class counter_env extends uvm_env;
	`uvm_component_utils(counter_env)

	counter_agent ct_agent;
	counter_scoreboard ct_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ct_agent	= counter_agent::type_id::create(.name("ct_agent"), .parent(this));
		ct_sb		= counter_scoreboard::type_id::create(.name("ct_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ct_agent.agent_ap_before.connect(ct_sb.sb_export_before);
		ct_agent.agent_ap_after.connect(ct_sb.sb_export_after);
	endfunction: connect_phase
endclass: counter_env
