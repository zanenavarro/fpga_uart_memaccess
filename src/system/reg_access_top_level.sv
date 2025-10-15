module uart_bridge_top(
    input wire clk,
    input wire rst,
    input wire uart_rx,
    output wire uart_tx,
    output reg  led_captured,
    output reg  led_reset,
    output reg uart_idle,
    output reg uart_start,
    output reg uart_data
);  
    logic baud_tick;
    logic baud_half_tick;

    logic rx_idle;
    logic rx_start;
    logic rx_data;
    
    // instantiate top level block
    reg_access_tlb reg_access (
        .clk(clk),
        .rst(rst),
        .tx(uart_tx),
        .tx_en(),
        .rx(uart_rx),
        .baud_tick(baud_tick),
        .baud_half_tick(baud_half_tick),
        .rx_idle(rx_idle),
        .rx_start(rx_start),
        .rx_data(rx_data)
    );

    // instantiate baud_tick
    baud_tick_gen baud_tick1 (
        .clk(clk),
        .rst(rst),
        .baud_rate(115200),
        .baud_tick(baud_tick)
    );

    baud_tick_gen baud_tick2 (
        .clk(clk),
        .rst(rst),
        .baud_rate(230400),
        .baud_tick(baud_half_tick)
    );

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            led_captured <= 0;
            led_reset    <= 1;
            uart_idle    <= 0;
            uart_start   <= 0;
            uart_data    <= 0;
        end else begin
            led_reset <= 0;
            if (reg_access.sampled_byte_valid == 1) begin
                led_captured <= 1; 
            end
            if (rx_idle == 1) begin
                uart_idle <= 1;
            end 
            if (rx_start == 1) begin
                uart_start <= 1;
            end
            if (rx_data == 1) begin
                uart_data <= 1;
            end
        end
    end


endmodule