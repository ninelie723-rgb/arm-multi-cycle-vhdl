-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;

-- entity DataPath_TB is
-- end DataPath_TB;

-- architecture Behavioral of DataPath_TB is
--     -- 组件声明
--     component DataPath is
--     port(
--         clk, rst     : in  std_logic;
--         irq0, irq1   : in  std_logic;
--         irq          : out std_logic;
--         irq_serv     : in  std_logic;
--         Inst_Mem     : out std_logic_vector(31 downto 0);
--         Inst_Reg     : out std_logic_vector(31 downto 0);
--         N            : out std_logic;
--         AdrSel       : in  std_logic;
--         MemRdEn      : in  std_logic;
--         MemWrEn      : in  std_logic;
--         IrWrEn       : in  std_logic;
--         WSel         : in  std_logic;
--         RegWrEn      : in  std_logic;
--         AluSelA      : in  std_logic;
--         AluSelB      : in  std_logic_vector(1 downto 0);
--         AluOP        : in  std_logic_vector(1 downto 0);
--         CpsrSel      : in  std_logic;
--         CpsrWrEn     : in  std_logic;
--         SpsrWrEn     : in  std_logic;
--         PCSel        : in  std_logic_vector(1 downto 0);
--         PCWrEn       : in  std_logic;
--         LRWrEn       : in  std_logic;
--         Res          : out std_logic_vector(31 downto 0);
--         ResWrEn      : in  std_logic
--     );
--     end component;

--     -- 测试信号定义
--     signal clk       : std_logic := '0';
--     signal rst       : std_logic := '1';
--     signal irq0      : std_logic := '0';
--     signal irq1      : std_logic := '0';
--     signal irq       : std_logic;
--     signal irq_serv  : std_logic := '0';
--     signal Inst_Mem  : std_logic_vector(31 downto 0);
--     signal Inst_Reg  : std_logic_vector(31 downto 0);
--     signal N         : std_logic;
--     signal AdrSel    : std_logic := '0';
--     signal MemRdEn   : std_logic := '0';
--     signal MemWrEn   : std_logic := '0';
--     signal IrWrEn    : std_logic := '0';
--     signal WSel      : std_logic := '0';
--     signal RegWrEn   : std_logic := '0';
--     signal AluSelA   : std_logic := '0';
--     signal AluSelB   : std_logic_vector(1 downto 0) := "00";
--     signal AluOP     : std_logic_vector(1 downto 0) := "00";
--     signal CpsrSel   : std_logic := '0';
--     signal CpsrWrEn  : std_logic := '0';
--     signal SpsrWrEn  : std_logic := '0';
--     signal PCSel     : std_logic_vector(1 downto 0) := "00";
--     signal PCWrEn    : std_logic := '0';
--     signal LRWrEn    : std_logic := '0';
--     signal Res       : std_logic_vector(31 downto 0);
--     signal ResWrEn   : std_logic := '0';

--     -- 时钟周期定义
--     constant CLK_PERIOD : time := 10 ns;
--     signal done :std_logic := '0';

-- begin
--     -- 实例化DataPath模块
--     uut: DataPath port map(
--         clk      => clk,
--         rst      => rst,
--         irq0     => irq0,
--         irq1     => irq1,
--         irq      => irq,
--         irq_serv => irq_serv,
--         Inst_Mem => Inst_Mem,
--         Inst_Reg => Inst_Reg,
--         N        => N,
--         AdrSel   => AdrSel,
--         MemRdEn  => MemRdEn,
--         MemWrEn  => MemWrEn,
--         IrWrEn   => IrWrEn,
--         WSel     => WSel,
--         RegWrEn  => RegWrEn,
--         AluSelA  => AluSelA,
--         AluSelB  => AluSelB,
--         AluOP    => AluOP,
--         CpsrSel  => CpsrSel,
--         CpsrWrEn => CpsrWrEn,
--         SpsrWrEn => SpsrWrEn,
--         PCSel    => PCSel,
--         PCWrEn   => PCWrEn,
--         LRWrEn   => LRWrEn,
--         Res      => Res,
--         ResWrEn  => ResWrEn
--     );

--     -- 生成时钟信号
--     clk_process: process
--     begin
--         clk <= '0';
--         wait for CLK_PERIOD/2;
--         clk <= '1';
--         wait for CLK_PERIOD/2;

--         if done = '1' then
--             wait;
--         end if;
--     end process;

--     -- 主测试流程
--     stim_proc: process
--     begin
--         -- 初始化复位
--         rst <= '1';
--         wait for 20 ns;
--         rst <= '0';
--         wait for 10 ns;

