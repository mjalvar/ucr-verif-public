interface mem_intf ();

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

// General
logic            RESETN;
logic            sdram_clk;
logic            sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 5;   // burst_lenght_width 

//-------------------------------------------
// WISH BONE Interface
//-------------------------------------------
//--------------------------------------
// Wish Bone Interface
// -------------------------------------      
logic             wb_stb_i           ;
wire              wb_ack_o           ;
logic  [25:0]     wb_addr_i          ;
logic             wb_we_i            ; // 1 - Write, 0 - Read
logic  [dw-1:0]   wb_dat_i           ;
logic  [dw/8-1:0] wb_sel_i           ; // Byte enable
wire   [dw-1:0]   wb_dat_o           ;
logic             wb_cyc_i           ;
logic   [2:0]     wb_cti_i           ;



//--------------------------------------------
// SDRAM I/F 
//--------------------------------------------

`ifdef SDR_32BIT
   wire [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
   wire [3:0]            sdr_dqm            ; // SDRAM DATA Mask
`elsif SDR_16BIT 
   wire [15:0]           Dq                 ; // SDRAM Read/Write Data Bus
   wire [1:0]            sdr_dqm            ; // SDRAM DATA Mask
`else 
   wire [7:0]           Dq                 ; // SDRAM Read/Write Data Bus
   wire [0:0]           sdr_dqm            ; // SDRAM DATA Mask
`endif

wire [1:0]            sdr_ba             ; // SDRAM Bank Select
wire [12:0]           sdr_addr           ; // SDRAM ADRESS
wire                  sdr_init_done      ; // SDRAM Init Done 

// to fix the sdram interface timing issue
wire #(2.0) sdram_clk_d   = sdram_clk;


endinterface
