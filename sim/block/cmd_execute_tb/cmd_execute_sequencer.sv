class cmd_execute_sequencer extends uvm_sequencer;

    common_cfg cfg;
    cmd_execute_transaction cmd_trans;

    mailbox #(cmd_execute_transaction) seq_mb;
    mailbox #(cmd_execute_transaction) golden_mb;
    logic [7:0] mem [0:255];


    function new(common_cfg cfg, mailbox #(cmd_execute_transaction) seq_mb, mailbox #(cmd_execute_transaction) golden_mb, logic [7:0] mem [0:255], string name="cmd_gather_sequencer");
        this.cfg = cfg;
        this.seq_mb = seq_mb;
        this.golden_mb = golden_mb;
        this.mem = mem;

    endfunction

    task start();
        int i;
        $display("CMD_EXECUTE_SEQUENCER: Starting cmd_execute_sequencer...");
        for (i=0; i<cfg.num_sequences; i++) begin
            cmd_trans = new();
            cmd_trans.randomize();

            $display("CMD_GATHER_SEQUENCER: Generating cmd_transaction: cmd_type=%0h, addr=%0h, data=%0h",
                     cmd_trans.cmd_type,
                     cmd_trans.addr,
                     cmd_trans.data);

            seq_mb.put(cmd_trans);
            add_to_golden_mb(cmd_trans);

        end
    endtask;


    task add_to_golden_mb(cmd_execute_transaction cmd_trans);

        case (cmd_trans.cmd_type)
            
            // READ
            2'b00: begin
                // read directly from environment
                cmd_trans.data = mem[cmd_trans.addr];
            end

            // WRITE
            2'b01: begin
                mem[cmd_trans.addr] = cmd_trans.data;
            end

            // MODIFY 
            2'b10: begin
                // read directly from environment
                cmd_trans.data = mem[cmd_trans.addr];
            end

        endcase

        golden_mb.put(cmd_trans);
        $display("CMD_GATHER_SEQUENCER: Adding to GOLDEN_MODEL: cmd_type=%0h, addr=%0h, data=%0h",
            cmd_trans.cmd_type,
            cmd_trans.addr,
            cmd_trans.data);

    endtask

endclass

