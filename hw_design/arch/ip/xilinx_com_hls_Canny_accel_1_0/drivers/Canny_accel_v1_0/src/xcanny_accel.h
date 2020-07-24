// ==============================================================
// File generated on Fri Jul 24 10:37:09 +0800 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XCANNY_ACCEL_H
#define XCANNY_ACCEL_H

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
#include "xcanny_accel_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Axilites_BaseAddress;
} XCanny_accel_Config;
#endif

typedef struct {
    u32 Axilites_BaseAddress;
    u32 IsReady;
} XCanny_accel;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XCanny_accel_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XCanny_accel_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XCanny_accel_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XCanny_accel_ReadReg(BaseAddress, RegOffset) \
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
int XCanny_accel_Initialize(XCanny_accel *InstancePtr, u16 DeviceId);
XCanny_accel_Config* XCanny_accel_LookupConfig(u16 DeviceId);
int XCanny_accel_CfgInitialize(XCanny_accel *InstancePtr, XCanny_accel_Config *ConfigPtr);
#else
int XCanny_accel_Initialize(XCanny_accel *InstancePtr, const char* InstanceName);
int XCanny_accel_Release(XCanny_accel *InstancePtr);
#endif

void XCanny_accel_Start(XCanny_accel *InstancePtr);
u32 XCanny_accel_IsDone(XCanny_accel *InstancePtr);
u32 XCanny_accel_IsIdle(XCanny_accel *InstancePtr);
u32 XCanny_accel_IsReady(XCanny_accel *InstancePtr);
void XCanny_accel_EnableAutoRestart(XCanny_accel *InstancePtr);
void XCanny_accel_DisableAutoRestart(XCanny_accel *InstancePtr);

void XCanny_accel_Set_low_threshold(XCanny_accel *InstancePtr, u32 Data);
u32 XCanny_accel_Get_low_threshold(XCanny_accel *InstancePtr);
void XCanny_accel_Set_high_threshold(XCanny_accel *InstancePtr, u32 Data);
u32 XCanny_accel_Get_high_threshold(XCanny_accel *InstancePtr);

void XCanny_accel_InterruptGlobalEnable(XCanny_accel *InstancePtr);
void XCanny_accel_InterruptGlobalDisable(XCanny_accel *InstancePtr);
void XCanny_accel_InterruptEnable(XCanny_accel *InstancePtr, u32 Mask);
void XCanny_accel_InterruptDisable(XCanny_accel *InstancePtr, u32 Mask);
void XCanny_accel_InterruptClear(XCanny_accel *InstancePtr, u32 Mask);
u32 XCanny_accel_InterruptGetEnabled(XCanny_accel *InstancePtr);
u32 XCanny_accel_InterruptGetStatus(XCanny_accel *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
