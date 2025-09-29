# TCL script to build cmd_gather from source
# ---------------------------------------------------------------------------
# Build script for cmd_gather block only
# ---------------------------------------------------------------------------

# Create a *separate* project for block-level work
# create_project cmd_execute_block cmd_execute_block -part xc7a100tcsg324-1 -force

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

add_files -fileset sim_1 ./src/common/cmd_pkg.sv

add_files -fileset sim_1 ./src/fifo/cmd_fifo.sv
add_files -fileset sim_1 ./src/core/register_bank.sv
add_files -fileset sim_1 ./src/core/cmd_parser.sv
add_files -fileset sim_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sim_1 ./src/uart/baud_tick_gen.sv


add_files -fileset sim_1 ./sim/common/uvm/uvm_component.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_driver.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_monitor.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequencer.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequence_itm.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_scoreboard.sv


add_files -fileset sim_1 ./sim/common/register/reg_access_entry.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_tlb.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/common_cfg.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_interface.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_transaction.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_driver.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_monitor.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_sequencer.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_scoreboard.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_agent.sv
add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute_top.sv

add_files -fileset sources_1 ./src/common/cmd_pkg.sv

add_files -fileset sources_1 ./src/fifo/cmd_fifo.sv
add_files -fileset sources_1 ./src/core/register_bank.sv
add_files -fileset sources_1 ./src/core/cmd_parser.sv
add_files -fileset sources_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sources_1 ./src/uart/baud_tick_gen.sv


add_files -fileset sources_1 ./sim/common/uvm/uvm_component.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_driver.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_monitor.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_sequencer.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_sequence_itm.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_scoreboard.sv


add_files -fileset sources_1 ./sim/common/register/reg_access_entry.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_tlb.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/common_cfg.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_interface.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_transaction.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_driver.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_monitor.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_sequencer.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_scoreboard.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_agent.sv
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute_top.sv


add_files -fileset sim_1 ./sim/block/cmd_execute_tb/cmd_execute.f
add_files -fileset sources_1 ./sim/block/cmd_execute_tb/cmd_execute.f


# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top cmd_execute_tlb [get_filesets sources_1]
set_property top cmd_execute_top [get_filesets sim_1]

puts "TCL project setup for cmd_execute block complete."


# Uncomment if you want Vivado to launch a run or simulation
# launch_runs synth_1
# move_files [get_files  C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_gather_tb/cmd_gather_tlb.sv]
# set_property top cmd_gather_tlb [current_fileset]
# export_ip_user_files -of_objects  [get_files C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_gather_tb/cmd_gather.f] -no_script -reset -force -quiet
# launch_simulation

