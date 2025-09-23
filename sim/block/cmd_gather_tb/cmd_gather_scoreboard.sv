class cmd_gather_scoreboard extends uvm_scoreboard;

    mailbox #(cmd_gather_transaction) golden_mb;
    mailbox #(cmd_gather_transaction) mon_out_mb;

    cmd_gather_transaction golden_trans;
    cmd_gather_transaction mon_out_trans;
    common_cfg cfg;


    function new(common_cfg cfg, mailbox #(cmd_gather_transaction) golden_mb, mailbox #(cmd_gather_transaction) mon_out_mb);
        this.golden_mb = golden_mb;
        this.mon_out_mb = mon_out_mb;
        this.cfg = cfg;
    endfunction


    task start();
        forever begin
            if (mon_out_mb.num() > 0 && golden_mb.num() > 0) begin
                mon_out_mb.get(mon_out_trans);
                golden_mb.get(golden_trans);


                if (mon_out_trans != golden_trans) begin
                    $error("cmd_gather_scoreboard: Mismatch: Expected: cmd_type=%0h, cmd_addr=%0h, cmd_data=%0h but RECEIVED: cmd_type=%0h, cmd_addr=%0h, cmd_data=%0h",
                             golden_trans.cmd_type, golden_trans.cmd_addr, golden_trans.cmd_data,
                             mon_out_trans.cmd_type, mon_out_trans.cmd_addr, mon_out_trans.cmd_data);
                end

                else begin
                    $display("cmd_gather_scoreboard: Match: cmd_type=%0h, cmd_addr=%0h, cmd_data=%0h",
                             mon_out_trans.cmd_type, mon_out_trans.cmd_addr, mon_out_trans.cmd_data);
                end
            end
        end
    endtask;



endclass
