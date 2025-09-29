// bringing in relevant packages
./src/common/cmd_pkg.sv

// bringing in rtl
./src/block/cmd_gather.f

// insert uvm base files
./sim/common/uvm/uvm_lite_top.sv


// testbench files
./sim/block/cmd_gather_tb/cmd_gather_tlb.sv
./sim/block/cmd_gather_tb/common_cfg.sv
./sim/block/cmd_gather_tb/cmd_gather_interface.sv
./sim/block/cmd_gather_tb/cmd_gather_transaction.sv
./sim/block/cmd_gather_tb/cmd_gather_driver.sv
./sim/block/cmd_gather_tb/cmd_gather_monitor.sv
./sim/block/cmd_gather_tb/cmd_gather_sequencer.sv
./sim/block/cmd_gather_tb/cmd_gather_scoreboard.sv
./sim/block/cmd_gather_tb/cmd_gather_agent.sv
./sim/block/cmd_gather_tb/cmd_gather_top.sv
