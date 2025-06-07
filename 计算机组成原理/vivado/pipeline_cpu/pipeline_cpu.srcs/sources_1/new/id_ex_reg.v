`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 15:08:25
// Design Name: 
// Module Name: IdExReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 译码和执行阶段之间的流水线寄存器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "global.vh"

module IdExReg(
    input clk,
    input rst,

    input bubble,

    input [31:0] id_imm,
    input [31:0] id_rs1_data,
    input [31:0] id_rs2_data,
    input [4:0] id_rd_addr,
    input [4:0] id_alu_select,
    input id_reg_write_enable,
    input id_mem_write_enable,
    input id_alu_num2_src,
    input id_reg_write_data_src,
    input id_jump_type_inst,
    input [31:0] id_pc,
    input id_jar_select,
    input id_alu1_select,
    input [2:0] id_data_mem_len,
        
    output reg [31:0] ex_imm,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [4:0] ex_rd_addr,
    output reg [4:0] ex_alu_select,
    output reg ex_reg_write_enable,
    output reg ex_mem_write_enable,
    output reg ex_alu_num2_src,
    output reg ex_reg_write_data_src,
    output reg ex_jump_type_inst,
    output reg [31:0] ex_pc,
    output reg ex_jar_select,
    output reg ex_alu1_select,
    output reg [2:0] ex_data_mem_len
    );

    always @(posedge clk or negedge rst) begin 
        if(!rst) begin
            ex_imm <= 32'h0;
            ex_rs1_data <= 32'h0;
            ex_rs2_data <= 32'h0;
            ex_rd_addr <= 5'h0;
            ex_alu_select <= 5'h0;
            ex_reg_write_enable <= 1'h0;
            ex_mem_write_enable <= 1'h0;
            ex_alu_num2_src <= 1'h0;
            ex_reg_write_data_src <= 1'h0;
            ex_jump_type_inst <= 1'h0;
            ex_pc <= 32'h0;
            ex_jar_select <= 1'b0;
            ex_alu1_select <= 1'b0;
            ex_data_mem_len <= 3'h0;
        end
        else if (bubble) begin 
            ex_imm <= 32'h0;
            ex_rs1_data <= 32'h0;
            ex_rs2_data <= 32'h0;
            ex_rd_addr <= 5'h0;
            ex_alu_select <= 5'h0;
            ex_reg_write_enable <= 1'h0;
            ex_mem_write_enable <= 1'h0;
            ex_alu_num2_src <= 1'h0;
            ex_reg_write_data_src <= 1'h0;
            ex_jump_type_inst <= 1'h0;
            ex_jar_select <= 1'b0;
            ex_alu1_select <= 1'b0;
            ex_data_mem_len <= 3'h0;
            ex_pc <= `FIRST_PC;
        end
        else begin 
            ex_imm <= id_imm;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_rd_addr <= id_rd_addr;
            ex_alu_select <= id_alu_select;
            ex_reg_write_enable <= id_reg_write_enable;
            ex_mem_write_enable <= id_mem_write_enable;
            ex_alu_num2_src <= id_alu_num2_src;
            ex_reg_write_data_src <= id_reg_write_data_src;
            ex_jump_type_inst <= id_jump_type_inst;
            ex_pc <= id_pc;
            ex_jar_select <= id_jar_select;
            ex_alu1_select <= id_alu1_select;
            ex_data_mem_len <= id_data_mem_len;
        end
    end

endmodule
