# TCL script to build cmd_respond from source
# ---------------------------------------------------------------------------
# Build script for cmd_respond block only
# ---------------------------------------------------------------------------

# Create a *separate* project for block-level work
# create_project reg_access_top reg_access_top -part xc7a100tcsg324-1 -force

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_respond
# (Adjust the glob if cmd_respond depends on other submodules)
# add_files -fileset sources_1 [glob ./src/**/*.sv]

# ---------------------- Simulation ----------------------
# Add block-level simulation files only

# In your build_cmd_respond.tcl
# add_files -fileset sim_1 [glob ./src/common/cmd_pkg.sv]
# add_files -fileset sources_1 [glob ./src/common/cmd_pkg.sv]


##########################
# ===============================================================
# TCL script to add files for cmd_respond block simulation
# Explicit compile order
# ===============================================================

# Clear previous sources
reset_project

# Add testbench sources
# Add testbench sources

add_files -fileset sim_1 ./src/common/cmd_pkg.sv
# adding all relevant uart design files
add_files -fileset sim_1 ./src/uart/uart_tx.sv
add_files -fileset sim_1 ./src/uart/uart_rx.sv
# adding all fifos
add_files -fileset sim_1 ./src/fifo/resp_fifo.sv
add_files -fileset sim_1 ./src/fifo/byte_fifo.sv
add_files -fileset sim_1 ./src/fifo/cmd_fifo.sv

# adding all cmd handling rtl
add_files -fileset sim_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sim_1 ./src/core/cmd_parser.sv
add_files -fileset sim_1 ./src/core/register_bank.sv

# adding baud_tick
add_files -fileset sim_1 ./src/uart/baud_tick_gen.sv


add_files -fileset sim_1 ./sim/common/uvm/uvm_component.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_driver.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_monitor.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequencer.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequence_itm.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_scoreboard.sv


add_files -fileset sim_1 ./sim/system/reg_access_tlb.sv
add_files -fileset sim_1 ./sim/block/cmd_respond_tb/common_cfg.sv
add_files -fileset sim_1 ./sim/system/reg_access_interface.sv
add_files -fileset sim_1 ./sim/system/reg_access_transaction.sv
add_files -fileset sim_1 ./sim/system/reg_access_driver.sv
add_files -fileset sim_1 ./sim/system/reg_access_monitor.sv
add_files -fileset sim_1 ./sim/system/reg_access_sequencer.sv
add_files -fileset sim_1 ./sim/system/reg_access_scoreboard.sv
add_files -fileset sim_1 ./sim/system/reg_access_agent.sv
add_files -fileset sim_1 ./sim/system/reg_access_top.sv


add_files -fileset sources_1 ./src/common/cmd_pkg.sv
# adding all relevant uart design files
add_files -fileset sources_1 ./src/uart/uart_tx.sv
add_files -fileset sources_1 ./src/uart/uart_rx.sv
# adding all fifos
add_files -fileset sources_1 ./src/fifo/resp_fifo.sv
add_files -fileset sources_1 ./src/fifo/byte_fifo.sv
add_files -fileset sources_1 ./src/fifo/cmd_fifo.sv

# adding all cmd handling rtl
add_files -fileset sources_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sources_1 ./src/core/cmd_parser.sv
add_files -fileset sources_1 ./src/core/register_bank.sv

# adding baud_tick
add_files -fileset sources_1 ./src/uart/baud_tick_gen.sv

add_files -fileset sources_1 ./sim/system/reg_access_tlb.sv
add_files -fileset sources_1 ./sim/system/reg_access_top.sv

# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top reg_access_tlb [get_filesets sources_1]
set_property top reg_access_top [get_filesets sim_1]

puts "TCL project setup for cmd_respond block complete."


# Uncomment if you want Vivado to launch a run or simulation
# launch_runs synth_1
# move_files [get_files  C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_respond_tb/cmd_respond_tlb.sv]
set_property top reg_access_tlb [current_fileset]
# export_ip_user_files -of_objects  [get_files C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_respond_tb/cmd_respond.f] -no_script -reset -force -quiet
# remove_files  C:/Users/zane/projects/fpga/uart_memaccess/sim/block/cmd_respond_tb/cmd_respond.f
# launch_simulation

