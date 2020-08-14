#include "servo.h"

void makeServoInstance(Servo * inst,unsigned int baseaddr)
{
	inst->baseaddr = baseaddr;
	inst->dutyCycle = 300;
}
//slv0 duty cycle
//slv1: freq_ratio, PWM freq = in_clk/freq_ratio;
void servo_init( Servo * inst )
{
	Xil_Out32((inst->baseaddr) + (0), 300);
	Xil_Out32((inst->baseaddr) + (4), 500000);
}
// PWM freqency is 200 Hz, which means when duty cycle is 30% (aka duty = 300), the width of pulse is 1500us.
void set_servo_pwm( Servo * inst,unsigned int duty)
{
	Xil_Out32((inst->baseaddr) + (0), duty);
}

void set_servo_pin(Servo * inst,unsigned pin)
{
	inst->pin = pin;
	set_pin(pin,PWM0);
}
