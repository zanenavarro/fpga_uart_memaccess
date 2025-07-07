//------------------------------------------------------------------------------
// Module Name    : latch_top
// Project        : Latch - UART-Based Register Access System
// Description    : 
//   Top-level module that integrates UART communication, command parsing,
//   and memory-mapped register access. Receives commands over UART, parses them 
//   into structured packets, and executes read/write operations on internal 
//   registers. Provides a modular and expandable architecture for remote 
//   control and debugging via serial interface.
//
//   Submodules:
//     - uart_rx         : Converts serial input to parallel bytes
//     - byte_fifo       : Buffers received UART bytes
//     - cmd_parser      : Parses structured commands from bytes
//     - cmd_fifo        : Buffers parsed commands for execution
//     - cmd_dispatcher  : Retrieves commands and executes
//     - register_file   : Memory-mapped register access
//     - uart_tx (future): Optional outbound data path
//
//   Features:
//     - UART communication interface (from Raspberry Pi or other host)
//     - FIFO-based buffering and command arbitration
//     - Modular register-based SoC interaction and expansion-ready design
//
// Author         : Zane Navarro
// Date Created   : 2025-06-28
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes
//
// Interfaces     :
//   - Inputs:
//       clk           : System clock
//       rst           : Active-high synchronous reset
//       rx            : UART RX line (serial input from Pi)
//
//   - Outputs:
//       tx            : UART TX line (for future use)
//       debug_leds    : Optional debug output (e.g., register status)
//
// Revision History:
//   2025-06-28 - Initial version
//
//------------------------------------------------------------------------------
import cmd_pkg::*;
module latch_top(
    input logic clk,
    input logic rst,
    
    input logic rx,
    output logic tx
);

logic baud_tick;
logic baud_half_tick;

baud_tick_gen baud_tick1 (
    .clk(clk),
    .rst(rst),
    .baud_rate(115200),
    .baud_tick(baud_tick)
);

baud_tick_gen baud_tick2 (
    .clk(clk),
    .rst(rst),
    .baud_rate(57600),
    .baud_tick(baud_tick_half)
);


logic [7:0] data_captured_byte;
logic data_capture_ready;

uart_rx uart_rx (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .baud_tick(baud_tick),
    .baud_half_tick(baud_half_tick),
    .data_out(data_captured_byte),
    .data_ready(data_capture_ready)
);


byte_fifo byte_fifo (
    .clk(clk),
    .rst(rst),
    .wr_en(data_capture_ready),
    .wr_data(data_captured_byte),
    .rd_en(byte_fifo_rd_en),
    .rd_data(byte_fifo_data),
    .valid(byte_fifo_valid),
    .full(full),
    .empty(empty)
);


cmd_parser cmd_parser (
    .clk(clk),
    .rst(rst),

    // Byte FIFO interface (from uart_rx)
    //inputs
    .byte_fifo_valid(byte_fifo_valid),
    .byte_fifo_data(byte_fifo_data),
    
    
    //outputs
    .byte_fifo_rd_en(byte_fifo_rd_en),

    // Command FIFO interface
    .cmd_fifo_wr_en(cmd_fifo_wr_en),
    .cmd_fifo_wr_data(cmd_fifo_wr_data)
);


cmd_fifo cmd_fifo (
    .clk(clk),
    .rst(rst),
    
    // inputs
    .wr_en(cmd_fifo_wr_en),
    .wr_data(cmd_fifo_wr_data),
    .rd_en(cmd_rd_en),
    
    // outputs
    .rd_data(cmd_rd_data),
    .valid(cmd_valid),
    .full(full),
    .empty(empty)
);


cmd_dispatcher cmd_dispatch (
    .clk(clk),
    .rst(rst),
    
    // input from cmd_fifo
    .cmd_rd_data(cmd_rd_data),
    .cmd_valid(cmd_valid),
    .cmd_rd_en(cmd_rd_en),
    
    
    // output to register file
    .mem_addr(mem_addr),
    // write
    .mem_write_en(mem_write_en),
    .mem_write_data(mem_write_data),
    
    // read
    .mem_read_en(mem_read_en),
    .mem_read_data(mem_read_data),
    
    
    // output to resp fifo
    .data_out_tx(data_out_tx),
    .out_tx_en(data_out_tx_en)
);


logic [7:0] mem_addr;
logic mem_write_en;
logic mem_read_en;
logic [7:0] mem_write_data;
logic [7:0] mem_read_data;

register_bank reg_bank(
    //input
    .clk(clk),
    .addr(mem_addr),
    .write_en(mem_write_en),
    .write_data(mem_write_data),
    .read_strobe(mem_read_en),
    
    // output
    .read_data(mem_read_data) 
);

logic data_out_tx_en;
cmd_packet_t data_out_tx;


// From resp_fifo to uart_tx
logic [7:0] rd_data;
logic valid;
logic full;
logic empty;

resp_fifo resp_fifo (
    .clk(clk),
    .rst(rst),
    
    // inputs
    .wr_en(data_out_tx_en),
    .wr_data(data_out_tx),
    .rd_en(data_read_en),
    
    // outputs
    .rd_data(rd_data),
    .valid(valid),
    .full(full),
    .empty(empty)
);


// Hook for uart_tx
logic data_ready;
assign data_ready = valid;

// Connect rd_data to cmd_rsp
cmd_packet_t cmd_rsp;
assign cmd_rsp = rd_data;


uart_tx uart_tx (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .cmd_rsp(cmd_rsp),
    .data_ready(data_ready),
    
    // output
    .data_read_en(data_read_en),
    .tx(tx)
);



endmodule
