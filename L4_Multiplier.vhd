----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2021 02:03:01 PM
-- Design Name: 
-- Module Name: L4_Multiplier - Behavioral
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

entity L4_Multiplier is
    port (
        i_vec_dataIn1     : in std_logic_vector(31 downto 0);
        i_vec_dataIn2     : in std_logic_vector(31 downto 0);
        o_vec_dataOutHigh : out std_logic_vector(31 downto 0);
        o_vec_dataOutLow  : out std_logic_vector(31 downto 0)
    );
end L4_Multiplier;

architecture Behavioral of L4_Multiplier is
    signal s_vec_dataOut : std_logic_vector(63 downto 0);
begin
    s_vec_dataOut     <= std_logic_vector(unsigned(i_vec_dataIn1) * unsigned(i_vec_dataIn2));
    o_vec_dataOutHigh <= s_vec_dataOut(63 downto 32);
    o_vec_dataOutLow  <= s_vec_dataOut(31 downto 0);
end Behavioral;