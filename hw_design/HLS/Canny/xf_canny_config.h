

#ifndef _XF_CANNY_CONFIG_H__
#define _XF_CANNY_CONFIG_H__

#include "hls_stream.h"
#include "ap_int.h"
#include "common/xf_common.h"
#include "common/xf_utility.h"
#include "imgproc/xf_canny.hpp"
#include "imgproc/xf_edge_tracing.hpp"
#include "xf_config_params.h"
#include "common/xf_axi_sdata.h"

#define WIDTH 1280
#define HEIGHT 720

#if NO
#define INTYPE XF_NPPC1
#define OUTTYPE XF_NPPC32
#elif RO
#define INTYPE XF_NPPC8
#define OUTTYPE XF_NPPC32
#endif

#if L1NORM
#define NORM_TYPE XF_L1NORM
#elif L2NORM
#define NORM_TYPE XF_L2NORM
#endif

void Canny_accel(hls::stream<ap_axiu<8,1,1,1> >& in_strm,hls::stream< ap_axiu<8,1,1,1> >& out_strm,unsigned char low_threshold,unsigned char high_threshold);

#endif
