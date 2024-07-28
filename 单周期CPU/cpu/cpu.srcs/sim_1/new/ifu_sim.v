`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 23:13:33
// Design Name: 
// Module Name: ifu_sim
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


module ifu_sim();
    reg clk;
    reg rst;
    reg [31:0] pc;
    wire [6:0] op_code;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [31:0] imm;
    
    ifu ifu_sim(
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .op_code(op_code),
        .func3(func3),
        .func7(func7),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm)
    );
    
    initial begin
        clk = 1'b0; #10;
        rst = 1'b0; #10;
        rst = 1'b1; #10;
        pc = 32'b0; #30; 
        $finish;
    end
    
    always #5 clk = ~clk;
endmodule
