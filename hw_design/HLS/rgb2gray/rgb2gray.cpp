#include "hls_video.h"
#include "hls_stream.h"
#include "ap_axi_sdata.h"
#define WIDTH 1280
#define HEIGHT 720
void rgb2gray(hls::stream <ap_axiu<24,1,1,1> >& in_stream, hls::stream<ap_axiu<8,1,1,1> >&out_stream)
{
#pragma HLS DATAFLOW
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis register both port=out_stream
#pragma HLS INTERFACE axis register both port=in_stream

	hls::Mat<HEIGHT,WIDTH,HLS_8UC3> img_in(HEIGHT,WIDTH);
	hls::Mat<HEIGHT,WIDTH,HLS_8UC1> img_out(HEIGHT,WIDTH);

	hls::AXIvideo2Mat(in_stream, img_in);

	hls::CvtColor<HLS_RGB2GRAY, HLS_8UC3, HLS_8UC1>(img_in, img_out);

	hls::Mat2AXIvideo(img_out,out_stream);
}
