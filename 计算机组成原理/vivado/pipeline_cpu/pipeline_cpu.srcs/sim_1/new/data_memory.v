`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 20:07:48
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input rst,
    input write_enable,         // 写使能
    input [31:0] addr,          // 读写内存地址
    input [31:0] write_data,    // 写入的数据
    output [31:0] read_data     // 读出的数据
    );
    
    // 内存，总大小为1KB
    reg [7:0] ram[1023:0];

    integer i;
    // 为了让内存可以在访存阶段内完成对内存的写操作，这里在clk的下降沿进行写操作
    // 否则会在访存阶段的下一个周期才可以完成对内存的写操作
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // 复位，将每个字节置为0
            for(i = 0; i < 1024; i = i + 1)
                ram[i] = 8'h0;
            $readmemh("data_mem.txt", ram);
            
            ram[0] <= 8'd8;
            ram[4] <= 8'd7;
            ram[8] <= 8'd6;
            ram[12] <= 8'd5;
            ram[16] <= 8'd4;
            ram[20] <= 8'd3;
            ram[24] <= 8'd2;
            ram[28] <= 8'd1;
        end
        else if (write_enable) begin // 写内存
            ram[addr] <= write_data[7:0];
            ram[addr+1] <= write_data[15:8];
            ram[addr+2] <= write_data[23:16];
            ram[addr+3] <= write_data[31:24];
        end
    end

    // 读内存
    assign read_data = {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
    
endmodule
