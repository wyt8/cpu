`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 12:55:48
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input rst,
    input write_enable,     // дʹ��
    input [4:0] ra_addr,    // ���Ĵ���A��ַ
    input [4:0] rb_addr,    // ���Ĵ���B��ַ
    input [4:0] rw_addr,    // д�Ĵ�����ַ
    
    input [31:0] rw_data,   // д�Ĵ���ʱ����
    output [31:0]  ra_data, // ���Ĵ���Aʱ����
    output [31:0] rb_data   // ���Ĵ���Bʱ����
    );
    // �Ĵ�����
    reg [31:0] regs[31:0];

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ÿ���Ĵ�����Ϊ0
            for(i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (write_enable) // д�Ĵ���
            regs[rw_addr] = rw_data;
    end

    // ���Ĵ���
    assign ra_data = regs[ra_addr];
    assign rb_data = regs[rb_addr];
endmodule

