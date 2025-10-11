//------------------------------------------------------------------------------
// Interface Name : uart_tx_if
// Project        : Latch - UART-Based Register Access System
// Description    : 
//  Provides a clean connection layer between the command FIFO, UART transmitter,
//  and testbench components. Encapsulates command data flow and TX output
//  signals into a single interface for ease of connectivity.
// Author         : Zane Navarro
// Date Created   : 2025-08-31
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes (interface signals can be flattened during synthesis)
//
// Interfaces     :
//   - cmd_fifo_rd_data : Command packet input from FIFO
//   - cmd_fifo_rd_en   : Read enable to FIFO
//   - cmd_fifo_valid   : Valid flag from FIFO
//   - tx_data          : Serialized TX output bit
//
// Revision History:
//   2025-08-31 - Initial version
//
//------------------------------------------------------------------------------

import cmd_pkg::*;

interface cmd_respond_if (input logic clk, input logic rst_n);

    cmd_packet_t cmd_fifo_rd_data;
    logic        cmd_fifo_rd_en;
    logic        cmd_fifo_valid;
    
    logic        baud_tick;

    logic        tx_data_en;
    logic        tx_data;

endinterface