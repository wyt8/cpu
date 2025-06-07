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
    input write_enable,         // дʹ��
    input [31:0] addr,          // ��д�ڴ��ַ
    input [31:0] write_data,    // д�������
    output [31:0] read_data     // ����������
    );
    
    // �ڴ棬�ܴ�СΪ1KB
    reg [7:0] ram[1023:0];

    integer i;
    // Ϊ�����ڴ�����ڷô�׶�����ɶ��ڴ��д������������clk���½��ؽ���д����
    // ������ڷô�׶ε���һ�����ڲſ�����ɶ��ڴ��д����
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ÿ���ֽ���Ϊ0
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
        else if (write_enable) begin // д�ڴ�
            ram[addr] <= write_data[7:0];
            ram[addr+1] <= write_data[15:8];
            ram[addr+2] <= write_data[23:16];
            ram[addr+3] <= write_data[31:24];
        end
    end

    // ���ڴ�
    assign read_data = {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
    
endmodule
