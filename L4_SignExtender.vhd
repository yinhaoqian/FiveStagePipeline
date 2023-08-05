----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 05:16:36 PM
-- Design Name: 
-- Module Name: L4_SignExtender - Behavioral
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

entity L4_SignExtender is
    port (
        i_vec_dataIn       : in std_logic_vector(15 downto 0);
        i_vec_opIn: in std_logic_vector(5 downto 0);
        o_vec_signExtended : out std_logic_vector(31 downto 0);
        o_vec_leftShifted  : out std_logic_vector(31 downto 0)
    );
end L4_SignExtender;

architecture Behavioral of L4_SignExtender is
    signal s_vec_signExtended : std_logic_vector(31 downto 0);
begin
    s_vec_signExtended(31 downto 16) <= "0000000000000000" when i_vec_opIn  ="001101" else
                                        "1111111111111111" when i_vec_dataIn(15) = '1' else 
                                        "0000000000000000";
    s_vec_signExtended(15 downto 0)  <= i_vec_dataIn;
    o_vec_signExtended               <= s_vec_signExtended;
    o_vec_leftShifted                <= s_vec_signExtended(29 downto 0) & "00";
end Behavioral;