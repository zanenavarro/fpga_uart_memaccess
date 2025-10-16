
class mem_access_monitor extends uvm_monitor;

    virtual mem_access_if vif;
    mailbox #(mem_access_transaction) mon_out_mb;

    common_cfg cfg;


    function new(virtual mem_access_if vif, common_cfg cfg, mailbox #(mem_access_transaction) mon_out_mb);
        this.vif = vif;
        this.mon_out_mb = mon_out_mb;
        this.cfg = cfg;
    endfunction

    task start();
        integer bit_count;
        logic [29:0] full_uart_tx;
        integer num_sequences;

        mem_access_transaction cmd_trans_out;
        $display("MEM_ACCESS_MONITOR: Starting mem_access_monitor...");

        bit_count = 0;
        full_uart_tx = '0;
        num_sequences = 0;

        forever begin
            @(posedge vif.baud_tick)
            @(posedge vif.clk)
            @(negedge vif.clk)
            
            if (vif.tx_en == 1) begin
                if (num_sequences != cfg.num_sequences) begin

                    // shift into tx
                    full_uart_tx = {vif.tx, full_uart_tx[29:1]};
                    bit_count = bit_count + 1;
                    
                    // sample complete, add to mailbox
                    if (bit_count == 30) begin


                        // checks on start bits
                        if (full_uart_tx[0] == 0 && full_uart_tx[10] == 0 & full_uart_tx[20] == 0) begin
                            $display("MEM_ACCESS_MONITOR: START BITS ARE CORRECT.");
                        end else begin
                            $display("MEM_ACCESS_MONITOR ERROR: START BITS ARE NOT CORRECT. cmd_type_start=%0h addr_start=%0h data_start=%0h",
                                full_uart_tx[0],
                                full_uart_tx[10],
                                full_uart_tx[20]);
                        end

                        // checks on stop bits
                        if (full_uart_tx[9] == 1 && full_uart_tx[19] == 1 & full_uart_tx[29] == 1) begin
                            $display("MEM_ACCESS_MONITOR: STOP BITS ARE CORRECT.");
                        end else begin
                            $display("MEM_ACCESS_MONITOR ERROR: STOP BITS ARE NOT CORRECT.");
                        end

                        cmd_trans_out = new();
                        
                        cmd_trans_out.cmd_type = full_uart_tx[8:1];
                        cmd_trans_out.addr = full_uart_tx[18:11];
                        cmd_trans_out.data = full_uart_tx[28:21];

                        $display("MEM_ACCESS_MONITOR: Received cmd_transaction from DUT: cmd_type=%0h, addr=%0h, data=%0h",
                            cmd_trans_out.cmd_type,
                            cmd_trans_out.addr,
                            cmd_trans_out.data);

                        mon_out_mb.put(cmd_trans_out);
                        full_uart_tx = '0;
                        bit_count = 0;
                        num_sequences = num_sequences + 1;

                    end

                end else begin
                    break;
                end
            end
        end
    endtask

endclass