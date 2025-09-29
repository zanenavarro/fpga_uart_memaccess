class cmd_execute_monitor extends uvm_monitor;

    virtual cmd_execute_if vif;
    mailbox #(cmd_execute_transaction) mon_out_mb;


    function new(virtual cmd_execute_if vif, mailbox #(cmd_execute_transaction) mon_out_mb);
        this.vif = vif;
        this.mon_out_mb = mon_out_mb;
    endfunction

    task start();

        cmd_execute_transaction cmd_trans_out;
        $display("CMD_EXECUTE_MONITOR: Starting cmd_execute_monitor...");

        forever begin
            @(posedge vif.cmd_resp_wr_en)
            cmd_trans_out = new();
            $display("CMD_EXECUTE_MONITOR: Received cmd_transaction from DUT: cmd_type=%0h, addr=%0h, data=%0h",
                     vif.cmd_resp_wr_data.cmd_type,
                     vif.cmd_resp_wr_data.addr,
                     vif.cmd_resp_wr_data.data);
            cmd_trans_out.cmd_type = vif.cmd_resp_wr_data.cmd_type;
            cmd_trans_out.addr =  vif.cmd_resp_wr_data.addr;
            cmd_trans_out.data = vif.cmd_resp_wr_data.data;
            mon_out_mb.put(cmd_trans_out);
        end
    endtask

endclass