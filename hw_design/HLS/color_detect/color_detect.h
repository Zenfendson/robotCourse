#include <hls_video.h>
#include "ap_axi_sdata.h"
#include "ap_int.h"

#define HEIGHT 720
#define WIDTH  1280

typedef hls::Mat<HEIGHT,WIDTH,HLS_8UC3> IMG_RGB;
typedef hls::Mat<HEIGHT,WIDTH,HLS_8UC3> IMG_HSV;
typedef hls::Mat<HEIGHT,WIDTH,HLS_8UC1> IMG_GRAY;
typedef hls::Scalar<3,unsigned char> PIXEL_RGB;
typedef hls::Scalar<1,unsigned char> PIXEL_GRAY;

struct THRES
{
	ap_uint<8>high;
	ap_uint<8>low;
};

struct RESULT
{
	unsigned int posX;
	unsigned int posY;
	unsigned int widthX;
	unsigned int widthY;
};


void color_detect(hls::stream<ap_axiu<24,1,1,1> > & strm_in ,THRES H_thres ,THRES S_thres, THRES V_thres,RESULT & res);
