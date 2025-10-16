class mem_access_sequencer extends uvm_sequencer;

    common_cfg cfg;
    mem_access_transaction cmd_trans;

    mailbox #(mem_access_transaction) seq_mb;
    mailbox #(mem_access_transaction) golden_mb;
    logic [7:0] mem [0:255];


    function new(common_cfg cfg, mailbox #(mem_access_transaction) seq_mb, mailbox #(mem_access_transaction) golden_mb, logic [7:0] mem [0:255], string name="cmd_gather_sequencer");
        this.cfg = cfg;
        this.seq_mb = seq_mb;
        this.golden_mb = golden_mb;
        this.mem = mem;

    endfunction

    task start();
        int i;
        $display("MEM_ACCESS_SEQUENCER: Starting mem_access_sequencer...");
        for (i=0; i<cfg.num_sequences; i++) begin
            cmd_trans = new();
            cmd_trans.randomize();

            $display("MEM_ACCESS_SEQUENCER: Generating cmd_transaction: cmd_type=%0h, addr=%0h, data=%0h",
                     cmd_trans.cmd_type,
                     cmd_trans.addr,
                     cmd_trans.data);

            seq_mb.put(cmd_trans);
            add_to_golden_mb(cmd_trans);

        end
    endtask;


    task add_to_golden_mb(mem_access_transaction cmd_trans);

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
        $display("MEM_ACCESS_SEQUENCER: Adding to GOLDEN_MODEL: cmd_type=%0h, addr=%0h, data=%0h",
            cmd_trans.cmd_type,
            cmd_trans.addr,
            cmd_trans.data);

    endtask

endclass

