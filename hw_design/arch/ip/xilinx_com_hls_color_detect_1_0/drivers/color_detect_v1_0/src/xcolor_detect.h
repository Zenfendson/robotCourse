// ==============================================================
// File generated on Tue Aug 04 13:24:05 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XCOLOR_DETECT_H
#define XCOLOR_DETECT_H

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
#include "xcolor_detect_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Axilites_BaseAddress;
} XColor_detect_Config;
#endif

typedef struct {
    u32 Axilites_BaseAddress;
    u32 IsReady;
} XColor_detect;

typedef struct {
    u32 word_0;
    u32 word_1;
    u32 word_2;
    u32 word_3;
} XColor_detect_Res;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XColor_detect_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XColor_detect_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XColor_detect_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XColor_detect_ReadReg(BaseAddress, RegOffset) \
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
int XColor_detect_Initialize(XColor_detect *InstancePtr, u16 DeviceId);
XColor_detect_Config* XColor_detect_LookupConfig(u16 DeviceId);
int XColor_detect_CfgInitialize(XColor_detect *InstancePtr, XColor_detect_Config *ConfigPtr);
#else
int XColor_detect_Initialize(XColor_detect *InstancePtr, const char* InstanceName);
int XColor_detect_Release(XColor_detect *InstancePtr);
#endif

void XColor_detect_Start(XColor_detect *InstancePtr);
u32 XColor_detect_IsDone(XColor_detect *InstancePtr);
u32 XColor_detect_IsIdle(XColor_detect *InstancePtr);
u32 XColor_detect_IsReady(XColor_detect *InstancePtr);
void XColor_detect_EnableAutoRestart(XColor_detect *InstancePtr);
void XColor_detect_DisableAutoRestart(XColor_detect *InstancePtr);

void XColor_detect_Set_H_thres(XColor_detect *InstancePtr, u32 Data);
u32 XColor_detect_Get_H_thres(XColor_detect *InstancePtr);
void XColor_detect_Set_S_thres(XColor_detect *InstancePtr, u32 Data);
u32 XColor_detect_Get_S_thres(XColor_detect *InstancePtr);
void XColor_detect_Set_V_thres(XColor_detect *InstancePtr, u32 Data);
u32 XColor_detect_Get_V_thres(XColor_detect *InstancePtr);
XColor_detect_Res XColor_detect_Get_res(XColor_detect *InstancePtr);
u32 XColor_detect_Get_res_vld(XColor_detect *InstancePtr);

void XColor_detect_InterruptGlobalEnable(XColor_detect *InstancePtr);
void XColor_detect_InterruptGlobalDisable(XColor_detect *InstancePtr);
void XColor_detect_InterruptEnable(XColor_detect *InstancePtr, u32 Mask);
void XColor_detect_InterruptDisable(XColor_detect *InstancePtr, u32 Mask);
void XColor_detect_InterruptClear(XColor_detect *InstancePtr, u32 Mask);
u32 XColor_detect_InterruptGetEnabled(XColor_detect *InstancePtr);
u32 XColor_detect_InterruptGetStatus(XColor_detect *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
