## =========================================================
## Nexys A7-50T (xc7a50t-csg324-1) - UART Bridge Constraints
## Active-HIGH reset version
## =========================================================

## Clock: 100 MHz onboard oscillator
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 [get_ports {clk}]
## E3 = 100 MHz oscillator input

## Reset Button: Center button (BTNC / CPU_RESET)
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports {rst}]
## Button now treated as active-HIGH (asserted when pressed)

## UART RX: from USB-UART bridge (host TX)
set_property -dict { PACKAGE_PIN C4   IOSTANDARD LVCMOS33 } [get_ports {uart_rx}]
## Connects to FTDI TX (USB-UART)

## UART TX: to USB-UART bridge (host RX)
set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports {uart_tx}]
## Connects to FTDI RX (USB-UART)

set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports {led_captured}]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports {led_reset}]

set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports {uart_idle}]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports {uart_start}]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports {uart_data}]


