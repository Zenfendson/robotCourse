// ==============================================================
// File generated on Mon Jun 22 11:53:18 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xpixel_pack.h"

extern XPixel_pack_Config XPixel_pack_ConfigTable[];

XPixel_pack_Config *XPixel_pack_LookupConfig(u16 DeviceId) {
	XPixel_pack_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XPIXEL_PACK_NUM_INSTANCES; Index++) {
		if (XPixel_pack_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XPixel_pack_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPixel_pack_Initialize(XPixel_pack *InstancePtr, u16 DeviceId) {
	XPixel_pack_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPixel_pack_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPixel_pack_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

