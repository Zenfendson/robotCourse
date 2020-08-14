#include "motor.h"
#define slv0 0
#define slv1 4
#define slv2 8
#define slv3 12
void makeMotorInstance(Motor * inst,unsigned int id)
{
	switch(id)
	{
		case 0:
		{
			inst->pwmGen_baseaddr = XPAR_CAR_IOP_ARDUINO_MOTOR_DRIVER_0_AXI_PWM_MOTOR_S_AXI_BASEADDR;
			inst->ctrlSel_baseaddr = XPAR_CAR_IOP_ARDUINO_MOTOR_DRIVER_0_AXI_MOTOR_CTRL_SEL_0_S_AXI_BASEADDR;
			inst->id = id;
			break;
		}
		case 1:
		{
			inst->pwmGen_baseaddr = XPAR_CAR_IOP_ARDUINO_MOTOR_DRIVER_1_AXI_PWM_MOTOR_S_AXI_BASEADDR;
			inst->ctrlSel_baseaddr = XPAR_CAR_IOP_ARDUINO_MOTOR_DRIVER_1_AXI_MOTOR_CTRL_SEL_0_S_AXI_BASEADDR;
			inst->id = id;
			break;
		}
	}
}
//pwm generator reg definition
//slv0: duty of the PWM
//slv1: freq_ratio, PWM freq = in_clk/freq_ratio;
//slv2: direction of Motor

//motor ctrl mode seletor reg definition
//slv0: mode
void motor_init( Motor * inst )
{
	Xil_Out32((inst->pwmGen_baseaddr) + (slv0), 0);
	Xil_Out32((inst->pwmGen_baseaddr) + (slv1), 100000);
	Xil_Out32((inst->pwmGen_baseaddr) + (slv2), 0);
}

void set_motor_pwm( Motor * inst,int duty)
{
	inst->dutyCycle = duty;
	Xil_Out32((inst->pwmGen_baseaddr) + (slv0), duty);
}

void set_motor_pins(Motor * inst,unsigned int pin1,unsigned pin2)
{
	inst->pin1 = pin1;
	inst->pin2 = pin2;
	switch(inst->id)
	{
		case 0:
		{
			set_pin(pin1,PWM1);
			set_pin(pin2,PWM2);
			break;
		}
		case 1:
		{
			set_pin(pin1,PWM3);
			set_pin(pin2,PWM4);
			break;
		}
	}
}

void set_motor_dir(Motor * inst,unsigned int dir)
{
	Xil_Out32((inst->pwmGen_baseaddr) + (slv2), dir);
}

void set_motor_ctrl_mode(Motor * inst,unsigned int mode)
{
	inst->ctrl_mode = mode;
	Xil_Out32((inst->ctrlSel_baseaddr) + (slv0), mode);
}
