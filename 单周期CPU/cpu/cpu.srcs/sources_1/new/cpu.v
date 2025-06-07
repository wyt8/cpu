`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/30 00:33:27
// Design Name: 
// Module Name: cpu
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


module cpu(
    input clk,  // 时钟信号
    input rst   // 置位信号
    );

    wire reg_write_enable;
    wire [4:0] ra_addr;
    wire [4:0] rb_addr;
    wire [4:0] rw_addr;
    wire [31:0] rw_data;
    wire [31:0] ra_data;
    wire [31:0] rb_data;
    wire mem_write_enable;
    wire [31:0] mem_read_data;
    wire [31:0] alu_num2;
    wire [3:0] alu_select;
    wire [31:0] alu_res;
    wire flag;
    wire [6:0] op_code;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [31:0] imm;
    wire num2_src, mem_to_reg;
    wire [31:0] pc_value;

    reg regfile_clk, data_memory_clk, alu_clk, ifu_clk, pc_clk;
    integer i = 0;
    
    always @(posedge clk) begin
        if (rst == 1) begin
            if (i == 0) begin
                ifu_clk = 1;
                i = i + 1;
            end
            else if (i == 1) begin
                alu_clk = 1;
                i = i + 1;
            end
            else if (i == 2) begin
                regfile_clk = 1;
                data_memory_clk = 1;
                i = i + 1;
            end
            else if (i == 3) begin
                pc_clk = 1;
                i = 0;
            end
        end
    end
    
    always @(negedge clk) begin
        regfile_clk = 0;
        data_memory_clk = 0;
        alu_clk = 0;
        ifu_clk = 0;
        pc_clk = 0;
    end

    // 实例化各模块
    // 寄存器堆
    regfile RegFile(
        .clk(regfile_clk),
        .rst(rst),
        .write_enable(reg_write_enable),
        .ra_addr(ra_addr),
        .rb_addr(rb_addr),
        .rw_addr(rw_addr),
        .rw_data(rw_data),
        .ra_data(ra_data),
        .rb_data(rb_data)
    );
    // 数据内存
    data_memory DataMemory(
        .clk(data_memory_clk),
        .rst(rst),
        .write_enable(mem_write_enable),
        .addr(alu_res),
        .write_data(rb_data),
        .read_data(mem_read_data)
    );
    // 算数逻辑单元
    alu ALU(
        .clk(alu_clk),
        .rst(rst),
        .num1(ra_data),
        .num2(alu_num2),
        .select(alu_select),
        .res(alu_res),
        .flag(flag)
    );
    // 取指单元
    ifu IFU(
        .clk(ifu_clk),
        .rst(rst),
        .pc(pc_value),
//        .flag(flag),
        .op_code(op_code),
        .func3(func3),
        .func7(func7),
        .rd(rw_addr),
        .rs1(ra_addr),
        .rs2(rb_addr),
        .imm(imm)
    );
    // 控制单元
    cu CU(
        .op_code(op_code),
        .func3(func3),
        .func7(func7),
        .num2_src(num2_src),
        .mem_to_reg(mem_to_reg),
        .reg_write_enable(reg_write_enable),
        .mem_write_enable(mem_write_enable),
        .alu_select(alu_select)
    );
    
    // PC
    pc PC(
        .clk(pc_clk),
        .rst(rst),
        .flag(flag),
        .imm(imm),
        .new_pc(pc_value)
    );

    assign alu_num2 = num2_src ? imm : rb_data;
    assign rw_data = mem_to_reg ? mem_read_data : alu_res;
endmodule
