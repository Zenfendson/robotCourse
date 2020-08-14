#include "encoder.h"
#define slv0 0
#define slv1 4
#define slv2 8
#define slv3 12
void makeEncoderInstance(Encoder * inst,unsigned int baseaddr)
{
	inst->baseaddr = baseaddr;
}
//slv0: data (read only)
//slv1: clock_per_ms
//slv2: sample interval in ms
//slv3: direction
void encoder_init(Encoder *inst)
{
	Xil_Out32((inst->baseaddr)+(slv1),100000);
	Xil_Out32((inst->baseaddr)+(slv2),10);
	Xil_Out32((inst->baseaddr)+(slv3),0);
}
void set_encoder_dir(Encoder *inst,unsigned int dir)
{
	Xil_Out32((inst->baseaddr)+(slv3),dir);
}

int get_encoder_data(Encoder *inst)
{
	return Xil_In32((inst->baseaddr)+(slv0));
}
