// ./src/common/cmd_pkg.sv

// +incdir+./src/core
./src/uart/uart_rx.sv
./src/fifo/byte_fifo.sv
./src/core/cmd_parser.sv
./src/uart/baud_tick_gen.sv

// +incdir+./src/fifo
// +incdir+./src/uart

./sim/block/cmd_gather_tb/cmd_gather_tlb.sv


./sim/common/uvm/uvm_component.sv
./sim/common/uvm/uvm_driver.sv
./sim/common/uvm/uvm_monitor.sv
./sim/common/uvm/uvm_sequencer.sv
./sim/common/uvm/uvm_sequence_item.sv


./sim/block/cmd_gather_tb/common_cfg.sv
./sim/block/cmd_gather_tb/cmd_gather_interface.sv
./sim/block/cmd_gather_tb/cmd_gather_transaction.sv
./sim/block/cmd_gather_tb/cmd_gather_driver.sv
./sim/block/cmd_gather_tb/cmd_gather_monitor.sv
./sim/block/cmd_gather_tb/cmd_gather_sequencer.sv
./sim/block/cmd_gather_tb/cmd_gather_scoreboard.sv
./sim/block/cmd_gather_tb/cmd_gather_agent.sv
./sim/block/cmd_gather_tb/cmd_gather_top.sv
