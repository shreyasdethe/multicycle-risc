--160070042/45/50/53--
--SAAK RISC Microprocessor--
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
use ieee.numeric_std.all;

entity memory is
	port(address: in std_logic_vector(15 downto 0);
		data_in: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(15 downto 0);
		CLK: in std_logic;
		memread, memwrite, init: in std_logic);
end entity;

architecture memory_behave of memory is
	subtype word is std_logic_vector(15 downto 0);
	type ram is array(0 to 1024) of word;
	signal fullram: ram := ((others => (others =>'0')));
begin
	process(CLK, memwrite, memread, address, data_in, fullram, init)
		--variable ram_addr_in: natural range 0 to 1024;
		begin
			if(CLK'event and CLK = '1') then
			
				--ram_addr_in := to_integer(unsigned(address));
				
				if(init = '1') then					
				-----------initializing instructions------------
				fullram(0)   <= "0001000111110010";
				fullram(50)  <= "0110001010100101";
				fullram(100) <= "0000000001010000";
				fullram(101) <= "0101000110000000";
				fullram(102) <= "1100000011000011";
				fullram(103) <= "0111100011111111";
				fullram(105) <= "0111100000000110";
				fullram(591) <= "0000000000001100";
				fullram(592) <= "0000000000110111";
				fullram(593) <= "0000000000100101";
				fullram(594) <= "0000000001100100";
				fullram(595) <= "0000000001100100";
----		
--				fullram(0)   <= "0110001001100101";
--				fullram(100) <= "0101000110000000";
--				fullram(101) <= "1100000011000011";
--				fullram(102) <= "0111100000100110";
--				fullram(103) <= "0111100000000110";
--				fullram(0)   <= "0000001010011000";
--				fullram(1)   <= "0000100101110000";
				-----------------------------------------------------
				end if;
			
				if(memwrite = '1') then
					fullram(to_integer(unsigned(address))) <= data_in;
				end if;
								
			end if;
	end process;
	data_out <= fullram(to_integer(unsigned(address)));

end memory_behave;