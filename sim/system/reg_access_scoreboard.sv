class reg_access_scoreboard extends uvm_scoreboard;

    virtual reg_access_if vif;


    mailbox #(reg_access_transaction) golden_mb;
    mailbox #(reg_access_transaction) mon_out_mb;

    reg_access_transaction golden_trans;
    reg_access_transaction mon_out_trans;
    common_cfg cfg;


    function new(virtual reg_access_if vif, common_cfg cfg, mailbox #(reg_access_transaction) golden_mb, mailbox #(reg_access_transaction) mon_out_mb);
        this.vif = vif;
        this.golden_mb = golden_mb;
        this.mon_out_mb = mon_out_mb;
        this.cfg = cfg;
    endfunction


    task start();
        forever begin
            @(posedge vif.clk);
            if (mon_out_mb.num() > 0 && golden_mb.num() > 0) begin
                mon_out_mb.get(mon_out_trans);
                golden_mb.get(golden_trans);


                if (is_mismatch(golden_trans, mon_out_trans)) begin
                    $error("reg_access_scoreboard: Mismatch: Expected: cmd_type=%0h, cmd_addr=%0h, cmd_data=%0h but RECEIVED: cmd_type=%0h, cmd_addr=%0h, cmd_data=%0h",
                             golden_trans.cmd_type, golden_trans.addr, golden_trans.data,
                             mon_out_trans.cmd_type, mon_out_trans.addr, mon_out_trans.data);
                end

                else begin
                    $display("reg_access_scoreboard: Match: cmd_type=%0h, addr=%0h, data=%0h",
                             mon_out_trans.cmd_type, mon_out_trans.addr, mon_out_trans.data);
                end
            end
        end
    endtask;

    function bit is_mismatch(reg_access_transaction golden, reg_access_transaction mon_out);
        if ( (golden.cmd_type !== mon_out.cmd_type) ||
             (golden.addr !== mon_out.addr) ||
             (golden.data !== mon_out.data) ) begin
            return 1;
        end else begin
            return 0;
        end
    endfunction



endclass
