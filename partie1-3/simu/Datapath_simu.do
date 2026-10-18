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
vcom -93 ../src/DataPath.vhd

vcom -93 Datapath_TB.vhd

vsim DataPath_TB

view signals
add wave *

add wave -position insertpoint sim:/DataPath_TB/uut/PC_out
add wave -position insertpoint sim:/DataPath_TB/uut/IR_out
add wave -position insertpoint sim:/DataPath_TB/uut/Res
add wave -position insertpoint sim:/DataPath_TB/irq
add wave -position insertpoint sim:/DataPath_TB/Inst_Mem

run -all
wave zoom full