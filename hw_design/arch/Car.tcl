
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project Car Car -part xc7z020clg400-1
   set_property BOARD_PART tul.com.tw:pynq-z2:part0:1.0 [current_project]
}

set_property  ip_repo_paths ./ip [current_project]
update_ip_catalog

add_files -fileset constrs_1 -norecurse ./cv_ov5640.xdc
import_files -fileset constrs_1 ./cv_ov5640.xdc
add_files -fileset constrs_1 -norecurse ./pynq-z2_v1.0.xdc
import_files -fileset constrs_1 ./pynq-z2_v1.0.xdc

# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:user:AXI_Encoder:1.0\
xilinx.com:user:AXI_PWM:1.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:user:dff_en_reset_vector:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:hls:Canny_accel:1.0\
xilinx.com:hls:SobelX_accel:1.0\
xilinx.com:hls:SobelY_accel:1.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:v_demosaic:1.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:hls:rgb2gray:1.0\
xilinx.com:ip:v_vid_in_axi4s:4.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_timer:2.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: timer_subsystem
proc create_hier_cell_timer_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_timer_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_timer_0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_timer_1

  # Create pins
  create_bd_pin -dir I -type clk Clk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -from 1 -to 0 timer_intr_out

  # Create instance: timer_0, and set properties
  set timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_0 ]

  # Create instance: timer_1, and set properties
  set timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_1 ]

  # Create instance: timer_intr, and set properties
  set timer_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 timer_intr ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $timer_intr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_timer_0] [get_bd_intf_pins timer_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_timer_1] [get_bd_intf_pins timer_1/S_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins Clk] [get_bd_pins timer_0/s_axi_aclk] [get_bd_pins timer_1/s_axi_aclk]
  connect_bd_net -net Net1 [get_bd_pins s_axi_aresetn] [get_bd_pins timer_0/s_axi_aresetn] [get_bd_pins timer_1/s_axi_aresetn]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins timer_0/interrupt] [get_bd_pins timer_intr/In0]
  connect_bd_net -net timer_1_interrupt [get_bd_pins timer_1/interrupt] [get_bd_pins timer_intr/In1]
  connect_bd_net -net timer_intr_dout [get_bd_pins timer_intr_out] [get_bd_pins timer_intr/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk FCLK_CLK0
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB1] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins FCLK_CLK0] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ov5640_driver_wrapper
proc create_hier_cell_ov5640_driver_wrapper { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ov5640_driver_wrapper() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 vid_iic

  # Create pins
  create_bd_pin -dir I -type clk ACLK
  create_bd_pin -dir I -type rst ARESETN
  create_bd_pin -dir I -from 0 -to 0 -type rst S_AXI_CTRL_ARESETN
  create_bd_pin -dir O -type intr iic2intc_irpt
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -from 7 -to 0 vid_data
  create_bd_pin -dir I vid_hsync
  create_bd_pin -dir I -type clk vid_pclk
  create_bd_pin -dir O -from 0 -to 0 vid_pwd
  create_bd_pin -dir O -from 0 -to 0 vid_rst
  create_bd_pin -dir I vid_vsync

  # Create instance: a0_demosaic, and set properties
  set a0_demosaic [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.0 a0_demosaic ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_interconnect_0

  # Create instance: axi_sccb, and set properties
  set axi_sccb [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_sccb ]

  # Create instance: axi_vdma_cam, and set properties
  set axi_vdma_cam [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_cam ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_linebuffer_depth {1024} \
 ] $axi_vdma_cam

  # Create instance: axis_interconnect_back, and set properties
  set axis_interconnect_back [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_back ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_interconnect_back

  # Create instance: axis_interconnect_front, and set properties
  set axis_interconnect_front [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_front ]
  set_property -dict [ list \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_interconnect_front

  # Create instance: gbr2rgb, and set properties
  set gbr2rgb [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 gbr2rgb ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {3} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[15:8],tdata[7:0],tdata[23:16]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[2:0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
 ] $gbr2rgb

  # Create instance: gbr2rgba, and set properties
  set gbr2rgba [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 gbr2rgba ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {8'b11111111,tdata[15:8],tdata[7:0],tdata[23:16]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TSTRB_REMAP {1'b0} \
 ] $gbr2rgba

  # Create instance: logic0, and set properties
  set logic0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $logic0

  # Create instance: logic1, and set properties
  set logic1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic1 ]

  # Create instance: rgb2gray_0, and set properties
  set rgb2gray_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:rgb2gray:1.0 rgb2gray_0 ]

  # Create instance: subset_cvt, and set properties
  set subset_cvt [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 subset_cvt ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {1} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {24'b000000000000000000000000,tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {3'b000,tkeep[0:0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
 ] $subset_cvt

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {11} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
 ] $v_vid_in_axi4s_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_vdma_cam/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins vid_iic] [get_bd_intf_pins axi_sccb/IIC]
  connect_bd_intf_net -intf_net S00_AXIS_1 [get_bd_intf_pins a0_demosaic/m_axis_video] [get_bd_intf_pins axis_interconnect_front/S00_AXIS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_sccb/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins a0_demosaic/s_axi_CTRL] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_vdma_cam/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axis_interconnect_front/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axis_interconnect_back/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axis_interconnect_back_M00_AXIS [get_bd_intf_pins axi_vdma_cam/S_AXIS_S2MM] [get_bd_intf_pins axis_interconnect_back/M00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_front_M00_AXIS [get_bd_intf_pins axis_interconnect_front/M00_AXIS] [get_bd_intf_pins gbr2rgba/S_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_front_M01_AXIS [get_bd_intf_pins axis_interconnect_front/M01_AXIS] [get_bd_intf_pins gbr2rgb/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_interconnect_back/S00_AXIS] [get_bd_intf_pins gbr2rgba/M_AXIS]
  connect_bd_intf_net -intf_net gbr2rgb_M_AXIS [get_bd_intf_pins gbr2rgb/M_AXIS] [get_bd_intf_pins rgb2gray_0/in_stream]
  connect_bd_intf_net -intf_net gbr2rgba1_M_AXIS [get_bd_intf_pins axis_interconnect_back/S01_AXIS] [get_bd_intf_pins subset_cvt/M_AXIS]
  connect_bd_intf_net -intf_net rgb2gray_0_out_stream [get_bd_intf_pins rgb2gray_0/out_stream] [get_bd_intf_pins subset_cvt/S_AXIS]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins a0_demosaic/s_axis_video] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]

  # Create port connections
  connect_bd_net -net S_AXI_CTRL_ARESETN_1 [get_bd_pins S_AXI_CTRL_ARESETN] [get_bd_pins axis_interconnect_front/S_AXI_CTRL_ARESETN]
  connect_bd_net -net ap_clk_1 [get_bd_pins ACLK] [get_bd_pins a0_demosaic/ap_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_sccb/s_axi_aclk] [get_bd_pins axi_vdma_cam/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_cam/s_axi_lite_aclk] [get_bd_pins axi_vdma_cam/s_axis_s2mm_aclk] [get_bd_pins axis_interconnect_back/ACLK] [get_bd_pins axis_interconnect_back/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S01_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S_AXI_CTRL_ACLK] [get_bd_pins axis_interconnect_front/ACLK] [get_bd_pins axis_interconnect_front/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_front/M01_AXIS_ACLK] [get_bd_pins axis_interconnect_front/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_front/S_AXI_CTRL_ACLK] [get_bd_pins gbr2rgb/aclk] [get_bd_pins gbr2rgba/aclk] [get_bd_pins rgb2gray_0/ap_clk] [get_bd_pins subset_cvt/aclk] [get_bd_pins v_vid_in_axi4s_0/aclk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ARESETN] [get_bd_pins a0_demosaic/ap_rst_n] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_sccb/s_axi_aresetn] [get_bd_pins axi_vdma_cam/axi_resetn] [get_bd_pins axis_interconnect_back/ARESETN] [get_bd_pins axis_interconnect_back/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S01_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S_AXI_CTRL_ARESETN] [get_bd_pins axis_interconnect_front/ARESETN] [get_bd_pins axis_interconnect_front/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/M01_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/S00_AXIS_ARESETN] [get_bd_pins gbr2rgb/aresetn] [get_bd_pins gbr2rgba/aresetn] [get_bd_pins rgb2gray_0/ap_rst_n] [get_bd_pins subset_cvt/aresetn] [get_bd_pins v_vid_in_axi4s_0/aresetn]
  connect_bd_net -net axi_sccb_iic2intc_irpt [get_bd_pins iic2intc_irpt] [get_bd_pins axi_sccb/iic2intc_irpt]
  connect_bd_net -net axi_vdma_cam_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_vdma_cam/s2mm_introut]
  connect_bd_net -net axis_enable_1 [get_bd_pins vid_rst] [get_bd_pins logic1/dout] [get_bd_pins v_vid_in_axi4s_0/aclken] [get_bd_pins v_vid_in_axi4s_0/axis_enable]
  connect_bd_net -net vid_data_1 [get_bd_pins vid_data] [get_bd_pins v_vid_in_axi4s_0/vid_data]
  connect_bd_net -net vid_field_id_1 [get_bd_pins vid_pwd] [get_bd_pins axis_interconnect_back/S00_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_back/S01_ARB_REQ_SUPPRESS] [get_bd_pins logic0/dout] [get_bd_pins v_vid_in_axi4s_0/vid_field_id] [get_bd_pins v_vid_in_axi4s_0/vid_hblank] [get_bd_pins v_vid_in_axi4s_0/vid_hsync] [get_bd_pins v_vid_in_axi4s_0/vid_vblank]
  connect_bd_net -net vid_hsync_1 [get_bd_pins vid_hsync] [get_bd_pins v_vid_in_axi4s_0/vid_active_video]
  connect_bd_net -net vid_pclk_1 [get_bd_pins vid_pclk] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_clk]
  connect_bd_net -net vid_vsync_1 [get_bd_pins vid_vsync] [get_bd_pins v_vid_in_axi4s_0/vid_vsync]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: image_processing
