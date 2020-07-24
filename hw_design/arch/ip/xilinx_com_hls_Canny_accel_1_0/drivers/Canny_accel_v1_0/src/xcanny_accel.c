// ==============================================================
// File generated on Fri Jul 24 10:37:09 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xcanny_accel.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XCanny_accel_CfgInitialize(XCanny_accel *InstancePtr, XCanny_accel_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Axilites_BaseAddress = ConfigPtr->Axilites_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XCanny_accel_Start(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL) & 0x80;
    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL, Data | 0x01);
}

u32 XCanny_accel_IsDone(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XCanny_accel_IsIdle(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XCanny_accel_IsReady(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XCanny_accel_EnableAutoRestart(XCanny_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL, 0x80);
}

void XCanny_accel_DisableAutoRestart(XCanny_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_AP_CTRL, 0);
}

void XCanny_accel_Set_low_threshold(XCanny_accel *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_LOW_THRESHOLD_DATA, Data);
}

u32 XCanny_accel_Get_low_threshold(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_LOW_THRESHOLD_DATA);
    return Data;
}

void XCanny_accel_Set_high_threshold(XCanny_accel *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_HIGH_THRESHOLD_DATA, Data);
}

u32 XCanny_accel_Get_high_threshold(XCanny_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_HIGH_THRESHOLD_DATA);
    return Data;
}

void XCanny_accel_InterruptGlobalEnable(XCanny_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_GIE, 1);
}

void XCanny_accel_InterruptGlobalDisable(XCanny_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_GIE, 0);
}

void XCanny_accel_InterruptEnable(XCanny_accel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_IER);
    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_IER, Register | Mask);
}

void XCanny_accel_InterruptDisable(XCanny_accel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_IER);
    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_IER, Register & (~Mask));
}

void XCanny_accel_InterruptClear(XCanny_accel *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCanny_accel_WriteReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_ISR, Mask);
}

u32 XCanny_accel_InterruptGetEnabled(XCanny_accel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_IER);
}

u32 XCanny_accel_InterruptGetStatus(XCanny_accel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCanny_accel_ReadReg(InstancePtr->Axilites_BaseAddress, XCANNY_ACCEL_AXILITES_ADDR_ISR);
}

