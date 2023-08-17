onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /tb/clk
add wave -noupdate -expand -group tb /tb/count
add wave -noupdate -expand -group tb /tb/nreset
add wave -noupdate -expand -group tb /tb/smplvalid
add wave -noupdate -expand -group fir /tb/fir_i/SMPL_BITS
add wave -noupdate -expand -group fir /tb/fir_i/TAPS
add wave -noupdate -expand -group fir /tb/fir_i/clk
add wave -noupdate -expand -group fir /tb/fir_i/nreset
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/count
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/countdlyd
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/tapidx
add wave -noupdate -expand -group fir -radix decimal /tb/fir_i/taps
add wave -noupdate -expand -group fir -format Analog-Step -height 74 -max 2047.0 -min -430.0 -radix decimal /tb/fir_i/tapval
add wave -noupdate -expand -group fir /tb/fir_i/rdtap
add wave -noupdate -expand -group fir /tb/fir_i/write
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/addr
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/wdata
add wave -noupdate -expand -group fir -radix unsigned /tb/fir_i/rdata
add wave -noupdate -expand -group fir /tb/fir_i/smplvalid
add wave -noupdate -expand -group fir -radix decimal /tb/fir_i/validsample
add wave -noupdate -expand -group fir -radix decimal /tb/fir_i/sample
add wave -noupdate -expand -group fir /tb/fir_i/smplsvalid
add wave -noupdate -expand -group fir /tb/fir_i/smpls
add wave -noupdate -expand -group fir {/tb/fir_i/smplsvalid[126]}
add wave -noupdate -expand -group fir -radix decimal /tb/fir_i/accum
add wave -noupdate -expand -group fir /tb/fir_i/idx
add wave -noupdate -expand -group fir /tb/fir_i/lastcycle
add wave -noupdate -expand -group fir /tb/fir_i/opvalid
add wave -noupdate -expand -group fir -format Analog-Interpolated -height 74 -max 2047.0 -min -430.0 -radix decimal /tb/fir_i/out
add wave -noupdate /tb/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96040084 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {195449138 ps} {200239520 ps}
