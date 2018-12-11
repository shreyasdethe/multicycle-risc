--160070042/45/50/53--
--SAAK RISC Microprocessor--
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
use ieee.numeric_std.all;

entity microprocessor is
	port (CLK, RESET: in std_logic);--);
			--state: out std_logic_vector(5 downto 0));
end microprocessor;

architecture microprocessor_behave of microprocessor is
--------------------------------------------------------


component alu is
port(alu_in1, alu_in2: in std_logic_vector(15 downto 0);
	alu_src: in std_logic_vector(1 downto 0);
	CLK: in std_logic;
	alu_out: out std_logic_vector(15 downto 0);
	C_out, Z_out: out std_logic);
end component;

component memory is
port(address: in std_logic_vector(15 downto 0);
	data_in: in std_logic_vector(15 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	CLK: in std_logic;
	memread, memwrite, init: in std_logic);
end component;

component registerfile is
port(address1, address2, address3: in std_logic_vector(2 downto 0);
		data_in1: in std_logic_vector(15 downto 0);
		data_out1, data_out2: out std_logic_vector(15 downto 0);
		--r0, r1, r2, r3, r4, r5, r6, r7: out std_logic_vector(15 downto 0);
		CLK, regwrite, regread, init: in std_logic);
end component;

component PriorityEncoder is
port (x: in std_logic_vector(15 downto 0);
	s: out std_logic_vector(2 downto 0);
	d_out: out std_logic_vector(15 downto 0);
	zero_out: out std_logic;
	CLK: in std_logic);
end component;
-----------------------------------------------------------------------------------------------

signal st: std_logic_vector(5 downto 0) := "111111";

--signal inst_reg_en, t1_en, t2_en, t3_en, t4_en,
--z_en, c_en,
signal memr, memwr, mem_init, reg_init, regr: std_logic := '0';
signal regwr : std_logic := '1';

signal c_in, z_in: std_logic := '0';
signal pezo: std_logic := '0';

signal alu_src: std_logic_vector(1 downto 0);
signal rfad1, rfad2, rfad3, peout : std_logic_vector(2 downto 0);
signal opcode: std_logic_vector(3 downto 0);

signal inst_reg_in,-- inst_reg_out,
t1_in,-- t1_out,
t2_in,-- t2_out,
t3_in,-- t3_out,
t4_in,-- t4_out,
t5_in,-- t5_out,
t6_in,-- t6_out,
alu_in1, alu_in2, alu_out,
mdin, mdout, madr,
rfdin1, rfdout1, rfdout2,
pein, pedum: std_logic_vector(15 downto 0) := "0000000000000000";
------------------------------------------------------------------------------------------------
begin
	
	process(CLK)
	begin

		if(CLK'event and CLK = '1') then
			if(st = "111111") then		--reset state
				--initialize all enables to 0
				--inst_reg_en <= '0';
				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';

				--c_in  <= '0';
				--c_out <= '0';
				--z_in  <= '0';
				--z_out <= '0';

				regwr  <= '1';
				regr   <= '0';
				rfad3  <= "111";
				rfdin1 <= "0000000000000000";
				
				
				mem_init <= '1';
				reg_init <= '1';


				st <= "000001";		--go to state 1

--------------------------------------------------------

--------------------------------------------------------
			elsif(st = "000001") then 		--state 1
				mem_init <= '0';
				reg_init <= '0';
				
				regwr <= '1';
				regr <= '1';
				memr <= '1';
				memwr <= '0';
				--inst_reg_en <= '1';
				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en <= '0';
				--c_en <= '0';

				rfad1 <= "111";		--PC address, read PC
				--madr <= rfdout1;	   --read inst. into mem
				alu_src <= "00";
				--alu_in1 <= rfdout1;	--PC in alu
				--alu_in2 <= "0000000000000001";
				rfad3 <= "111";		--write into PC
				--rfdin1 <= alu_out;

				--inst_reg_in <= mdout;
				--opcode <= mdout(15 downto 12);

				st <= "011000";
				--inst_reg_en <= '1';
				
				--if (mdout = "0000000000000000") then
				--	st <= "11111";
				--else
				--	st <= "00000";
				--end if;
------------------------------------------------------------------------------------------------------------
			elsif(st = "011000") then	--state 24
				madr <= rfdout1;
				alu_in1 <= rfdout1;
				alu_in2 <= "0000000000000001";
				--rfdin1 <= alu_out;
				st <= "100111";
-------------------------------------------------------------------------------------------------------------
			elsif(st = "100111") then 	--state 39
				rfdin1 <= alu_out;
				inst_reg_in <= mdout;

				if (mdout = "0000000000000000") then
					st <= "111111";
				else
					st <= "000000";
					opcode <= mdout(15 downto 12);
				end if;
-------------------------------------------------------------------------------------------------------------
			elsif(st = "000000") then	--state 0
				--inst_reg_en <= '0';
				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				memwr <= '0';
				memr <= '0';
				regwr <= '0';
				regr <= '0';
				
				
				if((opcode = "0000") or (opcode = "0010") or (opcode = "0100") or (opcode = "0101")) then
					st <= "000010";		--State 2 ADD/NAND/LW/SW

					elsif(opcode = "0001") then
					st <= "000101";		--State 5 ADI

					elsif(opcode = "0011") then
					st <= "001000";		--State 8 LHI

					elsif(opcode = "1100") then
					st <= "001100";		--State 12 BEQ

					elsif((opcode = "1000") or (opcode = "1001")) then
					st <= "001110";		--State 14 JAL/JLR

					elsif((opcode = "0110") or (opcode = "0111")) then
					st <= "010001";		--State 17 LM/SM
					else
					st <= "111111";
				end if;
--------------------------------------------------------------------------------------------------------------
			elsif(st = "000010") then	--state 2

				--t1_en <= '1';
				--t2_en <= '1';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
				rfad1 <= inst_reg_in(11 downto 9);
				--t1_in <= rfdout1;
				rfad2 <= inst_reg_in(8 downto 6);
				--t2_in <= rfdout2;

				st <= "011001";
--------------------------------------------------------------------------------------------------------------
			elsif (st = "011001") then 	--state 25
				t1_in <= rfdout1;
				t2_in <= rfdout2;

				if((opcode = "0000") or (opcode = "0010")) then
					if((inst_reg_in(1 downto 0) = "00")) then							--ADD
						st <= "000011";		--State 3
					elsif((inst_reg_in(1 downto 0) = "01") and (z_in = '0')) then		--goback
						st <= "000001";		--State 1
					elsif((inst_reg_in(1 downto 0) = "01") and (z_in = '1')) then		--ADZ
						st <= "000011";
					elsif((inst_reg_in(1 downto 0) = "10") and (c_in = '0')) then		--goback
						st <= "000001";
					elsif((inst_reg_in(1 downto 0) = "10") and (c_in = '1')) then		--ADC
						st <= "000011";
					end if;

				elsif((opcode = "0100") or (opcode = "0101")) then
					st <= "000110"; 		--State 6 LW/SW
				end if;
--------------------------------------------------------------------------------------------------------------
			elsif(st = "000011") then	--state 3

				--t1_en <= '0';
				--t2_en <= '1';
				--t3_en <= '0';
				--t4_en <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';

				if((opcode = "0000") or (opcode = "0010")) then	--ADD/NAND
					if((opcode = "0000")) then
						alu_src <= "00";
					elsif((opcode = "0010")) then
						alu_src <= "01";
					end if;
					
					--z_en  <= '1';
					--c_en  <= '1';
					alu_in1 <= t1_in;
					alu_in2 <= t2_in;
					--t3_in <= alu_out;
					
				elsif((opcode = "1100")) then					--BEQ
					--z_en  <= '0';
					--c_en  <= '0';
					alu_src <= "10";
					alu_in1 <= t1_in;
					alu_in2 <= t2_in;
					--t3_in <= alu_out;
				end if;

				st <= "101000";
				--t3_in <= alu_out;
--------------------------------------------------------------------------------------------------------------
			elsif(st = "101000") then 	--state 40
				t3_in <= alu_out;

				if((opcode = "0000") or (opcode = "0010")) then
					st <= "000100";
				elsif((opcode = "1100") and z_in = '0') then
					st <= "000001";
				elsif((opcode = "1100") and z_in = '1') then
					st <= "001101";
				end if;
--------------------------------------------------------------------------------------------------------------
			elsif(st = "000100") then 	--state 4

				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';

				regwr <= '1';
				regr <= '0';
				memr  <= '0';
				memwr <= '0';
				rfad3 <= inst_reg_in(5 downto 3);
				--rfdin1 <= t3_in;

				st <= "011010";
				--st <= "00001";		--State1 finished go back
----------------------------------------------------------------------------------------------------------------
			elsif(st = "011010") then 	--state 26
				rfdin1 <= t3_in;
				st <= "000001";		--State1 finished go back
----------------------------------------------------------------------------------------------------------------
			elsif(st = "000101") then 	--state 5

				--t1_en <= '0';
				--t2_en <= '1';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';

				regwr <= '0';
				regr <= '1';
				memr  <= '0';
				memwr <= '0';
				rfad1 <= inst_reg_in(11 downto 9);
				--t2_in <= rfdout1;

				st <= "011011";		--State 6 ADI
--------------------------------------------------------------------------------------------------------------
			elsif(st = "011011") then	--state 27
				t2_in <= rfdout1;
				st <= "000110";
--------------------------------------------------------------------------------------------------------------
			elsif(st = "000110") then	--state 6
				regwr <= '0';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
				alu_src <= "00";
				if((opcode = "0001") or (opcode = "0100") or (opcode = "0101")) then
--					if(inst_reg_in(5) = '1') then
--						alu_in1(15 downto 6) <= "1111111111";
--						alu_in1(5 downto 0) <= inst_reg_in(5 downto 0);
--						else 
--						alu_in1(15 downto 6) <= "0000000000";
--						alu_in1(5 downto 0) <= inst_reg_in(5 downto 0);
						alu_in1(15 downto 6) <= "0000000000";
						alu_in1(5 downto 0) <= inst_reg_in(5 downto 0);
--					end if;
--
					elsif((opcode = "1000")) then
--						if(inst_reg_in(8) = '1') then
--							alu_in1(15 downto 9) <= "1111111";
--							alu_in1(8 downto 0) <= inst_reg_in(8 downto 0);
--							else 
--							alu_in1(15 downto 9) <= "0000000";
--							alu_in1(8 downto 0) <= inst_reg_in(8 downto 0);
--						end if;
							alu_in1(15 downto 9) <= "0000000";
							alu_in1(8 downto 0) <= inst_reg_in(8 downto 0);
					end if;


					--t1_en <= '0';
					--t2_en <= '1';
					--t3_en <= '0';
					--t4_en <= '0';
					--z_en  <= '1';
					--c_en  <= '1';
					--inst_reg_en <= '0';

					alu_in2 <= t2_in;						
					--t3_in <= alu_out;

					st <= "101001";
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "101001") then 	--state 41
				t3_in <= alu_out;

				if   (opcode = "0001") then st <= "000111";	-- State 7  ADI
				elsif(opcode = "0100") then st <= "001001"; 	-- State 9  LW
				elsif(opcode = "0101") then st <= "001011"; 	-- State 11 SW
				elsif(opcode = "1000") then st <= "001111"; 	-- State 15 JAL
				end if;
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "000111") then 	--state 7

				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '1';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
				rfad3 <= inst_reg_in(8 downto 6);
				--rfdin1 <= t3_in;

				--st <= "00001";		--finished goback State 1
				st <= "011100";
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "011100") then 	--state 28
				rfdin1 <= t3_in;
				st <= "000001";
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "001000") then	--state 8

				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '1';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
				rfad3 <= inst_reg_in(11 downto 9);

				--rfdin1(15 downto 7) <= inst_reg_in(8 downto 0);
				--rfdin1(6 downto 0) <= "0000000";

				--st <= "00001"; 		--finished goback State 1
				st <= "011101";
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "011101") then 	-- state 29
				rfdin1(15 downto 7) <= inst_reg_in(8 downto 0);
				rfdin1(6 downto 0) <= "0000000";

				st <= "000001"; 		--finished goback State 1
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "001001") then	--state 9

				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '0';
				memwr <= '0';
				memr  <= '1';
				madr <= t3_in;
				--t1_in <= mdout;
				st <= "101110";
				--st <= "001010";		--State 10
				--memr <= '0';
