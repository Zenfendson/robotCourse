-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2018.3
-- Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity color_detect_entry13 is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    H_thres_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    H_thres_empty_n : IN STD_LOGIC;
    H_thres_read : OUT STD_LOGIC;
    S_thres_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    S_thres_empty_n : IN STD_LOGIC;
    S_thres_read : OUT STD_LOGIC;
    V_thres_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    V_thres_empty_n : IN STD_LOGIC;
    V_thres_read : OUT STD_LOGIC;
    H_thres_out_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    H_thres_out_full_n : IN STD_LOGIC;
    H_thres_out_write : OUT STD_LOGIC;
    S_thres_out_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    S_thres_out_full_n : IN STD_LOGIC;
    S_thres_out_write : OUT STD_LOGIC;
    V_thres_out_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    V_thres_out_full_n : IN STD_LOGIC;
    V_thres_out_write : OUT STD_LOGIC );
end;


architecture behav of color_detect_entry13 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal H_thres_blk_n : STD_LOGIC;
    signal S_thres_blk_n : STD_LOGIC;
    signal V_thres_blk_n : STD_LOGIC;
    signal H_thres_out_blk_n : STD_LOGIC;
    signal S_thres_out_blk_n : STD_LOGIC;
    signal V_thres_out_blk_n : STD_LOGIC;
    signal ap_block_state1 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);


begin




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
                elsif ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_NS_fsm_assign_proc : process (ap_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;

    H_thres_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            H_thres_blk_n <= H_thres_empty_n;
        else 
            H_thres_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    H_thres_out_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            H_thres_out_blk_n <= H_thres_out_full_n;
        else 
            H_thres_out_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    H_thres_out_din <= H_thres_dout;

    H_thres_out_write_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            H_thres_out_write <= ap_const_logic_1;
        else 
            H_thres_out_write <= ap_const_logic_0;
        end if; 
    end process;


    H_thres_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            H_thres_read <= ap_const_logic_1;
        else 
            H_thres_read <= ap_const_logic_0;
        end if; 
    end process;


    S_thres_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, S_thres_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            S_thres_blk_n <= S_thres_empty_n;
        else 
            S_thres_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    S_thres_out_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, S_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            S_thres_out_blk_n <= S_thres_out_full_n;
        else 
            S_thres_out_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    S_thres_out_din <= S_thres_dout;

    S_thres_out_write_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            S_thres_out_write <= ap_const_logic_1;
        else 
            S_thres_out_write <= ap_const_logic_0;
        end if; 
    end process;


    S_thres_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            S_thres_read <= ap_const_logic_1;
        else 
            S_thres_read <= ap_const_logic_0;
        end if; 
    end process;


    V_thres_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, V_thres_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            V_thres_blk_n <= V_thres_empty_n;
        else 
            V_thres_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    V_thres_out_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            V_thres_out_blk_n <= V_thres_out_full_n;
        else 
            V_thres_out_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    V_thres_out_din <= V_thres_dout;

    V_thres_out_write_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            V_thres_out_write <= ap_const_logic_1;
        else 
            V_thres_out_write <= ap_const_logic_0;
        end if; 
    end process;


    V_thres_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            V_thres_read <= ap_const_logic_1;
        else 
            V_thres_read <= ap_const_logic_0;
        end if; 
    end process;

    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_block_state1_assign_proc : process(ap_start, ap_done_reg, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
                ap_block_state1 <= ((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1));
    end process;


    ap_done_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, H_thres_empty_n, S_thres_empty_n, V_thres_empty_n, H_thres_out_full_n, S_thres_out_full_n, V_thres_out_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_const_logic_0 = V_thres_out_full_n) or (ap_const_logic_0 = S_thres_out_full_n) or (ap_const_logic_0 = H_thres_out_full_n) or (ap_const_logic_0 = V_thres_empty_n) or (ap_const_logic_0 = S_thres_empty_n) or (ap_const_logic_0 = H_thres_empty_n) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;

end behav;