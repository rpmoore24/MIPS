library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic (WIDTH : positive := 32);
    port	(
		clk 		: in std_logic;
		rst			: in std_logic;
		address		: in std_logic_vector(WIDTH-1 downto 0);
		MemRead 	: in std_logic;
		MemWrite	: in std_logic;
		RegB 		: in std_logic_vector(WIDTH-1 downto 0);
		InPort		: in std_logic_vector(WIDTH-1 downto 0);
		InPort0_en 	: in std_logic;
		InPort1_en 	: in std_logic;

		memory_out	: out std_logic_vector(WIDTH-1 downto 0);
		OutPort 	: out std_logic_vector(WIDTH-1 downto 0)
	);
end memory;

architecture STR of memory is

	signal ram_out			: std_logic_vector(WIDTH-1 downto 0);
	signal inport0_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal inport1_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal outport_en 		: std_logic;
	signal ram_wren		: std_logic;

begin

	process(address, ram_out, MemRead, MemWrite)
	begin
		outport_en 	<= '0';
		memory_out  <= ram_out;

		if (MemRead = '1' AND address = x"0000FFF8") then
			memory_out <= inport0_out;
		elsif (MemRead = '1' AND address = x"0000FFFC") then
			memory_out <= inport1_out;		
		elsif (MemWrite = '1' AND address = x"0000FFFC") then
			outport_en <= '1';
		end if;

	end process;

	U_RAM : entity work.RAM
		port map (
			address => address(9 downto 2),
			clock	=> clk,
			data 	=> RegB,
			wren 	=> MemWrite,
			q 		=> ram_out
		);

	U_INPORT0 : entity work.reg
		generic map (WIDTH => WIDTH)
		port map (
			clk  	=> clk,
			rst		=> '0',
			enable	=> InPort0_en,
			input	=> InPort,
			output 	=> inport0_out
		);

	U_INPORT1 : entity work.reg
		generic map (WIDTH => WIDTH)
		port map (
			clk 	=> clk,
			rst 	=> '0',
			enable  => InPort1_en,
			input 	=> InPort,
			output  => inport1_out
		);

	U_OUTPORT : entity work.reg
		generic map (WIDTH => WIDTH)
		port map (
			clk  	=> clk,
			rst  	=> rst,
			enable 	=> outport_en,
			input   => RegB,
			output  => OutPort
		);

end STR;