------------------------------------------------------------------------------------------------------------------
			elsif(st = "101110") then 	--state 46
				t1_in <= mdout;
				st <= "001010";
------------------------------------------------------------------------------------------------------------------
			elsif(st = "001010") then 	--state 10

				--t1_en <= '1';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				--memwr <= '0';

				regwr <= '1';
				regr <= '0';
				memr  <= '0';
				memwr <= '0';
				rfad3 <= inst_reg_in(11 downto 9);
				--rfdin1 <= t1_in;

				st <= "011110"; 	--finished goback State 1
------------------------------------------------------------------------------------------------------------------
			elsif(st = "011110") then 	--state 30
				rfdin1 <= t1_in;
				st <= "000001"; 	--finished goback State 1
------------------------------------------------------------------------------------------------------------------
 			elsif(st = "001011") then 	--state 11

 			--	t1_en <= '0';
 			--	t2_en <= '0';
 			--	t3_en <= '0';
 			--	t4_en <= '0';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '0';
 				memwr <= '1';
 				memr  <= '0';
 				madr <= t3_in;
 				mdin <= t1_in;

 				st <= "000001";		--finished goback State 1
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "001100") then 	--state 12
 				regwr <= '0';
 				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
 				rfad1 <= inst_reg_in(11 downto 9);
 				rfad2 <= inst_reg_in(8 downto 6);

				alu_src <= "10";
