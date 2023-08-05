#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_Milestones_Testbench.tcl
restart
#give a reset signal
add_force i_clk_clock 1 {0 10ns} -repeat_every 20ns

add_force i_rst_reset 1
run 40 ns
add_force i_rst_reset 0
run 2 ns

add_force s_l_resetFromCtrlUnit 0
add_force s_vec_dataOutFromMuxWrtReg -radix dec 1
add_force s_vec_dataOutFromMuxWrtData -radix dec 12345678
add_force s_l_regEnableFromCtrlUnit 1
add_force s_clk_clock 0
run 200 ps
add_force s_clk_clock 1
run 200 ps
remove_force s_vec_dataOutFromMuxWrtReg
remove_force s_vec_dataOutFromMuxWrtData
remove_force s_l_regEnableFromCtrlUnit
remove_force s_clk_clock
run 200 ps

add_force s_l_resetFromCtrlUnit 0
add_force s_vec_dataOutFromMuxWrtReg -radix dec 2
add_force s_vec_dataOutFromMuxWrtData -radix dec 87654321
add_force s_l_regEnableFromCtrlUnit 1
add_force s_clk_clock 0
run 200 ps
add_force s_clk_clock 1
run 200 ps
remove_force s_vec_dataOutFromMuxWrtReg
remove_force s_vec_dataOutFromMuxWrtData
remove_force s_l_regEnableFromCtrlUnit
remove_force s_clk_clock
run 200 ps

add_force s_l_resetFromCtrlUnit 0
add_force s_vec_dataOutFromMuxWrtReg -radix dec 30
add_force s_vec_dataOutFromMuxWrtData -radix dec 1
add_force s_l_regEnableFromCtrlUnit 1
add_force s_clk_clock 0
run 200 ps
add_force s_clk_clock 1
run 200 ps
remove_force s_vec_dataOutFromMuxWrtReg
remove_force s_vec_dataOutFromMuxWrtData
remove_force s_l_regEnableFromCtrlUnit
remove_force s_clk_clock
run 200 ps

add_force s_l_resetFromCtrlUnit 0
add_force s_vec_dataOutFromMuxWrtReg -radix dec 31
add_force s_vec_dataOutFromMuxWrtData -radix hex f0000000
add_force s_l_regEnableFromCtrlUnit 1
add_force s_clk_clock 0
run 200 ps
add_force s_clk_clock 1
run 200 ps
remove_force s_vec_dataOutFromMuxWrtReg
remove_force s_vec_dataOutFromMuxWrtData
remove_force s_l_regEnableFromCtrlUnit
remove_force s_clk_clock
run 200 ps

# addu r01 r02 r03
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000001000100001100000100001
run 100 ns
#r01=12345678
#r02=87654321
#r03=r01+r03=99999999
#r30=1
#r31=0xf0000000
#pc=0
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 99999999] } {
	puts "addu correct"
} else {
	puts "addu incorrect"
}
# and r04 r03 r01
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000011000010010000000100100
run 80 ns
#r01=12345678
#r02=87654321
#r03=99999999
#r04=r01&r03=11821134
#r30=1
#r31=0xf0000000
#pc=4
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 11821134] } {
	puts "and correct"
} else {
	puts "and incorrect"
}

# sub r05 r03 r04
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000011001000010100000100010
run 80 ns
#r01=12345678
#r02=87654321
#r03=99999999
#r04=11821134
#r05=r03-r04=88178865
#r30=1
#r31=0xf0000000
#pc=8
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 88178865] } {
	puts "sub correct"
} else {
	puts "sub incorrect"
}

# sra r06 r31 4
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000000111110011000100000011
run 80 ns
#r01=12345678
#r02=87654321
#r03=99999999
#r04=11821134
#r05=88178865
#r06=r31 sra 4=0xff000000
#r30=1
#r31=0xf0000000
#pc=12
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr -16777216] } {
	puts "sra correct"
} else {
	puts "sra incorrect"
}

# sllv r07 r03 r30
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000011110000110011100000000100
run 80 ns
#r01=12345678
#r02=87654321
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=r03 sllv r30=r03 sll 1=19999998
#r30=1
#r31=0xf0000000
#pc=16
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 199999998] } {
	puts "sllv correct"
} else {
	puts "sllv incorrect"
}

