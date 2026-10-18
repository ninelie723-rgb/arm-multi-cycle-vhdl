vlib work

vcom -93 ../src/VIC.vhd
vcom -93 ../src/Ban_de_registre.vhd
vcom -93 ../src/DualPortRAM.vhd
vcom -93 ../src/MAE.vhd
vcom -93 ../src/mux2.vhd
vcom -93 ../src/mux4.vhd
vcom -93 ../src/register32_charge.vhd
vcom -93 ../src/register32.vhd
vcom -93 ../src/sign_extension.vhd
vcom -93 ../src/alu.vhd
vcom -93 ../src/FDIV.vhd
vcom -93 ../src/uart_tx.vhd
vcom -93 ../src/uart_rx.vhd
vcom -93 ../src/uart_conf.vhd
vcom -93 ../src/MAE.vhd
vcom -93 ../src/DataPath_uart.vhd
vcom -93 ../src/ARM_UART.vhd

vcom -93 Rx_TB.vhd

vsim ARM_UART_TB

view signals
add wave *
add wave -position end  sim:/arm_uart_tb/UUT/DataPath1/UARTTX/Din

run -all
wave zoom full