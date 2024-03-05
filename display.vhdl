library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity display is
	Port(disp_clk: in STD_LOGIC;
			disp_input: in INTEGER range 0 to 10;
			led7seg_an_o: out STD_LOGIC_VECTOR (3 downto 0);
			led7seg_o: out STD_LOGIC_VECTOR (7 downto 0));
end display;

architecture ar_display of display is

	signal digits: STD_LOGIC_VECTOR (3 downto 0) := "1111";
	signal segments: STD_LOGIC_VECTOR (7 downto 0) := "11111111";
	
	begin
	
	process(disp_clk)
	begin
		if rising_edge(disp_clk) then
		
			if(digits = "0111") then
				digits <= "1011";
				if(disp_input = 10) then
					segments <= "10011111";
				else
					segments <= "11111111";
				end if;
					
			elsif(digits = "1011") then
				digits <= "1101";
				case disp_input is
					when 0 => segments <= ("00000011");
					when 1 => segments <= ("10011111");
					when 2 => segments <= ("00100101");
					when 3 => segments <= ("00001101");
					when 4 => segments <= ("10011001");
					when 5 => segments <= ("01001001");
					when 6 => segments <= ("01000001");
					when 7 => segments <= ("00011111");
					when 8 => segments <= ("00000001");
					when 9 => segments <= ("00001001");
					when 10 => segments <= ("00000011");
				end case;
				
			elsif(digits = "1101") then
				digits <= "1110";
				segments <= "00000011";
				
			else
				digits <= "0111";
				segments <= "11111111";
			end if;
		
		end if;
	end process;
	
	led7seg_an_o <= digits;
	led7seg_o <= segments;
	
end ar_display;