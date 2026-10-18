library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIC is
    port (
        CLK      : in  std_logic;
        RST    : in  std_logic;
        IRQ_SERV : in  std_logic;  -- 来自 MAE 的中断响应确认
        IRQ0     : in  std_logic;
        IRQ1     : in  std_logic;

        IRQ2     : in  std_logic;
        IRQ_UART_TX     : in  std_logic;      -- 来自 UART 的发送继续
        IRQ_UART_RX     : in  std_logic;

        IRQ      : out std_logic;  -- 中断请求发送给 MAE

        VICPC    : out std_logic_vector(31 downto 0)  -- 中断子程序地址
        
    );
end entity;

architecture Behavioral of VIC is
    signal irq0_d, irq1_d, irq2_d,IRQ_UART_TX_d,IRQ_UART_RX_d        : std_logic := '0';  -- 上一周期值
    signal IRQ0_memo, IRQ1_memo,IRQ2_memo,IRQ_UART_TX_memo,IRQ_UART_RX_memo   : std_logic := '0';
begin

    process(CLK, RST)
    begin
        if RST = '1' then
            IRQ0_memo <= '0';
            IRQ1_memo <= '0';
            IRQ2_memo <= '0';
            IRQ_UART_TX_memo <= '0';
            irq0_d <= '0';
            irq1_d <= '0';
            irq2_d <= '0';
            IRQ_UART_TX_d<='0';
            IRQ_UART_RX_d<='0';
        elsif rising_edge(CLK) then
            -- 检测上升沿
            if (IRQ0 = '1' and irq0_d = '0') then
                IRQ0_memo <= '1';
            end if;
            if (IRQ1 = '1' and irq1_d = '0') then
                IRQ1_memo <= '1';
            end if;
            if (IRQ2 = '1' and irq2_d = '0') then
                IRQ2_memo <= '1';
            end if;       
            if (IRQ_UART_TX = '1' and IRQ_UART_TX_d = '0') then
                IRQ_UART_TX_memo <= '1';
            end if;
            if (IRQ_UART_RX = '1' and IRQ_UART_RX_d = '0') then
                IRQ_UART_RX_memo <= '1';
            end if;

            -- 如果收到响应确认，清除中断
            if IRQ_SERV = '1' then
                IRQ0_memo <= '0';
                IRQ1_memo <= '0';
                IRQ2_memo <= '0';
                IRQ_UART_TX_memo <= '0';
                IRQ_UART_RX_memo <= '0';
            end if;

            -- 保存当前值用于下次比较
            irq0_d <= IRQ0;
            irq1_d <= IRQ1;
            irq2_d <= IRQ2;
            IRQ_UART_TX_d <= IRQ_UART_TX;
            IRQ_UART_RX_d <= IRQ_UART_RX;
        end if;
    end process;

    -- 中断优先级：IRQ0 > IRQ1
    process(IRQ0_memo, IRQ1_memo,IRQ2_memo,IRQ_UART_TX_memo,IRQ_UART_RX_memo)
    begin
        if IRQ0_memo = '1' then
            VICPC <= x"00000009";
        elsif IRQ1_memo = '1' then
            VICPC <= x"00000015";
        elsif IRQ2_memo = '1' then
            VICPC <= x"00000060";
        elsif IRQ_UART_TX_memo = '1' then
            VICPC <= x"00000060";
        elsif IRQ_UART_RX_memo = '1' then
            VICPC <= x"00000042";
        else
            VICPC <= (others => '0');
        end if;
    end process;

    -- 组合输出 IRQ = IRQ0_memo OR IRQ1_memo
    IRQ <= IRQ0_memo or IRQ1_memo or IRQ2_memo or IRQ_UART_TX_memo or IRQ_UART_RX_memo;

end architecture;
