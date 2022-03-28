//////////////////////////////////////////////////////////////////////////////////
//
// melvin.alvarado
// may 2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb();

    localparam WIDTH_P = 4;

    reg clk;
    reg reset_L;

    reg val, sop, eop, o_val;
    reg [7:0] vbc;
    reg [160*8-1:0] data;
    reg [3:0] id;
    wire ready;

    initial begin
        $display("Starting simulation");
        #5ns;
        clk <= 0;
        val <= 0;
        sop <= 0;
        eop <= 0;
        vbc <= 0;
        data <= '0;
        id <= '0;

        // reset
        reset_L <= 0;
        #20ns;
        reset_L <= 1;

        repeat (5) @(posedge clk);

        // test 5 small pkts
        repeat (5) begin
            val <= 1;
            sop <= 1;
            vbc <= 32;
            eop <= 1;
            for(int i=0; i<8; i++) begin
                data[i*32 +: 32] <= $urandom();
            end
            @(posedge clk);
            if(~ready) begin
                @(posedge ready);
                @(posedge clk);
            end
        end
        val <= 0;
        sop <= 0;
        vbc <= 0;
        eop <= 0;

        // test ptk > 32B
        repeat (2) @(posedge clk);
        val <= 1;
        sop <= 1;
        vbc <= 159;
        eop <= 1;
        for(int i=0; i<40; i++) begin
            data[i*32 +: 32] <= $urandom();
        end
        @(posedge clk);
        if(~ready) begin
            @(posedge ready);
            @(posedge clk);
        end

        // test ptk > 32B
        val <= 1;
        sop <= 1;
        vbc <= 160;
        eop <= 0;
        for(int i=0; i<40; i++) begin
            data[i*32 +: 32] <= i;
        end
        @(posedge clk);
        if(~ready) begin
            @(posedge ready);
            @(posedge clk);
        end
        val <= 1;
        sop <= 0;
        vbc <= 160;
        eop <= 0;
        for(int i=0; i<40; i++) begin
            data[i*32 +: 32] <= i;
        end
        @(posedge clk);
        if(~ready) begin
            @(posedge ready);
            @(posedge clk);
        end
        val <= 1;
        sop <= 0;
        vbc <= 159;
        eop <= 1;
        for(int i=0; i<40; i++) begin
            data[i*32 +: 32] <= i;
        end
        @(posedge clk);
        if(~ready) begin
            @(posedge ready);
            @(posedge clk);
        end
        val <= 0;
        sop <= 0;
        vbc <= 0;
        eop <= 0;

        #1000ns;
        $finish();
    end


     // clk gen
    always @(*) begin
        #5ns;
        clk <= ~clk;
    end


    c3po #() DUT (
        .reset_L(reset_L),
        .clk(clk),

        // PKT IN
        .sop(sop),
        .eop(eop),
        .val(val),
        .vbc(vbc),
        .id(id),
        .data(data),

        // PKT OUT
        .o_sop(),
        .o_eop(),
        .o_val(o_val),
        .o_vbc(),
        .o_data(o_data),
        .ready(ready)
    );


    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0,tb);
    end


endmodule
