// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "Instruction_Fetch.v"
`include "Instruction_Decode.v"
`include "Instruction_Execute.v"
`include "VEDA_MIPS.v"

`timescale 1ns/1ps
module final_test_bench();
    reg clk;
    reg [31:0] PC;
    wire [31:0] Instruction;
	wire R, I, J;
	wire [4:0] rs, rt, rd;
	wire [5:0] op, funct;
	wire [31:0] imm, tar_add, shamt;

    wire rst, mode1, mode2;
	wire [31:0] data_in1, data_in2;
	wire [31:0] address1, address2;
	wire [31:0] data_out1, data_out2;

    reg [1023:0] in_reg;
    wire [1023:0] out_reg;
    wire signed [31:0] out_reg_wire [0:31];
    
    genvar i;
    generate
        for (i=0;i<32;i=i+1) begin
            assign out_reg_wire[i] = out_reg[32*i +: 32];
        end
    endgenerate

    assign rst = 1'b0;

    initial begin
        clk = 0;
        PC = 0;
        in_reg[1023:0] = 1024'b0;
    end

    always #1 clk = ~clk;

    always @(negedge clk) PC = out_reg[63:32];
    always @(PC) in_reg = out_reg;

    always @(in_reg) begin
        // if $v0 contains 1
        if(in_reg[32*2 +: 32] == 1) begin
            $display("\nSorted Array:\n");
        end
        // if $v0 contains 3 => EXIT
        else if(in_reg[32*2 +: 32] == 3) begin
            $finish;
        end
    end

    // displaying sorted result
    // continue display till $v0 contains 2
    // sorted elememts are loaded into $20 one-by-one and printed
    always @(out_reg_wire[20]) begin
        if(out_reg_wire[2] == 2) $display("%d", out_reg_wire[20]);
    end

    // Instantiating all the required modules
    Instruction_Fetch IF (.PC(PC), .VEDA_data_out1(data_out1), .VEDA_mode1(mode1), .VEDA_address1(address1), .VEDA_data_in1(data_in1), .Instruction(Instruction));
    Instruction_Decode ID (.instruction(Instruction), .R(R), .I(I), .J(J), .op(op), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .imm(imm), .tar_add(tar_add));
    Instruction_Execute IE (.clk(clk), .Instruction(Instruction), .in_reg(in_reg), .out_reg(out_reg), .VEDA_mode2(mode2), .VEDA_data_in2(data_in2), .VEDA_data_out2(data_out2), .VEDA_add2(address2), .op(op), .funct(funct), .imm(imm), .tar_add(tar_add), .shamt(shamt), .rs(rs), .rt(rt), .rd(rd));
    VEDA_MIPS M (.clk(clk), .rst(rst), .mode1(mode1), .mode2(mode2), .data_in1(data_in1), .data_in2(data_in2), .address1(address1), .address2(address2), .data_out1(data_out1), .data_out2(data_out2));

endmodule