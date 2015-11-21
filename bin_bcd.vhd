--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

package bin_bcd is

FUNCTION bin_to_bcd (bin :std_logic_vector(11 DOWNTO 0)) return std_logic_vector;


end bin_bcd;

package body bin_bcd is

FUNCTION Bin_to_BCD (bin :std_logic_vector(11 DOWNTO 0)) return std_logic_vector IS
-- if 100's, 10's, 1's >= 0101
   -- add 3
-- shift left 1
-- if 10 shifts, done
	variable i : integer:=0;
	variable bcd : std_logic_vector(23 downto 0);
	variable bint : std_logic_vector(11 DOWNTO 0) := bin;
	BEGIN
		bcd := (others => '0');
		bcd(11 downto 0) := bint;
		for i in 0 to 11 loop 
			-- Left shift one bit
			bcd(23 downto 0) := bcd(22 downto 0) & '0';
			-- Check phase
			if(i < 11 and bcd(15 downto 12) > "0100") then 
				bcd(15 downto 12) := bcd(15 downto 12) + "0011";
			end if;
			if(i < 11 and bcd(19 downto 16) > "0100") then 
				bcd(19 downto 16) := bcd(19 downto 16) + "0011";
			end if;
			if(i < 11 and bcd(23 downto 20) > "0100") then 
				bcd(23 downto 20) := bcd(23 downto 20) + "0011";
			end if;
		end loop;
		RETURN BCD(23 downto 12);
	END FUNCTION;
 
end bin_bcd;
