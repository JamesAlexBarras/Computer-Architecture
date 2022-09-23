
use work.bv_arithmetic.all; 
use work.dlx_types.all; 

entity aubie_controller is
	port(ir_control: in dlx_word;
	     alu_out: in dlx_word; 
	     alu_error: in error_code; 
	     clock: in bit; 
	     regfilein_mux: out threeway_muxcode; 
	     memaddr_mux: out threeway_muxcode; 
	     addr_mux: out bit; 
	     pc_mux: out bit; 
	     alu_func: out alu_operation_code; 
	     regfile_index: out register_index;
	     regfile_readnotwrite: out bit; 
	     regfile_clk: out bit;   
	     mem_clk: out bit;
	     mem_readnotwrite: out bit;  
	     ir_clk: out bit; 
	     imm_clk: out bit; 
	     addr_clk: out bit;  
             pc_clk: out bit; 
	     op1_clk: out bit; 
	     op2_clk: out bit; 
	     result_clk: out bit
	     ); 
end aubie_controller; 

architecture behavior of aubie_controller is
begin
	behav: process(clock) is 
		type state_type is range 1 to 20; 
		variable state: state_type := 1; 
		variable opcode: byte; 
		variable destination,operand1,operand2 : register_index; 

	begin
		if clock'event and clock = '1' then
		   opcode := ir_control(31 downto 24);
		   destination := ir_control(23 downto 19);
		   operand1 := ir_control(18 downto 14);
		   operand2 := ir_control(13 downto 9); 
		   case state is
			when 1 => -- fetch the instruction, for all types
				-- your code goes here
				mem_clk <= '1' after 5 ns;
				ir_clk <= '1' after 5 ns;
				memaddr_mux <= "00" after 5 ns;
     				mem_readnotwrite <= '1' after 5 ns;
				--addr_mux <= '1' after 5 ns;

				state := 2; 
			when 2 =>  
				
				-- figure out which instruction
			 	if opcode(7 downto 4) = "0000" then -- ALU op
					state := 3; 
				elsif opcode = X"20" then  -- STO 
					state := 9;
				elsif opcode = X"30" or opcode = X"31" then -- LD or LDI
					state := 7;
				elsif opcode = X"22" then -- STOR
					state := 14;
				elsif opcode = X"32" then -- LDR
					state := 12;
				elsif opcode = X"40" or opcode = X"41" then -- JMP or JZ
					state := 16;
				elsif opcode = X"10" then -- NOOP
					state := 19;
				else -- error
					--alu_error <= "0001" after 5 ns;
					-- do nothing? can't assign value to an input
				end if; 
			when 3 => 
				-- ALU op:  load op1 register from the regfile
				-- your code here 
				regfile_index <= operand1 after 5 ns;
				op1_clk <= '1' after 5 ns;
				regfile_clk <= '1' after 5 ns;
				regfile_readnotwrite <= '1' after 5 ns;
	    			--_index <= operand1 after 5 ns;
				--op1_clk <= '1' after 5 ns;
				

				state := 4; 
			when 4 => 
				-- ALU op: load op2 registear from the regfile 
				-- your code here
				regfile_index <= operand2 after 5 ns;
				op2_clk <= '1' after 5 ns;
				regfile_clk <= '1' after 5 ns;
				regfile_readnotwrite <= '1' after 5 ns;
	    			--regfile_index <= operand2 after 5 ns;
				--op2_clk <= '1' after 5 ns;			

         			state := 5; 
			when 5 => 
				-- ALU op:  perform ALU operation
				-- your code here
				alu_func <= opcode(3 downto 0) after 5 ns; 
				result_clk <= '1' after 5 ns;

            			state := 6; 
			when 6 => 
				-- ALU op: write back ALU operation
				-- your code here
				regfile_readnotwrite <= '0' after 5 ns;
				regfile_index <= destination after 5 ns;
	    			regfilein_mux <= "00" after 5 ns;
				regfile_clk <= '1' after 5 ns;
				--regfile_readnotwrite <= 1 after 5 ns; 

				pc_mux <= '0' after 5 ns;
				pc_clk <= '1' after 5 ns;
            			state := 1; 
			when 7 => 
				-- LD or LDI: get the addr or immediate word
			   -- your code here 
				pc_mux <= '0' after 5 ns;
				pc_clk <= '1' after 5 ns;
				if opcode = X"30" then --LD op
					memaddr_mux <= "00" after 5 ns;
					mem_clk <= '1' after 5 ns;
					mem_readnotwrite <= '1' after 5 ns;
					addr_mux <= '1' after 5 ns;
					addr_clk <= '1' after 5 ns;
				end if;
				if opcode = X"31" then --LDI op
					memaddr_mux <= "00" after 5 ns;
					mem_clk <= '1' after 5 ns;
					mem_readnotwrite <= '1' after 5 ns;
					imm_clk <= '1' after 5 ns;
				end if;

				state := 8; 
			when 8 => 
				-- LD or LDI
				-- your code here
				if opcode = X"30" then --LD op
					memaddr_mux <= "01" after 5 ns;
					mem_clk <= '1' after 5 ns;
					regfilein_mux <= "01" after 5 ns;
					regfile_readnotwrite <= '0' after 5 ns;
					regfile_clk <= '1' after 5 ns;
					regfile_index <= destination after 5 ns;
				
				end if;
				if opcode = X"31" then --LDI op
					regfilein_mux <= "10" after 5 ns;
					regfile_readnotwrite <= '0' after 5 ns;
					regfile_clk <= '1' after 5 ns;
					regfile_index <= destination after 5 ns;
					
				end if;				

				pc_mux <= '0' after 5 ns;
				pc_clk <= '1' after 5 ns;
        			state := 1; 
			when 9 =>
				-- STO (optional)
				state := 10;
			when 10 =>
				--STO (optional)
				state := 11;
			when 11 =>
				--STO (optional)
				state := 1;
			when 12 =>
				-- LDR (optional)
				state := 13;
			when 13 =>
				--LDR (optional)
				state := 1;
			when 14 =>
			when 15 =>
			when 16 =>
			when 17 => 
			when 18 =>
			when 19 =>
				--NOOP
				pc_mux <= '0' after 5 ns;
				pc_clk <= '1' after 5 ns;
				state := 1;
			when others => null;
		   end case; 
		elsif clock'event and clock = '0' then
			-- reset all the register clocks
			regfile_clk <= '0' after 5 ns; 
	     		mem_clk <= '0' after 5 ns;
	     		ir_clk <= '0' after 5 ns;
	     		imm_clk <= '0' after 5 ns;
	     		addr_clk <= '0' after 5 ns;  
             		pc_clk <= '0' after 5 ns;
			op1_clk <= '0' after 5 ns;
	     		op2_clk <= '0' after 5 ns;
	     		result_clk <= '0' after 5 ns;
		   -- your code here				
		end if; 
	end process behav;
end behavior;	