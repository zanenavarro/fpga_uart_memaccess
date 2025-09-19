interface cmd_execute_if (input logic clk, input logic rst);

    // ---> cmd_parser
    logic         byte_fifo_valid;
    logic [7:0]   byte_fifo_data;
    logic         byte_fifo_rd_en;

    // cmd_dispatcher --->
    cmd_packet_t cmd_resp_wr_data;
    logic        cmd_resp_wr_en;

endinterface