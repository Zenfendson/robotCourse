#include "Canny_accel.h"
#include "canny_edge.h"
#include "infra.h"

void Canny_accel(hls::stream<ap_axiu<24,1,1,1> > &in_stream,
		hls::stream<ap_axiu<24,1,1,1> >&out_stream,
		unsigned int low_threshold,
		unsigned int high_threshold)
{
#pragma HLS DATAFLOW
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE s_axilite port=low_threshold
#pragma HLS INTERFACE s_axilite port=high_threshold
#pragma HLS INTERFACE axis register both port=out_stream
#pragma HLS INTERFACE axis register both port=in_stream

	RGB_IMAGE img_in(HEIGHT,WIDTH);
	GRAY_IMAGE img_gray_in(HEIGHT,WIDTH);
	GRAY_IMAGE img_gray_src0(HEIGHT,WIDTH);
	GRAY_IMAGE img_gray_src1(HEIGHT,WIDTH);
	GRAY_IMAGE_16S img_sobel0(HEIGHT,WIDTH);
	GRAY_IMAGE_16S img_sobel1(HEIGHT,WIDTH);
	GRAY_IMAGE_16 img_grad(HEIGHT,WIDTH);
	GRAY_IMAGE_16 img_nms(HEIGHT,WIDTH);
	GRAY_IMAGE img_canny(HEIGHT,WIDTH);

	RGB_IMAGE img_out(HEIGHT,WIDTH);


	plainStream2hlsMat_rgb_port(in_stream,img_in);

	hls::CvtColor<HLS_RGB2GRAY, HLS_8UC3, HLS_8UC1>(img_in, img_gray_in);

	hls::Duplicate( img_gray_in, img_gray_src0, img_gray_src1 );
	// Calculate gradients in x and y direction using Sobel filter
	hls::Sobel<1,0,3>( img_gray_src0, img_sobel0 );
	hls::Sobel<0,1,3>( img_gray_src1, img_sobel1 );

	// Calculate gradient magnitude and direction
	gradient_decomposition( img_sobel0, img_sobel1, img_grad );
	// Perform non-maximum suppression for edge thinning
	nonmax_suppression( img_grad, img_nms );
	// Perform hysteresis thresholding for edge tracing

	hysteresis( img_nms, img_canny, low_threshold, high_threshold);

	hls::CvtColor<HLS_GRAY2RGB, HLS_8UC1, HLS_8UC3>(img_canny, img_out);

	hlsMat2plainStream_rgb_port( img_out, out_stream);


}
