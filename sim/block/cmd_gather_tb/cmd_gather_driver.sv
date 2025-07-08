class cmd_uart_driver extends uvm_driver #(cmd_packet_item);

    `uvm_component_utils(cmd_uart_driver)

    // UART interface signals
    virtual uart_if uart_if;

    // Constructor
    function new(string name = "cmd_uart_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Main task to drive commands
    task run_phase(uvm_phase phase);
        cmd_packet_item pkt;
        forever begin
            // Wait for a command item to be available
            seq_item_port.get_next_item(pkt);

            `uvm_info(get_type_name(), $sformatf("Driving cmd: %s", pkt.convert2string()), UVM_MEDIUM);

            // Pack the command into UART bits
            pkt.pack_uart_bits();

            // Send bits one by one on baud_tick
            for (int i = 0; i < pkt.uart_bits.size(); i++) begin
                @(posedge uart_if.baud_tick);
                uart_if.rx <= pkt.uart_bits[i];
            end

            // back to idle
            @(posedge uart_if.baud_tick);
            uart_if.rx <= 1'b1;

            // Indicate that the item has been processed
            seq_item_port.item_done();
        end
    endtask
enclass