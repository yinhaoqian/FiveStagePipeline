----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2021 09:41:40 PM
-- Design Name: 
-- Module Name: L4_LeadingOnesCounter - Behavioral
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

entity L4_LeadingOnesCounter is
    port (
        i_vec_dataIn    : in std_logic_vector(31 downto 0);
        o_vec_onesCount : out std_logic_vector(31 downto 0)
    );
end L4_LeadingOnesCounter;

architecture Behavioral of L4_LeadingOnesCounter is

begin

    process (i_vec_dataIn)
        variable v_int_count     : integer;
        variable v_boo_stopCount : boolean;
    begin
        v_int_count     := 0;
        v_boo_stopCount := false;
        for v_int_iter in 31 downto 0 loop
            if (v_boo_stopCount = false) then
                if (i_vec_dataIn(v_int_iter) = '1') then
                    v_int_count := v_int_count + 1;
                elsif (i_vec_dataIn(v_int_iter) = '0') then
                    v_boo_stopCount := true;
                end if;
            end if;
        end loop;
        o_vec_onesCount <= std_logic_vector(to_unsigned(v_int_count, 32));
    end process;

end Behavioral;