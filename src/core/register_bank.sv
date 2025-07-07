//------------------------------------------------------------------------------
// Module Name    : register_bank
// Project        : Latch - UART-Based Register Access System
// Description    : 
//   256 x 16-bit internal register file with synchronous write and 
//   latched read behavior. Registers are memory-mapped and accessible 
//   over a UART interface via the command parser FSM.
//
// Author         : Zane Navarro
// Date Created   : 2025-06-28
// Tool Target    : Vivado / Nexys A7 (Artix-7)
// Synthesizable  : Yes
//
// Interfaces     :
//   - Clocked on : clk (posedge)
//   - Inputs     : write_en, read_strobe, addr, write_data
//   - Outputs    : read_data
//
// Revision History:
//   2025-06-28 - Initial version
//
//------------------------------------------------------------------------------


module register_bank (
    input logic clk,
    input logic write_en,
    input logic read_strobe,
    input logic [7:0] addr,
    input logic [7:0] write_data,
    output logic [7:0] read_data 
);


    logic [7:0] regs [0:255]; //make this parameterized
    
    // write : synchronous
    always_ff @(posedge clk) begin
        if (write_en) 
            regs[addr] <= write_data;
    end
    
    // read: latch on read_strobe
    always_ff @(posedge clk) begin
        if (read_strobe)
            read_data <= regs[addr];
    end

endmodule