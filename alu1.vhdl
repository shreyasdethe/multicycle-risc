--160070042/45/50/53--
--SAAK RISC Microprocessor--
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
use ieee.numeric_std.all;

entity alu is
	port(alu_in1, alu_in2: in std_logic_vector(15 downto 0);
		alu_src: in std_logic_vector(1 downto 0);
		CLK: in std_logic;
		alu_out: out std_logic_vector(15 downto 0);
		C_out, Z_out: out std_logic);
end entity;
architecture alu_behave of alu is

---------------------------------------------------
--signal Cinvec : std_logic_vector(0 downto 0);
signal add_out, nand_out, sub_out : std_logic_vector(16 downto 0);
--signal C_temp1, C_temp2: std_logic := '0';
--signal add_out : std_logic_vector(16 downto 0);
---------------------------------------------------



begin
	with alu_src select
		alu_out <= add_out(15 downto 0) when "00",
					nand_out(15 downto 0) when "01",
					sub_out(15 downto 0) when others;

	with alu_src select
		C_out <= add_out(16) when "00",
				 '0' when "01",
				 sub_out(16) when others;

	with alu_src select
		Z_out <= not(add_out(0) or add_out(1) or add_out(2) or add_out(3) or add_out(4) or add_out(5) or add_out(6) or add_out(7) or add_out(8) or add_out(9) or add_out(10) or add_out(11) or add_out(12) or add_out(13) or add_out(14) or add_out(15)) when "00",
				 not(sub_out(0) or sub_out(1) or sub_out(2) or sub_out(3) or sub_out(4) or sub_out(5) or sub_out(6) or sub_out(7) or sub_out(8) or sub_out(9) or sub_out(10) or sub_out(11) or sub_out(12) or sub_out(13) or sub_out(14) or sub_out(15)) when "10",
				 not(nand_out(0) or nand_out(1) or nand_out(2) or nand_out(3) or nand_out(4) or nand_out(5) or nand_out(6) or nand_out(7) or nand_out(8) or nand_out(9) or nand_out(10) or nand_out(11) or nand_out(12) or nand_out(13) or nand_out(14) or nand_out(15)) when "01",
				 '0' when others;

--	process(CLK, alu_in1, alu_in2)
--	begin
	
	
	--if(CLK'event and CLK = '1') then
		
		--if(alu_src = "00") then
		--	add_out <= std_logic_vector(unsigned('0' & alu_in1) + unsigned('0' & alu_in2)));
		--	alu_out <= add_out(15 downto 0);
		--	C_out <= add_out(16);
		--	Z_out <= not(add_out(0) or add_out(1) or add_out(2) or add_out(3) or add_out(4) or add_out(5) or add_out(6) or add_out(7) or add_out(8) or add_out(9) or add_out(10) or add_out(11) or add_out(12) or add_out(13) or add_out(14) or add_out(15));			
		--elsif(alu_src = "10") then
		--	sub_out <= std_logic_vector(unsigned('0' & alu_in1) - unsigned('0' & alu_in2));
		--	alu_out <= sub_out(15 downto 0);
		--	C_out <= add_out(16);
		--	Z_out <= not(sub_out(0) or sub_out(1) or sub_out(2) or sub_out(3) or sub_out(4) or sub_out(5) or sub_out(6) or sub_out(7) or sub_out(8) or sub_out(9) or sub_out(10) or sub_out(11) or sub_out(12) or sub_out(13) or sub_out(14) or sub_out(15));
		--elsif(alu_src = "01") then
		--	nand_out <= std_logic_vector(unsigned('1' & alu_in1) nand unsigned('1' & alu_in2));
		--	alu_out <= nand_out(15 downto 0);
		--	C_out <= '0';
		--	Z_out <= not(nand_out(0) or nand_out(1) or nand_out(2) or nand_out(3) or nand_out(4) or nand_out(5) or nand_out(6) or nand_out(7) or nand_out(8) or nand_out(9) or nand_out(10) or nand_out(11) or nand_out(12) or nand_out(13) or nand_out(14) or nand_out(15));
		--else	
		--end if;

		add_out <= std_logic_vector(unsigned('0' & alu_in1) + unsigned('0' & alu_in2));
		sub_out <= std_logic_vector(unsigned('0' & alu_in1) - unsigned('0' & alu_in2));
		nand_out <= std_logic_vector(unsigned('1' & alu_in1) nand unsigned('1' & alu_in2));

