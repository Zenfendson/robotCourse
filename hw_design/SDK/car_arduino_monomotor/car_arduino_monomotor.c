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
#include "xil_io.h"
#include "motor.h"
#include "servo.h"
#include "xio_switch.h"
#include "ultrasonic_ranger.h"
#include "encoder.h"
#include "XTmrCtr.h"
#include "Xintc.h"
#include "math.h"

typedef struct
{
	float target_servo_angle;
	int velocity;
	Servo *servo;
	Encoder *encoderL;
	Encoder *encoderR;
	Motor *motorL;
	Motor *motorR;
}ISR_param;

#define NUM_SAMPLES              100

// Mailbox commands
#define INIT				1
#define RESET 				3
#define SET_IIC_PINS			5
#define GET_ACCL_DATA 		7
#define GET_GYRO_DATA 		9
#define GET_COMPASS_DATA 	11
#define GET_ENCODER_DATA 	13
#define SET_ENCODER_DIR 	15
#define SET_MOTOR_PINS 		17
#define SET_MOTOR_DIR 		19
#define SET_VELOCITY  		21
#define SET_SERVO_ANGLE  	23
#define SET_SERVO_PIN 		25
#define GET_ULRANGER_DATA 	27
#define SET_MOTOR_MODE      29

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

void interruptSetup(XIntc * InterruptController,XTmrCtr * TimerCounterInst,int TMRCTR_DEVICE_ID,int INTC_DEVICE_ID,int TMRCTR_INTERRUPT_ID,int TIMER_CNTR,void * ISR, void * param)
{
	XTmrCtr_Initialize(TimerCounterInst, TMRCTR_DEVICE_ID);

	XIntc_Initialize(InterruptController, INTC_DEVICE_ID);

	XIntc_Connect(InterruptController,TMRCTR_INTERRUPT_ID,(XInterruptHandler)XTmrCtr_InterruptHandler,TimerCounterInst);

	XIntc_Start(InterruptController, XIN_REAL_MODE);

	XIntc_Enable(InterruptController, TMRCTR_INTERRUPT_ID);

	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XIntc_InterruptHandler,InterruptController);

	Xil_ExceptionEnable();

	XTmrCtr_SetHandler(TimerCounterInst,ISR,param);

	XTmrCtr_SetOptions(TimerCounterInst, TIMER_CNTR,XTC_INT_MODE_OPTION | XTC_AUTO_RELOAD_OPTION | XTC_DOWN_COUNT_OPTION);

	XTmrCtr_SetResetValue(TimerCounterInst, TIMER_CNTR, XPAR_MICROBLAZE_CORE_CLOCK_FREQ_HZ / 100);

	XTmrCtr_Start(TimerCounterInst, TIMER_CNTR);
}
const float Velocity_KP = 0.6, Velocity_KD =  0.6,Encoder2pwm = 41.7;
int Incremental_PD (int Target,int Encoder)
{
	static float Bias,Pwm,Last_bias;
	Bias=Target - Encoder*Encoder2pwm;
	Pwm+=Velocity_KD*(Bias-Last_bias)+Velocity_KP*Bias;
	//Pwm+=Velocity_KP*Bias;
	if(Pwm>1000)Pwm=1000;
	if(Pwm<-1000)Pwm=-1000;
	Last_bias=Bias;
	return Pwm;
}
#define SERVO_VAL_MIN 0
#define SERVO_VAL_MAX 180
#define PWM_MIN 120
#define PWM_MAX 480
int map_servo(int value)
{
	int res;
	if(value<SERVO_VAL_MIN)value = SERVO_VAL_MIN;
	if(value>SERVO_VAL_MAX)value = SERVO_VAL_MAX;
	float scale = (float)(PWM_MAX - PWM_MIN)/(float)(SERVO_VAL_MAX - SERVO_VAL_MIN);
	res = value*scale + PWM_MIN;
	return res;
}
void timer_10ms_ISR(void * CallBackRef)
{
	ISR_param * param = (ISR_param *)CallBackRef;
	int Motor;
	int servo_val;
	int Velocity_Left = get_encoder_data(param->encoderL);
	if(param->target_servo_angle < -45)param->target_servo_angle = -45;
	if(param->target_servo_angle > 45)param->target_servo_angle = 45;
	servo_val = 95 + param->target_servo_angle;
	servo_val = map_servo(servo_val);
	Motor = Incremental_PD(param->velocity, Velocity_Left);
	set_servo_pwm( param->servo,servo_val);
	set_motor_pwm( param->motorL,Motor);
}
static Servo servo;
static Motor motor0,motor1;
static Encoder encoder0,encoder1;
static Ultrasonic_ranger ulranger;
static XIntc intc;
static XTmrCtr timer_10ms;
int main()
{
   ISR_param param;
   param.motorL = &motor0;
   param.motorR = &motor1;
   param.encoderL = &encoder0;
   param.encoderR = &encoder1;
   param.servo = &servo;
   int cmd;
   int16_t ax, ay, az;
   int16_t gx, gy, gz;
   int16_t mx, my, mz;
   int val,val1,val2,val3;
   interruptSetup(&intc,&timer_10ms,XPAR_TMRCTR_1_DEVICE_ID,XPAR_INTC_0_DEVICE_ID,XPAR_INTC_0_TMRCTR_1_VEC_ID,0,timer_10ms_ISR,&param);
   makeURInstance(&ulranger,XPAR_CAR_IOP_ARDUINO_AXI_ULTRASONIC_RANGER_0_S_AXI_BASEADDR);
   makeServoInstance(&servo,XPAR_CAR_IOP_ARDUINO_AXI_PWM_SERVO_S_AXI_BASEADDR);
   makeEncoderInstance(&encoder0,XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_0_S_AXI_BASEADDR);
   makeEncoderInstance(&encoder1,XPAR_CAR_IOP_ARDUINO_AXI_ENCODER_1_S_AXI_BASEADDR);
   makeMotorInstance(&motor0,0);
   makeMotorInstance(&motor1,1);
   init_io_switch();
   set_motor_ctrl_mode(&motor0,SIMPLE);
   set_motor_ctrl_mode(&motor1,SIMPLE);
   // Initialization
   device = i2c_open_device(0);
   // Run application
   while(1){
     // wait and store valid command
      while((MAILBOX_CMD_ADDR & 0x01)==0);
      cmd = MAILBOX_CMD_ADDR;

      switch(cmd){
      	  case INIT:
      		  motor_init(&motor0);
      		  motor_init(&motor1);
      		  servo_init(&servo);
      		  encoder_init(&encoder0);
      		  encoder_init(&encoder1);
      		  mpu_init();
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case RESET:
      		  mpu_reset();
      		  param.target_servo_angle = 0;
      		  param.velocity = 0;
      		  motor_init(&motor0);
      		  motor_init(&motor1);
      		  servo_init(&servo);
      		  encoder_init(&encoder0);
      		  encoder_init(&encoder1);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_IIC_PINS:
      		  val = MAILBOX_DATA(0);
      		  val1 = MAILBOX_DATA(1);
      		  set_pin(val,SDA0);
      		  set_pin(val1,SCL0);
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
      		  val = get_encoder_data(&encoder0);
      		  val1 = get_encoder_data(&encoder1);
      		  MAILBOX_DATA(0) = val;
      		  MAILBOX_DATA(1) = val1;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
            
      	  case SET_ENCODER_DIR:
      		  val = MAILBOX_DATA(0);
      		  val1 = MAILBOX_DATA(1);
      		  set_encoder_dir(&encoder0,val);
      		  set_encoder_dir(&encoder1,val1);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_PINS:
      		  val = MAILBOX_DATA(0);
      		  val1 = MAILBOX_DATA(1);
      	 	  val2 = MAILBOX_DATA(2);
      		  val3 = MAILBOX_DATA(3);
      		  set_motor_pins(&motor0,val,val1);
      		  set_motor_pins(&motor1,val2,val3);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_VELOCITY:
      		  val = MAILBOX_DATA(0);
      		  param.velocity = val;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_DIR:
      		  val = MAILBOX_DATA(0);
      		  val1 = MAILBOX_DATA(1);
      		  set_motor_dir(&motor0, val);
      		  set_motor_dir(&motor1, val1);
      	      MAILBOX_CMD_ADDR = 0x0;
      	      break;

      	  case SET_SERVO_ANGLE:
      		  param.target_servo_angle = MAILBOX_DATA_FLOAT(0);
      	      MAILBOX_CMD_ADDR = 0x0;
      	      break;

      	  case SET_SERVO_PIN:
      		  val = MAILBOX_DATA(0);
      		  set_servo_pin(&servo, val);
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case GET_ULRANGER_DATA:
      		  val = get_ulranger_data(&ulranger);
      		  MAILBOX_DATA(0) = val;
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;

      	  case SET_MOTOR_MODE:
      		  val = MAILBOX_DATA(0);
      		  set_motor_ctrl_mode(&motor0,val);
      	      MAILBOX_CMD_ADDR = 0x0;
      	      break;

      	  default:
      		  MAILBOX_CMD_ADDR = 0x0;
      		  break;
      }
   }
   return 0;
}
