onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/ALUop
add wave -noupdate /datapath_tb/asel
add wave -noupdate /datapath_tb/bsel
add wave -noupdate /datapath_tb/clk
add wave -noupdate /datapath_tb/datapath_in
add wave -noupdate /datapath_tb/datapath_out
add wave -noupdate /datapath_tb/err
add wave -noupdate /datapath_tb/loada
add wave -noupdate /datapath_tb/loadb
add wave -noupdate /datapath_tb/loadc
add wave -noupdate /datapath_tb/loads
add wave -noupdate /datapath_tb/readnum
add wave -noupdate /datapath_tb/shift
add wave -noupdate /datapath_tb/vsel
add wave -noupdate /datapath_tb/write
add wave -noupdate /datapath_tb/writenum
add wave -noupdate /datapath_tb/Z_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {614 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {250 ps} {750 ps}
