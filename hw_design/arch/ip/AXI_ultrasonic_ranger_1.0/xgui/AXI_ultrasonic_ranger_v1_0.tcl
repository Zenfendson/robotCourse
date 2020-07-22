# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "PULSES_PER_US"
  ipgui::add_param $IPINST -name "SAMP_FRQZ"
  ipgui::add_param $IPINST -name "PULSE_WIDTH_US"
  ipgui::add_param $IPINST -name "TIMEOUT"

}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSES_PER_US { PARAM_VALUE.PULSES_PER_US } {
	# Procedure called to update PULSES_PER_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PULSES_PER_US { PARAM_VALUE.PULSES_PER_US } {
	# Procedure called to validate PULSES_PER_US
	return true
}

proc update_PARAM_VALUE.PULSE_WIDTH_US { PARAM_VALUE.PULSE_WIDTH_US } {
	# Procedure called to update PULSE_WIDTH_US when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PULSE_WIDTH_US { PARAM_VALUE.PULSE_WIDTH_US } {
	# Procedure called to validate PULSE_WIDTH_US
	return true
}

proc update_PARAM_VALUE.SAMP_FRQZ { PARAM_VALUE.SAMP_FRQZ } {
	# Procedure called to update SAMP_FRQZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SAMP_FRQZ { PARAM_VALUE.SAMP_FRQZ } {
	# Procedure called to validate SAMP_FRQZ
	return true
}

proc update_PARAM_VALUE.TIMEOUT { PARAM_VALUE.TIMEOUT } {
	# Procedure called to update TIMEOUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIMEOUT { PARAM_VALUE.TIMEOUT } {
	# Procedure called to validate TIMEOUT
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSES_PER_US { MODELPARAM_VALUE.PULSES_PER_US PARAM_VALUE.PULSES_PER_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSES_PER_US}] ${MODELPARAM_VALUE.PULSES_PER_US}
}

proc update_MODELPARAM_VALUE.SAMP_FRQZ { MODELPARAM_VALUE.SAMP_FRQZ PARAM_VALUE.SAMP_FRQZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SAMP_FRQZ}] ${MODELPARAM_VALUE.SAMP_FRQZ}
}

proc update_MODELPARAM_VALUE.PULSE_WIDTH_US { MODELPARAM_VALUE.PULSE_WIDTH_US PARAM_VALUE.PULSE_WIDTH_US } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_WIDTH_US}] ${MODELPARAM_VALUE.PULSE_WIDTH_US}
}

proc update_MODELPARAM_VALUE.TIMEOUT { MODELPARAM_VALUE.TIMEOUT PARAM_VALUE.TIMEOUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIMEOUT}] ${MODELPARAM_VALUE.TIMEOUT}
}

