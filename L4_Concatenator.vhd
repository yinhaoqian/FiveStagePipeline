----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2021 09:39:11 PM
-- Design Name: 
-- Module Name: L4_Concatenator - Behavioral
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

entity L4_Concatenator is
    port (
        i_vec_dataIn   : in std_logic_vector(31 downto 0);
        i_vec_selector : in std_logic_vector(1 downto 0); --00:HalfWord(Upper)   01:Word(Original)     10:HalfWord(Lower)     11:Byte(Lower)
        o_vec_dataOut  : out std_logic_vector(31 downto 0)
    );
end L4_Concatenator;

architecture Behavioral of L4_Concatenator is
    signal s_vec_upperImmediate : std_logic_vector(31 downto 0);
    signal s_vec_word           : std_logic_vector(31 downto 0);
    signal s_vec_halfWord       : std_logic_vector(31 downto 0);
    signal s_vec_byte           : std_logic_vector(31 downto 0);
begin
    s_vec_upperImmediate                     <= std_logic_vector(resize(signed(i_vec_dataIn(31 downto 16)), 32));
    s_vec_word                               <= i_vec_dataIn;--NO NEED TO RESIZE HERE
    s_vec_halfWord                           <= std_logic_vector(resize(signed(i_vec_dataIn(31 downto 16)), 32));
    s_vec_byte                               <= std_logic_vector(resize(signed(i_vec_dataIn(31 downto 24)), 32));
    with i_vec_selector select o_vec_dataOut <=
        s_vec_upperImmediate when "00",
        s_vec_word when "01",
        s_vec_halfWord when "10",
        s_vec_byte when "11",
        x"00000000" when others;
end Behavioral;