// bringing in relevant packages
./src/common/cmd_pkg.sv

// bringing in rtl
./src/block/cmd_respond.f

// insert uvm base files
./sim/common/uvm/uvm_lite_top.sv


// testbench files
./sim/block/cmd_respond_tb/cmd_respond_tlb.sv
./sim/block/cmd_respond_tb/common_cfg.sv
./sim/block/cmd_respond_tb/cmd_respond_interface.sv
./sim/block/cmd_respond_tb/cmd_respond_transaction.sv
./sim/block/cmd_respond_tb/cmd_respond_driver.sv
./sim/block/cmd_respond_tb/cmd_respond_monitor.sv
./sim/block/cmd_respond_tb/cmd_respond_sequencer.sv
./sim/block/cmd_respond_tb/cmd_respond_scoreboard.sv
./sim/block/cmd_respond_tb/cmd_respond_agent.sv
./sim/block/cmd_respond_tb/cmd_respond_top.sv
