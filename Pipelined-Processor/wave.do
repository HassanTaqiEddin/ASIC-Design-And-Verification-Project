onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/processor/clk
add wave -noupdate /top_tb/processor/reset
add wave -noupdate -radix unsigned /top_tb/processor/pcOut
add wave -noupdate /top_tb/processor/pcAdderResult
add wave -noupdate /top_tb/processor/instMemOut
add wave -noupdate /top_tb/processor/decode_pcAdderResult
add wave -noupdate /top_tb/processor/decode_instMemOut
add wave -noupdate /top_tb/processor/jumpAddress
add wave -noupdate /top_tb/processor/opCode
add wave -noupdate /top_tb/processor/funct
add wave -noupdate /top_tb/processor/rdAddress
add wave -noupdate /top_tb/processor/rtAddress
add wave -noupdate /top_tb/processor/rsAddress
add wave -noupdate /top_tb/processor/immediateData
add wave -noupdate /top_tb/processor/RegDst
add wave -noupdate /top_tb/processor/pcsrc
add wave -noupdate /top_tb/processor/Jump
add wave -noupdate /top_tb/processor/Branch
add wave -noupdate /top_tb/processor/MemtoReg
add wave -noupdate /top_tb/processor/MemReadEn
add wave -noupdate /top_tb/processor/MemWriteEn
add wave -noupdate /top_tb/processor/ALUOp
add wave -noupdate /top_tb/processor/ALUSrc
add wave -noupdate /top_tb/processor/RegWriteEn
add wave -noupdate /top_tb/processor/equal
add wave -noupdate /top_tb/processor/shiftedJump
add wave -noupdate -radix unsigned /top_tb/processor/jumpTA
add wave -noupdate /top_tb/processor/immediateExtended
add wave -noupdate /top_tb/processor/shiftedBranch
add wave -noupdate /top_tb/processor/mux1out
add wave -noupdate /top_tb/processor/mux2out
add wave -noupdate /top_tb/processor/mux3out
add wave -noupdate /top_tb/processor/data1
add wave -noupdate /top_tb/processor/data2
add wave -noupdate /top_tb/processor/shiftAdderResult
add wave -noupdate /top_tb/processor/Mux3Sel
add wave -noupdate /top_tb/processor/flush
add wave -noupdate /top_tb/processor/orOut
add wave -noupdate /top_tb/processor/Ex_RegWriteEn
add wave -noupdate /top_tb/processor/Ex_MemtoReg
add wave -noupdate /top_tb/processor/Ex_MemWriteEn
add wave -noupdate /top_tb/processor/Ex_MemReadEn
add wave -noupdate /top_tb/processor/Ex_ALUOp
add wave -noupdate /top_tb/processor/Ex_RegDst
add wave -noupdate /top_tb/processor/Ex_ALUSrc
add wave -noupdate /top_tb/processor/Ex_data1
add wave -noupdate /top_tb/processor/Ex_data2
add wave -noupdate /top_tb/processor/Ex_nextpc
add wave -noupdate /top_tb/processor/Ex_immediateext
add wave -noupdate /top_tb/processor/Ex_RsAddress
add wave -noupdate /top_tb/processor/Ex_RtAddress
add wave -noupdate /top_tb/processor/Ex_RdAddress
add wave -noupdate /top_tb/processor/Mux4out
add wave -noupdate /top_tb/processor/Mux5out
add wave -noupdate /top_tb/processor/ALUOut
add wave -noupdate /top_tb/processor/forwardSelA
add wave -noupdate /top_tb/processor/forwardSelB
add wave -noupdate /top_tb/processor/forwardMuxAout
add wave -noupdate /top_tb/processor/forwardMuxBout
add wave -noupdate /top_tb/processor/MEM_RegWriteEn
add wave -noupdate /top_tb/processor/MEM_MemtoReg
add wave -noupdate /top_tb/processor/MEM_MemWriteEn
add wave -noupdate /top_tb/processor/MEM_MemReadEn
add wave -noupdate /top_tb/processor/MEM_nextpc
add wave -noupdate /top_tb/processor/MEM_ALUOut
add wave -noupdate /top_tb/processor/MEM_data2
add wave -noupdate /top_tb/processor/MEM_WBAddress
add wave -noupdate /top_tb/processor/dataMemOut
add wave -noupdate /top_tb/processor/WB_RegWriteEn
add wave -noupdate /top_tb/processor/WB_MemtoReg
add wave -noupdate /top_tb/processor/WB_nextpc
add wave -noupdate /top_tb/processor/WB_ALUOut
add wave -noupdate /top_tb/processor/WB_dataMemOut
add wave -noupdate /top_tb/processor/WB_WBAddress
add wave -noupdate /top_tb/processor/Mux6out
add wave -noupdate -radix unsigned -childformat {{{/top_tb/processor/RegisterFile_inst/registers[0]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[1]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[2]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[3]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[4]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[5]} -radix hexadecimal} {{/top_tb/processor/RegisterFile_inst/registers[6]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[7]} -radix hexadecimal} {{/top_tb/processor/RegisterFile_inst/registers[8]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[9]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[10]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[11]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[12]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[13]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[14]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[15]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[16]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[17]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[18]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[19]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[20]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[21]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[22]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[23]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[24]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[25]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[26]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[27]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[28]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[29]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[30]} -radix unsigned} {{/top_tb/processor/RegisterFile_inst/registers[31]} -radix unsigned}} -expand -subitemconfig {{/top_tb/processor/RegisterFile_inst/registers[0]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[1]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[2]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[3]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[4]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[5]} {-radix hexadecimal} {/top_tb/processor/RegisterFile_inst/registers[6]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[7]} {-radix hexadecimal} {/top_tb/processor/RegisterFile_inst/registers[8]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[9]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[10]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[11]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[12]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[13]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[14]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[15]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[16]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[17]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[18]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[19]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[20]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[21]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[22]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[23]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[24]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[25]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[26]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[27]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[28]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[29]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[30]} {-radix unsigned} {/top_tb/processor/RegisterFile_inst/registers[31]} {-radix unsigned}} /top_tb/processor/RegisterFile_inst/registers
add wave -noupdate /top_tb/processor/forwardingUnit_inst/Ex_RsAddress
add wave -noupdate /top_tb/processor/forwardingUnit_inst/Ex_RtAddress
add wave -noupdate /top_tb/processor/forwardingUnit_inst/MEM_WBAddress
add wave -noupdate /top_tb/processor/forwardingUnit_inst/WB_WBAddress
add wave -noupdate /top_tb/processor/forwardingUnit_inst/MEM_RegWriteEn
add wave -noupdate /top_tb/processor/forwardingUnit_inst/WB_RegWriteEn
add wave -noupdate /top_tb/processor/forwardingUnit_inst/reset
add wave -noupdate /top_tb/processor/forwardingUnit_inst/forwardSelA
add wave -noupdate /top_tb/processor/forwardingUnit_inst/forwardSelB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {115000 ps} 1}
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
WaveRestoreZoom {74568 ps} {198856 ps}
