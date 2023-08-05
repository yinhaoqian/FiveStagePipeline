----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2021 01:41:22 PM
-- Design Name: 
-- Module Name: cpu_tb - Behavioral
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

entity cpu_tb is
    port (
        reset : in std_logic;
        clk : in std_logic
    );
end cpu_tb;

architecture Behavioral of cpu_tb is
    component L4_U0 is
        port (
            Reset         : in std_logic;
            Clock         : in std_logic;
            MemoryDataIn  : in std_logic_vector(31 downto 0);
            MemoryAddress : out std_logic_vector(31 downto 0);
            MemoryDataOut : out std_logic_vector(31 downto 0);
            MemWrite      : out std_logic
        );
    end component;
    component I_U1 is
        port (
            Clk      : in std_logic;
            addr     : in std_logic_vector(31 downto 0);
            dataIn   : in std_logic_vector(31 downto 0);
            MemWrite : in std_logic;
            dataOut  : out std_logic_vector(31 downto 0)
        );
    end component;
    signal s_clk_clock               : std_logic;
    signal s_rst_reset               : std_logic;
    signal s_vec_MemoryAddressFromU0 : std_logic_vector(31 downto 0);
    signal s_vec_MemoryDataOutFromU0 : std_logic_vector(31 downto 0);
    signal s_l_MemWriteFromU0        : std_logic;
    signal s_vec_dataOutFromU1       : std_logic_vector(31 downto 0);
begin
    s_clk_clock <= clk;
    s_rst_reset <= reset;
    U_0 : L4_U0
    port map(
        Reset         => s_rst_reset,
        Clock         => s_clk_clock,
        MemoryDataIn  => s_vec_dataOutFromU1,
        MemoryAddress => s_vec_MemoryAddressFromU0,
        MemoryDataOut => s_vec_MemoryDataOutFromU0,
        MemWrite      => s_l_MemWriteFromU0
    );

    U_1 : I_U1
    port map(
        Clk      => s_clk_clock,
        addr     => s_vec_MemoryAddressFromU0,
        dataIn   => s_vec_MemoryDataOutFromU0,
        MemWrite => s_l_MemWriteFromU0,
        dataOut  => s_vec_dataOutFromU1
    );
end Behavioral;