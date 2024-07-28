`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 16:24:01
// Design Name: 
// Module Name: alu_sim
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


module alu_sim();
    reg clk;
    reg rst;
    reg [31:0] num1;
    reg [31:0] num2;
    reg [3:0] select;
    wire [31:0] res;
    wire flag;

    alu alu_sim(
        .clk(clk),
        .rst(rst),
        .num1(num1),
        .num2(num2),
        .select(select),
        .flag(flag),
        .res(res)
    );

    initial begin
        clk = 1'b0; #10;
        rst = 1'b0; #10;
        rst = 1'b1; #10;
        select = 4'b0000; num1 = 32'h8000_0000; num2 = 32'h8000_0000; # 10;
        $finish;
    end

    always #5 clk = ~clk;
endmodule
