-----------------------------------------------------------------
-- File:				Vending_machine_controller.vhd
-- 
-- Entity:			Vending_machine_controller
-- Architecture:	Structural
-- Author:			Victoria Weaver
-- Created:			10/14/15
-- Modified:		10/18/15
--
-- VHDL '93
-- Description:	The following is the entity and architectural 
--				description of a vending machine controller.
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.bin_bcd.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Vending_machine_controller is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           soda_price : in  STD_LOGIC_VECTOR(3 downto 0);
           soda_req : in  STD_LOGIC;
           Qp : in  STD_LOGIC;
           Dp : in  STD_LOGIC;
           Np : in  STD_LOGIC;
           amt_error : out  STD_LOGIC;
           drop_soda : out  STD_LOGIC;
           hund_disp_n : out  STD_LOGIC_VECTOR (6 downto 0);
           tens_disp_n : out  STD_LOGIC_VECTOR (6 downto 0);
           ones_disp_n : out  STD_LOGIC_VECTOR (6 downto 0));
end Vending_machine_controller;

architecture behavioral of Vending_machine_controller is

Component Coin_controller is
	Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           soda_price : in  STD_LOGIC_VECTOR(3 downto 0);
           soda_req : in  STD_LOGIC;
           Qp : in  STD_LOGIC;
           Dp : in  STD_LOGIC;
           Np : in  STD_LOGIC;
           amt_error : out  STD_LOGIC;
           amt_deposit : out  STD_LOGIC_VECTOR(9 downto 0);
           drop_soda : out  STD_LOGIC);
end component;

Component seven_seg_decode is
	Port (seven_seg_in : in  STD_LOGIC_VECTOR (11 downto 0);
			seven_seg_out : out  STD_LOGIC_VECTOR (20 downto 0));
end component;


-- Signals
signal hund_in, tens_in, ones_in: std_logic_vector(6 downto 0);
signal amt_deposit: std_logic_vector(9 downto 0);
signal amt_display: std_logic_vector(11 downto 0);

signal ssout: std_logic_vector(20 downto 0);

signal hund_disp : STD_LOGIC_VECTOR (6 downto 0);
signal tens_disp : STD_LOGIC_VECTOR (6 downto 0);
signal ones_disp : STD_LOGIC_VECTOR (6 downto 0);

begin

	coin_control: Coin_controller port map( clk, reset_n, soda_price, soda_req, Qp, Dp, Np, 
													amt_error, amt_deposit, drop_soda);

	amt_display <= Bin_to_BCD("00" & amt_deposit);

	ssdecode: seven_seg_decode port map (amt_display, ssout);

	hund_disp_n <= ssout(20 downto 14);
	tens_disp_n <= ssout(13 downto 7);
	ones_disp_n <= ssout(6 downto 0);
	
end behavioral;





