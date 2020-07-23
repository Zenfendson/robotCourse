/******************************************************************************
 *  Copyright (c) 2016, Xilinx, Inc.
 *  All rights reserved.
 * 
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1.  Redistributions of source code must retain the above copyright notice, 
 *     this list of conditions and the following disclaimer.
 *
 *  2.  Redistributions in binary form must reproduce the above copyright 
 *      notice, this list of conditions and the following disclaimer in the 
 *      documentation and/or other materials provided with the distribution.
 *
 *  3.  Neither the name of the copyright holder nor the names of its 
 *      contributors may be used to endorse or promote products derived from 
 *      this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 *  OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
 *  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 *  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************/
/******************************************************************************
 *
 *
 * @file arduino_grove_imu.c
 *
 * IOP code (MicroBlaze) for grove IMU 10DOF.
 * The grove IMU has to be connected to an arduino interface 
 * via a shield socket.
 * Grove IMU is read only, and has IIC interface.
 * Hardware version 1.1.
 * http://www.seeedstudio.com/wiki/Grove_-_IMU_10DOF
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- --- ------- -----------------------------------------------
 * 1.00a yrq 04/25/16 release
 * 1.00d yrq 07/26/16 separate pmod and arduino
 *
 * </pre>
 *
 *****************************************************************************/

#include "MPU9250.h"
#include "circular_buffer.h"
#include "timer.h"
#include "i2c.h"
#include <xparameters.h>
#include "AXI_PWM.h"
#include "AXI_Encoder.h"
#include "xil_io.h"

#define NUM_SAMPLES              100

// Mailbox commands
#define RESET 1
#define GET_ACCL_DATA 3
#define GET_GYRO_DATA 5
#define GET_COMPASS_DATA 7
#define GET_ENCODER_DATA 9
#define SET_ENCODER_DIR 11
#define SET_ENCODER_SAMPLE_INTERVAL_MS 13
#define SET_MOTOR_FREQ 15
#define SET_MOTOR_PWM 17
#define SET_MOTOR_DIR 19
#define SET_SERVO_PWM 21

static i2c device;

// Byte operations
int iic_readBytes(uint8_t devAddr, uint8_t regAddr, 
                uint8_t length, uint8_t *data){
	i2c_write(device, devAddr, &regAddr, 1);
    i2c_read(device, devAddr, data, length);
    return length;
}

int iic_readByte(uint8_t devAddr, uint8_t regAddr, uint8_t *data){
    i2c_write(device, devAddr, &regAddr, 1);
    i2c_read(device, devAddr, data, 1);
    return 1;
}

void iic_writeBytes(uint8_t devAddr, uint8_t regAddr, 
                uint8_t length, uint8_t *data){
    int i;
    int len_total = (int)length+1;
    uint8_t temp[len_total];
    temp[0] = regAddr;
    for (i=1;i<len_total;i++){
        temp[i]=data[i-1];
    }
    i2c_write(device, devAddr, temp, len_total);
}

void iic_writeByte(uint8_t devAddr, uint8_t regAddr, uint8_t *data){
    uint8_t temp[2];
    temp[0] = regAddr;
    temp[1] = *data;
    i2c_write(device, devAddr, temp, 2);
}

// Bit operations
int8_t iic_readBits(uint8_t devAddr, uint8_t regAddr, 
                    uint8_t bitStart, uint8_t width, uint8_t *data) {
    /*
     * 01101001 read byte
     * 76543210 bit numbers
     *    xxx   parameters: bitStart=4, width=3
     *    010   masked
     *   -> 010 shifted
     */
    uint8_t count, b;
    uint8_t mask;
    if ((count = iic_readBytes(devAddr, regAddr, 1, &b)) != 0) {
        mask = ((1 << width) - 1) << (bitStart - width + 1);
        b &= mask;
        b >>= (bitStart - width + 1);
        *data = b;
    }
    return count;
}
int8_t iic_readBit(uint8_t devAddr, uint8_t regAddr, 
                   uint8_t bitStart, uint8_t *data) {
    return iic_readBits(devAddr, regAddr, bitStart, (uint8_t) 1, data);
}
    
