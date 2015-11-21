-----------------------------------------------------------------
-- File:				Coin_controller.vhd
-- 
-- Entity:			Coin_controller
-- Architecture:	Structural
-- Author:			Victoria Weaver
-- Created:			10/14/15
-- Modified:		10/18/15
--
-- VHDL '93
-- Description:	The following is the entity and architectural 
--				description of a coin controller for a vending 
--				machine.
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Coin_controller is
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
end Coin_controller;

architecture Behavioral of Coin_controller is

-- Define the states
	type state_type is (IDLE, DROP, ERROR, HOLD);
	signal state, next_state: state_type;
	
-- Define the prices
	type priceArray is array (0 to 8) of std_logic_vector(9 downto 0);
-- Put the prices in the table into an array
	CONSTANT prices: priceArray:=("0000110111", "0001010101", "0001011111", "0001111101", 
										"0010000111", "0010010110", "0011100001", "0011111010", 
										"0100101100");

	signal amt_err : STD_LOGIC;
	signal amt_dep : STD_LOGIC_VECTOR(9 downto 0);
	signal drop_s : STD_LOGIC;
	
begin

SYNC_PROC: process (clk, state, reset_n) begin
	if (reset_n = '0') then
		state <= IDLE;
	elsif (clk'event and clk = '1') then
		state <= next_state;
	else
		state <= state;
	end if;
end process;

-- next_state signal
NextStateDecode: process(reset_n, state, Qp, Dp, Np, amt_err, drop_s, soda_req, amt_dep, soda_price) 
begin
	--next_state <= state;  --default is to stay in current state
	case (state) is
		when IDLE =>
			if (soda_req='1') then
				if amt_dep >= prices(to_integer(unsigned(soda_price))) then
					next_state <= DROP;
				else
					next_state <= ERROR;
				end if;
			elsif (Qp or Np or Dp)='1' then
				next_state <= HOLD;
			else
				next_state <= IDLE;
			end if;	
		when DROP =>
			if soda_req='0' then
				next_state <= IDLE;
			else
				next_state <= DROP;
			end if;
		when ERROR =>
			if soda_req='0' then
				next_state <= IDLE;
			else
				next_state <= ERROR;
			end if;
		when HOLD =>
			if(Qp or Np or Dp)='0' then
				next_state <= IDLE;
			else
				next_state <= HOLD;
			end if;
		when others =>
			next_state <= state;
	end case;		
end process;




-- amt_deposit signal
DepositUpdate: process(reset_n, state, next_state, Qp, Dp, Np, amt_dep, soda_price, drop_s, clk)
begin
	if reset_n = '0' then
		amt_dep <= "0000000000";
	elsif (clk'event and clk='1') then	
		case (state) is
		when IDLE =>
			if(next_state = HOLD) then
				if (Qp= '1') then 
					amt_dep <= amt_dep + std_logic_vector(to_unsigned(25, 10));
				elsif(Dp = '1') then
					amt_dep <= amt_dep + std_logic_vector(to_unsigned(10, 10));
				elsif(Np = '1') then
					amt_dep <= amt_dep + std_logic_vector(to_unsigned(5, 10));
				else
					amt_dep <= amt_dep;
				end if;
			else
				amt_dep <= amt_dep;
			end if;
		when DROP =>
			if(next_state = IDLE) then
				amt_dep <= amt_dep - prices(to_integer(unsigned(soda_price)));	
			else
				amt_dep <= amt_dep;
			end if;
		when others =>
			amt_dep <= amt_dep;
		end case;
	else
		amt_dep <= amt_dep;
	end if;
	amt_deposit <= amt_dep;
end process;

-- amt_error signal
AmtErrorUpdate: process(reset_n, clk, state, amt_err, soda_price)
begin
	if reset_n = '0' then
		amt_err <= '0';
	elsif (clk'event and clk='1') then	
		case state is
		when IDLE =>
			if (soda_req='1') then
				if amt_dep >= prices(to_integer(unsigned(soda_price))) then
					amt_err <= '0';
				else
					amt_err <= '1';
				end if;
			else
				amt_err <= '0';
			end if;
		when DROP =>
			amt_err <= '0';
		when ERROR =>
			amt_err <= '1';
		when others =>
			amt_err <= amt_err;
		end case;
	else
		amt_err <= amt_err;
	end if;
	amt_error <= amt_err;
end process;


-- drop_soda signal
DropUpdate: process(reset_n, clk, state, amt_err, amt_dep, drop_s, soda_price)
begin
	if reset_n = '0' then
		drop_s <= '0';
	elsif (clk'event and clk='1') then	
		case state is
		when DROP =>
			drop_s <= '1';
		when others =>
			drop_s <= '0';
		end case;
	else
		drop_s <= drop_s;
	end if;
	drop_soda <= drop_s;
end process;

end Behavioral;

