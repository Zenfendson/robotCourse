-- ==============================================================
-- File generated on Wed Jul 22 09:49:55 +0800 2020
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Canny_accel_mac_mjbC_DSP48_4 is
port (
    clk: in  std_logic;
    rst: in  std_logic;
    ce:  in  std_logic;
    in0:  in  std_logic_vector(2 - 1 downto 0);
    in1:  in  std_logic_vector(8 - 1 downto 0);
    in2:  in  std_logic_vector(11 - 1 downto 0);
    dout: out std_logic_vector(11 - 1 downto 0));

    attribute use_dsp : string;
    attribute use_dsp of Canny_accel_mac_mjbC_DSP48_4 : entity is "yes";

end entity;

architecture behav of Canny_accel_mac_mjbC_DSP48_4 is
    signal a       : signed(25-1 downto 0);
    signal b       : signed(18-1 downto 0);
    signal c       : signed(48-1 downto 0);
    signal m       : signed(43-1 downto 0);
    signal p       : signed(48-1 downto 0);
    signal m_reg   : signed(43-1 downto 0);
    signal a_reg   : signed(25-1 downto 0);
    signal b_reg   : signed(18-1 downto 0);
begin
a  <= signed(resize(signed(in0), 25));
b  <= signed(resize(unsigned(in1), 18));
c  <= signed(resize(signed(in2), 48));

m  <= a_reg * b_reg;
p  <= m_reg + c;

process (clk) begin
    if (clk'event and clk = '1') then
        if (ce = '1') then
            m_reg  <= m;
            a_reg  <= a;
            b_reg  <= b;
        end if;
    end if;
end process;

dout <= std_logic_vector(resize(unsigned(p), 11));

end architecture;
Library IEEE;
use IEEE.std_logic_1164.all;

entity Canny_accel_mac_mjbC is
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        din2_WIDTH : INTEGER;
        dout_WIDTH : INTEGER);
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        din0 : IN STD_LOGIC_VECTOR(din0_WIDTH - 1 DOWNTO 0);
        din1 : IN STD_LOGIC_VECTOR(din1_WIDTH - 1 DOWNTO 0);
        din2 : IN STD_LOGIC_VECTOR(din2_WIDTH - 1 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(dout_WIDTH - 1 DOWNTO 0));
end entity;

architecture arch of Canny_accel_mac_mjbC is
    component Canny_accel_mac_mjbC_DSP48_4 is
        port (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            in0 : IN STD_LOGIC_VECTOR;
            in1 : IN STD_LOGIC_VECTOR;
            in2 : IN STD_LOGIC_VECTOR;
            dout : OUT STD_LOGIC_VECTOR);
    end component;



begin
    Canny_accel_mac_mjbC_DSP48_4_U :  component Canny_accel_mac_mjbC_DSP48_4
    port map (
        clk => clk,
        rst => reset,
        ce => ce,
        in0 => din0,
        in1 => din1,
        in2 => din2,
        dout => dout);

end architecture;

