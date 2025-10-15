//------------------------------------------------------------------------------
// Module Name    : uart_rx
// Project        : Latche - UART-Based Register Access System
// Description    : 
//   UART receiver module that samples incoming serial data on the RX line.
//   Converts serial data into 8-bit parallel words. Outputs a 'data_ready' 
//   pulse alongside each valid byte. Uses oversampling to detect start, data, 
//   and stop bits accurately.
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
     
`timescale 1ns/1ps

typedef enum logic [2:0] {
    RX_IDLE,       // Waiting for start bit (rx == 0)
    RX_START,      // Verifying start bit duration
    RX_DATA,       // Shifting in 8 data bits
    RX_STOP,       // Validating stop bit (rx == 1)
    RX_DONE        // Data byte received, trigger data_ready
} rx_state_e;


module uart_rx (
    input logic clk,
    input logic rst,
    input logic rx,
    input logic baud_tick,
    input logic baud_half_tick,
    output logic [7:0] data_out,
    output logic data_ready,
    output logic rx_idle,
    output logic rx_start,
    output logic rx_data
);


rx_state_e rx_state;
logic [7:0] sample_data;
logic [3:0] bit_count;
logic data_ready_r;

assign data_ready = data_ready_r;

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        rx_state <= RX_IDLE;
        sample_data <= 8'b0;
        bit_count <= 0;
        rx_idle <= 0;
        rx_data <= 0;
        rx_start <= 0;
        data_out <= 8'b0;
        data_ready_r <= 0;
    end else if (baud_tick) begin
        case (rx_state)
            RX_IDLE: begin
                rx_idle <= 1;
                if (rx == 0)
                    rx_state <= RX_START;
            end
            
            RX_DATA : begin
                rx_data <= 1;
                // begin sampling actual data
                if (bit_count == 8) begin
                    rx_state <= RX_STOP;
                    bit_count <= 0;
                end else begin
                    sample_data <= {rx, sample_data[7:1]}; //shift into sample_data
                    bit_count <= bit_count + 1;
                end
            end
                        
            default: rx_state <= RX_IDLE;
           
        endcase
    end else if (baud_half_tick) begin

        case (rx_state)
            RX_START: begin
                // make sure that rx_state is still low mid sample of START
                if (rx == 0) begin
                    rx_state <= RX_DATA;
                    sample_data <= 8'b0;
                    bit_count <= 0;
                    rx_start <= 1;
                end
            end
        endcase
    end else if (rx_state == RX_DONE) begin
        data_ready_r <= 1;
        rx_state <= RX_IDLE;
    end else if (rx_state == RX_STOP) begin
        if (rx == 1) begin
            rx_state <= RX_DONE;
            data_out <= sample_data;
        end else begin
            rx_state <= RX_IDLE; // framing error, reset
        end
    end else begin
        data_ready_r <= 0;
    end
end


endmodule