library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_conf is
    Port (
        CLK   : in  std_logic;
        RST   : in  std_logic;
             
        addr_in : in  std_logic_vector(6 downto 0);
        regB_in : in  std_logic_vector(31 downto 0);
        Mem_in : in  std_logic_vector(31 downto 0);
        Mem_out : out  std_logic_vector(31 downto 0);

        Go   : out  std_logic;
        tx_out: out std_logic_vector(7 downto 0);
        
        
        rx_in : in  std_logic_vector(7 downto 0);
        DAV   : in  std_logic; 
        Err   : in  std_logic
    );
end entity;

architecture Behavioral of uart_conf is
    begin
        process(CLK, RST)
        begin
            if RST = '1' then
                Tx_out <= (others => '0'); -- 复位时清零
                Go <= '0';
            elsif rising_edge(CLK) then
                if addr_in = "1000000" then
                    Tx_out <= regB_in(7 downto 0);           -- 时钟上升沿更新值
                    Go <= '1';
                else
                    Go <= '0';
                end if;
            end if;
        end process;

        process(RST, addr_in, DAV, rx_in,Mem_in)
        begin
            if RST = '1' then
                Mem_out <= (others => '0'); -- 复位时清零
            else
                if addr_in = "1000001" and DAV = '1' then
                    Mem_out <= std_logic_vector(resize(signed(rx_in), 32));           -- 时钟上升沿更新值
                else
                    Mem_out <= Mem_in;
                end if;
            end if;
        end process;
end architecture;