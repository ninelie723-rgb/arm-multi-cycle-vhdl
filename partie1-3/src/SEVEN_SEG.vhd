-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEVEN_SEG is
    port (
        Data   : in  std_logic_vector(3 downto 0); -- 输入 0~F
        Segout : out std_logic_vector(1 to 7)      -- A, B, C, D, E, F, G
    );
end entity SEVEN_SEG;

architecture COMB of SEVEN_SEG is
    signal sevseg : std_logic_vector(1 to 7); -- A 到 G
begin
    process(Data)
    begin
        case Data is
            when "0000" =>  sevseg <= "1000000"; --0
			when "0001" =>  sevseg <= "1111001"; --1
			when "0010" =>  sevseg <= "0100100"; --2
			when "0011" =>  sevseg <= "0110000"; --3
			when "0100" =>  sevseg <= "0011001"; --4
			when "0101" =>  sevseg <= "0010010"; --5
			when "0110" =>  sevseg <= "0000010"; --6
			when "0111" =>  sevseg <= "1111000"; --7
			when "1000" =>  sevseg <= "0000000"; --8
			when "1001" =>  sevseg <= "0010000"; --9
			when "1010" =>  sevseg <= "0001000"; --A
			when "1011" =>  sevseg <= "0000011"; --B
			when "1100" =>  sevseg <= "1000110"; --C
			when "1101" =>  sevseg <= "0100001"; --D
			when "1110" =>  sevseg <= "0000110"; --E
			when "1111" =>  sevseg <= "0001110"; --F
			when others  => sevseg <= "0111111"; --'-'
        end case;
        segout<=sevseg;
    end process;
end architecture COMB;


