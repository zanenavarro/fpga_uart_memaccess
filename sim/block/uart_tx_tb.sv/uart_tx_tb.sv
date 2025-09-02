module uart_tx_tb;

  // Clock and reset signals
  logic clk;
  logic rst;

  // ---> cmd_dispatcher

  // cmd_dispatcher ---> resp_fifo

  // resp_fifo  ---> uart_tx

  // uart_tx --->
  logic tx_data;
  logic tx_valid;
  logic tx_ready;



  // Instantiate the UART TX module
  uart_tx uart_tx_inst (
      .clk(clk),
      .rst(rst),
      .tx_data(tx_data),
      .tx_valid(tx_valid),
      .tx_ready(tx_ready)
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