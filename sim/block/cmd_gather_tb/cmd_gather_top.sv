module cmd_gather_top();

    // Clock and reset signals
    logic clk;
    logic rst;


    cmd_gather_if tb_if(clk, rst);
    
    // instantiate agent

    
    // instantiate the DUT
    cmd_gather_tlb cmd_gather (
        .clk(clk),
        .rst(rst),

        // ---> uart_rx
        .uart_rx_in(tb_if.uart_rx_in),

        // cmd_fifo --->
        .cmd_fifo_wr_en(tb_if.cmd_fifo_wr_en),
        .cmd_fifo_wr_data(tb_if.cmd_fifo_wr_data)
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