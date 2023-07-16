// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

module VEDA_MIPS (clk, rst, mode1, mode2, data_in1, data_in2, address1, address2, data_out1, data_out2);
	// 1: ins_mem(Instruction Memory)
	// 2: data_mem(Data Memory)
	input wire clk, rst, mode1, mode2;
	input wire [31:0] data_in1, data_in2;
	input wire [31:0] address1, address2;
	output wire [31:0] data_out1, data_out2;
	
	reg [31:0] temp_data_out1, temp_data_out2;

	reg [31:0] ins_mem [0:1048575];  // instruction memory : 2^20 words
	reg [31:0] data_mem[0:1048575];  // data memory : 2^20 words
	
	initial begin
		ins_mem[0] = 32'b001000_10011_00000_0000000001100100;       // lw $s0, $0, 100
		ins_mem[1] = 32'b000011_10011_10011_1111111111111111;       // addi $s0, $s0, -1
		ins_mem[2] = 32'b000011_01001_00000_0000000000000000;       // addi $t0,$zero, 0
		ins_mem[3] = 32'b000011_01010_00000_0000000000000000;       // addi $t1,$zero, 0
		ins_mem[4] = 32'b000011_01100_01010_0000000000000000;       // addi $t3, $t1, 0
		ins_mem[5] = 32'b001000_01011_01100_0000000000000000;       // lw $t2, $t3, 0
		ins_mem[6] = 32'b000011_01100_01100_0000000000000001;       // addi $t3, $t3, 1
		ins_mem[7] = 32'b001000_01101_01100_0000000000000000;       // lw $t4, $t3, 0
		ins_mem[8] = 32'b000000_01110_01011_01101_00000_001000;     // slt $t5, $t2, $t4
        ins_mem[9] = 32'b001011_01110_00000_0000000000000100;      // bne $t5, $0, 4
        ins_mem[10] = 32'b001001_01011_01100_0000000000000000;      // sw $t2, $t3, 0
        ins_mem[11] = 32'b000011_01100_01100_1111111111111111;      // addi $t3, $t3, -1
        ins_mem[12] = 32'b001001_01101_01100_0000000000000000;      // sw $t4, $t3, 0
        ins_mem[13] = 32'b000011_01010_01010_0000000000000001;      // addi $t1, $t1, 1
        ins_mem[14] = 32'b000000_11000_10011_01001_00000_000001;    // sub $s5, $s0, $t0
        ins_mem[15] = 32'b001011_01010_11000_1111111111110101;      // bne $t1, $s5, -11
        ins_mem[16] = 32'b000011_01001_01001_0000000000000001;      // addi $t0, $t0, 1
        ins_mem[17] = 32'b000011_01010_00000_0000000000000000;      // addi $t1,$0, 0
        ins_mem[18] = 32'b001011_01001_10011_1111111111110010;      // bne $t0, $s0, -14
        ins_mem[19] = 32'b000011_00010_00000_0000000000000001;      // addi $v0, $zero, 1
        ins_mem[20] = 32'b000011_00010_00000_0000000000000010;      // addi $v0, $zero, 2
        ins_mem[21] = 32'b000011_01001_00000_1111111111111111;      // addi $t0, $zero, -1
        ins_mem[22] = 32'b000011_01001_01001_0000000000000001;      // addi $t0, $t0, 1
        ins_mem[23] = 32'b001000_10100_01001_0000000000000000;      // lw $s1, $t0, 0
        ins_mem[24] = 32'b001011_01001_10011_1111111111111110;      // bne $t0, $s0, -2
        ins_mem[25] = 32'b000011_00010_00000_0000000000000011;      // addi $v0, $zero, 3
	end

	initial begin
		data_mem[100] = 10;		// value of N

		// stroring array elements into data_mem[0...N-1]
		data_mem[0] = 11;
		data_mem[1] = -29;
		data_mem[2] = 326;
		data_mem[3] = 31;
		data_mem[4] = -41;
        data_mem[5] = -48;
        data_mem[6] = 17;
        data_mem[7] = 59;
        data_mem[8] = 58;
        data_mem[9] = 15;

	end
	
	assign data_out1 = temp_data_out1;
	assign data_out2 = temp_data_out2;

	always @(rst, mode1, mode2, data_in1, data_in2, address1, address2) begin
		if(rst == 1) begin
			ins_mem[address1] = 0;
			data_mem[address2] = 0;
			temp_data_out1 = 0;
			temp_data_out2 = 0;
		end
		else begin
			if(mode1 == 0) ins_mem[address1] = data_in1;	// write ins_mem
			if(mode2 == 0) data_mem[address2] = data_in2;	// write data_mem
			temp_data_out1 = ins_mem[address1];
			temp_data_out2 = data_mem[address2];
		end
	end

endmodule