--         -- 测试1: 加载指令并执行MOV操作
--         -- 预期：指令存储器输出MOV指令（例如x"E3A01020"）
--         MemRdEn <= '1';     -- 允许读存储器
--         AdrSel  <= '0';     -- 选择PC作为地址
--         wait until rising_edge(clk);
--         IrWrEn  <= '1';     -- 加载指令到IR
--         wait until rising_edge(clk);
--         IrWrEn  <= '0';
--         MemRdEn <= '0';
--         assert Inst_Reg = x"E3A01020"
--             report "Test1 Failed: MOV" severity error;
--         wait until rising_edge(clk);

--         -- wait for 20 ns;

--         -- 测试2: 执行ADD操作
--         -- 预期：ALU计算结果正确，结果寄存器更新
--         AluSelA <= '1';     -- 选择寄存器A作为ALU输入A
--         AluSelB <= "00";    -- 选择寄存器B作为ALU输入B
--         AluOP   <= "00";    -- ALU执行加法
--         RegWrEn <= '1';     -- 允许写寄存器
--         wait until rising_edge(clk);
--         assert Res = x"00000020"
--             report "Test2 Failed: ADD" severity error;

--         -- 测试3: 触发中断IRQ0
--         -- 预期：IRQ信号置高，VICPC输出0x9
--         irq0 <= '1';
--         wait until rising_edge(clk);
--         irq0 <= '0';
--         wait until rising_edge(clk);
--         assert irq = '1' and Inst_Mem = x"00000009"
--             report "Test3 Failed: IRQ0" severity error;

--         -- 测试4: 处理中断服务程序
--         irq_serv <= '1';    -- 确认中断
--         wait until rising_edge(clk);
--         irq_serv <= '0';
--         assert irq = '0'
--             report "Test4 Failed: " severity error;

--         -- 测试5: 存储器写操作
--         MemWrEn <= '1';     -- 允许写存储器
--         AdrSel  <= '1';     -- 选择ALUOUT作为地址
--         wait until rising_edge(clk);
--         MemWrEn <= '0';
--         assert Inst_Mem = x"00000000"
--             report "Test5 Failed: " severity error;

--         -- 结束仿真
--         report "!";
--         done <= '1';
--         wait;
--     end process;

-- end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataPath_TB is
end DataPath_TB;

architecture Behavioral of DataPath_TB is
    -- 组件声明
    component DataPath is
    port(
        clk, rst     : in  std_logic;
        irq0, irq1   : in  std_logic;
        irq          : out std_logic;
        irq_serv     : in  std_logic;
        Inst_Mem     : out std_logic_vector(31 downto 0);
        Inst_Reg     : out std_logic_vector(31 downto 0);
        N            : out std_logic;
        AdrSel       : in  std_logic;
        MemRdEn      : in  std_logic;
        MemWrEn      : in  std_logic;
        IrWrEn       : in  std_logic;
        WSel         : in  std_logic;
        RegWrEn      : in  std_logic;
        AluSelA      : in  std_logic;
        AluSelB      : in  std_logic_vector(1 downto 0);
        AluOP        : in  std_logic_vector(1 downto 0);
        CpsrSel      : in  std_logic;
        CpsrWrEn     : in  std_logic;
        SpsrWrEn     : in  std_logic;
        PCSel        : in  std_logic_vector(1 downto 0);
        PCWrEn       : in  std_logic;
        LRWrEn       : in  std_logic;
        Res          : out std_logic_vector(31 downto 0);
        ResWrEn      : in  std_logic
    );
    end component;

    -- 测试信号定义
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal irq0      : std_logic := '0';
    signal irq1      : std_logic := '0';
    signal irq       : std_logic;
    signal irq_serv  : std_logic := '0';
    signal Inst_Mem  : std_logic_vector(31 downto 0);
    signal Inst_Reg  : std_logic_vector(31 downto 0);
    signal N         : std_logic;
    signal AdrSel    : std_logic := '0';
    signal MemRdEn   : std_logic := '0';
    signal MemWrEn   : std_logic := '0';
    signal IrWrEn    : std_logic := '0';
    signal WSel      : std_logic := '0';
    signal RegWrEn   : std_logic := '0';
    signal AluSelA   : std_logic := '0';
    signal AluSelB   : std_logic_vector(1 downto 0) := "00";
    signal AluOP     : std_logic_vector(1 downto 0) := "00";
    signal CpsrSel   : std_logic := '0';
    signal CpsrWrEn  : std_logic := '0';
    signal SpsrWrEn  : std_logic := '0';
    signal PCSel     : std_logic_vector(1 downto 0) := "00";
    signal PCWrEn    : std_logic := '0';
    signal LRWrEn    : std_logic := '0';
    signal Res       : std_logic_vector(31 downto 0);
    signal ResWrEn   : std_logic := '0';

    -- 时钟周期定义
    constant CLK_PERIOD : time := 10 ns;

