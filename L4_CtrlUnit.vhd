----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2021 05:01:53 PM
-- Design Name: 
-- Module Name: L4_CtrlUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity L4_CtrlUnit is
    port (
        i_rst_reset    : in std_logic;
        i_clk_clock    : in std_logic;
        i_l_aluZero    : in std_logic;
        i_vec_Op       : in std_logic_vector(5 downto 0);
        i_vec_cdrImd   : in std_logic_vector(15 downto 0);
        o_vec_stateNum : out std_logic_vector(4 downto 0);--DEBUG ONLY
        --SELECTOR
        o_vec_pcSelect           : out std_logic_vector(1 downto 0);
        o_vec_adrSelect          : out std_logic_vector(1 downto 0);
        o_vec_wrtRegSelect       : out std_logic_vector(1 downto 0);
        o_vec_wrtDataSelect      : out std_logic_vector(1 downto 0);
        o_vec_highLowSelect      : out std_logic_vector(1 downto 0);
        o_vec_aluASelect         : out std_logic_vector(1 downto 0);
        o_vec_aluBSelect         : out std_logic_vector(1 downto 0);
        o_vec_concatenatorSelect : out std_logic_vector(1 downto 0);
        o_vec_aluOpSelect        : out std_logic_vector(5 downto 0);
        o_l_signedSelect    : out std_logic;
        --ENABLER
        o_l_pcEnable       : out std_logic;
        o_l_memWriteEnable : out std_logic;
        o_l_instrRegEnable : out std_logic;
        o_l_memDataEnable  : out std_logic;
        o_l_regEnable      : out std_logic;
        o_l_AEnable        : out std_logic;
        o_l_BEnable        : out std_logic;
        o_l_aluOutEnable   : out std_logic;
        o_l_hiEnable       : out std_logic;
        o_l_loEnable       : out std_logic;
        --GLOBAL RESET
        o_l_reset : out std_logic
    );
end L4_CtrlUnit;
architecture Behavioral of L4_CtrlUnit is
    type t_sta_fsm is (
        sta_reset, sta_instructionFetch, sta_registerFetch, --Pre-Calculation Steps for ALL Instructions
        sta_rExecution, sta_rCompletion, --All Other R-Type Instructions
        sta_iExecution, sta_iCompletion, --All Other I-Type Instructions
        sta_bExecution, sta_bProcessing, sta_bCompletion, --All Branch-Type Instructions
        sta_jCompletion, --All Jump-Type Instructions
        sta_mCompletion, --Multiplication Instructions
        sta_cCompletion, --Count Leading Ones Instructions
        sta_lExecution, sta_lProcessing, sta_lCompletion, --All Load-Type Instructions
        sta_sExecution, sta_sCompletion, --All Store-Type Instructions
        sta_kExecution, sta_kProcessing, sta_kCompletion --ALL Link-Type instructions
    );
    signal s_sta_prev, s_sta_next : t_sta_fsm;
    signal s_vec_func             : std_logic_vector(5 downto 0);
