`include "uvm_macros.svh"

class memory_agent extends uvm_agent;
  `uvm_component_utils(memory_agent)
  function new(string name="memory_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual mem_intf mem_if;
  memory_driver mem_drv;
  uvm_sequencer #(mem_item)	mem_seqr;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(uvm_config_db #(virtual mem_intf)::get(this, "", "VIRTUAL_INTERFACE", mem_if) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end

    mem_drv = memory_driver::type_id::create ("mem_drv", this);

    mem_seqr = uvm_sequencer#(mem_item)::type_id::create("mem_seqr", this);

    uvm_config_db #(virtual mem_intf)::set (null, "uvm_test_top.mem_env.mem_ag.mem_drv", "VIRTUAL_INTERFACE", mem_if);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mem_drv.seq_item_port.connect(mem_seqr.seq_item_export);
  endfunction

endclass
