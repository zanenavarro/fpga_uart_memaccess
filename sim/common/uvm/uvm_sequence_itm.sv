class uvm_sequence_itm;
    rand logic [7:0] cmd_type;  // e.g. 00=READ, 01=WRITE, 10=MODIFY
    rand logic [7:0] addr;
    rand logic [7:0] data;
    // longint unsigned tid;

    constraint cmd_type_c { cmd_type inside {[0:2]}; };

    function print_fields();
        $display("CMD_TRANSACTION: ", $sformatf("CMD_TYPE: %0d, ADDR: 0x%0h, DATA: 0x%0h", cmd_type, addr, data));
    endfunction
endclass