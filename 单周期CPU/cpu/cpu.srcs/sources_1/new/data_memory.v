`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 16:46:33
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk,
    input rst,
    input write_enable, // дʹ��
    input [31:0] addr,  // ��д�ڴ��ַ
    input [31:0] write_data, // д�������
    output [31:0] read_data // ����������
    );

    // �ڴ棬�ܴ�СΪ1KB
    reg [7:0] ram[1023:0];

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ÿ���ֽ���Ϊ0
            for(i = 0; i < 1024; i = i + 1)
                ram[i] = 32'b0;
            $readmemh("mem.txt", ram);
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
