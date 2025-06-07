`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 23:40:19
// Design Name: 
// Module Name: cu
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


module cu(
    input [6:0] op_code,    // 操作码
    input [2:0] func3,      // 3位功能码
    input [6:0] func7,      // 7位功能码
    
    output num2_src,        // ALU的num2选择信号，为1表示从立即数输入，为0表示从寄存器堆rb输出输入
    output mem_to_reg,      // 寄存器堆写入数据的选择信号，为1表示从内存写入寄存器，为0表示从alu输出写入寄存器
    output reg_write_enable,// 寄存器堆写入使能
    output mem_write_enable,// 数据内存写入使能
    output [3:0] alu_select       // ALU的计算功能选择信号 
    );

    assign num2_src = ((op_code == 7'b000_0011) && (func3 == 3'b010)) 
        || ((op_code == 7'b010_0011) && (func3 == 3'b010))
        || (op_code == 7'b001_0011);
    assign mem_to_reg = (op_code == 7'b000_0011) && (func3 == 3'b010);
    assign reg_write_enable = ((op_code == 7'b000_0011) && (func3 == 3'b010))
        || (op_code == 7'b011_0011)
        || (op_code == 7'b001_0011);
    assign mem_write_enable = ((op_code == 7'b010_0011) && (func3 == 3'b010));
    assign alu_select = (((op_code == 7'b011_0011) && (func3 == 3'b000) && (func7 == 7'b000_0000)) 
            || ((op_code == 7'b001_0011) && (func3 == 3'b000))
            || ((op_code == 7'b000_0011) && (func3 == 3'b010))
            || ((op_code == 7'b010_0011) && (func3 == 3'b010))) ? 4'b0000 : // 加法
        ((op_code == 7'b011_0011) && (func3 == 3'b000) && (func7 == 7'b001_0100)) ? 4'b0001 : // 减法
        (((op_code == 7'b011_0011) && (func3 == 3'b111) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b111))) ? 4'b0010 : // 与
        (((op_code == 7'b011_0011) && (func3 == 3'b110) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b110))) ? 4'b0011 : // 或
        (((op_code == 7'b011_0011) && (func3 == 3'b100) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b100))) ? 4'b0100 : // 异或
        (((op_code == 7'b011_0011) && (func3 == 3'b010) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b010))
            || ((op_code == 7'b110_0011) && (func3 == 3'b100))) ? 4'b1000 : // 小于
        ((op_code == 7'b110_0011) && (func3 == 3'b101)) ? 4'b1001 : // 大于等于
        ((op_code == 7'b110_0011) && (func3 == 3'b000)) ? 4'b1010 : // 等于
        ((op_code == 7'b110_0011) && (func3 == 3'b001)) ? 4'b1011 : // 不等于
        (op_code == 7'b110_1111) ? 4'b1111 : // 无条件跳转
        4'b0000; // 无效编码
endmodule
