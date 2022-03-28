class test_init extends uvm_test;

  `uvm_component_utils(test_init)

  virtual mem_intf mem_if;

//--------------------
// data/address/burst length FIFO
//--------------------
int dfifo[$]; // data fifo
int afifo[$]; // address  fifo
int bfifo[$]; // Burst Length fifo

reg [31:0] read_data;
reg [31:0] ErrCnt;
int k;
reg [31:0] StartAddr;

  function new (string name="test_init", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if(uvm_config_db #(virtual mem_intf)::get(this, "", "mem_if", mem_if) == 0) begin
         `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end

      uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
      print();

   endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
    print();
    //uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  virtual task run_phase(uvm_phase phase);

  phase.raise_objection (this);
/////////////////////////////////////////////////////////////////////////
// Test Case
/////////////////////////////////////////////////////////////////////////

  /*set_lp_msg_onoff("LP_PSW_CTRL_INIT_INVALID","OFF");
  set_lp_msg_onoff("LP_ISOEN_INVALID","OFF");
  set_lp_msg_onoff("LP_PSW_CTRL_INVALID","OFF");
  supply_off("VDD");
  supply_off("VSS");

  #100
  //Start VDD power supply
  supply_on("VSS",0);
  #100
  supply_on("VDD",0.95);

  set_lp_msg_onoff("LP_PSW_CTRL_INIT_INVALID","ON");
  set_lp_msg_onoff("LP_ISOEN_INVALID","ON");
  set_lp_msg_onoff("LP_PSW_CTRL_INVALID","ON");

  force tb_top.u_dut.pg_pg_wb2sdrc_en_signal = 0;
  force tb_top.u_dut.pg_pg_sdrc_core_en_signal =0;


  #100
  */
  ErrCnt          = 0;
   mem_if.wb_addr_i      = 0;
   mem_if.wb_dat_i      = 0;
   mem_if.wb_sel_i       = 4'h0;
   mem_if.wb_we_i        = 0;
   mem_if.wb_stb_i       = 0;
   mem_if.wb_cyc_i       = 0;

  force tb_top.u_dut.pg_pg_wb2sdrc_en_signal = 1;

  #100

  force tb_top.u_dut.pg_pg_sdrc_core_en_signal =1;

  #100

  mem_if.RESETN    = 1'h1;

 #100
  // Applying reset
  mem_if.RESETN    = 1'h0;
  #10000;
  // Releasing reset
  mem_if.RESETN    = 1'h1;
  #1000;
  wait(tb_top.u_dut.sdr_init_done == 1);

  #1000;
  $display("-------------------------------------- ");
  $display(" Case-1: Single Write/Read Case        ");
  $display("-------------------------------------- ");

  burst_write(32'h4_0000,8'h4);
 #1000;
  burst_read();

  // Repeat one more time to analysis the
  // SDRAM state change for same col/row address
  $display("-------------------------------------- ");
  $display(" Case-2: Repeat same transfer once again ");
  $display("----------------------------------------");
  burst_write(32'h4_0000,8'h4);
  burst_read();
  burst_write(32'h0040_0000,8'h5);
  burst_read();
  $display("----------------------------------------");
  $display(" Case-3 Create a Page Cross Over        ");
  $display("----------------------------------------");
  burst_write(32'h0000_0FF0,8'h8);
  burst_write(32'h0001_0FF4,8'hF);
  burst_write(32'h0002_0FF8,8'hF);
  burst_write(32'h0003_0FFC,8'hF);
  burst_write(32'h0004_0FE0,8'hF);
  burst_write(32'h0005_0FE4,8'hF);
  burst_write(32'h0006_0FE8,8'hF);
  burst_write(32'h0007_0FEC,8'hF);
  burst_write(32'h0008_0FD0,8'hF);
  burst_write(32'h0009_0FD4,8'hF);
  burst_write(32'h000A_0FD8,8'hF);
  burst_write(32'h000B_0FDC,8'hF);
  burst_write(32'h000C_0FC0,8'hF);
  burst_write(32'h000D_0FC4,8'hF);
  burst_write(32'h000E_0FC8,8'hF);
  burst_write(32'h000F_0FCC,8'hF);
  burst_write(32'h0010_0FB0,8'hF);
  burst_write(32'h0011_0FB4,8'hF);
  burst_write(32'h0012_0FB8,8'hF);
  burst_write(32'h0013_0FBC,8'hF);
  burst_write(32'h0014_0FA0,8'hF);
  burst_write(32'h0015_0FA4,8'hF);
  burst_write(32'h0016_0FA8,8'hF);
  burst_write(32'h0017_0FAC,8'hF);
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();

  $display("----------------------------------------");
  $display(" Case:4 4 Write & 4 Read                ");
  $display("----------------------------------------");
  burst_write(32'h4_0000,8'h4);
  burst_write(32'h5_0000,8'h5);
  burst_write(32'h6_0000,8'h6);
  burst_write(32'h7_0000,8'h7);
  burst_read();
  burst_read();
  burst_read();
  burst_read();

  $display("---------------------------------------");
  $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
  $display("---------------------------------------");
  //----------------------------------------
  // Address Decodeing:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //
  burst_write({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
  burst_write({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
  burst_write({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
  burst_write({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
  burst_write({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
  burst_write({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
  burst_write({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
  burst_write({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();

  burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  burst_write({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
  burst_write({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
  burst_write({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
  burst_write({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
  burst_write({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
  burst_write({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
  burst_write({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();

  burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  burst_write({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
  burst_write({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
  burst_write({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
  burst_write({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
  burst_write({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
  burst_write({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
  burst_write({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  burst_read();
  $display("---------------------------------------------------");
  $display(" Case: 6 Random 2 write and 2 read random");
  $display("---------------------------------------------------");
  for(k=0; k < 20; k++) begin
     StartAddr = $random & 32'h003FFFFF;
     burst_write(StartAddr,($random & 8'h0f)+1);
 #100;

     StartAddr = $random & 32'h003FFFFF;
     burst_write(StartAddr,($random & 8'h0f)+1);
 #100;
     burst_read();
 #100;
     burst_read();
 #100;
  end

  #10000;

        $display("###############################");
    if(ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");

    //$finish;
    phase.drop_objection (this);
endtask

task burst_write;
input [31:0] Address;
input [7:0]  bl;
int i;
begin
  afifo.push_back(Address);
  bfifo.push_back(bl);

   @ (negedge mem_if.sys_clk);
   $display("Write Address: %x, Burst Size: %d",Address,bl);

   for(i=0; i < bl; i++) begin
      mem_if.wb_stb_i        = 1;
      mem_if.wb_cyc_i        = 1;
      mem_if.wb_we_i         = 1;
      mem_if.wb_sel_i        = 4'b1111;
      mem_if.wb_addr_i       = Address[31:2]+i;
      mem_if.wb_dat_i        = $random & 32'hFFFFFFFF;
      dfifo.push_back(mem_if.wb_dat_i);

      do begin
          @ (posedge mem_if.sys_clk);
      end while(mem_if.wb_ack_o == 1'b0);
          @ (negedge mem_if.sys_clk);

       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,mem_if.wb_addr_i,mem_if.wb_dat_i);
   end
   mem_if.wb_stb_i        = 0;
   mem_if.wb_cyc_i        = 0;
   mem_if.wb_we_i         = 'hx;
   mem_if.wb_sel_i        = 'hx;
   mem_if.wb_addr_i       = 'hx;
   mem_if.wb_dat_i        = 'hx;
end
endtask

task burst_read;
reg [31:0] Address;
reg [7:0]  bl;

int i,j;
reg [31:0]   exp_data;
begin

   Address = afifo.pop_front();
   bl      = bfifo.pop_front();
   @ (negedge mem_if.sys_clk);

      for(j=0; j < bl; j++) begin
         mem_if.wb_stb_i        = 1;
         mem_if.wb_cyc_i        = 1;
         mem_if.wb_we_i         = 0;
         mem_if.wb_addr_i       = Address[31:2]+j;

         exp_data        = dfifo.pop_front(); // Exptected Read Data
         do begin
             @ (posedge mem_if.sys_clk);
         end while(mem_if.wb_ack_o == 1'b0);
         if(mem_if.wb_dat_o !== exp_data) begin
             $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,mem_if.wb_addr_i,mem_if.wb_dat_o,exp_data);
             ErrCnt = ErrCnt+1;
         end else begin
             $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,mem_if.wb_addr_i,mem_if.wb_dat_o);
         end
         @ (negedge mem_if.sdram_clk);
      end
   mem_if.wb_stb_i        = 0;
   mem_if.wb_cyc_i        = 0;
   mem_if.wb_we_i         = 'hx;
   mem_if.wb_addr_i       = 'hx;
end
endtask

endclass : test_init
