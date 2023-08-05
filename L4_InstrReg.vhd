----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2021 03:07:52 PM
-- Design Name: 
-- Module Name: L4_InstrReg - Behavioral
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

entity L4_InstrReg is
	port (
		i_clk_clock : in std_logic;
		i_rst_reset : in std_logic;
		i_l_enable : in std_logic;
		i_vec_dataIn : in std_logic_vector(31 downto 0);
		o_vec_opOut : out std_logic_vector(5 downto 0);
		o_vec_rsOut : out std_logic_vector(4 downto 0);
		o_vec_rtOut : out std_logic_vector(4 downto 0);
		o_vec_adrImd : out std_logic_vector(15 downto 0)
	);
end L4_InstrReg;

architecture Behavioral of L4_InstrReg is
	component I_Register is
		generic (
			width : positive := 64
		);
		port (
			i_clk_clock : in std_logic;
			i_rst_reset : in std_logic;
			i_l_enable : in std_logic;
			i_vec_dataIn : in std_logic_vector(width - 1 downto 0);
			o_vec_dataOut : out std_logic_vector(width - 1 downto 0)
		);
	end component;
begin
	l_cmp_reg3 : I_Register
	generic map(6)
	port map(i_clk_clock, i_rst_reset, i_l_enable, i_vec_dataIn(31 downto 26), o_vec_opOut);

	l_cmp_reg2 : I_Register
	generic map(5)
	port map(i_clk_clock, i_rst_reset, i_l_enable, i_vec_dataIn(25 downto 21), o_vec_rsOut);

	l_cmp_reg1 : I_Register
	generic map(5)
	port map(i_clk_clock, i_rst_reset, i_l_enable, i_vec_dataIn(20 downto 16), o_vec_rtOut);

	l_cmp_reg0 : I_Register
	generic map(16)
	port map(i_clk_clock, i_rst_reset, i_l_enable, i_vec_dataIn(15 downto 0), o_vec_adrImd);

end Behavioral;


