------------------------------------------------------------------
--																--
--					PROCESSEUR MULTI-CYCLES						--
--						CHEMIN DE DONNEES						--
--																--
---						(c) 2010-2022      						--
-- 		A.Mocco, N.Hamila, M.Fonseca, J.Denoulet, P.Garda	    --
--      Modifié par Y Douze              						--
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataPath is 
port(
		clk,rst		: in std_logic;								-- Horloge + RST Asynchrone
        
		-- Gestion des Interruptions
		irq0,irq1,irq2	: in std_logic;								-- Boutons Interruptions Externes
		irq     		: out std_logic;								-- Requete Interruption Transmise par le VIC
		irq_serv		: in std_logic;  								-- Acquittement Interruption
        
		-- Instructions
		Inst_Mem   	: out std_logic_vector(31 downto 0);	-- Instruction a Decoder (MEMOIRE)
		Inst_Reg    : out std_logic_vector(31 downto 0);	-- Instruction a Decoder (REG INST)
		N        	: out std_logic; 								-- Flag N memorise dans Registre d'Etat
        
		-- Memoire Interne
		AdrSel 		: in std_logic; 								-- Commande Mux Bus Adresses
		MemRdEn   	: in std_logic;								-- Read Enable
		MemWrEn    	: in std_logic;								-- Write Enable
	
		-- Registre Instruction
		IrWrEn     	: in std_logic;								-- Write Enable              
        
		-- Banc de Registres
		WSel			: in std_logic;								-- Commande Mux Bus W
		RegWrEn 		: in std_logic;								-- Write Enable  
        
		--signaux de controle pour l'alu
		AluSelA 		: in std_logic;								-- Selection Entree A ALU
		AluSelB  	: in std_logic_vector(1 downto 0);		-- Selection Entree B ALU
		AluOP    	: in std_logic_vector(1 downto 0);		-- Selecttion Operation ALU
        
		-- Registres d'Etat (CPSR, SPSR)
		CpsrSel		: in std_logic; 								-- Mux Selection Entree CPSR
		CpsrWrEn		: in std_logic;								-- Write Enable CPSR
		SpsrWrEn		: in std_logic;								-- Write Enable SPSR
        
		-- Registres PC et LR      
		PCSel 		: in std_logic_vector(1 downto 0);		-- Selection Entree Registre PC
		PCWrEn 		: in std_logic;								-- Write Enable PC
		LRWrEn 		: in std_logic;								-- Write Enable LR
        
		-- Registre Resultat
		Res    		: out std_logic_vector(31 downto 0);	-- Sortie Registre Resultat
		ResWrEn		: in std_logic;									-- Write Enable
		Tx        	: out std_logic;
		Rx        	: in std_logic
  );
end DataPath;

