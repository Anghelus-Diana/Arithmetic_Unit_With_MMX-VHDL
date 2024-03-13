----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 11:48:24 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED .ALL;


entity SSD is
Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt :std_logic_vector(15 downto 0):=(others=>'0');
signal thex :std_logic_vector(3 downto 0);
signal sel: std_logic_vector(1 downto 0);

begin
sel<=cnt(15 downto 14);

counter: process(clk)
begin
if rising_edge(clk)then  
    cnt<=cnt+1;
  end if;
end process;

muxAN: process(sel)
begin 
case sel is 
 when "00" =>an<="1110";
 when "01" =>an<="1101";
 when "10" =>an<="1011";
 when others =>an<="0111";
end case;
end process;
 
muxCAT: process(sel,digits)
begin 
case sel is 
when "00" =>thex<=digits(3 downto 0);
 when "01" =>thex<=digits(7 downto 4);
 when "10" =>thex<=digits(11 downto 8);
 when others =>thex<=digits(15 downto 12);
end case;
end process;
 

dcd:process(thex)
begin 
case thex is 
when "0000"=>cat<="1000000";--0
when "0001"=>cat<="1111001";--1
when "0010"=>cat<="0100100";--2
when "0011"=>cat<="0110000";--3
when "0100"=>cat<="0011001";--4
when "0101"=>cat<="0010010";--5
when "0110"=>cat<="0000010";--6
when "0111"=>cat<="1111000";--7
when "1000"=>cat<="0000000";--8
when "1001"=>cat<="0010000";--9
when "1010"=>cat<="0001000";--A
when "1011"=>cat<="0000011";--b
when "1100"=>cat<="1000110";--C
when "1101"=>cat<="0100001";--d
when "1110"=>cat<="0000110";--E
when others=>cat<="0001110";--F
end case;
end process;


end Behavioral;
