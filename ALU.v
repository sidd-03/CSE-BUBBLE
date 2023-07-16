// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

module ALU(ctrl, op1, op2, result, overflow);
	
	input wire [3:0] ctrl;
	input wire [31:0] op1, op2;
	output reg [31:0] result;
	output reg overflow;
	
	wire signed [31:0] signed_op1, signed_op2;
	reg signed [31:0] signed_result;
	
	assign signed_op1 = op1;
	assign signed_op2 = op2;
	
	always @(ctrl, op1, op2)
	begin
		overflow = 0;
		case(ctrl)
			0: 	begin	// ADD
					result = signed_op1 + signed_op2;
					signed_result = signed_op1 + signed_op2;
					if(signed_op1 >= 0 && signed_op2 >= 0 && signed_result < 0) overflow = 1;
					if(signed_op1 < 0 && signed_op2 < 0 && signed_result >= 0) overflow = 1;				
				end
			1:  begin	// SUB
					result = signed_op1 - signed_op2;
					signed_result = signed_op1 - signed_op2;
					if(signed_op1 >= 0 && signed_op2 < 0 && signed_result < 0) overflow = 1;
					if(signed_op1 < 0 && signed_op2 >= 0 && signed_result >= 0) overflow = 1;						
				end  						
			2: 	result = op1 + op2;		// ADDU
			3:	result = op1 - op2;		// SUBU
			4: 	result = op1 & op2;		// AND
			5: 	result = op1 | op2;		// OR
			6: 	result = op1 << op2;	// SLL 
			7: 	result = op1 >> op2;	// SRL
			8: 	result = (signed_op1 < signed_op2) ? 1 : 0;	// SLT
			default: result = 0;
		endcase
	end
	
endmodule