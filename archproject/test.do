vsim -gui work.system
# vsim -gui work.system 
# Start time: 19:06:00 on Dec 13,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.system(myregisterfile)
# Loading work.decoder4x16(behavioral)
# Loading work.my_ndff(b_my_ndff)
# Loading work.my_dff(a_my_dff)
# Loading work.tri_state_buffer(behavioral)
# Loading work.mux2x1(behavioral)
# Loading work.ram(syncrama)
# Loading work.alu(alubehavioral)
# Loading work.addoperations(addbehavioral)
# Loading work.nadder(a_nadder)
# Loading work.my_adder(a_my_adder)
add wave -position insertpoint sim:/system/*
force -freeze sim:/system/busC 0111011101110111 0
force -freeze sim:/system/SelectDistC 0000 0
force -freeze sim:/system/DecoderEnDistC 1 0
force -freeze sim:/system/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/system/rst 0 0
force -freeze sim:/system/clkram 1 0, 0 {50 ps} -r 100
force -freeze sim:/system/w 0 0
force -freeze sim:/system/muxselect 0 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /system/ram
force -freeze sim:/system/SelectDistC 0001 0
run
force -freeze sim:/system/SelectDistC 0010 0
run
force -freeze sim:/system/SelectDistC 0011 0
run
force -freeze sim:/system/SelectDistC 0100 0
run
force -freeze sim:/system/SelectDistC 0101 0
run
force -freeze sim:/system/SelectDistC 0110 0
run
force -freeze sim:/system/SelectDistC 0111 0
run
force -freeze sim:/system/SelectDistC 1000 0
run
force -freeze sim:/system/SelectDistC 1001 0
run
force -freeze sim:/system/muxselect 1 0
run
force -freeze sim:/system/SelectDistC 1010 0
run
force -freeze sim:/system/SelectDistC 1011 0
run
force -freeze sim:/system/SelectDistC 1100 0
run
noforce sim:/system/DecoderEnDistC
force -freeze sim:/system/DecoderEnDistC 0 0
noforce sim:/system/busCDecOutRegEn
noforce sim:/system/busBDecOutTriEn
noforce sim:/system/busADecOutTriEn
force -freeze sim:/system/DecoderEnSrcA 1 0
force -freeze sim:/system/DecoderEnSrcB 1 0
force -freeze sim:/system/SelectSourceA 0000 0
force -freeze sim:/system/SelectSourceB 0001 0
run
force -freeze sim:/system/SelectSourceA 0011 0
force -freeze sim:/system/SelectSourceB 0100 0
run
mem load -filltype value -filldata {0000000000000001 } -fillradix binary /system/ram/ram(0)
force -freeze sim:/system/busC 0000000000000000 0
force -freeze sim:/system/DecoderEnDistC 1 0
force -freeze sim:/system/SelectDistC 1000 0
run
force -freeze sim:/system/muxselect 0 0
force -freeze sim:/system/SelectDistC 1001 0
force -freeze sim:/system/DecoderEnDistC 1 0
run
force -freeze sim:/system/busC 0111011101110111 0
force -freeze sim:/system/muxselect 1 0
force -freeze sim:/system/SelectDistC 1001 0
run
force -freeze sim:/system/busC 0000000000000001 0
force -freeze sim:/system/SelectDistC 1000 0
run
force -freeze sim:/system/w 1 0
run
run