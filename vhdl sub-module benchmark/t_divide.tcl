#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/Cpu_tb_requiredTB/t_divide.tcl

# restart the simulation
restart

#top-level CPU testbench is named cpu_tb
#this instruction will add the internal signals and ports of a component name U_1, which in this case is the memory block.
#this should be replaced by the name of the componenet in your top-level testbench
add_wave {{/cpu_tb/U_1}}

#addi $7 $0 17 #Initialize Store word base address
#ori $1 $0	35 #Divisor (A in A/B)
#ori $2 $0  2 #Dividend (B in A/B) #Be sure to store the result to gpr3
#anotherDiv: bltzal $1 afterDiv #if(gpr1<0 goto afterDiv)
#sub $1 $1 $2
#addi $3 $3 1
#j anotherDiv
#afterDiv:  addi $3 $3 -1
#sw $3 27($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
# the first 4 memory locations are initialized with the instruction codes correpsonding to the 4 instructions above.
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {34010023}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {34020002}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {04300007}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00220822}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {20630001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {08000c03}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {2063ffff}
add_force {/cpu_tb/U_1/mw_U_0ram_table[8]} -radix hex {ace3001b}
#forcing a clock with 10 ns period
add_force clk 1 {0 5ns} -repeat_every 10ns

#give a reset signal
add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 3333 ns

if { [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[11]} ] == {00000011} } {
    puts "test correct"
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[11]}  ]
} else {
    puts "test incorrect"
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[11]} ]
}