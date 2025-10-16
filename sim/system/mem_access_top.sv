module mem_access_top();

    logic clk;
    logic rst;


    // instantiate interface
    mem_access_if tb_if(clk, rst);

    // instantiate agent

    mem_access_agent agent;


    // instantiate top level block
    mem_access_tlb mem_access (
        .clk(clk),
        .rst(rst),
        .tx(tb_if.tx),
        .tx_en(tb_if.tx_en),
        .rx(tb_if.rx),
        .baud_tick(tb_if.baud_tick),
        .baud_half_tick(tb_if.baud_half_tick)
    );

    // instantiate baud_tick
    baud_tick_gen baud_tick1 (
        .clk(clk),
        .rst(rst),
        .baud_rate(115200),
        .baud_tick(tb_if.baud_tick)
    );

    baud_tick_gen baud_tick2 (
        .clk(clk),
        .rst(rst),
        .baud_rate(230400),
        .baud_tick(tb_if.baud_half_tick)
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

        $display("Starting MEM_ACCESS Top-level Simulation");

    end


    task backdoor_reg(mem_access_agent agent);
        integer i;
        foreach (mem_access.ram.regs[i]) mem_access.ram.regs[i] = agent.mem[i];
    endtask



endmodule