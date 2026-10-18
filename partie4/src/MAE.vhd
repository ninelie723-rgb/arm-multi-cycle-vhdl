
-- library ieee;
-- use ieee.std_logic_1164.all;

-- entity MAE is
--   port(
--         clk    	: in  std_logic;					-- Horloge
--         rst     : in  std_logic;					-- Reset Asynchrone
        
-- 		-- Gestion des Interruptions
-- 		irq     : in std_logic ;					-- Requete d'Interruption
--         irq_serv: out std_logic;					-- Acquittement Inerruption
        
-- 		-- Gestion des Instructions
-- 		inst_mem: in std_logic_vector(31 downto 0);	-- Instruction sortant de la mémoire
--         inst_reg: in std_logic_vector(31 downto 0);	-- Instruction a Decoder (REG INST)
--         N   	: in std_logic; -- Drapeaux de l'ALU
        
-- 		-- COMMANDES  
-- 		-- Memoire Interne
--         AdrSel	: out std_logic;					-- Commande Mux Bus Adresses
--         memRdEn	: out std_logic;					-- Read Enable
--         memWrEn : out std_logic;					-- Write Enable
        
--         -- Registre Instruction
--         irWrEn  : out std_logic;					-- Write Enable              
        
--         -- Banc de Registres
--         WSel    : out std_logic;					-- Commande Mux Bus W
--         RegWrEn	: out std_logic;       				-- Write Enable
        
--         -- ALU
--         AluSelA : out std_logic;					-- Selection Entree A ALU
--         AluSelB	: out std_logic_vector(1 downto 0);	-- Selection Entree B ALU
--         AluOP 	: out std_logic_vector(1 downto 0);	-- Selection Operation ALU
        
--         --Registres d'Etat CPSR et SPSR
--         CpsrSel	: out std_logic; 					-- Mux Selection Entree CPSR
--         CpsrWrEn: out std_logic;					-- Write Enable CPSR
--         SpsrWrEn: out std_logic;					-- Write Enable SPSR
        
--         -- Registres PC et LR      
--         PCSel 	: out std_logic_vector(1 downto 0);	-- Selection Entree Registre PC
--         PCWrEn 	: out std_logic;					-- Write Enable PC
--         LRWrEn 	: out std_logic;					-- Write Enable LR
        
--         -- Registre Resultat
--         ResWrEn	: out std_logic;						-- Write Enable Registre Resultat
--         RbSel   : out std_logic	
--       );
-- end entity ;
  
-- architecture archi of MAE is
    
--     type enum_instruction is (VID,MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT_True, BLT_False, BX, ISR);
--     signal instruct : enum_instruction;

--     type StateType is (E0,E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11,E12,E13,E14,E15,E16,E17);
--     signal state : StateType;

--     signal inst_new, inst_old : enum_instruction;

-- begin 


--     inst_new <= BX          when inst_mem = "11101011000000000000000000000000" else
--                 ISR         when irq='1' or inst_mem = "00000000000000000000000000000000" else
--                 BLT_True    when inst_mem(27 downto 26) = "10" and inst_mem(31 downto 28) = "1011" and N = '1' else 
--                 BLT_False   when inst_mem(27 downto 26) = "10" and inst_mem(31 downto 28) = "1011" and N = '0' else
--                 BAL         when inst_mem(27 downto 26) = "10" else
--                 MOV         when inst_mem(24 downto 21) = "1101" else
--                 ADDi        when inst_mem(24 downto 21) = "0100" and inst_mem(25) = '1' else
--                 ADDr        when inst_mem(24 downto 21) = "0100" else
--                 CMP         when inst_mem(24 downto 21) = "1010" else
--                 LDR         when inst_mem(24 downto 21) = "0000" and inst_mem(20) = '1' else
--                 STR         when inst_mem(24 downto 21) = "0000" else

--                 VID;

