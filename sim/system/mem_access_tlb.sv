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
module mem_access_tlb(
    input logic clk,
    input logic rst,
    
    input logic rx,
    output logic tx_en,
    output logic tx,


    output logic rx_idle,
    output logic rx_start,
    output logic rx_data,



    input logic baud_half_tick,
    input logic baud_tick
);


    // uart_rx --> byte_fifo
    logic [7:0] sampled_byte_data;
    logic       sampled_byte_valid;

    // cmd_parser --> byte_fifo
    logic       byte_fifo_rd_en;
    logic [7:0] byte_fifo_data;
    logic       byte_fifo_valid;



    // cmd parser --> cmd_fifo
    cmd_packet_t cmd_fifo_wr_data;
    logic        cmd_fifo_wr_en;

    // cmd_fifo --> cmd_dispatch
    cmd_packet_t cmd_fifo_rd_data;
    logic        cmd_fifo_rd_en;

    logic        cmd_fifo_valid;
    logic        cmd_fifo_full;
    logic        cmd_fifo_empty;

    // cmd_dispatch <--> register
    logic        reg_read_en;
    logic        reg_write_en;
    logic [7:0]  reg_read_data;
    logic [7:0]  reg_write_data;
    logic [7:0]  reg_addr;


    // cmd_dispatcher ---> resp_fifo
    cmd_packet_t resp_fifo_wr_data;
    logic        resp_fifo_wr_en;

    // resp_fifo  ---> uart_tx
    cmd_packet_t resp_fifo_rd_data;
    logic        resp_fifo_rd_en;
    logic        resp_fifo_valid;

    uart_rx uart_rx (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .baud_tick(baud_tick),
        .baud_half_tick(baud_half_tick),
        .data_out(sampled_byte_data),
        .data_ready(sampled_byte_valid),

        .rx_idle(rx_idle),
        .rx_start(rx_start),
        .rx_data(rx_data)

    );


    byte_fifo byte_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(sampled_byte_valid),
        .wr_data(sampled_byte_data),
        .rd_en(byte_fifo_rd_en),
        .rd_data(byte_fifo_data),
        .valid(byte_fifo_valid),
        .full(),
        .empty()
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
        .rd_en(cmd_fifo_rd_en),
        
        // outputs
        .rd_data(cmd_fifo_rd_data),
        .valid(cmd_fifo_valid),
        .full(full),
        .empty(empty)
    );


    cmd_dispatcher cmd_dispatch (
        .clk(clk),
        .rst(rst),
        
        // input from cmd_fifo
        .cmd_rd_data(cmd_fifo_rd_data),
        .cmd_valid(cmd_fifo_valid),
        .cmd_rd_en(cmd_fifo_rd_en),
        
        
        // output to register file
        .mem_addr(reg_addr),
        // write
        .mem_write_en(reg_write_en),
        .mem_write_data(reg_write_data),
        
        // read
        .mem_read_en(reg_read_en),
        .mem_read_data(reg_read_data),
        
        
        // output to resp fifo
        .data_out_tx(resp_fifo_wr_data),
        .out_tx_en(resp_fifo_wr_en)
    );

    ram ram(
        //input
        .clk(clk),
        .addr(reg_addr),
        .write_en(reg_write_en),
        .write_data(reg_write_data),
        .read_strobe(reg_read_en),
        
        // output
        .read_data(reg_read_data) 
    );


    resp_fifo resp_fifo (
        .clk(clk),
        .rst(rst),
        
        // inputs
        .wr_en(resp_fifo_wr_en),
        .wr_data(resp_fifo_wr_data),
        .rd_en(resp_fifo_rd_en),
        
        // outputs
        .rd_data(resp_fifo_rd_data),
        .valid(resp_fifo_valid),
        .full(),
        .empty()
    );

    uart_tx uart_tx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .cmd_rsp(resp_fifo_rd_data),
        .data_ready(resp_fifo_valid),
        
        // output
        .data_read_en(resp_fifo_rd_en),
        .tx(tx),
        .tx_en(tx_en)
    );

endmodule
