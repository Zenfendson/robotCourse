// ==============================================================
// File generated on Mon Jun 22 11:53:18 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XPIXEL_PACK_H
#define XPIXEL_PACK_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xpixel_pack_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Axilites_BaseAddress;
} XPixel_pack_Config;
#endif

typedef struct {
    u32 Axilites_BaseAddress;
    u32 IsReady;
} XPixel_pack;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XPixel_pack_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XPixel_pack_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XPixel_pack_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XPixel_pack_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XPixel_pack_Initialize(XPixel_pack *InstancePtr, u16 DeviceId);
XPixel_pack_Config* XPixel_pack_LookupConfig(u16 DeviceId);
int XPixel_pack_CfgInitialize(XPixel_pack *InstancePtr, XPixel_pack_Config *ConfigPtr);
#else
int XPixel_pack_Initialize(XPixel_pack *InstancePtr, const char* InstanceName);
int XPixel_pack_Release(XPixel_pack *InstancePtr);
#endif


void XPixel_pack_Set_mode(XPixel_pack *InstancePtr, u32 Data);
u32 XPixel_pack_Get_mode(XPixel_pack *InstancePtr);
void XPixel_pack_Set_alpha_V(XPixel_pack *InstancePtr, u32 Data);
u32 XPixel_pack_Get_alpha_V(XPixel_pack *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif