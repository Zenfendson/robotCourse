// ==============================================================
// File generated on Wed Jul 22 09:49:56 +0800 2020
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

