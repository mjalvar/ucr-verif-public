class unpacker_env extends uvm_env;
   `uvm_component_utils(unpacker_env)

   unpacker_agent agent;
   unpacker_scoreboard sb;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = unpacker_agent::type_id::create(.name("agent"), .parent(this));
      sb    = unpacker_scoreboard::type_id::create(.name("sb"), .parent(this));
   endfunction: build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agent_ap.connect(sb.sb_export);
   endfunction: connect_phase
endclass: unpacker_env
