//////////////////////////////////////////////////////////////////////////////////
//
// melvin.alvarado
// may 2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb();

    localparam WIDTH_P = 4;

    reg clk1, clk2;
    reg reset_L;
    reg en;


    initial begin
        $display("Starting simulation");
        #5ns;
        en <= 0;
        clk1 <= 0;
        clk2 <= 0;
        reset_L <= 0;
        #20ns;
        reset_L <= 1;
        repeat (5) begin
            repeat (10) @(posedge clk1);
            en <= 1;
            repeat (10) @(posedge clk1);
            en <= 0;
        end
        #1000ns;
        $finish();
    end


     // clk1 gen
    always @(*) begin
        #5ns;
        clk1 <= ~clk1;
    end

    // clk2 gen
    always @(*) begin
        #2.6ns;
        clk2 <= ~clk2;
    end


    counter #(
        .WIDTH_P(WIDTH_P)
    ) DUT (
        .clk1(clk1),
        .clk2(clk2),
        .reset_L(reset_L),
        .inc('b1),
        .en(en),
        .clr(0),
        .non_zero(),
        .val()
    );


    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0,tb);
    end


endmodule
