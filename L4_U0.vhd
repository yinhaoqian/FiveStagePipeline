----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2021 01:21:35 PM
-- Design Name: 
-- Module Name: U_0 - Behavioral
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

entity L4_U0 is
    port (
        Reset         : in std_logic;
        Clock         : in std_logic;
        MemoryDataIn  : in std_logic_vector(31 downto 0);
        MemoryAddress : out std_logic_vector(31 downto 0);
        MemoryDataOut : out std_logic_vector(31 downto 0);
        MemWrite      : out std_logic
    );
end L4_U0;

architecture Behavioral of L4_U0 is
    component L4_Milestone is
        port (
            i_clk_clock                : in std_logic; ---Clock
            i_rst_reset                : in std_logic; ---Reset
            i_vec_dataOutFromMem       : in std_logic_vector(31 downto 0);---Memory DataIn
            o_l_memWriteEnable         : out std_logic; ---MemWrite
            o_vec_dataOutFromMuxAdr    : out std_logic_vector(31 downto 0); ---Memory Address
            o_vec_dataOutFromRegisterB : out std_logic_vector(31 downto 0) ---Memory DataOut
        );
    end component;
begin
    l_cmp_milestone : L4_Milestone
    port map(
        i_clk_clock                => Clock,
        i_rst_reset                => Reset,
        i_vec_dataOutFromMem       => MemoryDataIn,
        o_l_memWriteEnable         => MemWrite,
        o_vec_dataOutFromMuxAdr    => MemoryAddress,
        o_vec_dataOutFromRegisterB => MemoryDataOut
    );
end Behavioral;