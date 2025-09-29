class cmd_execute_agent;

    common_cfg  cfg;
    virtual cmd_execute_if vif;
    cmd_execute_driver driver;
    cmd_execute_monitor monitor;
    cmd_execute_sequencer sequencer;
    cmd_execute_scoreboard scoreboard;

    logic [7:0] mem [0:255] ; // simple memory model for scoreboard comparison

    // mailbox declarations
    mailbox #(cmd_execute_transaction) seq_mb;
    mailbox #(cmd_execute_transaction) golden_mb;
    mailbox #(cmd_execute_transaction) mon_out_mb;



    function new(virtual cmd_execute_if vif);
        cfg = new();
        cfg.randomize();
        this.vif = vif;

        seq_mb = new();
        mon_out_mb = new();
        golden_mb = new();

        
        driver = new(vif, cfg, seq_mb);
        monitor = new(vif, mon_out_mb);
        scoreboard = new(vif, cfg, golden_mb, mon_out_mb);

        foreach (mem[i]) mem[i] = $urandom_range(0,255);
    endfunction


    task start();
        $display("CMD_EXECUTE_AGENT: Starting cmd_gather_agent...");
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
        
    // task populate_mem();
    //     logic [7:0] length_of_mem;
    //     integer i;
    //     reg_access_entry reg_entry;

    //     length_of_mem = 256;
    //     for(i=0; i < length_of_mem; i++) begin

    //         reg_entry = new();
    //         reg_entry.randomize();
    //         $display("CMD_EXECUTE_AGENT: populating index=%d /w data=%b...", i, reg_entry.data);

    //         this.mem[i] = reg_entry.data;
    //     end

    // endtask

    task backdoor_reg();
        // use randomly populated mem to populate register bank
        integer reg_addr;

        for (reg_addr = 0; reg_addr < 256; reg_addr ++) begin
            @(posedge vif.clk);
            vif.reg_addr = reg_addr;
            vif.reg_write_en = 1;
            vif.reg_write_data = mem[reg_addr];
        end

        vif.reg_write_en = 0;

    endtask

    task reg_init();
        populate_mem();
        // backdoor_reg();
    endtask






endclass