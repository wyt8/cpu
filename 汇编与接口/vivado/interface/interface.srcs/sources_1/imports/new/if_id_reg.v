`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 14:54:15
// Design Name: 
// Module Name: IfIdReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 取指和译码阶段之间的流水线寄存器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module IfIdReg(
    input clk,
    input rst,
    
    input stall,        // 流水线寄存器保持不变
    input bubble,       // 流水线寄存器清零

    input [31:0] if_instruction,
    input [31:0] if_pc,

    output reg [31:0] id_instruction,
    output reg [31:0] id_pc
    );

    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            id_instruction <= `BUBBLE_INST;
            id_pc <= `FIRST_PC;
        end
        else begin
            if (!stall) begin
                if(bubble) begin
                    id_instruction <= `BUBBLE_INST;
                    id_pc <= `FIRST_PC;
                end else begin 
                    id_instruction <= if_instruction;
                    id_pc <= if_pc;
                end
            end
        end
    end

endmodule
