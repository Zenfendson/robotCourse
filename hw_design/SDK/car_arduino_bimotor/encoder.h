#ifndef ENCODER_H
#define ENCODER_H
#include "xil_io.h"

typedef struct
{
	unsigned int baseaddr;
}Encoder;

void makeEncoderInstance(Encoder *,unsigned int baseaddr);

void encoder_init(Encoder *);

int get_encoder_data(Encoder *);

void set_encoder_dir(Encoder *inst,unsigned int dir);

#endif
