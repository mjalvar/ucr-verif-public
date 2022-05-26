class counter_agent extends uvm_agent;

	`uvm_component_utils(counter_agent)

	// uvm_analysis_port#(counter_transaction) agent_ap_before;
	// uvm_analysis_port#(counter_transaction) agent_ap_after;

	counter_sequencer		seqr;

	counter_driver			driver;
	// counter_monitor_before	sa_mon_before;
	// counter_monitor_after	sa_mon_after;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// agent_ap_before	= new(.name("agent_ap_before"), .parent(this));
		// agent_ap_after	= new(.name("agent_ap_after"), .parent(this));

		seqr		= counter_sequencer::type_id::create(.name("counter_seqr"), .parent(this));
		driver		= counter_driver::type_id::create(.name("counter_driver"), .parent(this));
		// sa_mon_before	= counter_monitor_before::type_id::create(.name("sa_mon_before"), .parent(this));
		// sa_mon_after	= counter_monitor_after::type_id::create(.name("sa_mon_after"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		driver.seq_item_port.connect(seqr.seq_item_export);
		// sa_mon_before.mon_ap_before.connect(agent_ap_before);
		// sa_mon_after.mon_ap_after.connect(agent_ap_after);
	endfunction: connect_phase

endclass: counter_agent
