library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity UART_RX is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        Rx           : in std_logic;
        Tick_halfbit : in std_logic;
        Clear_fdiv   : out std_logic;
        Err          : out std_logic;
        Data         : out std_logic_vector(7 downto 0);
		DAV          : out std_logic
    );
end UART_RX;



architecture RTL of UART_RX is
    signal reg:std_logic_vector(7 downto 0);
	signal cnt_bit:integer range 0 to 15;
	
    type StateType is (E1,E2,E3,E4,E5,E6,E7,E8,E9);
	signal state: StateType;
	
begin
    process(Clk, Reset)
    begin
	if reset='1' then
	  state <= E1;
	  DAV <= '0';
	  cnt_bit <= 0;
	  reg <= (others=>'0');
	  Clear_fdiv  <= '0';
	  err <= '0';
	  elsif rising_edge(clk) then
	  case State is
	    when E1 =>	if Rx='0' then
		            State <= E2;
					Clear_fdiv <= '1';
					err <= '0';
					end if;				 
	    when E2 =>	Clear_fdiv <= '0';
					if Tick_halfbit='1' then
						State <= E3;					 
					end if;
		when E3 =>	if Rx='0' then
						State <= E4;
					else err <= '1';
						State <= E1;
					end if;
		when E4 =>	if Tick_halfbit='1' then
						State <= E5;
					end if;
        when E5 =>	if Tick_halfbit='1' then
						State <= E6;
						reg(cnt_bit) <= Rx;
						cnt_bit<=cnt_bit+1;					 
					end if;
        when E6 =>	if Tick_halfbit='1' then
						if cnt_bit=8 then
							State<=E7;
						else State<=E5;
						end if;
					end if;
        when E7=>	if Tick_halfbit='1' then
						cnt_bit <= 0;
						if Rx = '1' then
							data <= reg;
							DAV <= '1';
							State <= E8;
						else 
							err <= '1';
							State <= E1;
						end if;
					end if;
		when E8 =>	if Tick_halfbit='1' then 
						State <= E9;											
					end if;
        when E9 =>	if Tick_halfbit='1' then 
						State <= E1;
						DAV <= '0';
					end if; 	   
		end case;
	 end if;
	 
 end process;
	
end architecture;
	
	
	
	
	
	
	
	
	
	
	
	
	