# sll r07 r07 8
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000000001110011101000000000
run 80 ns
#r01=12345678
#r02=87654321
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=r07 sll 8=-339608064
#r30=1
#r31=0xf0000000
#pc=20
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr -339608064] } {
	puts "sll correct"
} else {
	puts "sll incorrect"
}

# addi r01 r07 88
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000111000010000000001011000
run 80 ns
#r01=r07+88=-339607976
#r02=87654321
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r30=1
#r31=0xf0000000
#pc=24
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr -339607976] } {
	puts "addi correct"
} else {
	puts "addi incorrect"
}

# ori r02 r01 12345
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00110100001000100011000000111001
run 80 ns
#r01=-339607976
#r02=r01 or 12345=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r30=1
#r31=0xf0000000
#pc=28
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr -339607943] } {
	puts "ori correct"
} else {
	puts "ori incorrect"
}

# slti r01 r02 -1
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00101000010000011111111111111111
run 80 ns
#r01=r02<-1=1
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r30=1
#r31=0xf0000000
#pc=32
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 1] } {
	puts "slti_part1 correct"
} else {
	puts "slti_part1 incorrect"
}

# slti r01 r03 -1
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00101000011000010000000000000001
run 80 ns
#r01=r03<-1=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r30=1
#r31=0xf0000000
#pc=36
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 0] } {
	puts "slti_part2 correct"
} else {
	puts "slti_part2 incorrect"
}

# j 11
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00001000000000000000000000001011
run 60 ns
#r01=r03<-1=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r30=1
#r31=0xf0000000
#pc=44
if { [get_value -radix dec s_vec_dataOutFromRegisterPc] == [expr 44] } {
	puts "j correct"
} else {
	puts "j incorrect"
}

# ori r08 r08 15
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00110101000010000000000000111100
run 80 ns
#r01=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=60
#r30=1
#r31=0xf0000000
#pc=48


# jr r08
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000001000000000000000000001000
run 60 ns
#r01=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=60
#r30=1
#r31=0xf0000000
#pc=52
if { [get_value -radix dec s_vec_dataOutFromRegisterPc] == [expr 60] } {
	puts "jr correct"
} else {
	puts "jr incorrect"
}


# bne r02 r03 17
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00010000010000110000000000010001
run 100 ns
#r01=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#pc=68
if { [get_value -radix dec s_vec_dataOutFromRegisterPc] == [expr 68] } {
	puts "bne_part1 correct"
} else {
	puts "bne_part1 incorrect"
}


# bne r01 r09 1
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00010000001010010000000000000001
run 100 ns
#r01=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#pc=72
if { [get_value -radix dec s_vec_dataOutFromRegisterPc] == [expr 72] } {
	puts "bne_part2 correct"
} else {
	puts "bne_part2 incorrect"
}

# multu r03 r05
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000011001010000000000011001
run 60 ns
#r01=0
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=76
if { [get_value -radix dec s_vec_dataOutFromRegisterHi] == [expr 2053074] && [get_value -radix dec s_vec_dataOutFromRegisterLo] == [expr 725553231] } {
	puts "multu correct"
} else {
	puts "multu incorrect"
}

# mfhi r01
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000000000000000100000010000
run 60 ns
#r01=2053074
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=80

# addi r01 r01 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000001000010000000000000000
run 80 ns
#r01=2053074
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=84
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 2053074] } {
	puts "mfhi correct"
} else {
	puts "mfhi incorrect"
}

# mflo r01
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000000000000000000100000010010
run 60 ns
#r01=725553231
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=88

# addi r01 r01 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000001000010000000000000000
run 80 ns
#r01=725553231
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=92
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 725553231] } {
	puts "mflo correct"
} else {
	puts "mflo incorrect"
}

# clo r01 r31
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 01110011111000000000100000100001
run 60 ns
#r01=4
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=96

# addi r01 r01 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000001000010000000000000000
run 80 ns
#r01=4
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=100
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 4] } {
	puts "clo correct"
} else {
	puts "clo incorrect"
}

