#ifndef CANNY_ACCEL_H
#define CANNY_ACCEL_H
#include "hls_stream.h"
#include "hls_video.h"
#include "ap_axi_sdata.h"
#include "ap_fixed.h"
#include "ap_int.h"

#ifndef WIDTH
#define WIDTH 	1280
#endif

#ifndef HEIGHT
#define HEIGHT	720
#endif

void Canny_accel(hls::stream<ap_axiu<24,1,1,1> > &in_stream,hls::stream<ap_axiu<24,1,1,1> >&out_stream,unsigned int height,unsigned int width,unsigned int low_threshold,unsigned int high_threshold);
#endif
