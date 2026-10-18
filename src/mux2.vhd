library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    Generic (N : integer := 32);
    Port (
        A, B : in std_logic_vector(N-1 downto 0);
        COM : in std_logic;
        S : out std_logic_vector(N-1 downto 0)
    );
end mux2;

architecture Behavioral of mux2 is
begin
    S <= A when COM = '0' else B;
end Behavioral;