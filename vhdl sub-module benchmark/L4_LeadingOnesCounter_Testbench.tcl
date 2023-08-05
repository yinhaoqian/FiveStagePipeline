
#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_LeadingOnesCounter_Testbench.tcl
restart

add_force -radix bin i_vec_dataIn 00001111000011110000111100001111
run 1 ns
if { [get_value -radix dec o_vec_onesCount] == [expr 0] } {
	puts "1 correct"
} else {
	puts "1 incorrect"
}

add_force -radix bin i_vec_dataIn 11111001111111111111111111111111 
run 1 ns
if { [get_value -radix dec o_vec_onesCount] == [expr 5] } {
	puts "2 correct"
} else {
	puts "2 incorrect"
}

add_force -radix bin i_vec_dataIn 11111111111111111111111111100000
run 1 ns
if { [get_value -radix dec o_vec_onesCount] == [expr 27] } {
	puts "3 correct"
} else {
	puts "3 incorrect"
}

add_force -radix bin i_vec_dataIn 11111111111111111111111111111111
run 1 ns
if { [get_value -radix dec o_vec_onesCount] == [expr 32] } {
	puts "4 correct"
} else {
	puts "4 incorrect"
}