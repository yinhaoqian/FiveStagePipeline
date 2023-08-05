#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_Multiplier_Testbench.tcl
add_force -radix dec i_vec_dataIn1 2147483647 
add_force -radix dec i_vec_dataIn2 1234567890
run 10 ns

add_force -radix dec i_vec_dataIn1 -1234567890 
add_force -radix dec i_vec_dataIn2 98765
run 10 ns