`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/01 09:55:36
// Design Name: 
// Module Name: DataMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 数据内存
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMem(
    input clk,
    input write_enable,         // 写使能
    input [31:0] addr,          // 读写内存地址
    input [2:0] len,            // 写入数据长度
    input [31:0] write_data,    // 写入的数据
    output [31:0] read_data     // 读出的数据
    );

    reg [3:0] bram_wea;
    
    wire [31:0] bram_read_data;
    
    DataBram data_bram (
      .clka(clk),           // input wire clka
      .wea(bram_wea),       // input wire [3 : 0] wea
      .addra(addr),         // input wire [31 : 0] addra
      .dina(write_data),    // input wire [31 : 0] dina
      .clkb(clk),           // input wire clkb
      .addrb(addr),         // input wire [31 : 0] addrb
      .doutb(read_data)     // output wire [31 : 0] doutb
    );
    
//    always @(*) begin
//        case (addr & 32'b11) 
//            2'b00: begin // 4字节对齐
//                read_data <= bram_read_data[31:0];
//            end
//            2'b01: begin
//                read_data <= {8'b0, bram_read_data[31:8]};
//            end
//            2'b10: begin
//                read_data <= {16'b0, bram_read_data[31:16]};
//            end
//            2'b11:begin 
//                read_data <= {24'b0, bram_read_data[31:24]};
//            end
//            default: begin 
//                read_data <= bram_read_data[31:0];
//            end
//        endcase
//    end

    always @(*) begin
        if (write_enable) begin // 写内存
            case (len) 
                3'b000: begin // 8位操作
                    bram_wea <= 4'b0001;
                end
                3'b001: begin // 16位操作
                    bram_wea <= 4'b0011;
                end
                default: begin // 默认32位操作
                    bram_wea <= 4'b1111;
                end
            endcase
        end else begin 
            bram_wea <= 4'b0000;
        end
    end

endmodule
