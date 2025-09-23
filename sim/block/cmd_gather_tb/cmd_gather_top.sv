module cmd_gather_top();

    // Clock and reset signals
    logic clk;
    logic rst;

    ///////////////////////////////////
    ////////////// BAUD RATE GENERATOR
    baud_tick_gen baud_tick1 (
        .clk(clk),
        .rst(rst),
        .baud_rate(115200),
        .baud_tick(tb_if.baud_tick)
    );

    baud_tick_gen baud_tick2 (
        .clk(clk),
        .rst(rst),
        .baud_rate(57600),
        .baud_tick(tb_if.baud_half_tick)
    );
    /////////////////////////////////


    cmd_gather_if tb_if(clk, rst);
    
    // instantiate agent

    cmd_gather_agent agent (
        .clk(clk),
        .rst(rst),
        .cmd_gather_if(tb_if)
    );

    
    // instantiate the DUT
    cmd_gather_tlb cmd_gather (
        .clk(clk),
        .rst(rst),

        // ---> uart_rx
        .uart_rx_in(tb_if.uart_rx_in),
        .baud_half_tick(tb_if.baud_half_tick),
        .baud_tick(tb_if.baud_tick),

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

        agent = new(tb_if);
        agent.start();
    end


endmodule