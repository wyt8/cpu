`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 15:38:17
// Design Name: 
// Module Name: PlayerTopTestbench
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


module PlayerTopTestbench();
    reg clk;
    reg rst;
    wire [6:0] led0, led1;
    wire [3:0] led0_digit, led1_digit;
    wire overflow_flag;
    wire [7:0] led;
    wire [4:0] lcd_control;
    wire [7:0] lcd_data;
    reg [5:0] button;
    wire buzzer;
    
    PlayerTop player_top(
        .clk(clk),
        .rst(rst),
        .button(button),
        .lcd_data(lcd_data),
        .lcd_control(lcd_control),
        .led(led),
        .buzzer(buzzer),
        .led0(led0),
        .led1(led1),
        .led0_digit(led0_digit),
        .led1_digit(led1_digit)
    );
    
    initial begin
        clk = 1'b0;
        button = 5'b0;
        rst = 1'b0; #10;
        rst = 1'b1;
        # 500;
        $finish;
    end
    
    always #5 clk = ~clk;
endmodule
