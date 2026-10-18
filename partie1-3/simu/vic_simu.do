vlib work

vcom -93 ../src/vic.vhd

vcom -93 vic_tb.vhd

vsim vic_tb

view signals
add wave *

run -all
wave zoom full