library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity debouncer is
    Port(deb_input: in STD_LOGIC;
			deb_clk: in STD_LOGIC;
			deb_rst: in STD_LOGIC;
			deb_output: out STD_LOGIC);
end debouncer;

architecture ar_debouncer of debouncer is
	
	signal debounced: STD_LOGIC := '0';
	signal hysteresis: INTEGER range 0 to 10 := 0;
	
	begin
	
	process(deb_clk, deb_rst) is
	begin
		if(deb_rst = '1') then
			hysteresis <= 0;
			debounced <= '0';
			
		elsif rising_edge(deb_clk) then
		
			if(deb_input = '1') then
				if(hysteresis < 10) then
					hysteresis <= hysteresis + 1;
				end if;
			else
				if(hysteresis > 0) then
					hysteresis <= hysteresis - 1;
				end if;
			end if;
			
			if(hysteresis > 5) then
				debounced <= '1';
			else
				debounced <= '0';
			end if;
			
		end if;
	end process;
	
	deb_output <= debounced;
	
end ar_debouncer;