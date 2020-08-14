#include "ultrasonic_ranger.h"
void makeURInstance(Ultrasonic_ranger *inst,unsigned int baseaddr)
{
	inst->baseaddr = baseaddr;
}

void ultrasonic_ranger_init(Ultrasonic_ranger * inst)
{

}

unsigned int get_ulranger_data(Ultrasonic_ranger * inst)
{
	return Xil_In32((inst->baseaddr)+(0));
}
