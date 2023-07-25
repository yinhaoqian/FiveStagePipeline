# Logisim Five-Stage Pipeline
## Screenshot
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Main%20Interface.PNG)
## Introduction
This is an implementation of a five-stage pipelined processor, comprising the following components:
1. A program counter and fetch adder responsible for fetching instructions.
2. An instruction memory that stores the program instructions.
3. A register file for storing and accessing data during execution.
4. An instruction decoder to interpret fetched instructions.
5. A sign extender for sign extension operations.
6. An arithmetic logic unit (ALU) for performing various computations.
7. A data memory for storing data during memory operations.
8. Four pipeline latches to hold intermediate results between pipeline stages.
9. A forwarding unit to manage data hazards efficiently.
10. A hazard unit to handle potential hazards during instruction execution.
11. An LED hexadecimal display for visual feedback.
12. An LED indicator to signal when the processor has halted.
## Instructions
In the following table, the symbol "X" denotes that the Subop field (refer to the description below) is not applicable for I-format instructions. Notably, there are certain distinctions between this project and the standard RISC-V instructions. Primarily, this project adopts a "two-operand" instruction set, wherein each instruction involves a maximum of two operands—comprising source and destination operands. In this instruction format, one of the source operands (registers) also serves as the destination. Nevertheless, the majority of instructions retain similar functionality to their RISC-V counterparts:
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Instruction%20Set.PNG)
In this implmentation, two instruction formats are utilized: R and I. The R-format is employed for instructions that exclusively involve registers, while the I-format is utilized for instructions that incorporate immediates. The formats are as follows:
- In the R-format, the instruction consists of an Opcode field, followed by the destination register (Rd), the first source register (Rs), the second source register (Rt), an X field (which may vary in usage), Funct3, and Funct7 fields:
```
| Opcode (6 bits) | Rd (5 bits) | Rs (5 bits) | Rt (5 bits) | X (5 bits) | Funct3 (3 bits) | Funct7 (7 bits) |
```
- In the I-format, the instruction contains an Opcode field, the destination register (Rd), the first source register (Rs), and an 8-bit immediate value (Imm):
```
| Opcode (6 bits) | Rd (5 bits) | Rs (5 bits) | Imm (8 bits) |
```
## Components
**Registers**
There are 8 registers, labeled $r0 to $r7. In this project, $r0 is not 0. It’s a general register and can be used 
like any other register. The registers are 16 bits wide. An R-format instruction can read 2 source registers 
and write 1 destination register. Thus, the register file has 2 read ports and 1 write port.
**Instruction Memory**
This component is a ROM configured to hold 256 16-bit instructions. You should use the ROM in 
Logisim’s Memory library. In your implementation, the ROM must be visible in the main circuit. The 
ROM’s contents will hold the set of instructions for a program.
**Data Memory**
This component is a RAM configured to hold 256 16-bit words. You should use the RAM in Logisim’s 
Memory library. In your implementation, the RAM must be visible in the main circuit. 
**Arithmetic Logic Unit (ALU)**
The ALU is used in the arithmetic instructions, memory instructions and branch instructions. It can do 
addition, subtraction and comparison. 
**Decoder**
This component takes the instruction opcode as an input and generates control signals for the data path in 
each stage as outputs.
**LED Hexadecimal Display**
This project has a four digit hexadecimal (16 bit) display. Instruction “put” outputs a register value to this 
display. The contents of a put’s source register (16-bit value) is output on the display. A value that is “put” 
must remain until the next put is executed.
**Halting Processor Execution**
When halt is executed, the processor should stop fetching instructions. But the instructions which are 
already in the pipeline should be finished one by one. After all the instructions are done, the main circuit 
must have an LED that turns red when the processor is halted. 
**Program Counter**
The program counter is a register that holds an 8-bit instruction address. It specifies the instruction to fetch 
from the instruction memory. It is updated every clock cycle with PC + 1 or the target address of a taken 
branch (or jump).
**Pipeline Latches/Register**
To guarantee that portions of the datapath could be shared during instruction execution, we need to place 
registers between adjacent pipeline stages. Note there is no pipeline register at the end of write back stage. 
**Forwarding Unit and Hazard Unit**
Both data hazard and control hazard should be considered in this project. (There’s no structure hazard since 
each instruction only takes one cycle in each stage). 
Data hazard can be classified into EX hazard and MEM hazard, based on different kinds of instruction pairs 
which cause the hazard.
