#include "hls_video.h"
#include <ap_fixed.h>
#include "ap_axi_sdata.h"

#define MAX_WIDTH  1280
#define MAX_HEIGHT 720
#define CHANNEL	   3

#define SIZE 3
#define T ap_int<8>

typedef unsigned char uchar;

typedef hls::stream<ap_axiu<24,1,1,1> >  AXI_STREAM;
typedef hls::Scalar<3, unsigned char>  RGB_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3> RGB_IMAGE;

#define GRAY_CHANNEL 1

typedef hls::stream<ap_axiu<8,1,1,1> >  AXI_STREAM_GRAY;
typedef hls::Scalar<1, unsigned char>                 GRAY_PIXEL;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC1>     GRAY_IMAGE;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_16SC1>    GRAY_IMAGE_16S;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_16UC1>    GRAY_IMAGE_16;

void gradient_decomposition(GRAY_IMAGE_16S& gx, GRAY_IMAGE_16S& gy, GRAY_IMAGE_16& gd);

void nonmax_suppression(GRAY_IMAGE_16& gd, GRAY_IMAGE_16& dst);

void hysteresis( GRAY_IMAGE_16& src, GRAY_IMAGE& dst, int threshold_low, int threshold_high );

void canny_edge(AXI_STREAM& in, AXI_STREAM& out, int rows, int cols, int low_threshold, int high_threshold);
