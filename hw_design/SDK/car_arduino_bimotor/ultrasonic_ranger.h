#ifndef ULTRASONIC_RANGER_H
#define ULTRASONIC_RANGER_H
#include "xil_io.h"

typedef struct
{
	unsigned int baseaddr;
}Ultrasonic_ranger;

void makeURInstance(Ultrasonic_ranger *,unsigned int baseaddr);

void ultrasonic_ranger_init(Ultrasonic_ranger * );

unsigned int get_ulranger_data(Ultrasonic_ranger * );

#endif
