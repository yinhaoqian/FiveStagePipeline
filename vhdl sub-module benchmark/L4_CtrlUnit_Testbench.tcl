#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/L4_AluCtrl_Testbench.tcl
restart

#give a reset signal
add_force i_rst_reset 0
run 2500ps
add_force i_rst_reset 1
run 5 ns
add_force i_vec_Op 000000
add_force i_rst_reset 0
add_force i_clk_clock 1 {0 1ns} -repeat_every 2ns
run 50 ns



