#source C:/Users/Yinhao/Documents/FA2021/Mahmoud_1195/Labs/lab4/tcl_testbench/Cpu_tb_requiredTB/t9.tcl

# restart the simulation
restart

#top-level CPU testbench is named cpu_tb
#this instruction will add the internal signals and ports of a component name U_1, which in this case is the memory block.
#this should be replaced by the name of the componenet in your top-level testbench
add_wave {{/cpu_tb/U_1}}

#lui $1, 0x00001001
#ori $3, $0, 0xFF0F
#sw $3, 32($1)
#ori $5, $0, 0xBBBB
#sll $0,$0,0
#lw $2, 32($1)
#and $4, $2,$5
#sw $4, 36($1)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
# the first 4 memory locations are initialized with the instruction codes correpsonding to the 4 instructions above.
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3403FF0F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {AC230020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {3405BBBB}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {8C220020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00452024}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {AC240024}

#forcing a clock with 10 ns period
add_force clk 1 {0 5ns} -repeat_every 10ns

#give a reset signal
add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 500 ns

if { [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[8]} ] == {0000ff0f} && [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[9]} ] == {0000bb0b}} {
    puts "test correct"
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[8]}  ]
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[9]}  ]
} else {
    puts "test incorrect"
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[8]} ]
    puts [get_value -radix hex {/cpu_tb/U_1/mw_U_0ram_table[9]}  ]
}