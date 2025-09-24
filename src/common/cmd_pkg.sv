package cmd_pkg;

    typedef struct packed {
        logic [7:0] cmd_type;  // e.g. 00=READ, 01=WRITE, 10=MODIFY
        logic [7:0] addr;
        logic [7:0] data;
    } cmd_packet_t;

endpackage : cmd_pkg
