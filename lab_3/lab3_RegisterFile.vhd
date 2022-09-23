use work.dlx_types.all;
use work.bv_arithmetic.all;

entity reg_file is
	port(data_in : in dlx_word; readnotwrite, clock : in bit; data_out : out dlx_word; reg_number : in register_index);
end entity reg_file;

architecture behavior of reg_file is
	type reg_type is array (0 to 31) of dlx_word;
begin
	regFileProcess : process(data_in, clock, readnotwrite, reg_number) is 
		--type reg_type is array (0 to 31) of dlx_word;
		variable registers : reg_type;
		begin
	
		   if clock = '1' then
			if readnotwrite = '1' then
				data_out <= registers(bv_to_integer(reg_number)) after 10 ns;
			end if;
			if readnotwrite = '0' then
				registers(bv_to_integer(reg_number)) := data_in;
			end if;
		   end if;



--		case(reg_number) is 
--		when "00000" => 
--		   if clock = '1' then
--			if readnotwrite = '1' then
--				data_out <= registers(bv_to_integer(reg_number)) after 10 ns;
--			end if;
--			if readnotwrite = '0' then
--				registers(bv_to_integer(reg_number)) := data_in;
--			end if;
--		   end if;
--		when "00001" =>
--		   if clock = '1' then
--			if readnotwrite = '1' then
--				data_out <= registers(bv_to_integer(reg_number)) after 10 ns;
--			end if;
--			if readnotwrite = '0' then
--				registers(bv_to_integer(reg_number)) := data_in;
--			end if;
--		   end if;
--		when "00010" =>
--		when "00011" =>
--		when "00100" =>
--		when "00101" =>
--		when "00110" =>
--		when "00111" =>
--		when "01000" =>
--		when "01001" =>
--		when "01010" =>
--		when "01011" =>
--		when "01100" =>
--		when "01101" =>
--		when "01110" =>
--		when "01111" =>
--		when "10000" => 
--		when "10001" =>
--		when "10010" =>
--		when "10011" =>
--		when "10100" =>
--		when "10101" =>
--		when "10110" =>
--		when "10111" =>
--		when "11000" =>
--		when "11001" =>
--		when "11010" =>
--		when "11011" =>
--		when "11100" =>
--		when "11101" =>
--		when "11110" =>
--		when "11111" =>
 

		

	end process regFileProcess;
end architecture behavior;
