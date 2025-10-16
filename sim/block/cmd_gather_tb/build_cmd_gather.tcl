##########################
# ===============================================================
# TCL script to add files for cmd_gather block simulation
# ===============================================================

# Creating a separate project for Nexys A7
# create_project cmd_gather_tb cmd_gather_tb -part xc7a50ticsg324-1L -force

# Clear previous sources
reset_project

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather sim_1
add_files -fileset sim_1 ./src/common/cmd_pkg.sv

# Add RTL Files
add_files -fileset sim_1 ./src/uart/uart_rx.sv
add_files -fileset sim_1 ./src/fifo/byte_fifo.sv
add_files -fileset sim_1 ./src/core/cmd_parser.sv
add_files -fileset sim_1 ./src/uart/baud_tick_gen.sv


# ---------------------- Simulation ----------------------
# add baseline uvm_components
add_files -fileset sim_1 ./sim/common/uvm/uvm_component.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_driver.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_monitor.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequencer.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_sequence_itm.sv
add_files -fileset sim_1 ./sim/common/uvm/uvm_scoreboard.sv

# Add testbench sources
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/common_cfg.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_interface.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_transaction.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_driver.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_monitor.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_sequencer.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_scoreboard.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_agent.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_top.sv
add_files -fileset sim_1 ./sim/block/cmd_gather_tb/cmd_gather_tlb.sv


# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather sim_1
add_files -fileset sources_1 ./src/common/cmd_pkg.sv

# Add RTL Files
add_files -fileset sources_1 ./src/uart/uart_rx.sv
add_files -fileset sources_1 ./src/fifo/byte_fifo.sv
add_files -fileset sources_1 ./src/core/cmd_parser.sv
add_files -fileset sources_1 ./src/uart/baud_tick_gen.sv

# ---------------------- Simulation ----------------------
# add baseline uvm_components
add_files -fileset sources_1 ./sim/common/uvm/uvm_component.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_driver.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_monitor.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_sequencer.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_sequence_itm.sv
add_files -fileset sources_1 ./sim/common/uvm/uvm_scoreboard.sv

# Add testbench sources
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/common_cfg.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_interface.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_transaction.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_driver.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_monitor.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_sequencer.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_scoreboard.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_agent.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_top.sv
add_files -fileset sources_1 ./sim/block/cmd_gather_tb/cmd_gather_tlb.sv



# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top cmd_gather_tlb [get_filesets sources_1]
set_property top cmd_gather_top [get_filesets sim_1]

puts "TCL project setup for cmd_gather block complete."


# Uncomment if you want Vivado to launch a run or simulation
# launch_simulation

