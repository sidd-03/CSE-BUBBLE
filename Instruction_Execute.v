// Aditya Pratap Singh - 200053
// Siddheshwari Ramesh Madavi - 211036

`include "ALU.v"
`include "Branch_Unit.v"

module Instruction_Execute(clk, Instruction, in_reg, out_reg, VEDA_mode2, VEDA_data_in2, VEDA_data_out2, VEDA_add2, op, funct, imm, tar_add, shamt, rs, rt, rd);
    input wire clk;
    input wire [31:0] Instruction;
    input wire [1023:0] in_reg;
	input wire [5:0] op, funct;
	input wire [31:0] imm, tar_add, shamt;
    input wire [31:0] VEDA_data_out2;
    input wire [4:0] rs, rt, rd;

    output reg VEDA_mode2;
    output reg [31:0] VEDA_data_in2, VEDA_add2;
    output wire [1023:0] out_reg;

    reg [31:0] util_reg [0:31];
    reg [31:0] PC;
    always @(in_reg) PC = in_reg[63:32];

    // ALU ports
    reg [3:0] ALU_ctrl;
    reg [31:0] ALU_op1, ALU_op2;
    wire [31:0] ALU_result;
    wire ALU_overflow;

    // Branch Unit ports
    reg [2:0] BU_ctrl;
	reg [31:0] BU_curr_PC, BU_curr_RA, BU_imm;
	reg signed [31:0] BU_op1, BU_op2;
	wire [31:0] BU_next_PC, BU_next_RA;

    // Instantiating ALU(A1) and Branch Unit(B1)
    ALU A1 (.ctrl(ALU_ctrl), .op1(ALU_op1), .op2(ALU_op2), .result(ALU_result), .overflow(ALU_overflow));
    Branch_Unit B1 (.ctrl(BU_ctrl), .curr_PC(BU_curr_PC), .op1(BU_op1), .op2(BU_op2), .next_PC(BU_next_PC), .curr_RA(BU_curr_RA), .next_RA(BU_next_RA), .imm(BU_imm));

    initial begin
        VEDA_mode2 = 1;    // read mode
        VEDA_data_in2 = 0; 
        VEDA_add2 = 0;
    end

    initial begin
        ALU_ctrl = 0;
        BU_ctrl = 0;
        ALU_op1 = 0;
        ALU_op2 = 0;
        BU_curr_PC = 0;
        BU_curr_RA = 0;
        BU_op1 = 0;
        BU_op2 = 0;
    end

    integer k;
    initial begin
        for(k=0;k<32;k=k+1) begin
            util_reg[k] = 32'b0;
        end
    end

    genvar j;
    generate
        for(j=0;j<32;j=j+1) begin
            assign out_reg[32*j +: 32] = util_reg[j];
        end
    endgenerate

    integer i;
    always @(PC) begin
        for(i=0;i<32;i=i+1) begin
            util_reg[i] = in_reg[32*i +: 32];
        end

        // ALU
        if(op <= 7 && !(op == 0 && funct == 7) && !(op == 1 || op == 2)) begin
            if(op == 0 && funct <= 8 && !(funct == 6 || funct == 7)) begin
                ALU_ctrl = funct;
                ALU_op1 = util_reg[rt];
                ALU_op2 = util_reg[rd];
            end
            else if(op == 0 && (funct == 6 || funct == 7)) begin
                ALU_ctrl = funct;
                ALU_op1 = util_reg[rt];
                ALU_op2 = shamt;
            end
            else if(op == 3) begin
                ALU_ctrl = 0;
                ALU_op1 = util_reg[rt];
                ALU_op2 = imm;
            end
            else if(op == 4) begin
                ALU_ctrl = 2;
                ALU_op1 = util_reg[rt];
                ALU_op2 = imm;
            end
            else if(op == 5 || op == 6) begin
                ALU_ctrl = op - 1;
                ALU_op1 = util_reg[rt];
                ALU_op2 = imm;
            end
            else if(op == 7) begin
                ALU_ctrl = 8;
                ALU_op1 = util_reg[rt];
                ALU_op2 = imm;
            end
        end

        // Data transfer Unit
        else if(op == 8 || op == 9) begin
            if(op == 8) begin        // lw
                VEDA_add2 = util_reg[rt] + imm;
                VEDA_mode2 = 1;     // read
            end
            else begin         // sw
                VEDA_add2 = util_reg[rt] + imm;
                VEDA_mode2 = 0;     // write
                VEDA_data_in2 = util_reg[rs];
            end
        end

        // Branch Unit
        else begin
            // Conditional Branch
            if(op >= 10 && op <=15) begin
                BU_ctrl = op - 10;
                BU_op1 = util_reg[rs];
                BU_op2 = util_reg[rt];
                BU_imm = imm;
                BU_curr_PC = util_reg[1];
                BU_curr_RA = util_reg[31];
            end
            // Unconditional Branch
            else if(op >= 0 && op <= 2) begin
                if(op <= 1) BU_ctrl = 6;  // j or jr
                else BU_ctrl = 7;         // jal
                BU_imm = imm;
                BU_curr_PC = util_reg[1];
                BU_curr_RA = util_reg[31];
            end
            
        end
    end

    always @(posedge clk) begin
        // ALU
        if(op <= 7 && !(op == 0 && funct == 7) && !(op == 1 || op == 2)) begin
            util_reg[rs] = ALU_result;
            util_reg[1] = util_reg[1] + 1;  // increment PC
        end
        // LW
        else if(op == 8) begin
            util_reg[rs] = VEDA_data_out2;
            util_reg[1] = util_reg[1] + 1;  // increment PC
        end
        else if(op == 9) begin
            util_reg[1] = util_reg[1] + 1;  // increment PC
        end
        // Branch
        else if((op >= 10 && op <=15) || (op >= 0 && op <= 2)) begin
            util_reg[1] = BU_next_PC;
            util_reg[31] = BU_next_RA;
        end
    end

    always @(util_reg[1]) util_reg[30] = Instruction;

endmodule