# ===============================================================
# TCL script to add files for mem_access system simulation
# ===============================================================

# Create a *separate* project for block-level work
# create_project mem_access_top mem_access_top -part xc7a50ticsg324-1L -force

# Clear previous sources
reset_project

# ---------------------- RTL ----------------------
# Add only RTL needed for cmd_gather sources_1
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


add_files -fileset sim_1 ./sim/block/mem_access_tb/common_cfg.sv
add_files -fileset sim_1 ./sim/system/mem_access_interface.sv
add_files -fileset sim_1 ./sim/system/mem_access_transaction.sv
add_files -fileset sim_1 ./sim/system/mem_access_driver.sv
add_files -fileset sim_1 ./sim/system/mem_access_monitor.sv
add_files -fileset sim_1 ./sim/system/mem_access_sequencer.sv
add_files -fileset sim_1 ./sim/system/mem_access_scoreboard.sv
add_files -fileset sim_1 ./sim/system/mem_access_agent.sv
add_files -fileset sim_1 ./sim/system/mem_access_top.sv
add_files -fileset sim_1 ./sim/system/mem_access_tlb.sv



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
add_files -fileset sources_1 ./sim/system/mem_access_tlb.sv
add_files -fileset sources_1 ./src/system/mem_access_top_level.sv

# Update compile order
update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Optional: set top module for simulation and design
set_property top mem_access_tlb [get_filesets sources_1]
set_property top mem_access_top [get_filesets sim_1]

puts "TCL project setup for mem_access block complete."
set_property top mem_access_tlb [current_fileset]

launch_simulation

