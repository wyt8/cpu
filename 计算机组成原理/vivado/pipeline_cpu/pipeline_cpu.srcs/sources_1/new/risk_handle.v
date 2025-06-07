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
// 冒险处理模块
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

    input [6:0] op_code,           // 操作码
    input [4:0] rd,                // 目的寄存器
    input [4:0] rs1,               // 源寄存器1
    input [4:0] rs2,               // 源寄存器2


    output reg pc_stall,
    output reg if_id_reg_stall,
    output reg if_id_reg_bubble,
    output reg id_ex_reg_bubble
    );

    reg [4:0] prev_inst_rd_1;   // 上一个周期保存指令的rd
    reg [4:0] prev_inst_rd_2;   // 上二个周期保存指令的rd
    reg [4:0] prev_inst_rd_3;   // 上三个周期保存指令的rd

    reg [1:0] jump_stall_counter;   // 控制冒险时已经暂停周期计数

    always @(posedge clk or negedge rst) begin
        if(!rst) begin 
            prev_inst_rd_1 <= 5'h0;
            prev_inst_rd_2 <= 5'h0;
            prev_inst_rd_3 <= 5'h0;

            jump_stall_counter <= 3'h0;
        end else begin 
            prev_inst_rd_3 <= prev_inst_rd_2;
            prev_inst_rd_2 <= prev_inst_rd_1;
            // 为了处理类似如下情况的数据相关：
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
        // 数据冒险：当前指令的源寄存器出现在前 3 条指令的目的寄存器中
        // 出现在前 1 条指令需要插 3 个气泡
        // 出现在前 2 条指令需要插 2 个气泡
        // 出现在前 3 条指令需要插 1 个气泡
        // rs1 != 0 和 rs2 != 0表示当前源寄存器不能都为 x0
        begin
            pc_stall <= 1'b1;           // pc值保持在下一条指令的位置
            if_id_reg_stall <= 1'b1;    // if_id流水线寄存器保持当前指令
            if_id_reg_bubble <= 1'b0;
            id_ex_reg_bubble <= 1'b1;   // 取消该指令之后执行、访存、写回阶段
        end
        // 控制冒险：当指令为分支指令或跳转指令时
        // 暂停 3 个周期
        else if ((jump_stall_counter < 3 && jump_stall_counter > 0) || (op_code ==  `B_TYPE_OP_CODE || op_code == `JAL_TYPE_OP_CODE || op_code == `JALR_TYPE_OP_CODE)) begin
            pc_stall <= 1'b1;           // pc值保持在下一条指令的位置，如果select了 jump_pc 则保持在jump_pc
            if_id_reg_stall <= 1'b0;    
            if_id_reg_bubble <= 1'b1;   // if_id流水线寄存器清空，取消该指令之后的指令的执行
            id_ex_reg_bubble <= 1'b0;   // 该指令之后的执行、访存、写回阶段继续执行
        end 
        else begin
            pc_stall <= 1'b0;
            if_id_reg_stall <= 1'b0;
            if_id_reg_bubble <= 1'b0;
            id_ex_reg_bubble <= 1'b0;
        end
     end

endmodule
