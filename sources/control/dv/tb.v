//////////////////////////////////////////////////////////////////////////////////
//
// melvin.alvarado
// may 2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb();


    reg clk;
    reg reset_L;
    reg val, sop, eop;
    reg cfg_port_enable;


    initial begin
        $display("Starting simulation");
        #5ns;
        clk <= 0;
        val <= 0;
        sop <= 0;
        eop <= 0;

        // reset
        reset_L <= 0;
        #20ns;
        reset_L <= 1;

        // test
        repeat (5) begin
            repeat (10) @(posedge clk);
            val <= 1;
            sop <= 1;
            @(posedge clk);
            sop <= 0;
            repeat (10) @(posedge clk);
            eop <= 1;
            @(posedge clk);
            eop <= 0;
            val <= 0;
        end
        #1000ns;
        $finish();
    end

    initial begin
        cfg_port_enable <= 1;
        repeat(5) begin
            repeat (15) @(posedge clk);
            cfg_port_enable <= ~cfg_port_enable;
        end
    end


    // clk gen
    always @(*) begin
        #5ns;
        clk <= ~clk;
    end


    control_fsm #(
        //.WIDTH_P(WIDTH_P)
    ) DUT (
        .reset_L(reset_L),
        .clk(clk),
        .sop(sop),
        .eop(eop),
        .val(val),
        .cfg_port_enable(cfg_port_enable),
        .enable(),
        .error()
    );


    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0,tb);
    end


endmodule