--     inst_old <= BX          when inst_reg = "11101011000000000000000000000000" else
--                 ISR         when irq='1'or inst_mem = "00000000000000000000000000000000"else
--                 BLT_True    when inst_reg(27 downto 26) = "10" and inst_reg(31 downto 28) = "1011" and N = '1' else 
--                 BLT_False   when inst_reg(27 downto 26) = "10" and inst_reg(31 downto 28) = "1011" and N = '0' else
--                 BAL         when inst_reg(27 downto 26) = "10" else
--                 MOV         when inst_reg(24 downto 21) = "1101" else
--                 ADDi        when inst_reg(24 downto 21) = "0100" and inst_reg(25) = '1' else
--                 ADDr        when inst_reg(24 downto 21) = "0100" else
--                 CMP         when inst_reg(24 downto 21) = "1010" else
--                 LDR         when inst_reg(24 downto 21) = "0000" and inst_reg(20) = '1' else
--                 STR         when inst_reg(24 downto 21) = "0000" else

--                 VID;


-- process(CLK,RST)
-- begin

--     if RST = '1' then
--         State <= E0;
--         AdrSel	<= '0';					-- Commande Mux Bus Adresses
--         memRdEn	<= '1';					-- Read Enable
--         memWrEn <= '0';					-- Write Enable
--         irWrEn  <= '0';					-- Write Enable              
--         WSel    <= '0';					-- Commande Mux Bus W
--         RegWrEn	<= '0';       				-- Write Enable
--         AluSelA <= '0';					-- Selection Entree A ALU
--         AluSelB	<= "00";	             -- Selection Entree B ALU
--         AluOP 	<= "00";	             -- Selection Operation ALU
--         CpsrSel	<= '0'; 					-- Mux Selection Entree CPSR
--         CpsrWrEn<= '0';					-- Write Enable CPSR
--         SpsrWrEn<= '0';					-- Write Enable SPSR   
--         PCSel 	<= "00";	            -- Selection Entree Registre PC
--         PCWrEn 	<= '0';					-- Write Enable PC
--         LRWrEn 	<= '0';					-- Write Enable LR
--         ResWrEn	<= '0';						
--         RbSel   <= '0';

--     elsif rising_edge(clk) then
--     case State is  
-- 	when E0 =>
--         -- initialize
--         AdrSel	<= '0';					-- Commande Mux Bus Adresses
--         --memRdEn	<= '1';					-- Read Enable
--         memWrEn <= '0';					-- Write Enable
--         irWrEn  <= '0';					-- Write Enable              
--         WSel    <= '0';					-- Commande Mux Bus W
--         RegWrEn	<= '0';       				-- Write Enable
--         AluSelA <= '0';					-- Selection Entree A ALU
--         AluSelB	<= "00";	             -- Selection Entree B ALU
--         AluOP 	<= "00";	             -- Selection Operation ALU
--         CpsrSel	<= '0'; 					-- Mux Selection Entree CPSR
--         CpsrWrEn<= '0';					-- Write Enable CPSR
--         SpsrWrEn<= '0';					-- Write Enable SPSR   
--         PCSel 	<= "00";	            -- Selection Entree Registre PC
--         PCWrEn 	<= '0';					-- Write Enable PC
--         LRWrEn 	<= '0';					-- Write Enable LR
--         ResWrEn	<= '0';						
--         RbSel   <= '0';
--         -- next state
        
--         State   <= E1;
--         AdrSel  <= '0';
--         memRdEn <= '0'; 
--         irWrEn   <= '1';

-- 	when E1 =>
--         if inst_new = LDR or inst_new = STR or inst_new = ADDi or 
--             inst_new = ADDr or inst_new = CMP or inst_new = MOV then
-- 	        State <= E2;
--             PCSel   <= "00";
--             PCWrEn  <= '1';
--             AluSelA <= '0';
--             AluSelB <= "11";
--             AluOP   <= "00";

--             irWrEn   <= '0';

-- 		elsif inst_new = BAL or inst_new = BLT_True then
--             state <= E11;
--             PCSel <= "00";
--             AluSelA <= '0';
--             AluSelB <= "10";
--             AluOP <= "00";
--             PCWrEn  <= '1';

--             irWrEn   <= '0';

            
--         elsif inst_new = BLT_False then
--             state <= E12;
--             PCSel <= "00";
--             AluSelA <= '0';
--             AluSelB <= "11";
--             AluOP <= "00";
--             PCWrEn <= '1';

