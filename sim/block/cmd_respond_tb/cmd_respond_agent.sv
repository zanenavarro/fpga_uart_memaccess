class cmd_respond_agent;

    common_cfg  cfg;
    virtual cmd_respond_if vif;
    cmd_respond_driver driver;
    cmd_respond_monitor monitor;
    cmd_respond_sequencer sequencer;
    cmd_respond_scoreboard scoreboard;

    logic [7:0] mem [0:255] ; // simple memory model for scoreboard comparison

    // mailbox declarations
    mailbox #(cmd_respond_transaction) seq_mb;
    mailbox #(cmd_respond_transaction) golden_mb;
    mailbox #(cmd_respond_transaction) mon_out_mb;



    function new(virtual cmd_respond_if vif);
        cfg = new();
        cfg.randomize();
        this.vif = vif;

        seq_mb = new();
        mon_out_mb = new();
        golden_mb = new();

        
        driver = new(vif, cfg, seq_mb);
        monitor = new(vif, mon_out_mb, cfg);
        scoreboard = new(vif, cfg, golden_mb, mon_out_mb);

        foreach (mem[i]) mem[i] = $urandom_range(0,255);
    endfunction


    task start();
        $display("cmd_respond_AGENT: Starting cmd_gather_agent...");
        sequencer = new(cfg, seq_mb, golden_mb, mem);
        sequencer.start();
        #50;

        fork
            driver.start();
            monitor.start();  
            scoreboard.start();  
        join

    endtask

    task populate_mem();
        foreach (mem[i]) mem[i] = $urandom_range(0,255);
    endtask 
        

    task reg_init();
        populate_mem();
    endtask


endclass