begin
    -- 实例化DataPath模块
    uut: DataPath port map(
        clk      => clk,
        rst      => rst,
        irq0     => irq0,
        irq1     => irq1,
        irq      => irq,
        irq_serv => irq_serv,
        Inst_Mem => Inst_Mem,
        Inst_Reg => Inst_Reg,
        N        => N,
        AdrSel   => AdrSel,
        MemRdEn  => MemRdEn,
        MemWrEn  => MemWrEn,
        IrWrEn   => IrWrEn,
        WSel     => WSel,
        RegWrEn  => RegWrEn,
        AluSelA  => AluSelA,
        AluSelB  => AluSelB,
        AluOP    => AluOP,
        CpsrSel  => CpsrSel,
        CpsrWrEn => CpsrWrEn,
        SpsrWrEn => SpsrWrEn,
        PCSel    => PCSel,
        PCWrEn   => PCWrEn,
        LRWrEn   => LRWrEn,
        Res      => Res,
        ResWrEn  => ResWrEn
    );

    -- 生成时钟信号
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 主测试流程
    stim_proc: process
    begin
        -- 初始化复位
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        -- 测试1: 验证复位状态
        assert Inst_Mem = x"E3A01020" and Inst_Reg = x"00000000" and Res = x"00000000"
            report "Test1 Failed:" severity error;

        -- 测试2: 执行主程序累加逻辑（模拟10次循环）
        for i in 0 to 9 loop
            -- 阶段1: 取指（PC=0x0）
            MemRdEn <= '1'; AdrSel <= '0'; 
            wait until rising_edge(clk);
            IrWrEn <= '1';  -- 加载指令到IR
            wait until rising_edge(clk);
            IrWrEn <= '0'; MemRdEn <= '0';

            -- 阶段2: 执行MOV/ADD指令
            case to_integer(unsigned(Inst_Reg(31 downto 24))) is
                when 16#E3# =>  -- MOV指令
                    RegWrEn <= '1'; WSel <= '0';  -- 选择DR写入寄存器
                    wait until rising_edge(clk);
                    RegWrEn <= '0';
                when 16#E6# =>  -- LDR/STR指令
                    AluSelA <= '1'; AluSelB <= "01"; AluOP <= "00";  -- ALU计算地址
                    wait until rising_edge(clk);
                    if Inst_Reg(20) = '1' then  -- STR指令
                        MemWrEn <= '1';
                    else                        -- LDR指令
                        MemRdEn <= '1';
                    end if;
                    wait until rising_edge(clk);
                    MemWrEn <= '0'; MemRdEn <= '0';
                when others => null;
            end case;
        end loop;

        -- 验证累加结果（应等于55=0x37）
        wait until rising_edge(clk);
        assert Res = x"00000037"
            report "Test2 Failed:"  severity error;

        -- 测试3: 触发IRQ0中断
        irq0 <= '1';  -- 模拟按键触发IRQ0
        wait until rising_edge(clk);
        irq0 <= '0';
        wait until irq = '1';  -- 等待中断请求
        assert Inst_Mem = x"00000009"  -- VICPC应指向0x9
            report "Test3 Failed:"  severity error;

        -- 确认中断服务程序执行
        irq_serv <= '1';  -- MAE发送中断确认
        wait until rising_edge(clk);
        irq_serv <= '0';
        wait for 5*CLK_PERIOD;  -- 等待中断处理完成

        -- 验证中断修改内存后的结果（0x20地址值+1，总和变为56=0x38）
        assert Res = x"00000038"
            report "Test3 Failed" severity error;

        -- 测试4: 触发IRQ1中断（优先级低于IRQ0）
        irq1 <= '1';  -- 触发IRQ1
        irq0 <= '1';  -- 同时触发IRQ0
        wait until rising_edge(clk);
        irq1 <= '0'; irq0 <= '0';
        wait until irq = '1';
        assert Inst_Mem = x"00000009"  -- IRQ0应优先
            report "Test4 Failed:" severity error;

        -- 结束仿真
        report "===== ! =====";
        wait;
    end process;

end Behavioral;