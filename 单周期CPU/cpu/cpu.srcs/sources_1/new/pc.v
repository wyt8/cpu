`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/01 10:14:43
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input rst,
    input flag,
    input signed [31:0] imm,
    output [31:0] new_pc
    );
    reg [31:0] pc_value;
    always @(posedge clk or negedge rst) begin
        if(!rst) 
            pc_value = 32'b0;
        else begin 
            // ¸Ä±äpc
            if (flag) begin
                pc_value = pc_value + $signed(imm >>> 2);
            end
            else
                pc_value = pc_value + 32'b1;
            $display("pc: %d", pc_value);
        end
    end
    assign new_pc = pc_value;
endmodule
