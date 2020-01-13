library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	generic(WIDTH : positive);
	port(
		IsSigned 	: in std_logic;
		input 		: in std_logic_vector(WIDTH-1 downto 0);
		output 		: out std_logic_vector(2*WIDTH-1 downto 0)
	);
end sign_extend;

architecture BHV of sign_extend is
begin
	
	process(IsSigned, input)
	begin
		if(IsSigned = '1') then
			output <= std_logic_vector(resize(signed(input), 2*WIDTH));
		else
			output <= std_logic_vector(resize(unsigned(input), 2*WIDTH));
		end if;
	end process;

end BHV;
