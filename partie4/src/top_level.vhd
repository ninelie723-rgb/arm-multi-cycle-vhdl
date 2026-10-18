
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY top_level IS 
PORT (
	CLOCK_50	: IN 	std_logic;   					-- Horloge
  GPIO_0    :  INOUT STD_LOGIC_VECTOR(3 downto 0);
	KEY	: IN 	std_logic_vector(3 DOWNTO 0);  	-- Boutons Poussoir[3:0]
	HEX0	: OUT 	std_logic_vector(6 DOWNTO 0);   -- Resultatur 7 Segment 0
  HEX1	: OUT 	std_logic_vector(6 DOWNTO 0);   -- Resultatur 7 Segment 1
  HEX2	: OUT 	std_logic_vector(6 DOWNTO 0);   -- Resultatur 7 Segment 2
  HEX3	: OUT 	std_logic_vector(6 DOWNTO 0)   -- Resultatur 7 Segment 3

);
END entity;

ARCHITECTURE ARCHI OF top_level IS

signal 	rst,clk, pol,nKEY1,nKEY2,nKEY3  : std_logic;
signal Resultat : std_logic_vector(31 downto 0);
signal Data1:std_logic_vector(3 downto 0); 
signal Data2:std_logic_vector(3 downto 0);
signal Data3:std_logic_vector(3 downto 0);
signal Data4:std_logic_vector(3 downto 0);

signal Segout :std_logic_vector(1 to 7);

signal Tx,Rx : std_logic;

BEGIN

-- Gestion Boutons Poussoirs
	-- Appuye: 1 / Relache: 0
rst<=not KEY(0);
nKEY1<=not KEY(1); 
nKEY2<=not KEY(2);
nKEY3<=not KEY(3);
clk <= CLOCK_50; 
GPIO_0(0) <= Tx;
Rx <= GPIO_0(1);

U1:entity work.arm port map(
	rst			=>	rst,
	clk			=>	CLOCK_50,
	irq0		=>	nKEY1,
	irq1		=>	nKEY2,
  irq2		=>	nKEY3,
	resultat    =>	Resultat,
  Tx=>Tx,
  Rx=>Rx
);


    Data1<=Resultat(3 downto 0);  
    Data2<=Resultat(7 downto 4); 
    Data3<=Resultat(11 downto 8); 
    Data4<=Resultat(15 downto 12);  

U2:entity work.seven_seg port map(
  data=>Data1,
  segout=>HEX0
);

U3:entity work.seven_seg port map(
  data=>data2,
  segout=>HEX1
);

U4:entity work.seven_seg port map(
  data=>Data3,
  segout=>HEX2
);

U5:entity work.seven_seg port map(
  data=>Data4,
  segout=>HEX3
);

END architecture;
