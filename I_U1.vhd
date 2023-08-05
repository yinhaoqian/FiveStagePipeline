-- Created: by - Amr Mahmoud

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity I_U1 is
    port (
        Clk      : in std_logic;
        MemWrite : in std_logic;
        addr     : in std_logic_vector (31 downto 0);
        dataIn   : in std_logic_vector (31 downto 0);
        dataOut  : out std_logic_vector (31 downto 0)
    );

    -- Declarations
end I_U1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
architecture struct of I_U1 is

    -- Architecture declarations

    -- Internal signal declarations
    signal addr1 : std_logic_vector(3 downto 0);
    signal dout  : std_logic;
    -- ModuleWare signal declarations(v1.9) for instance 'U_0' of 'ramsp'
    type MW_U_0RAM_TYPE is array (((2 ** 4) - 1) downto 0) of std_logic_vector(31 downto 0);
    signal mw_U_0ram_table : MW_U_0RAM_TYPE := (others => "00000000000000000000000000000000");
    signal mw_U_0addr_reg  : std_logic_vector(3 downto 0);
begin
    -- Architecture concurrent statements
    -- HDL Embedded Text Block 2 eb2
    addr1 <= addr(5 downto 2);

    -- ModuleWare code(v1.9) for instance 'U_2' of 'inv'
    dout <= not(Clk);

    -- ModuleWare code(v1.9) for instance 'U_0' of 'ramsp'
    --attribute block_ram : boolean;
    --attribute block_ram of mem : signal is false;
    u_0ram_p_proc : process (dout)
    begin
        if (dout'EVENT and dout = '1') then
            if (MemWrite = '1') then
                mw_U_0ram_table(CONV_INTEGER(unsigned(addr1))) <= dataIn;
            end if;
            mw_U_0addr_reg <= addr1;
        end if;
    end process u_0ram_p_proc;
    dataOut <= mw_U_0ram_table(CONV_INTEGER(unsigned(mw_U_0addr_reg)));

    -- Instance port mappings.

end struct;