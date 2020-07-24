/***************************************************************************
Copyright (c) 2019, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

***************************************************************************/
#include "xf_canny_config.h"
void pre_process(hls::stream< ap_axiu<8,1,1,1> >& in_strm,hls::stream< ap_uint<8> >& out_strm)
{
	ap_axiu<8,1,1,1> in;
	ap_uint<8> out;
	for(int i = 0;i<HEIGHT;i++)
	{
		for(int j = 0;j<WIDTH;j++)
		{
#pragma HLS PIPELINE
			in_strm>>in;
			out = in.data;
			out_strm << out;
		}
	}
}
ap_uint<8> intense(ap_uint<2> input)
{
#pragma HLS INLINE
	ap_uint<8> res;
	if(input == 0)
		res = 0;
	else if(input == 1)
		res = 127;
	else
		res = 255;
	return res;
}
void post_process(hls::stream< ap_uint<2> >& in_strm,hls::stream< ap_axiu<8,1,1,1> >& out_strm)
{
	ap_uint<2> in;
	ap_axiu<8,1,1,1> out;
	for(int i = 0;i<HEIGHT;i++)
	{
		for(int j = 0;j<WIDTH;j++)
		{
#pragma HLS PIPELINE
			in_strm>>in;
			out.data = intense(in);
			out.keep = 1;
			out.last = (i==HEIGHT-1 && j == WIDTH-1);
			out_strm << out;
		}
	}
}
void Canny_accel(hls::stream< ap_axiu<8,1,1,1> >& in_strm,hls::stream< ap_axiu<8,1,1,1> >& out_strm,unsigned char low_threshold,unsigned char high_threshold)
{
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS INTERFACE s_axilite port=high_threshold
#pragma HLS INTERFACE s_axilite port=low_threshold
#pragma HLS INTERFACE axis register both port=out_strm
#pragma HLS INTERFACE axis register both port=in_strm
#pragma HLS DATAFLOW

	hls::stream<ap_uint<8> > strm_src;
	hls::stream<ap_uint<2> > strm_dst;

	pre_process(in_strm,strm_src);

	xf::xFCannyEdgeDetector<HEIGHT,WIDTH,XF_DEPTH(XF_8UC1,INTYPE),XF_DEPTH(XF_2UC1,INTYPE),INTYPE,XF_WORDWIDTH(XF_8UC1,INTYPE),XF_WORDWIDTH(XF_2UC1,INTYPE),FILTER_WIDTH,XF_USE_URAM>(strm_src,strm_dst,low_threshold,high_threshold,NORM_TYPE,720,1280);

	post_process(strm_dst,out_strm);

}


