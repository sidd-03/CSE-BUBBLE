// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "Instruction_Decode.v"

`timescale 1ns/1ps
module tb_Instruction_Decode();
	
	reg [31:0] instruction;
	wire R, I, J;
	wire [4:0] rs, rt, rd;
	wire [31:0] shamt;
	wire [5:0] op, funct;
	wire [31:0] imm, tar_add;
	
	Instruction_Decode DUT (.instruction(instruction), .R(R), .I(I), .J(J), .op(op), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .imm(imm), .tar_add(tar_add));
	
	initial begin
		$monitor($time, "\ninstruction = %b\nR = %b I = %b J = %b\nop = %d rs = %d rt = %d rd = %d shamt = %d funct = %d\nimm = %d tar_add = %d\n", instruction, R, I, J, op, rs, rt, rd, shamt, funct, imm, tar_add);
		
		#5 instruction = 32'b000011_01001_00000_0000000000100100;
		#5 instruction = 32'b000000_00000_00110_00100_01100_000001;
		#5 instruction = 32'b000000_00000_00111_00010_00110_000010;
		#5 instruction = 32'b000001_00000000000000000000000100;
		#5 instruction = 32'b000010_00000000000000000000010101;
		#5 instruction = 32'b000011_00101_01110_0000000000001110;
		#5 instruction = 32'b000100_00111_01011_0000000000101010;
		#5 instruction = 32'b000101_01011_01010_0000000000111111;
		
		#5 $finish;
		
	end
	
endmodule
