//------------------------------------------------------------------------------
// Module Name    : byte_fifo
// Project        : Latch - UART-Based Register Access System
// Description    : 
//  Buffers incoming bytes into FIFO
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


module byte_fifo #(
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic        clk,
    input  logic        rst,

    input  logic        wr_en,
    input  [7:0]  wr_data,

    input  logic        rd_en,
    output [7:0]  rd_data,
    output logic        valid,
    output logic        full,
    output logic        empty
);
    
logic [7:0] mem [0:DEPTH-1];
logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
logic [ADDR_WIDTH:0] count;
bit valid_write;
bit valid_read;



assign full = (count == DEPTH);
assign empty = (count == 0);
assign valid = !empty;
assign rd_data = mem[rd_ptr];
assign valid_write = (wr_data && !full && wr_en);
assign valid_read = (rd_data && !empty && rd_en);


// write logic
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        wr_ptr <= 0;
    end else if (valid_write) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1; // movin to next entry
    end 
end

// read logic
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        rd_ptr <= 0;
    end else if (valid_read) begin
        rd_ptr <= rd_ptr + 1;
    end
end

// count logic
always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (valid_write) begin
        count <= count - 1;
    end else if (valid_read) begin
        count <= count + 1;
    end
end


endmodule