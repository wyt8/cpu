`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 19:55:45
// Design Name: 
// Module Name: data_memory_sim
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


module data_memory_sim();
    reg clk;
    reg rst;
    reg write_enable;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;
    
    data_memory data_memory_sim(
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    initial begin
        clk = 1'b0; #10;
        rst = 1'b0; #10;
        rst = 1'b1; #10;
        addr = 32'h00000_0000; write_data = 32'h0000_1234; write_enable = 1'b1; #10;
        write_enable = 1'b0; #10;
        addr = 32'b00000_0000;;
        $finish;
    end
    
    always #5 clk = ~clk;
endmodule
