	lui  a0, 0x20510   	    # form address 0x2051_0000: a0 arg for xous-kernel.bin
	lui  a2, 0x20500        # form address 0x2050_0000: location of xous-loader.bin (stage 1)
	jalr x0, a2, 0          # jump to xous-loader.bin
