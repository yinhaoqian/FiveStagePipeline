----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2021 01:50:17 PM
-- Design Name: 
-- Module Name: L4_AluCtrl - Behavioral
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

entity L4_AluCtrl is
    port (
        i_vec_instr31To26  : in std_logic_vector(5 downto 0);
        i_vec_instr15To0   : in std_logic_vector(15 downto 0);
        o_vec_aluOp        : out std_logic_vector(3 downto 0);
        o_vec_shamt        : out std_logic_vector(4 downto 0);
        o_vec_shiftPortCtr : out std_logic
    );
end L4_AluCtrl;

architecture Behavioral of L4_AluCtrl is
    signal s_vec_op           : std_logic_vector(5 downto 0);
    signal s_vec_func         : std_logic_vector(5 downto 0);
    signal s_vec_aluOpForFunc : std_logic_vector(3 downto 0);
begin
    s_vec_op   <= i_vec_instr31To26; --Extracted 6bit Op-code from instruction
    s_vec_func <= i_vec_instr15To0(5 downto 0); --Extracted 6bit Func-code from instruction
    process (s_vec_op, s_vec_func)
    begin
        o_vec_shamt        <= "00000";
        o_vec_shiftPortCtr <= '0';
        if (s_vec_op = "001000") then --I-Type::ADDI (Milestone 3)
            o_vec_aluOp <= "0100"; --ALU::ADD
        elsif (s_vec_op = "000000" and s_vec_func = "100001") then --R-Type::ADDU (Milestone 2)
            o_vec_aluOp <= "0101"; --ALU::ADDU
        elsif (s_vec_op = "000000" and s_vec_func = "100100") then --R-Type::AND (Milestone 2)
            o_vec_aluOp <= "0000"; --ALU::AND
        elsif (s_vec_op = "000001") then --BLTZAL (Milestone 5)
            o_vec_aluOp        <= "1010"; --ALU::SLT
            o_vec_shiftPortCtr <= '1';
        elsif (s_vec_op = "000101") then --B-Type::BNE (Milestone 3)
            o_vec_aluOp <= "0110"; --ALU::SUB
        elsif (s_vec_op = "000010") then --J-Type::J (Milestone 3)
            o_vec_aluOp <= "1001"; --ALU::KEEP
        elsif (s_vec_op = "000000" and s_vec_func = "001000") then --JR (Milestone 3)
            o_vec_aluOp <= "1001"; --ALU::KEEP
        elsif (s_vec_op = "001111") then --I-Type::LUI (Milestone 4)
            o_vec_aluOp        <= "1100"; --ALU::SLL
            o_vec_shiftPortCtr <= '1';
            o_vec_shamt        <= "10000";
        elsif (s_vec_op = "001101") then --I-Type::ORI (Milestone 3)
            o_vec_aluOp <= "0001"; --ALU::OR
        elsif (s_vec_op = "000000" and s_vec_func = "000000") then --R-Type::SLL (Milestone 2)
            o_vec_aluOp        <= "1100"; --ALU::SLL
            o_vec_shamt        <= i_vec_instr15To0(10 downto 6);
            o_vec_shiftPortCtr <= '1';
        elsif (s_vec_op = "000000" and s_vec_func = "000100") then --R-Type::SLLV (Milestone 2)
            o_vec_aluOp        <= "1000"; --ALU::SLLV
            o_vec_shiftPortCtr <= '1';
        elsif (s_vec_op = "001010") then --I-Type::SLTI (Milestone 3)
            o_vec_aluOp <= "1010"; --ALU::SLT
        elsif (s_vec_op = "000000" and s_vec_func = "000011") then --R-Type::SRA (Milestone 2)
            o_vec_aluOp        <= "1111"; --ALU::SRA
            o_vec_shamt        <= i_vec_instr15To0(10 downto 6);
            o_vec_shiftPortCtr <= '1';
        elsif (s_vec_op = "000000" and s_vec_func = "100010") then --R-Type::SUB (Milestone 2)
            o_vec_aluOp <= "0110"; --ALU::SUB
        elsif (s_vec_op = "101011") then --SW
            o_vec_aluOp        <= "1001"; --ALU::KEEP
            o_vec_shiftPortCtr <= '1';
        end if;
    end process;

end Behavioral;