# Main UART-stage simulation. Run with: do ARM_simu.do
onerror {abort}
set script_dir [file dirname [file normalize [info script]]]
set source_dir [file normalize [file join $script_dir .. src]]
set library_dir [file join $script_dir work]
if {![file isdirectory $library_dir]} {vlib $library_dir}
vmap work $library_dir
set source_files {
    VIC.vhd
    Ban_de_registre.vhd
    DualPortRAM.vhd
    MAE.vhd
    mux2.vhd
    mux4.vhd
    register32_charge.vhd
    register32.vhd
    sign_extension.vhd
    alu.vhd
    fdiv.vhd
    uart_tx.vhd
    uart_rx.vhd
    uart_conf.vhd
    DataPath_UART.vhd
    arm_UART.vhd
}
foreach name $source_files {
    set source [file join $source_dir $name]
    if {![file isfile $source]} {error "Missing VHDL source: $source"}
    vcom -93 $source
}
vcom -93 [file join $script_dir ARM_TB.vhd]
vsim -voptargs=+acc work.ARM_UART_TB
view signals
add wave -r sim:/arm_uart_tb/*
run 1200 us
wave zoom full
