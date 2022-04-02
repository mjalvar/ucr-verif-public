`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  COUNTER
//  melvin.alvarado
//  may 2022
//
//////////////////////////////////////////////////////////////////////////////////


module rsync # (
    parameter WIDTH_P = 4
)(
    input                       clk_dest,
    input           [WIDTH_P-1:0] data_in,
    output logic    [WIDTH_P-1:0] data_out
);

logic [WIDTH_P-1:0] data_in_ff;

    always_ff @(posedge clk_dest) begin
        data_in_ff <= data_in;
        data_out <= data_in_ff;
    end

endmodule



module counter #(
    parameter WIDTH_P = 4
)(
    input clk1,
    input clk2,
    input reset_L,

    input en,
    input clr,
    input [WIDTH_P-1:0] inc,

    output reg overflow,
    output reg non_zero,
    output reg [WIDTH_P-1:0] val
);

    reg [WIDTH_P-1:0] val_int;
    assign non_zero = |val;

    always @(posedge clk1) begin
        if(reset_L == 1'b0) begin
            val_int <= '0;
            overflow <= '0;
        end
        else
            if(en)
                {overflow,val_int} <= val_int + inc;
    end

    rsync s2clk2(
        .clk_dest(clk2),
        .data_in(val_int),
        .data_out(val)
    );

endmodule
