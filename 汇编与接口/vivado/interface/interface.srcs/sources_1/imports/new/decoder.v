`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 15:31:32
// Design Name: 
// Module Name: Decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 指令解码模块：输入指令，解析出指令的各个字段，并进行立即数的有符号扩展
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module Decoder(
    input [31:0] instruction,           // 输入的指令
    output reg [6:0] op_code,           // 操作码
    output reg [2:0] func3,             // 3位功能码
    output reg [6:0] func7,             // 7位功能码
    output reg [4:0] rd,                // 目的寄存器
    output reg [4:0] rs1,               // 源寄存器1
    output reg [4:0] rs2,               // 源寄存器2
    output reg [31:0] imm               // 扩展到32位的立即数
    );

    always @(*) begin
        op_code = instruction[6:0];
        // 根据操作码获取指令的各个部分
        case(op_code)
            `BUBBLE_OP_CODE: begin // 自定义的气泡指令
                imm = 32'h0;
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = 5'h0;
            end
            `R_TYPE_OP_CODE: begin // R型指令
                imm = 32'h0;
                func3 = instruction[14:12];
                func7 = instruction[31:25];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = instruction[11:7];
            end
            `I_TYPE_OP_CODE: begin // 立即数型指令
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `LOAD_TYPE_OP_CODE: begin // load型指令
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `S_TYPE_OP_CODE: begin // S型指令
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = 5'h0;
            end
            `B_TYPE_OP_CODE: begin // B型指令
                imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = 5'h0;
            end
            `JAL_TYPE_OP_CODE: begin // Jal指令
                imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `JALR_TYPE_OP_CODE: begin // Jalr指令
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `LUI_OP_CODE: begin // lui指令
                imm = {instruction[31:12], 12'b0};
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `AUIPC_OP_CODE: begin // auipc指令
                imm = {instruction[31:12], 12'b0};
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
           default: begin 
                imm = 32'h0;
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = 5'h0;
            end
        endcase
    
    end

endmodule
