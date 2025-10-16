# ===============================================================
# TCL script to add files for cmd_gather block simulation
# ===============================================================

# Create a *separate* project for block-level work
# create_project cmd_execute_block cmd_execute_block -part xc7a50ticsg324-1L -force

# Clear previous sources
reset_project

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather
add_files -fileset sim_1 ./src/common/cmd_pkg.sv
add_files -fileset sim_1 ./src/fifo/cmd_fifo.sv
add_files -fileset sim_1 ./src/core/ram.sv
add_files -fileset sim_1 ./src/core/cmd_parser.sv
add_files -fileset sim_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sim_1 ./src/uart/baud_tick_gen.sv

# ---------------------- Simulation ----------------------
# Add block-level simulation files only
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

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather sources_1
add_files -fileset sources_1 ./src/common/cmd_pkg.sv
add_files -fileset sources_1 ./src/fifo/cmd_fifo.sv
add_files -fileset sources_1 ./src/core/ram.sv
add_files -fileset sources_1 ./src/core/cmd_parser.sv
add_files -fileset sources_1 ./src/core/cmd_dispatcher.sv
add_files -fileset sources_1 ./src/uart/baud_tick_gen.sv

# ---------------------- Simulation ----------------------
# Add block-level simulation files only
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


# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top cmd_execute_tlb [get_filesets sources_1]
set_property top cmd_execute_top [get_filesets sim_1]

puts "TCL project setup for cmd_execute block complete."

# Uncomment to automatically launch simulation automatically
# launch_simulation

