`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 19:38:20
// Design Name: 
// Module Name: PC
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

`include "global.vh"

module PC(
    input clk,
    input rst,

    input stall,                            // ��pcֵ���ֲ���

    input [31:0] jump_pc,
    input select,                           // PCѡ���źţ�Ϊ 0 �� !stall ��ʾ pc + 4��Ϊ 1 ��ʾѡ�� jump_pc
    output reg [31:0] pc                    // ����ָ��ĵ�ַ 
    );
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin 
            pc <= `FIRST_PC;
        end
        else begin
        // ������Ҫע�����ȼ���
        // stall ��Ӧ������ jump_pc ���µ� pc �仯
        // �����ʹ�ڿ���ð��ʱ��jump_pc�ڴ���ʱ���һ��������ǰ���͸ò���ֵ
            case(select) 
                1'b0: begin
                    if (stall) begin 
                        pc <= pc;
                    end else begin 
                        pc <= pc + 32'h4;
                    end
                end
                1'b1: begin
                    pc <= jump_pc;
                end
            endcase
        end
    end

endmodule