--             irWrEn   <= '0';
--         elsif inst_new = ISR then
--             state <= E14;
--             LRWrEn<='1';
--             SpsrWrEn<='1';
--             inst_mem<= "00000000000000000000000000000000";
--             irWrEn   <= '0';

--         elsif inst_new = BX then
--             state <= E17;
--             PCSel <= "10";
--             PCWrEn <= '1';
--             CpsrSel<='1';
--             CpsrWrEn<='1';
                        
--             irWrEn   <= '0';

--         end if;

        
--         irq_serv <= '0';  --???
        
--         when E2 =>
--         PCWrEn  <= '0';
--         memRdEn <= '0';
--         if inst_old = LDR or inst_old = STR or inst_old = ADDi then
--             state <= E3;
--             AluSelA <= '1';
--             -- AluSelB	<= "01";
--             AluOP   <= "11";
--             memRdEn <= '0';

--         elsif inst_old = ADDr then
--             state <= E3;
--             AluSelA <= '1';
--             AluSelB	<= "00";
--             AluOP   <= "00";

--             memRdEn <= '0';

--         elsif inst_old = MOV then
--             State <= E3;
--             AluOP <= "01";
--             AluSelB <= "01";

--             memRdEn <= '0';

--         elsif inst_old = CMP then
--             State <= E3; 
--             AluSelA  <= '1';
--             AluSelB	 <= "01";
--             AluOP    <= "10";
--             CpsrSel	 <= '0';					-- Mux Selection Entree CPSR
--             CpsrWrEn <= '1';
--             memRdEn <= '1';

--         end if;
        
--     when E3 =>
--         if inst_old = LDR or inst_old = STR or inst_old = ADDi then
--             state <= E4;
--             if inst_old = LDR then
--                 AdrSel	<= '1';					-- Commande Mux Bus Adresses
--                 memRdEn <= '1';
    
--             elsif inst_old = STR then
--                 AdrSel   <= '1';
--                 memWrEn  <= '1';
    
--             elsif inst_old = ADDi then
--                 AluOP <= "00";
--                 AluSelA <= '1';
--                 AluSelB <= "01";
--                 -- WSel <= '1';
--                 -- RegWrEn <= '1';
--                 -- memRdEn <= '1';
    
--             end if;

--         elsif inst_old = ADDr then
--             state <= E5;
--             WSel <= '1';
 
--         elsif inst_old = MOV then
--             State <= E6;
--             WSel<='1';
--             RegWrEn<='1';

--         elsif inst_old = CMP then
--             State <= E7; 
--             memRdEn <= '1';
--             CpsrWrEn<='0';
--             PCSel 	<= "00";

--         end if;

--     when E4 =>  -- A+Imm8
--         if inst_old = LDR then
--             state <= E8;


--         elsif inst_old = STR then
--             state <= E9;
--             AdrSel <= '1';
--             MemWrEn <= '1';
--             ResWrEn <= '1';

--         elsif inst_old = ADDi then
--             state <= E10;
            

--         end if;


--     when E5 =>  -- A+B
--         State   <= E10;
--         RegWrEn <= '1';
       
--     when E6 => -- Imm8
--         State <= E10;


--     when E7 => 
--         State    <= E0;


--     when E8 => 
--         State    <= E16;
       
--         WSel <= '0';
--         RegWrEn <= '1';

--     when E16 =>
--         State    <= E0;
--         memRdEn <= '1';
--         PCSel 	<= "00";
--         AdrSel	<= '0';

--     when E9 => 
--         State    <= E0;
--         memRdEn <= '1';
--         PCSel 	<= "10";
--         MemWrEn <= '0';
--         AdrSel <= '0';
--         ResWrEn <= '1';

--     when E10 => 
--         State    <= E0;
--         memRdEn <= '1';
--         PCSel 	<= "00";
--         WSel <= '1';
--         RegWrEn <= '1';

--     when E11 => 
--         State    <= E0;
--         PCSel 	<= "00";
--         memRdEn <= '1';
--         PCWrEn <= '0';


--     when E12 => 
--         State    <= E0;
--         PCSel 	<= "00";
--         memRdEn <= '1';
--         PCWrEn <= '0';

--     when E13 => 
-- 	    State    <= E0;