-- 				if(inst_reg_in(5) = '1') then
-- 					alu_in1(5 downto 0) <= inst_reg_in(5 downto 0);
-- 					alu_in1(15 downto 6) <= "1111111111";
-- 				else 
 					alu_in1(5 downto 0) <= inst_reg_in(5 downto 0);
 					alu_in1(15 downto 6) <= "0000000000";
-- 				end if;

 				alu_in2 <= "0000000000000001";

 			--	t1_en <= '1';
 			--	t2_en <= '1';
 			--	t3_en <= '1';
 			--	t4_en <= '0';
 			--	z_en  <= '1';
 			--	c_en  <= '1';
				--inst_reg_en <= '0';

 				--t1_in <= rfdout1;
 				--t2_in <= rfdout2;
 				--t4_in <= alu_out;

 				st <= "011111"; 			--State 3 BEQ
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "011111") then 	--state 31
 				t1_in <= rfdout1;
 				t2_in <= rfdout2;
 				t4_in <= alu_out;
 				st <= "000011";
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "001101") then	--state 13

 			--	t1_en <= '0';
 			--	t2_en <= '0';
 			--	t3_en <= '0';
 			--	t4_en <= '0';
 			--	z_en  <= '1';
 			--	c_en  <= '1';
				--inst_reg_en <= '0';
				regwr <= '1';
				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
 				rfad1 <= "111";
 				alu_src <= "00";
 				--alu_in1 <= rfdout1;	--PC into alu_in1
 				--alu_in2 <= t4_in;
 				rfad3 <= "111";
 				--rfdin1 <= alu_out;

 				--st <= "000001";		--finished goback State 1
 				st <= "100000";
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "100000") then 		--state 32
 				alu_in1 <= rfdout1;	--PC into alu_in1
 				alu_in2 <= t3_in;
 				--rfdin1 <= alu_out;
 				--st <= "000001";
 				st <= "101010";
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "101010") then 	--state 42
 				rfdin1 <= alu_out;
 				st <= "000001";
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "001110") then 	--state 14

 			--	t1_en <= '0';
 			--	t2_en <= '1';
 			--	t3_en <= '0';
 			--	t4_en <= '0';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';

				memr  <= '0';
				memwr <= '0';
				regwr <= '1';
				regr  <= '1';
 				rfad1 <= "111";
 				rfad3 <= inst_reg_in(11 downto 9);
 				--rfdin1 <= rfdout1;
 				--t2_in <= rfdout1;
 				st <= "100001";
 				--if((opcode = "1000")) then
 				--	st <= "000110"; 		--State 6 JAL
 				--	elsif((opcode = "1001")) then
 				--	st <= "010000"; 		--State 16 JLR
 				--end if;
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "100001") then 	--state 33
 				rfdin1 <= rfdout1;
 				t2_in <= rfdout1;

 				if((opcode = "1000")) then
 					st <= "000110"; 		--State 6 JAL
 					elsif((opcode = "1001")) then
 					st <= "010000"; 		--State 16 JLR
 				end if;
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "001111") then 	--state 15

 			--	t1_en <= '0';
 			--	t2_en <= '0';
 			--	t3_en <= '0';
 			--	t4_en <= '0';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';

 				regwr <= '1';
 				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
 				rfad3 <= "111";
 				--rfdin1 <= t2_in;
 				st <= "100010";
 				--st <= "000001";		--finished goback State 1 JAL
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "100010") then 	--state 34
 				rfdin1 <= t2_in;
 				st <= "000001";		--finished goback State 1 JAL
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "010000") then 	--state 16

 			--	t1_en <= '0';
 			--	t2_en <= '0';
 			--	t3_en <= '0';
 			--	t4_en <= '0';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '1';
				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
 				rfad1 <= inst_reg_in(8 downto 6);
 				rfad3 <= "111";
 				--rfdin1 <= rfdout1;
 				st <= "100011";
 				--st <= "000001";		--finished goback State 1 JLR
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "100011") then 	--state 35
 				rfdin1 <= rfdout1;
 				st <= "000001";		--finished goback State 1 JLR
 -----------------------------------------------------------------------------------------------------------------
 			elsif(st = "010001") then 	--state 17

 			--	t1_en <= '1';
 			--	t2_en <= '0';
 			--	t3_en <= '1';
 			--	t4_en <= '0';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
 				rfad1 <= inst_reg_in(11 downto 9);
 				--t1_in <= rfdout1;

 				t3_in(15 downto 8) <= "00000000";		--9th bit is always 0
 				t3_in(7 downto 0) <= inst_reg_in(7 downto 0);

 				st <= "100100";
 				--st <= "010010";			--State 18 LM
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "100100") then 	--state 36
				t1_in <= rfdout1;
				st <= "010010";			--State 18 LM 				
 ----------------------------------------------------------------------------------------------------------------
 			elsif(st = "010010") then 	--state 18

 			--	t1_en <= '0';
 			--	t2_en <= '0';
 			--	t3_en <= '1';
 			--	t4_en <= '1';
 			--	z_en  <= '0';
 			--	c_en  <= '0';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
 				pein <= t3_in;

 				st <= "101101";
 			--	t6_in <= pedum;
 			--	t4_in(2 downto 0) <= peout;
 			--	t4_in(15 downto 3) <= "0000000000000";
 			--	if(pezo = '1') then
 			--		st <= "000001"; 	--goback State 1
				--else
 			--		if((opcode = "0110")) then
 			--			st <= "010011";		--State 19 / LM
				--	elsif((opcode = "0111")) then
 			--			st <= "010101";		--State 21 / SM
 			--		end if;
 			--	end if;
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "101101") then 	--state 45
				t6_in <= pedum;
 				t4_in(2 downto 0) <= peout;
 				t4_in(15 downto 3) <= "0000000000000";
				if((opcode = "0110")) then
					st <= "010011";		--State 19 / LM
				elsif((opcode = "0111")) then
					st <= "010101";		--State 21 / SM
				end if;
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "010011") then	--state 19

				--t1_en <= '1';
				--t2_en <= '1';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '1';
				--c_en  <= '1';
				--inst_reg_en <= '0';

				--pezo <= '1';
				regwr <= '0';
				regr  <= '0';
				memr  <= '1';
				memwr <= '0';
				t3_in <= t6_in;
				madr  <= t1_in;
				alu_src <= "00";
				alu_in1 <= t1_in;
				alu_in2 <= "0000000000000001";
				--t2_in <= mdout;
				--t5_in <= alu_out;
				--st <= "010100";			--State 20
				st <= "101011";
