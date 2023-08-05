----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2021 08:46:15 PM
-- Design Name: 
-- Module Name: L4_Multiplexier - Behavioral
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

entity L4_Multiplexier is
	generic (
		g_pos_Width : positive := 32
	);
	port (
		i_vec_selector : in std_logic_vector(1 downto 0);
		i_vec_dataIn0 : in std_logic_vector(g_pos_Width - 1 downto 0);
		i_vec_dataIn1 : in std_logic_vector(g_pos_Width - 1 downto 0);
		i_vec_dataIn2 : in std_logic_vector(g_pos_Width - 1 downto 0);
		i_vec_dataIn3 : in std_logic_vector(g_pos_Width - 1 downto 0);
		o_vec_dataOut : out std_logic_vector(g_pos_Width - 1 downto 0)
	);
end L4_Multiplexier;

architecture Behavioral of L4_Multiplexier is

begin
	with i_vec_selector select o_vec_dataOut <=
		i_vec_dataIn0 when "00",
		i_vec_dataIn1 when "01",
		i_vec_dataIn2 when "10",
		i_vec_dataIn3 when "11",
		i_vec_dataIn0 when others;
end Behavioral;