void iic_writeBits(uint8_t devAddr, uint8_t regAddr, 
                     uint8_t bitStart, uint8_t width, uint8_t *data) {
    /*
     * 010 value to write
     * 76543210 bit numbers
     *    xxx   parameters: bitStart=4, width=3
     * 00011100 mask byte
     * 10101111 original value (sample)
     * 10100011 original & ~mask
     * 10101011 masked | value
     */
    uint8_t b, temp;
    temp = *data;
    if (iic_readBytes(devAddr, regAddr, 1, &b) != 0) {
        uint8_t mask = ((1 << width) - 1) << (bitStart - width + 1);
        // shift data into correct position
        temp <<= (bitStart - width + 1);
        // zero all non-important bits in data
        temp &= mask;
        // zero all important bits in existing byte
        b &= ~(mask);
        // combine data with existing byte
        b |= temp;
        iic_writeByte(devAddr, regAddr, &b);
    }
}
void iic_writeBit(uint8_t devAddr, uint8_t regAddr, 
                    uint8_t bitStart, uint8_t *data) {
    iic_writeBits(devAddr, regAddr, bitStart, (uint8_t) 1, data);
}

// MPU9250 driver functions
void mpu_init() {
    //device setup
    mpuAddr = MPU9250_DEFAULT_ADDRESS;
    mpu_setClockSource(MPU9250_CLOCK_INTERNAL);
    mpu_setFullScaleGyroRange(MPU9250_GYRO_FS_250);
    mpu_setFullScaleAccelRange(MPU9250_ACCEL_FS_2);
    mpu_setSleepEnabled(false);
    
}

void mpu_setClockSource(uint8_t source) {
    iic_writeBits(mpuAddr, MPU9250_RA_PWR_MGMT_1, MPU9250_PWR1_CLKSEL_BIT, 
                    MPU9250_PWR1_CLKSEL_LENGTH, &source);
}

void mpu_setFullScaleGyroRange(uint8_t range) {
    iic_writeBits(mpuAddr, MPU9250_RA_GYRO_CONFIG, MPU9250_GCONFIG_FS_SEL_BIT, 
                    MPU9250_GCONFIG_FS_SEL_LENGTH, &range);
}

void mpu_setFullScaleAccelRange(uint8_t range) {
    iic_writeBits(mpuAddr, MPU9250_RA_ACCEL_CONFIG, 
                    MPU9250_ACONFIG_AFS_SEL_BIT, 
                    MPU9250_ACONFIG_AFS_SEL_LENGTH, &range);
}
            
void mpu_getMotion9(int16_t* ax, int16_t* ay, int16_t* az, 
                    int16_t* gx, int16_t* gy, int16_t* gz, 
                    int16_t* mx, int16_t* my, int16_t* mz) {
    
    //get accel and gyro
    iic_readBytes(mpuAddr, MPU9250_RA_ACCEL_XOUT_H, 14, buffer);
    delay_us(60);
    *ax = (((int16_t)buffer[0]) << 8) | buffer[1];
    *ay = (((int16_t)buffer[2]) << 8) | buffer[3];
    *az = (((int16_t)buffer[4]) << 8) | buffer[5];
    *gx = (((int16_t)buffer[8]) << 8) | buffer[9];
    *gy = (((int16_t)buffer[10]) << 8) | buffer[11];
    *gz = (((int16_t)buffer[12]) << 8) | buffer[13];
    
    //read mag
    uint8_t data;
    data = 0x02;
    //set i2c bypass enable pin to access magnetometer
    iic_writeByte(mpuAddr, MPU9250_RA_INT_PIN_CFG, &data);
    delay_us(10);
    data = 0x01;
    //enable the magnetometer
    iic_writeByte(MPU9150_RA_MAG_ADDRESS, 0x0A, &data);
    delay_us(10);
    iic_readBytes(MPU9150_RA_MAG_ADDRESS, MPU9150_RA_MAG_XOUT_L, 6, buffer);
    delay_us(60);
    *mx = (((int16_t)buffer[1]) << 8) | buffer[0];
    *my = (((int16_t)buffer[3]) << 8) | buffer[2];
    *mz = (((int16_t)buffer[5]) << 8) | buffer[4];
}

