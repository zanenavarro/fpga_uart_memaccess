// ============================================================================
//  Testbench: cmd_gather_tb
// -----------------------------------------------------------------------------
//  This testbench simulates a mini command pipeline:
//  
//   [ uart_rx ]  --->  [ byte_fifo ]  --->  [ cmd_parser ]
//
//  - uart_rx:    Converts serial stream into bytes
//  - byte_fifo:  Buffers bytes between producer and consumer
//  - cmd_parser: Interprets byte stream into structured commands
//
//  Purpose:
//   Verifies data integrity across the RX → FIFO → Parser chain.
//   Ensures timing, flow control, and command framing are robust.
// 
//  Think of it as the "assembly line" for incoming UART traffic.
// ============================================================================ 

import cmd_pkg::*;

module cmd_gather_tlb (

    input logic         clk,
    input logic         rst,

	// ---> uart_rx
	input logic         uart_rx_in,

    input logic         baud_tick;
    input logic         baud_half_tick;

	// cmd_parser --->
	output logic        cmd_fifo_wr_en,
	output cmd_packet_t cmd_fifo_wr_data,
);




    // uart_rx --> byte_fifo
    logic [7:0] sampled_byte_data;
    logic       sampled_byte_valid;

    // cmd_parser --> byte_fifo
    logic       byte_fifo_rd_en;
    logic [7:0] byte_fifo_data;
    logic       byte_fifo_valid;


    /////////////////////////////////
    ///////////////// UART_RX MODULE
    uart_rx uart_rx (
        // inputs
        .clk(clk),
        .rst(rst),
        .rx(uart_rx_in),
        .baud_tick(baud_tick),
        .baud_half_tick(baud_half_tick),

        // outputs
        .data_out(sampled_byte_data),
        .data_ready(sampled_byte_valid)
    );
    /////////////////////////////////

    /////////////////////////////////
    ////////////////////// BYTE_FIFO 
    byte_fifo #(
        .DEPTH(16),
        .ADDR_WIDTH($clog2(16))
    ) byte_fifo (
        // inputs
        .clk(clk),
        .rst(rst),
        .wr_en(sampled_byte_valid),
        .wr_data(sampled_byte_data),
        .rd_en(byte_fifo_rd_en),

        // outputs
        .rd_data(byte_fifo_data),
        .valid(byte_fifo_valid),
        .full(full),
        .empty(empty)
    );
    /////////////////////////////////



    /////////////////////////////////
    ///////////////////// CMD_PARSER
    cmd_parser cmd_parser (
        .clk(clk),
        .rst(rst),

        // Byte FIFO interface (from uart_rx)
        .byte_fifo_valid(byte_fifo_valid),
        .byte_fifo_data(byte_fifo_data),
        .byte_fifo_rd_en(byte_fifo_rd_en),

        // Command FIFO interface
        .cmd_fifo_wr_en(cmd_fifo_wr_en),
        .cmd_fifo_wr_data(cmd_fifo_wr_data)
    );
    /////////////////////////////////



    // Clock generation
    localparam CLK_PERIOD = 10ns;  // 100 MHz

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset generation
    initial begin
        rst = 0;
        #100;        // hold reset low for 100ns
        rst = 1;
    end

endmodule