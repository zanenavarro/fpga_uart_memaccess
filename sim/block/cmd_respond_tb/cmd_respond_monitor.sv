class cmd_respond_monitor extends uvm_monitor;

    virtual cmd_respond_if vif;
    mailbox #(cmd_respond_transaction) mon_out_mb;

    common_cfg cfg;


    function new(virtual cmd_respond_if vif, mailbox #(cmd_respond_transaction) mon_out_mb, common_cfg cfg);
        this.vif = vif;
        this.mon_out_mb = mon_out_mb;
        this.cfg = cfg;
    endfunction

    task start();
        integer bit_count;
        logic [29:0] full_uart_tx;
        integer num_sequences;

        cmd_respond_transaction cmd_trans_out;
        $display("CMD_respond_MONITOR: Starting cmd_respond_monitor...");

        bit_count = 0;
        full_uart_tx = '0;
        num_sequences = 0;

        forever begin
            @(posedge vif.baud_tick)
            @(posedge vif.clk)
            @(negedge vif.clk)
            

            if (num_sequences != cfg.num_sequences) begin
                            // sample complete, add to mailbox
                if (bit_count == 30) begin

                    // checks on start bits
                    if (full_uart_tx[0] == 0 && full_uart_tx[10] == 0 & full_uart_tx[20] == 0) begin
                        $display("CMD_respond_MONITOR: START BITS ARE CORRECT.");
                    end else begin
                        $display("CMD_respond_MONITOR ERROR: START BITS ARE NOT CORRECT. cmd_type_start=%0h addr_start=%0h data_start=%0h",
                            full_uart_tx[0],
                            full_uart_tx[10],
                            full_uart_tx[20]);
                    end

                    // checks on stop bits
                    if (full_uart_tx[9] == 1 && full_uart_tx[19] == 1 & full_uart_tx[29] == 1) begin
                        $display("CMD_respond_MONITOR: STOP BITS ARE CORRECT.");
                    end else begin
                        $display("CMD_respond_MONITOR ERROR: STOP BITS ARE NOT CORRECT.");
                    end

                    cmd_trans_out = new();
                    
                    cmd_trans_out.cmd_type = full_uart_tx[8:1];
                    cmd_trans_out.addr = full_uart_tx[18:11];
                    cmd_trans_out.data = full_uart_tx[28:21];

                    $display("CMD_respond_MONITOR: Received cmd_transaction from DUT: cmd_type=%0h, addr=%0h, data=%0h",
                        cmd_trans_out.cmd_type,
                        cmd_trans_out.addr,
                        cmd_trans_out.data);

                    mon_out_mb.put(cmd_trans_out);
                    full_uart_tx = '0;
                    bit_count = 0;
                    num_sequences = num_sequences + 1;

                end else begin
                    // shift into tx
                    full_uart_tx = {vif.tx_data, full_uart_tx[29:1]};
                    bit_count = bit_count + 1;
                end

            end else begin
                break;
            end
        end
    endtask

endclass