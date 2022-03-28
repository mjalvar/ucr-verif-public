//////////////////////////////////////////////////////////////////////
////                                                              ////
////                                                              ////
////  This file is part of the SDRAM Controller project           ////
////  http://www.opencores.org/cores/sdr_ctrl/                    ////
////                                                              ////
////  Description                                                 ////
////  SDRAM CTRL definitions.                                     ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
//   Version  :0.1 - Test Bench automation is improvised with     ////
//             seperate data,address,burst length fifo.           ////
//             Now user can create different write and            ////
//             read sequence                                      ////
//                                                                ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

//`include "uvm.svh"
import uvm_pkg::*;

//`include "test.sv"

//import UPF::*;
//import SNPS_LP_MSG::*;

// This testbench verify with SDRAM TOP

module tb_top;

mem_intf mem_if();

`ifdef SDR_32BIT

   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
`elsif SDR_16BIT
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
`endif
      // System
`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
`else
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
`endif
          .cfg_colbits        (2'b00              ), // 8 Bit Column Address

/* WISH BONE */
          .wb_rst_i           (!mem_if.RESETN            ),
          .wb_clk_i           (mem_if.sys_clk            ),

          .wb_stb_i           (mem_if.wb_stb_i           ),
          .wb_ack_o           (mem_if.wb_ack_o           ),
          .wb_addr_i          (mem_if.wb_addr_i          ),
          .wb_we_i            (mem_if.wb_we_i            ),
          .wb_dat_i           (mem_if.wb_dat_i           ),
          .wb_sel_i           (mem_if.wb_sel_i           ),
          .wb_dat_o           (mem_if.wb_dat_o           ),
          .wb_cyc_i           (mem_if.wb_cyc_i           ),
          .wb_cti_i           (mem_if.wb_cti_i           ),

/* Interface to SDRAMs */
          .sdram_clk          (mem_if.sdram_clk          ),
          .sdram_resetn       (mem_if.RESETN             ),
          .sdr_cs_n           (sdr_cs_n           ),
          .sdr_cke            (sdr_cke            ),
          .sdr_ras_n          (sdr_ras_n          ),
          .sdr_cas_n          (sdr_cas_n          ),
          .sdr_we_n           (sdr_we_n           ),
          .sdr_dqm            (mem_if.sdr_dqm            ),
          .sdr_ba             (mem_if.sdr_ba             ),
          .sdr_addr           (mem_if.sdr_addr           ),
          .sdr_dq             (mem_if.Dq                 ),

    /* Parameters */
          .sdr_init_done      (mem_if.sdr_init_done      ),
          .cfg_req_depth      (2'h3               ),	        //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (mem_if.Dq                 ) ,
          .Addr               (mem_if.sdr_addr[10:0]     ),
          .Ba                 (mem_if.sdr_ba             ),
          .Clk                (mem_if.sdram_clk_d        ),
          .Cke                (sdr_cke            ),
          .Cs_n               (sdr_cs_n           ),
          .Ras_n              (sdr_ras_n          ),
          .Cas_n              (sdr_cas_n          ),
          .We_n               (sdr_we_n           ),
          .Dqm                (mem_if.sdr_dqm            )
     );

`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
          .dq                 (mem_if.Dq                 ),
          .addr               (mem_if.sdr_addr[11:0]     ),
          .ba                 (mem_if.sdr_ba             ),
          .clk                (mem_if.sdram_clk_d        ),
          .cke                (sdr_cke            ),
          .csb                (sdr_cs_n           ),
          .rasb               (sdr_ras_n          ),
          .casb               (sdr_cas_n          ),
          .web                (sdr_we_n           ),
          .dqm                (mem_if.sdr_dqm            )
    );
`else


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (mem_if.Dq                 ) ,
          .Addr               (mem_if.sdr_addr[11:0]     ),
          .Ba                 (mem_if.sdr_ba             ),
          .Clk                (mem_if.sdram_clk_d        ),
          .Cke                (sdr_cke            ),
          .Cs_n               (sdr_cs_n           ),
          .Ras_n              (sdr_ras_n          ),
          .Cas_n              (sdr_cas_n          ),
          .We_n               (sdr_we_n           ),
          .Dqm                (mem_if.sdr_dqm            )
     );
`endif

initial begin

  $dumpfile("dump.vcd"); $dumpvars;

  uvm_config_db #(virtual mem_intf)::set (null, "uvm_test_top", "VIRTUAL_INTERFACE", mem_if);
  run_test();
end

endmodule
