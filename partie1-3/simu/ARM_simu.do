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
vcom -93 ../src/MAE.vhd
vcom -93 ../src/DataPath.vhd
vcom -93 ../src/ARM.vhd

vcom -93 ARM_TB.vhd

vsim ARM_TB

view signals
add wave *
add wave -position end  sim:/arm_tb/UUT/MAE1/N
add wave -position end  sim:/arm_tb/UUT/MAE1/inst_new /arm_tb/UUT/MAE1/inst_old 
add wave -position end  sim:/arm_tb/UUT/MAE1/state
add wave -position end  sim:/arm_tb/UUT/DataPath1/N
add wave -radix hex /arm_tb/UUT/DataPath1/Inst_Mem
add wave -radix hex /arm_tb/UUT/DataPath1/Inst_Reg
add wave -radix unsigned /arm_tb/UUT/DataPath1/PC_out
add wave -radix unsigned /arm_tb/UUT/DataPath1/EXT24
add wave -radix unsigned /arm_tb/UUT/DataPath1/EXT8
add wave -position end  sim:/arm_tb/UUT/MAE1/memRdEn
add wave -position end  sim:/arm_tb/UUT/MAE1/memWrEn
add wave -position end  sim:/arm_tb/UUT/IrWrEn
add wave -position end  sim:/arm_tb/UUT/PCWrEn
add wave -radix hex  sim:/arm_tb/UUT/DataPath1/REG_FILE/Banc(0)
add wave -radix hex sim:/arm_tb/UUT/DataPath1/REG_FILE/Banc(1)
add wave -radix hex  sim:/arm_tb/UUT/DataPath1/REG_FILE/Banc(2)
delete wave /arm_tb/IRQ0 /arm_tb/IRQ1 /arm_tb/IRQ0
# add wave -group "commandes"   
add wave -position end  sim:/arm_tb/UUT/PCSel
add wave   sim:/arm_tb/UUT/AluSelA
add wave   sim:/arm_tb/UUT/AluSelB
add wave -position end  sim:/arm_tb/UUT/AluOP
add wave -radix unsigned  sim:/arm_tb/UUT/DataPath1/alu_inst/A
add wave -radix unsigned sim:/arm_tb/UUT/DataPath1/alu_inst/B
add wave -radix unsigned sim:/arm_tb/UUT/DataPath1/alu_inst/S
add wave -position end  sim:/arm_tb/UUT/DataPath1/BUS_W
add wave -position end sim:/arm_tb/UUT/DataPath1/ALUOUT_reg/*
add wave -position end  sim:/arm_tb/UUT/DataPath1/mux_ALU_B
add wave -position end sim:/arm_tb/UUT/DataPath1/ALUOUT_reg/*
add wave -position end  sim:/arm_tb/UUT/DataPath1/Res
add wave -position end  sim:/arm_tb/UUT/DataPath1/irq
add wave -position end  sim:/arm_tb/IRQ1
add wave -position end  sim:/arm_tb/UUT/MAE1/irq_serv
add wave -position end sim:/arm_tb/UUT/DataPath1/vic_ctrl/*

run -all
wave zoom full