----------------------------------------------------------------------------------------------------------------
			elsif(st = "101011") then 	--state 43
				t5_in <= alu_out;
				t2_in <= mdout;
				st <= "010100";			--State 20
----------------------------------------------------------------------------------------------------------------
			elsif(st = "010100") then	--state 20

				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				--inst_reg_en <= '0';
				t1_in <= t5_in;
				regwr <= '1';
				regr  <= '0';
				memr  <= '0';
				memwr <= '0';
				rfad3 <= t4_in(2 downto 0);
				--rfdin1 <= t2_in;
				rfdin1 <= t2_in;
				st <= "100101";
				--st <= "010010";			--State 18 goback in a loop;
-----------------------------------------------------------------------------------------------------------------
			elsif (st = "100101") then 	--state 37
				if(pezo = '1') then
					st <= "000001";
				else				
					st <= "010010";			--State 18 goback in a loop;
				end if;
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "010101") then	--state 21
				--pezo <= '1';
				--inst_reg_en <= '0';
				--t1_en <= '0';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '0';
				--c_en  <= '0';
				regwr <= '0';
				regr  <= '1';
				memr  <= '0';
				memwr <= '0';
				t3_in <= t6_in;
				--t1_in <= t5_in;
				rfad1 <= t4_in(2 downto 0);
				--t2_in <= rfdout1;
				st <= "100110";
				--st <= "010110";			
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "100110") then 	--state 38
				t2_in <= rfdout1;
				st <= "010110";			--State 22
