onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_stage2_tb/CLOCK_50
add wave -noupdate /lab8_stage2_tb/DUT/reset
add wave -noupdate /lab8_stage2_tb/DUT/CPU/stmac/present_state
add wave -noupdate /lab8_stage2_tb/DUT/CPU/stmac/reset_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/stmac/load_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/next_pc2
add wave -noupdate /lab8_stage2_tb/DUT/CPU/PC
add wave -noupdate /lab8_stage2_tb/DUT/CPU/addr_sel
add wave -noupdate /lab8_stage2_tb/DUT/CPU/mem_addr
add wave -noupdate /lab8_stage2_tb/DUT/CPU/out
add wave -noupdate /lab8_stage2_tb/DUT/CPU/in
add wave -noupdate /lab8_stage2_tb/DUT/CPU/decoder/in
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /lab8_stage2_tb/DUT/CPU/load_savepc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/load_writepc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/sximm8
add wave -noupdate /lab8_stage2_tb/DUT/CPU/readpc2
add wave -noupdate /lab8_stage2_tb/DUT/CPU/writepc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {609 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {558 ps} {770 ps}
