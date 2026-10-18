library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARM_TB is
end ARM_TB;

architecture sim of ARM_TB is

    component ARM
        Port (
            CLK, RST   : in  STD_LOGIC;
            IRQ0, IRQ1   : in  STD_LOGIC;

            resultat	: out std_logic_vector(31 downto 0)
        );
    end component;

    -- 信号声明
    signal CLK       : STD_LOGIC := '0';
    signal RESET     : STD_LOGIC := '1';
    signal IRQ0      : STD_LOGIC := '0';
    signal IRQ1      : STD_LOGIC := '0';

    signal resultat       : STD_LOGIC_vector(31 downto 0);
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 实例化 ARM 顶层模块
    UUT:ARM port map(
        CLK => CLK,
        RST => RESET,
        IRQ0 => IRQ0,
        IRQ1 => IRQ1,

        resultat =>resultat
    );

    -- 时钟生成
    clk_process : process
    begin
        while now < 12000 ns loop
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
        wait for 20 ns;
        RESET <= '0';
        wait for 50 ns;

        -- 模拟一段运行时间
        wait for 401 ns;

        -- 模拟 IRQ1 中断
        IRQ0 <= '1';
        wait for 1000 ns;
        IRQ0 <= '0';

        -- 继续仿真
        wait for 750 ns;

        -- 测试结束
        report "Testbench finished." severity note;
        wait;
    end process;

end sim;