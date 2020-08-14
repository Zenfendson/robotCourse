#ifndef MOTOR_H
#define MOTOR_H
#include "xil_io.h"
#include "xparameters.h"
#include "xio_switch.h"
#include "xil_io.h"

#define SIMPLE 0
#define FULL_BRIDGE 1

typedef struct
{
	unsigned int id;
	unsigned int pwmGen_baseaddr;
	unsigned int ctrlSel_baseaddr;
	unsigned int dutyCycle;
	unsigned int pin1;
	unsigned int pin2;
	unsigned int ctrl_mode;
} Motor;

void makeMotorInstance( Motor * inst,unsigned int id);

void motor_init( Motor * inst );

void set_motor_pwm( Motor * inst,int duty);

void set_motor_pins(Motor * inst,unsigned int pin1,unsigned pin2);

void set_motor_dir(Motor * inst,unsigned int dir);

void set_motor_ctrl_mode(Motor * inst,unsigned int mode);

#endif
