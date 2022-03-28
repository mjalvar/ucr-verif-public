class memory_env extends uvm_env;

  `uvm_component_utils(memory_env)

  function new (string name = "memory_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual mem_intf mem_if;
  memory_agent mem_ag;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual mem_intf)::get(this, "", "VIRTUAL_INTERFACE", mem_if) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    mem_ag = memory_agent::type_id::create ("mem_ag", this); 

    uvm_config_db #(virtual mem_intf)::set (null, "uvm_test_top.mem_env.mem_ag", "VIRTUAL_INTERFACE", mem_if);    
      
    uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
    print();

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
  endfunction

endclass