proc create_hier_cell_image_processing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_image_processing() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: Canny_accel_0, and set properties
  set Canny_accel_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:Canny_accel:1.0 Canny_accel_0 ]

  # Create instance: SobelX_accel_0, and set properties
  set SobelX_accel_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:SobelX_accel:1.0 SobelX_accel_0 ]

  # Create instance: SobelY_accel_0, and set properties
  set SobelY_accel_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:SobelY_accel:1.0 SobelY_accel_0 ]

  # Create instance: axi_dma_proc, and set properties
  set axi_dma_proc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_proc ]
  set_property -dict [ list \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_mm2s_data_width {32} \
   CONFIG.c_mm2s_burst_size {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_proc

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $axi_interconnect_0

  # Create instance: axis_interconnect_back, and set properties
  set axis_interconnect_back [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_back ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {4} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_interconnect_back

  # Create instance: axis_interconnect_front, and set properties
  set axis_interconnect_front [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_front ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_interconnect_front

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {3} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {tdata[7:0],tdata[7:0],tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[2:0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_0

  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {1} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {8'b11111111,16'b0000000000000000,tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {4'b1111} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_1

  # Create instance: axis_subset_converter_2, and set properties
  set axis_subset_converter_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_2 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {1} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[0:0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_2

  # Create instance: axis_subset_converter_3, and set properties
  set axis_subset_converter_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_3 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {8'b11111111,tdata[23:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {4'b1111} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_3

  # Create instance: axis_subset_converter_4, and set properties
  set axis_subset_converter_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_4 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {1} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[0:0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_4

  # Create instance: axis_subset_converter_5, and set properties
  set axis_subset_converter_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_5 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {0} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {1} \
   CONFIG.S_TDEST_WIDTH {0} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {0} \
   CONFIG.TDATA_REMAP {8'b11111111,16'b0000000000000000,tdata[7:0]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {4'b1111} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {1'b0} \
 ] $axis_subset_converter_5

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $proc_sys_reset_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Canny_accel_0_out_stream [get_bd_intf_pins Canny_accel_0/out_stream] [get_bd_intf_pins axis_subset_converter_3/S_AXIS]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net S03_AXIS_1 [get_bd_intf_pins axis_interconnect_back/S03_AXIS] [get_bd_intf_pins axis_subset_converter_5/M_AXIS]
  connect_bd_intf_net -intf_net SobelX_accel_0_out_stream [get_bd_intf_pins SobelX_accel_0/out_stream] [get_bd_intf_pins axis_subset_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net SobelY_accel_0_out_stream [get_bd_intf_pins SobelY_accel_0/out_stream] [get_bd_intf_pins axis_subset_converter_5/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_proc/M_AXIS_MM2S] [get_bd_intf_pins axis_interconnect_front/S00_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_proc/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_proc/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_dma_proc/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axis_interconnect_front/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axis_interconnect_back/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins Canny_accel_0/s_axi_AXILiteS] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_pins axis_interconnect_back/S00_AXIS] [get_bd_intf_pins axis_interconnect_front/M00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_back_M00_AXIS [get_bd_intf_pins axi_dma_proc/S_AXIS_S2MM] [get_bd_intf_pins axis_interconnect_back/M00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_front_M01_AXIS [get_bd_intf_pins axis_interconnect_front/M01_AXIS] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_front_M02_AXIS [get_bd_intf_pins axis_interconnect_front/M02_AXIS] [get_bd_intf_pins axis_subset_converter_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_front_M03_AXIS [get_bd_intf_pins axis_interconnect_front/M03_AXIS] [get_bd_intf_pins axis_subset_converter_4/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins Canny_accel_0/in_stream] [get_bd_intf_pins axis_subset_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_interconnect_back/S02_AXIS] [get_bd_intf_pins axis_subset_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_2_M_AXIS [get_bd_intf_pins SobelX_accel_0/in_stream] [get_bd_intf_pins axis_subset_converter_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_3_M_AXIS [get_bd_intf_pins axis_interconnect_back/S01_AXIS] [get_bd_intf_pins axis_subset_converter_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_4_M_AXIS [get_bd_intf_pins SobelY_accel_0/in_stream] [get_bd_intf_pins axis_subset_converter_4/M_AXIS]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins Canny_accel_0/ap_clk] [get_bd_pins SobelX_accel_0/ap_clk] [get_bd_pins SobelY_accel_0/ap_clk] [get_bd_pins axi_dma_proc/m_axi_mm2s_aclk] [get_bd_pins axi_dma_proc/m_axi_s2mm_aclk] [get_bd_pins axi_dma_proc/s_axi_lite_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axis_interconnect_back/ACLK] [get_bd_pins axis_interconnect_back/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S01_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S02_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S03_AXIS_ACLK] [get_bd_pins axis_interconnect_back/S_AXI_CTRL_ACLK] [get_bd_pins axis_interconnect_front/ACLK] [get_bd_pins axis_interconnect_front/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_front/M01_AXIS_ACLK] [get_bd_pins axis_interconnect_front/M02_AXIS_ACLK] [get_bd_pins axis_interconnect_front/M03_AXIS_ACLK] [get_bd_pins axis_interconnect_front/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_front/S_AXI_CTRL_ACLK] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins axis_subset_converter_2/aclk] [get_bd_pins axis_subset_converter_3/aclk] [get_bd_pins axis_subset_converter_4/aclk] [get_bd_pins axis_subset_converter_5/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net aux_reset_in_1 [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset_0/aux_reset_in]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_dma_proc/mm2s_introut]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_proc/s2mm_introut]
  connect_bd_net -net logic_1_dout [get_bd_pins logic_1/dout] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_back/ARESETN] [get_bd_pins axis_interconnect_front/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Canny_accel_0/ap_rst_n] [get_bd_pins SobelX_accel_0/ap_rst_n] [get_bd_pins SobelY_accel_0/ap_rst_n] [get_bd_pins axi_dma_proc/axi_resetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axis_interconnect_back/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S01_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S02_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S03_AXIS_ARESETN] [get_bd_pins axis_interconnect_back/S_AXI_CTRL_ARESETN] [get_bd_pins axis_interconnect_front/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/M01_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/M02_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/M03_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_front/S_AXI_CTRL_ARESETN] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins axis_subset_converter_2/aresetn] [get_bd_pins axis_subset_converter_3/aresetn] [get_bd_pins axis_subset_converter_4/aresetn] [get_bd_pins axis_subset_converter_5/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axis_interconnect_back/S00_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_back/S01_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_back/S02_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_back/S03_ARB_REQ_SUPPRESS] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: car_iop_arduino
proc create_hier_cell_car_iop_arduino { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_car_iop_arduino() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IMU_IIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_BRAM

  # Create pins
  create_bd_pin -dir I A
  create_bd_pin -dir I B
  create_bd_pin -dir I -type clk Clk
  create_bd_pin -dir O Motor_DIR
  create_bd_pin -dir O Motor_PWM
  create_bd_pin -dir I -type rst SYS_Rst
  create_bd_pin -dir O Servo_PWM
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir I intr_ack
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 q
  create_bd_pin -dir I -type rst s_axi_bram_aresetn

  # Create instance: AXI_Encoder, and set properties
  set AXI_Encoder [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI_Encoder:1.0 AXI_Encoder ]

  # Create instance: AXI_PWM_Motor, and set properties
  set AXI_PWM_Motor [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI_PWM:1.0 AXI_PWM_Motor ]

  # Create instance: AXI_PWM_Servo, and set properties
  set AXI_PWM_Servo [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI_PWM:1.0 AXI_PWM_Servo ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
 ] $axi_interconnect_0

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_AXI {0} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_ICACHE {0} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.ECC_TYPE {Hamming} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: mb_intc, and set properties
  set mb_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 mb_intc ]

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $proc_sys_reset

  # Create instance: timer_subsystem
  create_hier_cell_timer_subsystem $hier_obj timer_subsystem

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins IMU_IIC] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_BRAM] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net DEBUG_1 [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins AXI_Encoder/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins AXI_PWM_Motor/S_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins AXI_PWM_Servo/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins timer_subsystem/S_AXI_timer_0]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins timer_subsystem/S_AXI_timer_1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins mb_intc/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins intr/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net mb_DLMB [get_bd_intf_pins mb/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net mb_ILMB [get_bd_intf_pins mb/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net mb_bram_ctrl_BRAM_PORTA [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA] [get_bd_intf_pins microblaze_0_local_memory/BRAM_PORTB]
  connect_bd_intf_net -intf_net mb_intc_interrupt [get_bd_intf_pins mb/INTERRUPT] [get_bd_intf_pins mb_intc/interrupt]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins mb/M_AXI_DP]

  # Create port connections
  connect_bd_net -net AXI_PWM_Motor_PWM [get_bd_pins Motor_PWM] [get_bd_pins AXI_PWM_Motor/PWM]
  connect_bd_net -net AXI_PWM_Motor_dir [get_bd_pins Motor_DIR] [get_bd_pins AXI_PWM_Motor/dir]
  connect_bd_net -net AXI_PWM_Servo_PWM [get_bd_pins Servo_PWM] [get_bd_pins AXI_PWM_Servo/PWM]
  connect_bd_net -net A_0_1 [get_bd_pins A] [get_bd_pins AXI_Encoder/A]
  connect_bd_net -net B_0_1 [get_bd_pins B] [get_bd_pins AXI_Encoder/B]
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins microblaze_0_local_memory/SYS_Rst]
  connect_bd_net -net aux_reset_in_1 [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset/aux_reset_in]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins q] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net logic_1_dout [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins proc_sys_reset/ext_reset_in]
  connect_bd_net -net mb_debug_sys_rst_0_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins proc_sys_reset/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Clk] [get_bd_pins AXI_Encoder/s_axi_aclk] [get_bd_pins AXI_PWM_Motor/s_axi_aclk] [get_bd_pins AXI_PWM_Servo/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins mb_intc/s_axi_aclk] [get_bd_pins microblaze_0_local_memory/FCLK_CLK0] [get_bd_pins proc_sys_reset/slowest_sync_clk] [get_bd_pins timer_subsystem/Clk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins AXI_Encoder/s_axi_aresetn] [get_bd_pins AXI_PWM_Motor/s_axi_aresetn] [get_bd_pins AXI_PWM_Servo/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins mb_intc/s_axi_aresetn] [get_bd_pins proc_sys_reset/peripheral_aresetn] [get_bd_pins timer_subsystem/s_axi_aresetn]
  connect_bd_net -net proc_sys_reset_mb_reset [get_bd_pins mb/Reset] [get_bd_pins proc_sys_reset/mb_reset]
  connect_bd_net -net reset_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net s_axi_aresetn_0_1 [get_bd_pins s_axi_bram_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]
  connect_bd_net -net timer_subsystem_timer_intr_out [get_bd_pins timer_subsystem/timer_intr_out] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins mb_intc/intr] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IMU_IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IMU_IIC ]
  set vid_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 vid_iic ]

  # Create ports
  set A [ create_bd_port -dir I A ]
  set B [ create_bd_port -dir I B ]
  set Motor_DIR [ create_bd_port -dir O Motor_DIR ]
  set Motor_PWM [ create_bd_port -dir O Motor_PWM ]
  set Servo_PWM [ create_bd_port -dir O Servo_PWM ]
  set vid_data [ create_bd_port -dir I -from 7 -to 0 vid_data ]
  set vid_hsync [ create_bd_port -dir I vid_hsync ]
  set vid_pclk [ create_bd_port -dir I -type clk vid_pclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {74250000} \
 ] $vid_pclk
  set vid_pwd [ create_bd_port -dir O -from 0 -to 0 vid_pwd ]
  set vid_rst [ create_bd_port -dir O -from 0 -to 0 vid_rst ]
  set vid_vsync [ create_bd_port -dir I vid_vsync ]
  set vid_xclk [ create_bd_port -dir O -type clk vid_xclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {23809525} \
 ] $vid_xclk

  # Create instance: axi_intc, and set properties
  set axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $axi_interconnect_0

  # Create instance: car_iop_arduino
  create_hier_cell_car_iop_arduino [current_bd_instance .] car_iop_arduino

  # Create instance: image_process_reset, and set properties
  set image_process_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 image_process_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $image_process_reset

  # Create instance: image_processing
  create_hier_cell_image_processing [current_bd_instance .] image_processing

  # Create instance: interrupt, and set properties
  set interrupt [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 interrupt ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $interrupt

  # Create instance: mb_car_iop_arduino_intr_ack, and set properties
  set mb_car_iop_arduino_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_car_iop_arduino_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_car_iop_arduino_intr_ack

  # Create instance: mb_car_iop_arduino_reset, and set properties
  set mb_car_iop_arduino_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_car_iop_arduino_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $mb_car_iop_arduino_reset

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_MB_DBG_PORTS {1} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
 ] $mdm_0

  # Create instance: ov5640_driver_wrapper
  create_hier_cell_ov5640_driver_wrapper [current_bd_instance .] ov5640_driver_wrapper

  # Create instance: proc_sys_reset_100m, and set properties
  set proc_sys_reset_100m [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100m ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {650.000000} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.096154} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {23.809525} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {26} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {23809525} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1300.000} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {52} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {21} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1050.000} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 9} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {0} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {42} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {24} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {3} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {3} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {20} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {out} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {out} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#GPIO#GPIO#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#SD 0#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#gpio[12]#gpio[13]#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#cd#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.279} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.260} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.051} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_PACKAGE_NAME {clg400} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {525.000000} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.279} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.260} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {27.95} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {27.95} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {32.14} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {105.056} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {31.12} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {66.904} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {89.1715} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.63} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.051} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.006} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {32.2} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {98.503} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {31.08} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {68.5855} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {90.295} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {103.977} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 46} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
 ] $processing_system7_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {3} \
 ] $smartconnect_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins car_iop_arduino/S_AXI_BRAM]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins ov5640_driver_wrapper/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_intc/s_axi] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins image_processing/S00_AXI]
  connect_bd_intf_net -intf_net car_iop_arduino_IIC_0 [get_bd_intf_ports IMU_IIC] [get_bd_intf_pins car_iop_arduino/IMU_IIC]
  connect_bd_intf_net -intf_net image_processing_M_AXI_MM2S [get_bd_intf_pins image_processing/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net image_processing_M_AXI_S2MM [get_bd_intf_pins image_processing/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins car_iop_arduino/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_0]
  connect_bd_intf_net -intf_net ov5640_driver_wrapper_M_AXI_S2MM [get_bd_intf_pins ov5640_driver_wrapper/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net ov5640_driver_wrapper_vid_iic [get_bd_intf_ports vid_iic] [get_bd_intf_pins ov5640_driver_wrapper/vid_iic]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net A_0_1 [get_bd_ports A] [get_bd_pins car_iop_arduino/A]
  connect_bd_net -net B_0_1 [get_bd_ports B] [get_bd_pins car_iop_arduino/B]
  connect_bd_net -net Net [get_bd_pins image_process_reset/Din] [get_bd_pins mb_car_iop_arduino_intr_ack/Din] [get_bd_pins mb_car_iop_arduino_reset/Din] [get_bd_pins processing_system7_0/GPIO_O]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc/irq] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net car_iop_arduino_Motor_DIR [get_bd_ports Motor_DIR] [get_bd_pins car_iop_arduino/Motor_DIR]
  connect_bd_net -net car_iop_arduino_Motor_PWM [get_bd_ports Motor_PWM] [get_bd_pins car_iop_arduino/Motor_PWM]
  connect_bd_net -net car_iop_arduino_Servo_PWM [get_bd_ports Servo_PWM] [get_bd_pins car_iop_arduino/Servo_PWM]
  connect_bd_net -net car_iop_arduino_peripheral_aresetn [get_bd_pins car_iop_arduino/peripheral_aresetn] [get_bd_pins ov5640_driver_wrapper/S_AXI_CTRL_ARESETN]
  connect_bd_net -net car_iop_arduino_q [get_bd_pins car_iop_arduino/q] [get_bd_pins interrupt/In4]
  connect_bd_net -net image_process_reset_Dout [get_bd_pins image_process_reset/Dout] [get_bd_pins image_processing/aux_reset_in]
  connect_bd_net -net image_processing_mm2s_introut [get_bd_pins image_processing/mm2s_introut] [get_bd_pins interrupt/In0]
  connect_bd_net -net image_processing_s2mm_introut [get_bd_pins image_processing/s2mm_introut] [get_bd_pins interrupt/In1]
  connect_bd_net -net logic0_dout [get_bd_ports vid_pwd] [get_bd_pins ov5640_driver_wrapper/vid_pwd]
  connect_bd_net -net logic1_dout [get_bd_ports vid_rst] [get_bd_pins ov5640_driver_wrapper/vid_rst]
  connect_bd_net -net mb_car_iop_arduino_intr_ack_Dout [get_bd_pins car_iop_arduino/intr_ack] [get_bd_pins mb_car_iop_arduino_intr_ack/Dout]
  connect_bd_net -net mb_car_iop_arduino_rst_Dout [get_bd_pins car_iop_arduino/aux_reset_in] [get_bd_pins mb_car_iop_arduino_reset/Dout]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins car_iop_arduino/mb_debug_sys_rst] [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_100m/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins axi_intc/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins car_iop_arduino/Clk] [get_bd_pins image_processing/ap_clk] [get_bd_pins ov5640_driver_wrapper/ACLK] [get_bd_pins proc_sys_reset_100m/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net ov5640_driver_wrapper_iic2intc_irpt [get_bd_pins interrupt/In2] [get_bd_pins ov5640_driver_wrapper/iic2intc_irpt]
  connect_bd_net -net ov5640_driver_wrapper_s2mm_introut [get_bd_pins interrupt/In3] [get_bd_pins ov5640_driver_wrapper/s2mm_introut]
  connect_bd_net -net proc_sys_reset_100m_bus_struct_reset [get_bd_pins car_iop_arduino/SYS_Rst] [get_bd_pins proc_sys_reset_100m/bus_struct_reset]
  connect_bd_net -net proc_sys_reset_100m_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset_100m/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_100m_peripheral_aresetn [get_bd_pins axi_intc/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins car_iop_arduino/s_axi_bram_aresetn] [get_bd_pins ov5640_driver_wrapper/ARESETN] [get_bd_pins proc_sys_reset_100m/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_ports vid_xclk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_100m/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net vid_data_1 [get_bd_ports vid_data] [get_bd_pins ov5640_driver_wrapper/vid_data]
  connect_bd_net -net vid_hsync_1 [get_bd_ports vid_hsync] [get_bd_pins ov5640_driver_wrapper/vid_hsync]
  connect_bd_net -net vid_pclk_1 [get_bd_ports vid_pclk] [get_bd_pins ov5640_driver_wrapper/vid_pclk]
  connect_bd_net -net vid_vsync_1 [get_bd_ports vid_vsync] [get_bd_pins ov5640_driver_wrapper/vid_vsync]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_intc/intr] [get_bd_pins interrupt/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs car_iop_arduino/mb_bram_ctrl/S_AXI/Mem0] SEG1
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs image_processing/Canny_accel_0/s_axi_AXILiteS/Reg] SEG_Canny_accel_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs image_processing/axi_dma_proc/S_AXI_LITE/Reg] SEG_axi_dma_proc_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41800000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_intc/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ov5640_driver_wrapper/axi_sccb/S_AXI/Reg] SEG_axi_sccb_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ov5640_driver_wrapper/axi_vdma_cam/S_AXI_LITE/Reg] SEG_axi_vdma_ov5640_in_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ov5640_driver_wrapper/a0_demosaic/s_axi_CTRL/Reg] SEG_demosaic_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs image_processing/axis_interconnect_front/xbar/S_AXI_CTRL/Reg] SEG_xbar_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ov5640_driver_wrapper/axis_interconnect_back/xbar/S_AXI_CTRL/Reg] SEG_xbar_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs image_processing/axis_interconnect_back/xbar/S_AXI_CTRL/Reg] SEG_xbar_Reg3
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ov5640_driver_wrapper/axis_interconnect_front/xbar/S_AXI_CTRL/Reg] SEG_xbar_Reg4
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/AXI_Encoder/S_AXI/S_AXI_reg] SEG_AXI_Encoder_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/AXI_PWM_Motor/S_AXI/S_AXI_reg] SEG_AXI_PWM_Motor_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/AXI_PWM_Servo/S_AXI/S_AXI_reg] SEG_AXI_PWM_Servo_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces car_iop_arduino/mb/Instruction] [get_bd_addr_segs car_iop_arduino/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB1/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/intr/S_AXI/Reg] SEG_intr_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/mb_intc/S_AXI/Reg] SEG_mb_intc_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/timer_subsystem/timer_0/S_AXI/Reg] SEG_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C10000 [get_bd_addr_spaces car_iop_arduino/mb/Data] [get_bd_addr_segs car_iop_arduino/timer_subsystem/timer_1/S_AXI/Reg] SEG_timer_1_Reg
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces image_processing/axi_dma_proc/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces image_processing/axi_dma_proc/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces ov5640_driver_wrapper/axi_vdma_cam/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."
