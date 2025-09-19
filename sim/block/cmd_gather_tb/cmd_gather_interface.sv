
import cmd_pkg::*;

interface cmd_gather_if (input logic clk, input logic rst);
	
    logic        uart_rx_in;
    logic        cmd_fifo_wr_en;
    cmd_packet_t cmd_fifo_wr_data;
    logic        baud_tick;
    logic        baud_half_tick;

endinterface