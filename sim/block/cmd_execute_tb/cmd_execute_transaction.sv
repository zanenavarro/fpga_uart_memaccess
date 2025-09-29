class cmd_execute_transaction extends uvm_sequence_itm;
    function print_fields();
        $display("CMD_EXECUTE_TRANSACTION: ", $sformatf("CMD_TYPE: %0d, ADDR: 0x%0h, DATA: 0x%0h", cmd_type, addr, data));
    endfunction
endclass