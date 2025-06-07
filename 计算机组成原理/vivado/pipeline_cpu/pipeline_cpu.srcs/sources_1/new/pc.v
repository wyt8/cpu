`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 19:38:20
// Design Name: 
// Module Name: PC
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

`include "global.vh"

module PC(
    input clk,
    input rst,

    input stall,                            // 让pc值保持不变

    input [31:0] jump_pc,
    input select,                           // PC选择信号，为 0 且 !stall 表示 pc + 4，为 1 表示选择 jump_pc
    output reg [31:0] pc                    // 下条指令的地址 
    );
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin 
            pc <= `FIRST_PC;
        end
        else begin
        // 这里需要注意优先级：
        // stall 不应该阻塞 jump_pc 导致的 pc 变化
        // 否则会使在控制冒险时，jump_pc在传送时会多一个周期向前传送该不变值
            case(select) 
                1'b0: begin
                    if (stall) begin 
                        pc <= pc;
                    end else begin 
                        pc <= pc + 32'h4;
                    end
                end
                1'b1: begin
                    pc <= jump_pc;
                end
            endcase
        end
    end

endmodule
