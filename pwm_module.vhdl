library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pwm_module is
	Port(mod_up: in STD_LOGIC;
			mod_down: in STD_LOGIC;
			mod_rst: in STD_LOGIC;
			mod_hf_clk: in STD_LOGIC;
			mod_fill: out INTEGER range 0 to 10;
			mod_pwm_out: out STD_LOGIC);
end pwm_module;

architecture ar_pwm_module of pwm_module is

	component pwm_control
		Port(up: in STD_LOGIC;
				down: in STD_LOGIC;
				rst: in STD_LOGIC;
				ctrl_clk: in STD_LOGIC;
				fill: out INTEGER range 0 to 10);
	end component;
	
	component pwm_generator is
		Port(hf_clk: in STD_LOGIC;
				fill: in INTEGER range 0 to 10;
				pwm: out STD_LOGIC);
	end component;

	signal mod_int_fill: INTEGER range 0 to 10 := 0;

	begin
	
		control: pwm_control port map (up => mod_up,
										down => mod_down,
										rst => mod_rst,
										ctrl_clk => mod_hf_clk,
										fill => mod_int_fill);
		
		generator: pwm_generator port map (hf_clk => mod_hf_clk,
											fill => mod_int_fill,
											pwm => mod_pwm_out);

		mod_fill <= mod_int_fill;
		
end ar_pwm_module;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pwm_control is
	Port(up: in STD_LOGIC;
			down: in STD_LOGIC;
			rst: in STD_LOGIC;
			ctrl_clk: in STD_LOGIC;
			fill: out INTEGER range 0 to 10);
end pwm_control;

architecture ar_pwm_control of pwm_control is

	signal prev_state_up: STD_LOGIC := '0'; 
	signal prev_state_down: STD_LOGIC := '0';
	
	begin
	
	process(ctrl_clk, rst)
	
	variable int_fill: INTEGER range 0 to 10 := 0;
	
	begin
		if(rst = '1') then
			int_fill := 10;
			
		elsif rising_edge(ctrl_clk) then
			
			if(up = '1' and prev_state_up = '0') then
				prev_state_up <= '1';
		
				if(int_fill < 10) then
				int_fill := int_fill + 1;
				else
					int_fill := int_fill;
				end if;
			
			elsif(up = '0' and prev_state_up = '1') then
				prev_state_up <= '0';
				
			elsif(down = '1' and prev_state_down = '0') then
				prev_state_down <= '1';
		
				if(int_fill > 0) then
				int_fill := int_fill - 1;
				else
					int_fill := int_fill;
				end if;
		
			elsif(down = '0' and prev_state_down = '1') then
				prev_state_down <= '0';
			end if;
			
		end if;
		
		fill <= int_fill;
	
	end process;
	
end ar_pwm_control;

	
library IEEE;
use IEEE.STD_LOGIC_1164.all;	

entity pwm_generator is
	Port(hf_clk: in STD_LOGIC;
			fill: in INTEGER range 0 to 10;
			pwm: out STD_LOGIC);
end pwm_generator;

architecture ar_pwm_generator of pwm_generator is

	signal int_count: INTEGER range 0 to 9 := 0;
	signal output: STD_LOGIC;
	
	begin
	
	process(hf_clk)
	begin
		if rising_edge(hf_clk) then
			if(fill = 0) then
				output <= '0';
			elsif(fill = 10) then
				output <= '1';
			elsif(int_count >= fill) then
				output <= '0';
			else
				output <= '1';
			end if;
			
			if(int_count = 9) then
				int_count <= 0;
			else
				int_count <= int_count + 1;
			end if;
			
		end if;
	end process;
	
	pwm <= output;		

end ar_pwm_generator;