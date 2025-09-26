
class cmd_gather_driver extends uvm_driver;

    virtual cmd_gather_if vif;
    common_cfg cfg;
    cmd_gather_transaction cmd_trans;
    mailbox #(cmd_gather_transaction) seq_mb;


    function new(virtual cmd_gather_if vif,  common_cfg cfg, mailbox #(cmd_gather_transaction) seq_mb);
        this.vif = vif;
        this.seq_mb = seq_mb;
        this.cfg = cfg;
    endfunction


    task start();
        int i;
        $display("CMD_GATHER_DRIVER: Starting cmd_gather_driver...");

        vif.uart_rx_in <= 1'b1; // idle state
        @(posedge vif.baud_tick);
    
        for (i = 0; i < cfg.num_sequences; i++) begin
            seq_mb.get(cmd_trans);
            @(posedge vif.baud_tick);
            drive_transaction(cmd_trans);
            @(posedge vif.baud_tick);

        end

    endtask;

    task drive_transaction(cmd_gather_transaction cmd_trans);
        integer i;
        integer j;
        logic [9:0] data_to_send;

        $display("CMD_GATHER_DRIVER: Driving cmd_transaction into DUT: cmd_type=%0h, addr=%0h, data=%0h",
            cmd_trans.cmd_type,
            cmd_trans.addr,
            cmd_trans.data);


        // @(posedge vif.baud_tick);
        for (i=0; i<cfg.uart_num_of_byte; i++) begin
        

            // first cmd_type, then cmd_addr, then cmd_data
            data_to_send[8:1] = (i == 0) ? cmd_trans.cmd_type : ((i == 1) ? cmd_trans.addr : cmd_trans.data);
            data_to_send[0] = 1'b0; // start bit
            data_to_send[9] = 1'b1; // stop bit

            $display("CMD_GATHER_DRIVER: Sending byte %0d: 0x%0h", i, data_to_send[8:1]);

            for (j=0; j<cfg.uart_num_of_bits_tx;j++) begin
                @(posedge vif.baud_tick);
                vif.uart_rx_in <= data_to_send[j];
            end
            
            @(posedge vif.baud_tick);
        end 
    endtask

endclass