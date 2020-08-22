// ==============================================================
// File generated on Mon Jun 22 11:53:39 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xpixel_unpack.h"

extern XPixel_unpack_Config XPixel_unpack_ConfigTable[];

XPixel_unpack_Config *XPixel_unpack_LookupConfig(u16 DeviceId) {
	XPixel_unpack_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XPIXEL_UNPACK_NUM_INSTANCES; Index++) {
		if (XPixel_unpack_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XPixel_unpack_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPixel_unpack_Initialize(XPixel_unpack *InstancePtr, u16 DeviceId) {
	XPixel_unpack_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPixel_unpack_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPixel_unpack_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

