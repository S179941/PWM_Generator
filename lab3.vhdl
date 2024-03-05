library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is
	Port(clk_i: in STD_LOGIC;
			rst_i: in STD_LOGIC;
			btn: in STD_LOGIC_VECTOR (1 downto 0);
			led_o: out STD_LOGIC;
			led7seg_an_o: out STD_LOGIC_VECTOR (3 downto 0);
			led7seg_o: out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture ar_top of top is

	component divider
		Generic(N: integer := 50000000);
		Port(clk_i: in STD_LOGIC;
				rst_i: in STD_LOGIC;
				clk_o: out STD_LOGIC);
	end component;
	
	component pwm_module
	Port(mod_up: in STD_LOGIC;
			mod_down: in STD_LOGIC;
			mod_rst: in STD_LOGIC;
			mod_hf_clk: in STD_LOGIC;
			mod_fill: out INTEGER range 0 to 10;
			mod_pwm_out: out STD_LOGIC);
	end component;
	
	component display is
	Port(disp_clk: in STD_LOGIC;
			disp_input: in INTEGER range 0 to 10;
			led7seg_an_o: out STD_LOGIC_VECTOR (3 downto 0);
			led7seg_o: out STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component debouncer is
    Port(deb_input: in STD_LOGIC;
			deb_clk: in STD_LOGIC;
			deb_rst: in STD_LOGIC;
			deb_output: out STD_LOGIC);
	end component;
	
	signal clk_1MHz: STD_LOGIC;
	signal clk_1kHz: STD_LOGIC;
	signal display_fill: INTEGER range 0 to 10;
	signal button_up_purified: STD_LOGIC;
	signal button_down_purified: STD_LOGIC;
	
	begin
	
		div1MHz: divider generic map (N => 50)
								port map (clk_i => clk_i,
												rst_i => rst_i,
												clk_o => clk_1MHz);
		
		div1kHz: divider generic map (N => 50000)
								port map (clk_i => clk_i,
												rst_i => rst_i,
												clk_o => clk_1kHz);
												
		pwm_module_inst: pwm_module port map (mod_up => button_up_purified,
														mod_down => button_down_purified,
														mod_rst => rst_i,
														mod_hf_clk => clk_1MHz,
														mod_fill => display_fill,
														mod_pwm_out => led_o);
														
		up_button_debouncer: debouncer port map (deb_input => btn(0),
													deb_clk => clk_1kHz,
													deb_rst => rst_i,
													deb_output => button_up_purified);
													
		down_button_debouncer: debouncer port map (deb_input => btn(1),
													deb_clk => clk_1kHz,
													deb_rst => rst_i,
													deb_output => button_down_purified);
													
		display_inst: display port map (disp_clk => clk_1kHz,
										disp_input => display_fill,
										led7seg_an_o => led7seg_an_o,
										led7seg_o => led7seg_o);
														
end ar_top;