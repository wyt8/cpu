`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 19:14:40
// Design Name: 
// Module Name: ClockDivider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 放慢时钟周期
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ClockDivider #(  
    parameter integer N = 2  // 默认放慢 4 倍  
)(  
    input wire clk,          // 原始时钟信号  
    output reg clk_slow = 1'b0      // 放慢后的时钟信号  
    );
  
    // 内部计数器  
    reg [31:0] counter = 0;  
    
    always @(posedge clk) begin  
        // 计数器加1  
        counter <= counter + 1'b1;
          
        // 当计数器达到N时，翻转clk_slow并重置计数器  
        if (counter == N - 1) begin
            clk_slow <= ~clk_slow;
            counter <= 0;
        end
    end

endmodule
