
class cmd_execute_driver extends uvm_driver;

    virtual cmd_execute_if vif;
    common_cfg cfg;
    cmd_execute_transaction cmd_trans;
    mailbox #(cmd_execute_transaction) seq_mb;


    function new(virtual cmd_execute_if vif,  common_cfg cfg, mailbox #(cmd_execute_transaction) seq_mb);
        this.vif = vif;
        this.seq_mb = seq_mb;
        this.cfg = cfg;
    endfunction


    task start();
        int i;
        $display("CMD_GATHER_DRIVER: Starting cmd_gather_driver...");

        @(posedge vif.clk);
    
        for (i = 0; i < cfg.num_sequences; i++) begin
            seq_mb.get(cmd_trans);
            @(posedge vif.clk);
            drive_transaction(cmd_trans);
            @(posedge vif.clk);

        end

    endtask;

    task drive_transaction(cmd_execute_transaction cmd_trans);

        integer i;
        integer j;


        for (j=0; j < cfg.uart_num_of_byte; j++) begin
            logic [7:0] data;
            data = (j == 0) ? cmd_trans.cmd_type : ((j == 1) ? cmd_trans.addr : cmd_trans.data);

            @(posedge vif.clk);

            vif.byte_fifo_valid = 1;
            vif.byte_fifo_data = data;

            @(posedge vif.clk);
            vif.byte_fifo_valid = 0;
            #4;


        end
    endtask

endclass