library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end entity;

architecture a of tb is 

	component irReceiver is
	  Port ( 
	    clk_50 : in std_logic;
	    irSignal : in std_logic;
	    frame : out std_logic_vector(11 downto 0)
	  );
	end component;

	signal clk_50 : std_logic;
	signal irSignal : std_logic;
	signal frame : std_logic_vector(0 to 11);

begin
process
begin
	clk_50<='1';
	wait for 20ns;
	while(true)loop
		clk_50<='0';
		wait for 10ns;
		clk_50<='1';
		wait for 10ns;
	end loop;
end process;

process--(clk_50)
begin
	--if(rising_edge(clk_50))then
	--start
	irSignal<='0';
	wait for 2400us;
	irSignal<='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '1')
	irSignal<='0';
	wait for 1200us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '1')
	irSignal<='0';
	wait for 1200us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '1')
	irSignal<='0';
	wait for 1200us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '1')
	irSignal<='0';
	wait for 1200us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '0')
	irSignal <='0';
	wait for 600us;
	irSignal <='1';
	wait for 600us;
	--trama (envio un '1')
	irSignal<='0';
	wait for 1200us;
	irSignal <='1';
	wait for 600us;
	--Fin
	wait;
end process;

inst1: irReceiver
  Port Map( 
    clk_50 => clk_50,
    irSignal => irSignal,
    frame => frame
  );

end a;

