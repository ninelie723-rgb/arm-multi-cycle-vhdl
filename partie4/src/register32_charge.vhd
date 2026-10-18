library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register32_charge is
    Port (
        CLK   : in  std_logic;
        RST   : in  std_logic;       
        command : in std_logic;
        reg_in : in  std_logic_vector(31 downto 0);
        reg_out: out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of register32_charge is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            reg_out <= (others => '0'); -- 复位时清零
        elsif rising_edge(CLK) then
            if command = '1' then
            reg_out <= reg_in;           -- 时钟上升沿更新值
            end if;
        end if;
    end process;
end architecture;