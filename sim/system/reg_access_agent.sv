class reg_access_agent;

    common_cfg  cfg;
    virtual reg_access_if vif;
    reg_access_driver driver;
    reg_access_monitor monitor;
    reg_access_sequencer sequencer;
    reg_access_scoreboard scoreboard;

    logic [7:0] mem [0:255] ; // simple memory model for scoreboard comparison

    // mailbox declarations
    mailbox #(reg_access_transaction) seq_mb;
    mailbox #(reg_access_transaction) golden_mb;
    mailbox #(reg_access_transaction) mon_out_mb;



    function new(virtual reg_access_if vif);
        cfg = new();
        cfg.randomize();
        this.vif = vif;

        seq_mb = new();
        mon_out_mb = new();
        golden_mb = new();

        
        driver = new(vif, cfg, seq_mb);
        monitor = new(vif, cfg, mon_out_mb);
        scoreboard = new(vif, cfg, golden_mb, mon_out_mb);

        foreach (mem[i]) mem[i] = $urandom_range(0,255);
    endfunction


    task start();
        $display("REG_ACCESS_AGENT: Starting cmd_gather_agent...");
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
        // backdoor_reg();
    endtask






endclass