----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2021 12:26:00 PM
-- Design Name: 
-- Module Name: L4_Registers - Behavioral
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

entity L4_Registers is
    port (
        i_clk_clock         : in std_logic;
        i_rst_reset         : in std_logic;
        i_l_enable          : in std_logic;
        i_vec_readRegister1 : in std_logic_vector(4 downto 0);
        i_vec_readRegister2 : in std_logic_vector(4 downto 0);
        i_vec_writeRegister : in std_logic_vector(4 downto 0);
        i_vec_writeData     : in std_logic_vector(31 downto 0);
        o_vec_readData1     : out std_logic_vector(31 downto 0);
        o_vec_readData2     : out std_logic_vector(31 downto 0)
    );
end L4_Registers;

architecture Behavioral of L4_Registers is
    type t_arr_registers is array(0 to 31) of std_logic_vector(31 downto 0);
    signal s_vec_dataInHotCode     : std_logic_vector(31 downto 0);
    signal s_vec_dataInHotCodePost : std_logic_vector(31 downto 0);
    --signal s_arr_dataIn : t_arr_registers;
    signal s_arr_dataOut : t_arr_registers;
    component I_Register is
        generic (
            width : positive := 64
        );
        port (
            i_clk_clock   : in std_logic;
            i_rst_reset   : in std_logic;
            i_l_enable    : in std_logic;
            i_vec_dataIn  : in std_logic_vector(width - 1 downto 0);
            o_vec_dataOut : out std_logic_vector(width - 1 downto 0)
        );
    end component;
    component L4_Decoder is
        generic (
            g_pos_width : positive := 5
        );
        port (
            i_vec_dataIn  : in std_logic_vector(g_pos_width - 1 downto 0);
            o_vec_dataOut : out std_logic_vector(2 ** g_pos_width - 1 downto 0)
        );
    end component;
begin

    o_vec_readData1 <= s_arr_dataOut(to_integer(unsigned(i_vec_readRegister1)));
    o_vec_readData2 <= s_arr_dataOut(to_integer(unsigned(i_vec_readRegister2)));

    l_cmp_decoderForWrite : L4_Decoder
    generic map(5)
    port map(i_vec_writeRegister, s_vec_dataInHotCode);

    l_forgen_register :
    for v_int_iter in 0 to 31 generate
        l_cmp_register : I_Register
        generic map(32)
        port map(
            i_clk_clock   => i_clk_clock,
            i_rst_reset   => i_rst_reset,
            i_l_enable    => s_vec_dataInHotCodePost(v_int_iter),
            i_vec_dataIn  => i_vec_writeData,
            o_vec_dataOut => s_arr_dataOut(v_int_iter)
        );
    end generate;

    l_forgen_convert :
    for v_int_iter in 0 to 31 generate
        s_vec_dataInHotCodePost(v_int_iter) <= s_vec_dataInHotCode(v_int_iter) and i_l_enable;
    end generate;
end Behavioral;