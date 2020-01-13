library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity mips_top_tb is
end mips_top_tb;

architecture TB of mips_top_tb is

  signal clk        : std_logic := '0';
  signal switch     : std_logic_vector(9 downto 0);
  signal button     : std_logic_vector(1 downto 0) := "11";
  signal led0       : std_logic_vector(6 downto 0);
  signal led0_dp    : std_logic;
  signal led1       : std_logic_vector(6 downto 0);
  signal led1_dp    : std_logic;
  signal led2       : std_logic_vector(6 downto 0);
  signal led2_dp    : std_logic;
  signal led3       : std_logic_vector(6 downto 0);
  signal led3_dp    : std_logic;
  signal led4       : std_logic_vector(6 downto 0);
  signal led4_dp    : std_logic;
  signal led5       : std_logic_vector(6 downto 0);
  signal led5_dp    : std_logic;
  

begin

  UUT : entity work.mips_top
    port map (
        clk,
        switch,
        button,
        led0,
        led0_dp,
        led1,
        led1_dp,
        led2,
        led2_dp,
        led3,
        led3_dp,
        led4,
        led4_dp,
        led5,
        led5_dp);
 
  clk <= not clk after 5 ns;

  process
  begin

    -- reset
    button(0) <= '0';  
    wait for 20 ns;
    button(0) <= '1';

    -- select size
    switch(8 downto 0) <= "111111111";
    switch(9) <= '0';
    button(1) <= '0';
    wait for 20 ns;

    -- select first entry
    switch(8 downto 0) <= "111111111";
    switch(9) <= '1';
    button(1) <= '0';
    wait for 20 ns;

    -- reset
    button(1) <= '1';
    button(0) <= '0';
    wait for 20 ns;
    button(0) <= '1';

    wait for 1000 ns;

    -- select second entry
    switch(8 downto 0) <= "101000000";
    switch(9) <= '1';
    button(1) <= '0';
    wait for 1000 ns; 

    -- select third entry
    switch(8 downto 0) <= "101010111";
    switch(9) <= '1';
    button(1) <= '0';
    wait for 1000 ns; 

    wait;
    
  end process;
end;

