class regs_env extends uvm_env;
	`uvm_component_utils(regs_env)

	regs_agent sa_agent;
	regs_scoreboard sa_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sa_agent	= regs_agent::type_id::create(.name("sa_agent"), .parent(this));
		sa_sb		= regs_scoreboard::type_id::create(.name("sa_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sa_agent.agent_ap_before.connect(sa_sb.sb_export_before);
		sa_agent.agent_ap_after.connect(sa_sb.sb_export_after);
	endfunction: connect_phase
endclass: regs_env