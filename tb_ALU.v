// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "ALU.v"

`timescale 1ns/1ps
module tb_ALU();
	reg [3:0] ctrl;
	reg signed [31:0] op1, op2;
	wire signed [31:0] result;
	wire overflow;
	
	ALU DUT(.ctrl(ctrl), .op1(op1), .op2(op2), .result(result), .overflow(overflow));
	
	initial begin
		$monitor($time, " ctrl = %d\top1 = %d\top2 = %d\tresult = %d\toverflow = %b\n", ctrl, op1, op2, result, overflow);	
		
		#1 ctrl <= 0; op1 <= 2147483647; op2 <= 2147483647;		// result = -2 overflow = 1
		#1 ctrl <= 1; op1 <= 234; op2 <= 3;          // result = 234 - 3 = 231
		#1 ctrl <= 4;                                // result = 234 & 3 = 2
		#1 ctrl <= 5;                                // result = 234 | 3 = 235
		#1 ctrl <= 6;                                // result = 234 << 3 = 1872
		#1 ctrl <= 7;                                // result = 234 >> 3 = 29
		#1 ctrl <= 8; op1 <= 45; op2 <= 42;          // result = 0 (45 > 42)
		#1 op1 <= 25;                                // result = 1 (25 < 42)
		#1 op1 <= -1;                                // result = 1 (-1 < 42)
		#1 op1 <= -7; op2 <= -16;                    // result = 0 (-7 > -16)
	
		#1 $finish;
	end
	
endmodule
