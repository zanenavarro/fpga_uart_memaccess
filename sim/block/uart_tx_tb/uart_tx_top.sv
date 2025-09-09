module uart_tx_top ();

    // Clock and reset signals
    logic clk;
    logic rst;

    // instantiate interface
    uart_tx_if tb_if(clk, rst);

    // instantiate agent

    // instantiate the DUT
    uart_tx_tlb uart_tx (
        .clk(clk),
        .rst(rst),

        // ---> cmd_dispatcher
        .cmd_fifo_rd_data(tb_if.cmd_fifo_rd_data),
        .cmd_fifo_rd_en(tb_if.cmd_fifo_rd_en),
        .cmd_fifo_valid(tb_if.cmd_fifo_valid),

        // uart_tx --->
        .tx_data(tb_if.tx_data)
    );


    // Clock generation
    localparam time CLK_PERIOD = 10ns;  // 100 MHz

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset generation
    initial begin
        rst = 0;
        #100;        // hold reset low for 100ns
        rst = 1;
    end

endmodule