void mpu_reset() {
    uint8_t data = 0x01;
    iic_writeBit(mpuAddr, MPU9250_RA_PWR_MGMT_1, 
                    MPU9250_PWR1_DEVICE_RESET_BIT, &data);
}

void mpu_setSleepEnabled(uint8_t enabled) {
    iic_writeBit(mpuAddr, MPU9250_RA_PWR_MGMT_1, 
                    MPU9250_PWR1_SLEEP_BIT, &enabled);
}

// BMP180 driver functions
void motor_init()
{
	//slv0: duty of the PWM
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG0_OFFSET, 0);
	//slv1: freq_ratio, PWM freq = in_clk/freq_ratio;
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG1_OFFSET, 100000);
	//slv2: direction of Motor
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG2_OFFSET, 0);
}

void servo_init()
{
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_SERVO_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG0_OFFSET, 300);
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_SERVO_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG1_OFFSET, 500000);
}

void encoder_init()
{
	//slv0: data (read only)
	//slv1: clock_per_ms
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG1_OFFSET, 100000);
	//slv2: sample interval in ms
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG2_OFFSET, 10);
	//slv3: direction
	AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG3_OFFSET, 0);
}
int main()
{
   int cmd;
   int16_t ax, ay, az;
   int16_t gx, gy, gz;
   int16_t mx, my, mz;
   int val;
   // Initialization
   device = i2c_open_device(0);
   mpu_init();
   motor_init();
   servo_init();
   encoder_init();
   // Run application
   while(1){
     // wait and store valid command
      while((MAILBOX_CMD_ADDR & 0x01)==0);
      cmd = MAILBOX_CMD_ADDR;

      switch(cmd){
      	  case RESET:
      		  mpu_reset();
      		  motor_init();
      		  servo_init();
      		  encoder_init();
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case GET_ACCL_DATA:
      		  mpu_getMotion9(&ax, &ay, &az, &gx, &gy, &gz, &mx, &my, &mz);
      		  MAILBOX_DATA(0) = (signed int)ax;
      		  MAILBOX_DATA(1) = (signed int)ay;
      		  MAILBOX_DATA(2) = (signed int)az;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case GET_GYRO_DATA:
      		  mpu_getMotion9(&ax, &ay, &az, &gx, &gy, &gz, &mx, &my, &mz);
      		  MAILBOX_DATA(0) = (signed int)gx;
      		  MAILBOX_DATA(1) = (signed int)gy;
      		  MAILBOX_DATA(2) = (signed int)gz;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case GET_COMPASS_DATA:
      		  mpu_getMotion9(&ax, &ay, &az, &gx, &gy, &gz, &mx, &my, &mz);
      		  MAILBOX_DATA(0) = (signed int)mx;
      		  MAILBOX_DATA(1) = (signed int)my;
      		  MAILBOX_DATA(2) = (signed int)mz;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case GET_ENCODER_DATA:
      		  val = AXI_ENCODER_mReadReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG0_OFFSET);
      		  MAILBOX_DATA(0) = val;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case SET_ENCODER_DIR:
      		  val = MAILBOX_DATA(0);
      		  AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG3_OFFSET, val);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case SET_ENCODER_SAMPLE_INTERVAL_MS:
      		  val = MAILBOX_DATA(0);
      		  AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_S_AXI_BASEADDR, AXI_ENCODER_S_AXI_SLV_REG2_OFFSET, val);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_FREQ:
      		  val = MAILBOX_DATA(0);
      		  AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG1_OFFSET, val);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_PWM:
      		  val = MAILBOX_DATA(0);
      		  AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG0_OFFSET, val);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_DIR:
      		  val = MAILBOX_DATA(0);
      		  AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_MOTOR_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG2_OFFSET, val);
      	      MAILBOX_CMD_ADDR = 0x0;
      	      break;

      	  case SET_SERVO_PWM:
      	      val = MAILBOX_DATA(0);
      	      AXI_ENCODER_mWriteReg(XPAR_CAR_IOP_ARDUINO_AXI_PWM_SERVO_S_AXI_BASEADDR, AXI_PWM_S_AXI_SLV_REG0_OFFSET, val);
      	      MAILBOX_CMD_ADDR = 0x0;
      	      break;

      	  default:
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
      }
   }
   return 0;
}
