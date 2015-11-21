-----------------------------------------------------------------
-- File:				Vending_machine_controller.vhd
-- 
-- Entity:			Vending_machine_controller
-- Architecture:	Structural
-- Author:			Victoria Weaver
-- Created:			10/21/15
-- Modified:		--
--
-- VHDL '93
-- Description:	The following is the entity and architectural 
--				description of a vending machine controller.
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Usr_tb IS
END Usr_tb;
 
ARCHITECTURE behavior OF Usr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Usr_interaction
    PORT(
         Qrcd_in : IN  std_logic;
         Drcd_in : IN  std_logic;
         Nrcd_in : IN  std_logic;
         Clk_in : IN  std_logic;
         Reset_n_in : IN  std_logic;
         Soda_req_in : IN  std_logic;
         Soda_price_in : IN  std_logic_vector(3 downto 0);
         Drop_soda_out : OUT  std_logic;
         Qrcd_out : OUT  std_logic;
         Drcd_out : OUT  std_logic;
         Nrcd_out : OUT  std_logic;
         Amt_error : OUT  std_logic;
         unused_anode : OUT  std_logic;
         hund_anode_out : OUT  std_logic;
         tens_anode_out : OUT  std_logic;
         ones_anode_out : OUT  std_logic;
         CAn_out : OUT  std_logic;
         CBn_out : OUT  std_logic;
         CCn_out : OUT  std_logic;
         CDn_out : OUT  std_logic;
         CEn_out : OUT  std_logic;
         CFn_out : OUT  std_logic;
         CGn_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Qrcd_in : std_logic := '0';
   signal Drcd_in : std_logic := '0';
   signal Nrcd_in : std_logic := '0';
   signal Clk_in : std_logic := '0';
   signal Reset_n_in : std_logic := '0';
   signal Soda_req_in : std_logic := '0';
   signal Soda_price_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Drop_soda_out : std_logic;
   signal Qrcd_out : std_logic;
   signal Drcd_out : std_logic;
   signal Nrcd_out : std_logic;
   signal Amt_error : std_logic;
   signal unused_anode : std_logic;
   signal hund_anode_out : std_logic;
   signal tens_anode_out : std_logic;
   signal ones_anode_out : std_logic;
   signal CAn_out : std_logic;
   signal CBn_out : std_logic;
   signal CCn_out : std_logic;
   signal CDn_out : std_logic;
   signal CEn_out : std_logic;
   signal CFn_out : std_logic;
   signal CGn_out : std_logic;

   -- Clock period definitions
   constant Clk_in_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Usr_interaction PORT MAP (
          Qrcd_in => Qrcd_in,
          Drcd_in => Drcd_in,
          Nrcd_in => Nrcd_in,
          Clk_in => Clk_in,
          Reset_n_in => Reset_n_in,
          Soda_req_in => Soda_req_in,
          Soda_price_in => Soda_price_in,
          Drop_soda_out => Drop_soda_out,
          Qrcd_out => Qrcd_out,
          Drcd_out => Drcd_out,
          Nrcd_out => Nrcd_out,
          Amt_error => Amt_error,
          unused_anode => unused_anode,
          hund_anode_out => hund_anode_out,
          tens_anode_out => tens_anode_out,
          ones_anode_out => ones_anode_out,
          CAn_out => CAn_out,
          CBn_out => CBn_out,
          CCn_out => CCn_out,
          CDn_out => CDn_out,
          CEn_out => CEn_out,
          CFn_out => CFn_out,
          CGn_out => CGn_out
        );

   -- Clock process definitions
   Clk_in_process :process
   begin
		Clk_in <= '0';
		wait for Clk_in_period/2;
		Clk_in <= '1';
		wait for Clk_in_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- Hold reset state for 100 ns.
      wait for 100 ns;
		
		
		-- Reset the vending machine	
		Reset_n_in <= '0';
      wait for Clk_in_period*10;
		
		Reset_n_in <= '1';
      wait for Clk_in_period*10;
		
		-- Setting a price code
		Soda_price_in <= "0011";
		wait for Clk_in_period*10;
		
		-- Inserting different coins
		Qrcd_in <= '1';
		Drcd_in <= '0';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Qrcd_in <= '0';
		wait for 10 ms;		
		
		-- Requesting a soda with not enough coins
		Soda_req_in <= '1';
		wait for Clk_in_period*10;
		assert (Amt_error = '1' and Drop_soda_out = '0')
			report "Error, dropped without enough money.";
		wait for Clk_in_period;
		Soda_req_in <= '0';
		wait for 10 ms;
		
		-- Add more money
		Qrcd_in <= '1';
		Drcd_in <= '0';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Qrcd_in <= '0';
		wait for 10 ms;
		Qrcd_in <= '1';
		Drcd_in <= '0';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Qrcd_in <= '0';
		wait for 10 ms;
		Qrcd_in <= '1';
		Drcd_in <= '0';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Qrcd_in <= '0';
		wait for 10 ms;
		Qrcd_in <= '0';
		Drcd_in <= '1';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Drcd_in <= '0';
		wait for 10 ms;
		Qrcd_in <= '0';
		Drcd_in <= '1';
		Nrcd_in <= '0';
		wait for Clk_in_period*10;
		Drcd_in <= '0';
		wait for 10 ms;
		Qrcd_in <= '0';
		Drcd_in <= '0';
		Nrcd_in <= '1';
		wait for Clk_in_period*10;
		Nrcd_in <= '0';
		wait for 10 ms;		
		
		-- Request a soda with enough coins
		Soda_req_in <= '1';
		wait for Clk_in_period*10;
		assert (Amt_error = '0' and Drop_soda_out = '1')
			report "Error, failed to drop.";
		wait for Clk_in_period;
		Soda_req_in <= '0';
		wait;
		
   end process;

END;
