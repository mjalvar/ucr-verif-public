//////////////////////////////////////////////////////////////////////////////////
//
// melvin.alvarado
// may 2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

//`include "counter_pkg.svh"

module tb();
	import uvm_pkg::*;
    import counter_pkg::*;

    localparam WIDTH_P = 4;


    counter_if vif();

    logic [WIDTH_P-1:0] inc;
    logic clk;
    logic reset_L;
    logic en, clr;


    // initial begin
    //     $display("Starting simulation");
    //     #5ns;
    //     en <= 0;
    //     clk <= 0;
    //     reset_L <= 0;
    //     #20ns;
    //     reset_L <= 1;
    //     repeat (5) begin
    //         repeat (10) @(posedge clk);
    //         en <= 1;
    //         repeat (10) @(posedge clk);
    //         en <= 0;
    //     end
    //     #1000ns;
    //     $finish();
    // end


    // clk gen
    initial
        clk = 0;

    always @(*) begin
        #5ns;
        clk <= ~clk;
    end


    counter #(
        .WIDTH_P(WIDTH_P)
    ) DUT (
        .clk(clk),
        .reset_L(reset_L),
        .inc(inc),
        .en(en),
        .clr(clr),
        .non_zero(),
        .overflow(),
        .val()
    );


    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0,tb);
    end


    initial begin
		// Registers the Interface in the resource_db so that other
		// blocks can use it
		uvm_resource_db#(virtual counter_if)::set
			(.scope("ifs"), .name("counter_if"), .val(vif));

		//Executes the test
		run_test();
	end

    // connect
    assign vif.clk = clk;


endmodule
