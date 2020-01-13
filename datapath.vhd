library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
  	generic (WIDTH : positive := 32);
  	port (
    	clk    : in  std_logic;
    	rst    : in  std_logic;

    	-- signals to/from controller
    	PCWriteCond		: in std_logic;
    	PCWrite 		: in std_logic;
    	IorD 			: in std_logic;
    	MemRead    		: in std_logic;
    	MemWrite 		: in std_logic;
    	MemToReg 		: in std_logic;
    	IRWrite 		: in std_logic;
    	RegDst    		: in std_logic;
    	RegWrite 		: in std_logic;
    	JumpAndLink 	: in std_logic;
    	IsSigned  		: in std_logic;
    	ALUSrcA			: in std_logic;
    	ALUSrcB 		: in std_logic_vector(1 downto 0);
    	OPSelect 		: in std_logic_vector(5 downto 0);
    	PCSource		: in std_logic_vector(1 downto 0);
    	HI_en 			: in std_logic;
    	LO_en 			: in std_logic;
    	ALU_LO_HI 		: in std_logic_vector(1 downto 0);
    	InPort 			: in std_logic_vector(WIDTH-1 downto 0);
    	InPort0_en 		: in std_logic;
    	InPort1_en 		: in std_logic;

    	opcode 			: out std_logic_vector(5 downto 0);
    	funct 			: out std_logic_vector(5 downto 0);
    	OutPort 		: out std_logic_vector(WIDTH-1 downto 0));
end datapath;

architecture STR of datapath is

	signal pc_en 	 		: std_logic;
	signal branch 			: std_logic;
	signal alu_pc_out	    : std_logic_vector(WIDTH-1 downto 0);
	signal pc_reg_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal pc_mux_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal alu_reg_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal regA_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal regB_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal memory_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal ir_out 			: std_logic_vector(WIDTH-1 downto 0);
	signal mem_data_out 	: std_logic_vector(WIDTH-1 downto 0);
	signal alu_mux_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal data_mux_out 	: std_logic_vector(WIDTH-1 downto 0);
	signal ir_mux_out 		: std_logic_vector(4 downto 0);
	signal read_data1 		: std_logic_vector(WIDTH-1 downto 0);
	signal read_data2 		: std_logic_vector(WIDTH-1 downto 0);
	signal sign_ext_out		: std_logic_vector(WIDTH-1 downto 0);
	signal sign_ext_shift 	: std_logic_vector(WIDTH-1 downto 0);
	signal regA_mux_out 	: std_logic_vector(WIDTH-1 downto 0);
	signal regB_mux_out 	: std_logic_vector(WIDTH-1 downto 0);
	signal alu_result_LO 	: std_logic_vector(WIDTH-1 downto 0);
	signal alu_result_HI 	: std_logic_vector(WIDTH-1 downto 0);
	signal alu_LO_out		: std_logic_vector(WIDTH-1 downto 0);
	signal alu_HI_out 		: std_logic_vector(WIDTH-1 downto 0);
	signal pc_shift 		: std_logic_vector(WIDTH-1 downto 0);
	signal PC_4 			: std_logic_vector(WIDTH-1 downto 0);