architecture archi of DataPath is
	-- Signals for internal connections
	signal PC_out, ALU_result, ALUOUT, DR_out, BUS_A, BUS_B, VICPC, IR_out,LR_out : STD_LOGIC_VECTOR(31 downto 0);
	signal Mem_Data: STD_LOGIC_VECTOR(31 downto 0);
	signal BUS_W : STD_LOGIC_VECTOR(31 downto 0);
	signal Mem_Addr : STD_LOGIC_VECTOR(6 downto 0);
	signal CPSR, SPSR, CPSR_in : STD_LOGIC_VECTOR(31 downto 0);
	signal mux_PC_out : STD_LOGIC_VECTOR(31 downto 0);
	signal RegA, RegB,Mem_in : STD_LOGIC_VECTOR(31 downto 0);
	signal ALU_flag_N,COM_MUX_REG_RB : STD_LOGIC;
	signal Rd,Rn,Rm,RB : STD_LOGIC_VECTOR(3 downto 0);
	signal EXT8_in : STD_LOGIC_VECTOR(7 downto 0);
	signal EXT24_in : STD_LOGIC_VECTOR(23 downto 0);
	signal EXT8,EXT24 : STD_LOGIC_VECTOR(31 downto 0);
	signal mux_ALU_A, mux_ALU_B,Mux_CPSR_in : STD_LOGIC_VECTOR(31 downto 0);
	signal SPSR_OUT,CPSR_OUT : STD_LOGIC_VECTOR(31 downto 0);
	signal IRQ_UART,Tick_tx,Tick_rx,Go,Clear_fdiv,Err,DAV,rst_fdiv : STD_LOGIC;
	signal UART_TX,UART_RX: STD_LOGIC_VECTOR(7 downto 0);

	begin
		-- PC multiplexer
		mux_PC : entity work.mux4 
		port map (
			A => ALU_result,
			B => ALUOUT,
			C => LR_out,
			D => VICPC,
			COM => PCSel,
			S => mux_PC_out
		);

		-- PC register
		PC_reg : entity work.register32_charge 
		port map (
			CLK => CLK,
			RST => RST,
			command => PCWrEn,
			reg_in => mux_PC_out,
			reg_out => PC_out
		);

		-- LR register
		LR : entity work.register32_charge 
		port map (
			CLK => CLK,
			RST => RST,
			command => LRWrEn,
			reg_in => PC_out,
			reg_out => LR_out
		);

		-- Address multiplexer
		mux_ADDR : entity work.mux2 
		generic map (N => 7)
		port map (
			A => PC_out(6 downto 0),
			B => ALUOUT(6 downto 0),
			COM => AdrSel,
			S => MEM_addr
		);

		-- 双端口RAM
		RAM: entity work.DualPortRAM
		port map(
			clock    => clk,
			rst      => rst,
			data     => regB,      
			q        => Mem_in,
			rdaddress=> Mem_Addr,
			wraddress=> Mem_Addr,
			rden     => MemRdEn,
			wren     => MemWrEn
		);

		Inst_Mem <= Mem_Data;
		Inst_Reg <= IR_out;

		-- Instruction Register
		IR : entity work.register32_charge port map (
			CLK => CLK,
			RST => RST,
			command => IrWrEn,
			reg_in => Mem_Data,
			reg_out => IR_out
		);

		Rn <= IR_out(19 downto 16);
		Rm <= IR_out(3 downto 0);
		Rd <= IR_out(15 downto 12);

		DR : entity work.register32 port map (
			CLK => CLK,
			RST => RST,
			reg_in => Mem_Data,
			reg_out => DR_out
		);

		COM_MUX_REG_RB<=not (IR_out(27) or IR_out(20)) and IR_out(26);

		MUX_REG_RB : entity work.mux2 
		generic map (N => 4)
		port map (
			A => Rm,
            B => Rd,
			COM => COM_MUX_REG_RB,
			S => RB
		);

		MUX_REG_BUSW : entity work.mux2 
		generic map (N => 32)
		port map (
			A => DR_out,
            B => ALUOUT,
			COM => WSel,
			S => BUS_W
		);


		-- Register File
		REG_FILE : entity work.register_bank 
		port map (
			CLK => CLK,
			RST => RST,
			W => BUS_W,
			RA => Rn,
			RB => RB,
			RW => Rd,
			WE => RegWrEn,
			A => BUS_A,
			B => BUS_B
		);

		EXT8_in <= IR_out(7 downto 0);
		EXT24_in <= IR_out(23 downto 0);

		Ext_8: entity work.sign_extension
        generic map (N => 8)
        port map (
            E => EXT8_in,
            S => EXT8
        );
		
		-- ALU A mux
		muxALU_A : entity work.mux2 
		port map (
			A => PC_out,
			B => RegA,
			COM => AluSelA,
			S => mux_ALU_A
		);

		Ext_24: entity work.sign_extension
        generic map (N => 24)
        port map (
            E => EXT24_in,
            S => EXT24
        );

		-- A and B registers
		A_reg : entity work.register32 
		port map (
			CLK => CLK,
			RST => RST,
			reg_in => BUS_A,
			reg_out => RegA
		);

		B_reg : entity work.register32 
		port map (
			CLK => CLK,
			RST => RST,
			reg_in => BUS_B,
			reg_out => RegB
		);


		-- ALUOUT register
		ALUOUT_reg : entity work.register32 
		port map (
			CLK => CLK,
			RST => RST,
			reg_in => ALU_result,
			reg_out => ALUOUT
		);

		muxALU_B : entity work.mux4 
		port map (
			A => RegB,
			B => EXT8,
			C => EXT24,
			D => X"00000001",
			COM => AluSelB,
			S => mux_ALU_B
		);

		-- ALU
		alu_inst : entity work.ALU 
		port map (
			A => mux_ALU_A,
			B => mux_ALU_B,
			OP => AluOP,
			S => ALU_result,
			N => ALU_flag_N
		);

		-- N <= ALU_flag_N;
		N <= CPSR_OUT(31);
		Mux_CPSR_in<=ALU_flag_N & CPSR(30 downto 0);

		Mux_CPSR : entity work.mux2 
		port map (
			A => Mux_CPSR_in,
			B => SPSR_OUT,
			COM => CpsrSel,
			S => CPSR_in
		);

		CPSR_reg : entity work.register32_charge port map (
			CLK => CLK,
			RST => RST,
			command => CpsrWrEn,
			reg_in => CPSR_in,
			reg_out => CPSR_OUT
		);
		
		SPSR_reg : entity work.register32_charge port map (
			CLK => CLK,
			RST => RST,
			command => SpsrWrEn,
			reg_in => CPSR_OUT,
			reg_out => SPSR_OUT
		);

		-- VIC
		vic_ctrl : entity work.VIC 
		port map (
			CLK => CLK,
			RST => RST,
			IRQ0 => irq0,
			IRQ1 => irq1,
			IRQ2 => irq2,
			IRQ_UART_TX =>IRQ_UART,
			IRQ_SERV => irq_serv,
			IRQ_UART_RX=>DAV,
			IRQ => irq,
			VICPC => VICPC
		);

		RES_reg : entity work.register32_charge port map (
			CLK => CLK,
			RST => RST,
			command => ResWrEn,
			reg_in => RegB,
			reg_out => Res
		);

		UART_reg : entity work.uart_conf port map (
			CLK => CLK,
			RST => RST,
			addr_in => MEM_addr,
			regB_in => RegB,
			Mem_in  => Mem_in,
			Mem_out => Mem_Data,
			Go =>Go,
			tx_out => UART_tx,
			rx_in =>UART_Rx,
			Err => Err,
			DAV =>DAV
		);
		
		UARTTX : entity work.UART_tx port map (
			CLK => CLK,
			Reset => RST,
			LD =>Go,
			Din =>UART_tx,
			Tick=>Tick_tx,
			TxIrq=>IRQ_UART,
			Tx=>Tx
		);

		FDIV_tx_clk:entity work.FDIV port map (
			CLK => CLK,
			Reset => RST,
			Tick=>Tick_tx,
			Tick_half=>open
		);

		UARTRX : entity work.UART_rx port map (
			CLK => CLK,
			Reset => RST,
			Rx =>Rx,
			Tick_halfbit =>Tick_rx,
			Clear_fdiv=>Clear_fdiv,
			Err => Err,
			Data=>UART_RX,
			DAV =>DAV
		);

		rst_fdiv<=RST or Clear_fdiv;
		FDIV_rx_clk:entity work.FDIV port map (
			CLK => CLK,
			Reset => rst_fdiv,
			Tick=>open,
			Tick_half=>Tick_rx
		);



end architecture;
