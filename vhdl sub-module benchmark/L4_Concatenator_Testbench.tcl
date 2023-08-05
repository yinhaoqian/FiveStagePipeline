
#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_Concatenator_Testbench.tcl
restart

add_force -radix bin i_vec_dataIn 10110011100011110000111110000011
run 3 ns

#Concatenating Upper Immediate
add_force -radix bin i_vec_selector 00 
run 1 ns
if { [get_value -radix dec o_vec_dataOut] == [expr -19569] } {
	puts "concatenate upper immediate correct"
} else {
	puts "concatenate upper immediate incorrect"
}

#Concatenating Word (Keep the original Word)
add_force -radix bin i_vec_selector 01
run 1 ns
if { [get_value -radix dec o_vec_dataOut] == [expr -1282470013] } {
	puts "concatenate word correct"
} else {
	puts "concatenate word incorrect"
}

#Concatenating Half Word 
add_force -radix bin i_vec_selector 10
run 1 ns
if { [get_value -radix dec o_vec_dataOut] == [expr 3971] } {
	puts "concatenate half word correct"
} else {
	puts "concatenate half word incorrect"
}


#Concatenating Byte 
add_force -radix bin i_vec_selector 11
run 1 ns
if { [get_value -radix dec o_vec_dataOut] == [expr -125] } {
	puts "concatenate byte correct"
} else {
	puts "concatenate byte incorrect"
}