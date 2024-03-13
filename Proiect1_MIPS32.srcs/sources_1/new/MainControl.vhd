
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainControl is
 Port (instr:in std_logic_vector(31 downto 0 );
        RegDst:out std_logic;
        ExtOp:out std_logic;
        Branch:out std_logic;
        ALUOp:out std_logic_vector(2 downto 0);
        ALUSrc:out std_logic;
        RegWrite:out std_logic);
end MainControl;

architecture Behavioral of MainControl is
signal opcode:std_logic_vector(5 downto 0);

begin
opcode <= instr(31 downto 26);

procesul: process(instr(31 downto 26))
begin 
RegDst<='0';ExtOp<='0';
Branch<='0';RegWrite<='0';ALUOp<="000";ALUSrc<='0';

case instr(31 downto 26) is 
when "000000"=> -- R type
RegDst<='1';RegWrite<='1';ALUOp<="000";
when others =>
ExtOp <= '1' ; Branch <= '1'; ALUOp <= "001";
end case;
end process;

end Behavioral;
