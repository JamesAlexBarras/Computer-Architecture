use work.dlx_types.all;
use work.bv_arithmetic.all;

entity alu is 
	port(operand1, operand2: in dlx_word; operation: in alu_operation_code; result: out dlx_word; error: out error_code);
end entity alu;



architecture behavior of alu is 
begin
	aluProcess : process(operand1, operand2, operation) is
			-- 0000 = no error
			-- 0001 = overflow error
			-- 0010 = underflow error
			-- 0011 = divide by zero error
			variable error_boolean1 : boolean := false;
			variable error_boolean : boolean := false;
			variable result_var : dlx_word;
			variable result_true : dlx_word;
			variable result_false :dlx_word;
			variable minimum : dlx_word;
			variable zero : dlx_word;
			begin
			zero := "00000000000000000000000000000000";
			result_true := "00000000000000000000000000000001";
			--minimum := "11111111111111111111111111111111";
			result_false := "00000000000000000000000000000000";

			error <= "0000";
				--unsigned add
				case(operation) is
				when "0000" =>
					bv_addu(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							error <= "0001" after 15 ns;
						end if;
					result <= result_var after 15 ns;
				--unsigned subtract
				when "0001" =>
					bv_subu(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							error <= "0001" after 15 ns;
						end if;
					result <= result_var after 15 ns;
				--2's comp add
				when "0010" =>
					bv_add(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if(operand1(31) = '0') AND (operand2(31) = '0') then
								if (result_var(31) = '1') then
								error <= "0001" after 15 ns;
								end if;
							end if;
							if (operand1(31) = '1') AND (operand2(31) = '1') then
								if (result_var(31) = '0') then
								error <= "0010" after 15 ns;
								end if;
							end if;
						end if;						
					result <= result_var after 15 ns;
				--2's comp subtract
				when "0011" =>
					bv_sub(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if(operand1(31) = '1') AND (operand2(31) = '0') then
								if (result_var(31) = '0') then
								error <= "0010" after 15 ns;
								end if;
							end if;
							if (operand1(31) = '0') AND (operand2(31) = '1') then
								if (result_var(31) = '1') then
								error <= "0001" after 15 ns;
								end if;
							end if;
						end if;		
				
					result <= result_var after 15 ns;
				--2's comp multiply
				when "0100" =>
					bv_mult(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if ((operand1(31) = '1') AND (operand2(31) = '0')) OR ((operand1(31) = '0') AND (operand2(31) = '1')) then
							error <= "0010" after 15 ns;
							else
							error <= "0001" after 15 ns;
							end if;
	
						end if;
					result <= result_var after 15 ns;
				--2's comp divide
				when "0101" =>
					bv_div(operand1, operand2, result_var, error_boolean, error_boolean1);
						if error_boolean then
							error <= "0011" after 15 ns;
						end if;
						if error_boolean1 then
							error <= "0010" after 15 ns;
						end if;

					
					result <= result_var after 15 ns;
				--logical AND
				when "0110" =>
					if operand1 > zero then
						if operand2 > zero then
							result <= result_true after 15 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 15 ns;
						end if;
					end if;
					if operand1 = zero then
						if operand2 > zero then
							result <= result_false after 15 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 15 ns;
						end if;
					end if;
					

				--bitwise AND
				when "0111" => 
					result <= operand1 AND operand2 after 15 ns;
				--logical OR
				when "1000" =>
					if operand1 > zero then
						if operand2 > zero then
							result <= result_true after 15 ns;
						end if;
						if operand2 = zero then
							result <= result_true after 15 ns;
						end if;
					end if;
					if operand1 = zero then
						if operand2 > zero then
							result <= result_true after 15 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 15 ns;
						end if;
					end if;
				--bitwise OR
				when "1001" =>
					result <= operand1 OR operand2 after 15 ns;
				--logical NOT of operand1
				when "1010" =>
					if operand1 > zero then
						result <= result_false after 15 ns;
					end if;
					if operand1 = zero then
						result <= result_true after 15 ns;
					end if;
				--bitwise NOT of operand1
				when "1011" =>
					result <= NOT operand1 after 15 ns;
				--any other code (aka output 0s)
				when others =>
					result <= (others => '0') after 15 ns;
				end case;




	end process aluProcess;
end architecture behavior;
