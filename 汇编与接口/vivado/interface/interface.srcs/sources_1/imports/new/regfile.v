`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 15:38:33
// Design Name: 
// Module Name: Regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// ����һд�Ĵ�����
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Regfile(
    input clk,
    input rst,
    input write_enable,             // дʹ��
    input [4:0] ra_addr,            // ���Ĵ���A��ַ
    input [4:0] rb_addr,            // ���Ĵ���B��ַ
    input [4:0] rw_addr,            // д�Ĵ�����ַ
    input [2:0] rw_len,             // д���ݵĳ���

    input [31:0] rw_data,           // д�Ĵ���ʱ����
    output [31:0] ra_data,          // ���Ĵ���Aʱ����
    output [31:0] rb_data,           // ���Ĵ���Bʱ����
    
    // ʹ��ILA̽�⺯�����ù���
    output [31:0] a0,
    output [31:0] a1
    );

    // ͨ�üĴ�����
    reg [31:0] general_regs[31:0];

    assign a0 = general_regs[10];
    assign a1 = general_regs[11];

    integer i = 0;
    // Ϊ���üĴ���������д�ؽ׶�����ɶԼĴ�����д������������clk���½��ؽ���д����
    // �������д�ؽ׶ε���һ�����ڲſ�����ɶԼĴ�����д����
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ÿ���Ĵ�����Ϊ0
            for(i = 0; i < 32; i = i + 1)
                general_regs[i] <= 32'b0;
        end
        else if (write_enable) begin // д�Ĵ��� 
            if (rw_addr != 5'h0) begin
                case (rw_len) 3'b000: // 8λ������������չ 
                    general_regs[rw_addr] <= {{24{rw_data[7]}}, rw_data[7:0]}; 
                3'b001: // 16λ������������չ 
                    general_regs[rw_addr] <= {{16{rw_data[15]}}, rw_data[15:0]}; 
                3'b010: // 32λ������������չ 
                    general_regs[rw_addr] <= rw_data; 
                3'b100: // 8λ����������չ 
                    general_regs[rw_addr] <= {24'b0, rw_data[7:0]}; 
                3'b101: // 16λ����������չ 
                    general_regs[rw_addr] <= {16'b0, rw_data[15:0]}; 
                default: // Ĭ��32λ������������չ 
                    general_regs[rw_addr] <= rw_data; 
                endcase 
            end
        end
    end
    // ���Ĵ���
    assign ra_data = general_regs[ra_addr];
    assign rb_data = general_regs[rb_addr];

endmodule
