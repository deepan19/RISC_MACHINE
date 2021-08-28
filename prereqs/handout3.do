onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/DUT/clk
add wave -noupdate /lab7_check_tb/DUT/CPU/reset
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/present_state
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/reset_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/load_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/next_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/PC
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/mem_cmd
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/addr_sel
add wave -noupdate /lab7_check_tb/DUT/CPU/mem_addr
add wave -noupdate /lab7_check_tb/DUT/MEM/dout
add wave -noupdate /lab7_check_tb/DUT/msel
add wave -noupdate /lab7_check_tb/DUT/read_data
add wave -noupdate /lab7_check_tb/DUT/CPU/stmac/load_ir
add wave -noupdate /lab7_check_tb/DUT/CPU/decoder/in
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /lab7_check_tb/DUT/CPU/decoder/imm8
add wave -noupdate /lab7_check_tb/DUT/CPU/decoder/in
add wave -noupdate /lab7_check_tb/DUT/CPU/decoder/sximm8
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/data_in
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/sximm8
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {74 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
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
WaveRestoreZoom {0 ps} {109 ps}
