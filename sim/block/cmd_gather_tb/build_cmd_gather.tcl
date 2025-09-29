# TCL script to build cmd_gather from source
# ---------------------------------------------------------------------------
# Build script for cmd_gather block only
# ---------------------------------------------------------------------------

# Create a *separate* project for block-level work
# create_project cmd_gather_block cmd_gather_block -part xc7a100tcsg324-1 -force

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather
# (Adjust the glob if cmd_gather depends on other submodules)
# add_files -fileset sources_1 [glob ./src/**/*.sv]

# ---------------------- Simulation ----------------------
# Add block-level simulation files only

# In your build_cmd_gather.tcl
# add_files -fileset sim_1 [glob ./src/common/cmd_pkg.sv]
# add_files -fileset sources_1 [glob ./src/common/cmd_pkg.sv]


##########################
# ===============================================================
# TCL script to add files for cmd_gather block simulation
# Explicit compile order
# ===============================================================

# Clear previous sources
reset_project

# Add testbench sources
add_files -fileset sim_1 ../sim/block/cmd_gather_tb/cmd_gather.f
add_files -fileset sources_1 ../sim/block/cmd_gather_tb/cmd_gather.f


# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top cmd_gather_tlb [get_filesets sources_1]
set_property top cmd_gather_top [get_filesets sim_1]

puts "TCL project setup for cmd_gather block complete."


# Uncomment if you want Vivado to launch a run or simulation
# launch_runs synth_1
move_files [get_files  C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_gather_tb/cmd_gather_tlb.sv]
set_property top cmd_gather_tlb [current_fileset]
export_ip_user_files -of_objects  [get_files C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_gather_tb/cmd_gather.f] -no_script -reset -force -quiet
# remove_files  C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_gather_tb/cmd_gather.f
# launch_simulation

