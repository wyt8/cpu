`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 20:38:31
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [31:0] num1,  // 输入的第一个数
    input [31:0] num2,  // 输入的第二个数
    input [3:0] select, // 输入的选择信号，用于选择运算类型，0-add，1-sub
    output reg [31:0] res,  // 输出的运算结果
    output reg sf,          // 输出的符号标志位
    output reg cf,          // 输出的进位标志位
    output reg zf,          // 输出的零标志位
    output reg of,          // 输出的溢出标志位
    output reg pf           // 输出的奇偶标志位
);
    // 双符号位
    wire [32:0] double_sign_num1 = {num1[31], num1};
    wire [32:0] double_sign_num2 = {num2[31], num2};
    reg [32:0] double_sign_res;
    // 计算过程
    always@(*)
    begin
    case(select)
        4'b0000: begin 
            double_sign_res = double_sign_num1 + double_sign_num2;
            res = double_sign_res[31:0];
            cf = res < num1 || res < num2;
            of = double_sign_res[32] ^ double_sign_res[31];
            end
        4'b0001: begin 
            double_sign_res = double_sign_num1 - double_sign_num2;
            res = double_sign_res[31:0];
            cf = res > num1;
            of = double_sign_res[32] ^ double_sign_res[31];
            end
        4'b0010: begin
            res =  num1 & num2;
            cf = 0;
            of = 0;
            end
        4'b0011: begin
            res = num1 | num2;
            cf = 0;
            of = 0;
            end
        4'b0100: begin
            res = num1 ^ num2;
            cf = 0;
            of = 0;
            end
        4'b0101: begin
            res = ~(num1 | num2);
            cf = 0;
            of = 0; 
            end
        4'b0110: begin
            res = num1 << num2;
            cf = 0;
            of = 0;
            end
        4'b0111: begin
            res = num1 >> num2;
            cf = 0;
            of = 0;
            end
    endcase
    // 通用符号位计算
    zf = res == 0;
    sf = res[31];
    pf = ~^res;
    end
endmodule
