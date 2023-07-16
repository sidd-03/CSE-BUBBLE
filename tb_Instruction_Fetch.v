// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "Instruction_Fetch.v"
`include "VEDA_MIPS.v"

`timescale 1ns/1ps
module tb_Instruction_Fetch();
	reg clk;
	reg [31:0] PC;
	wire [31:0] Instruction;
	wire [31:0] address1, data_in1;
	wire mode1;
	wire [31:0] data_out1, data_out2;
	
	Instruction_Fetch IF (.PC(PC), .VEDA_data_out1(data_out1), .VEDA_mode1(mode1), .VEDA_address1(address1), .VEDA_data_in1(data_in1), .Instruction(Instruction));
	VEDA_MIPS M (.clk(clk), .rst(1'b0), .mode1(mode1), .mode2(1'b1), .data_in1(data_in1), .data_in2(32'b0), .address1(address1), .address2(32'b0), .data_out1(data_out1), .data_out2(data_out2));

	initial begin
		clk = 0;
		PC = 0;
	end
	
	always #1 clk = ~clk;

	initial begin
		$monitor($time, " PC = %d\nInstruction = %b\n\n", PC, Instruction);
		
		PC <= #1 1;
		PC <= #2 2;
		PC <= #3 3;
		PC <= #4 4;
	end
	
	initial #4 $finish;
	
endmodule
