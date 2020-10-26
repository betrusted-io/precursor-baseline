#!/usr/bin/env python3

# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.

LX_DEPENDENCIES = ["riscv", "vivado"]

# Import lxbuildenv to integrate the deps/ directory
import lxbuildenv
import litex.soc.doc as lxsocdoc
from pathlib import Path
import subprocess
import sys

from random import SystemRandom
import argparse

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer
from migen.genlib.cdc import MultiReg

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform, VivadoProgrammer

from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.cores.clock import S7MMCM, S7IDELAYCTRL
from litex.soc.cores.i2s import S7I2S
from litex.soc.cores.spi_opi import S7SPIOPI
from litex.soc.integration.soc import SoCRegion

from gateware import info
from gateware import sram_32
from gateware import memlcd
from gateware import spi_7series as spi
from gateware import messible
from gateware import i2c
from gateware import ticktimer

from gateware import spinor
from gateware import keyboard

# IOs ----------------------------------------------------------------------------------------------

_io_pvt = [   # PVT-generation I/Os
    ("clk12", 0, Pins("R3"), IOStandard("LVCMOS18")),

    ("analog", 0,
        Subsignal("usbdet_p",    Pins("C3"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("usbdet_n",    Pins("A3"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("vbus_div",    Pins("C4"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("noise0",      Pins("C5"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("noise1",      Pins("A8"), IOStandard("LVCMOS33")),  # DVT
        # diff grounds
        Subsignal("usbdet_p_n",  Pins("B3"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("usbdet_n_n",  Pins("A2"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("vbus_div_n",  Pins("B4"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("noise0_n",    Pins("B5"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("noise1_n",    Pins("A7"), IOStandard("LVCMOS33")),  # DVT
        # dedicated pins (no I/O standard applicable)
        Subsignal("ana_vn", Pins("K9")),
        Subsignal("ana_vp", Pins("J10")),
     ),

    ("jtag", 0,
         Subsignal("tck", Pins("U11"), IOStandard("LVCMOS18")),  # DVT
         Subsignal("tms", Pins("P6"), IOStandard("LVCMOS18")),   # DVT
         Subsignal("tdi", Pins("P7"), IOStandard("LVCMOS18")),   # DVT
         Subsignal("tdo", Pins("R6"), IOStandard("LVCMOS18")),   # DVT
    ),

    ("usb", 0,
         Subsignal("d_p", Pins("C1"), IOStandard("LVCMOS33"), Misc("DRIVE=4")),      # DVT
         Subsignal("d_n", Pins("B1"), IOStandard("LVCMOS33"), Misc("DRIVE=4")),      # DVT
         Subsignal("pullup_p", Pins("D1"), IOStandard("LVCMOS33"), Misc("DRIVE=4")),  # DVT
         Misc("SLEW=SLOW"),
     ),

    ("lpclk", 0, Pins("N15"), IOStandard("LVCMOS18")),  # wifi_lpclk

    # Power control signals
    ("power", 0,
        Subsignal("audio_on",     Pins("B7"),  IOStandard("LVCMOS33")),  # DVT
        Subsignal("fpga_sys_on",  Pins("A5"), IOStandard("LVCMOS33")),   # DVT
        Subsignal("noisebias_on", Pins("E17"), IOStandard("LVCMOS33")),  # DVT
        Subsignal("allow_up5k_n", Pins("B14"), IOStandard("LVCMOS33")),
        Subsignal("pwr_s0",       Pins("U6"), IOStandard("LVCMOS18")),
        Subsignal("pwr_s1",       Pins("L13"), IOStandard("LVCMOS18")),  # DVT
        # Noise generator
        Subsignal("noise_on",     Pins("P14 R13"), IOStandard("LVCMOS18")),
        # vibe motor
        Subsignal("vibe_on",      Pins("G13"), IOStandard("LVCMOS33")),  # PVT
        # reset EC
        Subsignal("reset_ec",   Pins("M6"), IOStandard("LVCMOS18")),   # PVT -- allow FPGA to recover crashed EC (invert polarity)
        # USB_CC DFP attach
        Subsignal("cc_id",        Pins("D18"), IOStandard("LVCMOS33")),  # DVT
        # turn on the UP5K in case we are woken up by RTC
        Subsignal("up5k_on",      Pins("G18"), IOStandard("LVCMOS33")),  # DVT -- T_TO_U_ON
        Subsignal("boostmode",    Pins("H16"), IOStandard("LVCMOS33")),  # PVT - for sourcing power in USB host mode
        Subsignal("selfdestruct", Pins("J14"), IOStandard("LVCMOS33")),  # PVT - cut power to BBRAM key and unit in an annoying-to-reset fashion
        Misc("SLEW=SLOW"),
        Misc("DRIVE=4"),
    ),

    # Audio interface
    ("i2s", 0,
       Subsignal("clk", Pins("D12")),
       Subsignal("tx", Pins("E13")), # au_sdi1
       Subsignal("rx", Pins("C13")), # au_sdo1
       Subsignal("sync", Pins("D14")),
       IOStandard("LVCMOS33"),
       Misc("SLEW=SLOW"), Misc("DRIVE=4"),
     ),
    ("au_mclk", 0, Pins("E12"), IOStandard("LVCMOS33"), Misc("SLEW=SLOW"), Misc("DRIVE=8")),

    # I2C1 bus -- to RTC and audio CODEC
    ("i2c", 0,
        Subsignal("scl", Pins("G2"), IOStandard("LVCMOS33")), # DVT
        Subsignal("sda", Pins("F2"), IOStandard("LVCMOS33")), # DVT
        Misc("SLEW=SLOW"), Misc("DRIVE=4"),
    ),

    # RTC interrupt
    ("rtc_irq", 0, Pins("N5"), IOStandard("LVCMOS18")),

    # COM interface to UP5K
    ("com", 0,
        Subsignal("csn",  Pins("T15"), IOStandard("LVCMOS18"), Misc("SLEW=SLOW"), Misc("DRIVE=4")),
        Subsignal("cipo", Pins("P16"), IOStandard("LVCMOS18")),
        Subsignal("copi", Pins("N18"), IOStandard("LVCMOS18"), Misc("SLEW=SLOW"), Misc("DRIVE=4")),
        Subsignal("sclk", Pins("R16"), IOStandard("LVCMOS18"), Misc("SLEW=SLOW"), Misc("DRIVE=4")),
     ),
    ("com_irq", 0, Pins("M16"), IOStandard("LVCMOS18")),

    # Top-side internal FPC header
    # Add USB PU/PD config to the GPIO cluster, see comment
    ("gpio", 0, Pins("F14 F15 E16 G15 H15 G16 F18 E18"), IOStandard("LVCMOS33"), Misc("SLEW=SLOW")), # PVT
    #("usb_alt", 0,
    # Subsignal("pulldn_p", Pins("C2"), IOStandard("LVCMOS33")),  # DVT
    # Subsignal("pullup_n", Pins("B2"), IOStandard("LVCMOS33")),  # DVT
    # Subsignal("pulldn_n", Pins("A4"), IOStandard("LVCMOS33")),  # DVT
    # Misc("DRIVE=4"), Misc("SLEW=SLOW"),
    # ),

    # Keyboard scan matrix
    ("kbd", 0,
        # "key" 0-8 are rows, 9-18 are columns
        # column scan with 1's, so PD to default 0
        Subsignal("row", Pins("A15 A17 A16 A14 C17 B16 B17 C14 B15"), Misc("PULLDOWN True")), # DVT
        Subsignal("col", Pins("B13 C18 E14 D15 B18 D16 D17 F13 E15 A13")),                    # DVT
        IOStandard("LVCMOS33"),
        Misc("SLEW=SLOW"),
        Misc("DRIVE=4"),
     ),

    # LCD interface
    ("lcd", 0,
        Subsignal("sclk", Pins("H17")), # DVT
        Subsignal("scs",  Pins("G17")), # DVT
        Subsignal("si",   Pins("H18")), # DVT
        IOStandard("LVCMOS33"),
        Misc("SLEW=SLOW"),
        Misc("DRIVE=4"),
     ),

    # SPI Flash
    ("spiflash_1x", 0, # clock needs to be accessed through STARTUPE2
        Subsignal("cs_n", Pins("M13")),
        Subsignal("copi", Pins("K17")),
        Subsignal("cipo", Pins("K18")),
        Subsignal("wp",   Pins("L14")), # provisional
        Subsignal("hold", Pins("M15")), # provisional
        IOStandard("LVCMOS18")
    ),
    ("spiflash_8x", 0, # clock needs a separate override to meet timing
        Subsignal("cs_n", Pins("M13")),
        Subsignal("dq",   Pins("K17 K18 L14 M15 L17 L18 M14 N14")),
        Subsignal("dqs",  Pins("R14")),
        Subsignal("ecs_n", Pins("L16")),
        Subsignal("sclk", Pins("C12")),  # DVT
        IOStandard("LVCMOS18"),
        Misc("SLEW=SLOW"),
     ),

    # SRAM
    ("sram", 0,
        Subsignal("adr", Pins(
            "V12 M5 P5 N4  V14 M3 R17 U15",
            "M4  L6 K3 R18 U16 K1 R5  T2",
            "U1  N1 L5 K2  M18 T6"),
            IOStandard("LVCMOS18")),
        Subsignal("ce_n", Pins("V5"),  IOStandard("LVCMOS18"), Misc("PULLUP True")),
        Subsignal("oe_n", Pins("U12"), IOStandard("LVCMOS18"), Misc("PULLUP True")),
        Subsignal("we_n", Pins("K4"),  IOStandard("LVCMOS18"), Misc("PULLUP True")),
        Subsignal("zz_n", Pins("V17"), IOStandard("LVCMOS18"), Misc("PULLUP True")),
        Subsignal("d", Pins(
            "M2  R4  P2  L4  L1  M1  R1  P1",
            "U3  V2  V4  U2  N2  T1  K6  J6",
            "V16 V15 U17 U18 P17 T18 P18 M17",
            "N3  T4  V13 P15 T14 R15 T3  R7"),
            IOStandard("LVCMOS18")),
        Subsignal("dm_n", Pins("V3 R2 T5 T13"), IOStandard("LVCMOS18")),
    ),
]

# use this config to wire the debug bridge UART to the Rpi
_io_uart_debug = [
    ("debug", 0,  # wired to the Rpi
        Subsignal("tx", Pins("V6")),
        Subsignal("rx", Pins("V7")),
        IOStandard("LVCMOS18"),
        Misc("SLEW=SLOW"),
    ),

    ("serial", 0, # wired to the internal flex
        Subsignal("tx", Pins("B18")), # debug0 breakout
        Subsignal("rx", Pins("D15")), # debug1
        IOStandard("LVCMOS33"),
        Misc("SLEW=SLOW"),
     ),
]

# use this config to wire the console UART to the Rpi, and debug bridge to GPIOs
_io_uart_debug_swapped = [
    ("serial", 0, # wired to the RPi
     Subsignal("tx", Pins("V6")),
     Subsignal("rx", Pins("V7")),
     IOStandard("LVCMOS18"),
     ),

    ("debug", 0, # wired to the internal flex
     Subsignal("tx", Pins("B18")), # debug0 breakout
     Subsignal("rx", Pins("D15")), # debug1
     IOStandard("LVCMOS33"),
     ),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(XilinxPlatform):
    def __init__(self, io, toolchain="vivado", programmer="vivado", part="50", encrypt=False, make_mod=False, bbram=False):
        part = "xc7s" + part + "-csga324-1il"
        XilinxPlatform.__init__(self, part, io, toolchain=toolchain)

        # NOTE: to do quad-SPI mode, the QE bit has to be set in the SPINOR status register. OpenOCD
        # won't do this natively, have to find a work-around (like using iMPACT to set it once)
        self.add_platform_command(
            "set_property CONFIG_VOLTAGE 1.8 [current_design]")
        self.add_platform_command(
            "set_property CFGBVS VCCO [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]")
        self.toolchain.bitstream_commands = [
            "set_property CONFIG_VOLTAGE 1.8 [current_design]",
            "set_property CFGBVS GND [current_design]",
            "set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]",
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]",
        ]
        if encrypt:
            type = 'eFUSE'
            if bbram:
                type = 'BBRAM'
            self.toolchain.bitstream_commands += [
                "set_property BITSTREAM.ENCRYPTION.ENCRYPT YES [current_design]",
                "set_property BITSTREAM.ENCRYPTION.ENCRYPTKEYSELECT {} [current_design]".format(type),
                "set_property BITSTREAM.ENCRYPTION.KEYFILE ../../dummy.nky [current_design]"
            ]

        self.toolchain.additional_commands += \
            ["write_cfgmem -verbose -force -format bin -interface spix1 -size 64 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.programmer = programmer

        self.toolchain.additional_commands += [
            "report_timing -delay_type min_max -max_paths 10 -slack_less_than 0 -sort_by group -input_pins -routable_nets -name failures -file timing-failures.txt"
        ]

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)

# CRG ----------------------------------------------------------------------------------------------

class CRG(Module, AutoCSR):
    def __init__(self, platform, sys_clk_freq, spinor_edge_delay_ns=2.5):
        self.warm_reset = Signal()

        self.clock_domains.cd_sys   = ClockDomain()
        self.clock_domains.cd_spi   = ClockDomain()
        self.clock_domains.cd_lpclk = ClockDomain()
        self.clock_domains.cd_spinor = ClockDomain()
        self.clock_domains.cd_clk200 = ClockDomain()
        self.clock_domains.cd_clk50 = ClockDomain()
        self.clock_domains.cd_usb_48 = ClockDomain()
        self.clock_domains.cd_usb_12 = ClockDomain()

        # # #

        sysclk_ns = 1e9 / sys_clk_freq
        # convert delay request in ns to degrees, where 360 degrees is one whole clock period
        phase_f = (spinor_edge_delay_ns / sysclk_ns) * 360
        # round phase to the nearest multiple of 7.5 (needs to be a multiple of 45 / CLKOUT2_DIVIDE = 45 / 6 = 7.5
        # note that CLKOUT2_DIVIDE is automatically calculated by mmcm.create_clkout() below
        phase = round(phase_f / 7.5) * 7.5

        clk32khz = platform.request("lpclk")
        self.specials += Instance("BUFG", i_I=clk32khz, o_O=self.cd_lpclk.clk)
        platform.add_platform_command("create_clock -name lpclk -period {:0.3f} [get_nets lpclk]".format(1e9 / 32.768e3))

        clk12 = platform.request("clk12")
        # Note: below feature cannot be used because Litex appends this *after* platform commands! This causes the generated
        # clock derived constraints immediately below to fail, because .xdc file is parsed in-order, and the main clock needs
        # to be created before the derived clocks. Instead, we use the line afterwards.
        # platform.add_period_constraint(clk12, 1e9 / 12e6)
        platform.add_platform_command("create_clock -name clk12 -period {:0.3f} [get_nets clk12]".format(1e9 / 12e6))
        # The above constraint must strictly proceed the below create_generated_clock constraints in the .XDC file

        # This allows PLLs/MMCMEs to be placed anywhere and reference the input clock
        self.clk12_bufg = Signal()
        self.specials += Instance("BUFG", i_I=clk12, o_O=self.clk12_bufg)

        self.submodules.mmcm = mmcm = S7MMCM(speedgrade=-1)
        self.comb += mmcm.reset.eq(self.warm_reset)
        mmcm.register_clkin(self.clk12_bufg, 12e6)
        # we count on clocks being assigned to the MMCME2_ADV in order. If we make more MMCME2 or shift ordering, these constraints must change.
        mmcm.create_clkout(self.cd_usb_48, 48e6) # 48 MHz for USB
        platform.add_platform_command("create_generated_clock -name usb_48 [get_pins MMCME2_ADV/CLKOUT0]")
        mmcm.create_clkout(self.cd_spi, 20e6)
        platform.add_platform_command("create_generated_clock -name spi_clk [get_pins MMCME2_ADV/CLKOUT1]")
        mmcm.create_clkout(self.cd_spinor, sys_clk_freq, phase=phase)  # delayed version for SPINOR cclk (different from COM SPI above)
        platform.add_platform_command("create_generated_clock -name spinor [get_pins MMCME2_ADV/CLKOUT2]")
        mmcm.create_clkout(self.cd_clk200, 200e6) # 200MHz required for IDELAYCTL
        platform.add_platform_command("create_generated_clock -name clk200 [get_pins MMCME2_ADV/CLKOUT3]")
        mmcm.create_clkout(self.cd_clk50, 50e6) # 50MHz for SHA-block
        platform.add_platform_command("create_generated_clock -name clk50 [get_pins MMCME2_ADV/CLKOUT4]")
        mmcm.create_clkout(self.cd_usb_12, 12e6) # 12 MHz for USB
        platform.add_platform_command("create_generated_clock -name usb_12 [get_pins MMCME2_ADV/CLKOUT5]")
        mmcm.create_clkout(self.cd_sys, sys_clk_freq, margin=0) # should be precise solution by design
        platform.add_platform_command("create_generated_clock -name sys_clk [get_pins MMCME2_ADV/CLKOUT6]")
        mmcm.expose_drp()

        # Add an IDELAYCTRL primitive for the SpiOpi block
        self.submodules += S7IDELAYCTRL(self.cd_clk200, reset_cycles=32) # 155ns @ 200MHz, min 59.28ns

# WarmBoot -----------------------------------------------------------------------------------------

class WarmBoot(Module, AutoCSR):
    def __init__(self, parent, reset_vector=0):
        self.ctrl = CSRStorage(size=8)
        self.addr = CSRStorage(size=32, reset=reset_vector)
        self.do_reset = Signal()
        # "Reset Key" is 0xac (0b101011xx)
        self.comb += self.do_reset.eq((self.ctrl.storage & 0xfc) == 0xac)

# BtEvents -----------------------------------------------------------------------------------------

class BtEvents(Module, AutoCSR, AutoDoc):
    def __init__(self, com, rtc):
        self.submodules.ev = EventManager()
        self.ev.com_int    = EventSourcePulse()   # rising edge triggered
        self.ev.rtc_int    = EventSourceProcess() # falling edge triggered
        self.ev.finalize()

        com_int = Signal()
        rtc_int = Signal()
        self.specials += MultiReg(com, com_int)
        self.specials += MultiReg(rtc, rtc_int)
        self.comb += self.ev.com_int.trigger.eq(com_int)
        self.comb += self.ev.rtc_int.trigger.eq(rtc_int)

# BtPower ------------------------------------------------------------------------------------------

class BtPower(Module, AutoCSR, AutoDoc):
    def __init__(self, pads, revision='evt'):
        self.intro = ModuleDoc("""BtPower - power control pins
        """)

        self.power = CSRStorage(8, fields=[
            CSRField("audio",     size=1, description="Write `1` to power on the audio subsystem"),
            CSRField("self",      size=1, description="Writing `1` forces self power-on (overrides the EC's ability to power me down)", reset=1),
            CSRField("ec_snoop",  size=1, description="Writing `1` allows the insecure EC to snoop a couple keyboard pads for wakeup key sequence recognition"),
            CSRField("state",     size=2, description="Current SoC power state. 0x=off or not ready, 10=on and safe to shutdown, 11=on and not safe to shut down, resets to 01 to allow extSRAM access immediately during init", reset=1),
            CSRField("noisebias", size=1, description="Writing `1` enables the primary bias supply for the noise generator"),
            CSRField("noise",     size=2, description="Controls which of two noise channels are active; all combos valid. noisebias must be on first."),
            CSRField("reset_ec",  size=1, description="Writing a `1` forces EC into reset. Requires write of `0` to release reset."),
            CSRField("up5k_on",   size=1, description="Writing a `1` pulses the UP5K domain to turn on", pulse=True),
            CSRField("boostmode", size=1, description="Writing a `1` causes the USB port to source 5V. To be active only when playing the host role."),
            CSRField("selfdestruct", size=1, description="Set this bit to clear BBRAM AES key (if used) and cut power in an annoying-to-reset fashion")
        ])
        # future-proofing this: we might want to add e.g. PWM levels and so forth, so give it its own register
        self.vibe = CSRStorage(1, description="Vibration motor configuration register", fields=[
            CSRField("vibe", size=1, description="Turn on vibration motor"),
        ])
        self.comb += [
            pads.audio_on.eq(self.power.fields.audio),
            pads.fpga_sys_on.eq(self.power.fields.self),
            # This signal automatically enables snoop when SoC is powered down
            pads.allow_up5k_n.eq(~self.power.fields.ec_snoop),
            # Ensure SRAM isolation during reset (CE & ZZ = 1 by pull-ups)
            pads.pwr_s0.eq(self.power.fields.state[0] & ~ResetSignal()),
        ]
        if revision != 'modnoise':
            self.comb += pads.noise_on.eq(self.power.fields.noise),

        if revision == 'dvt' or revision == 'pvt':
            self.reset_ec = TSTriple(1)
            if revision == 'dvt':
                self.specials += self.reset_ec.get_tristate(pads.reset_ec_n)
                self.comb += self.reset_ec.o.eq(0)  # reset is an active low signal
            else:
                self.specials += self.reset_ec.get_tristate(pads.reset_ec)
                self.comb += self.reset_ec.o.eq(1)  # reset is an active high signal
            self.comb += [
                pads.pwr_s1.eq(self.power.fields.state[1]),
                pads.noisebias_on.eq(self.power.fields.noisebias),
                pads.vibe_on.eq(self.vibe.fields.vibe),

                self.reset_ec.oe.eq(self.power.fields.reset_ec),  # drive reset low only when reset_ec is asserted, otherwise, Hi-Z
            ]
            self.submodules.ev = EventManager()
            self.ev.usb_attach = EventSourcePulse(description="USB attach event")
            self.ev.finalize()
            usb_attach = Signal()
            usb_attach_r = Signal()
            self.specials += MultiReg(pads.cc_id, usb_attach)
            self.sync += [
                usb_attach_r.eq(usb_attach),
                self.ev.usb_attach.trigger.eq(~usb_attach & usb_attach_r),  # falling edge trigger
            ]
            up5k_on_pulse = 0.20  # pulse up5k for 200ms to turn it on and have it keep itself on
            up5k_on_count = Signal(26, reset=int(up5k_on_pulse * 100e6))
            self.sync += [
                If(up5k_on_count > 0,
                    pads.up5k_on.eq(1),
                ).Else(
                    pads.up5k_on.eq(0)
                ),
                If(self.power.fields.up5k_on,
                    up5k_on_count.eq(int(up5k_on_pulse * 100e6))
                ).Elif( up5k_on_count > 0,
                    up5k_on_count.eq(up5k_on_count - 1),
                ).Else(
                    up5k_on_count.eq(0)
                )
            ]
        if revision == 'pvt':
            self.comb += pads.boostmode.eq(self.power.fields.boostmode)
            self.comb += pads.selfdestruct.eq(self.power.fields.selfdestruct)


# BtGpio -------------------------------------------------------------------------------------------

class BtGpio(Module, AutoDoc, AutoCSR):
    def __init__(self, pads):
        self.intro = ModuleDoc("""BtGpio - GPIO interface for betrusted""")

        gpio_in  = Signal(pads.nbits)
        gpio_out = Signal(pads.nbits)
        gpio_oe  = Signal(pads.nbits)

        for g in range(0, pads.nbits):
            gpio_ts = TSTriple(1)
            self.specials += gpio_ts.get_tristate(pads[g])
            self.comb += [
                gpio_ts.oe.eq(gpio_oe[g]),
                gpio_ts.o.eq(gpio_out[g]),
                gpio_in[g].eq(gpio_ts.i),
            ]

        self.output = CSRStorage(pads.nbits, name="output", description="Values to appear on GPIO when respective `drive` bit is asserted")
        self.input  = CSRStatus(pads.nbits,  name="input",  description="Value measured on the respective GPIO pin")
        self.drive  = CSRStorage(pads.nbits, name="drive",  description="When a bit is set to `1`, the respective pad drives its value out")
        self.intena = CSRStatus(pads.nbits,  name="intena", description="Enable interrupts when a respective bit is set")
        self.intpol = CSRStatus(pads.nbits,  name="intpol", description="When a bit is `1`, falling-edges cause interrupts. Otherwise, rising edges cause interrupts.")

        self.uartsel = CSRStorage(2, name="uartsel", description="Used to select which UART is routed to physical pins, 00 = kernel debug, 01 = console, others undefined")

        self.specials += MultiReg(gpio_in, self.input.status)
        self.comb += [
            gpio_out.eq(self.output.storage),
            gpio_oe.eq(self.drive.storage),
        ]

        self.submodules.ev = EventManager()

        for i in range(0, pads.nbits):
            setattr(self.ev, "gpioint" + str(i), EventSourcePulse() ) # pulse => rising edge

        self.ev.finalize()

        for i in range(0, pads.nbits):
            # pull from input.status because it's after the MultiReg synchronizer
            self.comb += getattr(self.ev, "gpioint" + str(i)).trigger.eq(self.input.status[i] ^ self.intpol.status[i])
            # note that if you change the polarity on the interrupt it could trigger an interrupt

# System constants ---------------------------------------------------------------------------------

boot_offset    = 0x500000 # enough space to hold 2x FPGA bitstreams before the firmware start
bios_size      = 0x8000
SPI_FLASH_SIZE = 128 * 1024 * 1024
prefix = ""  # sometimes 'soc_', sometimes '' prefix Litex is attaching to net names
# changes randomly depending on how the build system feels (currently problems with Chisel doing weird things to net names when CPU core is regenerated)

# BetrustedSoC -------------------------------------------------------------------------------------

class BetrustedSoC(SoCCore):
    # I/O range: 0x80000000-0xfffffffff (not cacheable)
    SoCCore.mem_map = {
        "rom":             0x00000000,
        "sram":            0x10000000, # Should this be 0x0100_0000 ???
        "spiflash":        0x20000000,
        "sram_ext":        0x40000000,
        "memlcd":          0xb0000000,
        "audio":           0xe0000000,
        "vexriscv_debug":  0xefff0000,
        "csr":             0xf0000000,
    }

    def __init__(self, platform, revision, sys_clk_freq=int(100e6), legacy_spi=False,
                 xous=False, uart_name="crossover",
                 **kwargs):
        assert sys_clk_freq in [int(12e6), int(100e6)]
        global bios_size

        # CPU cluster
        ## For dev work, we're booting from SPI directly. However, for enhanced security
        ## we will eventually want to move to a bitstream-ROM based bootloader that does
        ## a signature verification of the external SPI code before running it. The theory is that
        ## a user will burn a random AES key into their FPGA and encrypt their bitstream to their
        ## unique AES key, creating a root of trust that offers a defense against trivial patch attacks.

        if xous == False:  # raw firmware boots from SPINOR directly; xous boots from default Litex internal ROM
            reset_address = self.mem_map["spiflash"]+boot_offset
            bios_size = 0
        else:
            reset_address = self.mem_map["rom"]

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, csr_data_width=32,
            integrated_rom_size  = bios_size,
            integrated_sram_size = 0x20000,
            ident                = "Precursor SoC " + revision,
            cpu_type             = "vexriscv",
            csr_paging           = 4096,  # increase paging to 1 page size
            csr_address_width    = 16,    # increase to accommodate larger page size
            with_uart            = False, # implemented manually to allow for UART mux
            uart_name            = uart_name,
            cpu_reset_address    = reset_address,
            **kwargs)

        # CPU --------------------------------------------------------------------------------------
        self.cpu.use_external_variant("deps/pythondata-cpu-vexriscv/pythondata_cpu_vexriscv/verilog/VexRiscv_BetrustedSoC_Debug.v")
        self.cpu.add_debug()
        self.submodules.reboot = WarmBoot(self, reset_address)
        self.add_csr("reboot")
        warm_reset = Signal()
        self.comb += warm_reset.eq(self.reboot.do_reset)
        self.cpu.cpu_params.update(i_externalResetVector=self.reboot.addr.storage)

        # Debug cluster ----------------------------------------------------------------------------
        # from litex.soc.cores.uart import UARTWishboneBridge
        # self.submodules.uart_bridge = UARTWishboneBridge(platform.request("debug"), sys_clk_freq, baudrate=115200)
        # self.add_wb_master(self.uart_bridge.wishbone)
        self.register_mem("vexriscv_debug", 0xefff0000, self.cpu.debug_bus, 0x100)

        # Clockgen cluster -------------------------------------------------------------------------
        self.submodules.crg = CRG(platform, sys_clk_freq, spinor_edge_delay_ns=2.5)
        self.add_csr("crg")
        self.comb += self.crg.warm_reset.eq(warm_reset)

        # GPIO module ------------------------------------------------------------------------------
        self.submodules.gpio = BtGpio(platform.request("gpio"))
        self.add_csr("gpio")
        self.add_interrupt("gpio")

        # UART mux ---------------------------------------------------------------------------------
        from litex.soc.cores import uart
        if uart_name == "crossover":
            self.submodules.uart = uart.UARTCrossover()
            self.csr.add("uart_phy", use_loc_if_exists=True)
            self.csr.add("uart", use_loc_if_exists=True)
            self.add_interrupt("uart", use_loc_if_exists=True)
        elif uart_name == "serial":
            uart_pins = platform.request("serial")
            serial_layout = [("tx", 1), ("rx", 1)]
            kernel_pads = Record(serial_layout)
            console_pads = Record(serial_layout)
            server0_pads = Record(serial_layout)
            server1_pads = Record(serial_layout)
            self.comb += [
                If(self.gpio.uartsel.storage == 0,
                    uart_pins.tx.eq(kernel_pads.tx),
                    kernel_pads.rx.eq(uart_pins.rx),
                ).Elif(self.gpio.uartsel.storage == 1,
                    uart_pins.tx.eq(console_pads.tx),
                    console_pads.rx.eq(uart_pins.rx),
                ).Elif(self.gpio.uartsel.storage == 2,
                    uart_pins.tx.eq(server0_pads.tx),
                    server0_pads.rx.eq(uart_pins.rx),
                ).Elif(self.gpio.uartsel.storage == 3,
                    uart_pins.tx.eq(server1_pads.tx),
                    server1_pads.rx.eq(uart_pins.rx),
                )
            ]
            self.submodules.uart_phy = uart.UARTPHY(
                pads=kernel_pads,
                clk_freq=sys_clk_freq,
                baudrate=115200)
            self.submodules.uart = ResetInserter()(uart.UART(self.uart_phy,
                tx_fifo_depth=16,
                rx_fifo_depth=16))

            self.add_csr("uart_phy")
            self.add_csr("uart")
            self.add_interrupt("uart")

            self.submodules.console_phy = uart.UARTPHY(
                pads=console_pads,
                clk_freq=sys_clk_freq,
                baudrate=115200)
            self.submodules.console = ResetInserter()(uart.UART(self.console_phy,
                tx_fifo_depth=16,
                rx_fifo_depth=16))

            self.add_csr("console_phy")
            self.add_csr("console")
            self.add_interrupt("console")

            self.submodules.server0_phy = uart.UARTPHY(
                pads=server0_pads,
                clk_freq=sys_clk_freq,
                baudrate=115200)
            self.submodules.server0 = ResetInserter()(uart.UART(self.server0_phy,
                tx_fifo_depth=16,
                rx_fifo_depth=16))

            self.add_csr("server0_phy")
            self.add_csr("server0")
            self.add_interrupt("server0")

            self.submodules.server1_phy = uart.UARTPHY(
                pads=server1_pads,
                clk_freq=sys_clk_freq,
                baudrate=115200)
            self.submodules.server1 = ResetInserter()(uart.UART(self.server1_phy,
                tx_fifo_depth=16,
                rx_fifo_depth=16))

            self.add_csr("server1_phy")
            self.add_csr("server1")
            self.add_interrupt("server1")


        # XADC analog interface---------------------------------------------------------------------

        from litex.soc.cores.xadc import analog_layout
        analog_pads = Record(analog_layout)
        analog = platform.request("analog")
        self.comb += [
            analog_pads.vp.eq(analog.ana_vp),
            analog_pads.vn.eq(analog.ana_vn),
        ]
        # use explicit dummies to tie the analog inputs, otherwise the name space during finalization changes
        # (e.g. FHDL adds 'betrustedsoc_' to the beginning of every netlist name to give a prefix to unnamed signals)
        # notet that the added prefix messes up the .XDC constraints
        dummy7 = Signal(7, reset=0)
        dummy4 = Signal(4, reset=0)
        dummy5 = Signal(5, reset=0)
        dummy1 = Signal(1, reset=0)
        dummy15 = Signal(15, reset=0)
        # DVT is solidly an xc7s50-only build
        self.comb += analog_pads.vauxp.eq(Cat(dummy4,          # 0,1,2,3
                                         analog.noise1,        # 4
                                         dummy1,               # 5
                                         analog.vbus_div,      # 6
                                         dummy5,               # 7,8,9,10,11
                                         analog.noise0,        # 12
                                         dummy1,               # 13
                                         analog.usbdet_p,      # 14
                                         analog.usbdet_n,      # 15
                                    )),
        self.comb += analog_pads.vauxn.eq(Cat(dummy4,          # 0,1,2,3
                                         analog.noise1_n,      # 4
                                         dummy1,               # 5
                                         analog.vbus_div_n,    # 6
                                         dummy5,               # 7,8,9,10,11
                                         analog.noise0_n,      # 12
                                         dummy1,               # 13
                                         analog.usbdet_p_n,    # 14
                                         analog.usbdet_n_n,    # 15
                                    )),

        self.submodules.info = info.Info(platform, self.__class__.__name__, analog_pads)
        self.add_csr("info")
        self.platform.add_platform_command('create_generated_clock -name dna_cnt -source [get_pins {net}_reg[0]/Q] -divide_by 2 [get_pins DNA_PORT/CLK]', net=self.info.dna.count)

        # reset ignore - we should not be relying on any _rst signals to clear state in a single cycle!
        self.platform.add_platform_command('set_false_path -through [get_nets *_rst]')
        self.platform.add_platform_command('set_false_path -through [get_nets *crg_reset]')

        # all multiregs are false paths by definition. Make it explicit.
        self.platform.add_platform_command('set_false_path -through [get_nets *xilinxmultiregimpl*_regs0]') # covers sys-to-other
        self.platform.add_platform_command('set_false_path -through [get_pins *xilinxmultiregimpl*_regs0_reg*/D]') # covers other-to-sys

        # External SRAM ----------------------------------------------------------------------------
        # Note that page_rd_timing=2 works, but is a slight overclock on RAM. Cache fill time goes from 436ns to 368ns for 8 words.
        self.submodules.sram_ext = sram_32.SRAM32(platform.request("sram"), rd_timing=7, wr_timing=6, page_rd_timing=6)  # this works with 2:nbits page length with Rust firmware...
        self.add_csr("sram_ext")
        self.register_mem("sram_ext", self.mem_map["sram_ext"], self.sram_ext.bus, size=0x1000000)
        # A bit of a bodge -- the path is actually async, so what we are doing is trying to constrain intra-channel skew by pushing them up against clock limits
        self.platform.add_platform_command("set_input_delay -clock [get_clocks sys_clk] -min -add_delay 4.0 [get_ports {{sram_d[*]}}]")
        self.platform.add_platform_command("set_input_delay -clock [get_clocks sys_clk] -max -add_delay 9.0 [get_ports {{sram_d[*]}}]")
        self.platform.add_platform_command("set_output_delay -clock [get_clocks sys_clk] -min -add_delay 0.0 [get_ports {{sram_adr[*] sram_d[*] sram_ce_n sram_oe_n sram_we_n sram_zz_n sram_dm_n[*]}}]")
        self.platform.add_platform_command("set_output_delay -clock [get_clocks sys_clk] -max -add_delay 3.0 [get_ports {{sram_adr[*] sram_d[*] sram_ce_n sram_oe_n sram_we_n sram_zz_n sram_dm_n[*]}}]")
        # ODDR falling edge ignore
        self.platform.add_platform_command("set_false_path -fall_from [get_clocks sys_clk] -through [get_ports {{sram_d[*] sram_adr[*] sram_ce_n sram_oe_n sram_we_n sram_zz_n sram_dm_n[*]}}]")
        self.platform.add_platform_command("set_false_path -fall_to [get_clocks sys_clk] -through [get_ports {{sram_d[*]}}]")
        self.platform.add_platform_command("set_false_path -fall_from [get_clocks sys_clk] -through [get_nets {net}]", net=self.sram_ext.load)
        self.platform.add_platform_command("set_false_path -fall_to [get_clocks sys_clk] -through [get_nets {net}]", net=self.sram_ext.load)
        self.platform.add_platform_command("set_false_path -rise_from [get_clocks sys_clk] -fall_to [get_clocks sys_clk]")  # sort of a big hammer but should be OK

        # relax OE driver constraint (it's OK if it is a bit late, and it's an async path from fabric to output so it will be late)
        self.platform.add_platform_command("set_multicycle_path 2 -setup -through [get_pins {net}_reg/Q]", net=self.sram_ext.sync_oe_n)
        self.platform.add_platform_command("set_multicycle_path 1 -hold -through [get_pins {net}_reg/Q]", net=self.sram_ext.sync_oe_n)

        # LCD interface ----------------------------------------------------------------------------
        self.submodules.memlcd = memlcd.MemLCD(platform.request("lcd"))
        self.add_csr("memlcd")
        self.register_mem("memlcd", self.mem_map["memlcd"], self.memlcd.bus, size=self.memlcd.fb_depth*4)

        # COM SPI interface ------------------------------------------------------------------------
        self.submodules.com = spi.SPIController(platform.request("com"))
        self.add_csr("com")
        # 20.83ns = 1/2 of 24MHz clock, we are doing falling-to-rising timing
        # up5k tsu = -0.5ns, th = 5.55ns, tpdmax = 10ns
        # in reality, we are measuring a Tpd from the UP5K of 17ns. Routed input delay is ~3.9ns, which means
        # the fastest clock period supported would be 23.9MHz - just shy of 24MHz, with no margin to spare.
        # slow down clock period of SPI to 20MHz, this gives us about a 4ns margin for setup for PVT variation
        self.platform.add_platform_command("set_input_delay -clock [get_clocks spi_clk] -min -add_delay 0.5 [get_ports {{com_cipo}}]") # could be as low as -0.5ns but why not
        self.platform.add_platform_command("set_input_delay -clock [get_clocks spi_clk] -max -add_delay 17.5 [get_ports {{com_cipo}}]")
        self.platform.add_platform_command("set_output_delay -clock [get_clocks spi_clk] -min -add_delay 6.0 [get_ports {{com_copi com_csn}}]")
        self.platform.add_platform_command("set_output_delay -clock [get_clocks spi_clk] -max -add_delay 16.0 [get_ports {{com_copi com_csn}}]")  # could be as large as 21ns but why not
        # cross domain clocking is handled with explicit software barrires, or with multiregs
        self.platform.add_false_path_constraints(self.crg.cd_sys.clk, self.crg.cd_spi.clk)
        self.platform.add_false_path_constraints(self.crg.cd_spi.clk, self.crg.cd_sys.clk)

        # I2C interface ----------------------------------------------------------------------------
        self.submodules.i2c = i2c.RTLI2C(platform, platform.request("i2c", 0))
        self.add_csr("i2c")
        self.add_interrupt("i2c")

        # Event generation for I2C and COM ---------------------------------------------------------
        self.submodules.btevents = BtEvents(platform.request("com_irq", 0), platform.request("rtc_irq", 0))
        self.add_csr("btevents")
        self.add_interrupt("btevents")

        # Messible for debug -----------------------------------------------------------------------
        self.submodules.messible = messible.Messible()
        self.add_csr("messible")

        # Tick timer -------------------------------------------------------------------------------
        self.submodules.ticktimer = ticktimer.TickTimer(1000, sys_clk_freq, bits=64)
        self.add_csr("ticktimer")

        # Power control pins -----------------------------------------------------------------------
        self.submodules.power = BtPower(platform.request("power"), revision)
        self.add_csr("power")

        # SPI flash controller ---------------------------------------------------------------------
        if legacy_spi:
            self.submodules.spinor = spinor.SPINOR(platform, platform.request("spiflash_1x"), size=SPI_FLASH_SIZE)
        else:
            sclk_instance_name="SCLK_ODDR"
            iddr_instance_name="SPI_IDDR"
            cipo_instance_name="CIPO_FDRE"
            spiread=False
            self.submodules.spinor = S7SPIOPI(platform.request("spiflash_8x"),
                    sclk_name=sclk_instance_name, iddr_name=iddr_instance_name, cipo_name=cipo_instance_name, spiread=spiread)
            # reminder to self: the {{ and }} overloading is because Python treats these as special in strings, so {{ -> { in actual constraint
            # NOTE: ECSn is deliberately not constrained -- it's more or less async (0-10ns delay on the signal, only meant to line up with "block" region

            # constrain DQS-to-DQ input DDR delays
            self.platform.add_platform_command("create_clock -name spidqs -period 10 [get_ports spiflash_8x_dqs]")
            self.platform.add_platform_command("set_input_delay -clock spidqs -max 0.6 [get_ports {{spiflash_8x_dq[*]}}]")
            self.platform.add_platform_command("set_input_delay -clock spidqs -min -0.6 [get_ports {{spiflash_8x_dq[*]}}]")
            self.platform.add_platform_command("set_input_delay -clock spidqs -max 0.6 [get_ports {{spiflash_8x_dq[*]}}] -clock_fall -add_delay")
            self.platform.add_platform_command("set_input_delay -clock spidqs -min -0.6 [get_ports {{spiflash_8x_dq[*]}}] -clock_fall -add_delay")

            # derive clock for SCLK - clock-forwarded from DDR see Xilinx answer 62488 use case #4
            self.platform.add_platform_command("create_generated_clock -name spiclk_out -multiply_by 1 -source [get_pins {}/Q] [get_ports spiflash_8x_sclk]".format(sclk_instance_name))
            # if using CCLK output and not DDR forwarded clock, these are the commands used to define the clock
            #self.platform.add_platform_command("create_generated_clock -name spiclk_out -source [get_pins STARTUPE2/USRCCLKO] -combinational [get_pins STARTUPE2/USRCCLKO]")
            #self.platform.add_platform_command("set_clock_latency -min 0.5 [get_clocks spiclk_out]")  # define the min/max delay of the STARTUPE2 buffer
            #self.platform.add_platform_command("set_clock_latency -max 7.5 [get_clocks spiclk_out]")

            # constrain CIPO SDR delay -- WARNING: -max is 'actually' 5.0ns, but design can't meet timing @ 5.0 tPD from SPIROM. There is some margin in the timing closure tho, so 4.5ns is probably going to work....
            self.platform.add_platform_command("set_input_delay -clock [get_clocks spiclk_out] -clock_fall -max 4.5 [get_ports spiflash_8x_dq[1]]")
            self.platform.add_platform_command("set_input_delay -clock [get_clocks spiclk_out] -clock_fall -min 1 [get_ports spiflash_8x_dq[1]]")
            # corresponding false path on CIPO DDR input when clocking SDR data
            self.platform.add_platform_command("set_false_path -from [get_clocks spiclk_out] -to [get_pin {}/D ]".format(iddr_instance_name + "1"))
            # corresponding false path on CIPO SDR input from DQS strobe, only if the cipo path is used
            if spiread:
                self.platform.add_platform_command("set_false_path -from [get_clocks spidqs] -to [get_pin {}/D ]".format(cipo_instance_name))

            # constrain CLK-to-DQ output DDR delays; copi uses the same rules
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -max 1 [get_ports {{spiflash_8x_dq[*]}}]")
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -min -1 [get_ports {{spiflash_8x_dq[*]}}]")
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -max 1 [get_ports {{spiflash_8x_dq[*]}}] -clock_fall -add_delay")
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -min -1 [get_ports {{spiflash_8x_dq[*]}}] -clock_fall -add_delay")
            # constrain CLK-to-CS output delay. NOTE: timings require one dummy cycle insertion between CS and SCLK (de)activations. Not possible to meet timing for DQ & single-cycle CS due to longer tS/tH reqs for CS
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -min -1 [get_ports spiflash_8x_cs_n]") # -3 in reality
            self.platform.add_platform_command("set_output_delay -clock [get_clocks spiclk_out] -max 1 [get_ports spiflash_8x_cs_n]")  # 4.5 in reality
            # unconstrain OE path - we have like 10+ dummy cycles to turn the bus on wr->rd, and 2+ cycles to turn on end of read
            self.platform.add_platform_command("set_false_path -through [ get_pins {net}_reg/Q ]", net=self.spinor.dq.oe)
            self.platform.add_platform_command("set_false_path -through [ get_pins {net}_reg/Q ]", net=self.spinor.dq_copi.oe)

        self.register_mem("spiflash", self.mem_map["spiflash"], self.spinor.bus, size=SPI_FLASH_SIZE)
        self.add_csr("spinor")

        # Keyboard module --------------------------------------------------------------------------
        self.submodules.keyboard = ClockDomainsRenamer(cd_remapping={"kbd":"lpclk"})(keyboard.KeyScan(platform.request("kbd")))
        self.add_csr("keyboard")
        self.add_interrupt("keyboard")

        # Audio interfaces -------------------------------------------------------------------------
        from litex.soc.cores.i2s import I2S_FORMAT
        if revision == 'pvt':
            self.submodules.audio = S7I2S(platform.request("i2s", 0), controller=False,
                frame_format=I2S_FORMAT.I2S_STANDARD)
        else:
            self.submodules.audio = S7I2S(platform.request("i2s", 0), controller=False)
        self.bus.add_slave("audio", self.audio.bus, SoCRegion(origin=self.mem_map["audio"], size=0x4, cached=False))
        self.add_csr("audio")
        self.add_interrupt("audio")

        self.comb += platform.request("au_mclk", 0).eq(self.crg.clk12_bufg)

        # USB FS block -----------------------------------------------------------------------------
        from valentyusb.usbcore import io as usbio
        from valentyusb.usbcore.cpu import dummyusb
        usb_pads = platform.request("usb")
        usb_iobuf = usbio.IoBuf(usb_pads.d_p, usb_pads.d_n, usb_pads.pullup_p)
        self.submodules.usb = dummyusb.DummyUsb(usb_iobuf, debug=True, burst=True, cdc=True, relax_timing=True, product="Precursor Baseline")
        self.add_wb_master(self.usb.debug_bridge.wishbone)
        self.platform.add_platform_command('set_false_path -rise_from [get_clocks usb_12] -rise_to [get_clocks sys_clk] -through [get_pins {net}_reg*/D]', net=self.usb.debug_bridge.write_fifo.dout)
        self.platform.add_platform_command('set_false_path -rise_from [get_clocks sys_clk] -rise_to [get_clocks usb_12] -through [get_pins {net}_reg*/D]', net=self.usb.debug_bridge.read_fifo.dout)

# Build --------------------------------------------------------------------------------------------

def main():
    global _io

    if os.environ['PYTHONHASHSEED'] != "1":
        print( "PYTHONHASHEED must be set to 1 for consistent validation results. Failing to set this results in non-deterministic compilation results")
        return 1

    parser = argparse.ArgumentParser(description="Build the Betrusted SoC")
    parser.add_argument(
        "-D", "--document-only", default=False, action="store_true", help="Build docs only"
    )
    parser.add_argument(
        "-e", "--encrypt", help="Format output for encryption using the specified dummy key. Image is re-encrypted at sealing time with a secure key.", type=str
    )
    parser.add_argument(
        "-x", "--xous", help="Build for the Xous runtime environment. Defaults to `fw` validation image.", default=False, action="store_true"
    )
    parser.add_argument(
        "-r", "--revision", choices=['pvt'], help="Build for a particular revision. Defaults to 'pvt'", default='pvt', type=str,
    )
    parser.add_argument(
        "-b", "--bbram", help="encrypt to bbram, not efuse. Defaults to efuse. Only meaningful in -e is also specified.", default=False, action="store_true"
    )
    parser.add_argument(
        "-p", "--physical-uart", help="Use physical UART. Disables console UART tunelling over wishbone-tool and uses physical pins instead.", default=False, action="store_true"
    )

    ##### extract user arguments
    args = parser.parse_args()
    compile_gateware = True
    compile_software = True

    if args.document_only:
        compile_gateware = False
        compile_software = False

    bbram = False
    if args.encrypt == None:
        encrypt = False
    else:
        encrypt = True
        if args.bbram:
            bbram = True

    if args.revision == 'pvt':
        io = _io_pvt
    else:
        print("Invalid hardware revision specified: {}; aborting.".format(args.revision))
        sys.exit(1)

    if args.physical_uart:
        uart_name="serial"
    else:
        uart_name="crossover"

    ##### setup platform
    platform = Platform(io, encrypt=encrypt, bbram=bbram)
    # _io_uart_debug wires debug bridge to Rpi; _io_uart_debug_swapped wires console to Rpi
    platform.add_extension(_io_uart_debug_swapped)

    ##### define the soc
    soc = BetrustedSoC(platform, args.revision, xous=args.xous, uart_name=uart_name)

    ##### setup the builder and run it
    builder = Builder(soc, output_dir="build", csr_csv="build/csr.csv", csr_svd="build/software/soc.svd", compile_software=compile_software, compile_gateware=compile_gateware)
    builder.software_packages = [
        ("bios", os.path.abspath(os.path.join(os.path.dirname(__file__), "loader")))
    ]
    vns = builder.build()

    ##### post-build routines
    soc.do_exit(vns)
    lxsocdoc.generate_docs(soc, "build/documentation", note_pulses=True, sphinx_extensions=['sphinx_math_dollar', 'sphinx.ext.mathjax'],
            sphinx_extra_config=r"""
mathjax_config = {
   'tex2jax': {
       'inlineMath': [ ["\\(","\\)"] ],
       'displayMath': [["\\[","\\]"] ],
   },
}""")

    # now re-encrypt the binary if needed
    if encrypt and not args.document_only:
        # check if we need to re-encrypt to a set key
        if Path(args.encrypt).is_file():
            print('Found {}, re-encrypting binary to the specified fuse settings.'.format(args.encrypt))
            enc = ['deps/encrypt-bitstream-python/encrypt-bitstream.py', '-fbuild/gateware/__main__.bin', '-idummy.nky', '-k' + args.encrypt, '-obuild/gateware/encrypted']
            subprocess.call(enc)
        else:
            print('Specified key file {} does not exist'.format(args.encrypt))
            return 1

    return 0

if __name__ == "__main__":
    from datetime import datetime
    start = datetime.now()
    ret = main()
    print("Run completed in {}".format(datetime.now()-start))

    sys.exit(ret)
