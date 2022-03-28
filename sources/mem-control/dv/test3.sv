class mem_item2 extends mem_item;

  rand logic [31:0] Address;
  rand logic [7:0]  bl;

  constraint legal {
    Address == 32'h10010;
    bl >= 4;
    bl < 8;
  }

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(mem_item2)
  	`uvm_field_int (Address, UVM_DEFAULT)
  	`uvm_field_int (bl, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "mem_item2");
    super.new(name);
  endfunction
endclass

class test_nothing extends test_basic;

  `uvm_component_utils(test_nothing)

  function new (string name="test_nothing", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      set_type_override_by_type(mem_item::get_type(), mem_item2::get_type());


  endfunction

 /* virtual task run_phase(uvm_phase phase);

    phase.raise_objection (this);

    uvm_report_info(get_full_name(),"Init Start", UVM_LOW);

    set_lp_msg_onoff("LP_PSW_CTRL_INIT_INVALID","OFF");
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
    //mem_env.mem_drv.run_phase();
    uvm_report_info(get_full_name(),"Init Done", UVM_LOW);

    phase.drop_objection (this);
  endtask*/

endclass
