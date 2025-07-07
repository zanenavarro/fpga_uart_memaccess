//------------------------------------------------------------------------------
// Module Name    : cmd_parser
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

import cmd_pkg::*;

module cmd_parser (
    input  logic        clk,
    input  logic        rst,

    // Byte FIFO interface (from uart_rx)
    input  logic        byte_fifo_valid,
    input  logic [7:0]  byte_fifo_data,
    output logic        byte_fifo_rd_en,

    // Command FIFO interface
    output logic        cmd_fifo_wr_en,
    output cmd_packet_t cmd_fifo_wr_data
);

cmd_packet_t cmd_reg;
logic [1:0]  byte_count;

assign byte_fifo_rd_en = byte_fifo_valid;


always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        cmd_reg <= 0;
        byte_count <= 0;
        cmd_fifo_wr_data <= 0;
        cmd_fifo_wr_en <= 0;
        
    end else begin
        cmd_fifo_wr_en   <= 0;
        if (byte_fifo_valid) begin
            case (byte_count)
                2'b00: begin
                    cmd_reg.cmd_type <= byte_fifo_data[1:0];
                end
                2'b01: begin
                    cmd_reg.addr <= byte_fifo_data;
                end
                2'b10: begin
                    cmd_fifo_wr_data <= '{ 
                        cmd_type: cmd_reg.cmd_type, 
                        addr:     cmd_reg.addr, 
                        data:     byte_fifo_data
                    };
                    cmd_fifo_wr_en <= 1;
                end
            endcase
        end
        
        // handling byte_count
        if (byte_count == 2)
            byte_count <= 0;
        else
            byte_count <= byte_count + 1;
    end
end

endmodule