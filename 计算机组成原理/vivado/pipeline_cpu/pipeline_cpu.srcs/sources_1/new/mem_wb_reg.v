`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 16:45:44
// Design Name: 
// Module Name: MemWbReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 访存和写回阶段之间的流水线寄存器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MemWbReg(
    input clk,
    input rst,
    
    input [31:0] mem_mem_read_data,
    input [31:0] mem_alu_result,
    input mem_reg_write_enable,
    input mem_reg_write_data_src,
    input [4:0] mem_rd_addr,
    input [2:0] mem_data_mem_len,

    output reg [31:0] wb_mem_read_data,
    output reg [31:0] wb_alu_result,
    output reg wb_reg_write_enable,
    output reg wb_reg_write_data_src,
    output reg [4:0] wb_rd_addr,
    output reg [2:0] wb_data_mem_len
    );

    always @(posedge clk or negedge rst) begin 
        if(!rst) begin
            wb_mem_read_data <= 32'h0;
            wb_alu_result <= 32'h0;
            wb_reg_write_enable <= 1'h0;
            wb_reg_write_data_src <= 1'h0;
            wb_rd_addr <= 5'h0;
            wb_data_mem_len <= 3'h0;
        end
        else begin 
            wb_mem_read_data <= mem_mem_read_data;
            wb_alu_result <= mem_alu_result;
            wb_reg_write_enable <= mem_reg_write_enable;
            wb_reg_write_data_src <= mem_reg_write_data_src;
            wb_rd_addr <= mem_rd_addr;
            wb_data_mem_len <= mem_data_mem_len;
        end
    end

endmodule
