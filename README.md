# LogisimFiveStagePipeline
This is an implementation five-stage pipelined processor that includes IF, ID, EX, MEM, and WB. Each
stage takes 1 cycle to finish, which means the longest instruction needs 5 cycles to process. The 
implementation has several components: 1) a program counter and fetch adder; 2) an instruction 
memory; 3) a register file; 4) an instruction decoder; 5) a sign extender; 6) an ALU; 7) a data memory; 8) 
4 pipeline latches; 9) a forwarding unit; 10) a hazard unit 11) an LED hexadecimal display; and, 12) an 
LED to indicate the processor has halted.
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Main%20Interface.PNG)
