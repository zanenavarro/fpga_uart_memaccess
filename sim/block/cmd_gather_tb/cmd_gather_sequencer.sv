class cmd_gather_sequencer extends uvm_sequencer #(cmd_gather_transaction);

    common_cfg cfg;
    cmd_gather_transaction cmd_trans;

    mailbox #(cmd_gather_transaction) seq_mb;
    mailbox #(cmd_gather_transaction) golden_mb;

    function new(mailbox #(cmd_gather_transaction) seq_mb, mailbox #(cmd_gather_transaction) golden_mb, string name="cmd_gather_sequencer");
        super.new(name);
        this.seq_mb = seq_mb;
        this.golden_mb = golden_mb;
    endfunction

    task start();
        int i;

        for (i=0; i<cfg.num_sequences; i++) begin
            cmd_trans = new();

            seq_mb.put(cmd_trans);
            golden_mb.put(cmd_trans);
        end
    endtask;

endclass

