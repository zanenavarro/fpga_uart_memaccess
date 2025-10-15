//------------------------------------------------------------------------------
// Module Name    : uart_tx
// Project        : Latche - UART-Based Register Access System
// Description    : 
//   UART receiver module that sends incoming serial data on the TX line.
//
//   This module assumes:
//     - 8 data bits
//     - 1 stop bit
//     - No parity
//     - Fixed baud rate set by input clock and 'BAUD_TICK' parameter
//
// Author         : Zane Navarro
// Date Created   : 2025-06-28
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes
//
// Interfaces     :
//   - Inputs:
//       clk          : System clock
//       rst          : Active-high reset
//       rx           : UART serial input (from Raspberry Pi)
//
//   - Parameters:
//       BAUD_TICK    : Number of clock cycles per UART bit (derived from clk freq)
//
//   - Outputs:
//       data_out     : 8-bit parallel output byte
//       data_ready   : Pulse high (1 clk) when a full byte has been received
//
// Revision History:
//   2025-06-28 - Initial version
//
//------------------------------------------------------------------------------

typedef enum logic [3:0] {
    TX_IDLE,       // Trigger start bit (rx == 0)
    TX_READ,      // Verifying start bit duration
    TX_READ_DELAY,
    TX_READ_FIFO_COLLECT,
    TX_DATA,       // Shifting in 8 data bits
    TX_STOP,       // Validating stop bit (rx == 1)
    TX_DONE        // Data byte received, trigger data_ready
} tx_state_e;

module uart_tx (
    input logic clk,
    input logic rst,
    input logic baud_tick,
    input cmd_packet_t cmd_rsp,
    input logic data_ready,
    output logic data_read_en,
    output logic tx_en,
    output logic tx
);


tx_state_e tx_state;
cmd_packet_t current_cmd_rsp;
logic [4:0] bit_count;
logic [29:0] shift_reg;


always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        tx_state     <= TX_IDLE;
        bit_count    <= 0;
        shift_reg    <= 0;
        tx           <= 1;
        tx_en        <= 0;
        current_cmd_rsp <= '0;
    end else if (baud_tick) begin
        tx           <= 1;
        data_read_en <= 0;
        case (tx_state)            
            TX_DATA : begin
                // begin transmitting actual data
                tx <= shift_reg[0];
                tx_en <= 1;
                shift_reg <= shift_reg >> 1;
                bit_count <= bit_count + 1;
                
                if (bit_count == 29)
                    tx_state <= TX_STOP;
            end
            
            TX_STOP : begin
                tx       <= 1;
                tx_en    <= 0;
                tx_state <= TX_DONE;
                shift_reg <= '0;
                bit_count <= '0;
            end
                        
            default: tx_state <= TX_IDLE;
           
        endcase
    end else begin
        
        data_read_en <= 0;
        
        case (tx_state)            

            TX_IDLE: begin
                if (data_ready == 1) begin
                    tx_state     <= TX_READ;
                end
                tx_en <= 0;
            end
            
            TX_READ: begin
                data_read_en <= 1;
                tx_state     <= TX_READ_FIFO_COLLECT;
                current_cmd_rsp <= cmd_rsp;

            end

            TX_READ_FIFO_COLLECT: begin
                shift_reg <= {
                    // Byte 3: Data
                    1'b1,                                     // Stop bit
                    current_cmd_rsp.data,                             // 8 bits (MSB first here)
                    1'b0,                                     // Start bit
                
                    // Byte 2: Addr
                    1'b1,
                    current_cmd_rsp.addr,
                    1'b0,
                
                    // Byte 1: Cmd Type
                    1'b1,
                    current_cmd_rsp.cmd_type,
                    1'b0
                };
                // tx        <= 0;
                tx_state  <= TX_DATA;
            end


            TX_DONE : begin
                tx_state <= TX_IDLE;
            end
        endcase
    end
end

endmodule