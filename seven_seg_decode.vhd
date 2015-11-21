-----------------------------------------------------------------
-- File:				seven_seg_decode.vhd
-- 
-- Entity:			seven_seg_decode
-- Architecture:	Structural
-- Author:			Victoria Weaver
-- Created:			10/21/15
-- Modified:		--
--
-- VHDL '93
-- Description:	The following is the entity and architectural 
--				description of a coin controller for a vending 
--				machine.
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_seg_decode is
    Port ( seven_seg_in : in  STD_LOGIC_VECTOR (11 downto 0);
           seven_seg_out : out  STD_LOGIC_VECTOR (20 downto 0));
end seven_seg_decode;

architecture Behavioral of seven_seg_decode is

signal seven_seg_bcd : std_logic_vector(11 downto 0);

begin
	-- Hundreds
	with seven_seg_in(11 downto 8) select
	seven_seg_out(20 downto 14) <= "0000001" when "0000",
												"1001111" when "0001",
												"0010010" when "0010",
												"0000110" when "0011",
												"1001100" when "0100",
												"0100100" when "0101",
												"0100000" when "0110",
												"0001111" when "0111",
												"0000000" when "1000",
												"0000100" when "1001",
												"0110000" when others;
	-- Tens
	with seven_seg_in( 7 downto 4) select
	seven_seg_out(13 downto  7) <= "0000001" when "0000",
												"1001111" when "0001",
												"0010010" when "0010",
												"0000110" when "0011",
												"1001100" when "0100",
												"0100100" when "0101",
												"0100000" when "0110",
												"0001111" when "0111",
												"0000000" when "1000",
												"0000100" when "1001",
												"0110000" when others;
	-- Ones
	with seven_seg_in( 3 downto 0) select
	seven_seg_out( 6 downto  0) <= "0000001" when "0000",
												"1001111" when "0001",
												"0010010" when "0010",
												"0000110" when "0011",
												"1001100" when "0100",
												"0100100" when "0101",
												"0100000" when "0110",
												"0001111" when "0111",
												"0000000" when "1000",
												"0000100" when "1001",
												"0110000" when others;
end Behavioral;

