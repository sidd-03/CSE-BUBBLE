// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "Branch_Unit.v"

`timescale 1ns/1ps
module tb_Branch_Unit();
	reg [2:0] ctrl;
	reg [31:0] curr_PC, curr_RA, imm;
	reg signed [31:0] op1, op2;
	wire [31:0] next_PC, next_RA;
	
	Branch_Unit DUT(.ctrl(ctrl), .curr_PC(curr_PC), .curr_RA(curr_RA), .op1(op1), .op2(op2), .imm(imm), .next_PC(next_PC), .next_RA(next_RA));
	
	initial begin
		$monitor($time, " ctrl = %d op1 = %d op2 = %d imm = %d curr_PC = %d next_PC = %d curr_RA = %d next_RA = %d\n", ctrl, op1, op2, imm, curr_PC, next_PC, curr_RA, next_RA);
		
		#1 ctrl <= 0; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // beq(false)
		#1 ctrl <= 0; op1 <= 45; op2 = 45; curr_PC = 4; curr_RA = 12; imm <= 20; // beq(true)
	
		#1 ctrl <= 1; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bne(true)
		#1 ctrl <= 1; op1 <= 36; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bne(false)
		
		#1 ctrl <= 2; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bgt(true)
		#1 ctrl <= 2; op1 <= 24; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bgt(false)
		
		#1 ctrl <= 3; op1 <= 36; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bgte(true)
		#1 ctrl <= 3; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bgte(true)
		
		#1 ctrl <= 4; op1 <= 14; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // ble(true)
		#1 ctrl <= 4; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // ble(false)
		
		#1 ctrl <= 5; op1 <= 36; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bleq(true)
		#1 ctrl <= 5; op1 <= 18; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // bleq(true)
		
		#1 ctrl <= 6; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // j
		#1 ctrl <= 7; op1 <= 45; op2 = 36; curr_PC = 4; curr_RA = 12; imm <= 20; // jal
		
		#1 $finish;
		
	end	
	
endmodule
