
module cmd_execute_tb;

    // clocks
    logic        clk;
    logic        rst;

    // ---> cmd_parser
    logic        byte_fifo_valid;
    logic [7:0]  byte_fifo_data;
    logic        byte_fifo_rd_en;
 

    // cmd parser --> cmd_fifo
    cmd_packet_t cmd_fifo_wr_data;
    logic        cmd_fifo_wr_en;

    // cmd_fifo --> cmd_dispatch
    cmd_packet_t cmd_fifo_rd_data;
    logic        cmd_fifo_rd_en;

    logic        cmd_fifo_valid;
    logic        cmd_fifo_full;
    logic        cmd_fifo_empty;

    // cmd_dispatch <--> register
    logic        reg_read_en;
    logic        reg_write_en;
    logic [7:0]  reg_read_data;
    logic [7:0]  reg_write_data;
    logic [7:0]  reg_addr;


    /////////////////////////////////
    ///////////////////// CMD_PARSER
    cmd_parser cmd_parser (
        .clk(clk),
        .rst(rst),

        // Byte FIFO interface (from uart_rx)
        .byte_fifo_valid(byte_fifo_valid),
        .byte_fifo_data(byte_fifo_data),
        .byte_fifo_rd_en(byte_fifo_rd_en),

        // Command FIFO interface
        .cmd_fifo_wr_en(cmd_fifo_wr_en),
        .cmd_fifo_wr_data(cmd_fifo_wr_data)
        );
    /////////////////////////////////


    /////////////////////////////////
    ///////////////////// CMD_FIFO
    cmd_fifo #(
        .DEPTH(16),
        .ADDR_WIDTH($clog2(16))
    ) cmd_fifo (
        // input
        .clk(clk),
        .rst(rst),

        .wr_en(cmd_fifo_wr_en),
        .wr_data(cmd_fifo_wr_data),

        .rd_en(cmd_fifo_rd_en),

        // output
        .rd_data(cmd_fifo_rd_data),
        .valid(cmd_fifo_valid),
        .full(cmd_fifo_full),
        .empty(cmd_fifo_empty)
    );
    /////////////////////////////////


    /////////////////////////////////
    ///////////////////// CMD_DISPATCH
    cmd_dispatcher cmd_dispatch (
        .clk(clk),
        .rst(rst),

        // input from cmd_fifo
        .cmd_rd_data(cmd_fifo_rd_data),
        .cmd_valid(cmd_fifo_valid),

        //output
        .cmd_rd_en(cmd_fifo_rd_en),
        .mem_addr(reg_addr),

        // output to register file //
        // write
        .mem_write_en(reg_write_en),
        .mem_write_data(reg_write_data),

        // read
        .mem_read_en(reg_read_en),
        .mem_read_data(reg_read_data),
        //////////////////////////////


        // output to RESP FIFO
        .data_out_tx(data_out_tx),
        .out_tx_en(out_tx_en)
    );

    /////////////////////////////////
    ///////////////////// REGISTER

    register_bank register_bank(
        //input
        .clk(clk),
        .write_en(reg_write_en),
        .read_strobe(reg_read_en),
        .addr(reg_addr),
        .write_data(reg_write_data),

        //output
        .read_data(reg_read_data)
    );
    /////////////////////////////////

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