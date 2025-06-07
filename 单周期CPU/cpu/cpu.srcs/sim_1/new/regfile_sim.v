`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 15:04:26
// Design Name: 
// Module Name: regfile_sim
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


module regfile_sim();
    reg clk;
    reg rst;
    reg write_enable;
    reg [4:0] ra_addr;
    reg [4:0] rb_addr;
    reg [4:0] rw_addr;
    
    reg [31:0] rw_data;
    wire [31:0] ra_data;
    wire [31:0] rb_data;
    
    regfile regfile_sim(
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .ra_addr(ra_addr),
        .rb_addr(rb_addr),
        .rw_addr(rw_addr),
        .ra_data(ra_data),
        .rb_data(rb_data),
        .rw_data(rw_data)
    );
    
    initial begin
        clk = 1'b0; #10;
        rst = 1'b0; #10;
        rst = 1'b1; #10;
        rw_addr = 5'b00000; rw_data = 32'h0000_1234; write_enable = 1'b1; #10;
        rw_addr = 5'b00001; rw_data = 32'h0000_4321; write_enable = 1'b1; #10;
        write_enable = 1'b0; #10;
        ra_addr = 5'b00000; rb_addr = 5'b00001; #10;
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