--		if(alu_src = "00") then
--			alu_out <= add_out(15 downto 0);
--			C_out <= add_out(16);
--			Z_out <= not(add_out(0) or add_out(1) or add_out(2) or add_out(3) or add_out(4) or add_out(5) or add_out(6) or add_out(7) or add_out(8) or add_out(9) or add_out(10) or add_out(11) or add_out(12) or add_out(13) or add_out(14) or add_out(15));			
--
--		elsif(alu_src = "01") then
--			alu_out <= nand_out(15 downto 0);
--			C_out <= '0';
--			Z_out <= not(nand_out(0) or nand_out(1) or nand_out(2) or nand_out(3) or nand_out(4) or nand_out(5) or nand_out(6) or nand_out(7) or nand_out(8) or nand_out(9) or nand_out(10) or nand_out(11) or nand_out(12) or nand_out(13) or nand_out(14) or nand_out(15));
--		
--		elsif(alu_src = "10") then
--			alu_out <= sub_out(15 downto 0);
--			C_out <= add_out(16);
--			Z_out <= not(sub_out(0) or sub_out(1) or sub_out(2) or sub_out(3) or sub_out(4) or sub_out(5) or sub_out(6) or sub_out(7) or sub_out(8) or sub_out(9) or sub_out(10) or sub_out(11) or sub_out(12) or sub_out(13) or sub_out(14) or sub_out(15));
--			
--		else
--		end if;			


--end process;
--
--		with alu_src select
--			alu_out <= add_out(15 downto 0) when "00",
--						nand_out(15 downto 0) when "01",
--						sub_out(15 downto 0) when others;
--
--		with alu_src select
--			C_out <= add_out(16) when "00",
--					 '0' when "01",
--					 sub_out(16) when others;
--
--		with alu_src select
--			Z_out <= add_out(0) or add_out(1) or add_out(2) or add_out(3) or add_out(4) or add_out(5) or add_out(6) or add_out(7) or add_out(8) or add_out(9) or add_out(10) or add_out(11) or add_out(12) or add_out(13) or add_out(14) or add_out(15) when "00",
--					 sub_out(0) or sub_out(1) or sub_out(2) or sub_out(3) or sub_out(4) or sub_out(5) or sub_out(6) or sub_out(7) or sub_out(8) or sub_out(9) or sub_out(10) or sub_out(11) or sub_out(12) or sub_out(13) or sub_out(14) or sub_out(15) when "10",
--					 nand_out(0) or nand_out(1) or nand_out(2) or nand_out(3) or nand_out(4) or nand_out(5) or nand_out(6) or nand_out(7) or nand_out(8) or nand_out(9) or nand_out(10) or nand_out(11) or nand_out(12) or nand_out(13) or nand_out(14) or nand_out(15) when "01",
--					 '0' when others;

end alu_behave;				 
--	process (CLK, alu_src) 

--	begin
		--if(CLK'event and CLK = '1') then
		--	if(alu_src = "00") then
		--		temp_out <= std_logic_vector(unsigned('0' & alu_in1) + unsigned('0' & alu_in2));
		--		C_out <= temp_out(16);
		--		--C_out <= std_logic_vector(unsigned('0' & alu_in1) + unsigned('0' & alu_in2))(16);
		--	elsif(alu_src = "01") then
		--		temp_out <= std_logic_vector(unsigned('0' & alu_in2) nand unsigned('0' & alu_in1));
		--	elsif(alu_src = "10") then
		--		temp_out <= std_logic_vector(unsigned('0' & alu_in1) - unsigned('0' & alu_in2));
		--		C_out <= temp_out(16);
		--		--C_out <= std_logic_vector(unsigned('0' & alu_in1) - unsigned('0' & alu_in2));
		--	end if;

		--	alu_out(15 downto 0) <= temp_out(15 downto 0);
			


		--end if;
--	end process;