--         irWrEn   <= '0';
                 
--     when E14 => --ISR
-- 	    State    <= E15;
--         LRWrEn<='0';
--         SpsrWrEn<='0';
--         PCWrEn<='1';
--         PCSel<="11";
--         irq_serv<='1';

--     when E15 => --ISR
--         memRdEn<='1';
--         AdrSeL <='0';
-- 	    State    <= E0;

--      when E17 => --BX
-- 	    State    <= E0;
--         PCWrEn <= '0';
--         CpsrWrEn<='0';
--         memRdEn<='1';
--         AdrSel <='0';

-- 	end case;
	
--   end if;
-- end process;


-- end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity MAE is
  port(
        clk    	: in  std_logic;					-- Horloge
        rst     : in  std_logic;					-- Reset Asynchrone
        
		-- Gestion des Interruptions
		irq     : in std_logic ;					-- Requete d'Interruption
        irq_serv: out std_logic;					-- Acquittement Inerruption
        
		-- Gestion des Instructions
		inst_mem: in std_logic_vector(31 downto 0);	-- Instruction sortant de la mémoire
        inst_reg: in std_logic_vector(31 downto 0);	-- Instruction a Decoder (REG INST)
        N   	: in std_logic; -- Drapeaux de l'ALU
        
		-- COMMANDES  
		-- Memoire Interne
        AdrSel	: out std_logic;					-- Commande Mux Bus Adresses
        memRdEn	: out std_logic;					-- Read Enable
        memWrEn : out std_logic;					-- Write Enable
        
        -- Registre Instruction
        irWrEn  : out std_logic;					-- Write Enable              
        
        -- Banc de Registres
        WSel    : out std_logic;					-- Commande Mux Bus W
        RegWrEn	: out std_logic;       				-- Write Enable
        
        -- ALU
        AluSelA : out std_logic;					-- Selection Entree A ALU
        AluSelB	: out std_logic_vector(1 downto 0);	-- Selection Entree B ALU
        AluOP 	: out std_logic_vector(1 downto 0);	-- Selection Operation ALU
        
        --Registres d'Etat CPSR et SPSR
        CpsrSel	: out std_logic; 					-- Mux Selection Entree CPSR
        CpsrWrEn: out std_logic;					-- Write Enable CPSR
        SpsrWrEn: out std_logic;					-- Write Enable SPSR
        
        -- Registres PC et LR      
        PCSel 	: out std_logic_vector(1 downto 0);	-- Selection Entree Registre PC
        PCWrEn 	: out std_logic;					-- Write Enable PC
        LRWrEn 	: out std_logic;					-- Write Enable LR
        
        -- Registre Resultat
        ResWrEn	: out std_logic;						-- Write Enable Registre Resultat
        RbSel   : out std_logic	
      );
end entity ;
  
architecture archi of MAE is
    
    type enum_instruction is (VID,MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT_True, BLT_False, BX, ISR);
    signal instruct : enum_instruction;

    type StateType is (E0,E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11,E12,E13,E14,E15,E16,E17);
    signal state : StateType;

    signal inst_new, inst_old : enum_instruction;

begin 


    inst_new <= BX          when inst_mem = "11101011000000000000000000000000" else
                ISR         when irq='1'else
                BLT_True    when inst_mem(27 downto 26) = "10" and inst_mem(31 downto 28) = "1011" and N = '1' else 
                BLT_False   when inst_mem(27 downto 26) = "10" and inst_mem(31 downto 28) = "1011" and N = '0' else
                BAL         when inst_mem(27 downto 26) = "10" else
                MOV         when inst_mem(24 downto 21) = "1101" else
                ADDi        when inst_mem(24 downto 21) = "0100" and inst_mem(25) = '1' else
                ADDr        when inst_mem(24 downto 21) = "0100" else
                CMP         when inst_mem(24 downto 21) = "1010" else
                LDR         when inst_mem(24 downto 21) = "0000" and inst_mem(20) = '1' else
                STR         when inst_mem(24 downto 21) = "0000" else

                VID;

    inst_old <= BX          when inst_reg = "11101011000000000000000000000000" else
                --ISR         when irq='1'else
                BLT_True    when inst_reg(27 downto 26) = "10" and inst_reg(31 downto 28) = "1011" and N = '1' else 
                BLT_False   when inst_reg(27 downto 26) = "10" and inst_reg(31 downto 28) = "1011" and N = '0' else
                BAL         when inst_reg(27 downto 26) = "10" else
                MOV         when inst_reg(24 downto 21) = "1101" else
                ADDi        when inst_reg(24 downto 21) = "0100" and inst_reg(25) = '1' else
                ADDr        when inst_reg(24 downto 21) = "0100" else
                CMP         when inst_reg(24 downto 21) = "1010" else
                LDR         when inst_reg(24 downto 21) = "0000" and inst_reg(20) = '1' else
                STR         when inst_reg(24 downto 21) = "0000" else

                VID;


