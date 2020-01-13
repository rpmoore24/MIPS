library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is

    constant WIDTH  : positive                           := 8;
    signal input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal shift	: std_logic_vector(4 downto 0)		 := (others => '0');
    signal sel      : std_logic_vector(5 downto 0)       := (others => '0');
    signal LO 		: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal HI 		: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal branch	: std_logic;

begin  -- TB

    UUT : entity work.alu
        generic map (WIDTH => WIDTH)
        port map (
            input1  => input1,
            input2  => input2,
            shift   => shift,
            sel     => sel,
            LO 		=> LO,
            HI 		=> HI,
            branch	=> branch);

    process

        variable x : std_logic_vector(WIDTH-1 downto 0) := (others => '1');
        variable y : std_logic_vector(WIDTH-1 downto 0) := (others => '1');
        variable z : std_logic_vector(4 downto 0) := (others => '1');
        variable test : std_logic_vector(WIDTH-1 downto 0);

        function sum_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(in1,WIDTH)+to_unsigned(in2,WIDTH));
        end sum_test;

        function sub_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(in1,WIDTH)-to_unsigned(in2,WIDTH));
        end sub_test;

        function mult_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
            variable temp     : std_logic_vector((WIDTH*2-1) downto 0);
        begin
            temp := std_logic_vector(to_unsigned(in1*in2, WIDTH*2));
            return temp(WIDTH-1 downto 0);
        end mult_test;

        function multu_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
            variable temp     : std_logic_vector((WIDTH*2-1) downto 0);
        begin
            temp := std_logic_vector(to_unsigned(in1,WIDTH)*to_unsigned(in2,WIDTH));
            return temp(WIDTH-1 downto 0);
        end multu_test;

        function and_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(in1,WIDTH) AND to_unsigned(in2,WIDTH));
        end and_test;

        function or_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(in1,WIDTH) OR to_unsigned(in2,WIDTH));
        end or_test;

        function xor_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(to_unsigned(in1,WIDTH) XOR to_unsigned(in2,WIDTH));
        end xor_test;

        function srl_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(shift_right(to_unsigned(in1, WIDTH), in2));
        end srl_test;

        function sll_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(shift_left(to_unsigned(in1, WIDTH), in2));
        end sll_test;

        function sra_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            return std_logic_vector(shift_right(signed(to_unsigned(in1, WIDTH)), in2));
        end sra_test;

        function slt_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            if (signed(to_unsigned(in1, WIDTH)) < signed(to_unsigned(in2, WIDTH))) then
                            return std_logic_vector(to_unsigned(1, WIDTH));
            else
                return std_logic_vector(to_unsigned(0, WIDTH));
            end if;
        end slt_test;

        function sltu_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic_vector is
        begin
            if (to_unsigned(in1, WIDTH) < to_unsigned(in2,WIDTH)) then
                return std_logic_vector(to_unsigned(1, WIDTH));
            else
                return std_logic_vector(to_unsigned(0, WIDTH));
            end if;
        end sltu_test;

        function beq_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic is
        begin
            if (in1 = in2) then
                return '1';
            else
                return '0';
            end if;
        end beq_test;

        function bneq_test (
            constant in1      : integer;
            constant in2      : integer)
            return std_logic is
        begin
            if (in1 = in2) then
                return '0';
            else
                return '1';
            end if;
        end bneq_test;

        function bleq_test (
            constant in1      : integer)
            return std_logic is
        begin
            if (signed(to_unsigned(in1, WIDTH)) <= 0) then
                return '1';
            else
                return '0';
            end if;
        end bleq_test;

        function bgt_test (
            constant in1      : integer)
            return std_logic is
        begin
            if (signed(to_unsigned(in1, WIDTH)) > 0) then
                return '1';
            else
                return '0';
            end if;
        end bgt_test;

        function bgeq_test (
            constant in1      : integer)
            return std_logic is
        begin
            if (signed(to_unsigned(in1, WIDTH)) >= 0) then
                return '1';
            else
                return '0';
            end if;
        end bgeq_test;



    begin

            -- test all input combinations
          for i in 0 to to_integer(unsigned(x)) loop
            for j in 0 to to_integer(unsigned(y)) loop
                  
                  input1   <= std_logic_vector(to_unsigned(i, WIDTH));
                  input2   <= std_logic_vector(to_unsigned(j, WIDTH));
                  
                  sel      <= C_ADD_F;
                  wait for 40 ns;
                  assert(LO = sum_test(i,j)) report "Sum incorrect";
                  
                  sel      <= C_SUB_F;
                  wait for 40 ns;
                  assert(LO = sub_test(i,j)) report "Subtraction incorrect";

                  sel      <= C_MULT_F;
                  wait for 40 ns;
                  assert(LO = mult_test(i,j)) report "Multiplication incorrect";

                  sel      <= C_MULTU_F;
                  wait for 40 ns;
                  assert(LO = multu_test(i,j)) report "Multiplication unsigned incorrect";

                  sel      <= C_AND_F;
                  wait for 40 ns;
                  assert(LO = and_test(i,j)) report "AND incorrect";

                  sel      <= C_OR_F;
                  wait for 40 ns;
                  assert(LO = or_test(i,j)) report "OR incorrect";

                  sel      <= C_XOR_F;
                  wait for 40 ns;
                  assert(LO = xor_test(i,j)) report "XOR incorrect";

                  for k in 0 to to_integer(unsigned(z)) loop
                      shift    <= std_logic_vector(to_unsigned(k, 5));

                      sel      <= C_SRL_F;
                      wait for 40 ns;
                      test := srl_test(j,k);
                      assert(LO = srl_test(j,k)) report "SRL incorrect";

                      sel      <= C_SLL_F;
                      wait for 40 ns;
                      assert(LO = sll_test(j,k)) report "SLL incorrect";

                      sel      <= C_SRA_F;
                      wait for 40 ns;
                      assert(LO = sra_test(j,k)) report "SRA incorrect";
                  end loop;

                  sel      <= C_SLT_F;
                  wait for 40 ns;
                  assert(LO = slt_test(i,j)) report "SLT incorrect";

                  sel      <= C_SLTU_F;
                  wait for 40 ns;
                  assert(LO = sltu_test(i,j)) report "SLTU incorrect";

                  sel      <= C_BEQ_F;
                  wait for 40 ns;
                  assert(branch = beq_test(i,j)) report "BEQ incorrect";

                  sel      <= C_BNEQ_F;
                  wait for 40 ns;
                  assert(branch = bneq_test(i,j)) report "BNEQ incorrect";

                  sel      <= C_BLEQ_F;
                  wait for 40 ns;
                  assert(branch = bleq_test(i)) report "BLEQ incorrect";
                  
                  sel      <= C_BGT_F;
                  wait for 40 ns;
                  assert(branch = bgt_test(i)) report "BGT incorrect";

                  sel      <= C_BGEQ_F;
                  wait for 40 ns;
                  assert(branch = bgeq_test(i)) report "BGEQ incorrect";

            end loop;  -- j
          end loop;  -- i



        wait;

    end process;
end TB;

