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
    input [6:0] op_code,    // ������
    input [2:0] func3,      // 3λ������
    input [6:0] func7,      // 7λ������
    
    output num2_src,        // ALU��num2ѡ���źţ�Ϊ1��ʾ�����������룬Ϊ0��ʾ�ӼĴ�����rb�������
    output mem_to_reg,      // �Ĵ�����д�����ݵ�ѡ���źţ�Ϊ1��ʾ���ڴ�д��Ĵ�����Ϊ0��ʾ��alu���д��Ĵ���
    output reg_write_enable,// �Ĵ�����д��ʹ��
    output mem_write_enable,// �����ڴ�д��ʹ��
    output [3:0] alu_select       // ALU�ļ��㹦��ѡ���ź� 
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
            || ((op_code == 7'b010_0011) && (func3 == 3'b010))) ? 4'b0000 : // �ӷ�
        ((op_code == 7'b011_0011) && (func3 == 3'b000) && (func7 == 7'b001_0100)) ? 4'b0001 : // ����
        (((op_code == 7'b011_0011) && (func3 == 3'b111) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b111))) ? 4'b0010 : // ��
        (((op_code == 7'b011_0011) && (func3 == 3'b110) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b110))) ? 4'b0011 : // ��
        (((op_code == 7'b011_0011) && (func3 == 3'b100) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b100))) ? 4'b0100 : // ���
        (((op_code == 7'b011_0011) && (func3 == 3'b010) && (func7 == 7'b000_0000))
            || ((op_code == 7'b001_0011) && (func3 == 3'b010))
            || ((op_code == 7'b110_0011) && (func3 == 3'b100))) ? 4'b1000 : // С��
        ((op_code == 7'b110_0011) && (func3 == 3'b101)) ? 4'b1001 : // ���ڵ���
        ((op_code == 7'b110_0011) && (func3 == 3'b000)) ? 4'b1010 : // ����
        ((op_code == 7'b110_0011) && (func3 == 3'b001)) ? 4'b1011 : // ������
        (op_code == 7'b110_1111) ? 4'b1111 : // ��������ת
        4'b0000; // ��Ч����
endmodule
