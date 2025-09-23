import cmd_pkg::*;

class cmd_gather_driver extends uvm_driver;

    virtual cmd_gather_if vif;
    common_cfg cfg;
    mailbox #(cmd_gather_transaction) seq_mb;


    function new(virtual cmd_gather_if vif,  common_cfg cfg, mailbox #(cmd_gather_transaction) seq_mb);
        this.vif = vif;
        this.seq_mb = seq_mb;
        this.cfg = cfg;
    endfunction


    task start();

        vif.uart_rx_in = 1'b1; // idle state
        @(posedge vif.baud_tick);
        #(cfg.driver_start_delay);
    

        for (genvar i = 0; i < cfg.num_sequences; i++) begin
            seq_mb.get(cmd_trans);
            drive_transaction(cmd_trans);
        end

    endtask;

    task drive_transaction(cmd_gather_transaction cmd_trans);

        int i;
        int j;
        logic [9:0] data_to_send;


        for (i=0; i<cfg.uart_num_of_byte; i++) begin

            // first cmd_type, then cmd_addr, then cmd_data
            data_to_send[7:0] = (i == 0) ? cmd_trans.cmd_type : ((i == 1) ? cmd_trans.cmd_addr : cmd_trans.cmd_data);
            data_to_send[0] = 1'b0; // start bit
            data_to_send[9] = 1'b1; // stop bit

            for (j=0; j<cfg.uart_num_of_bits_tx;j++) begin
                @(posedge vif.baud_tick);
                vif.uart_rx_in = data_to_send[j];
            end
            
            vif.uart_rx_in = 1'b1; // idle state between bytes
            #(cfg.driver_send_delay);
        end 
    endtask

endclass