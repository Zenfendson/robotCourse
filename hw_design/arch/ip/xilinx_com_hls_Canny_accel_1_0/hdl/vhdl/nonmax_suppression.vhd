-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2018.3
-- Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nonmax_suppression is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    gd_data_stream_V_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    gd_data_stream_V_empty_n : IN STD_LOGIC;
    gd_data_stream_V_read : OUT STD_LOGIC;
    dst_data_stream_V_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dst_data_stream_V_full_n : IN STD_LOGIC;
    dst_data_stream_V_write : OUT STD_LOGIC );
end;


architecture behav of nonmax_suppression is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_ST_fsm_state7 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv10_0 : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_lv11_0 : STD_LOGIC_VECTOR (10 downto 0) := "00000000000";
    constant ap_const_lv10_2D1 : STD_LOGIC_VECTOR (9 downto 0) := "1011010001";
    constant ap_const_lv10_1 : STD_LOGIC_VECTOR (9 downto 0) := "0000000001";
    constant ap_const_lv10_2D0 : STD_LOGIC_VECTOR (9 downto 0) := "1011010000";
    constant ap_const_lv32_9 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001001";
    constant ap_const_lv9_0 : STD_LOGIC_VECTOR (8 downto 0) := "000000000";
    constant ap_const_lv10_2CF : STD_LOGIC_VECTOR (9 downto 0) := "1011001111";
    constant ap_const_lv11_501 : STD_LOGIC_VECTOR (10 downto 0) := "10100000001";
    constant ap_const_lv11_1 : STD_LOGIC_VECTOR (10 downto 0) := "00000000001";
    constant ap_const_lv11_500 : STD_LOGIC_VECTOR (10 downto 0) := "10100000000";
    constant ap_const_lv32_F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001111";
    constant ap_const_lv32_A : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001010";
    constant ap_const_lv11_4FF : STD_LOGIC_VECTOR (10 downto 0) := "10011111111";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";
    constant ap_const_lv2_2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv14_0 : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";

    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal gd_data_stream_V_blk_n : STD_LOGIC;
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal or_cond_reg_781 : STD_LOGIC_VECTOR (0 downto 0);
    signal dst_data_stream_V_blk_n : STD_LOGIC;
    signal ap_enable_reg_pp0_iter3 : STD_LOGIC := '0';
    signal or_cond4_reg_796 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond4_reg_796_pp0_iter2_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal t_V_1_reg_225 : STD_LOGIC_VECTOR (10 downto 0);
    signal t_V_1_reg_225_pp0_iter1_reg : STD_LOGIC_VECTOR (10 downto 0);
    signal ap_block_state3_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state4_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_state5_pp0_stage0_iter2 : BOOLEAN;
    signal ap_block_state6_pp0_stage0_iter3 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal exitcond8_fu_237_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal i_V_fu_243_p2 : STD_LOGIC_VECTOR (9 downto 0);
    signal i_V_reg_740 : STD_LOGIC_VECTOR (9 downto 0);
    signal tmp_2_fu_249_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_2_reg_745 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_fu_265_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_reg_750 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_4_fu_271_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_4_reg_755 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_5_fu_277_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_5_reg_760 : STD_LOGIC_VECTOR (0 downto 0);
    signal exitcond_fu_283_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal exitcond_reg_765 : STD_LOGIC_VECTOR (0 downto 0);
    signal exitcond_reg_765_pp0_iter1_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal j_V_fu_289_p2 : STD_LOGIC_VECTOR (10 downto 0);
    signal j_V_reg_769 : STD_LOGIC_VECTOR (10 downto 0);
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC := '0';
    signal tmp_8_fu_295_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_8_reg_774 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_8_reg_774_pp0_iter1_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond_fu_301_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond_reg_781_pp0_iter1_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal linebuff_val_1_addr_reg_785 : STD_LOGIC_VECTOR (10 downto 0);
    signal linebuff_val_1_addr_reg_785_pp0_iter1_reg : STD_LOGIC_VECTOR (10 downto 0);
    signal or_cond4_fu_318_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond4_reg_796_pp0_iter1_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal linebuff_val_0_q0 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp0_reg_800 : STD_LOGIC_VECTOR (15 downto 0);
    signal out_pixel_val_2_cast_fu_399_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal out_pixel_val_2_cast_reg_805 : STD_LOGIC_VECTOR (13 downto 0);
    signal icmp1_fu_419_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp1_reg_810 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_7_fu_425_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_7_reg_815 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_14_fu_589_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_14_reg_820 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_15_fu_595_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_15_reg_825 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal ap_condition_pp0_exit_iter0_state3 : STD_LOGIC;
    signal ap_enable_reg_pp0_iter2 : STD_LOGIC := '0';
    signal linebuff_val_0_address0 : STD_LOGIC_VECTOR (10 downto 0);
    signal linebuff_val_0_ce0 : STD_LOGIC;
    signal linebuff_val_0_address1 : STD_LOGIC_VECTOR (10 downto 0);
    signal linebuff_val_0_ce1 : STD_LOGIC;
    signal linebuff_val_0_we1 : STD_LOGIC;
    signal linebuff_val_1_address0 : STD_LOGIC_VECTOR (10 downto 0);
    signal linebuff_val_1_ce0 : STD_LOGIC;
    signal linebuff_val_1_q0 : STD_LOGIC_VECTOR (15 downto 0);
    signal linebuff_val_1_ce1 : STD_LOGIC;
    signal linebuff_val_1_we1 : STD_LOGIC;
    signal t_V_reg_214 : STD_LOGIC_VECTOR (9 downto 0);
    signal ap_block_state1 : BOOLEAN;
    signal ap_CS_fsm_state7 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state7 : signal is "none";
    signal ap_phi_mux_t_V_1_phi_fu_229_p4 : STD_LOGIC_VECTOR (10 downto 0);
    signal tmp_s_fu_306_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_6_fu_342_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal tmp1_s_fu_118 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp0_s_fu_122 : STD_LOGIC_VECTOR (15 downto 0);
    signal element_gd_s_fu_126 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_0_1_fu_130 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_0_0_0_win_va_fu_388_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_0_1_1_fu_134 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_1_1_fu_138 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_1_0_0_win_va_fu_381_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_1_1_1_fu_142 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_2_1_fu_146 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_2_0_0_win_va_fu_374_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal win_val_2_1_1_fu_150 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_3_fu_255_p4 : STD_LOGIC_VECTOR (8 downto 0);
    signal tmp_17_fu_312_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_19_fu_409_p4 : STD_LOGIC_VECTOR (9 downto 0);
    signal current_dir_fu_395_p1 : STD_LOGIC_VECTOR (1 downto 0);
    signal tmp_9_fu_431_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_10_fu_437_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sel_tmp1_fu_449_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_11_fu_443_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_20_fu_481_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_21_fu_491_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_13_fu_471_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_22_fu_501_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal sel_tmp2_fu_455_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_12_fu_461_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_23_fu_509_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_27_fu_545_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_28_fu_555_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_26_fu_535_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_29_fu_565_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_25_fu_525_p4 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_30_fu_573_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_31_fu_581_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_24_fu_517_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp8_fu_644_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp9_fu_640_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond3_fu_654_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond2_fu_648_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal out_pixel_val_fu_658_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_16_fu_665_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (3 downto 0);
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;

    component nonmax_suppressioocq IS
    generic (
        DataWidth : INTEGER;
        AddressRange : INTEGER;
        AddressWidth : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR (10 downto 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR (15 downto 0);
        address1 : IN STD_LOGIC_VECTOR (10 downto 0);
        ce1 : IN STD_LOGIC;
        we1 : IN STD_LOGIC;
        d1 : IN STD_LOGIC_VECTOR (15 downto 0) );
    end component;



begin
    linebuff_val_0_U : component nonmax_suppressioocq
    generic map (
        DataWidth => 16,
        AddressRange => 1920,
        AddressWidth => 11)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        address0 => linebuff_val_0_address0,
        ce0 => linebuff_val_0_ce0,
        q0 => linebuff_val_0_q0,
        address1 => linebuff_val_0_address1,
        ce1 => linebuff_val_0_ce1,
        we1 => linebuff_val_0_we1,
        d1 => element_gd_s_fu_126);

    linebuff_val_1_U : component nonmax_suppressioocq
    generic map (
        DataWidth => 16,
        AddressRange => 1920,
        AddressWidth => 11)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        address0 => linebuff_val_1_address0,
        ce0 => linebuff_val_1_ce0,
        q0 => linebuff_val_1_q0,
        address1 => linebuff_val_1_addr_reg_785_pp0_iter1_reg,
        ce1 => linebuff_val_1_ce1,
        we1 => linebuff_val_1_we1,
        d1 => tmp0_reg_800);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif (((exitcond8_fu_237_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter0_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_logic_1 = ap_condition_pp0_exit_iter0_state3) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
                elsif (((exitcond8_fu_237_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then
                    if ((ap_const_logic_1 = ap_condition_pp0_exit_iter0_state3)) then 
                        ap_enable_reg_pp0_iter1 <= (ap_const_logic_1 xor ap_condition_pp0_exit_iter0_state3);
                    elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                        ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
                    end if;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter2_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter2 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter3_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter3 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter3 <= ap_enable_reg_pp0_iter2;
                elsif (((exitcond8_fu_237_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                    ap_enable_reg_pp0_iter3 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    t_V_1_reg_225_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_reg_765 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
                t_V_1_reg_225 <= j_V_reg_769;
            elsif (((exitcond8_fu_237_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                t_V_1_reg_225 <= ap_const_lv11_0;
            end if; 
        end if;
    end process;

    t_V_reg_214_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state7)) then 
                t_V_reg_214 <= i_V_reg_740;
            elsif ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                t_V_reg_214 <= ap_const_lv10_0;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (or_cond_reg_781 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                element_gd_s_fu_126 <= gd_data_stream_V_dout;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                exitcond_reg_765 <= exitcond_fu_283_p2;
                exitcond_reg_765_pp0_iter1_reg <= exitcond_reg_765;
                linebuff_val_1_addr_reg_785_pp0_iter1_reg <= linebuff_val_1_addr_reg_785;
                or_cond4_reg_796_pp0_iter1_reg <= or_cond4_reg_796;
                or_cond_reg_781_pp0_iter1_reg <= or_cond_reg_781;
                t_V_1_reg_225_pp0_iter1_reg <= t_V_1_reg_225;
                tmp_8_reg_774_pp0_iter1_reg <= tmp_8_reg_774;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state2)) then
                i_V_reg_740 <= i_V_fu_243_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_0 = ap_block_pp0_stage0_11001)) then
                icmp1_reg_810 <= icmp1_fu_419_p2;
                or_cond4_reg_796_pp0_iter2_reg <= or_cond4_reg_796_pp0_iter1_reg;
                out_pixel_val_2_cast_reg_805 <= win_val_1_1_fu_138(15 downto 2);
                tmp_14_reg_820 <= tmp_14_fu_589_p2;
                tmp_15_reg_825 <= tmp_15_fu_595_p2;
                tmp_7_reg_815 <= tmp_7_fu_425_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((exitcond8_fu_237_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                icmp_reg_750 <= icmp_fu_265_p2;
                tmp_2_reg_745 <= tmp_2_fu_249_p2;
                tmp_4_reg_755 <= tmp_4_fu_271_p2;
                tmp_5_reg_760 <= tmp_5_fu_277_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then
                j_V_reg_769 <= j_V_fu_289_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_fu_283_p2 = ap_const_lv1_0) and (tmp_8_fu_295_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                linebuff_val_1_addr_reg_785 <= tmp_s_fu_306_p1(11 - 1 downto 0);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_fu_283_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                or_cond4_reg_796 <= or_cond4_fu_318_p2;
                or_cond_reg_781 <= or_cond_fu_301_p2;
                tmp_8_reg_774 <= tmp_8_fu_295_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (tmp_8_reg_774 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                tmp0_reg_800 <= linebuff_val_0_q0;
                tmp0_s_fu_122 <= linebuff_val_0_q0;
                tmp1_s_fu_118 <= linebuff_val_1_q0;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_reg_765_pp0_iter1_reg = ap_const_lv1_0) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then
                win_val_0_1_1_fu_134 <= win_val_0_1_fu_130;
                win_val_0_1_fu_130 <= win_val_0_0_0_win_va_fu_388_p3;
                win_val_1_1_1_fu_142 <= win_val_1_1_fu_138;
                win_val_1_1_fu_138 <= win_val_1_0_0_win_va_fu_381_p3;
                win_val_2_1_1_fu_150 <= win_val_2_1_fu_146;
                win_val_2_1_fu_146 <= win_val_2_0_0_win_va_fu_374_p3;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1, ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter3, exitcond8_fu_237_p2, ap_CS_fsm_state2, exitcond_fu_283_p2, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_subdone, ap_enable_reg_pp0_iter2)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                if (((exitcond8_fu_237_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                end if;
            when ap_ST_fsm_pp0_stage0 => 
                if ((not(((exitcond_fu_283_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) and not(((ap_enable_reg_pp0_iter3 = ap_const_logic_1) and (ap_enable_reg_pp0_iter2 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))))) then
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                elsif ((((ap_enable_reg_pp0_iter3 = ap_const_logic_1) and (ap_enable_reg_pp0_iter2 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) or ((exitcond_fu_283_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone)))) then
                    ap_NS_fsm <= ap_ST_fsm_state7;
                else
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                end if;
            when ap_ST_fsm_state7 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when others =>  
                ap_NS_fsm <= "XXXX";
        end case;
    end process;
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(2);
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
    ap_CS_fsm_state7 <= ap_CS_fsm(3);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_pp0_stage0_01001_assign_proc : process(gd_data_stream_V_empty_n, dst_data_stream_V_full_n, ap_enable_reg_pp0_iter1, or_cond_reg_781, ap_enable_reg_pp0_iter3, or_cond4_reg_796_pp0_iter2_reg)
    begin
                ap_block_pp0_stage0_01001 <= (((or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (dst_data_stream_V_full_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_1)) or ((or_cond_reg_781 = ap_const_lv1_1) and (gd_data_stream_V_empty_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)));
    end process;


    ap_block_pp0_stage0_11001_assign_proc : process(gd_data_stream_V_empty_n, dst_data_stream_V_full_n, ap_enable_reg_pp0_iter1, or_cond_reg_781, ap_enable_reg_pp0_iter3, or_cond4_reg_796_pp0_iter2_reg)
    begin
                ap_block_pp0_stage0_11001 <= (((or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (dst_data_stream_V_full_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_1)) or ((or_cond_reg_781 = ap_const_lv1_1) and (gd_data_stream_V_empty_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)));
    end process;


    ap_block_pp0_stage0_subdone_assign_proc : process(gd_data_stream_V_empty_n, dst_data_stream_V_full_n, ap_enable_reg_pp0_iter1, or_cond_reg_781, ap_enable_reg_pp0_iter3, or_cond4_reg_796_pp0_iter2_reg)
    begin
                ap_block_pp0_stage0_subdone <= (((or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (dst_data_stream_V_full_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_1)) or ((or_cond_reg_781 = ap_const_lv1_1) and (gd_data_stream_V_empty_n = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)));
    end process;


    ap_block_state1_assign_proc : process(ap_start, ap_done_reg)
    begin
                ap_block_state1 <= ((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1));
    end process;

        ap_block_state3_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_state4_pp0_stage0_iter1_assign_proc : process(gd_data_stream_V_empty_n, or_cond_reg_781)
    begin
                ap_block_state4_pp0_stage0_iter1 <= ((or_cond_reg_781 = ap_const_lv1_1) and (gd_data_stream_V_empty_n = ap_const_logic_0));
    end process;

        ap_block_state5_pp0_stage0_iter2 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_state6_pp0_stage0_iter3_assign_proc : process(dst_data_stream_V_full_n, or_cond4_reg_796_pp0_iter2_reg)
    begin
                ap_block_state6_pp0_stage0_iter3 <= ((or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (dst_data_stream_V_full_n = ap_const_logic_0));
    end process;


    ap_condition_pp0_exit_iter0_state3_assign_proc : process(exitcond_fu_283_p2)
    begin
        if ((exitcond_fu_283_p2 = ap_const_lv1_1)) then 
            ap_condition_pp0_exit_iter0_state3 <= ap_const_logic_1;
        else 
            ap_condition_pp0_exit_iter0_state3 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_assign_proc : process(ap_done_reg, exitcond8_fu_237_p2, ap_CS_fsm_state2)
    begin
        if (((exitcond8_fu_237_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_done_reg;
        end if; 
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);

    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter3, ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_enable_reg_pp0_iter3 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter2 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_phi_mux_t_V_1_phi_fu_229_p4_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0, t_V_1_reg_225, exitcond_reg_765, j_V_reg_769)
    begin
        if (((exitcond_reg_765 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_phi_mux_t_V_1_phi_fu_229_p4 <= j_V_reg_769;
        else 
            ap_phi_mux_t_V_1_phi_fu_229_p4 <= t_V_1_reg_225;
        end if; 
    end process;


    ap_ready_assign_proc : process(exitcond8_fu_237_p2, ap_CS_fsm_state2)
    begin
        if (((exitcond8_fu_237_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;

    current_dir_fu_395_p1 <= win_val_1_1_fu_138(2 - 1 downto 0);

    dst_data_stream_V_blk_n_assign_proc : process(dst_data_stream_V_full_n, ap_block_pp0_stage0, ap_enable_reg_pp0_iter3, or_cond4_reg_796_pp0_iter2_reg)
    begin
        if (((or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_1))) then 
            dst_data_stream_V_blk_n <= dst_data_stream_V_full_n;
        else 
            dst_data_stream_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dst_data_stream_V_din <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_16_fu_665_p3),16));

    dst_data_stream_V_write_assign_proc : process(ap_enable_reg_pp0_iter3, or_cond4_reg_796_pp0_iter2_reg, ap_block_pp0_stage0_11001)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (or_cond4_reg_796_pp0_iter2_reg = ap_const_lv1_0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_1))) then 
            dst_data_stream_V_write <= ap_const_logic_1;
        else 
            dst_data_stream_V_write <= ap_const_logic_0;
        end if; 
    end process;

    exitcond8_fu_237_p2 <= "1" when (t_V_reg_214 = ap_const_lv10_2D1) else "0";
    exitcond_fu_283_p2 <= "1" when (ap_phi_mux_t_V_1_phi_fu_229_p4 = ap_const_lv11_501) else "0";

    gd_data_stream_V_blk_n_assign_proc : process(gd_data_stream_V_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0, or_cond_reg_781)
    begin
        if (((or_cond_reg_781 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            gd_data_stream_V_blk_n <= gd_data_stream_V_empty_n;
        else 
            gd_data_stream_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    gd_data_stream_V_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, or_cond_reg_781, ap_block_pp0_stage0_11001)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (or_cond_reg_781 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            gd_data_stream_V_read <= ap_const_logic_1;
        else 
            gd_data_stream_V_read <= ap_const_logic_0;
        end if; 
    end process;

    i_V_fu_243_p2 <= std_logic_vector(unsigned(t_V_reg_214) + unsigned(ap_const_lv10_1));
    icmp1_fu_419_p2 <= "1" when (tmp_19_fu_409_p4 = ap_const_lv10_0) else "0";
    icmp_fu_265_p2 <= "1" when (tmp_3_fu_255_p4 = ap_const_lv9_0) else "0";
    j_V_fu_289_p2 <= std_logic_vector(unsigned(ap_phi_mux_t_V_1_phi_fu_229_p4) + unsigned(ap_const_lv11_1));
    linebuff_val_0_address0 <= tmp_s_fu_306_p1(11 - 1 downto 0);
    linebuff_val_0_address1 <= tmp_6_fu_342_p1(11 - 1 downto 0);

    linebuff_val_0_ce0_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then 
            linebuff_val_0_ce0 <= ap_const_logic_1;
        else 
            linebuff_val_0_ce0 <= ap_const_logic_0;
        end if; 
    end process;


    linebuff_val_0_ce1_assign_proc : process(ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            linebuff_val_0_ce1 <= ap_const_logic_1;
        else 
            linebuff_val_0_ce1 <= ap_const_logic_0;
        end if; 
    end process;


    linebuff_val_0_we1_assign_proc : process(ap_block_pp0_stage0_11001, or_cond_reg_781_pp0_iter1_reg, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (or_cond_reg_781_pp0_iter1_reg = ap_const_lv1_1) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            linebuff_val_0_we1 <= ap_const_logic_1;
        else 
            linebuff_val_0_we1 <= ap_const_logic_0;
        end if; 
    end process;

    linebuff_val_1_address0 <= tmp_s_fu_306_p1(11 - 1 downto 0);

    linebuff_val_1_ce0_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then 
            linebuff_val_1_ce0 <= ap_const_logic_1;
        else 
            linebuff_val_1_ce0 <= ap_const_logic_0;
        end if; 
    end process;


    linebuff_val_1_ce1_assign_proc : process(ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            linebuff_val_1_ce1 <= ap_const_logic_1;
        else 
            linebuff_val_1_ce1 <= ap_const_logic_0;
        end if; 
    end process;


    linebuff_val_1_we1_assign_proc : process(ap_block_pp0_stage0_11001, tmp_8_reg_774_pp0_iter1_reg, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (tmp_8_reg_774_pp0_iter1_reg = ap_const_lv1_1) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            linebuff_val_1_we1 <= ap_const_logic_1;
        else 
            linebuff_val_1_we1 <= ap_const_logic_0;
        end if; 
    end process;

    or_cond2_fu_648_p2 <= (tmp9_fu_640_p2 or tmp8_fu_644_p2);
    or_cond3_fu_654_p2 <= (tmp_15_reg_825 and tmp_14_reg_820);
    or_cond4_fu_318_p2 <= (tmp_4_reg_755 or tmp_17_fu_312_p2);
    or_cond_fu_301_p2 <= (tmp_8_fu_295_p2 and tmp_2_reg_745);
    out_pixel_val_2_cast_fu_399_p4 <= win_val_1_1_fu_138(15 downto 2);
    out_pixel_val_fu_658_p3 <= 
        out_pixel_val_2_cast_reg_805 when (or_cond3_fu_654_p2(0) = '1') else 
        ap_const_lv14_0;
    sel_tmp1_fu_449_p2 <= (tmp_9_fu_431_p2 xor ap_const_lv1_1);
    sel_tmp2_fu_455_p2 <= (tmp_10_fu_437_p2 and sel_tmp1_fu_449_p2);
    tmp8_fu_644_p2 <= (tmp_7_reg_815 or tmp_5_reg_760);
    tmp9_fu_640_p2 <= (icmp_reg_750 or icmp1_reg_810);
    tmp_10_fu_437_p2 <= "1" when (current_dir_fu_395_p1 = ap_const_lv2_3) else "0";
    tmp_11_fu_443_p2 <= "1" when (current_dir_fu_395_p1 = ap_const_lv2_2) else "0";
    tmp_12_fu_461_p4 <= win_val_0_1_1_fu_134(15 downto 2);
    tmp_13_fu_471_p4 <= win_val_1_1_1_fu_142(15 downto 2);
    tmp_14_fu_589_p2 <= "1" when (unsigned(out_pixel_val_2_cast_fu_399_p4) > unsigned(tmp_31_fu_581_p3)) else "0";
    tmp_15_fu_595_p2 <= "1" when (unsigned(out_pixel_val_2_cast_fu_399_p4) > unsigned(tmp_24_fu_517_p3)) else "0";
    tmp_16_fu_665_p3 <= 
        ap_const_lv14_0 when (or_cond2_fu_648_p2(0) = '1') else 
        out_pixel_val_fu_658_p3;
    tmp_17_fu_312_p2 <= "1" when (ap_phi_mux_t_V_1_phi_fu_229_p4 = ap_const_lv11_0) else "0";
    tmp_19_fu_409_p4 <= t_V_1_reg_225_pp0_iter1_reg(10 downto 1);
    tmp_20_fu_481_p4 <= win_val_2_1_fu_146(15 downto 2);
    tmp_21_fu_491_p4 <= win_val_0_0_0_win_va_fu_388_p3(15 downto 2);
    tmp_22_fu_501_p3 <= 
        tmp_20_fu_481_p4 when (tmp_11_fu_443_p2(0) = '1') else 
        tmp_21_fu_491_p4;
    tmp_23_fu_509_p3 <= 
        tmp_13_fu_471_p4 when (tmp_9_fu_431_p2(0) = '1') else 
        tmp_22_fu_501_p3;
    tmp_24_fu_517_p3 <= 
        tmp_12_fu_461_p4 when (sel_tmp2_fu_455_p2(0) = '1') else 
        tmp_23_fu_509_p3;
    tmp_25_fu_525_p4 <= win_val_2_0_0_win_va_fu_374_p3(15 downto 2);
    tmp_26_fu_535_p4 <= win_val_1_0_0_win_va_fu_381_p3(15 downto 2);
    tmp_27_fu_545_p4 <= win_val_0_1_fu_130(15 downto 2);
    tmp_28_fu_555_p4 <= win_val_2_1_1_fu_150(15 downto 2);
    tmp_29_fu_565_p3 <= 
        tmp_27_fu_545_p4 when (tmp_11_fu_443_p2(0) = '1') else 
        tmp_28_fu_555_p4;
    tmp_2_fu_249_p2 <= "1" when (unsigned(t_V_reg_214) < unsigned(ap_const_lv10_2D0)) else "0";
    tmp_30_fu_573_p3 <= 
        tmp_26_fu_535_p4 when (tmp_9_fu_431_p2(0) = '1') else 
        tmp_29_fu_565_p3;
    tmp_31_fu_581_p3 <= 
        tmp_25_fu_525_p4 when (sel_tmp2_fu_455_p2(0) = '1') else 
        tmp_30_fu_573_p3;
    tmp_3_fu_255_p4 <= t_V_reg_214(9 downto 1);
    tmp_4_fu_271_p2 <= "1" when (t_V_reg_214 = ap_const_lv10_0) else "0";
    tmp_5_fu_277_p2 <= "1" when (unsigned(t_V_reg_214) > unsigned(ap_const_lv10_2CF)) else "0";
    tmp_6_fu_342_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(t_V_1_reg_225_pp0_iter1_reg),64));
    tmp_7_fu_425_p2 <= "1" when (unsigned(t_V_1_reg_225_pp0_iter1_reg) > unsigned(ap_const_lv11_4FF)) else "0";
    tmp_8_fu_295_p2 <= "1" when (unsigned(ap_phi_mux_t_V_1_phi_fu_229_p4) < unsigned(ap_const_lv11_500)) else "0";
    tmp_9_fu_431_p2 <= "1" when (current_dir_fu_395_p1 = ap_const_lv2_0) else "0";
    tmp_s_fu_306_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(ap_phi_mux_t_V_1_phi_fu_229_p4),64));
    win_val_0_0_0_win_va_fu_388_p3 <= 
        element_gd_s_fu_126 when (tmp_8_reg_774_pp0_iter1_reg(0) = '1') else 
        win_val_0_1_fu_130;
    win_val_1_0_0_win_va_fu_381_p3 <= 
        tmp0_s_fu_122 when (tmp_8_reg_774_pp0_iter1_reg(0) = '1') else 
        win_val_1_1_fu_138;
    win_val_2_0_0_win_va_fu_374_p3 <= 
        tmp1_s_fu_118 when (tmp_8_reg_774_pp0_iter1_reg(0) = '1') else 
        win_val_2_1_fu_146;
end behav;