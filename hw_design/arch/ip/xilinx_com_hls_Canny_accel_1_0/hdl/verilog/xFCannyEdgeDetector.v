// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.3
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module xFCannyEdgeDetector (
        ap_clk,
        ap_rst,
        ap_start,
        start_full_n,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        start_out,
        start_write,
        p_src_mat_V_V_dout,
        p_src_mat_V_V_empty_n,
        p_src_mat_V_V_read,
        out_strm_V_V_din,
        out_strm_V_V_full_n,
        out_strm_V_V_write,
        p_lowthreshold_dout,
        p_lowthreshold_empty_n,
        p_lowthreshold_read,
        p_highthreshold_dout,
        p_highthreshold_empty_n,
        p_highthreshold_read
);

parameter    ap_ST_fsm_state1 = 2'd1;
parameter    ap_ST_fsm_state2 = 2'd2;

input   ap_clk;
input   ap_rst;
input   ap_start;
input   start_full_n;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
output   start_out;
output   start_write;
input  [7:0] p_src_mat_V_V_dout;
input   p_src_mat_V_V_empty_n;
output   p_src_mat_V_V_read;
output  [1:0] out_strm_V_V_din;
input   out_strm_V_V_full_n;
output   out_strm_V_V_write;
input  [7:0] p_lowthreshold_dout;
input   p_lowthreshold_empty_n;
output   p_lowthreshold_read;
input  [7:0] p_highthreshold_dout;
input   p_highthreshold_empty_n;
output   p_highthreshold_read;

reg ap_done;
reg ap_idle;
reg start_write;
reg p_src_mat_V_V_read;
reg out_strm_V_V_write;
reg p_lowthreshold_read;
reg p_highthreshold_read;

