// ==============================================================
// File generated on Tue Aug 04 13:24:05 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xcolor_detect.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XColor_detect_CfgInitialize(XColor_detect *InstancePtr, XColor_detect_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Axilites_BaseAddress = ConfigPtr->Axilites_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XColor_detect_Start(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL) & 0x80;
    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL, Data | 0x01);
}

u32 XColor_detect_IsDone(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XColor_detect_IsIdle(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XColor_detect_IsReady(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XColor_detect_EnableAutoRestart(XColor_detect *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL, 0x80);
}

void XColor_detect_DisableAutoRestart(XColor_detect *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_AP_CTRL, 0);
}

void XColor_detect_Set_H_thres(XColor_detect *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_H_THRES_DATA, Data);
}

u32 XColor_detect_Get_H_thres(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_H_THRES_DATA);
    return Data;
}

void XColor_detect_Set_S_thres(XColor_detect *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_S_THRES_DATA, Data);
}

u32 XColor_detect_Get_S_thres(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_S_THRES_DATA);
    return Data;
}

void XColor_detect_Set_V_thres(XColor_detect *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_V_THRES_DATA, Data);
}

u32 XColor_detect_Get_V_thres(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_V_THRES_DATA);
    return Data;
}

XColor_detect_Res XColor_detect_Get_res(XColor_detect *InstancePtr) {
    XColor_detect_Res Data;

    Data.word_0 = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_RES_DATA + 0);
    Data.word_1 = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_RES_DATA + 4);
    Data.word_2 = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_RES_DATA + 8);
    Data.word_3 = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_RES_DATA + 12);
    return Data;
}

u32 XColor_detect_Get_res_vld(XColor_detect *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_RES_CTRL);
    return Data & 0x1;
}

void XColor_detect_InterruptGlobalEnable(XColor_detect *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_GIE, 1);
}

void XColor_detect_InterruptGlobalDisable(XColor_detect *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_GIE, 0);
}

void XColor_detect_InterruptEnable(XColor_detect *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_IER);
    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_IER, Register | Mask);
}

void XColor_detect_InterruptDisable(XColor_detect *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_IER);
    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_IER, Register & (~Mask));
}

void XColor_detect_InterruptClear(XColor_detect *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XColor_detect_WriteReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_ISR, Mask);
}

u32 XColor_detect_InterruptGetEnabled(XColor_detect *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_IER);
}

u32 XColor_detect_InterruptGetStatus(XColor_detect *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XColor_detect_ReadReg(InstancePtr->Axilites_BaseAddress, XCOLOR_DETECT_AXILITES_ADDR_ISR);
}