# lw  r03 r01(1)
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 10001100001000110000000000000001
run 60 ns
#r01=4
#r02=-339607943
#r03=*mem(5)=12345678
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=104
if { [get_value -radix dec o_vec_dataOutFromMuxAdr] == [expr 5] } {
	add_force -radix dec s_vec_dataOutFromMem 12345678
	puts "lw load-initialization correct"
} else {
	add_force -radix dec s_vec_dataOutFromMem 0
	puts "lw load-initialization incorrect"
}
run 40 ns

# addi r03 r03 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000011000110000000000000000
run 80 ns
#r01=4
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=108
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 12345678] } {
	puts "lw correct"
} else {
	puts "lw incorrect"
}


# lh  r03 r01(2)
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 10000100001000110000000000000010
run 60 ns
#r01=4
#r02=-339607943
#r03=*mem(6)=24910
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=112
if { [get_value -radix dec o_vec_dataOutFromMuxAdr] == [expr 6] } {
	add_force -radix dec s_vec_dataOutFromMem 12345678
	puts "lh load-initialization correct"
} else {
	add_force -radix dec s_vec_dataOutFromMem 0
	puts "lh load-initialization incorrect"
}
run 40 ns

# addi r03 r03 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000011000110000000000000000
run 80 ns
#r01=4
#r02=-339607943
#r03=24910
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=116
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 24910] } {
	puts "lh correct"
} else {
	puts "lh incorrect"
}


# lb  r03 r01(0)
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 10000000001000110000000000000000
run 60 ns
#r01=4
#r02=-339607943
#r03=*mem(4)=78
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=120
if { [get_value -radix dec o_vec_dataOutFromMuxAdr] == [expr 4] } {
	add_force -radix dec s_vec_dataOutFromMem 12345678
	puts "lb load-initialization correct"
} else {
	add_force -radix dec s_vec_dataOutFromMem 0
	puts "lb load-initialization incorrect"
}
run 40 ns

# addi r03 r03 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100000011000110000000000000000
run 80 ns
#r01=4
#r02=-339607943
#r03=78
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=124
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 78] } {
	puts "lb correct"
} else {
	puts "lb incorrect"
}

# lui r03 65535
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00111100000000011111111111111111
run 80 ns
#r01=-65536
#r02=-339607943
#r03=78
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=128
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr -65536] } {
	puts "lui correct"
} else {
	puts "lui incorrect"
}


# sw r01 16(r08)
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 10101101000000010000000000010000
run 60 ns
#r01=-65536
#r02=-339607943
#r03=78
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=0xf0000000
#lo=725553231
#hi=2053074
#pc=132
if { [get_value -radix dec o_l_memWriteEnable] == [expr 1] && [get_value -radix dec s_vec_dataOutFromMuxAdr] == [expr 76] &&  [get_value -radix dec s_vec_dataOutFromRegisterB] == [expr -65536]} {
	puts "sw correct"
} else {
	puts [get_value -radix dec o_l_memWriteEnable]
	puts [get_value -radix dec s_vec_dataOutFromMuxAdr]
	puts [get_value -radix dec s_vec_dataOutFromRegisterB]
	puts "sw incorrect"
}
run 20 ns

# bltzal r01 15
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00000100001100000000000000001111
run 100 ns
#r01=-65536
#r02=-339607943
#r03=78
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=132
#lo=725553231
#hi=2053074
#pc=60
if { [get_value -radix dec s_vec_dataOutFromRegisterPc] == [expr 60] } {
	puts "bltzal_part1 correct"
} else {
	puts "bltzal_part1 incorrect"
}

# addi r31 r31 0
# -------------------------    PPPPPPSSSSSTTTTTDDDDD00000FFFFFF
add_force s_vec_dataOutFromMem 00100011111111110000000000000000
run 80 ns
#r01=-65536
#r02=-339607943
#r03=99999999
#r04=11821134
#r05=88178865
#r06=0xff000000
#r07=825032192
#r08=15
#r30=1
#r31=132
#lo=725553231
#hi=2053074
#pc=84
if { [get_value -radix dec s_vec_dataOutFromRegisterAluOut] == [expr 136] } {
	puts "bltzal_part2 correct"
} else {
	puts "bltzal_part2  incorrect"
}



#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_Milestones_Testbench.tcl