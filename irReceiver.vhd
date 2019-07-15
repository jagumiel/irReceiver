library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity irReceiver is
	Port ( 
			clk_50	: in	std_logic;												--Reloj del sistema (@50MHz).
			irSignal	: in	std_logic;												--Senal de entrada (iR).
			frame		: out	std_logic_vector (9 downto 0) :="0000000000"	--Senal decodificada.
  );
end irReceiver;

architecture Behavioral of irReceiver is

	--Estados
	TYPE estados is (idle, start, decoding, finish);
	SIGNAL ep : estados :=idle;	--Estado Presente
	SIGNAL es : estados;				--Estado Siguiente

	--Senales de control
	SIGNAL started	: std_logic :='0';	--Se ha captado un inicio de transferencia.
	SIGNAL decoded	: std_logic :='0';	--La trama ha sido decodificada.
	SIGNAL failled	: std_logic :='0';	--Fallo. Trama ininteligible.
	SIGNAL success	: std_logic :='0';	--Exito. Se ha enviado la trama capturada al exterior.
	
	--Senales (Contadores)
	SIGNAL cycleCounter	: integer range 0 to 149999 := 0;	--Contador de ciclos. Cada ciclo equivale a 20ns@50MHz.
	SIGNAL NB				: integer range -1 to 12 :=-1;		--Numero de Bits. Sirve para almacenar el dato en el array.
	
	--Senales auxiliares
	SIGNAL myData	: std_logic_vector (11 downto 0) :="000000000000";	--Vector auxiliar donde se va almacenando la trama que se recibe.
	SIGNAL stored	: std_logic :='0'; 											--Indica si el bit se ha almacenado en el vector. Latch.
	

begin
	--Maquina de estados (Unidad de Control)
	process(ep, irSignal, started, decoded, failled, success)
	begin
		CASE ep IS
			WHEN idle =>
				IF(irSignal='0' and started='0')THEN
					es<=start;
				ELSE
					es<=idle;
				END IF;
			--Empieza la cond. de inicio. 2,4ms a '1' en el emisor. Mi circuito esta en logica negada.
			WHEN start=>
				IF(irSignal='1' and started='1')THEN --Started se activa cuando ha pasado el tiempo.
					es<=decoding;
				ELSIF(failled='1')THEN
					es<=idle;
				ELSE					
					es<=start;
				END IF;
			--Ahora se decodifica la senal.
			WHEN decoding=>
				IF(decoded='1')THEN
					es<=finish;
				ELSIF(failled='1')THEN
					es<=idle;
				ELSE
					es<=decoding;
				END IF;
			--Uso este estado para actualizar la salida "frame".
			WHEN finish =>
				IF(success='1')THEN
					es<=idle;
				ELSE
					es<=finish;
				END IF;
			END CASE;
	end process;
			
	ep<=es;
	
	--(Unidad de procesos)
	process(clk_50)
	begin
		if(rising_edge(clk_50))then
			if(ep=idle)then
				--Contadores a 0.
				cycleCounter<=0;
				NB<=-1;
				--Reinicio de las senales de control.
				failled<='0';
				started<='0';
				decoded<='0';
				success<='0';
				stored <='0';
			elsif(ep=start)then
				--Comprobar que esta 2,4ms a '0'
				if(cycleCounter<120000)then
					cycleCounter<=cycleCounter+1;
					--Si la condicion de inicio se interrumpe, se para.
					if(cycleCounter<100000 and irSignal='1')then
						failled<='1';
					end if;
				else
					--Han pasado 2,4ms y la condicion de inicio se ha cumplido.
					started<='1';
					cycleCounter<=0;
				end if;
			elsif(ep=decoding)then
				--Lectura del dato.
				if(NB<12)then
					--Cuanto tiempo esta el led emitiendo?
					if(irSignal='0')then
						stored<='0';
						cycleCounter<=cycleCounter+1;
					else
						--Si el led ha estado mas de 1ms emitiendo, es un uno, sino, es un cero.
						if(stored='0')then
							if(NB>-1)then
								if(cyclecounter>50000)then
									myData(NB)<='1';
								else
									myData(NB)<='0';
								end if;
							end if;
							NB<=NB+1;
							cycleCounter<=0;
							stored<='1';
						end if;
					end if;
				else
					decoded<='1';
				end if;
			elsif(ep=finish)then
				--Recepcion completada, se actualiza el vector de salida.
				frame<=myData(11 downto 2);
				success<='1';
			end if;		
		end if;
	end process;
	
	
end Behavioral;