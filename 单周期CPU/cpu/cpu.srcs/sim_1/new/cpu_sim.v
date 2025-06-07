`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/30 01:07:55
// Design Name: 
// Module Name: cpu_sim
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


module cpu_sim();
    reg clk;
    reg rst;
    
    cpu cpu_sim(
        .clk(clk),
        .rst(rst)
    );
    
    initial begin
        clk = 1'b0; # 10;
        rst = 1'b0; # 40;
        rst = 1'b1; # 40;
    end
    always #5 clk = ~clk;
endmodule
