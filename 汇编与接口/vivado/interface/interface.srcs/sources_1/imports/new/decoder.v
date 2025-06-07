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
// ָ�����ģ�飺����ָ�������ָ��ĸ����ֶΣ����������������з�����չ
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module Decoder(
    input [31:0] instruction,           // �����ָ��
    output reg [6:0] op_code,           // ������
    output reg [2:0] func3,             // 3λ������
    output reg [6:0] func7,             // 7λ������
    output reg [4:0] rd,                // Ŀ�ļĴ���
    output reg [4:0] rs1,               // Դ�Ĵ���1
    output reg [4:0] rs2,               // Դ�Ĵ���2
    output reg [31:0] imm               // ��չ��32λ��������
    );

    always @(*) begin
        op_code = instruction[6:0];
        // ���ݲ������ȡָ��ĸ�������
        case(op_code)
            `BUBBLE_OP_CODE: begin // �Զ��������ָ��
                imm = 32'h0;
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = 5'h0;
            end
            `R_TYPE_OP_CODE: begin // R��ָ��
                imm = 32'h0;
                func3 = instruction[14:12];
                func7 = instruction[31:25];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = instruction[11:7];
            end
            `I_TYPE_OP_CODE: begin // ��������ָ��
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `LOAD_TYPE_OP_CODE: begin // load��ָ��
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `S_TYPE_OP_CODE: begin // S��ָ��
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = 5'h0;
            end
            `B_TYPE_OP_CODE: begin // B��ָ��
                imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                rd = 5'h0;
            end
            `JAL_TYPE_OP_CODE: begin // Jalָ��
                imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `JALR_TYPE_OP_CODE: begin // Jalrָ��
                imm = {{20{instruction[31]}}, instruction[31:20]};
                func3 = instruction[14:12];
                func7 = 7'h0;
                rs1 = instruction[19:15];
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `LUI_OP_CODE: begin // luiָ��
                imm = {instruction[31:12], 12'b0};
                func3 = 3'h0;
                func7 = 7'h0;
                rs1 = 5'h0;
                rs2 = 5'h0;
                rd = instruction[11:7];
            end
            `AUIPC_OP_CODE: begin // auipcָ��
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
