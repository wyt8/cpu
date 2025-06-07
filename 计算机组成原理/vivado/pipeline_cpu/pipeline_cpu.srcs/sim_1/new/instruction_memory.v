`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/25 20:07:48
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
    input clk,
    input rst,
    input [31:0] addr,          // 读内存地址
    output [31:0] data          // 读出的数据
    );
    
    // 内存，最多可以存放64条指令
    reg [31:0] ram[63:0];

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // 复位，将每个字节置为0
            for(i = 0; i < 64; i = i + 1)
                ram[i] = 32'h0;
            $readmemh("inst_mem.txt", ram);
           // 没有相关的指令
//            ram[0] = 32'h00100093; // addi x1, x0, 1
//            ram[1] = 32'h00200113; // addi x2, x0, 2
//            ram[2] = 32'h00300193; // addi x3, x0, 3
//            ram[3] = 32'h00400213; // addi x4, x0, 4
//            ram[4] = 32'h00108093; // addi x1, x1, 1
//            ram[5] = 32'h00210113; // addi x2, x2, 2
//            ram[6] = 32'h00318193; // addi x3, x3, 3
//            ram[7] = 32'h00420213; // addi x4, x4, 4
//            ram[8] = 32'h00108093; // addi x1, x1, 1
//            ram[9] = 32'h00210113; // addi x2, x2, 2
//            ram[10] = 32'h00318193; // addi x3, x3, 3
//            ram[11] = 32'h00420213; // addi x4, x4, 4 
            // 连续数据相关指令
//            ram[0] = 32'h00100093; // addi x1, x0, 1
//            ram[1] = 32'h001080b3; // add x1, x1, x1
//            ram[2] = 32'h001080b3; // add x1, x1, x1
//            ram[3] = 32'h001080b3; // add x1, x1, x1
//            ram[4] = 32'h001080b3; // add x1, x1, x1
//            ram[5] = 32'h001080b3; // add x1, x1, x1
//            ram[6] = 32'h001080b3; // add x1, x1, x1
//            ram[7] = 32'h001080b3; // add x1, x1, x1
//            ram[8] = 32'h001080b3; // add x1, x1, x1
//            ram[9] = 32'h001080b3; // add x1, x1, x1
//            ram[10] = 32'h001080b3; // add x1, x1, x1
//            ram[11] = 32'h001080b3; // add x1, x1, x1

        ram[0] <= 32'h01000093;
        ram[1] <= 32'h00000113;
        ram[2] <= 32'h00008193;
        ram[3] <= 32'h00000213;
        ram[4] <= 32'h004102b3;
        ram[5] <= 32'h0002a303;
        ram[6] <= 32'h0042a383;
        ram[7] <= 32'h00734663;
        ram[8] <= 32'h0072a023;
        ram[9] <= 32'h0062a223;
        ram[10] <= 32'h00420213;
        ram[11] <= 32'hfe3242e3;
        ram[12] <= 32'hffc18193;
        ram[13] <= 32'hfc01dce3;
        ram[14] <= 32'h00005063;
        end
    end

    // 读内存
    assign data = ram[addr>>2];
    
endmodule
