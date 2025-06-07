`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/28 23:14:44
// Design Name: 
// Module Name: sim
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


module sim();
    reg [31:0] num1, num2;
    reg [3:0] select;
    wire [31:0] res;
    wire sf, cf, zf, of, pf;
    alu alu_sim(
        .num1(num1),
        .num2(num2),
        .select(select),
        .res(res),
        .sf(sf),
        .cf(cf),
        .zf(zf),
        .of(of),
        .pf(pf)
    );
    initial
    begin
        select = 4'b0000; num1 = 32'h8000_0000; num2 = 32'h8000_0000; #100; // 加
        select = 4'b0001; num1 = 32'h8000_0000; num2 = 32'h0000_0001; #100; // 减
        select = 4'b0010; num1 = 32'h0000_00FF; num2 = 32'h0000_00F0; #100; // 与
        select = 4'b0011; num1 = 32'h0000_00F0; num2 = 32'h0000_000F; #100; // 或
        select = 4'b0100; num1 = 32'h0000_00FF; num2 = 32'h0000_000F; #100; // 异或
        select = 4'b0101; num1 = 32'h0000_0000; num2 = 32'h0000_000F; #100; // 或非
        select = 4'b0110; num1 = 32'h0000_0001; num2 = 32'h0000_000C; #100; // 左移
        select = 4'b0111; num1 = 32'h0000_1000; num2 = 32'h0000_000C; #100; // 右移
    end
    

endmodule
