#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_AluCtrl_Testbench.tcl
restart

run 1 ns
add_force i_vec_instr31To26 000000
add_force i_vec_instr15To0 0000000000100001
run 10 ns
if {[get_value -radix dec o_vec_aluOp] == [expr 5] } {
	puts "1 CORRECT"
} else {
	puts "1 INCORRECT"
}


add_force i_vec_instr31To26 000000
add_force i_vec_instr15To0 0000000000100100
run 10 ns
if {[get_value -radix dec o_vec_aluOp] == [expr 0] } {
	puts "2 CORRECT"
} else {
	puts "2 INCORRECT"
}

add_force i_vec_instr31To26 000000
add_force i_vec_instr15To0 0000000000100001
run 10 ns
if {[get_value -radix dec o_vec_aluOp] == [expr 5] } {
	puts "3 CORRECT"
} else {
	puts "3 INCORRECT"
}