#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_InstrReg_Testbench.tcl
#Test Passed
restart
#give a reset signal
add_force i_rst_reset 0
run 2500ps
add_force i_rst_reset 1
run 5 ns
add_force i_rst_reset 0
add_force i_clk_clock 1 {0 1ns} -repeat_every 2ns
run 5 ns
add_force i_l_enable 1
add_force i_vec_dataIn 00000000000000010000100000100001
run 10ns
