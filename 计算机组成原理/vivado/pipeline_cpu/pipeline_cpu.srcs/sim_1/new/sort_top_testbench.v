`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 19:05:29
// Design Name: 
// Module Name: SortTopTestbench
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


module SortTopTestbench();
    reg clk;
    reg rst;
    wire [6:0] led0, led1;
    wire [3:0] led0_digit, led1_digit;
    wire overflow_flag;
    
    SortTop sort_top(
        .clk(clk),
        .rst(rst),
        .led0(led0),
        .led1(led1),
        .led0_digit(led0_digit),
        .led1_digit(led1_digit),
        .overflow_flag(overflow_flag)
    );
    
    initial begin
        clk = 1'b0;
        rst = 1'b0; #10;
        rst = 1'b1;
        # 500;
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
