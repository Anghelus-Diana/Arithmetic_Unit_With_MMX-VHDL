library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.All;


entity InstrDecode is
Port (RegWrite:in std_logic;
 instr:in std_logic_vector(25 downto 0 );
 regDst : in std_logic;
 clk:in std_logic;
 en:in std_logic;
 ExtOp:in std_logic;
 rd1:out std_logic_vector(63 downto 0);
 rd2:out std_logic_vector(63 downto 0);
 wd:in std_logic_vector(63 downto 0);
 ExtImm:out std_logic_vector(63 downto 0);
 func:out std_logic_vector(5 downto 0);
 sa :out std_logic_vector(4 downto 0)); 
end InstrDecode;

architecture Behavioral of InstrDecode is

type reg_array is array (0 to 7) of std_logic_vector(63 downto 0);
signal reg_file : reg_array := (X"0000000000000000",
                                X"0000000000000002",
                                X"0000000000000005",
                                X"0000000000000001",
                                X"0000000000000004",
                                X"0000000000000006",
                                X"0000000000000006",
                       others =>X"0000000000000008");

signal ra1:std_logic_vector(4 downto 0);
signal ra2:std_logic_vector(4 downto 0);
signal rt:std_logic_vector(4 downto 0);
signal rd:std_logic_vector(4 downto 0);
signal wa:std_logic_vector(4 downto 0);


begin

ra1<=instr(25 downto 21);
ra2<=instr(20 downto 16);
func<=instr(5 downto 0);
sa<=instr(10 downto 6);


extUnit:process(ExtOp,instr(15 downto 0))
begin
case ExtOp is 
when '1'=>extImm<=instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15 downto 0);
when others=>extImm<="000000000000000000000000000000000000000000000000"&instr(15 downto 0);
end case;
end process;

rt<=instr(20 downto 16);
rd<=instr(15 downto 11);

regfile:process(clk)
begin
if falling_edge(clk) then
if RegWrite = '1' and en='1' then
reg_file(conv_integer(wa)) <= wd;
    end if;
    end if;
    end process;
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

mux: process(instr(20 downto 15),instr(15 downto 11),regDst)
begin 
case regDst is 
     when '1' =>wa<=instr(15 downto 11);
     when others => wa <= instr(20 downto 16);
     end case;
     end process;

end Behavioral;
