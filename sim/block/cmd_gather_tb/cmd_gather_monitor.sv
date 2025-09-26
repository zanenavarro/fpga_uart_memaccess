class cmd_gather_monitor extends uvm_monitor;

    common_cfg cfg;
    virtual cmd_gather_if vif;
    mailbox #(cmd_gather_transaction) mon_out_mb;


    function new(virtual cmd_gather_if vif, common_cfg cfg, mailbox #(cmd_gather_transaction) mon_out_mb);
        this.vif = vif;
        this.mon_out_mb = mon_out_mb;
        this.cfg = cfg;
    endfunction


    task start();
        cmd_gather_transaction cmd_trans_out;
        $display("CMD_GATHER_MONITOR: Starting cmd_gather_monitor...");


        forever begin
            @(posedge vif.cmd_fifo_wr_en);
            cmd_trans_out = new(); 
            $display("CMD_GATHER_MONITOR: Received cmd_transaction from DUT: cmd_type=%0h, addr=%0h, data=%0h",
                     vif.cmd_fifo_wr_data.cmd_type,
                     vif.cmd_fifo_wr_data.addr,
                     vif.cmd_fifo_wr_data.data);
            cmd_trans_out.cmd_type = vif.cmd_fifo_wr_data.cmd_type;
            cmd_trans_out.addr = vif.cmd_fifo_wr_data.addr;
            cmd_trans_out.data = vif.cmd_fifo_wr_data.data;

            mon_out_mb.put(cmd_trans_out); // add to mailbox for scoreboard
        end

    endtask;




endclass