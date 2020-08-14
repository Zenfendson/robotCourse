#include "color_detect.h"
void strm2mat(hls::stream<ap_axiu<24,1,1,1> > & strm_in, IMG_RGB & mat_out)
{
	PIXEL_RGB pix;
	ap_axiu<24,1,1,1> val;
	for(int i = 0;i<HEIGHT;i++)
	{
		for(int j = 0;j<WIDTH;j++)
		{
#pragma HLS PIPELINE
			strm_in >> val;
			pix.val[0] = val.data(7,0);
			pix.val[1] = val.data(15,8);
			pix.val[2] = val.data(23,16);
			mat_out << pix;
		}
	}
}

void doublethres(IMG_HSV & mat_in, IMG_GRAY & mat_out,THRES & H_thres ,THRES & S_thres, THRES & V_thres )
{
	PIXEL_RGB pix_in;
	PIXEL_GRAY pix_white(255);
	PIXEL_GRAY pix_black(0);
	for(int i = 0;i<HEIGHT;i++)
	{
		for(int j = 0;j<WIDTH;j++)
		{
#pragma HLS PIPELINE
			mat_in >> pix_in;
			if
			(
				pix_in.val[0]>=H_thres.low && pix_in.val[0]<= H_thres.high &&
				pix_in.val[1]>=S_thres.low && pix_in.val[1]<= S_thres.high &&
				pix_in.val[2]>=V_thres.low && pix_in.val[2]<= V_thres.high
			)
				mat_out << pix_white;
			else
				mat_out << pix_black;
		}
	}
}
template<unsigned int rows,unsigned int cols>
void count(IMG_GRAY & mat_in,hls::stream<ap_uint<12> > & strm_out)
{
	ap_uint<12> col_count[WIDTH] =
	{	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
#pragma HLS RESOURCE variable=col_count core=RAM_1P
	ap_uint<12> row_count[HEIGHT] =
	{	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
#pragma HLS RESOURCE variable=row_count core=RAM_1P

	PIXEL_GRAY val_in;
	for(int i = 0;i<rows;i++)
	{
		for(int j = 0;j<cols;j++)
		{
#pragma HLS PIPELINE
			mat_in >> val_in;
			if(val_in.val[0]==255)
			{
				row_count[i] = row_count[i] + 1;
				col_count[j] = col_count[j] + 1;
			}
		}
	}

	for(unsigned int i = 0;i<cols;i++)
	{
		strm_out << col_count[i];
	}
	for(unsigned int i = 0;i<rows;i++)
	{
		strm_out << row_count[i];
	}
}

template<unsigned int rows,unsigned int cols,unsigned int thresholdX,unsigned int thresholdY >
void dataPreprocess(hls::stream<ap_uint<12> > & strm_in,hls::stream<unsigned int > & strm_out)
{
	const ap_uint<4> kernel[5] = {3,6,8,6,3};
	ap_uint<16> inter_data0[5];
#pragma HLS ARRAY_PARTITION variable=inter_data0 complete dim=1
	ap_uint<18> inter_data1[3];
#pragma HLS ARRAY_PARTITION variable=inter_data1 complete dim=1
	ap_uint<20> temp_data;
	ap_uint<12> shift_reg[5] = {0};
#pragma HLS ARRAY_PARTITION variable=shift_reg complete dim=1
	ap_uint<12> val_in;
	unsigned int val_out;

////////////////////////////////////col data//////////////////////////////////////
	for(int i = 0;i<cols;i++)
	{
#pragma HLS PIPELINE
		strm_in >> val_in;
		for(int k = 0;k<5;k++)
		{
#pragma HLS UNROLL
			if(k == 4)
				shift_reg[k] = val_in;
			else
				shift_reg[k] = shift_reg[k+1];
		}

		for(int k = 0;k<5;k++)
		{
#pragma HLS UNROLL
			inter_data0[k] = shift_reg[k] * kernel[k];
		}

		inter_data1[0] = inter_data0[0] + inter_data0[1];
		inter_data1[1] = inter_data0[2];
		inter_data1[2] = inter_data0[3] + inter_data0[4];
		temp_data = inter_data1[0] + inter_data1[1] + inter_data1[2];
		val_out = temp_data / 26;
		if(val_out > thresholdX)
			strm_out << val_out;
		else
			strm_out << 0;
	}
////////////////////////////////////row data//////////////////////////////////////
	for(int i = 0;i<5;i++)
	{
#pragma HLS UNROLL
		shift_reg[i] = 0;
	}
	for(int i = 0;i<rows;i++)
	{
#pragma HLS PIPELINE
		strm_in >> val_in;
		for(int k = 0;k<5;k++)
		{
#pragma HLS UNROLL
			if(k == 4)
				shift_reg[k] = val_in;
			else
				shift_reg[k] = shift_reg[k+1];
		}

		for(int k = 0;k<5;k++)
		{
#pragma HLS UNROLL
			inter_data0[k] = shift_reg[k] * kernel[k];
		}

		inter_data1[0] = inter_data0[0] + inter_data0[1];
		inter_data1[1] = inter_data0[2];
		inter_data1[2] = inter_data0[3] + inter_data0[4];
		temp_data = inter_data1[0] + inter_data1[1] + inter_data1[2];
		val_out = temp_data / 26;
		if(val_out > thresholdY)
			strm_out << val_out;
		else
			strm_out << 0;
	}
}

void findMaxRegion(hls::stream<ap_uint<12> > & strm_in,hls::stream<unsigned int > & strm_out)
{
	const unsigned int cols = WIDTH;
	const unsigned int rows = HEIGHT;
	unsigned int curPosLowX = 0;
	unsigned int curPosHighX = 0;
	unsigned int curValSumX = 0;
	unsigned int maxPosLowX = 0;
	unsigned int maxPosHighX = 0;
	unsigned int maxValSumX = 0;
	bool isInValidRegionX = false;
	bool meetLowBoarderX = false;
	bool meetHighBoarderX = false;
	ap_uint<12> val_curX = 0;
	ap_uint<12> val_preX = 0;

	unsigned int curPosLowY = 0;
	unsigned int curPosHighY = 0;
	unsigned int curValSumY = 0;
	unsigned int maxPosLowY = 0;
	unsigned int maxPosHighY = 0;
	unsigned int maxValSumY = 0;
	bool isInValidRegionY = false;
	bool meetLowBoarderY = false;
	bool meetHighBoarderY = false;
	ap_uint<12> val_curY = 0;
	ap_uint<12> val_preY = 0;

	for(int i = 0;i<cols+rows;i++)
	{
#pragma HLS PIPELINE
		if(i<cols)
		{
			strm_in >> val_curX;
			isInValidRegionX 	= val_curX != 0 ? 															true : false;
			meetLowBoarderX		= (val_curX != 0 && val_preX == 0) || (val_curX != 0 && i == 0) ? 			true : false;
			meetHighBoarderX 	= (val_curX == 0 && val_preX != 0) || (val_curX != 0 && i == cols-1) ? 		true : false;
			curPosLowX 			= meetLowBoarderX? 															i : curPosLowX;
			curPosHighX 		= meetHighBoarderX? 														i : curPosHighX;
			if(isInValidRegionX | meetHighBoarderX)
				curValSumX = curValSumX + val_curX;
			else
				curValSumX = 0;
			if(meetHighBoarderX && (curValSumX > maxValSumX) )
			{
				maxValSumX = curValSumX;
				maxPosLowX = curPosLowX;
				maxPosHighX = curPosHighX;
			}
			val_preX = val_curX;
		}
		else
		{
			strm_in >> val_curY;
			isInValidRegionY 		= val_curY != 0 ? 															true : false;
			meetLowBoarderY 		= (val_curY != 0 && val_preY == 0) || (val_curY != 0 && i == cols) ? 		true : false;
			meetHighBoarderY 		= (val_curY == 0 && val_preY != 0) || (val_curY != 0 && i == cols+rows-1) ? true : false;
			curPosLowY 				= meetLowBoarderY? 															(i-cols) : curPosLowY;
			curPosHighY 			= meetHighBoarderY? 														(i-cols) : curPosHighY;
			if(isInValidRegionY | meetHighBoarderY)
				curValSumY = curValSumY + val_curY;
			else
				curValSumY = 0;
			if(meetHighBoarderY && (curValSumY > maxValSumY) )
			{
				maxValSumY = curValSumY;
				maxPosLowY = curPosLowY;
				maxPosHighY = curPosHighY;
			}
			val_preY = val_curY;
		}
	}

	unsigned int widthX = maxPosHighX - maxPosLowX;
	unsigned int centerX = (maxPosHighX + maxPosLowX)>>1;
	unsigned int widthY = maxPosHighY - maxPosLowY;
	unsigned int centerY = (maxPosHighY + maxPosLowY)>>1;
	strm_out << widthX;
	strm_out << centerX;
	strm_out << widthY;
	strm_out << centerY;
}
void color_detect(hls::stream<ap_axiu<24,1,1,1> > & strm_in ,THRES H_thres ,THRES S_thres, THRES V_thres,RESULT & res)
{
#pragma HLS INTERFACE s_axilite port=res
#pragma HLS DATA_PACK variable=res field_level
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS DATAFLOW disable_start_propagation
#pragma HLS INTERFACE axis register both port=strm_in
#pragma HLS INTERFACE s_axilite port=V_thres
#pragma HLS INTERFACE s_axilite port=S_thres
#pragma HLS INTERFACE s_axilite port=H_thres
#pragma HLS DATA_PACK variable=V_thres field_level
#pragma HLS DATA_PACK variable=S_thres field_level
#pragma HLS DATA_PACK variable=H_thres field_level

	static IMG_RGB img_src(HEIGHT,WIDTH);
	static IMG_HSV img_hsv(HEIGHT,WIDTH);
	static IMG_GRAY img_doublethres(HEIGHT,WIDTH);
	static hls::stream<ap_uint<12> > count_strm;
	static hls::stream<unsigned int > count_strm_done;
	static hls::stream<unsigned int > res_strm;

	strm2mat(strm_in,img_src);

	hls::CvtColor<HLS_RGB2HSV>(img_src,img_hsv);

	doublethres(img_hsv,img_doublethres,H_thres,S_thres,V_thres);

	count<HEIGHT,WIDTH>(img_doublethres,count_strm);

	findMaxRegion(count_strm,res_strm);

	res_strm >> res.widthX;
	res_strm >> res.posX;
	res_strm >> res.widthY;
	res_strm >> res.posY;
}
