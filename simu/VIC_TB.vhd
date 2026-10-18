-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;

-- entity VIC_TB is
-- end VIC_TB;

-- architecture Behavioral of VIC_TB is
--     -- 组件声明
--     component VIC is
--         Port (
--             CLK      : in  STD_LOGIC;
--             RESET    : in  STD_LOGIC;
--             IRQ_SERV : in  STD_LOGIC;
--             IRQ0     : in  STD_LOGIC;
--             IRQ1     : in  STD_LOGIC;
--             IRQ      : out STD_LOGIC;
--             VICPC    : out STD_LOGIC_VECTOR(31 downto 0)
--         );
--     end component;

--     -- 测试信号定义
--     signal CLK      : STD_LOGIC := '0';
--     signal RESET    : STD_LOGIC := '1';  -- 初始复位
--     signal IRQ_SERV : STD_LOGIC := '0';
--     signal IRQ0     : STD_LOGIC := '0';
--     signal IRQ1     : STD_LOGIC := '0';
--     signal IRQ      : STD_LOGIC;
--     signal VICPC    : STD_LOGIC_VECTOR(31 downto 0);

--     -- 时钟周期定义
--     constant CLK_PERIOD : time := 10 ns;

-- begin
--     -- 实例化VIC模块
--     uut: VIC port map (
--         CLK      => CLK,
--         RESET    => RESET,
--         IRQ_SERV => IRQ_SERV,
--         IRQ0     => IRQ0,
--         IRQ1     => IRQ1,
--         IRQ      => IRQ,
--         VICPC    => VICPC
--     );

--     -- 生成时钟信号
--     CLK_process: process
--     begin
--         CLK <= '0';
--         wait for CLK_PERIOD/2;
--         CLK <= '1';
--         wait for CLK_PERIOD/2;
--     end process;

--     -- 主测试流程
--     stim_proc: process
--     begin
--         -- 初始化复位
--         RESET <= '1';
--         wait for 20 ns;
--         RESET <= '0';
--         wait for 10 ns;

--         -- 测试1: IRQ0上升沿触发
--         IRQ0 <= '0';
--         wait for 20 ns;
--         IRQ0 <= '1';          -- 触发IRQ0上升沿
--         wait for 20 ns;
--         assert IRQ = '1' and VICPC = x"00000009"
--             report "Test1 Failed: IRQ0未触发或VICPC错误" severity error;

--         -- 发送中断服务确认
--         IRQ_SERV <= '1';
--         wait for 10 ns;
--         IRQ_SERV <= '0';
--         wait for 10 ns;
--         assert IRQ = '0'      -- 检查中断请求是否清除
--             report "Test1 Failed: IRQ未清除" severity error;

--         -- 测试2: IRQ1上升沿触发
--         IRQ1 <= '0';
--         wait for 20 ns;
--         IRQ1 <= '1';          -- 触发IRQ1上升沿
--         wait for 20 ns;
--         assert IRQ = '1' and VICPC = x"00000015"
--             report "Test2 Failed: IRQ1未触发或VICPC错误" severity error;

--         -- 测试3: 优先级验证（IRQ0优先于IRQ1）
--         IRQ0 <= '1';          -- 同时触发IRQ0和IRQ1
--         IRQ1 <= '1';
--         wait for 20 ns;
--         assert VICPC = x"00000009"
--             report "Test3 Failed: 优先级错误" severity error;

--         -- 测试4: 异步复位功能
--         RESET <= '1';
--         wait for 10 ns;
--         RESET <= '0';
--         wait for 10 ns;
--         assert IRQ = '0' and VICPC = x"00000000"
--             report "Test4 Failed: 复位未生效" severity error;

--         -- 测试5: 连续中断处理
--         IRQ0 <= '0'; IRQ1 <= '0';
--         wait for 10 ns;
--         IRQ0 <= '1';          -- 触发IRQ0
--         wait for 20 ns;
--         IRQ_SERV <= '1';     -- 确认中断
--         wait for 10 ns;
--         IRQ_SERV <= '0';
--         IRQ0 <= '0';
--         IRQ1 <= '1';          -- 立即触发IRQ1
--         wait for 20 ns;
--         assert IRQ = '1' and VICPC = x"00000015"
--             report "Test5 Failed: 连续中断处理错误" severity error;

--         -- 结束仿真
--         report "所有测试通过！";
--         wait;
--     end process;

-- end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VIC_TB is
end VIC_TB;

architecture Behavioral of VIC_TB is
    component VIC is
        Port (
            CLK      : in  STD_LOGIC;
            RST      : in  STD_LOGIC;
            IRQ_SERV : in  STD_LOGIC;
            IRQ0     : in  STD_LOGIC;
            IRQ1     : in  STD_LOGIC;
            IRQ      : out STD_LOGIC;
            VICPC    : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal CLK      : STD_LOGIC := '0';
    signal RESET    : STD_LOGIC := '1';
    signal IRQ_SERV : STD_LOGIC := '0';
    signal IRQ0     : STD_LOGIC := '0';
    signal IRQ1     : STD_LOGIC := '0';
    signal IRQ      : STD_LOGIC;
    signal VICPC    : STD_LOGIC_VECTOR(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    uut: VIC port map (
        CLK      => CLK,
        RST    => RESET,
        IRQ_SERV => IRQ_SERV,
        IRQ0     => IRQ0,
        IRQ1     => IRQ1,
        IRQ      => IRQ,
        VICPC    => VICPC
    );

    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 15 ns;

        -- Test 1: IRQ0 rising edge
        IRQ0 <= '0';
        wait for 20 ns;
        IRQ0 <= '1';
        wait for 20 ns;
        assert IRQ = '1' and VICPC = x"00000009"
            report "Test1 Failed: IRQ0 not triggered or VICPC error" severity error;

        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        wait for 10 ns;
        assert IRQ = '0'
            report "Test1 Failed: IRQ not cleared" severity error;

        -- Test 2: IRQ1 rising edge
        IRQ1 <= '0';
        wait for 20 ns;
        IRQ1 <= '1';
        wait for 20 ns;
        assert IRQ = '1' and VICPC = x"00000015"
            report "Test2 Failed: IRQ1 not triggered or VICPC error" severity error;

        IRQ0 <= '0';
        wait for 20 ns;
        IRQ1 <= '0';
        wait for 20 ns;

        -- Test 3: Priority check
        IRQ0 <= '1';
        IRQ1 <= '1';
        wait for 20 ns;
        assert VICPC = x"00000009"
            report "Test3 Failed: Priority error" severity error;

        -- Test 4: Reset
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 10 ns;
        assert IRQ = '0' and VICPC = x"00000000"
            report "Test4 Failed: Reset failed" severity error;

        -- Test 5: Consecutive interrupts
        IRQ0 <= '0'; IRQ1 <= '0';
        wait for 10 ns;
        IRQ0 <= '1';
        wait for 20 ns;
        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        IRQ0 <= '0';
        IRQ1 <= '1';
        wait for 20 ns;
        assert IRQ = '1' and VICPC = x"00000015"
            report "Test5 Failed: Consecutive interrupt error" severity error;

        report "All tests passed!";
        wait;
    end process;

end Behavioral;