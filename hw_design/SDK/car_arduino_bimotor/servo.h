#ifndef SERVO_H
#define SERVO_H
#include "xil_io.h"
#include "xparameters.h"
#include "xio_switch.h"
typedef struct
{
	unsigned int baseaddr;
	unsigned int dutyCycle;
	unsigned int pin;
}Servo;

void makeServoInstance(Servo * inst,unsigned int baseaddr);

void servo_init( Servo * inst );

void set_servo_pwm( Servo * inst,unsigned int duty);

void set_servo_pin(Servo * inst,unsigned pin);

#endif
