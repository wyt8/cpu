`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 21:49:38
// Design Name: 
// Module Name: ControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// ���Ƶ�Ԫ��ͨ��������͹��������ɸ��ֿ����ź�
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module ControlUnit(
    input [6:0] op_code,                        // ������
    input [2:0] func3,                          // 3λ������
    input [6:0] func7,                          // 7λ������

    output reg alu_num2_src,                    // alu��num2��Դ��1��ʾrs2_data 0��ʾimm
    output reg reg_write_enable,                // �Ĵ������Ƿ��д
    output reg mem_write_enable,                // �����ڴ��Ƿ��д
    output reg reg_write_data_src,              // �Ĵ�����д������Դ��1��ʾ���ڴ�������� 0��ʾalu������
    output reg jump_type_inst,                  // �Ƿ�Ϊ��ת����ָ���������תָ���������תָ�����ָ���
    output reg [4:0] alu_select,                // alu�Ĺ���ѡ���ź�
    output reg jar_select,                      // jalr or others
    output reg alu1_select                      // alu src1 = PC or rs1
    );

    always @(*) begin
        alu_select <= `ALU_ADD;
        case(op_code)
             // ��������ָ��
            `BUBBLE_OP_CODE: begin 
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b0;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                alu_select <= `ALU_ADD;
                jar_select <= 0;
                alu1_select <= 0;
            end
            // R����ָ��
            7'b011_0011: begin
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                jar_select <= 0;
                alu1_select <= 0;
                case(func3)
                    3'b000: begin
                        case(func7)
                            7'b000_0000: begin // add
                                alu_select <= `ALU_ADD;
                            end
                            7'b0100000: begin // sub
                                alu_select <= `ALU_SUB;
                            end
                            7'b0000001: begin // mul
                                alu_select <= `ALU_MUL;
                            end
                            7'b0000010: begin // div
                                alu_select <= `ALU_DIV;
                            end
                            7'b0000011: begin // mod
                                alu_select <= `ALU_MOD;
                            end
                        endcase
                    end
                    3'b100: begin//xor
                        alu_select <= `ALU_BIT_XOR;
                    end
                     3'b110: begin//or
                        alu_select <= `ALU_BIT_OR;
                    end
                     3'b111: begin//and
                        alu_select <= `ALU_BIT_AND;
                    end
                     3'b001: begin//sll
                        alu_select <= `ALU_SLL;
                    end
                     3'b101: begin
                        case(func7)
                            7'b0000000: begin // srl
                                alu_select <= `ALU_SRL;
                            end
                            7'b0100000: begin // sra
                                alu_select <= `ALU_SRA;
                            end
                        endcase
                    end
                    3'b010: begin//slt
                        alu_select <= `ALU_SLT;
                    end
                    3'b011: begin//sltu
                        alu_select <= `ALU_SLTU;
                    end
                endcase
            end
            // I����ָ��
            7'b001_0011: begin
                alu_num2_src <= 1'b0;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                jar_select <= 0;
                alu1_select <= 0;
                case(func3)
                    3'b000: begin // addi
                        alu_select <= `ALU_ADD;
                    end
                    3'b100: begin//xori
                        alu_select <= `ALU_BIT_XOR;
                    end
                     3'b110: begin//ori
                        alu_select <= `ALU_BIT_OR;
                    end
                     3'b111: begin//andi
                        alu_select <= `ALU_BIT_AND;
                    end
                    3'b001: begin//slli
                        alu_select <= `ALU_SLL;
                    end
                    3'b101: begin
                        case(func7)
                            7'b0000000: begin // srli
                                alu_select <= `ALU_SRL;
                            end
                            7'b0100000: begin // srai
                                alu_select <= `ALU_SRA;
                            end
                        endcase
                    end
                    3'b010: begin //slti
                        alu_select <= `ALU_SLT;
                    end
                    3'b011: begin //sltiu
                        alu_select <= `ALU_SLTU;
                    end
                endcase
            end
            // I����ָ���е�loadϵ��ָ��
            7'b000_0011: begin
                alu_num2_src <= 1'b0;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b1;
                jump_type_inst <= 1'b0;
                jar_select <= 0;
                alu1_select <= 0;
                case(func3)
                    3'b000: begin //lb
                        alu_select <= `ALU_ADD;
                    end
                    3'b001: begin //lh
                        alu_select <= `ALU_ADD;
                    end
                    3'b010: begin // lw
                        alu_select <= `ALU_ADD;
                    end
                    3'b100: begin //lbu
                        alu_select <= `ALU_ADD;
                    end
                    3'b101: begin //lhu
                        alu_select <= `ALU_ADD;
                    end
                endcase
            end
            // S����ָ��
            7'b010_0011: begin
                alu_num2_src <= 1'b0;
                reg_write_enable <= 1'b0;
                mem_write_enable <= 1'b1;
                reg_write_data_src <= 1'b1;
                jump_type_inst <= 1'b0;
                jar_select <= 0;
                alu1_select <= 0;
                case(func3)
                    3'b000: begin //sb
                        alu_select <= `ALU_ADD;
                    end
                    3'b001: begin //sh
                        alu_select <= `ALU_ADD;
                    end
                    3'b010: begin // sw
                        alu_select <= `ALU_ADD;
                    end
                endcase
            end
            // B����ָ��
            7'b110_0011: begin 
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b0;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b1;
                jump_type_inst <= 1'b1;
                jar_select <= 0;
                alu1_select <= 0;
                case(func3)
                    3'b000: begin //beq
                        alu_select <= `ALU_EQ;
                    end
                    3'b001: begin //bne
                        alu_select <= `ALU_NEQ;
                    end
                    3'b100: begin // blt
                        alu_select <= `ALU_LT;
                    end
                    3'b101: begin // bge
                        alu_select <= `ALU_GE;
                    end
                    3'b110: begin //bltu
                        alu_select <= `ALU_LTU;
                    end
                    3'b111: begin //bgeu
                        alu_select <= `ALU_GEU ;
                    end
                endcase
            end
            //Jal
             7'b110_1111: begin
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b1;
                alu_select <= `ALU_JAL ;
                jar_select <= 0;
                alu1_select <= 1;
            end
            //Jalr
             7'b110_0111: begin
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b1;
                alu_select <= `ALU_JAL ;
                jar_select <= 1;
                alu1_select <= 1;
            end
            //Lui
             7'b011_0111: begin
                alu_num2_src <= 1'b0;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                alu_select <= `ALU_LUI  ;
                jar_select <= 0;
                alu1_select <= 0;
            end
            //Auipc
             7'b001_0111: begin
                alu_num2_src <= 1'b0;
                reg_write_enable <= 1'b1;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                alu_select <= `ALU_AUIPC  ;
                jar_select <= 0;
                alu1_select <= 1;
            end
             default: begin
                alu_num2_src <= 1'b1;
                reg_write_enable <= 1'b0;
                mem_write_enable <= 1'b0;
                reg_write_data_src <= 1'b0;
                jump_type_inst <= 1'b0;
                alu_select <= `ALU_ADD;
                jar_select <= 0;
                alu1_select <= 0;
            end
        endcase
    end

endmodule
