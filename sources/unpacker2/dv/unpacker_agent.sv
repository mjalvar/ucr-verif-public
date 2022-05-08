class unpacker_agent extends uvm_agent;
   `uvm_component_utils(unpacker_agent)

   uvm_analysis_port#(unpacker_transaction) agent_ap;

   unpacker_sequencer seqr;
   unpacker_driver drvr;
   unpacker_monitor mon;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      agent_ap = new(.name("agent_ap"), .parent(this));

      seqr = unpacker_sequencer::type_id::create(.name("seqr"), .parent(this));
      drvr = unpacker_driver::type_id::create(.name("drvr"), .parent(this));
      mon = unpacker_monitor::type_id::create(.name("mon"), .parent(this));
   endfunction: build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      drvr.seq_item_port.connect(seqr.seq_item_export);
      mon.mon_ap.connect(agent_ap);
   endfunction: connect_phase
endclass: unpacker_agent
