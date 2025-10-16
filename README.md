# UART FPGA - MEMACCESS

## Overview
This project features **UART communication** between the **Nexys A7 FPGA** and a host PC, reading and writing memory on the fpga with a defined command structure that can be understood by both. It also provides UVM-Lite architecture to verify the full RTL with scoreboarding, agents, drivers and monitors in a **block-level** and **system-level** structure. This repo provides tcl command to build this project to be ran and tested with *Vivado*.

Board Part: ```xc7a50ticsg324-1L```


![alt text](image-1.png)


## Directory Structure
```
---sim
    |_block
    |    |_cmd_gather/
    |    |_cmd_execute/
    |    |_cmd_respond/
    |
    |_common
    |    |_uvm/
    |
    |_system/

---src
    |_block
    |    |_cmd_execute.f
    |    |_cmd_gather.f
    |    |_cmd_respond.f
    |_common
    |    |_cmd_pkg.sv
    |_core
    |    |_cmd_dispatcher.sv
    |    |_cmd_parser.sv
    |    |_ram.sv
    |
    |_fifo
    |    |_byte_fifo.sv
    |    |_cmd_fifo.sv
    |    |_resp_fifo.sv
    |
    |_system
    |    |_mem_access_top_level.sv
    |
    |_uart
         |_baud_tick_gen.sv
         |_uart_rx.sv
         |_uart_tx.sv

```

## Verification Environment Overview
In order to verify this architecture in a way that covers all major points in the design this was first verified as block-level and the blocks are named as such:

```cmd_gather```: 
 - In this particular block the command from the host PC is received via UART. These commands are broken into 3 bytes. This block receives bytes and adds them to a fifo called **byte_fifo** to be assembled into a command once they are all received.

    ![alt text](image-2.png)

## Verification Environment - Block
### CMD_GATHER
### CMD_RESPOND

### CMD_EXECUTE

### MEM_ACCESS
