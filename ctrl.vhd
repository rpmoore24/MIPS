library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity ctrl is
	generic (WIDTH : positive);
  	port (
    	clk    			: in  std_logic;
    	rst    			: in  std_logic;

    	-- signals to/from controller
    	opcode 			: in std_logic_vector(5 downto 0);

    	PCWriteCond		: out std_logic;
    	PCWrite 		: out std_logic;
    	IorD 			: out std_logic;
    	MemRead    		: out std_logic;
    	MemWrite 		: out std_logic;
    	MemToReg 		: out std_logic;
    	IRWrite 		: out std_logic;
    	RegDst    		: out std_logic;
    	RegWrite 		: out std_logic;
    	JumpAndLink 	: out std_logic;
    	IsSigned  		: out std_logic;
    	ALUSrcA			: out std_logic;
    	ALUSrcB 		: out std_logic_vector(1 downto 0);
    	ALUOp 			: out std_logic_vector(5 downto 0);
    	PCSource		: out std_logic_vector(1 downto 0));

end ctrl;




architecture FSM2P of ctrl is

    type STATE_TYPE is (S_FETCH, S_FETCH2, S_DECODE, S_BRANCH, S_BRANCH2, S_BRANCH3, S_IMMEDIATE, S_REGWRITE_I, S_JUMPNLINK, S_JUMP, S_JUMP2, S_EXECUTE, S_REGWRITE_R, S_COMPUTE_MEM_ADDR, S_MEM_READ, S_MEM_READ2, S_MEM_WRITE, S_MEM_WRITE2, S_REGWRITE, S_HALT);
    signal state, next_state : STATE_TYPE;

begin
    
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= S_FETCH;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    process(opcode, state)
	begin
        PCWriteCond <= '0';    
        PCWrite     <= '0';    
        IorD        <= '0';    
        MemRead     <= '0';    
        MemWrite    <= '0';   
        MemToReg    <= '0';   
        IRWrite     <= '0';   
        RegDst      <= '0';    
        RegWrite    <= '0';  
        JumpAndLink <= '0';   
        IsSigned    <= '0';   
        ALUSrcA     <= '0';  
        ALUSrcB     <= "00";    
        ALUOp       <= "001001";    
        PCSource    <= "00";    


        next_state <= state;

        case state is
--------------------------------------FETCH--------------------------------------
            when S_FETCH =>
                MemRead     <= '1';

                next_state <= S_FETCH2;

            when S_FETCH2 =>
                IRWrite     <= '1';
                PCWrite     <= '1';
                ALUSrcB     <= "01";

                next_state <= S_DECODE;
--------------------------------------DECODE------------------------------------
            when S_DECODE =>              
                if (opcode = C_LW_OP OR opcode = C_SW_OP) then
                    next_state <= S_COMPUTE_MEM_ADDR;
                elsif (opcode = C_RTYPE_OP) then
                    next_state <= S_EXECUTE;
                elsif (opcode = C_JADDR_OP) then
                    next_state <= S_JUMP;
                elsif (opcode = C_JLINK_OP) then
                    JumpAndLink <= '1';
                    next_state <= S_JUMP;
                elsif ((unsigned(opcode) > 8 AND unsigned(opcode) < 15) OR opcode = C_SUBIU_OP) then
                    next_state <= S_IMMEDIATE;
                elsif ((unsigned(opcode) > 3 AND unsigned(opcode) < 8) OR opcode = C_BGEQ_OP) then
                    next_state <= S_BRANCH;
                elsif (opcode = C_HALT_OP) then
                    next_state <= S_HALT;
                end if;
--------------------------------------HALT---------------------------------------------------
            when S_HALT =>
                next_state <= S_HALT;
-------------------------------------BRANCH------------------------------------------------
            when S_BRANCH =>
                ALUSrcB <= "11";

                next_state <= S_BRANCH2;

            when S_BRANCH2 =>
                ALUSrcA <= '1';
                ALUOp <= opcode;
                PCSource <= "01";
                PCWriteCond <= '1';

                next_state <= S_BRANCH3;

            when S_BRANCH3 =>
                next_state <= S_FETCH;
----------------------------------IMMEDIATE-----------------------------------------
            when S_IMMEDIATE =>               
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                ALUOp <= opcode;

                next_state <= S_REGWRITE_I;

            when S_REGWRITE_I =>
                ALUSrcA <= '1';
                ALUOp <= opcode;
                RegWrite <= '1';

                next_state <= S_FETCH;
-----------------------------------JUMP----------------------------------------------
            when S_JUMP =>
                PCSource <= "10";
                PCWrite     <= '1';

                next_state <= S_JUMP2;

            when S_JUMP2 =>
                next_state <= S_FETCH;
---------------------------------------RTYPE--------------------------------------------
            when S_EXECUTE =>
                ALUSrcA <= '1';
                ALUOp   <= opcode;
                PCWriteCond <= '1';

                next_state <= S_REGWRITE_R;

            when S_REGWRITE_R =>
                ALUSrcA <= '1';
                ALUOp   <= opcode;
                RegDst   <= '1';
                RegWrite <= '1';

                next_state <= S_FETCH;
----------------------------------------LW/SW-----------------------------------------------
            when S_COMPUTE_MEM_ADDR =>
                ALUSrcA <= '1';
                ALUSrcB <= "10";

                if (opcode = C_LW_OP) then
                    next_state <= S_MEM_READ;
                else
                    next_state <= S_MEM_WRITE;
                end if;

            when S_MEM_WRITE =>
                IorD <= '1';
                MemWrite <= '1';
                next_state <= S_MEM_WRITE2;

            when S_MEM_WRITE2 =>
                next_state <= S_FETCH;

            when S_MEM_READ =>
                IorD    <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                

                next_state <= S_MEM_READ2;

            when S_MEM_READ2 =>
                IorD    <= '1';
                MemRead <= '1';
                MemToReg   <= '1';
                next_state <= S_REGWRITE;

            when S_REGWRITE =>
                RegWrite   <= '1';
                MemToReg   <= '1';
                next_state <= S_FETCH;

            when others => null;

        end case;

    end process;
end FSM2P;