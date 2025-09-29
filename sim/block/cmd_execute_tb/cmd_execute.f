// bringing in relevant packages
./src/common/cmd_pkg.sv

// bringing in rtl
./src/block/cmd_execute.f

// insert uvm base files
./sim/common/uvm/uvm_lite_top.sv

// testbench files
./sim/block/cmd_execute_tb/cmd_execute_tlb.sv
./sim/block/cmd_execute_tb/common_cfg.sv
./sim/block/cmd_execute_tb/cmd_execute_interface.sv
./sim/block/cmd_execute_tb/cmd_execute_transaction.sv
./sim/block/cmd_execute_tb/cmd_execute_driver.sv
./sim/block/cmd_execute_tb/cmd_execute_monitor.sv
./sim/block/cmd_execute_tb/cmd_execute_sequencer.sv
./sim/block/cmd_execute_tb/cmd_execute_scoreboard.sv
./sim/block/cmd_execute_tb/cmd_execute_agent.sv
./sim/block/cmd_execute_tb/cmd_execute_top.sv