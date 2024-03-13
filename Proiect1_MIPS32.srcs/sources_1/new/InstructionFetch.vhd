library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity InstructionFetch is
 Port( 
        PCSrc :in std_logic;
        branchAddress :in std_logic_vector(31 downto 0);
        PCnext: out std_logic_vector(31 downto 0);
        instruction:out std_logic_vector(31 downto 0);
        clk:in std_logic;
        rst:in std_logic;
        en:in std_logic);       
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal addmux: std_logic_vector(31 downto 0);
signal muxPC :std_logic_vector (31 downto 0);
signal q:std_logic_vector(31 downto 0);
signal d:std_logic_vector(31 downto 0);
signal addresses:std_logic_vector(4 downto 0);


type memorieRom is array(0 to 31) of std_logic_vector(31 downto 0);
signal mem:memorieRom:=(
B"000000_00001_00010_00100_00000_000000",    --X"222000" --paddw r4<=r1+r2
B"000000_00111_00010_00110_00000_000001",    --X"E23001" --psubw  r6<=r7-r2
B"000000_00011_00101_00010_00000_000010",   --X"651002" --por  r2   <= r3 or r5
B"000000_00000_00011_00110_00001_001000",   --X"43048"  --psllw r6<= r3<<1
B"000000_00000_00100_00111_00001_000100",   --X"43844"  --psrq r7<= r4>>1 (o bucata)
B"000000_00000_00001_00101_00001_010000",   --X"72850"  --psrlw r1<= r5>>1 (4 bucati)
B"000001_000111_00110_000000000000001",     --X"4730001"  pcmpeqw <=compara ce e in r7 cu r6 si daca-s egale sare la r1
others =>X"00000000");         --NoOp (ADD &0,&0,&0)    

begin

d<=muxPC;

PC: process(clk)
begin 
if rising_edge(clk) then 
    if rst='1' then
      q<="00000000000000000000000000000000";
     else if en='1' then 
     q<=d;
     end if;
   end if;
 end if;
 end process;
 
addresses<=q(4 downto 0);
PCnext<=q+1;
addmux<=q+1;

muxulDeDupaAdd:process(PCSrc,branchAddress,addmux)
  begin 
  case PCSrc is 
  when '1' =>muxPc<=branchAddress;
  when others =>muxPc<=addmux;
  end case;
 end process;

instruction<=mem(conv_integer(addresses(4 downto 0)));

end Behavioral;
