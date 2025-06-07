`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 15:08:25
// Design Name: 
// Module Name: ExMemReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 执行和访存阶段之间的流水线寄存器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ExMemReg(
    input clk,
    input rst,

    input [31:0] ex_alu_result,
    input ex_alu_condition_flag,
    input ex_reg_write_enable,
    input ex_mem_write_enable,
    input ex_reg_write_data_src,
    input [4:0] ex_rd_addr,
    input [31:0] ex_rs2_data,
    input ex_jump_type_inst,
    input [31:0] ex_jump_pc,
    input [2:0] ex_data_mem_len,

    output reg [31:0] mem_alu_result,
    output reg mem_alu_condition_flag,
    output reg mem_reg_write_enable,
    output reg mem_mem_write_enable,
    output reg mem_reg_write_data_src,
    output reg [4:0] mem_rd_addr,
    output reg [31:0] mem_rs2_data,
    output reg mem_jump_type_inst,
    output reg [31:0] mem_jump_pc,
    output reg [2:0] mem_data_mem_len
    );

    always @(posedge clk or negedge rst) begin 
        if(!rst) begin 
            mem_alu_result <= 32'h0;
            mem_alu_condition_flag <= 1'h0;
            mem_reg_write_enable <= 1'h0;
            mem_mem_write_enable <= 1'h0;
            mem_reg_write_data_src <= 1'h0;
            mem_rd_addr <= 5'h0;
            mem_rs2_data <= 32'h0;
            mem_jump_type_inst <= 1'h0;
            mem_jump_pc <= 32'b0;
            mem_data_mem_len <= 3'h0;
        end
        else begin
            mem_alu_result <= ex_alu_result;
            mem_alu_condition_flag <= ex_alu_condition_flag;
            mem_reg_write_enable <= ex_reg_write_enable;
            mem_mem_write_enable <= ex_mem_write_enable;
            mem_reg_write_data_src <= ex_reg_write_data_src;
            mem_rd_addr <= ex_rd_addr;
            mem_rs2_data <= ex_rs2_data;
            mem_jump_type_inst <= ex_jump_type_inst;
            mem_jump_pc <= ex_jump_pc;
            mem_data_mem_len <= ex_data_mem_len;
        end
    end

endmodule
