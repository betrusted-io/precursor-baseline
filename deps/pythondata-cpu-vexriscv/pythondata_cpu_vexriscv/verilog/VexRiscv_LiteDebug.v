// Generator : SpinalHDL v1.3.6    git head : 9bf01e7f360e003fac1dd5ca8b8f4bffec0e52b8
// Date      : 23/03/2020, 17:06:45
// Component : VexRiscv


`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define EnvCtrlEnum_defaultEncoding_type [1:0]
`define EnvCtrlEnum_defaultEncoding_NONE 2'b00
`define EnvCtrlEnum_defaultEncoding_XRET 2'b01
`define EnvCtrlEnum_defaultEncoding_ECALL 2'b10

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

module InstructionCache (
      input   io_flush,
      input   io_cpu_prefetch_isValid,
      output reg  io_cpu_prefetch_haltIt,
      input  [31:0] io_cpu_prefetch_pc,
      input   io_cpu_fetch_isValid,
      input   io_cpu_fetch_isStuck,
      input   io_cpu_fetch_isRemoved,
      input  [31:0] io_cpu_fetch_pc,
      output [31:0] io_cpu_fetch_data,
      input   io_cpu_fetch_dataBypassValid,
      input  [31:0] io_cpu_fetch_dataBypass,
      output  io_cpu_fetch_mmuBus_cmd_isValid,
      output [31:0] io_cpu_fetch_mmuBus_cmd_virtualAddress,
      output  io_cpu_fetch_mmuBus_cmd_bypassTranslation,
      input  [31:0] io_cpu_fetch_mmuBus_rsp_physicalAddress,
      input   io_cpu_fetch_mmuBus_rsp_isIoAccess,
      input   io_cpu_fetch_mmuBus_rsp_allowRead,
      input   io_cpu_fetch_mmuBus_rsp_allowWrite,
      input   io_cpu_fetch_mmuBus_rsp_allowExecute,
      input   io_cpu_fetch_mmuBus_rsp_exception,
      input   io_cpu_fetch_mmuBus_rsp_refilling,
      output  io_cpu_fetch_mmuBus_end,
      input   io_cpu_fetch_mmuBus_busy,
      output [31:0] io_cpu_fetch_physicalAddress,
      output  io_cpu_fetch_haltIt,
      input   io_cpu_decode_isValid,
      input   io_cpu_decode_isStuck,
      input  [31:0] io_cpu_decode_pc,
      output [31:0] io_cpu_decode_physicalAddress,
      output [31:0] io_cpu_decode_data,
      output  io_cpu_decode_cacheMiss,
      output  io_cpu_decode_error,
      output  io_cpu_decode_mmuRefilling,
      output  io_cpu_decode_mmuException,
      input   io_cpu_decode_isUser,
      input   io_cpu_fill_valid,
      input  [31:0] io_cpu_fill_payload,
      output  io_mem_cmd_valid,
      input   io_mem_cmd_ready,
      output [31:0] io_mem_cmd_payload_address,
      output [2:0] io_mem_cmd_payload_size,
      input   io_mem_rsp_valid,
      input  [31:0] io_mem_rsp_payload_data,
      input   io_mem_rsp_payload_error,
      input  [2:0] _zz_10_,
      input  [31:0] _zz_11_,
      input   clk,
      input   reset);
  reg [22:0] _zz_12_;
  reg [31:0] _zz_13_;
  wire  _zz_14_;
  wire  _zz_15_;
  wire [0:0] _zz_16_;
  wire [0:0] _zz_17_;
  wire [22:0] _zz_18_;
  reg  _zz_1_;
  reg  _zz_2_;
  reg  lineLoader_fire;
  reg  lineLoader_valid;
  reg [31:0] lineLoader_address;
  reg  lineLoader_hadError;
  reg  lineLoader_flushPending;
  reg [6:0] lineLoader_flushCounter;
  reg  _zz_3_;
  reg  lineLoader_cmdSent;
  reg  lineLoader_wayToAllocate_willIncrement;
  wire  lineLoader_wayToAllocate_willClear;
  wire  lineLoader_wayToAllocate_willOverflowIfInc;
  wire  lineLoader_wayToAllocate_willOverflow;
  reg [2:0] lineLoader_wordIndex;
  wire  lineLoader_write_tag_0_valid;
  wire [5:0] lineLoader_write_tag_0_payload_address;
  wire  lineLoader_write_tag_0_payload_data_valid;
  wire  lineLoader_write_tag_0_payload_data_error;
  wire [20:0] lineLoader_write_tag_0_payload_data_address;
  wire  lineLoader_write_data_0_valid;
  wire [8:0] lineLoader_write_data_0_payload_address;
  wire [31:0] lineLoader_write_data_0_payload_data;
  wire  _zz_4_;
  wire [5:0] _zz_5_;
  wire  _zz_6_;
  wire  fetchStage_read_waysValues_0_tag_valid;
  wire  fetchStage_read_waysValues_0_tag_error;
  wire [20:0] fetchStage_read_waysValues_0_tag_address;
  wire [22:0] _zz_7_;
  wire [8:0] _zz_8_;
  wire  _zz_9_;
  wire [31:0] fetchStage_read_waysValues_0_data;
  wire  fetchStage_hit_hits_0;
  wire  fetchStage_hit_valid;
  wire  fetchStage_hit_error;
  wire [31:0] fetchStage_hit_data;
  wire [31:0] fetchStage_hit_word;
  reg [31:0] io_cpu_fetch_data_regNextWhen;
  reg [31:0] decodeStage_mmuRsp_physicalAddress;
  reg  decodeStage_mmuRsp_isIoAccess;
  reg  decodeStage_mmuRsp_allowRead;
  reg  decodeStage_mmuRsp_allowWrite;
  reg  decodeStage_mmuRsp_allowExecute;
  reg  decodeStage_mmuRsp_exception;
  reg  decodeStage_mmuRsp_refilling;
  reg  decodeStage_hit_valid;
  reg  decodeStage_hit_error;
  (* ram_style = "block" *) reg [22:0] ways_0_tags [0:63];
  (* ram_style = "block" *) reg [31:0] ways_0_datas [0:511];
  assign _zz_14_ = (! lineLoader_flushCounter[6]);
  assign _zz_15_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_16_ = _zz_7_[0 : 0];
  assign _zz_17_ = _zz_7_[1 : 1];
  assign _zz_18_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_18_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_6_) begin
      _zz_12_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_9_) begin
      _zz_13_ <= ways_0_datas[_zz_8_];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2_ = 1'b1;
    end
  end

  assign io_cpu_fetch_haltIt = io_cpu_fetch_mmuBus_busy;
  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == (3'b111)))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_14_)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3_))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],(5'b00000)};
  assign io_mem_cmd_payload_size = (3'b101);
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign _zz_4_ = 1'b1;
  assign lineLoader_write_tag_0_valid = ((_zz_4_ && lineLoader_fire) || (! lineLoader_flushCounter[6]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[6] ? lineLoader_address[10 : 5] : lineLoader_flushCounter[5 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[6];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 11];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && _zz_4_);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[10 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_5_ = io_cpu_prefetch_pc[10 : 5];
  assign _zz_6_ = (! io_cpu_fetch_isStuck);
  assign _zz_7_ = _zz_12_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_16_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_17_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[22 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[10 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_13_;
  assign fetchStage_hit_hits_0 = (fetchStage_read_waysValues_0_tag_valid && (fetchStage_read_waysValues_0_tag_address == io_cpu_fetch_mmuBus_rsp_physicalAddress[31 : 11]));
  assign fetchStage_hit_valid = (fetchStage_hit_hits_0 != (1'b0));
  assign fetchStage_hit_error = fetchStage_read_waysValues_0_tag_error;
  assign fetchStage_hit_data = fetchStage_read_waysValues_0_data;
  assign fetchStage_hit_word = fetchStage_hit_data[31 : 0];
  assign io_cpu_fetch_data = (io_cpu_fetch_dataBypassValid ? io_cpu_fetch_dataBypass : fetchStage_hit_word);
  assign io_cpu_decode_data = io_cpu_fetch_data_regNextWhen;
  assign io_cpu_fetch_mmuBus_cmd_isValid = io_cpu_fetch_isValid;
  assign io_cpu_fetch_mmuBus_cmd_virtualAddress = io_cpu_fetch_pc;
  assign io_cpu_fetch_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_fetch_mmuBus_end = ((! io_cpu_fetch_isStuck) || io_cpu_fetch_isRemoved);
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuBus_rsp_physicalAddress;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = decodeStage_hit_error;
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = ((! decodeStage_mmuRsp_refilling) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge clk) begin
    if(reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= (3'b000);
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_15_)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + (3'b001));
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_14_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + (7'b0000001));
    end
    _zz_3_ <= lineLoader_flushCounter[6];
    if(_zz_15_)begin
      lineLoader_flushCounter <= (7'b0000000);
    end
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_data_regNextWhen <= io_cpu_fetch_data;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuBus_rsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuBus_rsp_isIoAccess;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuBus_rsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuBus_rsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuBus_rsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuBus_rsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuBus_rsp_refilling;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_valid <= fetchStage_hit_valid;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_error <= fetchStage_hit_error;
    end
    if((_zz_10_ != (3'b000)))begin
      io_cpu_fetch_data_regNextWhen <= _zz_11_;
    end
  end

endmodule

module VexRiscv (
      input  [31:0] externalResetVector,
      input   timerInterrupt,
      input   softwareInterrupt,
      input  [31:0] externalInterruptArray,
      input   debug_bus_cmd_valid,
      output reg  debug_bus_cmd_ready,
      input   debug_bus_cmd_payload_wr,
      input  [7:0] debug_bus_cmd_payload_address,
      input  [31:0] debug_bus_cmd_payload_data,
      output reg [31:0] debug_bus_rsp_data,
      output  debug_resetOut,
      output reg  iBusWishbone_CYC,
      output reg  iBusWishbone_STB,
      input   iBusWishbone_ACK,
      output  iBusWishbone_WE,
      output [29:0] iBusWishbone_ADR,
      input  [31:0] iBusWishbone_DAT_MISO,
      output [31:0] iBusWishbone_DAT_MOSI,
      output [3:0] iBusWishbone_SEL,
      input   iBusWishbone_ERR,
      output [1:0] iBusWishbone_BTE,
      output [2:0] iBusWishbone_CTI,
      output  dBusWishbone_CYC,
      output  dBusWishbone_STB,
      input   dBusWishbone_ACK,
      output  dBusWishbone_WE,
      output [29:0] dBusWishbone_ADR,
      input  [31:0] dBusWishbone_DAT_MISO,
      output [31:0] dBusWishbone_DAT_MOSI,
      output reg [3:0] dBusWishbone_SEL,
      input   dBusWishbone_ERR,
      output [1:0] dBusWishbone_BTE,
      output [2:0] dBusWishbone_CTI,
      input   clk,
      input   reset,
      input   debugReset);
  wire  _zz_209_;
  wire  _zz_210_;
  wire  _zz_211_;
  wire  _zz_212_;
  wire [31:0] _zz_213_;
  wire  _zz_214_;
  wire  _zz_215_;
  wire  _zz_216_;
  reg  _zz_217_;
  reg [31:0] _zz_218_;
  reg [31:0] _zz_219_;
  reg [31:0] _zz_220_;
  wire  IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_haltIt;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  wire  IBusCachedPlugin_cache_io_cpu_decode_error;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_data;
  wire  IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire  IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire [31:0] IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire [2:0] IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire  _zz_221_;
  wire  _zz_222_;
  wire  _zz_223_;
  wire  _zz_224_;
  wire  _zz_225_;
  wire  _zz_226_;
  wire  _zz_227_;
  wire  _zz_228_;
  wire  _zz_229_;
  wire  _zz_230_;
  wire  _zz_231_;
  wire  _zz_232_;
  wire  _zz_233_;
  wire  _zz_234_;
  wire  _zz_235_;
  wire  _zz_236_;
  wire  _zz_237_;
  wire  _zz_238_;
  wire  _zz_239_;
  wire  _zz_240_;
  wire  _zz_241_;
  wire  _zz_242_;
  wire [1:0] _zz_243_;
  wire  _zz_244_;
  wire  _zz_245_;
  wire  _zz_246_;
  wire  _zz_247_;
  wire  _zz_248_;
  wire  _zz_249_;
  wire  _zz_250_;
  wire  _zz_251_;
  wire  _zz_252_;
  wire  _zz_253_;
  wire  _zz_254_;
  wire [5:0] _zz_255_;
  wire  _zz_256_;
  wire  _zz_257_;
  wire  _zz_258_;
  wire  _zz_259_;
  wire  _zz_260_;
  wire  _zz_261_;
  wire [1:0] _zz_262_;
  wire  _zz_263_;
  wire [4:0] _zz_264_;
  wire [2:0] _zz_265_;
  wire [31:0] _zz_266_;
  wire [11:0] _zz_267_;
  wire [31:0] _zz_268_;
  wire [19:0] _zz_269_;
  wire [11:0] _zz_270_;
  wire [31:0] _zz_271_;
  wire [31:0] _zz_272_;
  wire [19:0] _zz_273_;
  wire [11:0] _zz_274_;
  wire [2:0] _zz_275_;
  wire [0:0] _zz_276_;
  wire [0:0] _zz_277_;
  wire [0:0] _zz_278_;
  wire [0:0] _zz_279_;
  wire [0:0] _zz_280_;
  wire [0:0] _zz_281_;
  wire [0:0] _zz_282_;
  wire [0:0] _zz_283_;
  wire [0:0] _zz_284_;
  wire [0:0] _zz_285_;
  wire [0:0] _zz_286_;
  wire [0:0] _zz_287_;
  wire [0:0] _zz_288_;
  wire [0:0] _zz_289_;
  wire [0:0] _zz_290_;
  wire [0:0] _zz_291_;
  wire [0:0] _zz_292_;
  wire [0:0] _zz_293_;
  wire [2:0] _zz_294_;
  wire [4:0] _zz_295_;
  wire [11:0] _zz_296_;
  wire [11:0] _zz_297_;
  wire [31:0] _zz_298_;
  wire [31:0] _zz_299_;
  wire [31:0] _zz_300_;
  wire [31:0] _zz_301_;
  wire [31:0] _zz_302_;
  wire [31:0] _zz_303_;
  wire [31:0] _zz_304_;
  wire [31:0] _zz_305_;
  wire [32:0] _zz_306_;
  wire [11:0] _zz_307_;
  wire [19:0] _zz_308_;
  wire [11:0] _zz_309_;
  wire [31:0] _zz_310_;
  wire [31:0] _zz_311_;
  wire [31:0] _zz_312_;
  wire [11:0] _zz_313_;
  wire [19:0] _zz_314_;
  wire [11:0] _zz_315_;
  wire [2:0] _zz_316_;
  wire [1:0] _zz_317_;
  wire [1:0] _zz_318_;
  wire [1:0] _zz_319_;
  wire [1:0] _zz_320_;
  wire [0:0] _zz_321_;
  wire [5:0] _zz_322_;
  wire [33:0] _zz_323_;
  wire [32:0] _zz_324_;
  wire [33:0] _zz_325_;
  wire [32:0] _zz_326_;
  wire [33:0] _zz_327_;
  wire [32:0] _zz_328_;
  wire [0:0] _zz_329_;
  wire [5:0] _zz_330_;
  wire [32:0] _zz_331_;
  wire [32:0] _zz_332_;
  wire [31:0] _zz_333_;
  wire [31:0] _zz_334_;
  wire [32:0] _zz_335_;
  wire [32:0] _zz_336_;
  wire [32:0] _zz_337_;
  wire [0:0] _zz_338_;
  wire [32:0] _zz_339_;
  wire [0:0] _zz_340_;
  wire [32:0] _zz_341_;
  wire [0:0] _zz_342_;
  wire [31:0] _zz_343_;
  wire [0:0] _zz_344_;
  wire [0:0] _zz_345_;
  wire [0:0] _zz_346_;
  wire [0:0] _zz_347_;
  wire [0:0] _zz_348_;
  wire [0:0] _zz_349_;
  wire [26:0] _zz_350_;
  wire [6:0] _zz_351_;
  wire  _zz_352_;
  wire  _zz_353_;
  wire [2:0] _zz_354_;
  wire  _zz_355_;
  wire  _zz_356_;
  wire  _zz_357_;
  wire [31:0] _zz_358_;
  wire [31:0] _zz_359_;
  wire [31:0] _zz_360_;
  wire  _zz_361_;
  wire [3:0] _zz_362_;
  wire [3:0] _zz_363_;
  wire  _zz_364_;
  wire [0:0] _zz_365_;
  wire [25:0] _zz_366_;
  wire [31:0] _zz_367_;
  wire [31:0] _zz_368_;
  wire  _zz_369_;
  wire [0:0] _zz_370_;
  wire [0:0] _zz_371_;
  wire  _zz_372_;
  wire  _zz_373_;
  wire [0:0] _zz_374_;
  wire [0:0] _zz_375_;
  wire [2:0] _zz_376_;
  wire [2:0] _zz_377_;
  wire  _zz_378_;
  wire [0:0] _zz_379_;
  wire [22:0] _zz_380_;
  wire [31:0] _zz_381_;
  wire [31:0] _zz_382_;
  wire [31:0] _zz_383_;
  wire [31:0] _zz_384_;
  wire [31:0] _zz_385_;
  wire [31:0] _zz_386_;
  wire [31:0] _zz_387_;
  wire [31:0] _zz_388_;
  wire [31:0] _zz_389_;
  wire [31:0] _zz_390_;
  wire [31:0] _zz_391_;
  wire  _zz_392_;
  wire [0:0] _zz_393_;
  wire [0:0] _zz_394_;
  wire [0:0] _zz_395_;
  wire [4:0] _zz_396_;
  wire [0:0] _zz_397_;
  wire [0:0] _zz_398_;
  wire  _zz_399_;
  wire [0:0] _zz_400_;
  wire [20:0] _zz_401_;
  wire [31:0] _zz_402_;
  wire [31:0] _zz_403_;
  wire [31:0] _zz_404_;
  wire [31:0] _zz_405_;
  wire [31:0] _zz_406_;
  wire  _zz_407_;
  wire [0:0] _zz_408_;
  wire [2:0] _zz_409_;
  wire [31:0] _zz_410_;
  wire [31:0] _zz_411_;
  wire  _zz_412_;
  wire [2:0] _zz_413_;
  wire [2:0] _zz_414_;
  wire  _zz_415_;
  wire [0:0] _zz_416_;
  wire [18:0] _zz_417_;
  wire [31:0] _zz_418_;
  wire [31:0] _zz_419_;
  wire [31:0] _zz_420_;
  wire  _zz_421_;
  wire [0:0] _zz_422_;
  wire [0:0] _zz_423_;
  wire [31:0] _zz_424_;
  wire  _zz_425_;
  wire [0:0] _zz_426_;
  wire [0:0] _zz_427_;
  wire [0:0] _zz_428_;
  wire [1:0] _zz_429_;
  wire [0:0] _zz_430_;
  wire [0:0] _zz_431_;
  wire  _zz_432_;
  wire [0:0] _zz_433_;
  wire [16:0] _zz_434_;
  wire [31:0] _zz_435_;
  wire [31:0] _zz_436_;
  wire [31:0] _zz_437_;
  wire [31:0] _zz_438_;
  wire [31:0] _zz_439_;
  wire [31:0] _zz_440_;
  wire [31:0] _zz_441_;
  wire [31:0] _zz_442_;
  wire [31:0] _zz_443_;
  wire [31:0] _zz_444_;
  wire  _zz_445_;
  wire  _zz_446_;
  wire [31:0] _zz_447_;
  wire [31:0] _zz_448_;
  wire [0:0] _zz_449_;
  wire [0:0] _zz_450_;
  wire  _zz_451_;
  wire [0:0] _zz_452_;
  wire [14:0] _zz_453_;
  wire [31:0] _zz_454_;
  wire [0:0] _zz_455_;
  wire [0:0] _zz_456_;
  wire [0:0] _zz_457_;
  wire [1:0] _zz_458_;
  wire [1:0] _zz_459_;
  wire [1:0] _zz_460_;
  wire  _zz_461_;
  wire [0:0] _zz_462_;
  wire [11:0] _zz_463_;
  wire [31:0] _zz_464_;
  wire [31:0] _zz_465_;
  wire [31:0] _zz_466_;
  wire [31:0] _zz_467_;
  wire [31:0] _zz_468_;
  wire [31:0] _zz_469_;
  wire [31:0] _zz_470_;
  wire [31:0] _zz_471_;
  wire [31:0] _zz_472_;
  wire [31:0] _zz_473_;
  wire [31:0] _zz_474_;
  wire [0:0] _zz_475_;
  wire [0:0] _zz_476_;
  wire [1:0] _zz_477_;
  wire [1:0] _zz_478_;
  wire  _zz_479_;
  wire [0:0] _zz_480_;
  wire [8:0] _zz_481_;
  wire [31:0] _zz_482_;
  wire [31:0] _zz_483_;
  wire [31:0] _zz_484_;
  wire  _zz_485_;
  wire [0:0] _zz_486_;
  wire [0:0] _zz_487_;
  wire  _zz_488_;
  wire [0:0] _zz_489_;
  wire [0:0] _zz_490_;
  wire  _zz_491_;
  wire [0:0] _zz_492_;
  wire [5:0] _zz_493_;
  wire [31:0] _zz_494_;
  wire [31:0] _zz_495_;
  wire [31:0] _zz_496_;
  wire  _zz_497_;
  wire  _zz_498_;
  wire  _zz_499_;
  wire [1:0] _zz_500_;
  wire [1:0] _zz_501_;
  wire  _zz_502_;
  wire [0:0] _zz_503_;
  wire [2:0] _zz_504_;
  wire [31:0] _zz_505_;
  wire [31:0] _zz_506_;
  wire  _zz_507_;
  wire [0:0] _zz_508_;
  wire [0:0] _zz_509_;
  wire [1:0] _zz_510_;
  wire [1:0] _zz_511_;
  wire  _zz_512_;
  wire  _zz_513_;
  wire [31:0] _zz_514_;
  wire [31:0] _zz_515_;
  wire [31:0] _zz_516_;
  wire  _zz_517_;
  wire [0:0] _zz_518_;
  wire [12:0] _zz_519_;
  wire [31:0] _zz_520_;
  wire [31:0] _zz_521_;
  wire [31:0] _zz_522_;
  wire  _zz_523_;
  wire [0:0] _zz_524_;
  wire [6:0] _zz_525_;
  wire [31:0] _zz_526_;
  wire [31:0] _zz_527_;
  wire [31:0] _zz_528_;
  wire  _zz_529_;
  wire [0:0] _zz_530_;
  wire [0:0] _zz_531_;
  wire  _zz_532_;
  wire  _zz_533_;
  wire  _zz_534_;
  wire  decode_CSR_WRITE_OPCODE;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire  decode_IS_CSR;
  wire  decode_DO_EBREAK;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_1_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_2_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_3_;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_4_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_5_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_6_;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire  decode_SRC_LESS_UNSIGNED;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_7_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_8_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_9_;
  wire  decode_IS_DIV;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_10_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_11_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_12_;
  wire  decode_SRC2_FORCE_ZERO;
  wire [31:0] execute_BRANCH_CALC;
  wire  decode_MEMORY_STORE;
  wire [31:0] memory_MEMORY_READ_DATA;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_13_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_14_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_15_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_16_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_17_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_18_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_19_;
  wire  decode_CSR_READ_OPCODE;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_20_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_21_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_22_;
  wire  decode_IS_RS2_SIGNED;
  wire  execute_BRANCH_DO;
  wire  decode_IS_MUL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_23_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_24_;
  wire  decode_IS_RS1_SIGNED;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire  decode_PREDICTION_HAD_BRANCHED2;
  wire  execute_DO_EBREAK;
  wire  decode_IS_EBREAK;
  wire  _zz_25_;
  wire  execute_IS_RS1_SIGNED;
  wire  execute_IS_DIV;
  wire  execute_IS_MUL;
  wire  execute_IS_RS2_SIGNED;
  wire  memory_IS_DIV;
  wire  memory_IS_MUL;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_26_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_27_;
  wire  _zz_28_;
  wire  _zz_29_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_30_;
  wire [31:0] memory_BRANCH_CALC;
  wire  memory_BRANCH_DO;
  wire [31:0] _zz_31_;
  wire [31:0] execute_PC;
  wire  execute_PREDICTION_HAD_BRANCHED2;
  wire  _zz_32_;
  wire [31:0] execute_RS1;
  wire  execute_BRANCH_COND_RESULT;
  wire `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_33_;
  wire  _zz_34_;
  wire  _zz_35_;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  reg [31:0] _zz_36_;
  wire  memory_REGFILE_WRITE_VALID;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  reg [31:0] decode_RS2;
  reg [31:0] decode_RS1;
  reg [31:0] _zz_37_;
  wire `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_38_;
  wire  _zz_39_;
  wire [31:0] _zz_40_;
  wire [31:0] _zz_41_;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC2_FORCE_ZERO;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_42_;
  wire `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_43_;
  wire [31:0] _zz_44_;
  wire `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_45_;
  wire [31:0] _zz_46_;
  wire  decode_SRC_USE_SUB_LESS;
  wire  decode_SRC_ADD_ZERO;
  wire  _zz_47_;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_48_;
  wire [31:0] _zz_49_;
  wire [31:0] execute_SRC2;
  wire [31:0] execute_SRC1;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_50_;
  wire [31:0] _zz_51_;
  wire  _zz_52_;
  reg  _zz_53_;
  wire [31:0] _zz_54_;
  wire [31:0] _zz_55_;
  wire [31:0] decode_INSTRUCTION_ANTICIPATED;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire  _zz_56_;
  wire  _zz_57_;
  wire  _zz_58_;
  wire  _zz_59_;
  wire  _zz_60_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_61_;
  wire  _zz_62_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_63_;
  wire  _zz_64_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_65_;
  wire  _zz_66_;
  wire  _zz_67_;
  wire  _zz_68_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_69_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_70_;
  wire  _zz_71_;
  wire  _zz_72_;
  wire  _zz_73_;
  wire  _zz_74_;
  wire  _zz_75_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_76_;
  wire  _zz_77_;
  wire  _zz_78_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_79_;
  wire  _zz_80_;
  wire  writeBack_MEMORY_STORE;
  reg [31:0] _zz_81_;
  wire  writeBack_MEMORY_ENABLE;
  wire [1:0] writeBack_MEMORY_ADDRESS_LOW;
  wire [31:0] writeBack_MEMORY_READ_DATA;
  wire  memory_MMU_FAULT;
  wire [31:0] memory_MMU_RSP_physicalAddress;
  wire  memory_MMU_RSP_isIoAccess;
  wire  memory_MMU_RSP_allowRead;
  wire  memory_MMU_RSP_allowWrite;
  wire  memory_MMU_RSP_allowExecute;
  wire  memory_MMU_RSP_exception;
  wire  memory_MMU_RSP_refilling;
  wire [31:0] memory_PC;
  wire  memory_ALIGNEMENT_FAULT;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_MEMORY_STORE;
  wire  memory_MEMORY_ENABLE;
  wire [31:0] _zz_82_;
  wire [31:0] _zz_83_;
  wire  _zz_84_;
  wire  _zz_85_;
  wire  _zz_86_;
  wire  _zz_87_;
  wire  _zz_88_;
  wire  _zz_89_;
  wire  execute_MMU_FAULT;
  wire [31:0] execute_MMU_RSP_physicalAddress;
  wire  execute_MMU_RSP_isIoAccess;
  wire  execute_MMU_RSP_allowRead;
  wire  execute_MMU_RSP_allowWrite;
  wire  execute_MMU_RSP_allowExecute;
  wire  execute_MMU_RSP_exception;
  wire  execute_MMU_RSP_refilling;
  wire  _zz_90_;
  wire [31:0] execute_SRC_ADD;
  wire [1:0] _zz_91_;
  wire [31:0] execute_RS2;
  wire [31:0] execute_INSTRUCTION;
  wire  execute_MEMORY_STORE;
  wire  execute_MEMORY_ENABLE;
  wire  execute_ALIGNEMENT_FAULT;
  wire  _zz_92_;
  wire  decode_MEMORY_ENABLE;
  wire  decode_FLUSH_ALL;
  reg  IBusCachedPlugin_rsp_issueDetected;
  reg  _zz_93_;
  reg  _zz_94_;
  reg  _zz_95_;
  wire [31:0] _zz_96_;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_97_;
  wire [31:0] decode_INSTRUCTION;
  reg [31:0] _zz_98_;
  reg [31:0] _zz_99_;
  wire [31:0] decode_PC;
  wire [31:0] _zz_100_;
  wire [31:0] _zz_101_;
  wire [31:0] _zz_102_;
  wire [31:0] writeBack_PC;
  wire [31:0] writeBack_INSTRUCTION;
  reg  decode_arbitration_haltItself;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushIt;
  reg  decode_arbitration_flushNext;
  reg  decode_arbitration_isValid;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  reg  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  reg  execute_arbitration_flushIt;
  reg  execute_arbitration_flushNext;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  reg  memory_arbitration_flushIt;
  reg  memory_arbitration_flushNext;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  wire  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  wire  writeBack_arbitration_flushIt;
  reg  writeBack_arbitration_flushNext;
  reg  writeBack_arbitration_isValid;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring;
  wire [31:0] lastStageInstruction /* verilator public */ ;
  wire [31:0] lastStagePc /* verilator public */ ;
  wire  lastStageIsValid /* verilator public */ ;
  wire  lastStageIsFiring /* verilator public */ ;
  reg  IBusCachedPlugin_fetcherHalt;
  reg  IBusCachedPlugin_fetcherflushIt;
  reg  IBusCachedPlugin_incomingInstruction;
  wire  IBusCachedPlugin_predictionJumpInterface_valid;
  (* keep , syn_keep *) wire [31:0] IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg  IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire  IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire  IBusCachedPlugin_pcValids_0;
  wire  IBusCachedPlugin_pcValids_1;
  wire  IBusCachedPlugin_pcValids_2;
  wire  IBusCachedPlugin_pcValids_3;
  wire  IBusCachedPlugin_redoBranch_valid;
  wire [31:0] IBusCachedPlugin_redoBranch_payload;
  reg  IBusCachedPlugin_decodeExceptionPort_valid;
  reg [3:0] IBusCachedPlugin_decodeExceptionPort_payload_code;
  wire [31:0] IBusCachedPlugin_decodeExceptionPort_payload_badAddr;
  wire  IBusCachedPlugin_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire [31:0] IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire  IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  wire  IBusCachedPlugin_mmuBus_rsp_allowRead;
  wire  IBusCachedPlugin_mmuBus_rsp_allowWrite;
  wire  IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire  IBusCachedPlugin_mmuBus_rsp_exception;
  wire  IBusCachedPlugin_mmuBus_rsp_refilling;
  wire  IBusCachedPlugin_mmuBus_end;
  wire  IBusCachedPlugin_mmuBus_busy;
  reg  DBusSimplePlugin_memoryExceptionPort_valid;
  reg [3:0] DBusSimplePlugin_memoryExceptionPort_payload_code;
  wire [31:0] DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
  wire  DBusSimplePlugin_mmuBus_cmd_isValid;
  wire [31:0] DBusSimplePlugin_mmuBus_cmd_virtualAddress;
  wire  DBusSimplePlugin_mmuBus_cmd_bypassTranslation;
  wire [31:0] DBusSimplePlugin_mmuBus_rsp_physicalAddress;
  wire  DBusSimplePlugin_mmuBus_rsp_isIoAccess;
  wire  DBusSimplePlugin_mmuBus_rsp_allowRead;
  wire  DBusSimplePlugin_mmuBus_rsp_allowWrite;
  wire  DBusSimplePlugin_mmuBus_rsp_allowExecute;
  wire  DBusSimplePlugin_mmuBus_rsp_exception;
  wire  DBusSimplePlugin_mmuBus_rsp_refilling;
  wire  DBusSimplePlugin_mmuBus_end;
  wire  DBusSimplePlugin_mmuBus_busy;
  reg  DBusSimplePlugin_redoBranch_valid;
  wire [31:0] DBusSimplePlugin_redoBranch_payload;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_payload_code;
  wire [31:0] decodeExceptionPort_payload_badAddr;
  wire  BranchPlugin_jumpInterface_valid;
  wire [31:0] BranchPlugin_jumpInterface_payload;
  wire  BranchPlugin_branchExceptionPort_valid;
  wire [3:0] BranchPlugin_branchExceptionPort_payload_code;
  wire [31:0] BranchPlugin_branchExceptionPort_payload_badAddr;
  reg  CsrPlugin_jumpInterface_valid;
  reg [31:0] CsrPlugin_jumpInterface_payload;
  wire  CsrPlugin_exceptionPendings_0;
  wire  CsrPlugin_exceptionPendings_1;
  wire  CsrPlugin_exceptionPendings_2;
  wire  CsrPlugin_exceptionPendings_3;
  wire  externalInterrupt;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  reg  CsrPlugin_forceMachineWire;
  reg  CsrPlugin_selfException_valid;
  reg [3:0] CsrPlugin_selfException_payload_code;
  wire [31:0] CsrPlugin_selfException_payload_badAddr;
  reg  CsrPlugin_allowInterrupts;
  reg  CsrPlugin_allowException;
  reg  IBusCachedPlugin_injectionPort_valid;
  reg  IBusCachedPlugin_injectionPort_ready;
  wire [31:0] IBusCachedPlugin_injectionPort_payload;
  wire  IBusCachedPlugin_jump_pcLoad_valid;
  wire [31:0] IBusCachedPlugin_jump_pcLoad_payload;
  wire [4:0] _zz_103_;
  wire [4:0] _zz_104_;
  wire  _zz_105_;
  wire  _zz_106_;
  wire  _zz_107_;
  wire  _zz_108_;
  wire  IBusCachedPlugin_fetchPc_output_valid;
  wire  IBusCachedPlugin_fetchPc_output_ready;
  wire [31:0] IBusCachedPlugin_fetchPc_output_payload;
  reg [31:0] IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusCachedPlugin_fetchPc_corrected;
  reg  IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg  IBusCachedPlugin_fetchPc_booted;
  reg  IBusCachedPlugin_fetchPc_inc;
  reg [31:0] IBusCachedPlugin_fetchPc_pc;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_0_inputSample;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_1_inputSample;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload;
  reg  IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_inputSample;
  wire  _zz_109_;
  wire  _zz_110_;
  wire  _zz_111_;
  wire  _zz_112_;
  wire  _zz_113_;
  reg  _zz_114_;
  wire  _zz_115_;
  reg  _zz_116_;
  reg [31:0] _zz_117_;
  reg  IBusCachedPlugin_iBusRsp_readyForError;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_valid;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_decodeInput_payload_pc;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_error;
  wire [31:0] IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_payload_isRvc;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_4;
  reg  IBusCachedPlugin_injector_decodeRemoved;
  wire  _zz_118_;
  reg [18:0] _zz_119_;
  wire  _zz_120_;
  reg [10:0] _zz_121_;
  wire  _zz_122_;
  reg [18:0] _zz_123_;
  reg  _zz_124_;
  wire  _zz_125_;
  reg [10:0] _zz_126_;
  wire  _zz_127_;
  reg [18:0] _zz_128_;
  wire  iBus_cmd_valid;
  wire  iBus_cmd_ready;
  reg [31:0] iBus_cmd_payload_address;
  wire [2:0] iBus_cmd_payload_size;
  wire  iBus_rsp_valid;
  wire [31:0] iBus_rsp_payload_data;
  wire  iBus_rsp_payload_error;
  wire [31:0] _zz_129_;
  reg [31:0] IBusCachedPlugin_rspCounter;
  wire  IBusCachedPlugin_s0_tightlyCoupledHit;
  reg  IBusCachedPlugin_s1_tightlyCoupledHit;
  reg  IBusCachedPlugin_s2_tightlyCoupledHit;
  wire  IBusCachedPlugin_rsp_iBusRspOutputHalt;
  reg  IBusCachedPlugin_rsp_redoFetch;
  wire  dBus_cmd_valid;
  wire  dBus_cmd_ready;
  wire  dBus_cmd_payload_wr;
  wire [31:0] dBus_cmd_payload_address;
  wire [31:0] dBus_cmd_payload_data;
  wire [1:0] dBus_cmd_payload_size;
  wire  dBus_rsp_ready;
  wire  dBus_rsp_error;
  wire [31:0] dBus_rsp_data;
  wire  _zz_130_;
  reg  execute_DBusSimplePlugin_skipCmd;
  reg [31:0] _zz_131_;
  reg [3:0] _zz_132_;
  wire [3:0] execute_DBusSimplePlugin_formalMask;
  reg [31:0] writeBack_DBusSimplePlugin_rspShifted;
  wire  _zz_133_;
  reg [31:0] _zz_134_;
  wire  _zz_135_;
  reg [31:0] _zz_136_;
  reg [31:0] writeBack_DBusSimplePlugin_rspFormated;
  wire [31:0] _zz_137_;
  wire  _zz_138_;
  wire  _zz_139_;
  wire  _zz_140_;
  wire  _zz_141_;
  wire  _zz_142_;
  wire  _zz_143_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_144_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_145_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_146_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_147_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_148_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_149_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_150_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  lastStageRegFileWrite_valid /* verilator public */ ;
  wire [4:0] lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire [31:0] lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg  _zz_151_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_152_;
  reg [31:0] _zz_153_;
  wire  _zz_154_;
  reg [19:0] _zz_155_;
  wire  _zz_156_;
  reg [19:0] _zz_157_;
  reg [31:0] _zz_158_;
  reg [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  reg  execute_LightShifterPlugin_isActive;
  wire  execute_LightShifterPlugin_isShift;
  reg [4:0] execute_LightShifterPlugin_amplitudeReg;
  wire [4:0] execute_LightShifterPlugin_amplitude;
  wire [31:0] execute_LightShifterPlugin_shiftInput;
  wire  execute_LightShifterPlugin_done;
  reg [31:0] _zz_159_;
  reg  _zz_160_;
  reg  _zz_161_;
  wire  _zz_162_;
  reg  _zz_163_;
  reg [4:0] _zz_164_;
  reg [31:0] _zz_165_;
  wire  _zz_166_;
  wire  _zz_167_;
  wire  _zz_168_;
  wire  _zz_169_;
  wire  _zz_170_;
  wire  _zz_171_;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_172_;
  reg  _zz_173_;
  reg  _zz_174_;
  wire  _zz_175_;
  reg [19:0] _zz_176_;
  wire  _zz_177_;
  reg [10:0] _zz_178_;
  wire  _zz_179_;
  reg [18:0] _zz_180_;
  reg  _zz_181_;
  wire  execute_BranchPlugin_missAlignedTarget;
  reg [31:0] execute_BranchPlugin_branch_src1;
  reg [31:0] execute_BranchPlugin_branch_src2;
  wire  _zz_182_;
  reg [19:0] _zz_183_;
  wire  _zz_184_;
  reg [10:0] _zz_185_;
  wire  _zz_186_;
  reg [18:0] _zz_187_;
  wire [31:0] execute_BranchPlugin_branchAdder;
  wire [1:0] CsrPlugin_misa_base;
  wire [25:0] CsrPlugin_misa_extensions;
  reg [1:0] CsrPlugin_mtvec_mode;
  reg [29:0] CsrPlugin_mtvec_base;
  reg [31:0] CsrPlugin_mepc;
  reg  CsrPlugin_mstatus_MIE;
  reg  CsrPlugin_mstatus_MPIE;
  reg [1:0] CsrPlugin_mstatus_MPP;
  reg  CsrPlugin_mip_MEIP;
  reg  CsrPlugin_mip_MTIP;
  reg  CsrPlugin_mip_MSIP;
  reg  CsrPlugin_mie_MEIE;
  reg  CsrPlugin_mie_MTIE;
  reg  CsrPlugin_mie_MSIE;
  reg  CsrPlugin_mcause_interrupt;
  reg [3:0] CsrPlugin_mcause_exceptionCode;
  reg [31:0] CsrPlugin_mtval;
  reg [63:0] CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg [63:0] CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire  _zz_188_;
  wire  _zz_189_;
  wire  _zz_190_;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg [3:0] CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg [31:0] CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire [1:0] _zz_191_;
  wire  _zz_192_;
  wire [1:0] _zz_193_;
  wire  _zz_194_;
  reg  CsrPlugin_interrupt_valid;
  reg [3:0] CsrPlugin_interrupt_code /* verilator public */ ;
  reg [1:0] CsrPlugin_interrupt_targetPrivilege;
  wire  CsrPlugin_exception;
  wire  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  reg [1:0] CsrPlugin_targetPrivilege;
  reg [3:0] CsrPlugin_trapCause;
  reg [1:0] CsrPlugin_xtvec_mode;
  reg [29:0] CsrPlugin_xtvec_base;
  wire  execute_CsrPlugin_inWfi /* verilator public */ ;
  reg  execute_CsrPlugin_wfiWake;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  wire [31:0] execute_CsrPlugin_readToWriteData;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  reg [32:0] memory_MulDivIterativePlugin_rs1;
  reg [31:0] memory_MulDivIterativePlugin_rs2;
  reg [64:0] memory_MulDivIterativePlugin_accumulator;
  reg  memory_MulDivIterativePlugin_mul_counter_willIncrement;
  reg  memory_MulDivIterativePlugin_mul_counter_willClear;
  reg [5:0] memory_MulDivIterativePlugin_mul_counter_valueNext;
  reg [5:0] memory_MulDivIterativePlugin_mul_counter_value;
  wire  memory_MulDivIterativePlugin_mul_willOverflowIfInc;
  wire  memory_MulDivIterativePlugin_mul_counter_willOverflow;
  reg  memory_MulDivIterativePlugin_div_needRevert;
  reg  memory_MulDivIterativePlugin_div_counter_willIncrement;
  reg  memory_MulDivIterativePlugin_div_counter_willClear;
  reg [5:0] memory_MulDivIterativePlugin_div_counter_valueNext;
  reg [5:0] memory_MulDivIterativePlugin_div_counter_value;
  wire  memory_MulDivIterativePlugin_div_counter_willOverflowIfInc;
  wire  memory_MulDivIterativePlugin_div_counter_willOverflow;
  reg  memory_MulDivIterativePlugin_div_done;
  reg [31:0] memory_MulDivIterativePlugin_div_result;
  wire [31:0] _zz_195_;
  wire [32:0] _zz_196_;
  wire [32:0] _zz_197_;
  wire [31:0] _zz_198_;
  wire  _zz_199_;
  wire  _zz_200_;
  reg [32:0] _zz_201_;
  reg [31:0] externalInterruptArray_regNext;
  reg [31:0] _zz_202_;
  wire [31:0] _zz_203_;
  reg  DebugPlugin_firstCycle;
  reg  DebugPlugin_secondCycle;
  reg  DebugPlugin_resetIt;
  reg  DebugPlugin_haltIt;
  reg  DebugPlugin_stepIt;
  reg  DebugPlugin_isPipBusy;
  reg  DebugPlugin_godmode;
  reg  DebugPlugin_haltedByBreak;
  reg [31:0] DebugPlugin_busReadDataReg;
  reg  _zz_204_;
  reg  DebugPlugin_resetIt_regNext;
  reg  decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg  decode_to_execute_IS_RS1_SIGNED;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg  decode_to_execute_IS_MUL;
  reg  execute_to_memory_IS_MUL;
  reg [31:0] execute_to_memory_MMU_RSP_physicalAddress;
  reg  execute_to_memory_MMU_RSP_isIoAccess;
  reg  execute_to_memory_MMU_RSP_allowRead;
  reg  execute_to_memory_MMU_RSP_allowWrite;
  reg  execute_to_memory_MMU_RSP_allowExecute;
  reg  execute_to_memory_MMU_RSP_exception;
  reg  execute_to_memory_MMU_RSP_refilling;
  reg  execute_to_memory_BRANCH_DO;
  reg  decode_to_execute_IS_RS2_SIGNED;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg [31:0] memory_to_writeBack_MEMORY_READ_DATA;
  reg [31:0] decode_to_execute_RS2;
  reg  decode_to_execute_MEMORY_STORE;
  reg  execute_to_memory_MEMORY_STORE;
  reg  memory_to_writeBack_MEMORY_STORE;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg  memory_to_writeBack_MEMORY_ENABLE;
  reg [31:0] execute_to_memory_BRANCH_CALC;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg  decode_to_execute_SRC2_FORCE_ZERO;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg  decode_to_execute_IS_DIV;
  reg  execute_to_memory_IS_DIV;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg  execute_to_memory_MMU_FAULT;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg [1:0] memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg  execute_to_memory_ALIGNEMENT_FAULT;
  reg [31:0] decode_to_execute_RS1;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg  decode_to_execute_DO_EBREAK;
  reg  decode_to_execute_IS_CSR;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg [2:0] _zz_205_;
  reg [2:0] _zz_206_;
  reg  _zz_207_;
  reg [31:0] iBusWishbone_DAT_MISO_regNext;
  wire  dBus_cmd_halfPipe_valid;
  wire  dBus_cmd_halfPipe_ready;
  wire  dBus_cmd_halfPipe_payload_wr;
  wire [31:0] dBus_cmd_halfPipe_payload_address;
  wire [31:0] dBus_cmd_halfPipe_payload_data;
  wire [1:0] dBus_cmd_halfPipe_payload_size;
  reg  dBus_cmd_halfPipe_regs_valid;
  reg  dBus_cmd_halfPipe_regs_ready;
  reg  dBus_cmd_halfPipe_regs_payload_wr;
  reg [31:0] dBus_cmd_halfPipe_regs_payload_address;
  reg [31:0] dBus_cmd_halfPipe_regs_payload_data;
  reg [1:0] dBus_cmd_halfPipe_regs_payload_size;
  reg [3:0] _zz_208_;
  `ifndef SYNTHESIS
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_1__string;
  reg [95:0] _zz_2__string;
  reg [95:0] _zz_3__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_4__string;
  reg [23:0] _zz_5__string;
  reg [23:0] _zz_6__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_7__string;
  reg [63:0] _zz_8__string;
  reg [63:0] _zz_9__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_10__string;
  reg [39:0] _zz_11__string;
  reg [39:0] _zz_12__string;
  reg [39:0] _zz_13__string;
  reg [39:0] _zz_14__string;
  reg [39:0] _zz_15__string;
  reg [39:0] _zz_16__string;
  reg [39:0] decode_ENV_CTRL_string;
  reg [39:0] _zz_17__string;
  reg [39:0] _zz_18__string;
  reg [39:0] _zz_19__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_20__string;
  reg [71:0] _zz_21__string;
  reg [71:0] _zz_22__string;
  reg [31:0] _zz_23__string;
  reg [31:0] _zz_24__string;
  reg [39:0] memory_ENV_CTRL_string;
  reg [39:0] _zz_26__string;
  reg [39:0] execute_ENV_CTRL_string;
  reg [39:0] _zz_27__string;
  reg [39:0] writeBack_ENV_CTRL_string;
  reg [39:0] _zz_30__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_33__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_38__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_43__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_45__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_48__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_50__string;
  reg [71:0] _zz_61__string;
  reg [39:0] _zz_63__string;
  reg [39:0] _zz_65__string;
  reg [63:0] _zz_69__string;
  reg [23:0] _zz_70__string;
  reg [95:0] _zz_76__string;
  reg [31:0] _zz_79__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_97__string;
  reg [31:0] _zz_144__string;
  reg [95:0] _zz_145__string;
  reg [23:0] _zz_146__string;
  reg [63:0] _zz_147__string;
  reg [39:0] _zz_148__string;
  reg [39:0] _zz_149__string;
  reg [71:0] _zz_150__string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [39:0] decode_to_execute_ENV_CTRL_string;
  reg [39:0] execute_to_memory_ENV_CTRL_string;
  reg [39:0] memory_to_writeBack_ENV_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  `endif

  (* ram_style = "block" *) reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign _zz_221_ = (memory_arbitration_isValid && memory_IS_MUL);
  assign _zz_222_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_223_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_224_ = 1'b1;
  assign _zz_225_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_226_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_227_ = ((execute_arbitration_isValid && execute_LightShifterPlugin_isShift) && (execute_SRC2[4 : 0] != (5'b00000)));
  assign _zz_228_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_229_ = ((_zz_214_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! _zz_93_));
  assign _zz_230_ = ((_zz_214_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! _zz_94_));
  assign _zz_231_ = ((_zz_214_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! _zz_95_));
  assign _zz_232_ = ((_zz_214_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! 1'b0));
  assign _zz_233_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_234_ = (! execute_arbitration_isStuckByOthers);
  assign _zz_235_ = (execute_arbitration_isValid && execute_DO_EBREAK);
  assign _zz_236_ = (({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00)) == 1'b0);
  assign _zz_237_ = (! memory_MulDivIterativePlugin_mul_willOverflowIfInc);
  assign _zz_238_ = (! memory_MulDivIterativePlugin_div_done);
  assign _zz_239_ = ({BranchPlugin_branchExceptionPort_valid,DBusSimplePlugin_memoryExceptionPort_valid} != (2'b00));
  assign _zz_240_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_241_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_242_ = (DebugPlugin_stepIt && IBusCachedPlugin_incomingInstruction);
  assign _zz_243_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_244_ = (! IBusCachedPlugin_iBusRsp_readyForError);
  assign _zz_245_ = ((dBus_rsp_ready && dBus_rsp_error) && (! memory_MEMORY_STORE));
  assign _zz_246_ = (! ((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (1'b1 || (! memory_arbitration_isStuckByOthers))));
  assign _zz_247_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_248_ = (1'b0 || (! 1'b1));
  assign _zz_249_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_250_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_251_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_252_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_253_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_254_ = (! memory_arbitration_isStuck);
  assign _zz_255_ = debug_bus_cmd_payload_address[7 : 2];
  assign _zz_256_ = (iBus_cmd_valid || (_zz_206_ != (3'b000)));
  assign _zz_257_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_258_ = ((_zz_188_ && 1'b1) && (! 1'b0));
  assign _zz_259_ = ((_zz_189_ && 1'b1) && (! 1'b0));
  assign _zz_260_ = ((_zz_190_ && 1'b1) && (! 1'b0));
  assign _zz_261_ = (! dBus_cmd_halfPipe_regs_valid);
  assign _zz_262_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_263_ = execute_INSTRUCTION[13];
  assign _zz_264_ = (_zz_103_ - (5'b00001));
  assign _zz_265_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_266_ = {29'd0, _zz_265_};
  assign _zz_267_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_268_ = {{_zz_119_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_269_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_270_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_271_ = {{_zz_121_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_272_ = {{_zz_123_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_273_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_274_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_275_ = (memory_MEMORY_STORE ? (3'b110) : (3'b100));
  assign _zz_276_ = _zz_137_[2 : 2];
  assign _zz_277_ = _zz_137_[3 : 3];
  assign _zz_278_ = _zz_137_[6 : 6];
  assign _zz_279_ = _zz_137_[7 : 7];
  assign _zz_280_ = _zz_137_[8 : 8];
  assign _zz_281_ = _zz_137_[9 : 9];
  assign _zz_282_ = _zz_137_[10 : 10];
  assign _zz_283_ = _zz_137_[15 : 15];
  assign _zz_284_ = _zz_137_[16 : 16];
  assign _zz_285_ = _zz_137_[17 : 17];
  assign _zz_286_ = _zz_137_[20 : 20];
  assign _zz_287_ = _zz_137_[24 : 24];
  assign _zz_288_ = _zz_137_[27 : 27];
  assign _zz_289_ = _zz_137_[28 : 28];
  assign _zz_290_ = _zz_137_[29 : 29];
  assign _zz_291_ = _zz_137_[30 : 30];
  assign _zz_292_ = _zz_137_[31 : 31];
  assign _zz_293_ = execute_SRC_LESS;
  assign _zz_294_ = (3'b100);
  assign _zz_295_ = execute_INSTRUCTION[19 : 15];
  assign _zz_296_ = execute_INSTRUCTION[31 : 20];
  assign _zz_297_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_298_ = ($signed(_zz_299_) + $signed(_zz_302_));
  assign _zz_299_ = ($signed(_zz_300_) + $signed(_zz_301_));
  assign _zz_300_ = execute_SRC1;
  assign _zz_301_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_302_ = (execute_SRC_USE_SUB_LESS ? _zz_303_ : _zz_304_);
  assign _zz_303_ = (32'b00000000000000000000000000000001);
  assign _zz_304_ = (32'b00000000000000000000000000000000);
  assign _zz_305_ = (_zz_306_ >>> 1);
  assign _zz_306_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_LightShifterPlugin_shiftInput[31]),execute_LightShifterPlugin_shiftInput};
  assign _zz_307_ = execute_INSTRUCTION[31 : 20];
  assign _zz_308_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_309_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_310_ = {_zz_176_,execute_INSTRUCTION[31 : 20]};
  assign _zz_311_ = {{_zz_178_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_312_ = {{_zz_180_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_313_ = execute_INSTRUCTION[31 : 20];
  assign _zz_314_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_315_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_316_ = (3'b100);
  assign _zz_317_ = (_zz_191_ & (~ _zz_318_));
  assign _zz_318_ = (_zz_191_ - (2'b01));
  assign _zz_319_ = (_zz_193_ & (~ _zz_320_));
  assign _zz_320_ = (_zz_193_ - (2'b01));
  assign _zz_321_ = memory_MulDivIterativePlugin_mul_counter_willIncrement;
  assign _zz_322_ = {5'd0, _zz_321_};
  assign _zz_323_ = (_zz_325_ + _zz_327_);
  assign _zz_324_ = (memory_MulDivIterativePlugin_rs2[0] ? memory_MulDivIterativePlugin_rs1 : (33'b000000000000000000000000000000000));
  assign _zz_325_ = {{1{_zz_324_[32]}}, _zz_324_};
  assign _zz_326_ = _zz_328_;
  assign _zz_327_ = {{1{_zz_326_[32]}}, _zz_326_};
  assign _zz_328_ = (memory_MulDivIterativePlugin_accumulator >>> 32);
  assign _zz_329_ = memory_MulDivIterativePlugin_div_counter_willIncrement;
  assign _zz_330_ = {5'd0, _zz_329_};
  assign _zz_331_ = {1'd0, memory_MulDivIterativePlugin_rs2};
  assign _zz_332_ = {_zz_195_,(! _zz_197_[32])};
  assign _zz_333_ = _zz_197_[31:0];
  assign _zz_334_ = _zz_196_[31:0];
  assign _zz_335_ = _zz_336_;
  assign _zz_336_ = _zz_337_;
  assign _zz_337_ = ({1'b0,(memory_MulDivIterativePlugin_div_needRevert ? (~ _zz_198_) : _zz_198_)} + _zz_339_);
  assign _zz_338_ = memory_MulDivIterativePlugin_div_needRevert;
  assign _zz_339_ = {32'd0, _zz_338_};
  assign _zz_340_ = _zz_200_;
  assign _zz_341_ = {32'd0, _zz_340_};
  assign _zz_342_ = _zz_199_;
  assign _zz_343_ = {31'd0, _zz_342_};
  assign _zz_344_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_345_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_346_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_347_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_348_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_349_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_350_ = (iBus_cmd_payload_address >>> 5);
  assign _zz_351_ = ({3'd0,_zz_208_} <<< dBus_cmd_halfPipe_payload_address[1 : 0]);
  assign _zz_352_ = 1'b1;
  assign _zz_353_ = 1'b1;
  assign _zz_354_ = {_zz_106_,{_zz_108_,_zz_107_}};
  assign _zz_355_ = decode_INSTRUCTION[31];
  assign _zz_356_ = decode_INSTRUCTION[31];
  assign _zz_357_ = decode_INSTRUCTION[7];
  assign _zz_358_ = (32'b00000010000000000100000001110100);
  assign _zz_359_ = (decode_INSTRUCTION & (32'b00000000000000000001000001001000));
  assign _zz_360_ = (32'b00000000000000000001000000001000);
  assign _zz_361_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000010000)) == (32'b00000000000000000000000000010000));
  assign _zz_362_ = {(_zz_367_ == _zz_368_),{_zz_369_,{_zz_370_,_zz_371_}}};
  assign _zz_363_ = (4'b0000);
  assign _zz_364_ = ({_zz_372_,_zz_373_} != (2'b00));
  assign _zz_365_ = ({_zz_374_,_zz_375_} != (2'b00));
  assign _zz_366_ = {(_zz_376_ != _zz_377_),{_zz_378_,{_zz_379_,_zz_380_}}};
  assign _zz_367_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000100));
  assign _zz_368_ = (32'b00000000000000000000000000000000);
  assign _zz_369_ = ((decode_INSTRUCTION & _zz_381_) == (32'b00000000000000000000000000000000));
  assign _zz_370_ = (_zz_382_ == _zz_383_);
  assign _zz_371_ = (_zz_384_ == _zz_385_);
  assign _zz_372_ = ((decode_INSTRUCTION & _zz_386_) == (32'b00000000000000000001000001010000));
  assign _zz_373_ = ((decode_INSTRUCTION & _zz_387_) == (32'b00000000000000000010000001010000));
  assign _zz_374_ = (_zz_388_ == _zz_389_);
  assign _zz_375_ = (_zz_390_ == _zz_391_);
  assign _zz_376_ = {_zz_392_,{_zz_393_,_zz_394_}};
  assign _zz_377_ = (3'b000);
  assign _zz_378_ = ({_zz_395_,_zz_396_} != (6'b000000));
  assign _zz_379_ = (_zz_397_ != _zz_398_);
  assign _zz_380_ = {_zz_399_,{_zz_400_,_zz_401_}};
  assign _zz_381_ = (32'b00000000000000000000000000011000);
  assign _zz_382_ = (decode_INSTRUCTION & (32'b00000000000000000110000000000100));
  assign _zz_383_ = (32'b00000000000000000010000000000000);
  assign _zz_384_ = (decode_INSTRUCTION & (32'b00000000000000000101000000000100));
  assign _zz_385_ = (32'b00000000000000000001000000000000);
  assign _zz_386_ = (32'b00000000000000000001000001010000);
  assign _zz_387_ = (32'b00000000000000000010000001010000);
  assign _zz_388_ = (decode_INSTRUCTION & (32'b00000000000000000111000000110100));
  assign _zz_389_ = (32'b00000000000000000101000000010000);
  assign _zz_390_ = (decode_INSTRUCTION & (32'b00000010000000000111000001100100));
  assign _zz_391_ = (32'b00000000000000000101000000100000);
  assign _zz_392_ = ((decode_INSTRUCTION & _zz_402_) == (32'b01000000000000000001000000010000));
  assign _zz_393_ = (_zz_403_ == _zz_404_);
  assign _zz_394_ = (_zz_405_ == _zz_406_);
  assign _zz_395_ = _zz_138_;
  assign _zz_396_ = {_zz_407_,{_zz_408_,_zz_409_}};
  assign _zz_397_ = (_zz_410_ == _zz_411_);
  assign _zz_398_ = (1'b0);
  assign _zz_399_ = (_zz_412_ != (1'b0));
  assign _zz_400_ = (_zz_413_ != _zz_414_);
  assign _zz_401_ = {_zz_415_,{_zz_416_,_zz_417_}};
  assign _zz_402_ = (32'b01000000000000000011000001010100);
  assign _zz_403_ = (decode_INSTRUCTION & (32'b00000000000000000111000000110100));
  assign _zz_404_ = (32'b00000000000000000001000000010000);
  assign _zz_405_ = (decode_INSTRUCTION & (32'b00000010000000000111000001010100));
  assign _zz_406_ = (32'b00000000000000000001000000010000);
  assign _zz_407_ = ((decode_INSTRUCTION & _zz_418_) == (32'b00000000000000000001000000010000));
  assign _zz_408_ = (_zz_419_ == _zz_420_);
  assign _zz_409_ = {_zz_421_,{_zz_422_,_zz_423_}};
  assign _zz_410_ = (decode_INSTRUCTION & (32'b00010000000100000011000001010000));
  assign _zz_411_ = (32'b00000000000000000000000001010000);
  assign _zz_412_ = ((decode_INSTRUCTION & _zz_424_) == (32'b00010000000000000000000001010000));
  assign _zz_413_ = {_zz_425_,{_zz_426_,_zz_427_}};
  assign _zz_414_ = (3'b000);
  assign _zz_415_ = ({_zz_428_,_zz_429_} != (3'b000));
  assign _zz_416_ = (_zz_430_ != _zz_431_);
  assign _zz_417_ = {_zz_432_,{_zz_433_,_zz_434_}};
  assign _zz_418_ = (32'b00000000000000000001000000010000);
  assign _zz_419_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_420_ = (32'b00000000000000000010000000010000);
  assign _zz_421_ = ((decode_INSTRUCTION & _zz_435_) == (32'b00000000000000000000000000010000));
  assign _zz_422_ = (_zz_436_ == _zz_437_);
  assign _zz_423_ = (_zz_438_ == _zz_439_);
  assign _zz_424_ = (32'b00010000010000000011000001010000);
  assign _zz_425_ = ((decode_INSTRUCTION & _zz_440_) == (32'b00000000000000000000000001000000));
  assign _zz_426_ = (_zz_441_ == _zz_442_);
  assign _zz_427_ = (_zz_443_ == _zz_444_);
  assign _zz_428_ = _zz_142_;
  assign _zz_429_ = {_zz_445_,_zz_446_};
  assign _zz_430_ = (_zz_447_ == _zz_448_);
  assign _zz_431_ = (1'b0);
  assign _zz_432_ = (_zz_143_ != (1'b0));
  assign _zz_433_ = (_zz_449_ != _zz_450_);
  assign _zz_434_ = {_zz_451_,{_zz_452_,_zz_453_}};
  assign _zz_435_ = (32'b00000000000000000000000001010000);
  assign _zz_436_ = (decode_INSTRUCTION & (32'b00000000000000000000000000001100));
  assign _zz_437_ = (32'b00000000000000000000000000000100);
  assign _zz_438_ = (decode_INSTRUCTION & (32'b00000000000000000000000000101000));
  assign _zz_439_ = (32'b00000000000000000000000000000000);
  assign _zz_440_ = (32'b00000000000000000000000001010000);
  assign _zz_441_ = (decode_INSTRUCTION & (32'b00000000000000000000000000111000));
  assign _zz_442_ = (32'b00000000000000000000000000000000);
  assign _zz_443_ = (decode_INSTRUCTION & (32'b00000000000100000011000001000000));
  assign _zz_444_ = (32'b00000000000000000000000001000000);
  assign _zz_445_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000110000)) == (32'b00000000000000000000000000010000));
  assign _zz_446_ = ((decode_INSTRUCTION & (32'b00000010000000000000000001100000)) == (32'b00000000000000000000000000100000));
  assign _zz_447_ = (decode_INSTRUCTION & (32'b00000000000000000001000000000000));
  assign _zz_448_ = (32'b00000000000000000001000000000000);
  assign _zz_449_ = ((decode_INSTRUCTION & _zz_454_) == (32'b00000000000000000000000000000000));
  assign _zz_450_ = (1'b0);
  assign _zz_451_ = ({_zz_140_,{_zz_455_,_zz_456_}} != (3'b000));
  assign _zz_452_ = ({_zz_457_,_zz_458_} != (3'b000));
  assign _zz_453_ = {(_zz_459_ != _zz_460_),{_zz_461_,{_zz_462_,_zz_463_}}};
  assign _zz_454_ = (32'b00000000000000000000000001011000);
  assign _zz_455_ = _zz_143_;
  assign _zz_456_ = _zz_139_;
  assign _zz_457_ = ((decode_INSTRUCTION & _zz_464_) == (32'b00000000000000000000000001000000));
  assign _zz_458_ = {(_zz_465_ == _zz_466_),(_zz_467_ == _zz_468_)};
  assign _zz_459_ = {(_zz_469_ == _zz_470_),(_zz_471_ == _zz_472_)};
  assign _zz_460_ = (2'b00);
  assign _zz_461_ = ((_zz_473_ == _zz_474_) != (1'b0));
  assign _zz_462_ = ({_zz_475_,_zz_476_} != (2'b00));
  assign _zz_463_ = {(_zz_477_ != _zz_478_),{_zz_479_,{_zz_480_,_zz_481_}}};
  assign _zz_464_ = (32'b00000000000000000000000001000100);
  assign _zz_465_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010100));
  assign _zz_466_ = (32'b00000000000000000010000000010000);
  assign _zz_467_ = (decode_INSTRUCTION & (32'b01000000000000000100000000110100));
  assign _zz_468_ = (32'b01000000000000000000000000110000);
  assign _zz_469_ = (decode_INSTRUCTION & (32'b00000000000000000110000000010100));
  assign _zz_470_ = (32'b00000000000000000110000000010000);
  assign _zz_471_ = (decode_INSTRUCTION & (32'b00000000000000000101000000010100));
  assign _zz_472_ = (32'b00000000000000000100000000010000);
  assign _zz_473_ = (decode_INSTRUCTION & (32'b00000000000000000110000000010100));
  assign _zz_474_ = (32'b00000000000000000010000000010000);
  assign _zz_475_ = _zz_142_;
  assign _zz_476_ = ((decode_INSTRUCTION & _zz_482_) == (32'b00000000000000000000000000100000));
  assign _zz_477_ = {_zz_142_,(_zz_483_ == _zz_484_)};
  assign _zz_478_ = (2'b00);
  assign _zz_479_ = ({_zz_485_,{_zz_486_,_zz_487_}} != (3'b000));
  assign _zz_480_ = (_zz_488_ != (1'b0));
  assign _zz_481_ = {(_zz_489_ != _zz_490_),{_zz_491_,{_zz_492_,_zz_493_}}};
  assign _zz_482_ = (32'b00000000000000000000000001110000);
  assign _zz_483_ = (decode_INSTRUCTION & (32'b00000000000000000000000000100000));
  assign _zz_484_ = (32'b00000000000000000000000000000000);
  assign _zz_485_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100100));
  assign _zz_486_ = ((decode_INSTRUCTION & _zz_494_) == (32'b00000000000000000001000000010000));
  assign _zz_487_ = ((decode_INSTRUCTION & _zz_495_) == (32'b00000000000000000001000000010000));
  assign _zz_488_ = ((decode_INSTRUCTION & (32'b00010000000100000011000001010000)) == (32'b00000000000100000000000001010000));
  assign _zz_489_ = ((decode_INSTRUCTION & _zz_496_) == (32'b00000000000000000000000000100000));
  assign _zz_490_ = (1'b0);
  assign _zz_491_ = ({_zz_497_,_zz_498_} != (2'b00));
  assign _zz_492_ = (_zz_499_ != (1'b0));
  assign _zz_493_ = {(_zz_500_ != _zz_501_),{_zz_502_,{_zz_503_,_zz_504_}}};
  assign _zz_494_ = (32'b00000000000000000011000000110100);
  assign _zz_495_ = (32'b00000010000000000011000001010100);
  assign _zz_496_ = (32'b00000000000000000000000000100000);
  assign _zz_497_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000010000)) == (32'b00000000000000000010000000000000));
  assign _zz_498_ = ((decode_INSTRUCTION & (32'b00000000000000000101000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_499_ = ((decode_INSTRUCTION & (32'b00000010000000000100000001100100)) == (32'b00000010000000000100000000100000));
  assign _zz_500_ = {(_zz_505_ == _zz_506_),_zz_141_};
  assign _zz_501_ = (2'b00);
  assign _zz_502_ = ({_zz_507_,_zz_141_} != (2'b00));
  assign _zz_503_ = ({_zz_508_,_zz_509_} != (2'b00));
  assign _zz_504_ = {(_zz_510_ != _zz_511_),{_zz_512_,_zz_513_}};
  assign _zz_505_ = (decode_INSTRUCTION & (32'b00000000000000000000000000010100));
  assign _zz_506_ = (32'b00000000000000000000000000000100);
  assign _zz_507_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000000000100));
  assign _zz_508_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000110100)) == (32'b00000000000000000000000000100000));
  assign _zz_509_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100000));
  assign _zz_510_ = {_zz_140_,_zz_139_};
  assign _zz_511_ = (2'b00);
  assign _zz_512_ = ({_zz_138_,((decode_INSTRUCTION & (32'b00000000000000000000000000011100)) == (32'b00000000000000000000000000000100))} != (2'b00));
  assign _zz_513_ = (((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000001000000)) != (1'b0));
  assign _zz_514_ = (32'b00000000000000000001000001111111);
  assign _zz_515_ = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_516_ = (32'b00000000000000000010000001110011);
  assign _zz_517_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001111111)) == (32'b00000000000000000100000001100011));
  assign _zz_518_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000010000000010011));
  assign _zz_519_ = {((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011)),{((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_520_) == (32'b00000000000000000000000000000011)),{(_zz_521_ == _zz_522_),{_zz_523_,{_zz_524_,_zz_525_}}}}}};
  assign _zz_520_ = (32'b00000000000000000101000001011111);
  assign _zz_521_ = (decode_INSTRUCTION & (32'b00000000000000000111000001111011));
  assign _zz_522_ = (32'b00000000000000000000000001100011);
  assign _zz_523_ = ((decode_INSTRUCTION & (32'b00000000000000000110000001111111)) == (32'b00000000000000000000000000001111));
  assign _zz_524_ = ((decode_INSTRUCTION & (32'b11111100000000000000000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_525_ = {((decode_INSTRUCTION & (32'b11111100000000000011000001011111)) == (32'b00000000000000000001000000010011)),{((decode_INSTRUCTION & (32'b10111100000000000111000001111111)) == (32'b00000000000000000101000000010011)),{((decode_INSTRUCTION & _zz_526_) == (32'b00000000000000000101000000110011)),{(_zz_527_ == _zz_528_),{_zz_529_,{_zz_530_,_zz_531_}}}}}};
  assign _zz_526_ = (32'b10111110000000000111000001111111);
  assign _zz_527_ = (decode_INSTRUCTION & (32'b10111110000000000111000001111111));
  assign _zz_528_ = (32'b00000000000000000000000000110011);
  assign _zz_529_ = ((decode_INSTRUCTION & (32'b11011111111111111111111111111111)) == (32'b00010000001000000000000001110011));
  assign _zz_530_ = ((decode_INSTRUCTION & (32'b11111111111011111111111111111111)) == (32'b00000000000000000000000001110011));
  assign _zz_531_ = ((decode_INSTRUCTION & (32'b11111111111111111111111111111111)) == (32'b00010000010100000000000001110011));
  assign _zz_532_ = execute_INSTRUCTION[31];
  assign _zz_533_ = execute_INSTRUCTION[31];
  assign _zz_534_ = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_53_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_352_) begin
      _zz_218_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_353_) begin
      _zz_219_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  InstructionCache IBusCachedPlugin_cache ( 
    .io_flush(_zz_209_),
    .io_cpu_prefetch_isValid(_zz_210_),
    .io_cpu_prefetch_haltIt(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt),
    .io_cpu_prefetch_pc(IBusCachedPlugin_iBusRsp_stages_0_input_payload),
    .io_cpu_fetch_isValid(_zz_211_),
    .io_cpu_fetch_isStuck(_zz_212_),
    .io_cpu_fetch_isRemoved(IBusCachedPlugin_fetcherflushIt),
    .io_cpu_fetch_pc(IBusCachedPlugin_iBusRsp_stages_1_input_payload),
    .io_cpu_fetch_data(IBusCachedPlugin_cache_io_cpu_fetch_data),
    .io_cpu_fetch_dataBypassValid(IBusCachedPlugin_s1_tightlyCoupledHit),
    .io_cpu_fetch_dataBypass(_zz_213_),
    .io_cpu_fetch_mmuBus_cmd_isValid(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid),
    .io_cpu_fetch_mmuBus_cmd_virtualAddress(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress),
    .io_cpu_fetch_mmuBus_cmd_bypassTranslation(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation),
    .io_cpu_fetch_mmuBus_rsp_physicalAddress(IBusCachedPlugin_mmuBus_rsp_physicalAddress),
    .io_cpu_fetch_mmuBus_rsp_isIoAccess(IBusCachedPlugin_mmuBus_rsp_isIoAccess),
    .io_cpu_fetch_mmuBus_rsp_allowRead(IBusCachedPlugin_mmuBus_rsp_allowRead),
    .io_cpu_fetch_mmuBus_rsp_allowWrite(IBusCachedPlugin_mmuBus_rsp_allowWrite),
    .io_cpu_fetch_mmuBus_rsp_allowExecute(IBusCachedPlugin_mmuBus_rsp_allowExecute),
    .io_cpu_fetch_mmuBus_rsp_exception(IBusCachedPlugin_mmuBus_rsp_exception),
    .io_cpu_fetch_mmuBus_rsp_refilling(IBusCachedPlugin_mmuBus_rsp_refilling),
    .io_cpu_fetch_mmuBus_end(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end),
    .io_cpu_fetch_mmuBus_busy(IBusCachedPlugin_mmuBus_busy),
    .io_cpu_fetch_physicalAddress(IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress),
    .io_cpu_fetch_haltIt(IBusCachedPlugin_cache_io_cpu_fetch_haltIt),
    .io_cpu_decode_isValid(_zz_214_),
    .io_cpu_decode_isStuck(_zz_215_),
    .io_cpu_decode_pc(IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload),
    .io_cpu_decode_physicalAddress(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_cpu_decode_data(IBusCachedPlugin_cache_io_cpu_decode_data),
    .io_cpu_decode_cacheMiss(IBusCachedPlugin_cache_io_cpu_decode_cacheMiss),
    .io_cpu_decode_error(IBusCachedPlugin_cache_io_cpu_decode_error),
    .io_cpu_decode_mmuRefilling(IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling),
    .io_cpu_decode_mmuException(IBusCachedPlugin_cache_io_cpu_decode_mmuException),
    .io_cpu_decode_isUser(_zz_216_),
    .io_cpu_fill_valid(_zz_217_),
    .io_cpu_fill_payload(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_mem_cmd_valid(IBusCachedPlugin_cache_io_mem_cmd_valid),
    .io_mem_cmd_ready(iBus_cmd_ready),
    .io_mem_cmd_payload_address(IBusCachedPlugin_cache_io_mem_cmd_payload_address),
    .io_mem_cmd_payload_size(IBusCachedPlugin_cache_io_mem_cmd_payload_size),
    .io_mem_rsp_valid(iBus_rsp_valid),
    .io_mem_rsp_payload_data(iBus_rsp_payload_data),
    .io_mem_rsp_payload_error(iBus_rsp_payload_error),
    ._zz_10_(_zz_205_),
    ._zz_11_(IBusCachedPlugin_injectionPort_payload),
    .clk(clk),
    .reset(reset) 
  );
  always @(*) begin
    case(_zz_354_)
      3'b000 : begin
        _zz_220_ = CsrPlugin_jumpInterface_payload;
      end
      3'b001 : begin
        _zz_220_ = DBusSimplePlugin_redoBranch_payload;
      end
      3'b010 : begin
        _zz_220_ = BranchPlugin_jumpInterface_payload;
      end
      3'b011 : begin
        _zz_220_ = IBusCachedPlugin_redoBranch_payload;
      end
      default : begin
        _zz_220_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_1_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_1__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_1__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_1__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_1__string = "URS1        ";
      default : _zz_1__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_2__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_2__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_2__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_2__string = "URS1        ";
      default : _zz_2__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_3__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_3__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_3__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_3__string = "URS1        ";
      default : _zz_3__string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_4__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_4__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_4__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_4__string = "PC ";
      default : _zz_4__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_5__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_5__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_5__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_5__string = "PC ";
      default : _zz_5__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_6__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_6__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_6__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_6__string = "PC ";
      default : _zz_6__string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_7__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_7__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_7__string = "BITWISE ";
      default : _zz_7__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_8__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_8__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_8__string = "BITWISE ";
      default : _zz_8__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_9__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_9__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_9__string = "BITWISE ";
      default : _zz_9__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_10__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_10__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_10__string = "AND_1";
      default : _zz_10__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_11__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_11__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_11__string = "AND_1";
      default : _zz_11__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_12__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_12__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_12__string = "AND_1";
      default : _zz_12__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_13__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_13__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_13__string = "ECALL";
      default : _zz_13__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_14__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_14__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_14__string = "ECALL";
      default : _zz_14__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_15__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_15__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_15__string = "ECALL";
      default : _zz_15__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_16__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_16__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_16__string = "ECALL";
      default : _zz_16__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL";
      default : decode_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_17__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_17__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_17__string = "ECALL";
      default : _zz_17__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_18__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_18__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_18__string = "ECALL";
      default : _zz_18__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_19__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_19__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_19__string = "ECALL";
      default : _zz_19__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_20__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_20__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_20__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_20__string = "SRA_1    ";
      default : _zz_20__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_21__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_21__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_21__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_21__string = "SRA_1    ";
      default : _zz_21__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_22__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_22__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_22__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_22__string = "SRA_1    ";
      default : _zz_22__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_23__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_23__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_23__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_23__string = "JALR";
      default : _zz_23__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_24__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_24__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_24__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_24__string = "JALR";
      default : _zz_24__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL";
      default : memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_26__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_26__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_26__string = "ECALL";
      default : _zz_26__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL";
      default : execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_27__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_27__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_27__string = "ECALL";
      default : _zz_27__string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL";
      default : writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_30__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_30__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_30__string = "ECALL";
      default : _zz_30__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_33_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_33__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_33__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_33__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_33__string = "JALR";
      default : _zz_33__string = "????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_38_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_38__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_38__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_38__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_38__string = "SRA_1    ";
      default : _zz_38__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_43_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_43__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_43__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_43__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_43__string = "PC ";
      default : _zz_43__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_45__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_45__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_45__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_45__string = "URS1        ";
      default : _zz_45__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_48__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_48__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_48__string = "BITWISE ";
      default : _zz_48__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_50_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_50__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_50__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_50__string = "AND_1";
      default : _zz_50__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_61_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_61__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_61__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_61__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_61__string = "SRA_1    ";
      default : _zz_61__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_63_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_63__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_63__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_63__string = "ECALL";
      default : _zz_63__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_65_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_65__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_65__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_65__string = "AND_1";
      default : _zz_65__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_69_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_69__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_69__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_69__string = "BITWISE ";
      default : _zz_69__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_70_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_70__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_70__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_70__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_70__string = "PC ";
      default : _zz_70__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_76_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_76__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_76__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_76__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_76__string = "URS1        ";
      default : _zz_76__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_79_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_79__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_79__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_79__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_79__string = "JALR";
      default : _zz_79__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_97_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_97__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_97__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_97__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_97__string = "JALR";
      default : _zz_97__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_144_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_144__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_144__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_144__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_144__string = "JALR";
      default : _zz_144__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_145_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_145__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_145__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_145__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_145__string = "URS1        ";
      default : _zz_145__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_146_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_146__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_146__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_146__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_146__string = "PC ";
      default : _zz_146__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_147_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_147__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_147__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_147__string = "BITWISE ";
      default : _zz_147__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_148_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_148__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_148__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_148__string = "AND_1";
      default : _zz_148__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_149_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_149__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_149__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_149__string = "ECALL";
      default : _zz_149__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_150_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_150__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_150__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_150__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_150__string = "SRA_1    ";
      default : _zz_150__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL";
      default : decode_to_execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL";
      default : execute_to_memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL";
      default : memory_to_writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  `endif

  assign decode_CSR_WRITE_OPCODE = _zz_29_;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = _zz_100_;
  assign decode_IS_CSR = _zz_60_;
  assign decode_DO_EBREAK = _zz_25_;
  assign decode_SRC1_CTRL = _zz_1_;
  assign _zz_2_ = _zz_3_;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_49_;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_91_;
  assign decode_SRC2_CTRL = _zz_4_;
  assign _zz_5_ = _zz_6_;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_58_;
  assign decode_SRC_LESS_UNSIGNED = _zz_74_;
  assign decode_ALU_CTRL = _zz_7_;
  assign _zz_8_ = _zz_9_;
  assign decode_IS_DIV = _zz_75_;
  assign decode_ALU_BITWISE_CTRL = _zz_10_;
  assign _zz_11_ = _zz_12_;
  assign decode_SRC2_FORCE_ZERO = _zz_47_;
  assign execute_BRANCH_CALC = _zz_31_;
  assign decode_MEMORY_STORE = _zz_73_;
  assign memory_MEMORY_READ_DATA = _zz_82_;
  assign _zz_13_ = _zz_14_;
  assign _zz_15_ = _zz_16_;
  assign decode_ENV_CTRL = _zz_17_;
  assign _zz_18_ = _zz_19_;
  assign decode_CSR_READ_OPCODE = _zz_28_;
  assign decode_SHIFT_CTRL = _zz_20_;
  assign _zz_21_ = _zz_22_;
  assign decode_IS_RS2_SIGNED = _zz_78_;
  assign execute_BRANCH_DO = _zz_32_;
  assign decode_IS_MUL = _zz_56_;
  assign _zz_23_ = _zz_24_;
  assign decode_IS_RS1_SIGNED = _zz_67_;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_64_;
  assign decode_PREDICTION_HAD_BRANCHED2 = _zz_35_;
  assign execute_DO_EBREAK = decode_to_execute_DO_EBREAK;
  assign decode_IS_EBREAK = _zz_72_;
  assign execute_IS_RS1_SIGNED = decode_to_execute_IS_RS1_SIGNED;
  assign execute_IS_DIV = decode_to_execute_IS_DIV;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign execute_IS_RS2_SIGNED = decode_to_execute_IS_RS2_SIGNED;
  assign memory_IS_DIV = execute_to_memory_IS_DIV;
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_26_;
  assign execute_ENV_CTRL = _zz_27_;
  assign writeBack_ENV_CTRL = _zz_30_;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_COND_RESULT = _zz_34_;
  assign execute_BRANCH_CTRL = _zz_33_;
  assign decode_RS2_USE = _zz_77_;
  assign decode_RS1_USE = _zz_59_;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  always @ (*) begin
    _zz_36_ = memory_REGFILE_WRITE_DATA;
    if(_zz_221_)begin
      _zz_36_ = ((memory_INSTRUCTION[13 : 12] == (2'b00)) ? memory_MulDivIterativePlugin_accumulator[31 : 0] : memory_MulDivIterativePlugin_accumulator[63 : 32]);
    end
    if(_zz_222_)begin
      _zz_36_ = memory_MulDivIterativePlugin_div_result;
    end
  end

  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = _zz_54_;
    if(_zz_163_)begin
      if((_zz_164_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_165_;
      end
    end
    if(_zz_223_)begin
      if(_zz_224_)begin
        if(_zz_167_)begin
          decode_RS2 = _zz_81_;
        end
      end
    end
    if(_zz_225_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_169_)begin
          decode_RS2 = _zz_36_;
        end
      end
    end
    if(_zz_226_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_171_)begin
          decode_RS2 = _zz_37_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = _zz_55_;
    if(_zz_163_)begin
      if((_zz_164_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_165_;
      end
    end
    if(_zz_223_)begin
      if(_zz_224_)begin
        if(_zz_166_)begin
          decode_RS1 = _zz_81_;
        end
      end
    end
    if(_zz_225_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_168_)begin
          decode_RS1 = _zz_36_;
        end
      end
    end
    if(_zz_226_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_170_)begin
          decode_RS1 = _zz_37_;
        end
      end
    end
  end

  always @ (*) begin
    _zz_37_ = execute_REGFILE_WRITE_DATA;
    if(_zz_227_)begin
      _zz_37_ = _zz_159_;
    end
    if(_zz_228_)begin
      _zz_37_ = execute_CsrPlugin_readData;
    end
  end

  assign execute_SHIFT_CTRL = _zz_38_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_42_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_43_;
  assign execute_SRC1_CTRL = _zz_45_;
  assign decode_SRC_USE_SUB_LESS = _zz_68_;
  assign decode_SRC_ADD_ZERO = _zz_71_;
  assign execute_SRC_ADD_SUB = _zz_41_;
  assign execute_SRC_LESS = _zz_39_;
  assign execute_ALU_CTRL = _zz_48_;
  assign execute_SRC2 = _zz_44_;
  assign execute_SRC1 = _zz_46_;
  assign execute_ALU_BITWISE_CTRL = _zz_50_;
  assign _zz_51_ = writeBack_INSTRUCTION;
  assign _zz_52_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_53_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_53_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = _zz_96_;
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_62_;
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = _zz_80_;
  assign decode_INSTRUCTION_READY = 1'b1;
  assign writeBack_MEMORY_STORE = memory_to_writeBack_MEMORY_STORE;
  always @ (*) begin
    _zz_81_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_81_ = writeBack_DBusSimplePlugin_rspFormated;
    end
  end

  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_READ_DATA = memory_to_writeBack_MEMORY_READ_DATA;
  assign memory_MMU_FAULT = execute_to_memory_MMU_FAULT;
  assign memory_MMU_RSP_physicalAddress = execute_to_memory_MMU_RSP_physicalAddress;
  assign memory_MMU_RSP_isIoAccess = execute_to_memory_MMU_RSP_isIoAccess;
  assign memory_MMU_RSP_allowRead = execute_to_memory_MMU_RSP_allowRead;
  assign memory_MMU_RSP_allowWrite = execute_to_memory_MMU_RSP_allowWrite;
  assign memory_MMU_RSP_allowExecute = execute_to_memory_MMU_RSP_allowExecute;
  assign memory_MMU_RSP_exception = execute_to_memory_MMU_RSP_exception;
  assign memory_MMU_RSP_refilling = execute_to_memory_MMU_RSP_refilling;
  assign memory_PC = execute_to_memory_PC;
  assign memory_ALIGNEMENT_FAULT = execute_to_memory_ALIGNEMENT_FAULT;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_STORE = execute_to_memory_MEMORY_STORE;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MMU_FAULT = _zz_90_;
  assign execute_MMU_RSP_physicalAddress = _zz_83_;
  assign execute_MMU_RSP_isIoAccess = _zz_84_;
  assign execute_MMU_RSP_allowRead = _zz_85_;
  assign execute_MMU_RSP_allowWrite = _zz_86_;
  assign execute_MMU_RSP_allowExecute = _zz_87_;
  assign execute_MMU_RSP_exception = _zz_88_;
  assign execute_MMU_RSP_refilling = _zz_89_;
  assign execute_SRC_ADD = _zz_40_;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_MEMORY_STORE = decode_to_execute_MEMORY_STORE;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_ALIGNEMENT_FAULT = _zz_92_;
  assign decode_MEMORY_ENABLE = _zz_66_;
  assign decode_FLUSH_ALL = _zz_57_;
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected = _zz_93_;
    if(_zz_229_)begin
      IBusCachedPlugin_rsp_issueDetected = 1'b1;
    end
  end

  always @ (*) begin
    _zz_93_ = _zz_94_;
    if(_zz_230_)begin
      _zz_93_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_94_ = _zz_95_;
    if(_zz_231_)begin
      _zz_94_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_95_ = 1'b0;
    if(_zz_232_)begin
      _zz_95_ = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_97_;
  assign decode_INSTRUCTION = _zz_101_;
  always @ (*) begin
    _zz_98_ = memory_FORMAL_PC_NEXT;
    if(DBusSimplePlugin_redoBranch_valid)begin
      _zz_98_ = DBusSimplePlugin_redoBranch_payload;
    end
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_98_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_99_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_99_ = IBusCachedPlugin_predictionJumpInterface_payload;
    end
    if(IBusCachedPlugin_redoBranch_valid)begin
      _zz_99_ = IBusCachedPlugin_redoBranch_payload;
    end
  end

  assign decode_PC = _zz_102_;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusSimplePlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
    case(_zz_205_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_haltItself = 1'b1;
      end
      3'b011 : begin
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && (_zz_160_ || _zz_161_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts))begin
      decode_arbitration_haltByOther = decode_arbitration_isValid;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(_zz_233_)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_redoBranch_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(_zz_233_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if(((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_130_)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_227_)begin
      if(_zz_234_)begin
        if(! execute_LightShifterPlugin_done) begin
          execute_arbitration_haltItself = 1'b1;
        end
      end
    end
    if(_zz_228_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_haltByOther = 1'b0;
    if(_zz_235_)begin
      execute_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_flushIt = 1'b0;
    if(_zz_235_)begin
      if(_zz_236_)begin
        execute_arbitration_flushIt = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
    if(_zz_235_)begin
      if(_zz_236_)begin
        execute_arbitration_flushNext = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if((((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (! memory_MEMORY_STORE)) && ((! dBus_rsp_ready) || 1'b0)))begin
      memory_arbitration_haltItself = 1'b1;
    end
    if(_zz_221_)begin
      if(_zz_237_)begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
    if(_zz_222_)begin
      if(_zz_238_)begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(_zz_239_)begin
      memory_arbitration_removeIt = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_flushIt = 1'b0;
    if(DBusSimplePlugin_redoBranch_valid)begin
      memory_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(DBusSimplePlugin_redoBranch_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
    if(_zz_239_)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  assign writeBack_arbitration_haltItself = 1'b0;
  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  assign writeBack_arbitration_flushIt = 1'b0;
  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(_zz_240_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_241_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusCachedPlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_240_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_241_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_235_)begin
      if(_zz_236_)begin
        IBusCachedPlugin_fetcherHalt = 1'b1;
      end
    end
    if(DebugPlugin_haltIt)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_242_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetcherflushIt = 1'b0;
    if(({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
    if((IBusCachedPlugin_predictionJumpInterface_valid && decode_arbitration_isFiring))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
    if(_zz_235_)begin
      if(_zz_236_)begin
        IBusCachedPlugin_fetcherflushIt = 1'b1;
      end
    end
  end

  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_240_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_241_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_240_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_241_)begin
      case(_zz_243_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    CsrPlugin_forceMachineWire = 1'b0;
    if(DebugPlugin_godmode)begin
      CsrPlugin_forceMachineWire = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_allowInterrupts = 1'b1;
    if((DebugPlugin_haltIt || DebugPlugin_stepIt))begin
      CsrPlugin_allowInterrupts = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_allowException = 1'b1;
    if(DebugPlugin_godmode)begin
      CsrPlugin_allowException = 1'b0;
    end
  end

  assign IBusCachedPlugin_jump_pcLoad_valid = ({CsrPlugin_jumpInterface_valid,{BranchPlugin_jumpInterface_valid,{DBusSimplePlugin_redoBranch_valid,{IBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}}} != (5'b00000));
  assign _zz_103_ = {IBusCachedPlugin_predictionJumpInterface_valid,{IBusCachedPlugin_redoBranch_valid,{BranchPlugin_jumpInterface_valid,{DBusSimplePlugin_redoBranch_valid,CsrPlugin_jumpInterface_valid}}}};
  assign _zz_104_ = (_zz_103_ & (~ _zz_264_));
  assign _zz_105_ = _zz_104_[3];
  assign _zz_106_ = _zz_104_[4];
  assign _zz_107_ = (_zz_104_[1] || _zz_105_);
  assign _zz_108_ = (_zz_104_[2] || _zz_105_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_220_;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_corrected = 1'b0;
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_corrected = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_266_);
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_inputSample = 1'b1;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_109_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_109_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_109_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_110_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_110_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_110_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt = 1'b1;
    end
  end

  assign _zz_111_ = (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready && _zz_111_);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid && _zz_111_);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload = IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_112_;
  assign _zz_112_ = ((1'b0 && (! _zz_113_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_113_ = _zz_114_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_113_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_115_)) || IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready);
  assign _zz_115_ = _zz_116_;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid = _zz_115_;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload = _zz_117_;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((! IBusCachedPlugin_pcValids_0))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_decodeInput_ready = (! decode_arbitration_isStuck);
  always @ (*) begin
    decode_arbitration_isValid = (IBusCachedPlugin_iBusRsp_decodeInput_valid && (! IBusCachedPlugin_injector_decodeRemoved));
    case(_zz_205_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b011 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_102_ = IBusCachedPlugin_iBusRsp_decodeInput_payload_pc;
  assign _zz_101_ = IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst;
  assign _zz_100_ = (decode_PC + (32'b00000000000000000000000000000100));
  assign _zz_118_ = _zz_267_[11];
  always @ (*) begin
    _zz_119_[18] = _zz_118_;
    _zz_119_[17] = _zz_118_;
    _zz_119_[16] = _zz_118_;
    _zz_119_[15] = _zz_118_;
    _zz_119_[14] = _zz_118_;
    _zz_119_[13] = _zz_118_;
    _zz_119_[12] = _zz_118_;
    _zz_119_[11] = _zz_118_;
    _zz_119_[10] = _zz_118_;
    _zz_119_[9] = _zz_118_;
    _zz_119_[8] = _zz_118_;
    _zz_119_[7] = _zz_118_;
    _zz_119_[6] = _zz_118_;
    _zz_119_[5] = _zz_118_;
    _zz_119_[4] = _zz_118_;
    _zz_119_[3] = _zz_118_;
    _zz_119_[2] = _zz_118_;
    _zz_119_[1] = _zz_118_;
    _zz_119_[0] = _zz_118_;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_268_[31]));
    if(_zz_124_)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_120_ = _zz_269_[19];
  always @ (*) begin
    _zz_121_[10] = _zz_120_;
    _zz_121_[9] = _zz_120_;
    _zz_121_[8] = _zz_120_;
    _zz_121_[7] = _zz_120_;
    _zz_121_[6] = _zz_120_;
    _zz_121_[5] = _zz_120_;
    _zz_121_[4] = _zz_120_;
    _zz_121_[3] = _zz_120_;
    _zz_121_[2] = _zz_120_;
    _zz_121_[1] = _zz_120_;
    _zz_121_[0] = _zz_120_;
  end

  assign _zz_122_ = _zz_270_[11];
  always @ (*) begin
    _zz_123_[18] = _zz_122_;
    _zz_123_[17] = _zz_122_;
    _zz_123_[16] = _zz_122_;
    _zz_123_[15] = _zz_122_;
    _zz_123_[14] = _zz_122_;
    _zz_123_[13] = _zz_122_;
    _zz_123_[12] = _zz_122_;
    _zz_123_[11] = _zz_122_;
    _zz_123_[10] = _zz_122_;
    _zz_123_[9] = _zz_122_;
    _zz_123_[8] = _zz_122_;
    _zz_123_[7] = _zz_122_;
    _zz_123_[6] = _zz_122_;
    _zz_123_[5] = _zz_122_;
    _zz_123_[4] = _zz_122_;
    _zz_123_[3] = _zz_122_;
    _zz_123_[2] = _zz_122_;
    _zz_123_[1] = _zz_122_;
    _zz_123_[0] = _zz_122_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_124_ = _zz_271_[1];
      end
      default : begin
        _zz_124_ = _zz_272_[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_125_ = _zz_273_[19];
  always @ (*) begin
    _zz_126_[10] = _zz_125_;
    _zz_126_[9] = _zz_125_;
    _zz_126_[8] = _zz_125_;
    _zz_126_[7] = _zz_125_;
    _zz_126_[6] = _zz_125_;
    _zz_126_[5] = _zz_125_;
    _zz_126_[4] = _zz_125_;
    _zz_126_[3] = _zz_125_;
    _zz_126_[2] = _zz_125_;
    _zz_126_[1] = _zz_125_;
    _zz_126_[0] = _zz_125_;
  end

  assign _zz_127_ = _zz_274_[11];
  always @ (*) begin
    _zz_128_[18] = _zz_127_;
    _zz_128_[17] = _zz_127_;
    _zz_128_[16] = _zz_127_;
    _zz_128_[15] = _zz_127_;
    _zz_128_[14] = _zz_127_;
    _zz_128_[13] = _zz_127_;
    _zz_128_[12] = _zz_127_;
    _zz_128_[11] = _zz_127_;
    _zz_128_[10] = _zz_127_;
    _zz_128_[9] = _zz_127_;
    _zz_128_[8] = _zz_127_;
    _zz_128_[7] = _zz_127_;
    _zz_128_[6] = _zz_127_;
    _zz_128_[5] = _zz_127_;
    _zz_128_[4] = _zz_127_;
    _zz_128_[3] = _zz_127_;
    _zz_128_[2] = _zz_127_;
    _zz_128_[1] = _zz_127_;
    _zz_128_[0] = _zz_127_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_126_,{{{_zz_355_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_128_,{{{_zz_356_,_zz_357_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_210_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_213_ = (32'b00000000000000000000000000000000);
  assign _zz_211_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_212_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_214_ = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_215_ = (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready);
  assign _zz_216_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_96_ = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_232_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_230_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_244_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b0;
    end
  end

  always @ (*) begin
    _zz_217_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_230_)begin
      _zz_217_ = 1'b1;
    end
    if(_zz_244_)begin
      _zz_217_ = 1'b0;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_231_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_229_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_231_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_229_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b0001);
    end
  end

  assign IBusCachedPlugin_decodeExceptionPort_payload_badAddr = {IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload[31 : 2],(2'b00)};
  assign IBusCachedPlugin_redoBranch_valid = IBusCachedPlugin_rsp_redoFetch;
  assign IBusCachedPlugin_redoBranch_payload = IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  assign IBusCachedPlugin_iBusRsp_decodeInput_valid = IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready = IBusCachedPlugin_iBusRsp_decodeInput_ready;
  assign IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_decodeInput_payload_pc = IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload;
  assign IBusCachedPlugin_mmuBus_cmd_isValid = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_virtualAddress = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_cmd_bypassTranslation = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  assign IBusCachedPlugin_mmuBus_end = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  assign _zz_209_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign _zz_130_ = 1'b0;
  assign _zz_92_ = (((dBus_cmd_payload_size == (2'b10)) && (dBus_cmd_payload_address[1 : 0] != (2'b00))) || ((dBus_cmd_payload_size == (2'b01)) && (dBus_cmd_payload_address[0 : 0] != (1'b0))));
  always @ (*) begin
    execute_DBusSimplePlugin_skipCmd = 1'b0;
    if(execute_ALIGNEMENT_FAULT)begin
      execute_DBusSimplePlugin_skipCmd = 1'b1;
    end
    if((execute_MMU_FAULT || execute_MMU_RSP_refilling))begin
      execute_DBusSimplePlugin_skipCmd = 1'b1;
    end
  end

  assign dBus_cmd_valid = (((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_isFlushed)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_130_));
  assign dBus_cmd_payload_wr = execute_MEMORY_STORE;
  assign dBus_cmd_payload_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_131_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_131_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_131_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dBus_cmd_payload_data = _zz_131_;
  assign _zz_91_ = dBus_cmd_payload_address[1 : 0];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_132_ = (4'b0001);
      end
      2'b01 : begin
        _zz_132_ = (4'b0011);
      end
      default : begin
        _zz_132_ = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_132_ <<< dBus_cmd_payload_address[1 : 0]);
  assign DBusSimplePlugin_mmuBus_cmd_isValid = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign DBusSimplePlugin_mmuBus_cmd_virtualAddress = execute_SRC_ADD;
  assign DBusSimplePlugin_mmuBus_cmd_bypassTranslation = 1'b0;
  assign DBusSimplePlugin_mmuBus_end = ((! execute_arbitration_isStuck) || execute_arbitration_removeIt);
  assign dBus_cmd_payload_address = DBusSimplePlugin_mmuBus_rsp_physicalAddress;
  assign _zz_90_ = ((execute_MMU_RSP_exception || ((! execute_MMU_RSP_allowWrite) && execute_MEMORY_STORE)) || ((! execute_MMU_RSP_allowRead) && (! execute_MEMORY_STORE)));
  assign _zz_83_ = DBusSimplePlugin_mmuBus_rsp_physicalAddress;
  assign _zz_84_ = DBusSimplePlugin_mmuBus_rsp_isIoAccess;
  assign _zz_85_ = DBusSimplePlugin_mmuBus_rsp_allowRead;
  assign _zz_86_ = DBusSimplePlugin_mmuBus_rsp_allowWrite;
  assign _zz_87_ = DBusSimplePlugin_mmuBus_rsp_allowExecute;
  assign _zz_88_ = DBusSimplePlugin_mmuBus_rsp_exception;
  assign _zz_89_ = DBusSimplePlugin_mmuBus_rsp_refilling;
  assign _zz_82_ = dBus_rsp_data;
  always @ (*) begin
    DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    if(_zz_245_)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b1;
    end
    if(memory_ALIGNEMENT_FAULT)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b1;
    end
    if(memory_MMU_RSP_refilling)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    end else begin
      if(memory_MMU_FAULT)begin
        DBusSimplePlugin_memoryExceptionPort_valid = 1'b1;
      end
    end
    if(_zz_246_)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    end
  end

  always @ (*) begin
    DBusSimplePlugin_memoryExceptionPort_payload_code = (4'bxxxx);
    if(_zz_245_)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = (4'b0101);
    end
    if(memory_ALIGNEMENT_FAULT)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = {1'd0, _zz_275_};
    end
    if(! memory_MMU_RSP_refilling) begin
      if(memory_MMU_FAULT)begin
        DBusSimplePlugin_memoryExceptionPort_payload_code = (memory_MEMORY_STORE ? (4'b1111) : (4'b1101));
      end
    end
  end

  assign DBusSimplePlugin_memoryExceptionPort_payload_badAddr = memory_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusSimplePlugin_redoBranch_valid = 1'b0;
    if(memory_MMU_RSP_refilling)begin
      DBusSimplePlugin_redoBranch_valid = 1'b1;
    end
    if(_zz_246_)begin
      DBusSimplePlugin_redoBranch_valid = 1'b0;
    end
  end

  assign DBusSimplePlugin_redoBranch_payload = memory_PC;
  always @ (*) begin
    writeBack_DBusSimplePlugin_rspShifted = writeBack_MEMORY_READ_DATA;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusSimplePlugin_rspShifted[15 : 0] = writeBack_MEMORY_READ_DATA[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_133_ = (writeBack_DBusSimplePlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_134_[31] = _zz_133_;
    _zz_134_[30] = _zz_133_;
    _zz_134_[29] = _zz_133_;
    _zz_134_[28] = _zz_133_;
    _zz_134_[27] = _zz_133_;
    _zz_134_[26] = _zz_133_;
    _zz_134_[25] = _zz_133_;
    _zz_134_[24] = _zz_133_;
    _zz_134_[23] = _zz_133_;
    _zz_134_[22] = _zz_133_;
    _zz_134_[21] = _zz_133_;
    _zz_134_[20] = _zz_133_;
    _zz_134_[19] = _zz_133_;
    _zz_134_[18] = _zz_133_;
    _zz_134_[17] = _zz_133_;
    _zz_134_[16] = _zz_133_;
    _zz_134_[15] = _zz_133_;
    _zz_134_[14] = _zz_133_;
    _zz_134_[13] = _zz_133_;
    _zz_134_[12] = _zz_133_;
    _zz_134_[11] = _zz_133_;
    _zz_134_[10] = _zz_133_;
    _zz_134_[9] = _zz_133_;
    _zz_134_[8] = _zz_133_;
    _zz_134_[7 : 0] = writeBack_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_135_ = (writeBack_DBusSimplePlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_136_[31] = _zz_135_;
    _zz_136_[30] = _zz_135_;
    _zz_136_[29] = _zz_135_;
    _zz_136_[28] = _zz_135_;
    _zz_136_[27] = _zz_135_;
    _zz_136_[26] = _zz_135_;
    _zz_136_[25] = _zz_135_;
    _zz_136_[24] = _zz_135_;
    _zz_136_[23] = _zz_135_;
    _zz_136_[22] = _zz_135_;
    _zz_136_[21] = _zz_135_;
    _zz_136_[20] = _zz_135_;
    _zz_136_[19] = _zz_135_;
    _zz_136_[18] = _zz_135_;
    _zz_136_[17] = _zz_135_;
    _zz_136_[16] = _zz_135_;
    _zz_136_[15 : 0] = writeBack_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_262_)
      2'b00 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_134_;
      end
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_136_;
      end
      default : begin
        writeBack_DBusSimplePlugin_rspFormated = writeBack_DBusSimplePlugin_rspShifted;
      end
    endcase
  end

  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = IBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusSimplePlugin_mmuBus_rsp_physicalAddress = DBusSimplePlugin_mmuBus_cmd_virtualAddress;
  assign DBusSimplePlugin_mmuBus_rsp_allowRead = 1'b1;
  assign DBusSimplePlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign DBusSimplePlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign DBusSimplePlugin_mmuBus_rsp_isIoAccess = DBusSimplePlugin_mmuBus_rsp_physicalAddress[31];
  assign DBusSimplePlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusSimplePlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusSimplePlugin_mmuBus_busy = 1'b0;
  assign _zz_138_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001000)) == (32'b00000000000000000000000001001000));
  assign _zz_139_ = ((decode_INSTRUCTION & (32'b00000000000000000111000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_140_ = ((decode_INSTRUCTION & (32'b00000000000000000101000000000000)) == (32'b00000000000000000100000000000000));
  assign _zz_141_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_142_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_143_ = ((decode_INSTRUCTION & (32'b00000000000000000011000000000000)) == (32'b00000000000000000010000000000000));
  assign _zz_137_ = {(((decode_INSTRUCTION & _zz_358_) == (32'b00000010000000000000000000110000)) != (1'b0)),{((_zz_359_ == _zz_360_) != (1'b0)),{(_zz_361_ != (1'b0)),{(_zz_362_ != _zz_363_),{_zz_364_,{_zz_365_,_zz_366_}}}}}};
  assign _zz_80_ = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_514_) == (32'b00000000000000000001000001110011)),{(_zz_515_ == _zz_516_),{_zz_517_,{_zz_518_,_zz_519_}}}}}}} != (20'b00000000000000000000));
  assign _zz_144_ = _zz_137_[1 : 0];
  assign _zz_79_ = _zz_144_;
  assign _zz_78_ = _zz_276_[0];
  assign _zz_77_ = _zz_277_[0];
  assign _zz_145_ = _zz_137_[5 : 4];
  assign _zz_76_ = _zz_145_;
  assign _zz_75_ = _zz_278_[0];
  assign _zz_74_ = _zz_279_[0];
  assign _zz_73_ = _zz_280_[0];
  assign _zz_72_ = _zz_281_[0];
  assign _zz_71_ = _zz_282_[0];
  assign _zz_146_ = _zz_137_[12 : 11];
  assign _zz_70_ = _zz_146_;
  assign _zz_147_ = _zz_137_[14 : 13];
  assign _zz_69_ = _zz_147_;
  assign _zz_68_ = _zz_283_[0];
  assign _zz_67_ = _zz_284_[0];
  assign _zz_66_ = _zz_285_[0];
  assign _zz_148_ = _zz_137_[19 : 18];
  assign _zz_65_ = _zz_148_;
  assign _zz_64_ = _zz_286_[0];
  assign _zz_149_ = _zz_137_[23 : 22];
  assign _zz_63_ = _zz_149_;
  assign _zz_62_ = _zz_287_[0];
  assign _zz_150_ = _zz_137_[26 : 25];
  assign _zz_61_ = _zz_150_;
  assign _zz_60_ = _zz_288_[0];
  assign _zz_59_ = _zz_289_[0];
  assign _zz_58_ = _zz_290_[0];
  assign _zz_57_ = _zz_291_[0];
  assign _zz_56_ = _zz_292_[0];
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_218_;
  assign decode_RegFilePlugin_rs2Data = _zz_219_;
  assign _zz_55_ = decode_RegFilePlugin_rs1Data;
  assign _zz_54_ = decode_RegFilePlugin_rs2Data;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_52_ && writeBack_arbitration_isFiring);
    if(_zz_151_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_51_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_81_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_152_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_152_ = {31'd0, _zz_293_};
      end
      default : begin
        _zz_152_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign _zz_49_ = _zz_152_;
  assign _zz_47_ = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_153_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_153_ = {29'd0, _zz_294_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_153_ = {execute_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_153_ = {27'd0, _zz_295_};
      end
    endcase
  end

  assign _zz_46_ = _zz_153_;
  assign _zz_154_ = _zz_296_[11];
  always @ (*) begin
    _zz_155_[19] = _zz_154_;
    _zz_155_[18] = _zz_154_;
    _zz_155_[17] = _zz_154_;
    _zz_155_[16] = _zz_154_;
    _zz_155_[15] = _zz_154_;
    _zz_155_[14] = _zz_154_;
    _zz_155_[13] = _zz_154_;
    _zz_155_[12] = _zz_154_;
    _zz_155_[11] = _zz_154_;
    _zz_155_[10] = _zz_154_;
    _zz_155_[9] = _zz_154_;
    _zz_155_[8] = _zz_154_;
    _zz_155_[7] = _zz_154_;
    _zz_155_[6] = _zz_154_;
    _zz_155_[5] = _zz_154_;
    _zz_155_[4] = _zz_154_;
    _zz_155_[3] = _zz_154_;
    _zz_155_[2] = _zz_154_;
    _zz_155_[1] = _zz_154_;
    _zz_155_[0] = _zz_154_;
  end

  assign _zz_156_ = _zz_297_[11];
  always @ (*) begin
    _zz_157_[19] = _zz_156_;
    _zz_157_[18] = _zz_156_;
    _zz_157_[17] = _zz_156_;
    _zz_157_[16] = _zz_156_;
    _zz_157_[15] = _zz_156_;
    _zz_157_[14] = _zz_156_;
    _zz_157_[13] = _zz_156_;
    _zz_157_[12] = _zz_156_;
    _zz_157_[11] = _zz_156_;
    _zz_157_[10] = _zz_156_;
    _zz_157_[9] = _zz_156_;
    _zz_157_[8] = _zz_156_;
    _zz_157_[7] = _zz_156_;
    _zz_157_[6] = _zz_156_;
    _zz_157_[5] = _zz_156_;
    _zz_157_[4] = _zz_156_;
    _zz_157_[3] = _zz_156_;
    _zz_157_[2] = _zz_156_;
    _zz_157_[1] = _zz_156_;
    _zz_157_[0] = _zz_156_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_158_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_158_ = {_zz_155_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_158_ = {_zz_157_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_158_ = _zz_42_;
      end
    endcase
  end

  assign _zz_44_ = _zz_158_;
  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_298_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign _zz_41_ = execute_SrcPlugin_addSub;
  assign _zz_40_ = execute_SrcPlugin_addSub;
  assign _zz_39_ = execute_SrcPlugin_less;
  assign execute_LightShifterPlugin_isShift = (execute_SHIFT_CTRL != `ShiftCtrlEnum_defaultEncoding_DISABLE_1);
  assign execute_LightShifterPlugin_amplitude = (execute_LightShifterPlugin_isActive ? execute_LightShifterPlugin_amplitudeReg : execute_SRC2[4 : 0]);
  assign execute_LightShifterPlugin_shiftInput = (execute_LightShifterPlugin_isActive ? memory_REGFILE_WRITE_DATA : execute_SRC1);
  assign execute_LightShifterPlugin_done = (execute_LightShifterPlugin_amplitude[4 : 1] == (4'b0000));
  always @ (*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
        _zz_159_ = (execute_LightShifterPlugin_shiftInput <<< 1);
      end
      default : begin
        _zz_159_ = _zz_305_;
      end
    endcase
  end

  always @ (*) begin
    _zz_160_ = 1'b0;
    if(_zz_247_)begin
      if(_zz_248_)begin
        if(_zz_166_)begin
          _zz_160_ = 1'b1;
        end
      end
    end
    if(_zz_249_)begin
      if(_zz_250_)begin
        if(_zz_168_)begin
          _zz_160_ = 1'b1;
        end
      end
    end
    if(_zz_251_)begin
      if(_zz_252_)begin
        if(_zz_170_)begin
          _zz_160_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_160_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_161_ = 1'b0;
    if(_zz_247_)begin
      if(_zz_248_)begin
        if(_zz_167_)begin
          _zz_161_ = 1'b1;
        end
      end
    end
    if(_zz_249_)begin
      if(_zz_250_)begin
        if(_zz_169_)begin
          _zz_161_ = 1'b1;
        end
      end
    end
    if(_zz_251_)begin
      if(_zz_252_)begin
        if(_zz_171_)begin
          _zz_161_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_161_ = 1'b0;
    end
  end

  assign _zz_162_ = (_zz_52_ && writeBack_arbitration_isFiring);
  assign _zz_166_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_167_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_168_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_169_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_170_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_171_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_35_ = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_172_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_172_ == (3'b000))) begin
        _zz_173_ = execute_BranchPlugin_eq;
    end else if((_zz_172_ == (3'b001))) begin
        _zz_173_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_172_ & (3'b101)) == (3'b101)))) begin
        _zz_173_ = (! execute_SRC_LESS);
    end else begin
        _zz_173_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_174_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_174_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_174_ = 1'b1;
      end
      default : begin
        _zz_174_ = _zz_173_;
      end
    endcase
  end

  assign _zz_34_ = _zz_174_;
  assign _zz_175_ = _zz_307_[11];
  always @ (*) begin
    _zz_176_[19] = _zz_175_;
    _zz_176_[18] = _zz_175_;
    _zz_176_[17] = _zz_175_;
    _zz_176_[16] = _zz_175_;
    _zz_176_[15] = _zz_175_;
    _zz_176_[14] = _zz_175_;
    _zz_176_[13] = _zz_175_;
    _zz_176_[12] = _zz_175_;
    _zz_176_[11] = _zz_175_;
    _zz_176_[10] = _zz_175_;
    _zz_176_[9] = _zz_175_;
    _zz_176_[8] = _zz_175_;
    _zz_176_[7] = _zz_175_;
    _zz_176_[6] = _zz_175_;
    _zz_176_[5] = _zz_175_;
    _zz_176_[4] = _zz_175_;
    _zz_176_[3] = _zz_175_;
    _zz_176_[2] = _zz_175_;
    _zz_176_[1] = _zz_175_;
    _zz_176_[0] = _zz_175_;
  end

  assign _zz_177_ = _zz_308_[19];
  always @ (*) begin
    _zz_178_[10] = _zz_177_;
    _zz_178_[9] = _zz_177_;
    _zz_178_[8] = _zz_177_;
    _zz_178_[7] = _zz_177_;
    _zz_178_[6] = _zz_177_;
    _zz_178_[5] = _zz_177_;
    _zz_178_[4] = _zz_177_;
    _zz_178_[3] = _zz_177_;
    _zz_178_[2] = _zz_177_;
    _zz_178_[1] = _zz_177_;
    _zz_178_[0] = _zz_177_;
  end

  assign _zz_179_ = _zz_309_[11];
  always @ (*) begin
    _zz_180_[18] = _zz_179_;
    _zz_180_[17] = _zz_179_;
    _zz_180_[16] = _zz_179_;
    _zz_180_[15] = _zz_179_;
    _zz_180_[14] = _zz_179_;
    _zz_180_[13] = _zz_179_;
    _zz_180_[12] = _zz_179_;
    _zz_180_[11] = _zz_179_;
    _zz_180_[10] = _zz_179_;
    _zz_180_[9] = _zz_179_;
    _zz_180_[8] = _zz_179_;
    _zz_180_[7] = _zz_179_;
    _zz_180_[6] = _zz_179_;
    _zz_180_[5] = _zz_179_;
    _zz_180_[4] = _zz_179_;
    _zz_180_[3] = _zz_179_;
    _zz_180_[2] = _zz_179_;
    _zz_180_[1] = _zz_179_;
    _zz_180_[0] = _zz_179_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_181_ = (_zz_310_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_181_ = _zz_311_[1];
      end
      default : begin
        _zz_181_ = _zz_312_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_181_);
  assign _zz_32_ = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_182_ = _zz_313_[11];
  always @ (*) begin
    _zz_183_[19] = _zz_182_;
    _zz_183_[18] = _zz_182_;
    _zz_183_[17] = _zz_182_;
    _zz_183_[16] = _zz_182_;
    _zz_183_[15] = _zz_182_;
    _zz_183_[14] = _zz_182_;
    _zz_183_[13] = _zz_182_;
    _zz_183_[12] = _zz_182_;
    _zz_183_[11] = _zz_182_;
    _zz_183_[10] = _zz_182_;
    _zz_183_[9] = _zz_182_;
    _zz_183_[8] = _zz_182_;
    _zz_183_[7] = _zz_182_;
    _zz_183_[6] = _zz_182_;
    _zz_183_[5] = _zz_182_;
    _zz_183_[4] = _zz_182_;
    _zz_183_[3] = _zz_182_;
    _zz_183_[2] = _zz_182_;
    _zz_183_[1] = _zz_182_;
    _zz_183_[0] = _zz_182_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_183_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_185_,{{{_zz_532_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_187_,{{{_zz_533_,_zz_534_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_316_};
        end
      end
    endcase
  end

  assign _zz_184_ = _zz_314_[19];
  always @ (*) begin
    _zz_185_[10] = _zz_184_;
    _zz_185_[9] = _zz_184_;
    _zz_185_[8] = _zz_184_;
    _zz_185_[7] = _zz_184_;
    _zz_185_[6] = _zz_184_;
    _zz_185_[5] = _zz_184_;
    _zz_185_[4] = _zz_184_;
    _zz_185_[3] = _zz_184_;
    _zz_185_[2] = _zz_184_;
    _zz_185_[1] = _zz_184_;
    _zz_185_[0] = _zz_184_;
  end

  assign _zz_186_ = _zz_315_[11];
  always @ (*) begin
    _zz_187_[18] = _zz_186_;
    _zz_187_[17] = _zz_186_;
    _zz_187_[16] = _zz_186_;
    _zz_187_[15] = _zz_186_;
    _zz_187_[14] = _zz_186_;
    _zz_187_[13] = _zz_186_;
    _zz_187_[12] = _zz_186_;
    _zz_187_[11] = _zz_186_;
    _zz_187_[10] = _zz_186_;
    _zz_187_[9] = _zz_186_;
    _zz_187_[8] = _zz_186_;
    _zz_187_[7] = _zz_186_;
    _zz_187_[6] = _zz_186_;
    _zz_187_[5] = _zz_186_;
    _zz_187_[4] = _zz_186_;
    _zz_187_[3] = _zz_186_;
    _zz_187_[2] = _zz_186_;
    _zz_187_[1] = _zz_186_;
    _zz_187_[0] = _zz_186_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign _zz_31_ = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign BranchPlugin_branchExceptionPort_valid = (memory_arbitration_isValid && (memory_BRANCH_DO && memory_BRANCH_CALC[1]));
  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  always @ (*) begin
    CsrPlugin_privilege = (2'b11);
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = (26'b00000000000000000001000010);
  assign _zz_188_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_189_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_190_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_191_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_192_ = _zz_317_[0];
  assign _zz_193_ = {BranchPlugin_branchExceptionPort_valid,DBusSimplePlugin_memoryExceptionPort_valid};
  assign _zz_194_ = _zz_319_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_233_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(_zz_239_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  assign CsrPlugin_lastStageWasWfi = 1'b0;
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusCachedPlugin_pcValids_3);
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = (30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign _zz_29_ = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign _zz_28_ = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  assign execute_CsrPlugin_inWfi = 1'b0;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000101 : begin
        if(execute_CSR_WRITE_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000011 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b111111000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000010 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      default : begin
      end
    endcase
    if((CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]))begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_valid = 1'b0;
    if(_zz_253_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_253_)begin
      case(CsrPlugin_privilege)
        2'b00 : begin
          CsrPlugin_selfException_payload_code = (4'b1000);
        end
        default : begin
          CsrPlugin_selfException_payload_code = (4'b1011);
        end
      endcase
    end
  end

  assign CsrPlugin_selfException_payload_badAddr = execute_INSTRUCTION;
  always @ (*) begin
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_202_;
      end
      12'b001100000000 : begin
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mepc;
      end
      12'b001100000101 : begin
      end
      12'b001101000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
      end
      12'b001101000011 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mtval;
      end
      12'b111111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_203_;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
      end
      12'b001101000010 : begin
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_mcause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_mcause_exceptionCode;
      end
      default : begin
      end
    endcase
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_263_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  always @ (*) begin
    memory_MulDivIterativePlugin_mul_counter_willIncrement = 1'b0;
    if(_zz_221_)begin
      if(_zz_237_)begin
        memory_MulDivIterativePlugin_mul_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_MulDivIterativePlugin_mul_counter_willClear = 1'b0;
    if((! memory_arbitration_isStuck))begin
      memory_MulDivIterativePlugin_mul_counter_willClear = 1'b1;
    end
  end

  assign memory_MulDivIterativePlugin_mul_willOverflowIfInc = (memory_MulDivIterativePlugin_mul_counter_value == (6'b100000));
  assign memory_MulDivIterativePlugin_mul_counter_willOverflow = (memory_MulDivIterativePlugin_mul_willOverflowIfInc && memory_MulDivIterativePlugin_mul_counter_willIncrement);
  always @ (*) begin
    if(memory_MulDivIterativePlugin_mul_counter_willOverflow)begin
      memory_MulDivIterativePlugin_mul_counter_valueNext = (6'b000000);
    end else begin
      memory_MulDivIterativePlugin_mul_counter_valueNext = (memory_MulDivIterativePlugin_mul_counter_value + _zz_322_);
    end
    if(memory_MulDivIterativePlugin_mul_counter_willClear)begin
      memory_MulDivIterativePlugin_mul_counter_valueNext = (6'b000000);
    end
  end

  always @ (*) begin
    memory_MulDivIterativePlugin_div_counter_willIncrement = 1'b0;
    if(_zz_222_)begin
      if(_zz_238_)begin
        memory_MulDivIterativePlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_MulDivIterativePlugin_div_counter_willClear = 1'b0;
    if(_zz_254_)begin
      memory_MulDivIterativePlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_MulDivIterativePlugin_div_counter_willOverflowIfInc = (memory_MulDivIterativePlugin_div_counter_value == (6'b100001));
  assign memory_MulDivIterativePlugin_div_counter_willOverflow = (memory_MulDivIterativePlugin_div_counter_willOverflowIfInc && memory_MulDivIterativePlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_MulDivIterativePlugin_div_counter_willOverflow)begin
      memory_MulDivIterativePlugin_div_counter_valueNext = (6'b000000);
    end else begin
      memory_MulDivIterativePlugin_div_counter_valueNext = (memory_MulDivIterativePlugin_div_counter_value + _zz_330_);
    end
    if(memory_MulDivIterativePlugin_div_counter_willClear)begin
      memory_MulDivIterativePlugin_div_counter_valueNext = (6'b000000);
    end
  end

  assign _zz_195_ = memory_MulDivIterativePlugin_rs1[31 : 0];
  assign _zz_196_ = {memory_MulDivIterativePlugin_accumulator[31 : 0],_zz_195_[31]};
  assign _zz_197_ = (_zz_196_ - _zz_331_);
  assign _zz_198_ = (memory_INSTRUCTION[13] ? memory_MulDivIterativePlugin_accumulator[31 : 0] : memory_MulDivIterativePlugin_rs1[31 : 0]);
  assign _zz_199_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_200_ = ((execute_IS_MUL && _zz_199_) || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_201_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_201_[31 : 0] = execute_RS1;
  end

  assign _zz_203_ = (_zz_202_ & externalInterruptArray_regNext);
  assign externalInterrupt = (_zz_203_ != (32'b00000000000000000000000000000000));
  always @ (*) begin
    debug_bus_cmd_ready = 1'b1;
    if(debug_bus_cmd_valid)begin
      case(_zz_255_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            debug_bus_cmd_ready = IBusCachedPlugin_injectionPort_ready;
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    debug_bus_rsp_data = DebugPlugin_busReadDataReg;
    if((! _zz_204_))begin
      debug_bus_rsp_data[0] = DebugPlugin_resetIt;
      debug_bus_rsp_data[1] = DebugPlugin_haltIt;
      debug_bus_rsp_data[2] = DebugPlugin_isPipBusy;
      debug_bus_rsp_data[3] = DebugPlugin_haltedByBreak;
      debug_bus_rsp_data[4] = DebugPlugin_stepIt;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_injectionPort_valid = 1'b0;
    if(debug_bus_cmd_valid)begin
      case(_zz_255_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            IBusCachedPlugin_injectionPort_valid = 1'b1;
          end
        end
        default : begin
        end
      endcase
    end
  end

  assign IBusCachedPlugin_injectionPort_payload = debug_bus_cmd_payload_data;
  assign _zz_25_ = ((! DebugPlugin_haltIt) && (decode_IS_EBREAK || 1'b0));
  assign debug_resetOut = DebugPlugin_resetIt_regNext;
  assign _zz_24_ = decode_BRANCH_CTRL;
  assign _zz_97_ = _zz_79_;
  assign _zz_33_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_22_ = decode_SHIFT_CTRL;
  assign _zz_20_ = _zz_61_;
  assign _zz_38_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_19_ = decode_ENV_CTRL;
  assign _zz_16_ = execute_ENV_CTRL;
  assign _zz_14_ = memory_ENV_CTRL;
  assign _zz_17_ = _zz_63_;
  assign _zz_27_ = decode_to_execute_ENV_CTRL;
  assign _zz_26_ = execute_to_memory_ENV_CTRL;
  assign _zz_30_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_12_ = decode_ALU_BITWISE_CTRL;
  assign _zz_10_ = _zz_65_;
  assign _zz_50_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_9_ = decode_ALU_CTRL;
  assign _zz_7_ = _zz_69_;
  assign _zz_48_ = decode_to_execute_ALU_CTRL;
  assign _zz_6_ = decode_SRC2_CTRL;
  assign _zz_4_ = _zz_70_;
  assign _zz_43_ = decode_to_execute_SRC2_CTRL;
  assign _zz_3_ = decode_SRC1_CTRL;
  assign _zz_1_ = _zz_76_;
  assign _zz_45_ = decode_to_execute_SRC1_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (*) begin
    IBusCachedPlugin_injectionPort_ready = 1'b0;
    case(_zz_205_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
      end
      3'b011 : begin
      end
      3'b100 : begin
        IBusCachedPlugin_injectionPort_ready = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign iBusWishbone_ADR = {_zz_350_,_zz_206_};
  assign iBusWishbone_CTI = ((_zz_206_ == (3'b111)) ? (3'b111) : (3'b010));
  assign iBusWishbone_BTE = (2'b00);
  assign iBusWishbone_SEL = (4'b1111);
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_256_)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_256_)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_207_;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign dBus_cmd_halfPipe_valid = dBus_cmd_halfPipe_regs_valid;
  assign dBus_cmd_halfPipe_payload_wr = dBus_cmd_halfPipe_regs_payload_wr;
  assign dBus_cmd_halfPipe_payload_address = dBus_cmd_halfPipe_regs_payload_address;
  assign dBus_cmd_halfPipe_payload_data = dBus_cmd_halfPipe_regs_payload_data;
  assign dBus_cmd_halfPipe_payload_size = dBus_cmd_halfPipe_regs_payload_size;
  assign dBus_cmd_ready = dBus_cmd_halfPipe_regs_ready;
  assign dBusWishbone_ADR = (dBus_cmd_halfPipe_payload_address >>> 2);
  assign dBusWishbone_CTI = (3'b000);
  assign dBusWishbone_BTE = (2'b00);
  always @ (*) begin
    case(dBus_cmd_halfPipe_payload_size)
      2'b00 : begin
        _zz_208_ = (4'b0001);
      end
      2'b01 : begin
        _zz_208_ = (4'b0011);
      end
      default : begin
        _zz_208_ = (4'b1111);
      end
    endcase
  end

  always @ (*) begin
    dBusWishbone_SEL = _zz_351_[3:0];
    if((! dBus_cmd_halfPipe_payload_wr))begin
      dBusWishbone_SEL = (4'b1111);
    end
  end

  assign dBusWishbone_WE = dBus_cmd_halfPipe_payload_wr;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_halfPipe_payload_data;
  assign dBus_cmd_halfPipe_ready = (dBus_cmd_halfPipe_valid && dBusWishbone_ACK);
  assign dBusWishbone_CYC = dBus_cmd_halfPipe_valid;
  assign dBusWishbone_STB = dBus_cmd_halfPipe_valid;
  assign dBus_rsp_ready = ((dBus_cmd_halfPipe_valid && (! dBusWishbone_WE)) && dBusWishbone_ACK);
  assign dBus_rsp_data = dBusWishbone_DAT_MISO;
  assign dBus_rsp_error = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= externalResetVector;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_114_ <= 1'b0;
      _zz_116_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_129_;
      IBusCachedPlugin_rspCounter <= (32'b00000000000000000000000000000000);
      _zz_151_ <= 1'b1;
      execute_LightShifterPlugin_isActive <= 1'b0;
      _zz_163_ <= 1'b0;
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      memory_MulDivIterativePlugin_mul_counter_value <= (6'b000000);
      memory_MulDivIterativePlugin_div_counter_value <= (6'b000000);
      _zz_202_ <= (32'b00000000000000000000000000000000);
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_205_ <= (3'b000);
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
      _zz_206_ <= (3'b000);
      _zz_207_ <= 1'b0;
      dBus_cmd_halfPipe_regs_valid <= 1'b0;
      dBus_cmd_halfPipe_regs_ready <= 1'b1;
    end else begin
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_corrected || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetcherflushIt) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_114_ <= 1'b0;
      end
      if(_zz_112_)begin
        _zz_114_ <= IBusCachedPlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_116_ <= IBusCachedPlugin_iBusRsp_stages_1_output_valid;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_116_ <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + (32'b00000000000000000000000000000001));
      end
      _zz_151_ <= 1'b0;
      if(_zz_227_)begin
        if(_zz_234_)begin
          execute_LightShifterPlugin_isActive <= 1'b1;
          if(execute_LightShifterPlugin_done)begin
            execute_LightShifterPlugin_isActive <= 1'b0;
          end
        end
      end
      if(execute_arbitration_removeIt)begin
        execute_LightShifterPlugin_isActive <= 1'b0;
      end
      _zz_163_ <= _zz_162_;
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_257_)begin
        if(_zz_258_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_259_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_260_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_240_)begin
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_241_)begin
        case(_zz_243_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= ({_zz_190_,{_zz_189_,_zz_188_}} != (3'b000));
      memory_MulDivIterativePlugin_mul_counter_value <= memory_MulDivIterativePlugin_mul_counter_valueNext;
      memory_MulDivIterativePlugin_div_counter_value <= memory_MulDivIterativePlugin_div_counter_valueNext;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_36_;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      case(_zz_205_)
        3'b000 : begin
          if(IBusCachedPlugin_injectionPort_valid)begin
            _zz_205_ <= (3'b001);
          end
        end
        3'b001 : begin
          _zz_205_ <= (3'b010);
        end
        3'b010 : begin
          _zz_205_ <= (3'b011);
        end
        3'b011 : begin
          if((! decode_arbitration_isStuck))begin
            _zz_205_ <= (3'b100);
          end
        end
        3'b100 : begin
          _zz_205_ <= (3'b000);
        end
        default : begin
        end
      endcase
      case(execute_CsrPlugin_csrAddress)
        12'b101111000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            _zz_202_ <= execute_CsrPlugin_writeData[31 : 0];
          end
        end
        12'b001100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
            CsrPlugin_mstatus_MPIE <= _zz_344_[0];
            CsrPlugin_mstatus_MIE <= _zz_345_[0];
          end
        end
        12'b001101000001 : begin
        end
        12'b001100000101 : begin
        end
        12'b001101000100 : begin
        end
        12'b001101000011 : begin
        end
        12'b111111000000 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_347_[0];
            CsrPlugin_mie_MTIE <= _zz_348_[0];
            CsrPlugin_mie_MSIE <= _zz_349_[0];
          end
        end
        12'b001101000010 : begin
        end
        default : begin
        end
      endcase
      if(_zz_256_)begin
        if(iBusWishbone_ACK)begin
          _zz_206_ <= (_zz_206_ + (3'b001));
        end
      end
      _zz_207_ <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if(_zz_261_)begin
        dBus_cmd_halfPipe_regs_valid <= dBus_cmd_valid;
        dBus_cmd_halfPipe_regs_ready <= (! dBus_cmd_valid);
      end else begin
        dBus_cmd_halfPipe_regs_valid <= (! dBus_cmd_halfPipe_ready);
        dBus_cmd_halfPipe_regs_ready <= dBus_cmd_halfPipe_ready;
      end
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_117_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow memory stage stall when read happend");
    end
    if(!(! (((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE) && (! writeBack_MEMORY_STORE)) && writeBack_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow writeback stage stall when read happend");
    end
    if(_zz_227_)begin
      if(_zz_234_)begin
        execute_LightShifterPlugin_amplitudeReg <= (execute_LightShifterPlugin_amplitude - (5'b00001));
      end
    end
    if(_zz_162_)begin
      _zz_164_ <= _zz_51_[11 : 7];
      _zz_165_ <= _zz_81_;
    end
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(_zz_233_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_192_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_192_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
    end
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= CsrPlugin_selfException_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= CsrPlugin_selfException_payload_badAddr;
    end
    if(_zz_239_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_194_ ? DBusSimplePlugin_memoryExceptionPort_payload_code : BranchPlugin_branchExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_194_ ? DBusSimplePlugin_memoryExceptionPort_payload_badAddr : BranchPlugin_branchExceptionPort_payload_badAddr);
    end
    if(_zz_257_)begin
      if(_zz_258_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_259_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_260_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_240_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    if(_zz_221_)begin
      if(_zz_237_)begin
        memory_MulDivIterativePlugin_rs2 <= (memory_MulDivIterativePlugin_rs2 >>> 1);
        memory_MulDivIterativePlugin_accumulator <= ({_zz_323_,memory_MulDivIterativePlugin_accumulator[31 : 0]} >>> 1);
      end
    end
    if((memory_MulDivIterativePlugin_div_counter_value == (6'b100000)))begin
      memory_MulDivIterativePlugin_div_done <= 1'b1;
    end
    if((! memory_arbitration_isStuck))begin
      memory_MulDivIterativePlugin_div_done <= 1'b0;
    end
    if(_zz_222_)begin
      if(_zz_238_)begin
        memory_MulDivIterativePlugin_rs1[31 : 0] <= _zz_332_[31:0];
        memory_MulDivIterativePlugin_accumulator[31 : 0] <= ((! _zz_197_[32]) ? _zz_333_ : _zz_334_);
        if((memory_MulDivIterativePlugin_div_counter_value == (6'b100000)))begin
          memory_MulDivIterativePlugin_div_result <= _zz_335_[31:0];
        end
      end
    end
    if(_zz_254_)begin
      memory_MulDivIterativePlugin_accumulator <= (65'b00000000000000000000000000000000000000000000000000000000000000000);
      memory_MulDivIterativePlugin_rs1 <= ((_zz_200_ ? (~ _zz_201_) : _zz_201_) + _zz_341_);
      memory_MulDivIterativePlugin_rs2 <= ((_zz_199_ ? (~ execute_RS2) : execute_RS2) + _zz_343_);
      memory_MulDivIterativePlugin_div_needRevert <= ((_zz_200_ ^ (_zz_199_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == (32'b00000000000000000000000000000000)) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    externalInterruptArray_regNext <= externalInterruptArray;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_23_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MMU_RSP_physicalAddress <= execute_MMU_RSP_physicalAddress;
      execute_to_memory_MMU_RSP_isIoAccess <= execute_MMU_RSP_isIoAccess;
      execute_to_memory_MMU_RSP_allowRead <= execute_MMU_RSP_allowRead;
      execute_to_memory_MMU_RSP_allowWrite <= execute_MMU_RSP_allowWrite;
      execute_to_memory_MMU_RSP_allowExecute <= execute_MMU_RSP_allowExecute;
      execute_to_memory_MMU_RSP_exception <= execute_MMU_RSP_exception;
      execute_to_memory_MMU_RSP_refilling <= execute_MMU_RSP_refilling;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_21_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_42_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_18_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_15_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_13_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_STORE <= memory_MEMORY_STORE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_11_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_8_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MMU_FAULT <= execute_MMU_FAULT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_5_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if(((! memory_arbitration_isStuck) && (! execute_arbitration_isStuckByOthers)))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_37_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_2_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_DO_EBREAK <= decode_DO_EBREAK;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_99_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_98_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
      end
      12'b001100000000 : begin
      end
      12'b001101000001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001100000101 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mtvec_base <= execute_CsrPlugin_writeData[31 : 2];
          CsrPlugin_mtvec_mode <= execute_CsrPlugin_writeData[1 : 0];
        end
      end
      12'b001101000100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mip_MSIP <= _zz_346_[0];
        end
      end
      12'b001101000011 : begin
      end
      12'b111111000000 : begin
      end
      12'b001100000100 : begin
      end
      12'b001101000010 : begin
      end
      default : begin
      end
    endcase
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    if(_zz_261_)begin
      dBus_cmd_halfPipe_regs_payload_wr <= dBus_cmd_payload_wr;
      dBus_cmd_halfPipe_regs_payload_address <= dBus_cmd_payload_address;
      dBus_cmd_halfPipe_regs_payload_data <= dBus_cmd_payload_data;
      dBus_cmd_halfPipe_regs_payload_size <= dBus_cmd_payload_size;
    end
  end

  always @ (posedge clk) begin
    DebugPlugin_firstCycle <= 1'b0;
    if(debug_bus_cmd_ready)begin
      DebugPlugin_firstCycle <= 1'b1;
    end
    DebugPlugin_secondCycle <= DebugPlugin_firstCycle;
    DebugPlugin_isPipBusy <= (({writeBack_arbitration_isValid,{memory_arbitration_isValid,{execute_arbitration_isValid,decode_arbitration_isValid}}} != (4'b0000)) || IBusCachedPlugin_incomingInstruction);
    if(writeBack_arbitration_isValid)begin
      DebugPlugin_busReadDataReg <= _zz_81_;
    end
    _zz_204_ <= debug_bus_cmd_payload_address[2];
    if(_zz_235_)begin
      DebugPlugin_busReadDataReg <= execute_PC;
    end
    DebugPlugin_resetIt_regNext <= DebugPlugin_resetIt;
  end

  always @ (posedge clk) begin
    if(debugReset) begin
      DebugPlugin_resetIt <= 1'b0;
      DebugPlugin_haltIt <= 1'b0;
      DebugPlugin_stepIt <= 1'b0;
      DebugPlugin_godmode <= 1'b0;
      DebugPlugin_haltedByBreak <= 1'b0;
    end else begin
      if((DebugPlugin_haltIt && (! DebugPlugin_isPipBusy)))begin
        DebugPlugin_godmode <= 1'b1;
      end
      if(debug_bus_cmd_valid)begin
        case(_zz_255_)
          6'b000000 : begin
            if(debug_bus_cmd_payload_wr)begin
              DebugPlugin_stepIt <= debug_bus_cmd_payload_data[4];
              if(debug_bus_cmd_payload_data[16])begin
                DebugPlugin_resetIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[24])begin
                DebugPlugin_resetIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[17])begin
                DebugPlugin_haltIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltedByBreak <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_godmode <= 1'b0;
              end
            end
          end
          6'b000001 : begin
          end
          default : begin
          end
        endcase
      end
      if(_zz_235_)begin
        if(_zz_236_)begin
          DebugPlugin_haltIt <= 1'b1;
          DebugPlugin_haltedByBreak <= 1'b1;
        end
      end
      if(_zz_242_)begin
        if(decode_arbitration_isValid)begin
          DebugPlugin_haltIt <= 1'b1;
        end
      end
    end
  end

endmodule