reg    real_start;
reg    start_once_reg;
reg    ap_done_reg;
(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    internal_ap_ready;
reg    p_lowthreshold_blk_n;
reg    p_highthreshold_blk_n;
reg   [7:0] p_lowthreshold_read_reg_92;
reg    ap_block_state1;
reg   [7:0] p_highthreshold_read_reg_97;
wire    grp_xFCannyKernel_fu_80_p_src_mat_V_V_read;
wire   [1:0] grp_xFCannyKernel_fu_80_p_dst_mat_V_V_din;
wire    grp_xFCannyKernel_fu_80_p_dst_mat_V_V_write;
wire    grp_xFCannyKernel_fu_80_ap_start;
wire    grp_xFCannyKernel_fu_80_ap_done;
wire    grp_xFCannyKernel_fu_80_ap_ready;
wire    grp_xFCannyKernel_fu_80_ap_idle;
reg    grp_xFCannyKernel_fu_80_ap_continue;
reg    grp_xFCannyKernel_fu_80_ap_start_reg;
reg    ap_block_state1_ignore_call6;
wire    ap_CS_fsm_state2;
wire    ap_sync_grp_xFCannyKernel_fu_80_ap_ready;
wire    ap_sync_grp_xFCannyKernel_fu_80_ap_done;
reg    ap_block_state2_on_subcall_done;
reg    ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready;
reg    ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done;
reg   [1:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 start_once_reg = 1'b0;
#0 ap_done_reg = 1'b0;
#0 ap_CS_fsm = 2'd1;
#0 grp_xFCannyKernel_fu_80_ap_start_reg = 1'b0;
#0 ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready = 1'b0;
#0 ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done = 1'b0;
end

xFCannyKernel grp_xFCannyKernel_fu_80(
    .p_src_mat_V_V_dout(p_src_mat_V_V_dout),
    .p_src_mat_V_V_empty_n(p_src_mat_V_V_empty_n),
    .p_src_mat_V_V_read(grp_xFCannyKernel_fu_80_p_src_mat_V_V_read),
    .p_dst_mat_V_V_din(grp_xFCannyKernel_fu_80_p_dst_mat_V_V_din),
    .p_dst_mat_V_V_full_n(out_strm_V_V_full_n),
    .p_dst_mat_V_V_write(grp_xFCannyKernel_fu_80_p_dst_mat_V_V_write),
    .p_lowthreshold(p_lowthreshold_read_reg_92),
    .p_highthreshold(p_highthreshold_read_reg_97),
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .p_lowthreshold_ap_vld(1'b1),
    .p_highthreshold_ap_vld(1'b1),
    .ap_start(grp_xFCannyKernel_fu_80_ap_start),
    .ap_done(grp_xFCannyKernel_fu_80_ap_done),
    .ap_ready(grp_xFCannyKernel_fu_80_ap_ready),
    .ap_idle(grp_xFCannyKernel_fu_80_ap_idle),
    .ap_continue(grp_xFCannyKernel_fu_80_ap_continue)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
            ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done <= 1'b0;
        end else if ((grp_xFCannyKernel_fu_80_ap_done == 1'b1)) begin
            ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
            ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready <= 1'b0;
        end else if ((grp_xFCannyKernel_fu_80_ap_ready == 1'b1)) begin
            ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_xFCannyKernel_fu_80_ap_start_reg <= 1'b0;
    end else begin
        if ((((ap_sync_grp_xFCannyKernel_fu_80_ap_ready == 1'b0) & (1'b1 == ap_CS_fsm_state2)) | (~((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1)))) begin
            grp_xFCannyKernel_fu_80_ap_start_reg <= 1'b1;
        end else if ((grp_xFCannyKernel_fu_80_ap_ready == 1'b1)) begin
            grp_xFCannyKernel_fu_80_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        start_once_reg <= 1'b0;
    end else begin
        if (((internal_ap_ready == 1'b0) & (real_start == 1'b1))) begin
            start_once_reg <= 1'b1;
        end else if ((internal_ap_ready == 1'b1)) begin
            start_once_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((~((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        p_highthreshold_read_reg_97 <= p_highthreshold_dout;
        p_lowthreshold_read_reg_92 <= p_lowthreshold_dout;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = ap_done_reg;
    end
end

always @ (*) begin
    if (((real_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
        grp_xFCannyKernel_fu_80_ap_continue = 1'b1;
    end else begin
        grp_xFCannyKernel_fu_80_ap_continue = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
        internal_ap_ready = 1'b1;
    end else begin
        internal_ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        out_strm_V_V_write = grp_xFCannyKernel_fu_80_p_dst_mat_V_V_write;
    end else begin
        out_strm_V_V_write = 1'b0;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        p_highthreshold_blk_n = p_highthreshold_empty_n;
    end else begin
        p_highthreshold_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        p_highthreshold_read = 1'b1;
    end else begin
        p_highthreshold_read = 1'b0;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        p_lowthreshold_blk_n = p_lowthreshold_empty_n;
    end else begin
        p_lowthreshold_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        p_lowthreshold_read = 1'b1;
    end else begin
        p_lowthreshold_read = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        p_src_mat_V_V_read = grp_xFCannyKernel_fu_80_p_src_mat_V_V_read;
    end else begin
        p_src_mat_V_V_read = 1'b0;
    end
end

always @ (*) begin
    if (((start_full_n == 1'b0) & (start_once_reg == 1'b0))) begin
        real_start = 1'b0;
    end else begin
        real_start = ap_start;
    end
end

always @ (*) begin
    if (((start_once_reg == 1'b0) & (real_start == 1'b1))) begin
        start_write = 1'b1;
    end else begin
        start_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == ap_block_state2_on_subcall_done))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

always @ (*) begin
    ap_block_state1 = ((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1));
end

always @ (*) begin
    ap_block_state1_ignore_call6 = ((real_start == 1'b0) | (p_highthreshold_empty_n == 1'b0) | (p_lowthreshold_empty_n == 1'b0) | (ap_done_reg == 1'b1));
end

always @ (*) begin
    ap_block_state2_on_subcall_done = ((ap_sync_grp_xFCannyKernel_fu_80_ap_ready & ap_sync_grp_xFCannyKernel_fu_80_ap_done) == 1'b0);
end

assign ap_ready = internal_ap_ready;

assign ap_sync_grp_xFCannyKernel_fu_80_ap_done = (grp_xFCannyKernel_fu_80_ap_done | ap_sync_reg_grp_xFCannyKernel_fu_80_ap_done);

assign ap_sync_grp_xFCannyKernel_fu_80_ap_ready = (grp_xFCannyKernel_fu_80_ap_ready | ap_sync_reg_grp_xFCannyKernel_fu_80_ap_ready);

assign grp_xFCannyKernel_fu_80_ap_start = grp_xFCannyKernel_fu_80_ap_start_reg;

assign out_strm_V_V_din = grp_xFCannyKernel_fu_80_p_dst_mat_V_V_din;

assign start_out = real_start;

endmodule //xFCannyEdgeDetector