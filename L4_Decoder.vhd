----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2021 04:09:28 PM
-- Design Name: 
-- Module Name: L4_Decoder - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity L4_Decoder is
	generic(
		g_pos_width: positive := 5
	);	
	port(
		i_vec_dataIn: in std_logic_vector(g_pos_width-1 downto 0);
		o_vec_dataOut: out std_logic_vector(2**g_pos_width-1 downto 0)
	);
end L4_Decoder;

architecture Behavioral of L4_Decoder is
	

begin
	process(i_vec_dataIn)
	variable v_vec_dataOut: std_logic_vector(2**g_pos_width-1 downto 0);
	begin
		v_vec_dataOut := std_logic_vector(to_unsigned(0,2**g_pos_width));
		v_vec_dataOut(to_integer(unsigned(i_vec_dataIn))):='1';
		o_vec_dataOut <= v_vec_dataOut;
	end process;

end Behavioral;
