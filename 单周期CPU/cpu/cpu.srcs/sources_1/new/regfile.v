`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 12:55:48
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input rst,
    input write_enable,     // Ğ´Ê¹ÄÜ
    input [4:0] ra_addr,    // ¶Á¼Ä´æÆ÷AµØÖ·
    input [4:0] rb_addr,    // ¶Á¼Ä´æÆ÷BµØÖ·
    input [4:0] rw_addr,    // Ğ´¼Ä´æÆ÷µØÖ·
    
    input [31:0] rw_data,   // Ğ´¼Ä´æÆ÷Ê±Êı¾İ
    output [31:0]  ra_data, // ¶Á¼Ä´æÆ÷AÊ±Êı¾İ
    output [31:0] rb_data   // ¶Á¼Ä´æÆ÷BÊ±Êı¾İ
    );
    // ¼Ä´æÆ÷¶Ñ
    reg [31:0] regs[31:0];

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // ¸´Î»£¬½«Ã¿¸ö¼Ä´æÆ÷ÖÃÎª0
            for(i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (write_enable) // Ğ´¼Ä´æÆ÷
            regs[rw_addr] = rw_data;
    end

    // ¶Á¼Ä´æÆ÷
    assign ra_data = regs[ra_addr];
    assign rb_data = regs[rb_addr];
endmodule

