

class cmd_gather_transaction extend uvm_sequence_itm;


    rand logic [1:0] cmd_type;  // e.g. 00=READ, 01=WRITE, 10=MODIFY
    rand logic [7:0] addr;
    rand logic [7:0] data;

    constraint cmd_type_c { cmd_type inside {[0:2]}; };


    function print_string();
        $sformat(uvm_report_info, "CMD_GATHER_TRANSACTION", $sformatf("CMD_TYPE: %0d, ADDR: 0x%0h, DATA: 0x%0h", cmd_type, addr, data));
    endfunction


endclass