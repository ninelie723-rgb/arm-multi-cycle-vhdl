# Main UART-stage simulation entry point.
set uart_entry [file join [file dirname [file normalize [info script]]] ARM_simu.do]
do $uart_entry
