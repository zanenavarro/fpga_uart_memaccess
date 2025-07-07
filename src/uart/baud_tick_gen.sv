//------------------------------------------------------------------------------
// Module Name    : baud_tick_gen
// Project        : Latch - UART-Based Register Access System
// Description    : 
//  Generates baud_tick signal based on system clock and desired baud rate.
//  The tick occurs once every N cycles, where N = CLK_FREQ_HZ / baud_rate.
//
// Author         : Zane Navarro
// Date Created   : 2025-06-28
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes
//
// Interfaces     :
//   - Inputs:
//       clk         : System clock
//       rst         : Active-high reset
//       baud_rate   : Desired baud rate (e.g., 115200)
//
//   - Parameters:
//       CLK_FREQ_HZ : System clock frequency in Hz (default: 100 MHz)
//
//   - Outputs:
//       baud_tick   : One-cycle pulse at each baud interval
//
// Revision History:
//   2025-06-28 - Initial version (no half-tick)
//
//------------------------------------------------------------------------------

module baud_tick_gen #(
    parameter int unsigned CLK_FREQ_HZ = 100_000_000
) (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] baud_rate,
    output logic        baud_tick
);

    // Derived number of clock cycles per baud interval
    logic [31:0] baud_cycles;
    logic [31:0] counter;

    // Combinational division logic
    always_comb begin
        baud_cycles = (baud_rate != 0) ? (CLK_FREQ_HZ / baud_rate) : 1;
    end

    // Counting logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else if (counter >= baud_cycles - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign baud_tick = (counter == baud_cycles - 1);

endmodule
