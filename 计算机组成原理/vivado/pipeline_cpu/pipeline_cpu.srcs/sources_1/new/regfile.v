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
// 两读一写寄存器堆
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
    input write_enable,             // 写使能
    input [4:0] ra_addr,            // 读寄存器A地址
    input [4:0] rb_addr,            // 读寄存器B地址
    input [4:0] rw_addr,            // 写寄存器地址
    input [2:0] rw_len,             // 写数据的长度

    input [31:0] rw_data,           // 写寄存器时数据
    output [31:0] ra_data,          // 读寄存器A时数据
    output [31:0] rb_data,           // 读寄存器B时数据
    
    // 使用ILA探测函数调用过程
    output [31:0] a0,
    output [31:0] a1
    );

    // 通用寄存器堆
    reg [31:0] general_regs[31:0];

    assign a0 = general_regs[10];
    assign a1 = general_regs[11];

    integer i = 0;
    // 为了让寄存器可以在写回阶段内完成对寄存器的写操作，这里在clk的下降沿进行写操作
    // 否则会在写回阶段的下一个周期才可以完成对寄存器的写操作
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // 复位，将每个寄存器置为0
            for(i = 0; i < 32; i = i + 1)
                general_regs[i] <= 32'b0;
        end
        else if (write_enable) begin // 写寄存器 
            if (rw_addr != 5'h0) begin
                case (rw_len) 3'b000: // 8位操作，符号扩展 
                    general_regs[rw_addr] <= {{24{rw_data[7]}}, rw_data[7:0]}; 
                3'b001: // 16位操作，符号扩展 
                    general_regs[rw_addr] <= {{16{rw_data[15]}}, rw_data[15:0]}; 
                3'b010: // 32位操作，无需扩展 
                    general_regs[rw_addr] <= rw_data; 
                3'b100: // 8位操作，零扩展 
                    general_regs[rw_addr] <= {24'b0, rw_data[7:0]}; 
                3'b101: // 16位操作，零扩展 
                    general_regs[rw_addr] <= {16'b0, rw_data[15:0]}; 
                default: // 默认32位操作，无需扩展 
                    general_regs[rw_addr] <= rw_data; 
                endcase 
            end
        end
    end
    // 读寄存器
    assign ra_data = general_regs[ra_addr];
    assign rb_data = general_regs[rb_addr];

endmodule
