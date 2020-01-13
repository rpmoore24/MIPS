library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity memory_tb is
end memory_tb;

architecture TB of memory_tb is

    constant WIDTH  	: positive  := 32;
    signal clk			: std_logic := '0';
    signal rst 			: std_logic := '0';
    signal address		: std_logic_vector(WIDTH-1 downto 0);
    signal MemRead		: std_logic;
    signal MemWrite		: std_logic;
    signal RegB 		: std_logic_vector(WIDTH-1 downto 0);
    signal InPort 		: std_logic_vector(WIDTH-1 downto 0);
    signal InPort0_en	: std_logic;
    signal InPort1_en	: std_logic;
    signal memory_out	: std_logic_vector(WIDTH-1 downto 0);
    signal OutPort 		: std_logic_vector(WIDTH-1 downto 0);

begin  -- TB

    UUT : entity work.memory
        generic map (WIDTH => WIDTH)
        port map (
			clk     	=> clk,
			rst 		=> rst, 
			address	    => address,
			MemRead 	=> MemRead,
			MemWrite	=> MemWrite,
			RegB 		=> RegB,
			InPort 		=> InPort,
			InPort0_en	=> InPort0_en,
			InPort1_en	=> InPort1_en,
			memory_out	=> memory_out,
			OutPort 	=> OutPort);

	clk <= not clk after 5 ns;

  	process
  	begin

        -- test write to address 0x0
        address   	<= x"00000000";
        RegB 		<= x"0A0A0A0A";
        MemWrite  	<= '1';
        MemRead		<= '0';
       	wait for 40 ns;

        -- test write to address 0x4
        address   	<= x"00000004";
        RegB		<= x"F0F0F0F0";
        MemWrite  	<= '1';
        MemRead 	<= '0';
       	wait for 40 ns;

        -- test read from 0x0
        address   	<= x"00000000";
        MemWrite  	<= '0';
        MemRead 	<= '1';
       	wait for 40 ns;
        assert(memory_out = x"0A0A0A0A") report "Error : read incorrect" severity warning;

        -- test read from 0x1
        address   	<= x"00000001";
        MemWrite  	<= '0';
        MemRead 	<= '1';
       	wait for 40 ns;
        assert(memory_out = x"0A0A0A0A") report "Error : read incorrect" severity warning;

      	-- test read from 0x4
        address   	<= x"00000004";
        MemWrite  	<= '0';
        MemRead 	<= '1';
       	wait for 40 ns;
        assert(memory_out = x"F0F0F0F0") report "Error : read incorrect" severity warning;

      	-- test read from 0x5
      	address   	<= x"00000005";
        MemWrite  	<= '0';
        MemRead 	<= '1';
       	wait for 40 ns;
        assert(memory_out = x"F0F0F0F0") report "Error : read incorrect" severity warning;

        -- test write to outport
        address 	<= x"0000FFFC";
        RegB 		<= x"00001111";
        MemWrite 	<= '1';
        MemRead 	<= '0';
        wait for 40 ns;
        assert(OutPort = x"00001111") report "Error writing to outport" severity warning;

        -- test load into inport0
		InPort0_en	<= '1';
		InPort1_en 	<= '0';
		InPort 		<= x"00010000";
        wait for 40 ns;

        -- test load into inport1
        InPort0_en  <= '0';
       	InPort1_en	<= '1';
		InPort 		<= x"00000001";
        wait for 40 ns;

        -- test read from inport0
        InPort0_en  <= '0';
        InPort1_en  <= '0';
        address 	<= x"0000FFF8";
        MemWrite 	<= '0';
        MemRead 	<= '1';
        wait for 40 ns;
        assert(memory_out = x"00010000") report "Error inport0" severity warning;

        -- test read from inport1
        address 	<= x"0000FFFC";
        MemWrite 	<= '0';
        MemRead		<= '1';
        wait for 40 ns;
        assert(memory_out = x"00000001") report "Error inport1" severity warning;

        wait;

    end process;
end TB;


