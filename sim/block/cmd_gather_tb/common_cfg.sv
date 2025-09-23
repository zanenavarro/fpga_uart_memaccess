class common_cfg;


    // driver params
    rand logic [5:0] driver_start_delay;
    rand logic [5:0] driver_send_delay;

    constraint driver_send_delay_c {driver_send_delay inside {[10:20]};};


    // sequencer params


    // agent config


    // monitor config

    // scoreboard config

    // uart config
    localparam int uart_num_of_byte = 3; // command packet size in bytes
    localparam int uart_num_of_bits_tx = 10; // 1 start, 8 data, 1 stop


    // test sequences
    rand logic [5:0] num_sequences;
    constraint num_sequences_c {num_sequences inside {[1:10]};};



endclass;
