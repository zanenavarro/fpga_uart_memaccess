

import cmd_pkg::*;
class cmd_gather_agent extends uvm_agent;

    virtual cmd_gather_if vif;
    cmd_gather_driver driver;
    cmd_gather_monitor monitor;

    // constructor passing virtual interface to driver and monitors.
    function new(virtual cmd_gather_if vif);
        this.vif = vif;
        driver = new(vif);
        monitor = new(vif);
    endfunction

    function start();
        driver.start();
        monitor.start();
    endfunction;

endclass