-----------------------------------------------------------------------------------------------------------------
			elsif(st = "010110") then 	--state 22

				--t1_en <= '1';
				--t2_en <= '0';
				--t3_en <= '0';
				--t4_en <= '0';
				--z_en  <= '1';
				--c_en  <= '1';
				--inst_reg_en <= '0';
				regwr <= '0';
				regr  <= '0';
				memwr <= '1';
				memr  <= '0';
				madr <= t1_in;
				alu_src <= "00";
				alu_in1 <= t1_in;
				alu_in2 <= "0000000000000001";
				mdin <= t2_in;
				--t5_in <= alu_out;
				--st <= "010010";			--State 18 goback in a loop;
				st <= "101100";
------------------------------------------------------------------------------------------------------------------
			elsif(st = "101100") then 	--state 44
				t1_in <= alu_out;
				if(pezo = '1') then 
					st <= "000001";
				else
					st <= "010010";			--State 18 goback in a loop;
				end if;
------------------------------------------------------------------------------------------------------------------
			end if;
		
--		if(st = "00001") then
--			opcode <= inst_reg_in(15 downto 12);
--			inst_reg_en <= '1';
--			inst_reg_in <= mdout;
--		end if;

		--if(st = "10010") then
		--	pein <= t3_in;
		--end if;
		
		--st <= nst;
		--state <= st;
		

	end if;

