library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4 is
    Port (
        A   : in  STD_LOGIC_VECTOR(31 downto 0);   -- 输入通道A
        B   : in  STD_LOGIC_VECTOR(31 downto 0);    -- 输入通道B
        C   : in  STD_LOGIC_VECTOR(31 downto 0);    -- 输入通道C
        D   : in  STD_LOGIC_VECTOR(31 downto 0);    -- 输入通道D
        COM : in  STD_LOGIC_VECTOR(1 downto 0);     -- 选择信号（2位）
        S   : out STD_LOGIC_VECTOR(31 downto 0)     -- 输出信号
    );
end MUX4;

architecture Behavioral of MUX4 is
begin
    -- 组合逻辑实现选择功能
    process(A, B, C, D, COM)
    begin
        case COM is
            when "00"   => S <= A;    -- 选择通道A
            when "01"   => S <= B;    -- 选择通道B
            when "10"   => S <= C;    -- 选择通道C
            when "11"   => S <= D;    -- 选择通道D
            when others => S <= (others => '0');  -- 容错处理
        end case;
    end process;
end Behavioral;