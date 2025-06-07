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
    input [31:0] num1,  // ����ĵ�һ����
    input [31:0] num2,  // ����ĵڶ�����
    input [3:0] select, // �����ѡ���źţ�����ѡ���������ͣ�0-add��1-sub
    output reg [31:0] res,  // �����������
    output reg sf,          // ����ķ��ű�־λ
    output reg cf,          // ����Ľ�λ��־λ
    output reg zf,          // ��������־λ
    output reg of,          // ����������־λ
    output reg pf           // �������ż��־λ
);
    // ˫����λ
    wire [32:0] double_sign_num1 = {num1[31], num1};
    wire [32:0] double_sign_num2 = {num2[31], num2};
    reg [32:0] double_sign_res;
    // �������
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
    // ͨ�÷���λ����
    zf = res == 0;
    sf = res[31];
    pf = ~^res;
    end
endmodule
