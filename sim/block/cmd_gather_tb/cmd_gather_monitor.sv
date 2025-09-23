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

        forever begin
            @(posedge vif.cmd_fifo_wr_en);
            mon_out_mb.put(vif.cmd_fifo_wr_data); // add to mailbox for scoreboard
        end

    endtask;




endclass