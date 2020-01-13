library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity alu_ctrl is
  	port (

    	-- signals to/from controller
    	funct 		: in std_logic_vector(5 downto 0);
    	ALUOp		: in std_logic_vector(5 downto 0);

    	OPSelect 	: out std_logic_vector(5 downto 0);
    	HI_en		: out std_logic;
    	LO_en 		: out std_logic;
    	ALU_LO_HI	: out std_logic_vector(1 downto 0));

end alu_ctrl;

architecture BHV of alu_ctrl is

    begin

    process(ALUOp, funct)
    begin
        HI_en       <= '0';
        LO_en       <= '0';
        ALU_LO_HI   <= "00";
        OPSelect    <= "000000";

        case ALUOp is
            when C_RTYPE_OP =>
                OPSelect <= funct;

                if (funct = C_MULT_F OR funct = C_MULTU_F OR funct = C_ADD_F) then
                    HI_en <= '1';
                    LO_en <= '1';
                elsif (funct = C_MFLO_F) then
                    ALU_LO_HI <= "01";
                elsif (funct = C_MFHI_F) then
                    ALU_LO_HI <= "10";
                end if;     
            when C_JADDR_OP =>
                OPSelect <= C_JUMP_F;
            when C_JLINK_OP =>
                OPSelect <= C_JUMP_F;
            when C_BEQ_OP   =>
                OPSelect <= ALUOp;
            when C_BNEQ_OP  =>
                OPSelect <= ALUOp;
            when C_BLEQ_OP  =>
                OPSelect <= ALUOp;
            when C_BGT_OP   =>
                OPSelect <= ALUOp;
            when C_ADDI_OP  =>
                OPSelect <= C_ADD_F;
            when C_SLTI_OP  =>
                OPSelect <= C_SLT_F;
            when C_SLTIU_OP =>
                OPSelect <= C_SLTU_F;
            when C_ANDI_OP  =>
                OPSelect <= C_AND_F;
            when C_ORI_OP   =>
                OPSelect <= C_OR_F;
            when C_XORI_OP  =>
                OPSelect <= C_XOR_F;
            when C_SUBIU_OP =>
                OPSelect <= C_SUB_F;
            when C_LW_OP    =>
                OPSelect <= C_ADD_F;
            when C_SW_OP    =>
                OPSelect <= C_ADD_F;
            when C_HALT_OP  =>
                OPSelect <= C_JUMP_F;
                ALU_LO_HI <= "01";

            when others => null;
        end case;

    end process;

end BHV;