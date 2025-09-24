class cmd_gather_agent;

    virtual cmd_gather_if vif;
    cmd_gather_driver driver;
    cmd_gather_monitor monitor;
    cmd_gather_sequencer sequencer;
    common_cfg cfg;


    // mailboxes
    mailbox #(cmd_gather_transaction) seq_mb;
    mailbox #(cmd_gather_transaction) golden_mb;
    mailbox #(cmd_gather_transaction) mon_out_mb;


    // constructor passing virtual interface to driver and monitors.
    function new(virtual cmd_gather_if vif);
        cfg = new();
        cfg.randomize();
        seq_mb = new();
        golden_mb = new();
        mon_out_mb = new();
        
        this.vif = vif;
        driver = new(vif, cfg, seq_mb);
        monitor = new(vif, cfg, mon_out_mb);
        sequencer = new(cfg, seq_mb, golden_mb);
    endfunction

    task start();
        $display("CMD_GATHER_AGENT: Starting cmd_gather_agent...");
        sequencer.start();

        #50;
        driver.start();
        monitor.start();
    endtask;

endclass