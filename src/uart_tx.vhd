library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX is
    port (
        Clk     : in std_logic;                   -- 时钟信号
        Reset   : in std_logic;                   -- 重置信号
        LD      : in std_logic;                   -- 负载信号，用于加载输入数据
        Din     : in std_logic_vector(7 downto 0);-- 8位输入数据
        Tick    : in std_logic;                   -- 时钟分频信号，用于控制发送速率
        TxIrq    : out std_logic;                  -- 发送忙标志
        Tx      : out std_logic                   -- 串行发送信号
    );
end entity;

architecture RTL of UART_TX is
    signal i    : integer range 0 to 7 := 0;      -- 位计数器，控制发送的每一位
    signal reg  : std_logic_vector(7 downto 0);   -- 寄存器用于保存要发送的数据

    type StateType is (E0, E1, E2, E3, E4);      
    signal State : StateType := E0;              
    signal LD_prev  : std_logic := '0';  
    signal LD_edge  : std_logic := '0';  



begin 

    process (CLK, reset)
    begin
    if reset = '1' then
        LD_prev <= '0';
        LD_edge <= '0';
    elsif rising_edge(CLK) then
        -- ?????????? 0 ? 1 ???
        LD_edge <= '0';
        if LD_prev = '0' and LD = '1' then
        LD_edge <= '1';  -- ??????
        end if;
        LD_prev <= LD;  -- ??????????????
    end if;
    end process;

    process(Clk, Reset)
    begin
        if Reset = '1' then
            -- 当重置信号为1时，复位所有信号
            State <= E0;
            Tx <= '1';                            -- Tx信号默认空闲状态为高电平
            TxIrq <= '0';                       -- 初始状态不忙
            i <= 0;                               -- 复位位计数器
        elsif rising_edge(Clk) then
            case State is
                when E0 =>
                    -- 等待负载信号，准备加载数据
                   if LD_edge = '1' then
                        State <= E1;
                        reg <= Din;               -- 将输入数据加载到寄存器
                        TxIrq <= '0'; -- 发送忙状态
                              
                    end if;

                when E1 =>
                    -- 发送起始位 (逻辑0)
                    if Tick = '1' then
                        State <= E2;
                        Tx <= '0';                -- 发送起始位
                        i <= 0;                  -- 确保位计数器从0开始
                    end if;

                when E2 =>
                    -- 发送数据位
                    if Tick = '1' then
                        Tx <= reg(i);             -- 发送当前位
                        if i = 7 then             -- 如果所有8位数据已经发送
                            State <= E3;
                        else
                            i <= i + 1; 
                            --State <= E1;          -- 递增位计数器
                        end if;
                    end if;

                when E3 =>
                    -- 发送停止位 (逻辑1)
                    if Tick = '1' then
                        Tx <= '1';                -- 发送停止位
                        State <= E4;
                    end if;

                when E4 =>
                    -- 发送完成，返回空闲状态
                    if Din = "00000110" then
                        TxIrq <= '0';
                    else      
                        TxIrq <= '1';
                    end if;          -- 清除忙标志
                    State <= E0;                  -- 返回到初始状态
            end case;
        end if;
    end process;
end architecture;
