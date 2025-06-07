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
// ����ʱ������
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ClockDivider #(  
    parameter integer N = 2  // Ĭ�Ϸ��� 4 ��  
)(  
    input wire clk,          // ԭʼʱ���ź�  
    output reg clk_slow = 1'b0      // �������ʱ���ź�  
    );
  
    // �ڲ�������  
    reg [31:0] counter = 0;  
    
    always @(posedge clk) begin  
        // ��������1  
        counter <= counter + 1'b1;
          
        // ���������ﵽNʱ����תclk_slow�����ü�����  
        if (counter == N - 1) begin
            clk_slow <= ~clk_slow;
            counter <= 0;
        end
    end

endmodule
