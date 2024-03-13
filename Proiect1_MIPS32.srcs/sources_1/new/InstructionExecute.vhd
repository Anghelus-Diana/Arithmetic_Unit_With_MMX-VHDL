library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity InstructionExecute is
Port (rd1:in std_logic_vector(63 downto 0 );
 rd2:in std_logic_vector(63 downto 0 );
 Ext_Imm:in std_logic_vector(63 downto 0);
 func:in std_logic_vector(5 downto 0);
 ALUOp:in std_logic_vector(2 downto 0);
 sa : in std_logic_vector ( 4 downto 0);
 PCnext:in std_logic_vector(31 downto 0);
 ALUSrc : in std_logic;
 ALURes:out std_logic_vector(63 downto 0);
 Branch: in std_logic;
 BranchAddress: out std_logic_vector(31 downto 0));
end InstructionExecute;

architecture Behavioral of InstructionExecute is

signal ALUCtrl :std_logic_vector(2 downto 0);
signal resAdd : std_logic_vector(31 downto 0);
signal PcSrc : std_logic ;

signal a: std_logic_vector(63 downto 0);
signal b: std_logic_vector(63 downto 0);
signal c: std_logic_vector(63 downto 0);
signal zero: std_logic;
signal c_33 : std_logic_vector(32 downto 0);
signal c_16_0, c_16_1, c_16_2, c_16_3 : std_logic_vector(16 downto 0);
signal c_16_s0, c_16_s1, c_16_s2, c_16_s3 : std_logic_vector(15 downto 0);
 

begin

A<= rd1;
B<= rd2;
resAdd<= PCnext + Ext_Imm(31 downto 0) ;
BranchAddress <= resAdd;

PcSrc <= Branch and Zero;

ALUControl:process(ALUOp,func)
begin 
  case ALUOp is 
  when "000"=>--R type
     case func is 
       when "000000"=>ALUCtrl<="000";-- +
       when "000001"=>ALUCtrl<="001"; -- -
       when "000010"=>ALUCtrl<="010"; -- |
       when "000100"=>ALUCtrl<="100"; -- >>( o bucata)
       when "001000"=>ALUCtrl<="110"; -- <<
       when "010000"=>ALUCtrl<="111"; -- >>(4 bucati)
       when others =>ALUCtrl<=(others=>'X');
      end case;
      --I type
  when "001"=>ALUCtrl<="001"; -- - 
  when others =>ALUCtrl<=(others=>'X');
  end case;
  end process;
  
  zerodetect:process(c)
begin
 if c=X"0000" then 
 Zero<='1';
 else 
 Zero<='0';
 end if;
end process;

ALU: process(a,b,ALUctrl,sa,c_16_0,c_16_1,c_16_2,c_16_3,c_16_s0,c_16_s1,c_16_s2,c_16_s3)
begin 
case ALUctrl is
    when "001" => c_16_0 <= ('0'& a(15 downto 0)) - ('0' & b(15 downto 0));  --PSUBW(-)-4 bucati
                  c_16_1 <= ('0'& a(31 downto 16)) - ('0' & b(31 downto 16)) - c_16_0(16);
                  c_16_2 <= ('0'& a(47 downto 32)) - ('0' & b(47 downto 32)) - c_16_1(16);
                  c_16_3 <= ('0'& a(63 downto 48)) - ('0' & b(63 downto 48)) - c_16_2(16);
                  c <= c_16_3(15 downto 0) & c_16_2(15 downto 0) & c_16_1(15 downto 0) & c_16_0(15 downto 0);
                  
    when "000" => c_16_0 <= ('0'& a(15 downto 0)) + ('0' & b(15 downto 0));  --PADDW(+)-4 bucati
                  c_16_1 <= ('0'& a(31 downto 16)) + ('0' & b(31 downto 16)) + c_16_0(16);
                  c_16_2 <= ('0'& a(47 downto 32)) + ('0' & b(47 downto 32)) + c_16_1(16);
                  c_16_3 <= ('0'& a(63 downto 48)) + ('0' & b(63 downto 48)) + c_16_2(16);
                  c <= c_16_3(15 downto 0) & c_16_2(15 downto 0) & c_16_1(15 downto 0) & c_16_0(15 downto 0);     
                          
   when "110" => c_16_s0 <= b(62 downto 48) & b(47); --PSLLW (4 bucati)
                 c_16_s1 <= b(46 downto 32) & b(31);
                 c_16_s2 <= b(30 downto 16) & b(15);
                 c_16_s3 <= b(14 downto 0) & '0';
                 c <= c_16_s0 & c_16_s1 & c_16_s2 & c_16_s3;
                 
   when "111" => c_16_s0 <= '0' & b(63 downto 49) ; --PSLRW (4 bucati)
                 c_16_s1 <= b(48) & b(47 downto 33);
                 c_16_s2 <= b(32) & b(31 downto 17);
                 c_16_s3 <= b(16) & b(15 downto 1);
                 c <= c_16_s0 & c_16_s1 & c_16_s2 & c_16_s3;
                 
                 
            
   
   when "010" => c <= a or b;
   
   when "100" => --shift PSRQ
            case sa is
                when "00000" => c <= b;
                when "00001" => c <= '0' & b(63 downto 1) ;
                when "00010" => c <= "00" & b(63 downto 2) ;
                when "00011" => c <="000" & b(63 downto 3) ;
                when "00100" => c <="0000" & b(63 downto 4) ;
                when "00101" => c <="00000" & b(63 downto 5) ;
                when others => c<=(others => 'X');
                end case;
  when others => c<=(others => 'X');
end case;
end process; 
     
ALURes<=c;

end Behavioral;
