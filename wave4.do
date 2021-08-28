onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_check_tb/CLOCK_50
add wave -noupdate /lab8_check_tb/err
add wave -noupdate /lab8_check_tb/DUT/N
add wave -noupdate /lab8_check_tb/DUT/V
add wave -noupdate /lab8_check_tb/DUT/Z
add wave -noupdate /lab8_check_tb/DUT/CPU/stmac/present_state
add wave -noupdate /lab8_check_tb/DUT/CPU/stmac/load_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/stmac/reset_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/next_pc2
add wave -noupdate /lab8_check_tb/DUT/CPU/PC
add wave -noupdate /lab8_check_tb/DUT/CPU/cond_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/cond
add wave -noupdate /lab8_check_tb/DUT/CPU/cond0
add wave -noupdate /lab8_check_tb/DUT/CPU/cond1
add wave -noupdate /lab8_check_tb/DUT/CPU/cond2
add wave -noupdate /lab8_check_tb/DUT/CPU/cond3
add wave -noupdate /lab8_check_tb/DUT/CPU/cond4
add wave -noupdate /lab8_check_tb/DUT/CPU/cond5
add wave -noupdate /lab8_check_tb/DUT/CPU/mem_cmd
add wave -noupdate /lab8_check_tb/DUT/CPU/addr_sel
add wave -noupdate /lab8_check_tb/DUT/CPU/mem_addr
add wave -noupdate /lab8_check_tb/DUT/CPU/datapath_out
add wave -noupdate /lab8_check_tb/DUT/msel
add wave -noupdate /lab8_check_tb/DUT/read_data
add wave -noupdate /lab8_check_tb/DUT/CPU/load_ir
add wave -noupdate /lab8_check_tb/DUT/CPU/decoder/in
add wave -noupdate /lab8_check_tb/DUT/CPU/choose
add wave -noupdate /lab8_check_tb/DUT/CPU/decoder/sximm8
add wave -noupdate /lab8_check_tb/DUT/CPU/load_savepc
add wave -noupdate /lab8_check_tb/DUT/CPU/load_writepc
add wave -noupdate /lab8_check_tb/DUT/CPU/next_pc1
add wave -noupdate /lab8_check_tb/DUT/dout
add wave -noupdate /lab8_check_tb/DUT/check
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8 ps} 0}
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
WaveRestoreZoom {0 ps} {112 ps}
