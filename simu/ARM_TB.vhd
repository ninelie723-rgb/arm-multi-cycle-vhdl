library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARM_UART_TB is
end ARM_UART_TB;

architecture sim of ARM_UART_TB is

    component ARM
        Port (
            CLK, RST   : in  STD_LOGIC;
            IRQ0, IRQ1   : in  STD_LOGIC;
            irq2   : in  STD_LOGIC;
            Rx        	: in std_logic;
            resultat	: out std_logic_vector(31 downto 0);
            tx   : out  STD_LOGIC
        );
    end component;

    -- 信号声明
    signal CLK       : STD_LOGIC := '0';
    signal RESET     : STD_LOGIC := '1';
    signal IRQ0      : STD_LOGIC := '0';
    signal IRQ1      : STD_LOGIC := '0';
    signal IRQ2      : STD_LOGIC := '0';
    signal resultat       : STD_LOGIC_vector(31 downto 0);
    constant CLK_PERIOD : time := 20 ns;
    signal Go          : std_logic := '0';
    signal Data        : std_logic_vector(7 downto 0) := (others => '0');
    signal Tick,Tick_half        : std_logic := '0';
    signal Tx, TxBusy  : std_logic;
    signal Reg         : std_logic_vector(9 downto 0) := (others => '0');
    signal OK          : boolean := TRUE;
	signal	Clear_fdiv : std_logic := '0';
	signal rst_fdiv    : std_logic := '0';
	signal DAV  : std_logic := '0';
	signal data_out : std_logic_vector(7 downto 0) := (others => '0');
	signal err : std_logic := '0';

begin

    -- 实例化 ARM 顶层模块
    UUT:ARM port map(
        CLK => CLK,
        RST => RESET,
        IRQ0 => IRQ0,
        IRQ1 => IRQ1,
        IRQ2 => IRQ2,
        resultat =>resultat,
        tx=>open,
        rx=>tx
    );

    -- 时钟生成
    clk_process : process
    begin
        while now < 1200000 ns loop
            CLK <= '1'; wait for CLK_PERIOD / 2;
            CLK <= '0'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- 刺激过程
    stim_proc: process
    begin
        -- 初始化复位
        RESET <= '1';
        wait for 5 * CLK_PERIOD;
        wait until falling_edge(CLK);
        RESET <= '0';
        wait for 50 ns;

        -- 模拟一段运行时间
        wait for 401 ns;

        Data <= "01100101";
        Go <= '1';

        -- 继续仿真
        wait for 75000 ns;

        -- 模拟 IRQ1 中断
        IRQ2 <= '1';
        wait for 1000 ns;
        IRQ2 <= '0';

        wait for 750000 ns;
        Data <= "01101101";
        Go <= '1';

        -- 继续仿真
        wait for 75000 ns;

        IRQ2 <= '1';
        wait for 1000 ns;
        IRQ2 <= '0';
        -- 测试结束
        report "Testbench finished." severity note;
        wait;
    end process;

    fdiv: entity work.FDIV
        port map (
            Clk       => Clk,
            Reset     => Reset,
            Tick      => Tick,
            Tick_half => open
        );
        
    UART_TX: entity work.UART_TX
        port map (
            Clk   => Clk,
            Reset => Reset,
            LD    => Go,
            Din  => Data,
            Tick  => Tick,
            TxIrq => TxBusy, 
            Tx    => Tx
        );
    

end sim;