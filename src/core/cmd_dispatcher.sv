//------------------------------------------------------------------------------
// Module Name    : cmd_dispatcher
// Project        : Latch - UART-Based Register Access System
// Description    : 
//  
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

typedef enum logic [2:0]{
    IDLE,
    FIFO_COLLECT,
    READ,
    READ_DELAY,
    READ_RX,
    WRITE,
    MODIFY,
    DONE
} cmd_state_t;

module cmd_dispatcher (
    input logic clk,
    input logic rst,
    
    // input from cmd_fifo
    input cmd_packet_t cmd_rd_data,
    input logic cmd_valid,
    output logic cmd_rd_en,
    
    output logic [7:0] mem_addr,
    
    // output to register file
    // write
    output logic mem_write_en,
    output logic [7:0] mem_write_data,
    
    // read
    output logic mem_read_en,
    input logic [7:0] mem_read_data,
    
    
    // output to tx
    output cmd_packet_t data_out_tx,
    output logic out_tx_en
);

cmd_state_t cmd_state;
cmd_packet_t active_cmd;

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        cmd_rd_en <= '0;
        cmd_state <= IDLE;
        mem_addr <= '0;
        mem_write_en <= '0;
        mem_read_en <= '0;
        data_out_tx <= '0;
        out_tx_en <= '0;
        active_cmd <= 0;
    end else begin
        cmd_rd_en      <= 0;
        mem_write_en   <= 0;
        mem_read_en    <= 0;
        data_out_tx.data    <= 0;
        out_tx_en      <= 0;
        

        case (cmd_state)
            IDLE: begin
                if (cmd_valid) begin
                    cmd_rd_en <= 1;
                    cmd_state <= FIFO_COLLECT;
                end
            end
            
            FIFO_COLLECT: begin
            
                active_cmd <= cmd_rd_data;
                data_out_tx <= cmd_rd_data;
                case (cmd_rd_data.cmd_type)
                    2'd0: 
                        cmd_state <= READ;
                    2'd1:
                        cmd_state <= WRITE;
                    2'd2:
                        cmd_state <= MODIFY;
                endcase
            end
            
            MODIFY: begin
                mem_addr       <= active_cmd.addr;
                mem_read_en    <= 1;
                cmd_state      <= READ_DELAY; // reuse logic from READ
            end
            
            READ: begin
                mem_addr <= active_cmd.addr;
                mem_read_en <= 1;
                
                cmd_state <= READ_DELAY;    
            end
            
            
            READ_DELAY: begin
                cmd_state <= READ_RX;
            end
            
            READ_RX: begin
                // sending msg back out
                data_out_tx.data <= mem_read_data; // updating with read value
                out_tx_en <= 1;
                cmd_state <= DONE;
            end
            
            WRITE: begin
            
                //writing to memory
                mem_addr <= active_cmd.addr;
                mem_write_en <= 1;
                mem_write_data <= active_cmd.data;
                
                // sending msg back out
                out_tx_en <= 1;
                cmd_state <= DONE;
            end
            
            DONE: begin
                cmd_state <= IDLE;
            end
        endcase
    end
end



endmodule
