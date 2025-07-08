class cmd_packet_item extends uvm_sequence_item;

    // --------------------------------------------
    // Core payload fields
    rand bit [1:0]  cmd_type;
    rand bit [7:0]  addr;
    rand bit [7:0]  data;

    // --------------------------------------------
    // UART transmission representation (bits with framing)
    bit [29:0] uart_bits;

    `uvm_object_utils(cmd_packet_item)

    function new(string name = "cmd_packet_item");
        super.new(name);
    endfunction

    // --------------------------------------------
    // Pack with start/stop bits: {stop, data, start} x 3
    function void pack_uart_bits();
        uart_bits = {
        1'b1, data, 1'b0,     // Byte 3
        1'b1, addr, 1'b0,     // Byte 2
        1'b1, {6'b0, cmd_type}, 1'b0  // Byte 1 (2-bit cmd_type padded to 8 bits)
        };
    endfunction

    // Optionally unpack (e.g., monitor receiving 30 bits)
    function void unpack_uart_bits(bit [29:0] bits);
        uart_bits = bits;

        data     = uart_bits[28:21];
        addr     = uart_bits[18:11];
        cmd_type = uart_bits[8:7];  // assuming cmd_type was stored in upper bits of 8-bit frame
    endfunction

    // --------------------------------------------
    // Print nicely
    function string convert2string();
        return $sformatf("[CMD=%0d ADDR=0x%02h DATA=0x%02h UART=0x%08h]",
                        cmd_type, addr, data, uart_bits);
    endfunction

endclass
