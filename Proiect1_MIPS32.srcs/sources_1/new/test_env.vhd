library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;
 
architecture Behavioral of test_env is
 
component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;
 
component InstrDecode is
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
end component;
 
component InstructionFetch is
 Port( 
        PCSrc :in std_logic;
        branchAddress :in std_logic_vector(31 downto 0);
        PCnext: out std_logic_vector(31 downto 0);
        instruction:out std_logic_vector(31 downto 0);
        clk:in std_logic;
        rst:in std_logic;
        en:in std_logic);       
end component;
 
component InstructionExecute is
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
end component;

component MainControl is
 Port (instr:in std_logic_vector(31 downto 0 );
        RegDst:out std_logic;
        ExtOp:out std_logic;
        Branch:out std_logic;
        ALUOp:out std_logic_vector(2 downto 0);
        ALUSrc:out std_logic;
        RegWrite:out std_logic);
end component;
 
---------------IF--------------------------
signal enMpg: std_logic;
signal rstMpg :std_logic;
signal instrOut: std_logic_vector(31 downto 0);
signal PcNextOut :std_logic_vector(31 downto 0);
signal digits: std_logic_vector(31 downto 0);
signal addrInstr : std_logic_vector( 31 downto 0);

-----------MainControl----------------------
signal RegDst, ExtOp, ALUSrc, Branch,RegWrite : std_logic;
signal ALUOp :std_logic_vector(2 downto 0);

-----------InsructionDecode------------------
signal rd1,rd2,wd,Ext_imm :std_logic_vector(63 downto 0);
signal func: std_logic_vector(5 downto 0);
signal sa : std_logic_vector(4 downto 0);


 
begin
monop1:  MPG port map(enMpg, btn(0), clk); --enable
monop2: MPG port map(rstMpg,btn(1),clk); --reset la IF
instrFetch : InstructionFetch port map(sw(1),addrInstr,PcNextOut,instrOut,clk,rstMpg,enMpg);
SevenSegment: SSD port map(clk, digits(15 downto 0), an, cat);
MainC : MainControl port map(instrOut,RegDst, ExtOp,Branch, ALUOp,ALUSrc,RegWrite);
IDmap : InstrDecode port map(RegWrite,instrOut(25 downto 0),RegDst,clk,enMpg,ExtOp,rd1,rd2,wd,Ext_imm,func,sa);
EX :InstructionExecute port map (rd1,rd2,Ext_imm,func,ALUOp,sa,PcNextOut,ALUSrc,wd,branch,addrInstr);

 
ledd: led(5 downto 0)<=ALUOp(0)&RegDst&ExtOp&ALUSrc&Branch&RegWrite;
 
swMUX: process(sw(7 downto 5),instrOut,PcNextOut,rd1,rd2,Ext_imm,wd)
begin
case sw(7 downto 5) is
when "000"=> digits(31 downto 0)<=instrOut;
when "001"=> digits(31 downto 0)<=PcNextOut;
when "010"=> digits<=RD1(31 downto 0);
when "011"=> digits<=RD2(31 downto 0);
when "100"=> digits<=Ext_Imm(31 downto 0);
when "101"=> digits<=wd(31 downto 0);
when others=>digits<=(others=>'X');
end case;
end process;
 
end Behavioral;