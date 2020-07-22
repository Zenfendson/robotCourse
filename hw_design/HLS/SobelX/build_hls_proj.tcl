############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project SobelX
set_top SobelX_accel
add_files ./infra.h
add_files ./infra.cpp
add_files ./Sobel_accel.h
add_files ./Sobel_accel.cpp
open_solution "solution1"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 5 -name default
config_export -format ip_catalog -rtl verilog
csynth_design
export_design -rtl verilog -format ip_catalog
