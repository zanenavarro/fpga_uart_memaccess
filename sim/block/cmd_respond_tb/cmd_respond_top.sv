module cmd_respond_top ();

    // Clock and reset signals
    logic clk;
    logic rst;

    /////////////////////////////////
    ////////////// BAUD RATE GENERATOR
    logic baud_tick;

    baud_tick_gen baud_tick1 (
        .clk(clk),
        .rst(rst),
        .baud_rate(115200),
        .baud_tick(tb_if.baud_tick)
    );
    /////////////////////////////////


    // instantiate interface
    cmd_respond_if tb_if(clk, rst);

    // instantiate agent
    cmd_respond_agent agent;

    // instantiate the DUT
    cmd_respond_tlb cmd_respond (
        .clk(clk),
        .rst(rst),

        // ---> cmd_dispatcher
        .cmd_fifo_rd_data(tb_if.cmd_fifo_rd_data),
        .cmd_fifo_rd_en(tb_if.cmd_fifo_rd_en),
        .cmd_fifo_valid(tb_if.cmd_fifo_valid),
        .baud_tick(tb_if.baud_tick),

        // uart_tx --->
        .tx_data(tb_if.tx_data),
        .tx_data_en(tb_if.tx_data_en)
    );


    // Clock generation
    localparam time CLK_PERIOD = 10ns;  // 100 MHz

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset generation
    initial begin
        rst = 1;
        #100;        // hold reset low for 100ns
        rst = 0;
        agent = new(tb_if);
        agent.reg_init();
        backdoor_reg(agent);

        #(350);

        agent.start();

        $display("Starting CMD_RESPOND Top-level Simulation");

    end


    task backdoor_reg(cmd_respond_agent agent);
        integer i;
        foreach (cmd_respond.register_bank.regs[i]) cmd_respond.register_bank.regs[i] = agent.mem[i];
    endtask


endmodule