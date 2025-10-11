
class cmd_respond_driver extends uvm_driver;

    virtual cmd_respond_if vif;
    common_cfg cfg;
    cmd_respond_transaction cmd_trans;
    mailbox #(cmd_respond_transaction) seq_mb;


    function new(virtual cmd_respond_if vif,  common_cfg cfg, mailbox #(cmd_respond_transaction) seq_mb);
        this.vif = vif;
        this.seq_mb = seq_mb;
        this.cfg = cfg;
    endfunction


    task start();
        int i;
        $display("CMD_RESPOND_DRIVER: Starting cmd_respond_driver...");

        @(posedge vif.clk);
        vif.cmd_fifo_valid = 0;

    
        for (i = 0; i < cfg.num_sequences; i++) begin
            seq_mb.get(cmd_trans);
            @(posedge vif.clk);
            drive_transaction(cmd_trans);
            vif.cmd_fifo_valid = 0;
            @(posedge vif.clk);
            @(posedge vif.clk);
            @(posedge vif.clk);
            @(posedge vif.baud_tick);


        end

    endtask;

    task drive_transaction(cmd_respond_transaction cmd_trans);

        integer i;
        integer j;

        @(posedge vif.clk);
        vif.cmd_fifo_valid = 1;
        @(posedge vif.clk)

        // $display("CMD_RESPOND_DRIVER: Received Proper READ_EN SIGNAL");
        // @(posedge vif.clk)

        // transmit cmd_trans
        vif.cmd_fifo_rd_data.cmd_type = cmd_trans.cmd_type;
        vif.cmd_fifo_rd_data.addr = cmd_trans.addr;
        vif.cmd_fifo_rd_data.data = cmd_trans.data;

        $display("CMD_RESPOND_DRIVER: SENDING cmd_transaction into DUT: cmd_type=%0h, addr=%0h, data=%0h",
            cmd_trans.cmd_type,
            cmd_trans.addr,
            cmd_trans.data);

        // if (vif.cmd_fifo_rd_en == 1) begin
        //     $display("CMD_RESPOND_DRIVER: Received Proper READ_EN SIGNAL");
        //     @(posedge vif.clk)

        //     // transmit cmd_trans
        //     vif.cmd_fifo_rd_data.cmd_type = cmd_trans.cmd_type;
        //     vif.cmd_fifo_rd_data.addr = cmd_trans.addr;
        //     vif.cmd_fifo_rd_data.data = cmd_trans.data;

        // end else begin
        //     $display("CMD_RESPOND_DRIVER: ERROR didnt receive proper READ_EN signal.");
        // end
    endtask

endclass