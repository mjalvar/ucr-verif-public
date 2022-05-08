`include "counter_pkg.sv"
`include "counter.v"
`include "counter_if.sv"

module counter_tb;
	import uvm_pkg::*;
	import counter_pkg::*;

	//Interface declaration
	counter_if vif();

	//Connects the Interface to the DUT
	counter dut(vif.clk,
			vif.reset_L,
			vif.en,
			vif.clr,
			vif.inc,
			vif.overflow,
			vif.non_zero,
			vif.val);
			
			

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual counter_if)::set
			(.scope("ifs"), .name("counter_if"), .val(vif));

		//Executes the test
		run_test();
	end

	//Variable initialization
	initial begin
		vif.clk <= 1'b1;
	end

	//Clock generation
	always
		#5 vif.clk = ~vif.clk;

	//Dump variables
	initial begin
		$dumpfile("counter.vcd");
		$dumpvars(0, counter, counter_tb_top);
	end

endmodule
