package counter_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "counter_tlm.sv"
	`include "counter_sequence.sv"
	`include "counter_sequencer.sv"
	// `include "simpleadder_monitor.sv"
	`include "counter_driver.sv"
	`include "counter_agent.sv"
	// `include "simpleadder_scoreboard.sv"
	`include "counter_env.sv"
	`include "counter_test.sv"

endpackage: counter_pkg
