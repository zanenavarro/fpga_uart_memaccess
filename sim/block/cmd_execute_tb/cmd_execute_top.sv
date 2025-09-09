module cmd_execute_tb ();

    // Clock and reset signals
    logic clk;
    logic rst;

    // instantiate interface
    cmd_execute_if tb_if(clk, rst);

    // instantiate agent

    
    // instantiate the DUT
    cmd_execute_tlb cmd_execute (
        .clk(clk),
        .rst(rst),

        // ---> cmd_parser
        .byte_fifo_valid(tb_if.byte_fifo_valid),
        .byte_fifo_data(tb_if.byte_fifo_data),
        .byte_fifo_rd_en(tb_if.byte_fifo_rd_en),

        // cmd_dispatcher --->
        .cmd_resp_wr_data(tb_if.cmd_resp_wr_data),
        .cmd_resp_wr_en(tb_if.cmd_resp_wr_en)
    );

    // Clock generation
    localparam CLK_PERIOD = 10ns;  // 100 MHz

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset generation
    initial begin
        rst = 0;
        #100;        // hold reset low for 100ns
        rst = 1;
    end

endmodule