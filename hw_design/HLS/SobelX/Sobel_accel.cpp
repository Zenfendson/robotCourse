#include "Sobel_accel.h"
#include "infra.h"

void SobelX_accel(hls::stream<ap_axiu<8,1,1,1> > &in_stream,
		hls::stream<ap_axiu<8,1,1,1> >&out_stream)
{
#pragma HLS DATAFLOW
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis register both port=out_stream
#pragma HLS INTERFACE axis register both port=in_stream

	hls::Mat<HEIGHT,WIDTH,HLS_8UC3> img_in(HEIGHT,WIDTH);
	hls::Mat<HEIGHT,WIDTH,HLS_8UC1> img_gray_in(HEIGHT,WIDTH);
	hls::Mat<HEIGHT,WIDTH,HLS_8UC1> img_gray_out(HEIGHT,WIDTH);
	hls::Mat<HEIGHT,WIDTH,HLS_8UC3> img_out(HEIGHT,WIDTH);

	plainStream2hlsMat_gray_port(in_stream,img_gray_in);

	hls::Sobel<1,0,3>(img_gray_in, img_gray_out);

	hlsMat2plainStream_gray_port( img_gray_out, out_stream);
}
