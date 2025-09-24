class cmd_gather_sequencer extends uvm_sequencer;

    common_cfg cfg;
    cmd_gather_transaction cmd_trans;

    mailbox #(cmd_gather_transaction) seq_mb;
    mailbox #(cmd_gather_transaction) golden_mb;

    function new(common_cfg cfg, mailbox #(cmd_gather_transaction) seq_mb, mailbox #(cmd_gather_transaction) golden_mb, string name="cmd_gather_sequencer");
        this.cfg = cfg;
        this.seq_mb = seq_mb;
        this.golden_mb = golden_mb;
        this.cfg = cfg;
    endfunction

    task start();
        int i;
        $display("CMD_GATHER_SEQUENCER: Starting cmd_gather_sequencer...");
        for (i=0; i<cfg.num_sequences; i++) begin
            cmd_trans = new();
            
            $display("CMD_GATHER_SEQUENCER: Generating cmd_transaction:/n");
            cmd_trans.randomize();
            cmd_trans.print_fields();

            seq_mb.put(cmd_trans);
            golden_mb.put(cmd_trans);
        end
    endtask;

endclass

