## 10x2 Connect Board

###PmodA

#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { vid_iic_sda_io }]; #IO_L17P_T2_34 Sch=ja_p[1]
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { vid_rst }]; #IO_L17N_T2_34 Sch=ja_n[1]
#set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { vid_hsync }]; #IO_L7P_T1_34 Sch=ja_p[2]
#set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { vid_xclk }]; #IO_L7N_T1_34 Sch=ja_n[2]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { vid_iic_scl_io }]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3]
#set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { vid_vsync }]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3]
#set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { vid_pwd }]; #IO_L22P_T3_34 Sch=ja_p[4]
#set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { vid_data[7] }]; #IO_L22N_T3_34 Sch=ja_n[4]

###PmodB

#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { vid_data[5] }]; #IO_L8P_T1_34 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { vid_data[4] }]; #IO_L8N_T1_34 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { vid_data[3] }]; #IO_L1P_T0_34 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { vid_data[2] }]; #IO_L1N_T0_34 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { vid_data[6] }]; #IO_L18P_T2_34 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { vid_pclk }]; #IO_L18N_T2_34 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { vid_data[0] }]; #IO_L4P_T0_34 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { vid_data[1] }]; #IO_L4N_T0_34 Sch=jb_n[4]

## 9x2 Connect Board

##PmodA

set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { vid_rst }]; #IO_L17P_T2_34 Sch=ja_p[1] D2
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { vid_data[1] }]; #IO_L17N_T2_34 Sch=ja_n[1] C2
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { vid_data[3] }]; #IO_L7P_T1_34 Sch=ja_p[2] B2
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { vid_data[5] }]; #IO_L7N_T1_34 Sch=ja_n[2] A2
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { vid_pwd }]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3] H2
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { vid_data[0] }]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3] G2
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { vid_data[2] }]; #IO_L22P_T3_34 Sch=ja_p[4] F2
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { vid_data[4] }]; #IO_L22N_T3_34 Sch=ja_n[4] E2

##PmodB

set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { vid_data[7] }]; ##IO_L8P_T1_34 Sch=jb_p[1] D1
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { vid_pclk }]; #IO_L8N_T1_34 Sch=jb_n[1] C1
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { vid_vsync }]; #IO_L1P_T0_34 Sch=jb_p[2] B1
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { vid_iic_scl_io }]; #IO_L1N_T0_34 Sch=jb_n[2] A1
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { vid_data[6] }]; #IO_L18P_T2_34 Sch=jb_p[3] H1
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { vid_xclk }]; #IO_L18N_T2_34 Sch=jb_n[3] G1
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { vid_hsync }]; #IO_L4P_T0_34 Sch=jb_p[4] F1
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { vid_iic_sda_io }]; #IO_L4N_T0_34 Sch=jb_n[4] E1

set_property PULLUP true [get_ports vid_iic_scl_io]
set_property PULLUP true [get_ports vid_iic_sda_io]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets vid_pclk_IBUF]