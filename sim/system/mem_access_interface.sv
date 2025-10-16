interface mem_access_if (input logic clk, input logic rst);
    logic rx;
    logic tx;
    logic tx_en;

    logic baud_tick;
    logic baud_half_tick;
endinterface