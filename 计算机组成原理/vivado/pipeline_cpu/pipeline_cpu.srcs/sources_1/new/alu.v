`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 16:13:07
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// �����߼���Ԫ
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module ALU(
    input [31:0] num1,                  // ����ĵ�һ����
    input [31:0] num2,                  // ����ĵڶ�����
    input [4:0] select,                 // �����ѡ���źţ�����ѡ����������
    output reg [31:0] result,           // �����������
    output reg condition_flag,          // �����룬�ж������Ƿ����������Ϊ1
    output reg overflow_flag
    );

    // �������
    always@(*) begin
	    overflow_flag <= 0;
        case(select)
            `ALU_ADD: begin 
                result <= num1 + num2;
                condition_flag <= 1'b0;
		        overflow_flag <= (num1[31] == num2[31]) && (result[31] != num1[31]);
                end
            `ALU_SUB: begin 
                result <= num1 - num2;
                condition_flag <= 1'b0;
		        overflow_flag <= (num1[31] != num2[31]) && (result[31] != num1[31]);
                end
            `ALU_MUL: begin 
                result <= num1 * num2;
                condition_flag <= 1'b0;
                end
            `ALU_DIV: begin 
                result <= num1 / num2;
                condition_flag <= 1'b0;
                end
            `ALU_MOD: begin 
                result <= num1 % num2;
                condition_flag <= 1'b0;
                end
            `ALU_BIT_AND: begin
                result <= num1 & num2;
                condition_flag <= 1'b0;
                end
            `ALU_BIT_OR: begin
                result <= num1 | num2;
                condition_flag <= 1'b0;
                end
            `ALU_BIT_XOR: begin
                result <= num1 ^ num2;
                condition_flag <= 1'b0;
                end
             //��������alu����   
             `ALU_SLL: begin
                result <= num1 << num2[4:0];
                condition_flag <= 1'b0;
                end
            `ALU_SRL: begin
                result <= num1 >> num2[4:0];
                condition_flag <= 1'b0;
                end
             `ALU_SRA: begin
                result <= $signed(num1) >>> num2[4:0];
                condition_flag <= 1'b0;
                end
             `ALU_SLT: begin
                result <= ( $signed(num1) < $signed(num2));
                condition_flag <= 1'b0;
                end
            `ALU_SLTU: begin
                result <= (num1 < num2);
                condition_flag <= 1'b0;
                end
            `ALU_LT: begin
                result <= 32'h0;
                condition_flag <= $signed(num1) < $signed(num2);
                end
            `ALU_LTU: begin
                result <= 32'h0;
                condition_flag <= num1 < num2;
                end
            `ALU_GE: begin
                result <= 32'h0;
                condition_flag <= $signed(num1) >= $signed(num2);
            end
            `ALU_GEU: begin
                result <= 32'h0;
                condition_flag <= num1 >= num2 ;
            end
            `ALU_EQ: begin
                result <= 32'h0;
                condition_flag <= num1 == num2;
            end
            `ALU_NEQ: begin
                result <= 32'h0;
                condition_flag <= num1 != num2;
            end
            `ALU_JAL: begin
                result <= num1 + 32'h4;
                condition_flag <= 1'b1;
            end
            `ALU_LUI: begin
                result <= num2;
                condition_flag <= 1'b0;
            end
            `ALU_AUIPC: begin
                result <= num1 + num2;
                condition_flag <= 1'b0;
            end
            default: begin
                result <= 32'h0;
                condition_flag <= 1'b0;
            end
        endcase
    end

endmodule
