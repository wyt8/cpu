`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 22:27:40
// Design Name: 
// Module Name: PilelineCPUTestbench
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


module PilelineCPUTestbench();
    reg clk;
    reg rst;
    wire data_mem_write_enable;
    wire [31:0] data_mem_addr;
    wire [31:0] data_mem_write_data;
    wire [31:0] data_mem_read_data;
    wire [31:0] inst_mem_read_addr;
    wire [31:0] inst_mem_read_data;
    wire overflow_flag;
    
    PipelineCPU pipeline_cpu(
        .clk(clk),
        .rst(rst),
        .inst_mem_read_addr(inst_mem_read_addr),
        .inst_mem_read_data(inst_mem_read_data),
        .data_mem_write_enable(data_mem_write_enable),
        .data_mem_addr(data_mem_addr),
        .data_mem_write_data(data_mem_write_data),
        .data_mem_read_data(data_mem_read_data),
        .overflow_flag(overflow_flag)
    );
    
    DataMemory data_mem(
        .clk(clk),
        .rst(rst),
        .write_enable(data_mem_write_enable),
        .addr(data_mem_addr),
        .write_data(data_mem_write_data),
        .read_data(data_mem_read_data)
    );
    
    InstructionMemory inst_mem(
        .clk(clk),
        .rst(rst),
        .addr(inst_mem_read_addr),
        .data(inst_mem_read_data)
    );
    
    initial begin
        clk = 1'b1;
        rst = 1'b0; #10;
        rst = 1'b1;
        # 500;
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
