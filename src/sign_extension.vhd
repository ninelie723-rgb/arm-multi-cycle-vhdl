library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extension is
    Generic (N : integer := 24);
    Port (
        E : in std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end sign_extension;

architecture Behavioral of sign_extension is
begin
    S <= std_logic_vector(resize(signed(E), 32));
end Behavioral;