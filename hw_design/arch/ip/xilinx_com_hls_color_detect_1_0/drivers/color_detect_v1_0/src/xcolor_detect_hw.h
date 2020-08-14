// ==============================================================
// File generated on Tue Aug 04 13:24:05 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// AXILiteS
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : Data signal of H_thres
//        bit 15~0 - H_thres[15:0] (Read/Write)
//        others   - reserved
// 0x14 : reserved
// 0x18 : Data signal of S_thres
//        bit 15~0 - S_thres[15:0] (Read/Write)
//        others   - reserved
// 0x1c : reserved
// 0x20 : Data signal of V_thres
//        bit 15~0 - V_thres[15:0] (Read/Write)
//        others   - reserved
// 0x24 : reserved
// 0x28 : Data signal of res
//        bit 31~0 - res[31:0] (Read)
// 0x2c : Data signal of res
//        bit 31~0 - res[63:32] (Read)
// 0x30 : Data signal of res
//        bit 31~0 - res[95:64] (Read)
// 0x34 : Data signal of res
//        bit 31~0 - res[127:96] (Read)
// 0x38 : Control signal of res
//        bit 0  - res_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL      0x00
#define XCOLOR_DETECT_AXILITES_ADDR_GIE          0x04
#define XCOLOR_DETECT_AXILITES_ADDR_IER          0x08
#define XCOLOR_DETECT_AXILITES_ADDR_ISR          0x0c
#define XCOLOR_DETECT_AXILITES_ADDR_H_THRES_DATA 0x10
#define XCOLOR_DETECT_AXILITES_BITS_H_THRES_DATA 16
#define XCOLOR_DETECT_AXILITES_ADDR_S_THRES_DATA 0x18
#define XCOLOR_DETECT_AXILITES_BITS_S_THRES_DATA 16
#define XCOLOR_DETECT_AXILITES_ADDR_V_THRES_DATA 0x20
#define XCOLOR_DETECT_AXILITES_BITS_V_THRES_DATA 16
#define XCOLOR_DETECT_AXILITES_ADDR_RES_DATA     0x28
#define XCOLOR_DETECT_AXILITES_BITS_RES_DATA     128
#define XCOLOR_DETECT_AXILITES_ADDR_RES_CTRL     0x38

