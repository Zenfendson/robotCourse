// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.3
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module xfExtractPixels_1 (
        ap_ready,
        val1_V_read,
        ap_return
);


output   ap_ready;
input  [7:0] val1_V_read;
output  [7:0] ap_return;

assign ap_ready = 1'b1;

assign ap_return = val1_V_read;

endmodule //xfExtractPixels_1
