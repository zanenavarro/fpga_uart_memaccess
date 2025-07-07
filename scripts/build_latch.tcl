# TCL script to build Latch project from source

# create_project latch latch_top -part xc7a100tcsg324-1

# Add Verilog/SystemVerilog source files
add_files [glob ./src/**/*.sv]

# Add constraints
# add_files ./constraints/latch_top.xdc

# Set compile order and run synthesis
update_compile_order -fileset sources_1
launch_runs synth_1