end process;

	--zero_flag: 	dbitflipflop port map(d_in => z_in, d_out => z_out, en => z_en, CLK => CLK);
	--carry_flag: dbitflipflop port map(d_in => c_in, d_out => c_out, en => c_en, CLK => CLK);

	--inst_reg: 	dflipflop port map (d_in => inst_reg_in, d_out => inst_reg_out, en => inst_reg_en, CLK => CLK);
	--t1: 			dflipflop port map (d_in => t1_in, d_out => t1_out, en => t1_en, CLK => CLK);
	--t2: 			dflipflop port map (d_in => t2_in, d_out => t2_out, en => t2_en, CLK => CLK);
	--t3: 			dflipflop port map (d_in => t3_in, d_out => t3_out, en => t3_en, CLK => CLK);
	--t4: 			dflipflop port map (d_in => t4_in, d_out => t4_out, en => t4_en, CLK => CLK);

	alu1:			alu port map (alu_in1 => alu_in1, alu_in2 => alu_in2, C_out => c_in, Z_out => z_in, alu_src => alu_src, alu_out => alu_out, CLK => CLK);
	memory1:		memory port map (address => madr, data_in => mdin, data_out => mdout, CLK => CLK, memread => memr, memwrite => memwr, init => mem_init);
	regfile1:	registerfile port map (address1 => rfad1, address2 => rfad2, address3 => rfad3, data_in1 => rfdin1, data_out1 => rfdout1, data_out2 => rfdout2, regwrite => regwr, regread => regr, init => reg_init, CLK => CLK);--, r0 => r0, r1 => r1, r2 => r2, r3 => r3, r4 => r4, r5 => r5, r6 => r6, r7 => r7);
	pen1:			PriorityEncoder port map (x => pein, s => peout, d_out => pedum, zero_out => pezo, CLK => CLK);

--process(CLK)
--begin
--	if(CLK'event and CLK = '1') then
--		st <= nst;
--	end if;
--end process;

end microprocessor_behave;
