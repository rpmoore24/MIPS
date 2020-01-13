library ieee;
use ieee.std_logic_1164.all;

entity mips_top is
    port (
        clk      : in  std_logic;
        switch   : in  std_logic_vector(9 downto 0);
        button   : in  std_logic_vector(1 downto 0);
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic;
        led4     : out std_logic_vector(6 downto 0);
        led4_dp  : out std_logic;
        led5     : out std_logic_vector(6 downto 0);
        led5_dp  : out std_logic);
end mips_top;

architecture STR of mips_top is

	signal opcode 			: std_logic_vector(5 downto 0);
	signal funct  			: std_logic_vector(5 downto 0);
	signal PCWriteCond 		: std_logic;
    signal PCWrite          : std_logic;
	signal IorD 			: std_logic;
	signal MemRead 			: std_logic;
	signal MemWrite 		: std_logic;
	signal MemToReg 		: std_logic;
	signal IRWrite 			: std_logic;
	signal RegDst 			: std_logic;
	signal RegWrite 		: std_logic;
	signal JumpAndLink 		: std_logic;
	signal IsSigned 		: std_logic;
	signal AlUSrcA 			: std_logic;
	signal ALUSrcB 			: std_logic_vector(1 downto 0);
	signal ALUOp 			: std_logic_vector(5 downto 0);
	signal PCSource			: std_logic_vector(1 downto 0);
	signal OPSelect			: std_logic_vector(5 downto 0);
	signal HI_en 			: std_logic;
	signal LO_en			: std_logic;
	signal ALU_LO_HI 		: std_logic_vector(1 downto 0);
    signal InPort0_en       : std_logic;
    signal InPort1_en       : std_logic;
    signal InPort           : std_logic_vector(31 downto 0);
    signal OutPort          : std_logic_vector(31 downto 0);
    signal rst              : std_logic;

begin  -- STR

    InPort      <= "00000000000000000000000" & switch(8 downto 0);
    InPort1_en  <= (not button(1) AND switch(9));
    InPort0_en  <= (not button(1) AND not switch(9));
    rst         <= not button(0);

    U_CTRL : entity work.ctrl 
    	generic map (32)
    	port map (
    		clk 		=> clk,
    		rst 		=> rst,
    		opcode 		=> opcode,
    		PCWriteCond => PCWriteCond,
            PCWrite     => PCWrite,
    		IorD		=> IorD,
    		MemRead 	=> MemRead,
    		MemWrite 	=> MemWrite,
    		MemToReg	=> MemToReg,
    		IRWrite 	=> IRWrite,
    		RegDst 		=> RegDst,
    		RegWrite 	=> RegWrite,
    		JumpAndLink => JumpAndLink,
    		IsSigned 	=> IsSigned,
    		ALUSrcA 	=> ALUSrcA,
    		ALUSrcB 	=> ALUSrcB,
    		ALUOp 		=> ALUOp, 
    		PCSource 	=> PCSource);
	
	U_ALU_CTRL : entity work.alu_ctrl
		port map (
		    funct 		=> funct,
    		ALUOp		=> ALUOp,
			OPSelect 	=> OPSelect,
    		HI_en		=> HI_en,
    		LO_en 		=> LO_en,
    		ALU_LO_HI	=> ALU_LO_HI);

    U_DATAPATH : entity work.datapath
    	generic map (32)
    	port map (
    		clk 		=> clk,
    		rst 		=> rst, 
            PCWriteCond => PCWriteCond,
    		PCWrite 	=> PCWrite,
    		IorD 		=> IorD,
    		MemRead 	=> MemRead,
    		MemWrite 	=> MemWrite,
            MemToReg    => MemToReg,
    		IRWrite 	=> IRWrite,
    		RegDst 		=> RegDst,
    		RegWrite 	=> RegWrite,
    		JumpAndLink => JumpAndLink,
    		IsSigned 	=> IsSigned,
    		ALUSrcA 	=> ALUSrcA,
    		ALUSrcB 	=> ALUSrcB,
    		OPSelect 	=> OPSelect,
    		PCSource 	=> PCSource,
    		HI_en 		=> HI_en,
    		LO_en 		=> LO_en,
    		ALU_LO_HI 	=> ALU_LO_HI,
    		InPort 		=> InPort,
    		InPort0_en 	=> InPort0_en,
    		InPort1_en  => InPort1_en,
    		opcode 		=> opcode,
            funct       => funct,
    		OutPort 	=> OutPort);

    U_LED5 : entity work.decoder7seg 
        port map (
            input  => OutPort(23 downto 20),
            output => led5);

    U_LED4 : entity work.decoder7seg 
        port map (
            input  => OutPort(19 downto 16),
            output => led4);
    
    U_LED3 : entity work.decoder7seg 
        port map (
            input  => OutPort(15 downto 12),
            output => led3);

    U_LED2 : entity work.decoder7seg 
        port map (
            input  => OutPort(11 downto 8),
            output => led2);
    
    U_LED1 : entity work.decoder7seg 
        port map (
            input  => OutPort(7 downto 4),
            output => led1);

    U_LED0 : entity work.decoder7seg 
        port map (
            input  => OutPort(3 downto 0),
            output => led0);

    led5_dp <= '1';
    led4_dp <= '1';
    led3_dp <= '1';
    led2_dp <= '1';
    led1_dp <= '1';
    led0_dp <= '1';

end STR;