#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_Registers_Testbench.tcl
restart

#give a reset signal
add_force i_rst_reset 0
run 2500ps
add_force i_rst_reset 1
run 5 ns
add_force i_rst_reset 0
add_force i_l_enable 1
add_force i_clk_clock 1 {0 1ns} -repeat_every 2ns
run 5 ns


for {set i 0} {$i < 32} {incr i} {
	add_force i_vec_writeData -radix dec [expr $i * 2 + 10]
	add_force i_vec_writeRegister -radix dec [expr $i]
	run 5 ns
}
add_force i_l_enable 0
run 10 ns

for {set i 0} {$i < 16} {incr i} {
	add_force i_vec_writeData -radix dec [expr 0]
	add_force i_vec_readRegister1 -radix dec [expr $i *2]
	add_force i_vec_readRegister2 -radix dec [expr $i *2 +1]
	run 5 ns
	if {[get_value -radix dec o_vec_readData1] == [expr $i * 2 * 2 + 10]} {
		puts "readData1 Correct!"
	} else {
		puts "readData1 Wrong!"
	}
	if {[get_value -radix dec o_vec_readData2] == [expr ($i * 2 + 1 ) * 2 + 10]} {
		puts "readData2 Correct!"
	} else {
		puts "readData2 Wrong!"
	}
}


