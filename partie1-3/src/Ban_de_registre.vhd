library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_bank is
    Port (
        CLK : in std_logic;
        RST : in std_logic;
        W : in std_logic_vector(31 downto 0);
        RA : in std_logic_vector(3 downto 0);
        RB : in std_logic_vector(3 downto 0);
        RW : in std_logic_vector(3 downto 0);
        WE : in std_logic;
        A : out std_logic_vector(31 downto 0);
        B : out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture Behavioral of register_bank is
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);
    
    function init_banc return table is
        variable result : table;
    begin
        for i in 14 downto 0 loop
            result(i) := "00000000000000000000000000000000";
        end loop;
        result(15) := "00000000000000000000000000110000";
        return result;
    end init_banc;
    
    signal Banc: table := init_banc;
begin
    -- Asynchronous read
    A <= Banc(to_integer(unsigned(RA)));
    B <= Banc(to_integer(unsigned(RB)));
    
    -- Synchronous write
    process(CLK, RST)
    begin
        if RST = '1' then
            Banc <= init_banc;
        elsif rising_edge(CLK) then
            if WE = '1' then
                Banc(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;
end Behavioral;