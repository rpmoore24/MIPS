library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity alu is
	generic (WIDTH : positive := 32);
	
	port (
		input1			: in std_logic_vector(WIDTH-1 downto 0);
		input2			: in std_logic_vector(WIDTH-1 downto 0);
		shift			: in std_logic_vector(4 downto 0);
		sel 			: in std_logic_vector(5 downto 0);
		LO 				: out std_logic_vector(WIDTH-1 downto 0);
		HI				: out std_logic_vector(wIDTH-1 downto 0);
		branch			: out std_logic
	);
		
end alu;

architecture BHV of alu is
begin
	process (input1, input2, sel)

		variable temp : unsigned((WIDTH*2)-1 downto 0);
	
	begin
		branch <= '0';
		temp := to_unsigned(0, temp'length);
		case sel is
			when C_ADD_F =>
				temp := resize(unsigned(input1), temp'length) + resize(unsigned(input2), temp'length);
			    
			when C_SUB_F =>
				temp := resize(unsigned(input1), temp'length) - resize(unsigned(input2), temp'length);

			when C_MULT_F =>
				temp := unsigned(signed(input1) * signed(input2));
			
			when C_MULTU_F =>
				temp := unsigned(input1) * unsigned(input2);

			when C_AND_F =>
				temp := resize(unsigned(input1), temp'length) AND resize(unsigned(input2), temp'length);
			
			when C_OR_F =>
				temp := resize(unsigned(input1), temp'length) OR resize(unsigned(input2), temp'length);
			
			when C_XOR_F =>
				temp := resize(unsigned(input1), temp'length) XOR resize(unsigned(input2), temp'length);

			when C_SRL_F =>
				temp(WIDTH-1 downto 0) := shift_right(unsigned(input2), to_integer(unsigned(shift)));

			when C_SLL_F =>
				temp(WIDTH-1 downto 0) := shift_left(unsigned(input2), to_integer(unsigned(shift)));

			when C_SRA_F =>
				temp(WIDTH-1 downto 0) := unsigned(shift_right(signed(input2), to_integer(unsigned(shift))));

			when C_SLT_F =>
				if (signed(input1) < signed(input2)) then
					temp := to_unsigned(1, temp'length);
				else
					temp := (others => '0');
				end if;

			when C_SLTU_F =>
				if (unsigned(input1) < unsigned(input2)) then
					temp := to_unsigned(1, temp'length);
				else
					temp := (others => '0');
				end if;

			when C_BEQ_F 	=>
				if (input1 = input2) then
					branch <= '1';
				end if;

			when C_BNEQ_F=>
				if (input1 /= input2) then
					branch <= '1';
				end if;
				
			when C_BLEQ_F =>
				if (signed(input1) <= 0) then
					branch <= '1';
				end if;
				
			when C_BGT_F 	=>
				if (signed(input1) > 0) then
					branch <= '1';
				end if;
				
			when C_BGEQ_F =>
				if (signed(input1) >= 0) then
					branch <= '1';
				end if;

			when C_JUMP_F =>
				branch	<= '1';
				temp(WIDTH-1 downto 0) := unsigned(input1);
			
			when others => null;
		
		end case;

		HI <= std_logic_vector(temp((WIDTH*2)-1 downto WIDTH));
		LO <= std_logic_vector(temp(WIDTH-1 downto 0));

	end process;
end BHV;
