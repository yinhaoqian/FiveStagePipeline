----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2021 03:31:42 PM
-- Design Name: 
-- Module Name: B_Register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: custom bit register
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Tested by B_Register_Testbench.vhd
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

entity I_Register is
	generic (
		width: positive := 64
	);
	port (
		i_clk_clock: in std_logic;
		i_rst_reset: in std_logic;
		i_l_enable: in std_logic;
		i_vec_dataIn: in std_logic_vector(width-1 downto 0);
		o_vec_dataOut: out std_logic_vector(width-1 downto 0)
	);
end I_Register;

architecture Behavioral of I_Register is

begin

	syncDetect:
	process(i_clk_clock,i_rst_reset)
	begin
		if i_rst_reset = '1' then
			o_vec_dataOut <= std_logic_vector(to_unsigned(0,width));
		elsif(i_clk_clock'event and i_clk_clock = '1') then
			if i_l_enable = '1'  then
				o_vec_dataOut <= i_vec_dataIn;
			end if;
		end if;		
	end process;

end Behavioral;
