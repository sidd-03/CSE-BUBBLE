// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

module Instruction_Decode (instruction, R, I, J, op, rs, rt, rd, shamt, funct, imm, tar_add);
	input wire [31:0] instruction;

	output wire R, I, J;
	output wire [4:0] rs, rt, rd;
	output wire [5:0] op, funct;
	output wire [31:0] imm, tar_add, shamt;

	reg reg_R, reg_I, reg_J;
	reg [4:0] reg_rs, reg_rt, reg_rd;
	reg [5:0] reg_op, reg_funct;
	reg [31:0] reg_imm, reg_tar_add, reg_shamt;

	initial begin
		reg_R = 1'b0; reg_I = 1'b0; reg_J = 1'b0;
		reg_rs = 5'b0; reg_rt = 5'b0; reg_rd = 5'b0;
		reg_op = 6'b0; reg_funct = 6'b0;
		reg_imm = 32'b0; reg_tar_add = 32'b0; reg_shamt = 32'b0;
	end

	assign R = reg_R;
	assign I = reg_I;
	assign J = reg_J;
	assign rs = reg_rs;
	assign rt = reg_rt;
	assign rd = reg_rd;
	assign op = reg_op;
	assign funct = reg_funct;
	assign imm = reg_imm;
	assign tar_add = reg_tar_add;
	assign shamt = reg_shamt;

	
	always @(instruction) begin
		reg_op = instruction[31:26];
		
		if(reg_op == 6'b000000) begin // R type instruction
			reg_R = 1'b1;
			reg_I = 1'b0;
			reg_J = 1'b0;
		end  
		else if(reg_op == 6'b000001 || reg_op == 6'b000010) begin // J type instruction
			reg_R = 1'b0;
			reg_I = 1'b0;
			reg_J = 1'b1;
		end
		else begin // I type instruction
			reg_R = 1'b0;
			reg_I = 1'b1;
			reg_J = 1'b0;
		end
		
		reg_rs = instruction[25:21];
		reg_rt = instruction[20:16];
		reg_rd = instruction[15:11];

		reg_shamt[4:0] = instruction[10:6];
		reg_shamt[31:5] = 17'b0;

		reg_funct = instruction[5:0];

		reg_tar_add[25:0] = instruction[25:0];
		reg_tar_add[31:26] = 6'b0;
		
		reg_imm[15:0] = instruction[15:0];
		// immediate field extension to 32 bits
		if(reg_op != 6'b000110 && reg_op != 6'b000101) begin    // if op is other than ANDI and ORI
			reg_imm[31:16] = {16{instruction[15]}};  // sign extension
		end
		
	end
	
endmodule