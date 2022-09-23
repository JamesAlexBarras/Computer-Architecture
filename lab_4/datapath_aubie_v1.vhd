-- datapath_aubie.vhd

-- entity reg_file (lab 3)
use work.dlx_types.all; 
use work.bv_arithmetic.all;  

entity reg_file is
     port (data_in: in dlx_word; readnotwrite,clock : in bit; 
	   data_out: out dlx_word; reg_number: in register_index );
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
				data_out <= registers(bv_to_integer(reg_number)) after 5 ns;
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


-- entity alu (lab 2) 
use work.dlx_types.all; 
use work.bv_arithmetic.all; 

entity alu is 
     generic(prop_delay : Time := 5 ns);
     port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
          result: out dlx_word; error: out error_code); 
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
							error <= "0001" after 5 ns;
						end if;
					result <= result_var after 5 ns;
				--unsigned subtract
				when "0001" =>
					bv_subu(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							error <= "0010" after 5 ns;
						end if;
					result <= result_var after 5 ns;
				--2's comp add
				when "0010" =>
					bv_add(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if(operand1(31) = '0') AND (operand2(31) = '0') then
								if (result_var(31) = '1') then
								error <= "0001" after 5 ns;
								end if;
							end if;
							if (operand1(31) = '1') AND (operand2(31) = '1') then
								if (result_var(31) = '0') then
								error <= "0010" after 5 ns;
								end if;
							end if;
						end if;						
					result <= result_var after 5 ns;
				--2's comp subtract
				when "0011" =>
					bv_sub(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if(operand1(31) = '1') AND (operand2(31) = '0') then
								if (result_var(31) = '0') then
								error <= "0010" after 5 ns;
								end if;
							end if;
							if (operand1(31) = '0') AND (operand2(31) = '1') then
								if (result_var(31) = '1') then
								error <= "0001" after 5 ns;
								end if;
							end if;
						end if;		
				
					result <= result_var after 5 ns;
				--2's comp multiply
				when "0100" =>
					bv_mult(operand1, operand2, result_var, error_boolean);
						if error_boolean then
							if ((operand1(31) = '1') AND (operand2(31) = '0')) OR ((operand1(31) = '0') AND (operand2(31) = '1')) then
							error <= "0010" after 5 ns;
							else
							error <= "0001" after 5 ns;
							end if;
	
						end if;
					result <= result_var after 5 ns;
				--2's comp divide
				when "0101" =>
					bv_div(operand1, operand2, result_var, error_boolean, error_boolean1);
						if error_boolean then
							error <= "0011" after 5 ns;
						end if;
						if error_boolean1 then
							error <= "0010" after 5 ns;
						end if;

					
					result <= result_var after 5 ns;
				--logical AND
				when "0110" =>
					if operand1 > zero then
						if operand2 > zero then
							result <= result_true after 5 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 5 ns;
						end if;
					end if;
					if operand1 = zero then
						if operand2 > zero then
							result <= result_false after 5 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 5 ns;
						end if;
					end if;
					

				--bitwise AND
				when "0111" => 
					result <= operand1 AND operand2 after 5 ns;
				--logical OR
				when "1000" =>
					if operand1 > zero then
						if operand2 > zero then
							result <= result_true after 5 ns;
						end if;
						if operand2 = zero then
							result <= result_true after 5 ns;
						end if;
					end if;
					if operand1 = zero then
						if operand2 > zero then
							result <= result_true after 5 ns;
						end if;
						if operand2 = zero then
							result <= result_false after 5 ns;
						end if;
					end if;
				--bitwise OR
				when "1001" =>
					result <= operand1 OR operand2 after 5 ns;
				--logical NOT of operand1
				when "1010" =>
					if operand1 > zero then
						result <= result_false after 5 ns;
					end if;
					if operand1 = zero then
						result <= result_true after 5 ns;
					end if;
				--bitwise NOT of operand1
				when "1011" =>
					result <= NOT operand1 after 5 ns;
				--any other code (aka output 0s)
				when others =>
					result <= (others => '0') after 5 ns;
				end case;




	end process aluProcess;
end architecture behavior;
-- alu_operation_code values
-- 0000 unsigned add
-- 0001 signed add
-- 0010 2's compl add
-- 0011 2's compl sub
-- 0100 2's compl mul
-- 0101 2's compl divide
-- 0110 logical and
-- 0111 bitwise and
-- 1000 logical or
-- 1001 bitwise or
-- 1010 logical not (op1) 
-- 1011 bitwise not (op1)
-- 1100-1111 output all zeros

-- error code values
-- 0000 = no error
-- 0001 = overflow (too big positive) 
-- 0010 = underflow (too small neagative) 
-- 0011 = divide by zero 

-- entity dlx_register (lab 3)
use work.dlx_types.all; 

entity dlx_register is
     generic(prop_delay : Time := 5 ns);
     port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word);
end entity dlx_register;

architecture behavior of dlx_register is
begin
	dlxRegProcess : process(in_val, clock) is 
		begin
		if clock = '1' then
			out_val <= in_val after 5 ns;
		end if;

	end process dlxRegProcess;
end architecture behavior;

-- entity pcplusone
use work.dlx_types.all;
use work.bv_arithmetic.all; 

entity pcplusone is
	generic(prop_delay: Time := 5 ns); 
	port (input: in dlx_word; clock: in bit;  output: out dlx_word); 
end entity pcplusone; 

architecture behavior of pcplusone is 
begin
	plusone: process(input,clock) is  -- add clock input to make it execute
		variable newpc: dlx_word;
		variable error: boolean; 
	begin
	   if clock'event and clock = '1' then
	  	bv_addu(input,"00000000000000000000000000000001",newpc,error);
		output <= newpc after prop_delay; 
	  end if; 
	end process plusone; 
end architecture behavior; 


-- entity mux
use work.dlx_types.all; 

entity mux is
     generic(prop_delay : Time := 5 ns);
     port (input_1,input_0 : in dlx_word; which: in bit; output: out dlx_word);
end entity mux;

architecture behavior of mux is
begin
   muxProcess : process(input_1, input_0, which) is
   begin
      if (which = '1') then
         output <= input_1 after prop_delay;
      else
         output <= input_0 after prop_delay;
      end if;
   end process muxProcess;
end architecture behavior;
-- end entity mux

-- entity threeway_mux 
use work.dlx_types.all; 

entity threeway_mux is
     generic(prop_delay : Time := 5 ns);
     port (input_2,input_1,input_0 : in dlx_word; which: in threeway_muxcode; output: out dlx_word);
end entity threeway_mux;

architecture behavior of threeway_mux is
begin
   muxProcess : process(input_1, input_0, which) is
   begin
      if (which = "10" or which = "11" ) then
         output <= input_2 after prop_delay;
      elsif (which = "01") then 
	 output <= input_1 after prop_delay; 
       else
         output <= input_0 after prop_delay;
      end if;
   end process muxProcess;
end architecture behavior;
-- end entity mux

  
-- entity memory
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity memory is
  
  port (
    address : in dlx_word;
    readnotwrite: in bit; 
    data_out : out dlx_word;
    data_in: in dlx_word; 
    clock: in bit); 
end memory;

architecture behavior of memory is

begin  -- behavior

  mem_behav: process(address,clock) is
    -- note that there is storage only for the first 1k of the memory, to speed
    -- up the simulation
    type memtype is array (0 to 1024) of dlx_word;
    variable data_memory : memtype;
  begin
    -- fill this in by hand to put some values in there
    -- some instructions
    data_memory(0) :=  X"30200000"; --LD R4, 0x100
    data_memory(1) :=  X"00000100"; -- address 0x100 for previous instruction
    data_memory(2) :=  X"30080000"; -- LD for reg 1
    data_memory(3) :=  X"00000101";
    data_memory(4) :=  X"30100000"; -- LD for reg 2
    data_memory(5) :=  X"00000101"; -- Just going to add 1s, so using same address (101) w/ a 1 stored at it
    data_memory(6) :=  "00000000000110000100010000000000"; -- ADDU R3,R1,R2 (should give 2)
    -- some data
    -- note that this code runs every time an input signal to memory changes, 
    -- so for testing, write to some other locations besides these
    data_memory(256) := "01010101000000001111111100000000";
    data_memory(257) := "00000000000000000000000000000001";
    data_memory(258) := "00000000000000000000000000000001";


   
    if clock = '1' then
      if readnotwrite = '1' then
        -- do a read
        data_out <= data_memory(bv_to_natural(address)) after 5 ns;
      else
        -- do a write
        data_memory(bv_to_natural(address)) := data_in; 
      end if;
    end if;


  end process mem_behav; 

end behavior;
-- end entity memory


