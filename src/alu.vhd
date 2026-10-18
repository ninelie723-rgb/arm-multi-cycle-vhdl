library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        OP : in std_logic_vector(1 downto 0);   -- 2-bit操作码
        A, B : in std_logic_vector(31 downto 0);-- 32位输入总线
        S : out std_logic_vector(31 downto 0);  -- 32位输出总线
        N, Z : out std_logic                    -- 标志位N（负）和Z（零）
    );
end ALU;

architecture Behavioral of ALU is
    signal result : std_logic_vector(31 downto 0);
begin
    process(OP, A, B)
    begin
        case OP is
            when "00" => result <= std_logic_vector(signed(A) + signed(B)); -- ADD
            when "01" => result <= B;                                       -- B
            when "10" => result <= std_logic_vector(signed(A) - signed(B)); -- SUB
            when "11" => result <= A;                                       -- A
            when others => result <= "00000000000000000000000000000000";                       -- 默认值
        end case;
    end process;
    
    S <= result; -- 输出结果
    N <= '1' when signed(result) < 0 else '0';  -- 负标志
    Z <= '1' when result = "00000000000000000000000000000000" else '0';-- 零标志
end Behavioral;