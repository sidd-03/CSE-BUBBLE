// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

module Branch_Unit(ctrl, curr_PC, op1, op2, next_PC, curr_RA, next_RA, imm);
	input wire [2:0] ctrl;
	input wire [31:0] curr_PC, curr_RA, imm;
	input wire signed [31:0] op1, op2;
	output reg [31:0] next_PC, next_RA;
	
	
	always @(ctrl, op1, op2, imm, curr_PC) begin
		case(ctrl)
			0:	begin	// beq
					if(op1 == op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			1:  begin	// bne
					if(op1 != op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			2:  begin	// bgt
					if(op1 > op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			3:  begin	// bgte
					if(op1 >= op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			4:  begin	// ble
					if(op1 < op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			5:  begin	// bleq
					if(op1 <= op2) next_PC = curr_PC + imm;
					else next_PC = curr_PC + 1;
					next_RA = curr_RA;
				end
			6:	begin	// j or jr
					next_PC = imm;
					next_RA = curr_RA;
				end
			7:	begin	// jal
					next_RA = curr_PC + 1;
					next_PC = imm;	
				end
		endcase
	end
	
endmodule