begin
    s_vec_func <= i_vec_cdrImd(5 downto 0);
    --Section 1: FSM Register
    process (i_rst_reset, i_clk_clock)
    begin
        if i_rst_reset = '1' then
            s_sta_prev <= sta_reset;
        elsif (i_clk_clock'event and i_clk_clock = '1') then
            s_sta_prev <= s_sta_next;
        end if;
    end process;

    --Section 2: Next State Function
    process (i_vec_Op, s_sta_prev, s_vec_func)
    begin
        case s_sta_prev is
            when sta_reset =>
                s_sta_next <= sta_instructionFetch;
            when sta_instructionFetch =>
                s_sta_next <= sta_registerFetch;
            when sta_registerFetch =>
                ------MILESTONE 1
                if (i_vec_Op = "000000") then
                    if (s_vec_func = "001000") then
                        s_sta_next <= sta_jCompletion;--Op = R-Type::JR (Milestone 3)
                    elsif (s_vec_func = "011001" or s_vec_func = "010000" or s_vec_func = "010010") then
                        s_sta_next <= sta_mCompletion;--Op = R-Type::MULTU/MFHI/MFLO (Milestone 4)
                    else
                        s_sta_next <= sta_rExecution;--Op = R-Type::ADDU/AND/SUB/SRA/SLLV/SLL (Milestone 2)
                    end if;
                elsif (i_vec_Op = "001000" or i_vec_Op = "001101" or i_vec_Op = "001010" or i_vec_Op = "001111") then --Op = I_Type::ADDI/ORI/SLTI/LUI (Milestone 3)
                    s_sta_next <= sta_iExecution;
                elsif (i_vec_Op = "000010") then
                    s_sta_next <= sta_jCompletion;--Op = J-Type::J (Milestone 3)
                elsif (i_vec_Op = "000101") then
                    s_sta_next <= sta_bExecution;--Op = I-Type::BNE (Milestone 3)
                elsif (i_vec_Op = "011100" and s_vec_func = "100001") then
                    s_sta_next <= sta_cCompletion;--Op = I-Type::CLO (Milestone 5)
                elsif (i_vec_Op = "100011" or i_vec_Op = "100001" or i_vec_Op = "100000") then
                    s_sta_next <= sta_lExecution;--Op = I-Type::LW/LH/LB (Milestone 4)
                elsif (i_vec_Op = "101011") then
                    s_sta_next <= sta_sExecution;--Op = I-Type::SW (Milestone 4)
                elsif (i_vec_Op = "000001") then
                    s_sta_next <= sta_kExecution;--Op = I-Type::BLTZAL (Milestone 5)
                end if;
            when sta_rExecution =>
                s_sta_next <= sta_rCompletion;
            when sta_rCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_iExecution =>
                s_sta_next <= sta_iCompletion;
            when sta_iCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_bExecution =>
                s_sta_next <= sta_bProcessing;
            when sta_bProcessing =>
                s_sta_next <= sta_bCompletion;
            when sta_bCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_jCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_mCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_cCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_lExecution =>
                s_sta_next <= sta_lProcessing;
            when sta_lProcessing =>
                s_sta_next <= sta_lCompletion;
            when sta_lCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_sExecution =>
                s_sta_next <= sta_sCompletion;
            when sta_sCompletion =>
                s_sta_next <= sta_instructionFetch;
            when sta_kExecution =>
                s_sta_next <= sta_kProcessing;
            when sta_kProcessing =>
                s_sta_next <= sta_kCompletion;
            when sta_kCompletion =>
                s_sta_next <= sta_instructionFetch;
        end case;
    end process;

    --Section 3: Output Function
    process (i_vec_Op, s_sta_prev)
    begin
        case s_sta_prev is
            when sta_reset =>
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00001";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Use ALU::ADD by pretending to be addi
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '1';
                ----------------------------------------------------------------------------------------------------------------------
            when sta_instructionFetch => --Instruction Fetch
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00010";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '1';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------
            when sta_registerFetch => --Instruction Decode & Registers Fetch
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00011";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '1';--A
                o_l_BEnable        <= '1';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------
            when sta_rExecution => --R-Type Execution
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00100";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:                
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------				
            when sta_rCompletion => --R-Type Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00101";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "01";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Use ALU::ADD by pretending to be addi
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '1';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------				
            when sta_iExecution => --I-Type Execution 
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00110";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "10";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                if(i_vec_op = "001101") then
                    o_l_signedSelect    <= '0';
                else
                    o_l_signedSelect    <= '1';
                end if;
                ----------------------------------------------------------------------------------------------------------------------				
            when sta_iCompletion => --I-Type Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "00111";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Use ALU::ADD by pretending to be addi
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '1';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------	
            when sta_bExecution => --Branch Execution
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01000";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "11";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "101011"; -- Borrow Op-Code from SW
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------	
            when sta_bProcessing => --Branch Processing
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01001";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op; -- ALU::SUB
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------		
            when sta_bCompletion => --Branch Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01010";
                ----SELECTOR
                --o_vec_pcSelect      <= "01";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Use ALU::ADD by pretending to be addi
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                if (i_l_aluZero = '0') then -- NOT EQUAL
                    o_vec_pcSelect <= "01";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                else -- EQUAL
                    o_vec_pcSelect <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                end if;
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------				
            when sta_jCompletion => --Jump Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01011";
                ----SELECTOR
                o_vec_pcSelect          <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "11";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                --o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------			
                if (i_vec_Op = "000000") then --J-Type::JR
                    o_vec_aluOpSelect        <= i_vec_Op;
                else --J-Type::J
                    o_vec_aluOpSelect        <= "101011";
                end if;
            when sta_mCompletion => --Multiplication Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                --s_vec_func = "011001" or s_vec_func = "010000" or s_vec_func = "010010")
                o_vec_stateNum <= "01100";
                ----SELECTOR
                o_vec_pcSelect     <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect    <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect <= "01";--00:Inst20-16		01:Inst15-0		10:					11:
                --o_vec_wrtDataSelect <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                --o_vec_highLowSelect <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                --o_l_regEnable      <= '0';--Registers
                o_l_AEnable      <= '0';--A
                o_l_BEnable      <= '0';--B
                o_l_aluOutEnable <= '0';--ALUOut
                --o_l_hiEnable     <= '1';--High Bits from Multiplication
                --o_l_loEnable     <= '1';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                if (s_vec_func = "011001") then --R-Type::MULTU
                    o_vec_wrtDataSelect <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                    o_vec_highLowSelect <= "00";--00:High Register    01:Low Register 10:					11:
                    o_l_regEnable       <= '0';--Registers
                    o_l_hiEnable        <= '1';--High Bits from Multiplication
                    o_l_loEnable        <= '1';--Low Bits from Multiplication
                elsif (s_vec_func = "010000") then --R-Type::MFHI
                    o_vec_wrtDataSelect <= "10";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                    o_vec_highLowSelect <= "00";--00:High Register    01:Low Register 10:					11:
                    o_l_regEnable       <= '1';--Registers
                    o_l_hiEnable        <= '0';--High Bits from Multiplication
                    o_l_loEnable        <= '0';--Low Bits from Multiplication
                elsif (s_vec_func = "010010") then --R-Type::MFLO
                    o_vec_wrtDataSelect <= "10";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                    o_vec_highLowSelect <= "01";--00:High Register    01:Low Register 10:					11:
                    o_l_regEnable       <= '1';--Registers
                    o_l_hiEnable        <= '0';--High Bits from Multiplication
                    o_l_loEnable        <= '0';--Low Bits from Multiplication
                end if;
                ----------------------------------------------------------------------------------------------------------------------			
            when sta_cCompletion => --Count Leading Ones Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01101";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "01";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "11";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Use ALU::ADD by pretending to be addi
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '1';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------			
            when sta_lExecution => --Load Memory Address Computation
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01110";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "10";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000"; --ALU::ADD using I-Type::ADDI
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------
            when sta_lProcessing => --Load Memory Address Access
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "01111";
                ----SELECTOR
                o_vec_pcSelect      <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect     <= "01";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect  <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect    <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect    <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                --o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '1';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                if (i_vec_Op = "100011") then
                    o_vec_concatenatorSelect <= "01";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                elsif (i_vec_Op = "100001") then
                    o_vec_concatenatorSelect <= "10";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                elsif (i_vec_Op = "100000") then
                    o_vec_concatenatorSelect <= "11";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                end if;
                ----------------------------------------------------------------------------------------------------------------------				
            when sta_lCompletion => --Load Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "10000";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "01";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '1';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------			
            when sta_sExecution => --Store Memory Address Computation
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "10001";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "01";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "10";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000"; --ALU::ADD using I-Type::ADDI
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------			
            when sta_sCompletion => --Store Completion
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "10010";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "01";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '1';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------
            when sta_kExecution => --Link Execution (Temporarily store PC<<2 into ALUOut)
                o_vec_stateNum <= "10011";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "01";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "001000";--Borrow ALU::ADD
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '1';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                ----------------------------------------------------------------------------------------------------------------------			
            when sta_kProcessing => --Link Processing (Calculate Zero from Comparing rt and zero)
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "10100";
                ----SELECTOR
                o_vec_pcSelect           <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "00";--00:Inst20-16		01:Inst15-0		10:					11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "01";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "00";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= i_vec_Op;
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '0';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                o_l_regEnable      <= '0';--Registers
                o_l_AEnable        <= '0';--A
                o_l_BEnable        <= '0';--B
                o_l_aluOutEnable   <= '0';--ALUOut
                o_l_hiEnable       <= '0';--High Bits from Multiplication
                o_l_loEnable       <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
            when sta_kCompletion => --Link Completion (Store PC<<2 to PC if zero=0 || Store PC<<2 to GPR31 and offset<<2 to PC if zero=1 && Calculate Offset Addr)
                ------------------OUTPUT VALUE DEFINITION BLOCK-----------------------------------------------------------------------
                o_vec_stateNum <= "10101";
                ----SELECTOR
                --o_vec_pcSelect           <= "01";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                o_vec_adrSelect          <= "00";--00:PC			    01:ALUOut		10:					11:
                o_vec_wrtRegSelect       <= "10";--00:Inst20-16		01:Inst15-0		    10:	31 constant		11:
                o_vec_wrtDataSelect      <= "00";--00:ALUOut		    01:MemDataReg	10:Mtplictn Hi/Lo   11:LeadingOnes
                o_vec_highLowSelect      <= "00";--00:High Register    01:Low Register 10:					11:
                o_vec_aluASelect         <= "00";--00:PC			    01:RegA			10:					11:
                o_vec_aluBSelect         <= "11";--00:RegB			    01:4 (CONSTANT)	10:SignExtended		11:ShiftLeft2
                o_vec_concatenatorSelect <= "00";--00:HalfWord(Upper)   01:Word(Ori)    10:HalfWord(Lower)  11:Byte(Lower)
                o_vec_aluOpSelect        <= "101011";--Borrow Op-Code from Sw to Keep B
                o_l_signedSelect    <= '1';
                ----ENABLER
                o_l_pcEnable       <= '1';--Program Counter
                o_l_memWriteEnable <= '0';--Memory :: Write
                o_l_instrRegEnable <= '0';--Instruction Register
                o_l_memDataEnable  <= '0';--Memory Data Register
                --o_l_regEnable      <= '0';--Registers
                o_l_AEnable      <= '0';--A
                o_l_BEnable      <= '0';--B
                o_l_aluOutEnable <= '1';--ALUOut
                o_l_hiEnable     <= '0';--High Bits from Multiplication
                o_l_loEnable     <= '0';--Low Bits from Multiplication
                --GLOBAL RESET
                o_l_reset <= '0';
                if (i_l_aluZero = '0') then-- jump and link
                    o_vec_pcSelect <= "00";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                    o_l_regEnable  <= '1';--Registers
                else --do not jump or link, simply put aluOUt into PC
                    o_vec_pcSelect <= "01";--00:ALUResult		01:ALUOut		10:ShiftLeft2		11:
                    o_l_regEnable  <= '0';--Registers
                end if;

        end case;

    end process;

end Behavioral;