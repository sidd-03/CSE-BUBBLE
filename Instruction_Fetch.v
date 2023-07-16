// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

module Instruction_Fetch (PC, VEDA_data_out1, VEDA_mode1, VEDA_address1, VEDA_data_in1, Instruction);
	input wire [31:0] PC, VEDA_data_out1;
	output wire VEDA_mode1;
	output wire [31:0] VEDA_address1, VEDA_data_in1, Instruction;
	
	assign Instruction = VEDA_data_out1;
	assign VEDA_address1 = PC;
	assign VEDA_data_in1 = 1'b0;
	assign VEDA_mode1 = 1'b1;		// read mode

endmodule