# LogisimFiveStagePipeline
This is an implementation of a five-stage pipelined processor, comprising the following components:
- A program counter and fetch adder responsible for fetching instructions.
- An instruction memory that stores the program instructions.
- A register file for storing and accessing data during execution.
- An instruction decoder to interpret fetched instructions.
- A sign extender for sign extension operations.
- An arithmetic logic unit (ALU) for performing various computations.
- A data memory for storing data during memory operations.
- Four pipeline latches to hold intermediate results between pipeline stages.
- A forwarding unit to manage data hazards efficiently.
- A hazard unit to handle potential hazards during instruction execution.
- An LED hexadecimal display for visual feedback.
- An LED indicator to signal when the processor has halted.
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Main%20Interface.PNG)
In the following table, the symbol "X" denotes that the Subop field (refer to the description below) is not applicable for I-format instructions. Notably, there are certain distinctions between this project and the standard RISC-V instructions. Primarily, this project adopts a "two-operand" instruction set, wherein each instruction involves a maximum of two operands—comprising source and destination operands. In this instruction format, one of the source operands (registers) also serves as the destination. Nevertheless, the majority of instructions retain similar functionality to their RISC-V counterparts.
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Instruction%20Set.PNG)
In this project, two instruction formats are utilized: R and I. The R-format is employed for instructions that exclusively involve registers, while the I-format is utilized for instructions that incorporate immediates. The formats are as follows:
![alt text](https://github.com/yinhaoqian/LogisimFiveStagePipeline/blob/main/pictures/Format.PNG)
- In the R-format, the instruction consists of an Opcode field, followed by the destination register (Rd), the first source register (Rs), the second source register (Rt), an X field (which may vary in usage), Funct3, and Funct7 fields.
- In the I-format, the instruction contains an Opcode field, the destination register (Rd), the first source register (Rs), and an 8-bit immediate value (Imm).
