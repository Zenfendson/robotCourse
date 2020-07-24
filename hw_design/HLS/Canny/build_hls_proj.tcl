############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project Canny
set_top Canny_accel
add_files ./xf_canny_accel.cpp -cflags "-I ./include -D__XFCV_HLS_MODE__ -std=c++0x"
open_solution "solution1"
set_part {xc7z020clg400-1}
create_clock -period 5 -name default
#source "./Canny/solution1/directives.tcl"
csynth_design
export_design -rtl verilog -format ip_catalog
