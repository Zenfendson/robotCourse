# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "A0_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "A1_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "B0_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "B1_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HIGH_THRESHOLD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LOW_THRESHOLD" -parent ${Page_0}


}

proc update_PARAM_VALUE.A0_ID { PARAM_VALUE.A0_ID } {
	# Procedure called to update A0_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.A0_ID { PARAM_VALUE.A0_ID } {
	# Procedure called to validate A0_ID
	return true
}

proc update_PARAM_VALUE.A1_ID { PARAM_VALUE.A1_ID } {
	# Procedure called to update A1_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.A1_ID { PARAM_VALUE.A1_ID } {
	# Procedure called to validate A1_ID
	return true
}

proc update_PARAM_VALUE.B0_ID { PARAM_VALUE.B0_ID } {
	# Procedure called to update B0_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.B0_ID { PARAM_VALUE.B0_ID } {
	# Procedure called to validate B0_ID
	return true
}

proc update_PARAM_VALUE.B1_ID { PARAM_VALUE.B1_ID } {
	# Procedure called to update B1_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.B1_ID { PARAM_VALUE.B1_ID } {
	# Procedure called to validate B1_ID
	return true
}

proc update_PARAM_VALUE.HIGH_THRESHOLD { PARAM_VALUE.HIGH_THRESHOLD } {
	# Procedure called to update HIGH_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HIGH_THRESHOLD { PARAM_VALUE.HIGH_THRESHOLD } {
	# Procedure called to validate HIGH_THRESHOLD
	return true
}

proc update_PARAM_VALUE.LOW_THRESHOLD { PARAM_VALUE.LOW_THRESHOLD } {
	# Procedure called to update LOW_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOW_THRESHOLD { PARAM_VALUE.LOW_THRESHOLD } {
	# Procedure called to validate LOW_THRESHOLD
	return true
}


proc update_MODELPARAM_VALUE.HIGH_THRESHOLD { MODELPARAM_VALUE.HIGH_THRESHOLD PARAM_VALUE.HIGH_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HIGH_THRESHOLD}] ${MODELPARAM_VALUE.HIGH_THRESHOLD}
}

proc update_MODELPARAM_VALUE.LOW_THRESHOLD { MODELPARAM_VALUE.LOW_THRESHOLD PARAM_VALUE.LOW_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOW_THRESHOLD}] ${MODELPARAM_VALUE.LOW_THRESHOLD}
}

proc update_MODELPARAM_VALUE.A0_ID { MODELPARAM_VALUE.A0_ID PARAM_VALUE.A0_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.A0_ID}] ${MODELPARAM_VALUE.A0_ID}
}

proc update_MODELPARAM_VALUE.A1_ID { MODELPARAM_VALUE.A1_ID PARAM_VALUE.A1_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.A1_ID}] ${MODELPARAM_VALUE.A1_ID}
}

proc update_MODELPARAM_VALUE.B0_ID { MODELPARAM_VALUE.B0_ID PARAM_VALUE.B0_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.B0_ID}] ${MODELPARAM_VALUE.B0_ID}
}

proc update_MODELPARAM_VALUE.B1_ID { MODELPARAM_VALUE.B1_ID PARAM_VALUE.B1_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.B1_ID}] ${MODELPARAM_VALUE.B1_ID}
}

