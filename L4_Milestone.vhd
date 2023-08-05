----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2021 08:05:19 PM
-- Design Name: 
-- Module Name: L4_Milestone - Behavioral
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

entity L4_Milestone is
    port (
        i_clk_clock                : in std_logic; ---Clock
        i_rst_reset                : in std_logic; ---Reset
        i_vec_dataOutFromMem       : in std_logic_vector(31 downto 0);---Memory DataIn
        o_l_memWriteEnable         : out std_logic; ---MemWrite
        o_vec_dataOutFromMuxAdr    : out std_logic_vector(31 downto 0); ---Memory Address
        o_vec_dataOutFromRegisterB : out std_logic_vector(31 downto 0) ---Memory DataOut
    );
end L4_Milestone;

architecture Behavioral of L4_Milestone is
    ---Component Definitions:
    component L4_Alu is
        port (
            i_vec_aluOp      : in std_logic_vector(3 downto 0);
            i_vec_shamt      : in std_logic_vector(4 downto 0);
            i_l_shiftPortCtr : in std_logic;
            i_vec_dataInA    : in std_logic_vector(31 downto 0);
            i_vec_dataInB    : in std_logic_vector(31 downto 0);
            o_vec_dataOutR   : out std_logic_vector(31 downto 0);
            o_l_zero         : out std_logic
        );
    end component;
    component L4_AluCtrl is
        port (
            i_vec_instr31To26  : in std_logic_vector(5 downto 0);
            i_vec_instr15To0   : in std_logic_vector(15 downto 0);
            o_vec_aluOp        : out std_logic_vector(3 downto 0);
            o_vec_shamt        : out std_logic_vector(4 downto 0);
            o_vec_shiftPortCtr : out std_logic
        );
    end component;
    component L4_CtrlUnit is
        port (
            i_rst_reset    : in std_logic;
            i_clk_clock    : in std_logic;
            i_l_aluZero    : in std_logic;
            i_vec_Op       : in std_logic_vector(5 downto 0);
            i_vec_cdrImd   : in std_logic_vector(15 downto 0);
            o_vec_stateNum : out std_logic_vector(4 downto 0);--DEBUG ONLY
            --SELECTOR
            o_vec_pcSelect           : out std_logic_vector(1 downto 0);
            o_vec_adrSelect          : out std_logic_vector(1 downto 0);
            o_vec_wrtRegSelect       : out std_logic_vector(1 downto 0);
            o_vec_wrtDataSelect      : out std_logic_vector(1 downto 0);
            o_vec_highLowSelect      : out std_logic_vector(1 downto 0);
            o_vec_aluASelect         : out std_logic_vector(1 downto 0);
            o_vec_aluBSelect         : out std_logic_vector(1 downto 0);
            o_vec_concatenatorSelect : out std_logic_vector(1 downto 0);
            o_vec_aluOpSelect        : out std_logic_vector(5 downto 0);
            --ENABLER
            o_l_pcEnable       : out std_logic;
            o_l_memWriteEnable : out std_logic;
            o_l_instrRegEnable : out std_logic;
            o_l_memDataEnable  : out std_logic;
            o_l_regEnable      : out std_logic;
            o_l_AEnable        : out std_logic;
            o_l_BEnable        : out std_logic;
            o_l_aluOutEnable   : out std_logic;
            o_l_hiEnable       : out std_logic;
            o_l_loEnable       : out std_logic;
            --GLOBAL RESET
            o_l_reset : out std_logic
        );
    end component;
    component L4_InstrReg is
        port (
            i_clk_clock  : in std_logic;
            i_rst_reset  : in std_logic;
            i_l_enable   : in std_logic;
            i_vec_dataIn : in std_logic_vector(31 downto 0);
            o_vec_opOut  : out std_logic_vector(5 downto 0);
            o_vec_rsOut  : out std_logic_vector(4 downto 0);
            o_vec_rtOut  : out std_logic_vector(4 downto 0);
            o_vec_adrImd : out std_logic_vector(15 downto 0)
        );
    end component;
    component L4_Multiplexier is
        generic (
            g_pos_Width : positive := 32
        );
        port (
            i_vec_selector : in std_logic_vector(1 downto 0);
            i_vec_dataIn0  : in std_logic_vector(g_pos_Width - 1 downto 0);
            i_vec_dataIn1  : in std_logic_vector(g_pos_Width - 1 downto 0);
            i_vec_dataIn2  : in std_logic_vector(g_pos_Width - 1 downto 0);
            i_vec_dataIn3  : in std_logic_vector(g_pos_Width - 1 downto 0);
            o_vec_dataOut  : out std_logic_vector(g_pos_Width - 1 downto 0)
        );
    end component;
    component L4_Registers is
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
    end component;
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
    component L4_LeftShifter is
        port (
            i_vec_rsIn     : in std_logic_vector(4 downto 0);
            i_vec_rtIn     : in std_logic_vector(4 downto 0);
            i_vec_adrImdIn : in std_logic_vector(15 downto 0);
            i_vec_pcIn     : in std_logic_vector(31 downto 0);
            o_vec_dataOut  : out std_logic_vector(31 downto 0)
        );
    end component;
    component L4_SignExtender is
        port (
            i_vec_dataIn       : in std_logic_vector(15 downto 0);
            i_vec_opIn: in std_logic_vector(5 downto 0);
            o_vec_signExtended : out std_logic_vector(31 downto 0);
            o_vec_leftShifted  : out std_logic_vector(31 downto 0)
        );
    end component;
    component L4_Multiplier is
        port (
            i_vec_dataIn1     : in std_logic_vector(31 downto 0);
            i_vec_dataIn2     : in std_logic_vector(31 downto 0);
            o_vec_dataOutHigh : out std_logic_vector(31 downto 0);
            o_vec_dataOutLow  : out std_logic_vector(31 downto 0)
        );
    end component;
    component L4_LeadingOnesCounter is
        port (
            i_vec_dataIn    : in std_logic_vector(31 downto 0);
            o_vec_onesCount : out std_logic_vector(31 downto 0)
        );
    end component;
    component L4_Concatenator is
        port (
            i_vec_dataIn   : in std_logic_vector(31 downto 0);
            i_vec_selector : in std_logic_vector(1 downto 0); --00:HalfWord(Upper)   01:Word(Original)     10:HalfWord(Lower)     11:Byte(Lower)
            o_vec_dataOut  : out std_logic_vector(31 downto 0)
        );
    end component;
    --Intermediate Clock Signal Definitions:
    signal s_clk_clock : std_logic;
    --Intermediate Reset Signal Definitions:
    ------@@@@All Reset Signals Are Sychronous To Input Reset Signal From GPIO Ports <= Thus No Definitions Here
    --Intermediate Vector Signals Definitions:
    ----ALU:
    signal s_vec_dataOutRFromAlu : std_logic_vector(31 downto 0);
    signal s_l_zeroFromAlu       : std_logic;
    ----AluCtrl:
    signal s_vec_aluOpFromAluCtrl        : std_logic_vector(3 downto 0);
    signal s_vec_shamtFromAluCtrl        : std_logic_vector(4 downto 0);
    signal s_vec_shiftPortCtrFromAluCtrl : std_logic;
    ----CtrlUnit:
    signal s_vec_stateNumFromCtrlUnit : std_logic_vector(4 downto 0);--DEBUG ONLY
    ----LeftShifter:
    signal s_vec_dataOutFromLeftShifter : std_logic_vector(31 downto 0);
    ----SignExtender:
    signal s_vec_signExtendedFromSignExtender : std_logic_vector(31 downto 0);
    signal s_vec_leftShiftedFromSignExtender  : std_logic_vector(31 downto 0);
    ----Multiplier:
    signal s_vec_dataOutHighFromMultiplier : std_logic_vector(31 downto 0);
    signal s_vec_dataOutLowFromMultiplier  : std_logic_vector(31 downto 0);
    ----LeadingOnesCounter:
    signal s_vec_onesCountFromLeadingOnesCounter : std_logic_vector(31 downto 0);
    ----Concatenator:
    signal s_vec_dataOutFromConcatenator : std_logic_vector(31 downto 0);
    --SELECTOR
    signal s_vec_pcSelectFromCtrlUnit           : std_logic_vector(1 downto 0);
    signal s_vec_adrSelectFromCtrlUnit          : std_logic_vector(1 downto 0);
    signal s_vec_wrtRegSelectFromCtrlUnit       : std_logic_vector(1 downto 0);
    signal s_vec_wrtDataSelectFromCtrlUnit      : std_logic_vector(1 downto 0);
    signal s_vec_highLowSelectFromCtrlUnit      : std_logic_vector(1 downto 0);
    signal s_vec_aluASelectFromCtrlUnit         : std_logic_vector(1 downto 0);
    signal s_vec_aluBSelectFromCtrlUnit         : std_logic_vector(1 downto 0);
    signal s_vec_concatenatorSelectFromCtrlUnit : std_logic_vector(1 downto 0);
    signal s_vec_aluOpSelectFromCtrlUnit        : std_logic_vector(5 downto 0);
    --ENABLER
    signal s_l_pcEnableFromCtrlUnit       : std_logic;
    signal s_l_memWriteEnableFromCtrlUnit : std_logic;
    signal s_l_instrRegEnableFromCtrlUnit : std_logic;
    signal s_l_memDataEnableFromCtrlUnit  : std_logic;
    signal s_l_regEnableFromCtrlUnit      : std_logic;
    signal s_l_AEnableFromCtrlUnit        : std_logic;
    signal s_l_BEnableFromCtrlUnit        : std_logic;
    signal s_l_aluOutEnableFromCtrlUnit   : std_logic;
    signal s_l_hiEnableFromCtrlUnit       : std_logic;
    signal s_l_loEnableFromCtrlUnit       : std_logic;
    --GLOBAL RESET
    signal s_l_resetFromCtrlUnit : std_logic;
    ----InstrReg:
    signal s_vec_opOutFromInstrReg  : std_logic_vector(5 downto 0);
    signal s_vec_rsOutFromInstrReg  : std_logic_vector(4 downto 0);
    signal s_vec_rtOutFromInstrReg  : std_logic_vector(4 downto 0);
    signal s_vec_adrImdFromInstrReg : std_logic_vector(15 downto 0);
    ----Registers:
    signal s_vec_readData1FromRegisters : std_logic_vector(31 downto 0);
    signal s_vec_readData2FromRegisters : std_logic_vector(31 downto 0);
    ----Memory:
    signal s_vec_dataOutFromMem : std_logic_vector(31 downto 0);
    ----MUX::muxAdr
    signal s_vec_dataOutFromMuxAdr : std_logic_vector(31 downto 0);
    ----MUX::muxWrtReg
    signal s_vec_dataOutFromMuxWrtReg : std_logic_vector(4 downto 0);
    ----MUX::muxWrtData
    signal s_vec_dataOutFromHighLow : std_logic_vector(31 downto 0);
    ----MUX::muxWrtData
    signal s_vec_dataOutFromMuxWrtData : std_logic_vector(31 downto 0);
    ----MUX::muxAluA
    signal s_vec_dataOutFromMuxA : std_logic_vector(31 downto 0);
    ----MUX::muxAluB
    signal s_vec_dataOutFromMuxB : std_logic_vector(31 downto 0);
    ----MUX::muxPc
    signal s_vec_dataOutFromMuxPc : std_logic_vector(31 downto 0);
    ----REGISTER::registerPc
    signal s_vec_dataOutFromRegisterPc : std_logic_vector(31 downto 0);
    ----REGISTER::registerMemData
    signal s_vec_dataOutFromRegisterMemData : std_logic_vector(31 downto 0);
    ----REGISTER::registerA
    signal s_vec_dataOutFromRegisterA : std_logic_vector(31 downto 0);
    ----REGISTER::registerB
    signal s_vec_dataOutFromRegisterB : std_logic_vector(31 downto 0);
    ----REGISTER::registerAluOut
    signal s_vec_dataOutFromRegisterAluOut : std_logic_vector(31 downto 0);
    ----REGISTER::registerHi
    signal s_vec_dataOutFromRegisterHi : std_logic_vector(31 downto 0);
    ----REGISTER::registerLo
    signal s_vec_dataOutFromRegisterLo : std_logic_vector(31 downto 0);
    --Intermediate Vector Signals Definitions:

