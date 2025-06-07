`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/28 22:15:47
// Design Name: 
// Module Name: RiskHandle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// ð�մ���ģ��
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module RiskHandle(
    input clk,
    input rst,

    input [6:0] op_code,           // ������
    input [4:0] rd,                // Ŀ�ļĴ���
    input [4:0] rs1,               // Դ�Ĵ���1
    input [4:0] rs2,               // Դ�Ĵ���2


    output reg pc_stall,
    output reg if_id_reg_stall,
    output reg if_id_reg_bubble,
    output reg id_ex_reg_bubble
    );

    reg [4:0] prev_inst_rd_1;   // ��һ�����ڱ���ָ���rd
    reg [4:0] prev_inst_rd_2;   // �϶������ڱ���ָ���rd
    reg [4:0] prev_inst_rd_3;   // ���������ڱ���ָ���rd

    reg [1:0] jump_stall_counter;   // ����ð��ʱ�Ѿ���ͣ���ڼ���

    always @(posedge clk or negedge rst) begin
        if(!rst) begin 
            prev_inst_rd_1 <= 5'h0;
            prev_inst_rd_2 <= 5'h0;
            prev_inst_rd_3 <= 5'h0;

            jump_stall_counter <= 3'h0;
        end else begin 
            prev_inst_rd_3 <= prev_inst_rd_2;
            prev_inst_rd_2 <= prev_inst_rd_1;
            // Ϊ�˴����������������������أ�
            // add x1, x1, x1
            // add x1, x1, x1
            // add x1, x1, x1
            // add x1, x1, x1
            // ...
            if (if_id_reg_stall) begin 
                prev_inst_rd_1 <= 5'h0;
            end else begin 
                prev_inst_rd_1 <= rd;
            end

            if (if_id_reg_bubble) begin 
                jump_stall_counter <= jump_stall_counter + 1'b1;
                if (jump_stall_counter == 3) begin
                    jump_stall_counter <= 2'h1;
                end
            end
         end
    end


    always @(*) begin
        if ((prev_inst_rd_1 != 0 && (prev_inst_rd_1 == rs1 || prev_inst_rd_1 == rs2))
            || (prev_inst_rd_2 != 0 && (prev_inst_rd_2 == rs1 || prev_inst_rd_2 == rs2))
            || (prev_inst_rd_3 != 0 && (prev_inst_rd_3 == rs1 || prev_inst_rd_3 == rs2))
        )
        // ����ð�գ���ǰָ���Դ�Ĵ���������ǰ 3 ��ָ���Ŀ�ļĴ�����
        // ������ǰ 1 ��ָ����Ҫ�� 3 ������
        // ������ǰ 2 ��ָ����Ҫ�� 2 ������
        // ������ǰ 3 ��ָ����Ҫ�� 1 ������
        // rs1 != 0 �� rs2 != 0��ʾ��ǰԴ�Ĵ������ܶ�Ϊ x0
        begin
            pc_stall <= 1'b1;           // pcֵ��������һ��ָ���λ��
            if_id_reg_stall <= 1'b1;    // if_id��ˮ�߼Ĵ������ֵ�ǰָ��
            if_id_reg_bubble <= 1'b0;
            id_ex_reg_bubble <= 1'b1;   // ȡ����ָ��֮��ִ�С��ô桢д�ؽ׶�
        end
        // ����ð�գ���ָ��Ϊ��ָ֧�����תָ��ʱ
        // ��ͣ 3 ������
        else if ((jump_stall_counter < 3 && jump_stall_counter > 0) || (op_code ==  `B_TYPE_OP_CODE || op_code == `JAL_TYPE_OP_CODE || op_code == `JALR_TYPE_OP_CODE)) begin
            pc_stall <= 1'b1;           // pcֵ��������һ��ָ���λ�ã����select�� jump_pc �򱣳���jump_pc
            if_id_reg_stall <= 1'b0;    
            if_id_reg_bubble <= 1'b1;   // if_id��ˮ�߼Ĵ�����գ�ȡ����ָ��֮���ָ���ִ��
            id_ex_reg_bubble <= 1'b0;   // ��ָ��֮���ִ�С��ô桢д�ؽ׶μ���ִ��
        end 
        else begin
            pc_stall <= 1'b0;
            if_id_reg_stall <= 1'b0;
            if_id_reg_bubble <= 1'b0;
            id_ex_reg_bubble <= 1'b0;
        end
     end

endmodule
