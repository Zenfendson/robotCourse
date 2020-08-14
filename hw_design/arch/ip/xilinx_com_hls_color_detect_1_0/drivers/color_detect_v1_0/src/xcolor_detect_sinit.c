// ==============================================================
// File generated on Tue Aug 04 13:24:05 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xcolor_detect.h"

extern XColor_detect_Config XColor_detect_ConfigTable[];

XColor_detect_Config *XColor_detect_LookupConfig(u16 DeviceId) {
	XColor_detect_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCOLOR_DETECT_NUM_INSTANCES; Index++) {
		if (XColor_detect_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XColor_detect_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XColor_detect_Initialize(XColor_detect *InstancePtr, u16 DeviceId) {
	XColor_detect_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XColor_detect_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XColor_detect_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

