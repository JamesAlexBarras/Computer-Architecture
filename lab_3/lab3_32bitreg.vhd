
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity dlx_register is
	port(in_val : in dlx_word; clock : in bit; out_val : out dlx_word);
end entity dlx_register;

architecture behavior of dlx_register is
begin
	dlxRegProcess : process(in_val, clock) is 
		begin
		if clock = '1' then
			out_val <= in_val after 10 ns;
		end if;

	end process dlxRegProcess;
end architecture behavior;
