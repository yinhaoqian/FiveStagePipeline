----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 05:29:31 PM
-- Design Name: 
-- Module Name: L4_LeftShifter - Behavioral
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

entity L4_LeftShifter is
    port (
        i_vec_rsIn     : in std_logic_vector(4 downto 0);
        i_vec_rtIn     : in std_logic_vector(4 downto 0);
        i_vec_adrImdIn : in std_logic_vector(15 downto 0);
        i_vec_pcIn     : in std_logic_vector(31 downto 0);
        o_vec_dataOut  : out std_logic_vector(31 downto 0)
    );
end L4_LeftShifter;

architecture Behavioral of L4_LeftShifter is
    signal s_vec_dataIn : std_logic_vector(25 downto 0);
begin
    s_vec_dataIn  <= i_vec_rsIn & i_vec_rtIn & i_vec_adrImdIn;
    o_vec_dataOut <= i_vec_pcIn(31 downto 28) & s_vec_dataIn & "00";
end Behavioral;