#ifndef INFRA_H
#define INFRA_H

#include "hls_video.h"
#include "ap_int.h"
#include "ap_axi_sdata.h"

#ifndef WIDTH
#define WIDTH 	1280
#endif

#ifndef HEIGHT
#define HEIGHT	720
#endif

typedef hls::Scalar<3,unsigned char> RGB_PIXEL;
typedef hls::Scalar<1,unsigned char> GRAY_PIXEL;

void plainStream2hlsMat_rgb_port(hls::stream<ap_axiu<24,1,1,1> >& , hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &);
void hlsMat2plainStream_rgb_port(hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &, hls::stream<ap_axiu<24,1,1,1> >&);

void plainStream2hlsMat_rgb_inter(hls::stream<ap_uint<24> >& , hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &);
void hlsMat2plainStream_rgb_inter(hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &, hls::stream<ap_uint<24> >&);

void plainStream2hlsMat_gray_port(hls::stream<ap_axiu<8,1,1,1> >& , hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &);
void hlsMat2plainStream_gray_port(hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &, hls::stream<ap_axiu<8,1,1,1> >&);

void plainStream2hlsMat_gray_inter(hls::stream<ap_uint<8> >& , hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &);
void hlsMat2plainStream_gray_inter(hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &, hls::stream<ap_uint<8> >&);

#endif
