--160070042/45/50/53-
--SAAK RISC Microprocessor--
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
use ieee.numeric_std.all;

entity PriorityEncoder is
	port (x:in std_logic_vector(15 downto 0);
		s: out std_logic_vector(2 downto 0);
		d_out: out std_logic_vector(15 downto 0);
		zero_out: out std_logic := '0';
		CLK: in std_logic);
end PriorityEncoder;

architecture pencbehave of PriorityEncoder is

	signal dummyin: std_logic_vector(15 downto 0);
	--signal dummyout: std_logic_vector(15 downto 0);

	begin

		dummyin <= x;

		process(CLK, dummyin)
		begin
			--if(CLK'event and CLK = '1') then
				if(dummyin(0) = '1') then
					s <= "000";
					d_out <= dummyin and "1111111111111110";
					zero_out <= '0';
				elsif(dummyin(1) = '1') then
					s <= "001";
					d_out <= dummyin and "1111111111111100";
					zero_out <= '0';
				elsif(dummyin(2) = '1') then
					s <= "010";
					d_out <= dummyin and "1111111111111000";
					zero_out <= '0';
				elsif(dummyin(3) = '1') then
					s <= "011";
					d_out <= dummyin and "1111111111110000";
					zero_out <= '0';
				elsif(dummyin(4) = '1') then
					s <= "100";
					d_out <= dummyin and "1111111111100000";
					zero_out <= '0';
				elsif(dummyin(5) = '1') then
					s <= "101";
					d_out <= dummyin and "1111111111000000";
					zero_out <= '0';
				elsif(dummyin(6) = '1') then
					s <= "110";
					d_out <= dummyin and "1111111110000000";
					zero_out <= '0';
				else
					s <= "111";
					d_out <= "0000000000000000";
					zero_out <= '1';
				end if;
			--end if;
		end process;

		--s(0) <= not(x(6)) and ( (not(x(4)) and not(x(2)) and x(1)) or (not(x(4)) and x(3)) or (x(5))) or x(7);
		--s(1) <= (not(x(5)) and not(x(4)) and ( x(2) or x(3) ) ) or x(6) or x(7);
		--s(2) <= x(4) or x(5) or x(6) or x(7);



		--d_out <= dummyout;

end pencbehave;