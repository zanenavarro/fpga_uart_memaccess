//------------------------------------------------------------------------------
// Module Name    : rsp_fifo
// Project        : Latch - UART-Based Register Access System
// Description    : 
//  Buffers commands while parser FSM handles one at a time
// Author         : Zane Navarro
// Date Created   : 2025-06-28
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes
//
// Interfaces     :
//
// Revision History:
//   2025-06-28 - Initial version
//
//------------------------------------------------------------------------------


import cmd_pkg::*;

module resp_fifo #(
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic        clk,
    input  logic        rst,

    input  logic        wr_en,
    input  cmd_packet_t  wr_data,

    input  logic        rd_en,
    output cmd_packet_t  rd_data,
    output logic        valid,
    output logic        full,
    output logic        empty
);
    
cmd_packet_t mem [0:DEPTH-1];
logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
logic [ADDR_WIDTH:0] count;



assign full = (count == DEPTH);
assign empty = (count == 0);
assign valid = !empty;
assign rd_data = mem[rd_ptr];


// write logic
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        wr_ptr <= 0;
    end else if (wr_en && !full) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1; // movin to next entry
    end 
end

// read logic
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1;
    end
end

// count logic
always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (wr_en && !full) begin
        count <= count + 1;
    end else if (rd_en && !empty) begin
        count <= count - 1;
    end
end


endmodule