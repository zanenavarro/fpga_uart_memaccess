

import cmd_pkg::*;
class cmd_gather_agent extends uvm_agent;

    virtual cmd_gather_if vif;
    cmd_gather_driver driver;
    cmd_gather_monitor monitor;


    // mailboxes
    mailbox #(cmd_packet_t) seq_mb;
    mailbox #(cmd_packet_t) golden_mb;
    mailbox #(cmd_packet_t) mon_out_mb;


    // constructor passing virtual interface to driver and monitors.
    function new(virtual cmd_gather_if vif);
        this.vif = vif;
        driver = new(vif, seq_mb);
        monitor = new(vif);
        sequencer = new(seq_mb, golden_mb);
    endfunction

    function start();
        driver.start();
        monitor.start();
    endfunction;

endclass