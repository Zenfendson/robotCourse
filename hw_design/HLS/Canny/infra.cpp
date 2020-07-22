#include "infra.h"

void plainStream2hlsMat_rgb_port(hls::stream<ap_axiu<24,1,1,1> >& strm_in, hls::Mat<HEIGHT,WIDTH,HLS_8UC3> & mat_out)
{
	short int rows = mat_out.rows;
	short int cols = mat_out.cols;
	ap_axiu<24,1,1,1> in_val;
	hls::Scalar<3,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			strm_in >> in_val;
			pix.val[0] = in_val.data(7,0);
			pix.val[1] = in_val.data(15,8);
			pix.val[2] = in_val.data(23,16);
			mat_out << pix;
		}
	}
}
void hlsMat2plainStream_rgb_port(hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &mat_in, hls::stream<ap_axiu<24,1,1,1> >&strm_out)
{
	short int rows = mat_in.rows;
	short int cols = mat_in.cols;
	ap_axiu<24,1,1,1> out_val;
	hls::Scalar<3,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			mat_in >> pix;
			out_val.data(7,0) = pix.val[0];
			out_val.data(15,8) = pix.val[1];
			out_val.data(23,16) = pix.val[2];
			out_val.last = (i == rows-1 && j == cols-1);
			out_val.keep = 0x7;
			strm_out << out_val;
		}
	}
}

void plainStream2hlsMat_rgb_inter(hls::stream<ap_uint<24> >& strm_in, hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &mat_out)
{
	short int rows = mat_out.rows;
	short int cols = mat_out.cols;
	ap_uint<24> in_val;
	hls::Scalar<3,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			strm_in >> in_val;
			pix.val[0] = in_val(7,0);
			pix.val[1] = in_val(15,8);
			pix.val[2] = in_val(23,16);
			mat_out << pix;
		}
	}
}
void hlsMat2plainStream_rgb_inter(hls::Mat<HEIGHT,WIDTH,HLS_8UC3> &mat_in, hls::stream<ap_uint<24> >&strm_out)
{
	short int rows = mat_in.rows;
	short int cols = mat_in.cols;
	ap_uint<24> out_val;
	hls::Scalar<3,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			mat_in >> pix;
			out_val(7,0) = pix.val[0];
			out_val(15,8) = pix.val[1];
			out_val(23,16) = pix.val[2];
			strm_out << out_val;
		}
	}
}

void plainStream2hlsMat_gray_port(hls::stream<ap_axiu<8,1,1,1> >& strm_in, hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &mat_out)
{
	short int rows = mat_out.rows;
	short int cols = mat_out.cols;
	ap_axiu<8,1,1,1> in_val;
	hls::Scalar<1,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			strm_in >> in_val;
			pix.val[0] = in_val.data(7,0);
			mat_out << pix;
		}
	}
}
void hlsMat2plainStream_gray_port(hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &mat_in, hls::stream<ap_axiu<8,1,1,1> >&strm_out)
{
	short int rows = mat_in.rows;
	short int cols = mat_in.cols;
	ap_axiu<8,1,1,1> out_val;
	hls::Scalar<1,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			mat_in >> pix;
			out_val.data(7,0) = pix.val[0];
			out_val.last = (i == rows-1 && j == cols-1);
			out_val.keep = 0x1;
			strm_out << out_val;
		}
	}
}


void plainStream2hlsMat_gray_inter(hls::stream<ap_uint<8> >& strm_in, hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &mat_out)
{
	short int rows = mat_out.rows;
	short int cols = mat_out.cols;
	ap_uint<8> in_val;
	hls::Scalar<1,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			strm_in >> in_val;
			pix.val[0] = in_val(7,0);
			mat_out << pix;
		}
	}
}
void hlsMat2plainStream_gray_inter(hls::Mat<HEIGHT,WIDTH,HLS_8UC1> &mat_in, hls::stream<ap_uint<8> >&strm_out)
{
	short int rows = mat_in.rows;
	short int cols = mat_in.cols;
	ap_uint<8> out_val;
	hls::Scalar<1,unsigned char> pix;
	for(int i = 0;i<rows;i++)
	{
		for(int j=0; j<cols;j++){
#pragma HLS loop_flatten off
#pragma HLS pipeline II=1
			mat_in >> pix;
			out_val(7,0) = pix.val[0];
			strm_out << out_val;
		}
	}
}