process(CLK,RST)
begin

    if RST = '1' then
        State <= E0;
        AdrSel	<= '0';					-- Commande Mux Bus Adresses
        memRdEn	<= '1';					-- Read Enable
        memWrEn <= '0';					-- Write Enable
        irWrEn  <= '0';					-- Write Enable              
        WSel    <= '0';					-- Commande Mux Bus W
        RegWrEn	<= '0';       				-- Write Enable
        AluSelA <= '0';					-- Selection Entree A ALU
        AluSelB	<= "00";	             -- Selection Entree B ALU
        AluOP 	<= "00";	             -- Selection Operation ALU
        CpsrSel	<= '0'; 					-- Mux Selection Entree CPSR
        CpsrWrEn<= '0';					-- Write Enable CPSR
        SpsrWrEn<= '0';					-- Write Enable SPSR   
        PCSel 	<= "00";	            -- Selection Entree Registre PC
        PCWrEn 	<= '0';					-- Write Enable PC
        LRWrEn 	<= '0';					-- Write Enable LR
        ResWrEn	<= '0';						
        RbSel   <= '0';

    elsif rising_edge(clk) then
    case State is  
	when E0 =>
        -- initialize
        AdrSel	<= '0';					-- Commande Mux Bus Adresses
        --memRdEn	<= '1';					-- Read Enable
        memWrEn <= '0';					-- Write Enable
        irWrEn  <= '0';					-- Write Enable              
        WSel    <= '0';					-- Commande Mux Bus W
        RegWrEn	<= '0';       				-- Write Enable
        AluSelA <= '0';					-- Selection Entree A ALU
        AluSelB	<= "00";	             -- Selection Entree B ALU
        AluOP 	<= "00";	             -- Selection Operation ALU
        CpsrSel	<= '0'; 					-- Mux Selection Entree CPSR
        CpsrWrEn<= '0';					-- Write Enable CPSR
        SpsrWrEn<= '0';					-- Write Enable SPSR   
        PCSel 	<= "00";	            -- Selection Entree Registre PC
        PCWrEn 	<= '0';					-- Write Enable PC
        LRWrEn 	<= '0';					-- Write Enable LR
        ResWrEn	<= '0';						
        RbSel   <= '0';
        -- next state
        
        State   <= E1;
        AdrSel  <= '0';
        memRdEn <= '0'; 
        irWrEn   <= '1';

	when E1 =>
        if inst_new = LDR or inst_new = STR or inst_new = ADDi or 
            inst_new = ADDr or inst_new = CMP or inst_new = MOV then
	        State <= E2;
            PCSel   <= "00";
            PCWrEn  <= '1';
            AluSelA <= '0';
            AluSelB <= "11";
            AluOP   <= "00";

            irWrEn   <= '0';

		elsif inst_new = BAL or inst_new = BLT_True then
            state <= E11;
            PCSel <= "00";
            AluSelA <= '0';
            AluSelB <= "10";
            AluOP <= "00";
            PCWrEn  <= '1';

            irWrEn   <= '0';

            
        elsif inst_new = BLT_False then
            state <= E12;
            PCSel <= "00";
            AluSelA <= '0';
            AluSelB <= "11";
            AluOP <= "00";
            PCWrEn <= '1';

            irWrEn   <= '0';
        elsif inst_new = ISR then
            state <= E14;

            irWrEn   <= '0';

        elsif inst_new = BX then
            state <= E17;
            PCSel <= "10";
            PCWrEn <= '1';
            CpsrSel<='1';
            CpsrWrEn<='1';
                        
            irWrEn   <= '0';

        end if;

        
        irq_serv <= '0';  --???
        
        when E2 =>
        PCWrEn  <= '0';
        memRdEn <= '0';
        if inst_old = LDR or inst_old = STR or inst_old = ADDi then
            state <= E3;
            AluSelA <= '1';
            -- AluSelB	<= "01";
            AluOP   <= "11";
            memRdEn <= '0';

        elsif inst_old = ADDr then
            state <= E3;
            AluSelA <= '1';
            AluSelB	<= "00";
            AluOP   <= "00";

            memRdEn <= '0';

        elsif inst_old = MOV then
            State <= E3;
            AluOP <= "01";
            AluSelB <= "01";

            memRdEn <= '0';

        elsif inst_old = CMP then
            State <= E3; 
            AluSelA  <= '1';
            AluSelB	 <= "01";
            AluOP    <= "10";
            CpsrSel	 <= '0';					-- Mux Selection Entree CPSR
            CpsrWrEn <= '1';
            memRdEn <= '1';

        end if;
        
    when E3 =>
        if inst_old = LDR or inst_old = STR or inst_old = ADDi then
            state <= E4;
            if inst_old = LDR then
                AdrSel	<= '1';					-- Commande Mux Bus Adresses
                memRdEn <= '1';
    
            elsif inst_old = STR then
                AdrSel   <= '1';
                memWrEn  <= '1';
    
            elsif inst_old = ADDi then
                AluOP <= "00";
                AluSelA <= '1';
                AluSelB <= "01";
                -- WSel <= '1';
                -- RegWrEn <= '1';
                -- memRdEn <= '1';
    
            end if;

        elsif inst_old = ADDr then
            state <= E5;
            WSel <= '1';
 
        elsif inst_old = MOV then
            State <= E6;
            WSel<='1';
            RegWrEn<='1';

        elsif inst_old = CMP then
            State <= E7; 
            memRdEn <= '1';
            CpsrWrEn<='0';
            PCSel 	<= "00";

        end if;

    when E4 =>  -- A+Imm8
        if inst_old = LDR then
            state <= E8;


        elsif inst_old = STR then
            state <= E9;
            AdrSel <= '1';
            MemWrEn <= '1';
            ResWrEn <= '1';

        elsif inst_old = ADDi then
            state <= E10;
            

        end if;


    when E5 =>  -- A+B
        State   <= E10;
        RegWrEn <= '1';
       
    when E6 => -- Imm8
        State <= E10;


    when E7 => 
        State    <= E0;


    when E8 => 
        State    <= E16;
       
        WSel <= '0';
        RegWrEn <= '1';

    when E16 =>
        State    <= E0;
        memRdEn <= '1';
        PCSel 	<= "00";
        AdrSel	<= '0';

    when E9 => 
        State    <= E0;
        memRdEn <= '1';
        PCSel 	<= "10";
        MemWrEn <= '0';
        AdrSel <= '0';
        ResWrEn <= '1';

    when E10 => 
        State    <= E0;
        memRdEn <= '1';
        PCSel 	<= "00";
        WSel <= '1';
        RegWrEn <= '1';

    when E11 => 
        State    <= E0;
        PCSel 	<= "00";
        memRdEn <= '1';
        PCWrEn <= '0';


    when E12 => 
        State    <= E0;
        PCSel 	<= "00";
        memRdEn <= '1';
        PCWrEn <= '0';

    when E13 => 
	    State    <= E0;

        irWrEn   <= '0';
                 
    when E14 => --ISR
	    State    <= E15;
        LRWrEn<='1';
        SpsrWrEn<='1';
        PCWrEn<='1';
        PCSel<="11";
        irq_serv<='1';

    when E15 => --ISR
        LRWrEn<='0';
        SpsrWrEn<='0';
        PCWrEn<='0';
        MemRdEn <= '1';
	    State    <= E0;

     when E17 => --BX
	    State    <= E0;
        PCWrEn <= '0';
        CpsrWrEn<='0';
        memRdEn<='1';

	end case;
	
  end if;
end process;


end architecture;

