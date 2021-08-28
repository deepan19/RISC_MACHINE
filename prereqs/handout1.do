onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Lab7_top_tb/LEDR
add wave -noupdate /Lab7_top_tb/SW
add wave -noupdate /Lab7_top_tb/DUT/eq3
add wave -noupdate /Lab7_top_tb/DUT/eq4
add wave -noupdate /Lab7_top_tb/DUT/eq5
add wave -noupdate /Lab7_top_tb/DUT/eq6
add wave -noupdate /Lab7_top_tb/DUT/ledcheck
add wave -noupdate /Lab7_top_tb/DUT/mem_addr
add wave -noupdate /Lab7_top_tb/DUT/mem_cmd
add wave -noupdate /Lab7_top_tb/DUT/swcheck
add wave -noupdate /Lab7_top_tb/DUT/CPU/stmac/present_state
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /Lab7_top_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /Lab7_top_tb/DUT/CPU/decoder/in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 276
configure wave -valuecolwidth 72
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
WaveRestoreZoom {0 ps} {1368 ps}
