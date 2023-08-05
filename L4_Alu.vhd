----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2021 11:39:41 PM
-- Design Name: 
-- Module Name: L4_Alu - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity L4_Alu is
    port (
        i_vec_aluOp      : in std_logic_vector(3 downto 0);
        i_vec_shamt      : in std_logic_vector(4 downto 0);
        i_l_shiftPortCtr : in std_logic;
        i_vec_dataInA    : in std_logic_vector(31 downto 0);
        i_vec_dataInB    : in std_logic_vector(31 downto 0);
        o_vec_dataOutR   : out std_logic_vector(31 downto 0);
        o_l_zero         : out std_logic
    );
end L4_Alu;

architecture Behavioral of L4_Alu is
    signal s_vec_dataOutR : std_logic_vector(31 downto 0);
begin
    o_l_zero <= '1' when s_vec_dataOutR = x"00000000" else
        '0';
    o_vec_dataOutR <= s_vec_dataOutR;
    process (i_vec_dataInA, i_vec_dataInB, i_vec_aluOp, i_l_shiftPortCtr, i_vec_shamt)
    begin
        case(i_vec_aluOp) is
            when "0000" => -- LOGIC: AND
            s_vec_dataOutR <= i_vec_dataInA and i_vec_dataInB;
            when "0001" => -- LOGIC: OR
            s_vec_dataOutR <= i_vec_dataInA or i_vec_dataInB;
            when "0010" => -- LOGIC: XOR
            s_vec_dataOutR <= i_vec_dataInA xor i_vec_dataInB;
            when "0011" => -- LOGIC: NOR
            s_vec_dataOutR <= i_vec_dataInA nor i_vec_dataInB;
            when "0100" => -- ARITH: ADD
            s_vec_dataOutR <= std_logic_vector(signed(i_vec_dataInA) + signed(i_vec_dataInB));
            when "0101" => -- ARITH: ADDU
            s_vec_dataOutR <= std_logic_vector(unsigned(i_vec_dataInA) + unsigned(i_vec_dataInB));
            when "0110" => -- ARITH: SUB
            s_vec_dataOutR <= std_logic_vector(signed(i_vec_dataInA) - signed(i_vec_dataInB));
            when "0111" => -- ARITH: SUBU
            s_vec_dataOutR <= std_logic_vector(unsigned(i_vec_dataInA) - unsigned(i_vec_dataInB));
            when "1000" => -- SPECIAL: SLLV
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= std_logic_vector(shift_left(unsigned(i_vec_dataInA), to_integer(unsigned(i_vec_dataInB))));
            else
                s_vec_dataOutR <= std_logic_vector(shift_left(unsigned(i_vec_dataInB), to_integer(unsigned(i_vec_dataInA))));
            end if;
            when "1001" => -- SPECIAL: KEEP (used in J and JR)
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= i_vec_dataInA;
            else
                s_vec_dataOutR <= i_vec_dataInB;
            end if;
            when "1010" => -- COMPR: SLT
            if (i_l_shiftPortCtr = '0') then
                if (signed(i_vec_dataInA) < signed(i_vec_dataInB)) then
                    s_vec_dataOutR <= x"00000001";
                else
                    s_vec_dataOutR <= x"00000000";
                end if;
            else
                if (signed(i_vec_dataInA) < to_signed(0, 32)) then
                    s_vec_dataOutR <= x"00000001";
                else
                    s_vec_dataOutR <= x"00000000";
                end if;
            end if;
            when "1011" => -- COMPR: SLTU
            if (unsigned(i_vec_dataInA) < unsigned(i_vec_dataInB)) then
                s_vec_dataOutR <= x"00000001";
            else
                s_vec_dataOutR <= x"00000000";
            end if;
            when "1100" => -- SHIFT: SLL
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= std_logic_vector(shift_left(unsigned(i_vec_dataInA), to_integer(unsigned(i_vec_shamt))));
            else
                s_vec_dataOutR <= std_logic_vector(shift_left(unsigned(i_vec_dataInB), to_integer(unsigned(i_vec_shamt))));
            end if;
            when "1101" => -- SHIFT: SLA
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= std_logic_vector(shift_left(signed(i_vec_dataInA), to_integer(unsigned(i_vec_shamt))));
            else
                s_vec_dataOutR <= std_logic_vector(shift_left(signed(i_vec_dataInB), to_integer(unsigned(i_vec_shamt))));
            end if;
            when "1110" => -- SHIFT: SRL
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= std_logic_vector(shift_right(unsigned(i_vec_dataInA), to_integer(unsigned(i_vec_shamt))));
            else
                s_vec_dataOutR <= std_logic_vector(shift_right(unsigned(i_vec_dataInB), to_integer(unsigned(i_vec_shamt))));
            end if;
            when "1111" => -- SHIFT: SRA
            if (i_l_shiftPortCtr = '0') then
                s_vec_dataOutR <= std_logic_vector(shift_right(signed(i_vec_dataInA), to_integer(unsigned(i_vec_shamt))));
            else
                s_vec_dataOutR <= std_logic_vector(shift_right(signed(i_vec_dataInB), to_integer(unsigned(i_vec_shamt))));
            end if;
            when others => --BOUNDARY CASES
            s_vec_dataOutR <= x"00000000";
        end case;
    end process;
end Behavioral;