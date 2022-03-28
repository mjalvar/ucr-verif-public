`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  REGS
//  melvin.alvarado
//  may 2021
//
//////////////////////////////////////////////////////////////////////////////////

//import common::*;
`include "field.v"
`include "reg_control.v"

module regs #(
    parameter ADDR_SIZE_P = 4
)(
    input clk,
    input reset_L,

    input [ADDR_SIZE_P-1:0] addr,
    input                   rd_wr,
    input                   req,

    input       cfg_ctrl_err,
    input       cfg_ctrl_idle,
    output reg  cfg_port_enable,
    output reg  [3:0] cfg_port_id,

    input      [31:0]       write_val,
    output reg [31:0]       read_val,
    output reg              ack

);


    reg_control # (
        .ADDR_SIZE_P(ADDR_SIZE_P),
        .RESET_PORT_ID(0),
        .REG_ADDR(0)
    ) REG_CONTROL(
        .clk(clk),
        .reset_L(reset_L),

        .cfg_port_enable(cfg_port_enable),
        .cfg_ctrl_err(cfg_ctrl_err),
        .cfg_ctrl_idle(cfg_ctrl_idle),
        .cfg_port_id(cfg_port_id),

        .addr(addr),
        .req(req),
        .rd_wr(rd_wr),
        .write_val(write_val),
        .read_val(read_val),
        .ack(ack)

    );



endmodule