begin

	pc_en <= (PCWriteCond AND branch) OR PCWrite;
	
	U_PC_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable  => pc_en,
			input   => alu_pc_out,
			output  => pc_reg_out);

	U_PC_MUX : entity work.mux2x1
		generic map (32)
		port map (
			in1		=> alu_reg_out,
			in2 	=> pc_reg_out,
			sel 	=> IorD,
			output	=> pc_mux_out);

	U_MEMORY : entity work.memory
		generic map (32)
		port map (
			clk			=> clk,
			rst 		=> rst,
			address 	=> pc_mux_out,
			MemRead 	=> MemRead,
			MemWrite 	=> MemWrite,
			RegB 		=> regB_out,
			InPort 		=> InPort,
			InPort0_en 	=> InPort0_en,
			InPort1_en 	=> InPort1_en,
			memory_out 	=> memory_out,
			OutPort		=> OutPort);

	U_INST_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable 	=> IRWrite,
			input   => memory_out,
			output	=> ir_out);

	opcode <= ir_out(31 downto 26);
	funct  <= ir_out(5 downto 0);

	U_MEM_DATA_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable 	=> '1',
			input   => memory_out,
			output	=> mem_data_out);

	U_DATA_MUX : entity work.mux2x1
		generic map (32)
		port map (
			in1		=> mem_data_out,
			in2 	=> alu_mux_out,
			sel 	=> MemToReg,
			output	=> data_mux_out);

	U_IR_MUX : entity work.mux2x1
		generic map (5)
		port map (
			in1		=> ir_out(15 downto 11),
			in2 	=> ir_out(20 downto 16),
			sel 	=> RegDst,
			output	=> ir_mux_out);

	PC_4 <= pc_reg_out;

	U_REG_FILE : entity work.registerfile(async_read)
		port map (
			clk			=> clk,
			rst 		=> rst,
			rd_addr0 	=> ir_out(25 downto 21),
			rd_addr1 	=> ir_out(20 downto 16),
			wr_addr 	=> ir_mux_out,
			wr_en 		=> RegWrite,
			wr_data 	=> data_mux_out,
			rd_data0 	=> read_data1,
			rd_data1  	=> read_data2,
			PC_4 	    => PC_4,	
			JumpAndLink	=> JumpAndLink);

	U_SIGN_EXT : entity work.sign_extend
		generic map (16)
		port map (
			IsSigned	=> IsSigned,
			input		=> ir_out(15 downto 0),
			output		=> sign_ext_out);

	sign_ext_shift	<= sign_ext_out(WIDTH-3 downto 0) & "00";

	U_REGA : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable	=> '1',
			input 	=> read_data1,
			output	=> regA_out);

	U_REGB : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable	=> '1',
			input 	=> read_data2,
			output	=> regB_out);

	U_REGA_MUX : entity work.mux2x1
		generic map (32)
		port map (
			in1 	=> regA_out,
			in2		=> pc_reg_out,
			sel 	=> ALUSrcA,
			output  => regA_mux_out);

	U_REGB_MUX : entity work.mux4x1
		generic map (32)
		port map (
			in1 	=> sign_ext_shift,
			in2 	=> sign_ext_out,
			in3 	=> std_logic_vector(to_unsigned(4, regB_mux_out'length)),
			in4 	=> regB_out,
			sel 	=> ALUSrcB,
			output	=> regB_mux_out);

	U_ALU : entity work.alu
		generic map (32)
		port map (
			input1	=> regA_mux_out,
			input2 	=> regB_mux_out,
			shift 	=> ir_out(10 downto 6),
			sel 	=> OPSelect,
			LO 		=> alu_result_LO,
			HI 		=> alu_result_HI,
			branch 	=> branch);

	U_ALU_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable	=> '1',
			input 	=> alu_result_LO,
			output	=> alu_reg_out);

	U_LO_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable	=> LO_en,
			input 	=> alu_result_LO,
			output	=> alu_LO_out);

	U_HI_REG : entity work.reg
		generic map (32)
		port map (
			clk		=> clk,
			rst 	=> rst,
			enable	=> HI_en,
			input 	=> alu_result_HI,
			output	=> alu_HI_out);

	U_ALU_MUX : entity work.mux4x1
		generic map (32)
		port map (
			in1 	=> std_logic_vector(to_unsigned(0, alu_mux_out'length)),
			in2 	=> alu_HI_out,
			in3 	=> alu_LO_out,
			in4 	=> alu_reg_out,
			sel 	=> ALU_LO_HI,
			output	=> alu_mux_out);

	pc_shift <= pc_reg_out(31 downto 28) & ir_out(25 downto 0) & "00";

	U_ALU_PC_MUX : entity work.mux4x1
		generic map (32)
		port map (
			in1 	=> std_logic_vector(to_unsigned(0, alu_pc_out'length)),
			in2 	=> pc_shift,
			in3 	=> alu_reg_out,
			in4 	=> alu_result_LO,
			sel 	=> PCSource,
			output	=> alu_pc_out);


end STR;