begin
    ---PART1: ASSIGNING GPIO PORTS TO CORRESPONDING SIGNALS
    s_clk_clock                <= i_clk_clock;
    s_vec_dataOutFromMem       <= i_vec_dataOutFromMem;
    o_l_memWriteEnable         <= s_l_memWriteEnableFromCtrlUnit;
    o_vec_dataOutFromMuxAdr    <= s_vec_dataOutFromMuxAdr;
    o_vec_dataOutFromRegisterB <= s_vec_dataOutFromRegisterB;
    ---PART2: INITIALIZING MODULES USING GENERALMAPS AND PORTMAPS
    l_cmp_ctrlUnit : L4_CtrlUnit
    port map(
        i_rst_reset    => i_rst_reset,
        i_clk_clock    => i_clk_clock,
        i_l_aluZero    => s_l_zeroFromAlu,
        i_vec_Op       => s_vec_opOutFromInstrReg,
        i_vec_cdrImd   => s_vec_adrImdFromInstrReg,
        o_vec_stateNum => s_vec_stateNumFromCtrlUnit,
        --SELECTOR
        o_vec_pcSelect           => s_vec_pcSelectFromCtrlUnit,
        o_vec_adrSelect          => s_vec_adrSelectFromCtrlUnit,
        o_vec_wrtRegSelect       => s_vec_wrtRegSelectFromCtrlUnit,
        o_vec_wrtDataSelect      => s_vec_wrtDataSelectFromCtrlUnit,
        o_vec_highLowSelect      => s_vec_highLowSelectFromCtrlUnit,
        o_vec_aluASelect         => s_vec_aluASelectFromCtrlUnit,
        o_vec_aluBSelect         => s_vec_aluBSelectFromCtrlUnit,
        o_vec_concatenatorSelect => s_vec_concatenatorSelectFromCtrlUnit,
        o_vec_aluOpSelect        => s_vec_aluOpSelectFromCtrlUnit,
        --ENABLER
        o_l_pcEnable       => s_l_pcEnableFromCtrlUnit,
        o_l_memWriteEnable => s_l_memWriteEnableFromCtrlUnit,
        o_l_instrRegEnable => s_l_instrRegEnableFromCtrlUnit,
        o_l_memDataEnable  => s_l_memDataEnableFromCtrlUnit,
        o_l_regEnable      => s_l_regEnableFromCtrlUnit,
        o_l_AEnable        => s_l_AEnableFromCtrlUnit,
        o_l_BEnable        => s_l_BEnableFromCtrlUnit,
        o_l_aluOutEnable   => s_l_aluOutEnableFromCtrlUnit,
        o_l_hiEnable       => s_l_hiEnableFromCtrlUnit,
        o_l_loEnable       => s_l_loEnableFromCtrlUnit,
        --GLOBAL RESET
        o_l_reset => s_l_resetFromCtrlUnit
    );
    l_cmp_instrReg : L4_InstrReg
    port map(
        i_clk_clock  => s_clk_clock,
        i_rst_reset  => s_l_resetFromCtrlUnit,
        i_l_enable   => s_l_instrRegEnableFromCtrlUnit,
        i_vec_dataIn => s_vec_dataOutFromMem,
        o_vec_opOut  => s_vec_opOutFromInstrReg,
        o_vec_rsOut  => s_vec_rsOutFromInstrReg,
        o_vec_rtOut  => s_vec_rtOutFromInstrReg,
        o_vec_adrImd => s_vec_adrImdFromInstrReg
    );
    l_cmp_registers : L4_Registers
    port map(
        i_clk_clock         => s_clk_clock,
        i_rst_reset         => s_l_resetFromCtrlUnit,
        i_l_enable          => s_l_regEnableFromCtrlUnit,
        i_vec_readRegister1 => s_vec_rsOutFromInstrReg,
        i_vec_readRegister2 => s_vec_rtOutFromInstrReg,
        i_vec_writeRegister => s_vec_dataOutFromMuxWrtReg,
        i_vec_writeData     => s_vec_dataOutFromMuxWrtData,
        o_vec_readData1     => s_vec_readData1FromRegisters,
        o_vec_readData2     => s_vec_readData2FromRegisters
    );
    l_cmp_alu : L4_Alu
    port map(
        i_vec_aluOp      => s_vec_aluOpFromAluCtrl,
        i_vec_shamt      => s_vec_shamtFromAluCtrl,
        i_l_shiftPortCtr => s_vec_shiftPortCtrFromAluCtrl,
        i_vec_dataInA    => s_vec_dataOutFromMuxA,
        i_vec_dataInB    => s_vec_dataOutFromMuxB,
        o_vec_dataOutR   => s_vec_dataOutRFromAlu,
        o_l_zero         => s_l_zeroFromAlu
    );
    l_cmp_aluCtrl : L4_AluCtrl
    port map(
        i_vec_instr31To26  => s_vec_aluOpSelectFromCtrlUnit,
        i_vec_instr15To0   => s_vec_adrImdFromInstrReg,
        o_vec_aluOp        => s_vec_aluOpFromAluCtrl,
        o_vec_shamt        => s_vec_shamtFromAluCtrl,
        o_vec_shiftPortCtr => s_vec_shiftPortCtrFromAluCtrl
    );
    l_cmp_registerPc : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_pcEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_dataOutFromMuxPc,
        o_vec_dataOut => s_vec_dataOutFromRegisterPc
    );
    l_cmp_registerMemData : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_memDataEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_dataOutFromConcatenator,
        o_vec_dataOut => s_vec_dataOutFromRegisterMemData
    );
    l_cmp_registerA : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_AEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_readData1FromRegisters,
        o_vec_dataOut => s_vec_dataOutFromRegisterA
    );
    l_cmp_registerB : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_BEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_readData2FromRegisters,
        o_vec_dataOut => s_vec_dataOutFromRegisterB
    );
    l_cmp_registerAluOut : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_aluOutEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_dataOutRFromAlu,
        o_vec_dataOut => s_vec_dataOutFromRegisterAluOut
    );
    l_cmp_registerHi : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_hiEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_dataOutHighFromMultiplier,
        o_vec_dataOut => s_vec_dataOutFromRegisterHi
    );
    l_cmp_registerLo : I_Register
    generic map(32)
    port map(
        i_clk_clock   => s_clk_clock,
        i_rst_reset   => s_l_resetFromCtrlUnit,
        i_l_enable    => s_l_loEnableFromCtrlUnit,
        i_vec_dataIn  => s_vec_dataOutLowFromMultiplier,
        o_vec_dataOut => s_vec_dataOutFromRegisterLo
    );
    l_cmp_muxAdr : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_adrSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutFromRegisterPc,
        i_vec_dataIn1  => s_vec_dataOutFromRegisterAluOut,
        i_vec_dataIn2  => x"00000000",
        i_vec_dataIn3  => x"00000000",
        o_vec_dataOut  => s_vec_dataOutFromMuxAdr
    );
    l_cmp_muxWrtReg : L4_Multiplexier
    generic map(5)
    port map(
        i_vec_selector => s_vec_wrtRegSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_rtOutFromInstrReg,
        i_vec_dataIn1  => s_vec_adrImdFromInstrReg(15 downto 11),
        i_vec_dataIn2  => "11111", --Used in BLTZAL (Constant 31)
        i_vec_dataIn3  => "00000",
        o_vec_dataOut  => s_vec_dataOutFromMuxWrtReg
    );
    l_cmp_muxWrtData : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_wrtDataSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutFromRegisterAluOut,
        i_vec_dataIn1  => s_vec_dataOutFromRegisterMemData,
        i_vec_dataIn2  => s_vec_dataOutFromHighLow,
        i_vec_dataIn3  => s_vec_onesCountFromLeadingOnesCounter,
        o_vec_dataOut  => s_vec_dataOutFromMuxWrtData
    );
    l_cmp_muxHighLow : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_highLowSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutFromRegisterHi,
        i_vec_dataIn1  => s_vec_dataOutFromRegisterLo,
        i_vec_dataIn2  => x"00000000",
        i_vec_dataIn3  => x"00000000",
        o_vec_dataOut  => s_vec_dataOutFromHighLow
    );
    l_cmp_muxAluA : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_aluASelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutFromRegisterPc,
        i_vec_dataIn1  => s_vec_dataOutFromRegisterA,
        i_vec_dataIn2  => x"00000000",
        i_vec_dataIn3  => x"00000000",
        o_vec_dataOut  => s_vec_dataOutFromMuxA
    );
    l_cmp_muxAluB : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_aluBSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutFromRegisterB,
        i_vec_dataIn1  => x"00000004",
        i_vec_dataIn2  => s_vec_signExtendedFromSignExtender,
        i_vec_dataIn3  => s_vec_leftShiftedFromSignExtender,
        o_vec_dataOut  => s_vec_dataOutFromMuxB
    );
    l_cmp_muxPc : L4_Multiplexier
    generic map(32)
    port map(
        i_vec_selector => s_vec_pcSelectFromCtrlUnit,
        i_vec_dataIn0  => s_vec_dataOutRFromAlu,
        i_vec_dataIn1  => s_vec_dataOutFromRegisterAluOut,
        i_vec_dataIn2  => s_vec_dataOutFromLeftShifter,
        i_vec_dataIn3  => x"00000000",
        o_vec_dataOut  => s_vec_dataOutFromMuxPc
    );
    l_cmp_leftShifter : L4_LeftShifter
    port map(
        i_vec_rsIn     => s_vec_rsOutFromInstrReg,
        i_vec_rtIn     => s_vec_rtOutFromInstrReg,
        i_vec_adrImdIn => s_vec_adrImdFromInstrReg,
        i_vec_pcIn     => s_vec_dataOutFromRegisterPc,
        o_vec_dataOut  => s_vec_dataOutFromLeftShifter
    );
    l_cmp_signExtender : L4_SignExtender
    port map(
        i_vec_dataIn       => s_vec_adrImdFromInstrReg,
        i_vec_opIn => s_vec_opOutFromInstrReg,
        o_vec_signExtended => s_vec_signExtendedFromSignExtender,
        o_vec_leftShifted  => s_vec_leftShiftedFromSignExtender
    );
    l_cmp_multiplier : L4_Multiplier
    port map(
        i_vec_dataIn1     => s_vec_dataOutFromRegisterA,
        i_vec_dataIn2     => s_vec_dataOutFromRegisterB,
        o_vec_dataOutHigh => s_vec_dataOutHighFromMultiplier,
        o_vec_dataOutLow  => s_vec_dataOutLowFromMultiplier
    );
    l_cmp_leadingOnesCounter : L4_LeadingOnesCounter
    port map(
        i_vec_dataIn    => s_vec_dataOutFromRegisterA,
        o_vec_onesCount => s_vec_onesCountFromLeadingOnesCounter
    );
    l_cmp_concatenator : L4_Concatenator
    port map(
        i_vec_dataIn   => s_vec_dataOutFromMem,
        i_vec_selector => s_vec_concatenatorSelectFromCtrlUnit,
        o_vec_dataOut  => s_vec_dataOutFromConcatenator
    );
end Behavioral;