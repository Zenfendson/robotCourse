set overlay_name "Car"
set design_name "design_1"

# open block design
open_project ./${overlay_name}/${overlay_name}.xpr
open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd

# Add top wrapper 
make_wrapper -files [get_files ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd] -top
add_files -norecurse ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.v
set_property top ${design_name}_wrapper [current_fileset]
# import_files -fileset constrs_1 -
update_compile_order -fileset sources_1

# call implement
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

# add hardware definition file for microblaze projects
# file mkdir ./${overlay_name}/${overlay_name}.sdk
# write_hwdef -force  -file ./${overlay_name}/${overlay_name}.sdk/${overlay_name}.hdf
# file copy -force ./${overlay_name}/${overlay_name}.sdk/${overlay_name}.hdf .

# move and rename bitstream to final location
file copy -force ./${overlay_name}/${overlay_name}.runs/impl_1/${design_name}_wrapper.bit ${overlay_name}.bit

# copy hwh files
file copy -force ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/hw_handoff/${design_name}.hwh ${overlay_name}.hwh
