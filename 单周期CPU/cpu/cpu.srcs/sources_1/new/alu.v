`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 15:52:38
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
    input clk,
    input rst,
    input [31:0] num1,      // 输入的第一个数
    input [31:0] num2,      // 输入的第二个数
    input [3:0] select,     // 输入的选择信号，用于选择运算类型
    output [31:0] res,      // 输出的运算结果
    output flag             // 根据输入的选择信号，判断条件是否成立
);
    // 双符号位
    // wire [32:0] double_sign_num1 = {num1[31], num1};
    // wire [32:0] double_sign_num2 = {num2[31], num2};
    // reg [32:0] double_sign_res;
    // reg cf_reg, of_reg;
    reg [31:0] res_reg;
    reg flag_reg;
    // 计算过程
    always@(posedge clk or negedge rst) begin
        if (!rst) begin
            res_reg = 32'b0;
            flag_reg = 1'b0;
        end
        else begin  // 没有复位时进行的操作
            case(select)
                4'b0000: begin 
                    // double_sign_res = double_sign_num1 + double_sign_num2;
                    // cf_reg = double_sign_res[31:0] < num1 || double_sign_res[31:0] < num2;
                    // of_reg = double_sign_res[32] ^ double_sign_res[31];
                    res_reg = num1 + num2;
                    flag_reg = 1'b0;
                    end
                4'b0001: begin 
                    // double_sign_res = double_sign_num1 - double_sign_num2;
                    // cf_reg = double_sign_res[31:0] > num1;
                    // of_reg = double_sign_res[32] ^ double_sign_res[31];
                    res_reg = num1 - num2;
                    flag_reg = 1'b0;
                    end
                4'b0010: begin
                    // double_sign_res[31:0] =  num1 & num2;
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = num1 & num2;
                    flag_reg = 1'b0;
                    end
                4'b0011: begin
                    // double_sign_res[31:0] = num1 | num2;
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = num1 | num2;
                    flag_reg = 1'b0;
                    end
                4'b0100: begin
                    // double_sign_res[31:0] = num1 ^ num2;
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = num1 ^ num2;
                    flag_reg = 1'b0;
                    end
                4'b0101: begin
                    // double_sign_res[31:0] = ~(num1 | num2);
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = ~(num1 | num2);
                    flag_reg = 1'b0; 
                    end
                4'b0110: begin
                    // double_sign_res[31:0] = num1 << num2;
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = num1 << num2;
                    flag_reg = 1'b0;
                    end
                4'b0111: begin
                    // double_sign_res[31:0] = num1 >> num2;
                    // cf_reg = 0;
                    // of_reg = 0;
                    res_reg = num1 >> num2;
                    flag_reg = 1'b0;
                    end
                4'b1000: begin
//                    res_reg = 32'b0;
                    flag_reg = num1 < num2;
                    end
                4'b1001: begin
//                    res_reg = 32'b0;
                    flag_reg = num1 >= num2;
                end
                4'b1010: begin
//                    res_reg = 32'b0;
                    flag_reg = num1 == num2;
                end
                4'b1011: begin
//                    res_reg = 32'b0;
                    flag_reg = num1 != num2;
                end
                4'b1111: begin
//                    res_reg = 32'b0;
                    flag_reg = 1'b1;
                end
            endcase
        end
    end

    // assign res = double_sign_res[31:0];
    assign res = res_reg;
    assign flag = flag_reg;
    // 通用符号位计算
    // assign zf = res == 0;
    // assign sf = res[31];
    // assign pf = ~^res;
    // assign cf = cf_reg;
    // assign of = of_reg;

endmodule
