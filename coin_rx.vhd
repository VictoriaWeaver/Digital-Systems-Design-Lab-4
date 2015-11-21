----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Prof. Cliver
-- 
-- Create Date: Summer Time
-- Design Name: vending_machine
-- Module Name: coin_rx - Behavioral 
-- Project Name: 561_vend_mach
-- Target Devices: Spartan 3E FPGA
-- Tool versions: 8.2
-- Description: Accepts async quarter, dime and nichel switch inputs.
--              Produces 1 second pulse when coin pulse (H/L) recd.
--
-- Dependencies: 
--
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments: Feel free to change any names or code.
--	Refer to the Digilent manual for more details.
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity coin_rx is
    Port ( Qrcd     : in   STD_LOGIC;
           Drcd     : in   STD_LOGIC;
           Nrcd     : in   STD_LOGIC;
			  Clk      : in   STD_LOGIC;
			  Reset_n  : in   STD_LOGIC;
			  Qp       : out  STD_LOGIC;
           Dp       : out  STD_LOGIC;
           Np       : out  STD_LOGIC);
end coin_rx;

architecture Behavioral of coin_rx is
-- state machine to handle coin entry
-- only one coin is handled at a time
   type state_type is (idle, nickel_detected,  nickel_wait,
	                          dime_detected,    dime_wait,
									  quarter_detected, quarter_wait); 
   signal state, next_state : state_type; 

-- external signals that are not syncronized with the clock
--   should first be run through two FFs to avoid metastability.
  signal Q_reg      : STD_LOGIC;
  signal Q_received : STD_LOGIC;
  signal D_reg      : STD_LOGIC;
  signal D_received : STD_LOGIC;
  signal N_reg      : STD_LOGIC;
  signal N_received : STD_LOGIC;
  signal coin_cntr  : STD_LOGIC_VECTOR (9 downto 0);
  constant coin_cntr_max : STD_LOGIC_VECTOR (9 downto 0) := "1111111111";

begin
  metastability_remover : process (clk) begin
    if (clk'event and clk = '1') then
	   if (Reset_n = '0') then
        Q_reg        <= '0';
		  Q_received   <= '0';
        D_reg        <= '0';
		  D_received   <= '0';
        N_reg        <= '0';
		  N_received   <= '0';
		else
        Q_reg        <= Qrcd;
		  Q_received   <= Q_reg;
        D_reg        <= Drcd;
		  D_received   <= D_reg;
        N_reg        <= Nrcd;
		  N_received   <= N_reg;
		end if;
	 end if;
  end process metastability_remover;

  SYNC_PROC: process (clk) begin
    if (clk'event and clk = '1') then
      if (reset_n = '0') then
        state <= idle;
	     Qp <= '0';
	     Dp <= '0';
	     Np <= '0';
      else
        state <= next_state;
        case next_state is
		    when quarter_detected =>
			   Qp <= '1';
            Dp <= '0';
            Np <= '0';
		    when dime_detected =>
			   Qp <= '0';
            Dp <= '1';
            Np <= '0';
		    when nickel_detected =>
			   Qp <= '0';
            Dp <= '0';
            Np <= '1';
			 when OTHERS =>
			   Qp <= '0';
            Dp <= '0';
            Np <= '0';
		  end case;
      end if;        
    end if;
  end process;

  NEXT_STATE_DECODE: process (state, coin_cntr, q_received, d_received, n_received) begin
    --declare default state for next_state to avoid latches
    next_state <= state;  --default is to stay in current state
    case (state) is
      when idle =>
        if (Q_received = '1') then
          next_state <= quarter_detected;
        elsif (D_received = '1') then
		    next_state <= dime_detected;
		  elsif (N_received = '1') then
		    next_state <= nickel_detected;
	     end if;
      when quarter_detected =>
        if coin_cntr = coin_cntr_max then
          next_state <= quarter_wait;
		  else
		    next_state <= quarter_detected;
        end if;
      when quarter_wait =>
        if (Q_received = '0') then -- signal must go low again before another pulse is generated
		    next_state <= idle;
		  else
		    next_state <= quarter_wait;
		  end if;
      when dime_detected =>
        if coin_cntr = coin_cntr_max then
          next_state <= dime_wait;
		  else
		    next_state <= dime_detected;
        end if;
      when dime_wait =>
        if (D_received = '0') then -- signal must go low again before another pulse is generated
		    next_state <= idle;
		  else
		    next_state <= dime_wait;
		  end if;
      when nickel_detected =>
        if coin_cntr = coin_cntr_max then
          next_state <= nickel_wait;
		  else
		    next_state <= nickel_detected;
        end if;
      when nickel_wait =>
        if (N_received = '0') then -- signal must go low again before another pulse is generated
		    next_state <= idle;
		  else
		    next_state <= nickel_wait;
		  end if;
      when others =>
        next_state <= idle;
      end case;      
   end process;

-- set clock at 25MHz clock
-- coin receiver counter. It is started by the any rcd signal.
-- additional rcd signals are not recognized until the counter completes and rcd is deasserted.
-- 3FF (hex) = 1023 (dec).
-- if 25MHz  / 1023 it becomes 24,437Hz or 40.9us

  coin_rcd_cntr : process (clk) begin
	 if (clk'event and clk = '1') then
	   if (reset_n = '0') then
	     coin_cntr <= (OTHERS => '0');
	   else
	     case state is
			 when quarter_detected | dime_detected | nickel_detected =>
		      coin_cntr <= coin_cntr + 1;
          when OTHERS =>
			   coin_cntr <= (OTHERS => '0');
        end case;			   
	   end if;
	 end if;
  end process coin_rcd_cntr;

end Behavioral;