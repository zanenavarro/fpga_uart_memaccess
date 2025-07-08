//------------------------------------------------------------------------------
// Module Name    : latch_top
// Project        : Latch - UART-Based Register Access System
// Description    : 
//   Top level module that focuses on command gather to be used for testing
//   Submodules:
//     - uart_rx         : Converts serial input to parallel bytes
//     - byte_fifo       : Buffers received UART bytes
//     - cmd_parser      : Parses structured commands from bytes
//
//
// Author         : Zane Navarro
// Date Created   : 2025-07-07
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
//       cmd_fifo_wr_data  : command packet to FIFO for execution 
//       cmd_fifo_wr_en    : enable command FIFO write
//
// Revision History:
//   2025-07-07 - Initial version
//
//------------------------------------------------------------------------------\

module cmd_gather(
    input logic clk,
    input logic rst,
    input logic rx,
    input logic baud_tick,

    output cmd_packet_t cmd_fifo_wr_data,
    output logic cmd_fifo_wr_en
);


baud_tick_gen baud_tick2 (
    .clk(clk),
    .rst(rst),
    .baud_rate(57600),
    .baud_tick(baud_half_tick)
);


logic [7:0] data_captured_byte;
logic data_capture_ready;
logic baud_half_tick;


uart_rx uart_rx (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .baud_tick(baud_tick),
    .baud_half_tick(baud_half_tick),
    .data_out(data_captured_byte),
    .data_ready(data_capture_ready)
);

logic [7:0] byte_fifo_data;
logic byte_fifo_rd_en;
logic byte_fifo_valid;

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

endmodule



