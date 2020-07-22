############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project rgb2gray
set_top rgb2gray
add_files ./rgb2gray.cpp
open_solution "solution1"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 5 -name default
csynth_design
export_design -rtl verilog -format ip_catalog
