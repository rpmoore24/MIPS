library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants is

	-- functions
	constant C_SLL_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#00#, 6));
	constant C_SRL_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#02#, 6));
	constant C_SRA_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#03#, 6));
	constant C_JUMP_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#08#, 6));
	constant C_MFHI_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#10#, 6));
	constant C_MFLO_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#12#, 6));
	constant C_MULT_F       : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#18#, 6));
	constant C_MULTU_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#19#, 6));
	constant C_ADD_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#21#, 6));
	constant C_SUB_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#23#, 6));
	constant C_AND_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#24#, 6));
	constant C_OR_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#25#, 6));
	constant C_XOR_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#26#, 6));
	constant C_SLT_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#2A#, 6));
	constant C_SLTU_F 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#2B#, 6));

--	constant C_BLT_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#01#, 6));
	constant C_BGEQ_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#01#, 6));
	constant C_BEQ_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#04#, 6));
	constant C_BNEQ_F	 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#05#, 6));
	constant C_BLEQ_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#06#, 6));
	constant C_BGT_F		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#07#, 6));


	-- opcodes
	constant C_RTYPE_OP 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#00#, 6));
	constant C_BGEQ_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#01#, 6));
	constant C_JADDR_OP 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#02#, 6));
	constant C_JLINK_OP 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#03#, 6));
	constant C_BEQ_OP      	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#04#, 6));
	constant C_BNEQ_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#05#, 6));
	constant C_BLEQ_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#06#, 6));
	constant C_BGT_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#07#, 6));
	constant C_ADDI_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#09#, 6));
	constant C_SLTI_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#0A#, 6));
	constant C_SLTIU_OP 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#0B#, 6));
	constant C_ANDI_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#0C#, 6));
	constant C_ORI_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#0D#, 6));
	constant C_XORI_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#0E#, 6));
	constant C_SUBIU_OP 	: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#10#, 6));
	constant C_LW_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#23#, 6));
	constant C_SW_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#2B#, 6));
	constant C_HALT_OP 		: std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(16#3F#, 6));	

end constants;

