module uart_tx_tlb (

    // Clock and reset signals
    input logic clk,
    input logic rst,

    // ---> cmd_dispatcher
    input cmd_packet_t cmd_fifo_rd_data,
    input logic        cmd_fifo_rd_en,
    input logic        cmd_fifo_valid,

    // uart_tx --->
    output logic tx_data
);
    
    // cmd_dispatch <--> register
    logic        reg_read_en;
    logic        reg_write_en;
    logic [7:0]  reg_read_data;
    logic [7:0]  reg_write_data;
    logic [7:0]  reg_addr;

    // cmd_dispatcher ---> resp_fifo
    cmd_packet_t resp_fifo_wr_data;
    logic        resp_fifo_wr_en;

    // resp_fifo  ---> uart_tx
    cmd_packet_t resp_fifo_rd_data;
    logic        resp_fifo_rd_en;
    logic        resp_fifo_valid;


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

        // output to register file //
        // write
        .mem_addr(reg_addr),
        .mem_write_en(reg_write_en),
        .mem_write_data(reg_write_data),

        // read
        .mem_read_en(reg_read_en),
        .mem_read_data(reg_read_data),

        // output to RESP FIFO
        .data_out_tx(resp_fifo_wr_data),
        .out_tx_en(resp_fifo_wr_en)
    );
    /////////////////////////////////


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



    /////////////////////////////////
    ///////////////////// RESP_FIFO
    resp_fifo #(
        .DEPTH(16),
        .ADDR_WIDTH($clog2(16))
    ) resp_fifo (
        // input
        .clk(clk),
        .rst(rst),

        .wr_en(resp_fifo_wr_en),
        .wr_data(resp_fifo_wr_data),
        .rd_en(resp_fifo_rd_en),

        // output
        .rd_data(resp_fifo_rd_data),
        .valid(resp_fifo_valid),
        .full(),
        .empty()
    );
    /////////////////////////////////

    /////////////////////////////////
    ///////////////////// UART_TX

    uart_tx uart_tx (
        // input
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .cmd_rsp(resp_fifo_rd_data),
        .data_ready(resp_fifo_valid),
        .data_read_en(resp_fifo_rd_en),

        // output
        .tx(tx_data)
    );
    /////////////////////////////////


    /////////////////////////////////
    ////////////// BAUD RATE GENERATOR
    logic baud_tick;

    baud_tick_gen baud_tick1 (
        .clk(clk),
        .rst(rst),
        .baud_rate(115200),
        .baud_tick(baud_tick)
    );
    /////////////////////////////////


endmodule