`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 16:14:43
// Design Name: 
// Module Name: SortTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 流水线CPU上板测试程序，功能是进行冒泡排序并显示在数码管上
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SortTop(
    input clk,
    input rst,

    output [6:0] led0,          // 7段数码管段选信号
    output [3:0] led0_digit,    // 7段数码管位选信号
    output [6:0] led1,          // 7段数码管段选信号
    output [3:0] led1_digit,    // 7段数码管位选信号
    output overflow_flag        // 溢出指示灯
    );

    wire data_mem_write_enable;
    wire [31:0] data_mem_addr;
    wire [31:0] data_mem_write_data;
    wire [31:0] data_mem_read_data;
    wire [2:0] data_mem_len;
    wire [31:0] inst_mem_read_addr;
    wire [31:0] inst_mem_read_data;

    wire [7:0] addr_0_data;
    wire [7:0] addr_4_data;
    wire [7:0] addr_8_data;
    wire [7:0] addr_12_data;
    wire [7:0] addr_16_data;
    wire [7:0] addr_20_data;
    wire [7:0] addr_24_data;
    wire [7:0] addr_28_data;

    // 周期变为 clk 的 n * 2 倍
    parameter CPU_CLK_PERIOD = 100_0000;
    parameter LED_CLK_PERIOD = 10000;

    wire cpu_clk;
    wire led_clk;
    // 减慢CPU和数码管的时钟周期
    // 减慢CPU时钟周期 -> 方便显示排序过程
    // 减慢数码管时钟周期 -> 实测如果直接使用clk，则显示不正常
    ClockDivider #(.N(CPU_CLK_PERIOD)) cpu_clock_divider(
        .clk(clk),
        .clk_slow(cpu_clk)
    );
    
    ClockDivider #(.N(LED_CLK_PERIOD)) led_clock_divider(
        .clk(clk),
        .clk_slow(led_clk)
    );

    PipelineCPU pipeline_cpu(
        .clk(cpu_clk),
        .rst(rst),
        .inst_mem_read_addr(inst_mem_read_addr),
        .inst_mem_read_data(inst_mem_read_data),
        .data_mem_write_enable(data_mem_write_enable),
        .data_mem_addr(data_mem_addr),
        .data_mem_len(data_mem_len),
        .data_mem_write_data(data_mem_write_data),
        .data_mem_read_data(data_mem_read_data),
        .overflow_flag(overflow_flag)
    );
    
    DataMemory data_mem(
        .clk(cpu_clk),
        .rst(rst),
        .write_enable(data_mem_write_enable),
        .addr(data_mem_addr),
        .len(data_mem_len),
        .write_data(data_mem_write_data),
        .read_data(data_mem_read_data),

        .addr_0_data(addr_0_data),
        .addr_4_data(addr_4_data),
        .addr_8_data(addr_8_data),
        .addr_12_data(addr_12_data),
        .addr_16_data(addr_16_data),
        .addr_20_data(addr_20_data),
        .addr_24_data(addr_24_data),
        .addr_28_data(addr_28_data)
    );
    
    InstructionMemory inst_mem(
        .clk(cpu_clk),
        .rst(rst),
        .addr(inst_mem_read_addr),
        .data(inst_mem_read_data)
    );

    reg [3:0] num0;
    reg [3:0] num1;
    Num2Led num_2_led0(
        .num(num0),
        .led(led0)
    );
    Num2Led num_2_led1(
        .num(num1),
        .led(led1)
    );


    reg [3:0] showing_digit;

    always @(posedge led_clk) begin 
        case(showing_digit)
            4'b0001: begin 
                num0 <= addr_4_data[3:0];
                num1 <= addr_20_data[3:0];
                showing_digit <= 4'b0010;
            end
            4'b0010: begin
                num0 <= addr_8_data[3:0];
                num1 <= addr_24_data[3:0];
                showing_digit <= 4'b0100;
            end
            4'b0100: begin 
                num0 <= addr_12_data[3:0];
                num1 <= addr_28_data[3:0];
                showing_digit <= 4'b1000;
            end
            4'b1000: begin 
                num0 <= addr_0_data[3:0];
                num1 <= addr_16_data[3:0];
                showing_digit <= 4'b0001;
            end
            default: begin
                num0 <= addr_0_data[3:0];
                num1 <= addr_16_data[3:0];
                showing_digit <= 4'b0001;
            end
        endcase
    end

    assign led0_digit = showing_digit;
    assign led1_digit = showing_digit;

endmodule


module DataMemory(
    input clk,
    input rst,
    input write_enable,         // 写使能
    input [31:0] addr,          // 读写内存地址
    input [2:0] len,   
    input [31:0] write_data,    // 写入的数据
    output [31:0] read_data,    // 读出的数据
    // 不同地址处的数据
    output [7:0] addr_0_data,
    output [7:0] addr_4_data,
    output [7:0] addr_8_data,
    output [7:0] addr_12_data,
    output [7:0] addr_16_data,
    output [7:0] addr_20_data,
    output [7:0] addr_24_data,
    output [7:0] addr_28_data
    );
    
    parameter RAM_SIZE = 64;

    reg [7:0] ram[RAM_SIZE-1:0];

    initial begin
        // 向内存中写入数据
        ram[0] <= 8'd8;
        ram[4] <= 8'd7;
        ram[8] <= 8'd6;
        ram[12] <= 8'd5;
        ram[16] <= 8'd4;
        ram[20] <= 8'd3;
        ram[24] <= 8'd2;
        ram[28] <= 8'd1;
    end


    integer i;
    // 为了让内存可以在访存阶段内完成对内存的写操作，这里在clk的下降沿进行写操作
    // 否则会在访存阶段的下一个周期才可以完成对内存的写操作
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // 复位，将每个字节置为0
            for(i = 0; i < RAM_SIZE; i = i + 1)
                ram[i] <= 8'h0;
            // 向内存中写入数据
            ram[0] <= 8'd8;
            ram[4] <= 8'd7;
            ram[8] <= 8'd6;
            ram[12] <= 8'd5;
            ram[16] <= 8'd4;
            ram[20] <= 8'd3;
            ram[24] <= 8'd2;
            ram[28] <= 8'd1;
        end
        else if (write_enable) begin // 写内存
            case (len) 
                3'b000: begin // 8位操作
                    ram[addr] <= write_data[7:0];
                end
                3'b001: begin // 16位操作
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                end
                3'b010: begin // 32位操作
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                    ram[addr+2] <= write_data[23:16];
                    ram[addr+3] <= write_data[31:24];
                end
                default: begin // 默认32位操作
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                    ram[addr+2] <= write_data[23:16];
                    ram[addr+3] <= write_data[31:24];
                end
            endcase
        end
    end

    // 读内存
    assign read_data = {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};

    assign addr_0_data = ram[0];
    assign addr_4_data = ram[4];
    assign addr_8_data = ram[8];
    assign addr_12_data = ram[12];
    assign addr_16_data = ram[16];
    assign addr_20_data = ram[20];
    assign addr_24_data = ram[24];
    assign addr_28_data = ram[28];
    
endmodule

module InstructionMemory(
    input clk,
    input rst,
    input [31:0] addr,          // 读内存地址
    output [31:0] data          // 读出的数据
    );
    
    parameter RAM_SIZE = 32;

    reg [31:0] ram[RAM_SIZE-1:0];

    initial begin 
        // $readmemh("E:/inst_mem.txt", ram);
//    # x1寄存器存放常数 ((8-1)*4)
//    addi %t1, %zero, 28
//    # x2 寄存器存放数组起始内存地址，这里为 0
//    addi x2, x0, 0
//    # x3寄存器存放外层循环变量 i = 28
//    addi x3, x1, 0
//loop:
//    # x4 寄存器存放内层循坏变量 j = 0
//    addi x4, x0, 0
//inner_loop:
//    # x5 寄存器存放当前访问内存数组元素的地址
//    add x5, x2, x4
//    # x6 存放当前访问内存数组元素值
//    lw x6, 0(x5)
//    # x7 存放下一个内存数组元素值
//    lw x7, 4(x5)
//    blt x6, x7, inner_loop_end
//    # 交换两个相邻数组元素
//    sw x7, 0(x5)
//    sw x6, 4(x5)
//inner_loop_end: # 内循环结束处理，j+4
//    addi x4, x4, 4
//    blt x4, x3, inner_loop
//loop_end: # 外循环结束处理，i-4
//    addi x3, x3, -4
//    bge x3, x0, loop

//    # 让程序停止在这里
//finish:
//    bge x0, x0, finish
// 进行冒泡排序，对应的源文件为srot_8num.asm
        ram[0] <= 32'h01c00093;
        ram[1] <= 32'h00000113;
        ram[2] <= 32'h00008193;
        ram[3] <= 32'h00000213;
        ram[4] <= 32'h004102b3;
        ram[5] <= 32'h0002a303;
        ram[6] <= 32'h0042a383;
        ram[7] <= 32'h00734663;
        ram[8] <= 32'h0072a023;
        ram[9] <= 32'h0062a223;
        ram[10] <= 32'h00420213;
        ram[11] <= 32'hfe3242e3;
        ram[12] <= 32'hffc18193;
        ram[13] <= 32'hfc01dce3;
        ram[14] <= 32'h00005063;
    end

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // 复位，将每个字节置为0
            for(i = 0; i < RAM_SIZE; i = i + 1)
                ram[i] <= 32'h0;
            // $readmemh("E:/inst_mem.txt", ram);
            ram[0] <= 32'h01c00093;
            ram[1] <= 32'h00000113;
            ram[2] <= 32'h00008193;
            ram[3] <= 32'h00000213;
            ram[4] <= 32'h004102b3;
            ram[5] <= 32'h0002a303;
            ram[6] <= 32'h0042a383;
            ram[7] <= 32'h00734663;
            ram[8] <= 32'h0072a023;
            ram[9] <= 32'h0062a223;
            ram[10] <= 32'h00420213;
            ram[11] <= 32'hfe3242e3;
            ram[12] <= 32'hffc18193;
            ram[13] <= 32'hfc01dce3;
            ram[14] <= 32'h00005063;
        end
    end

    // 读内存
    assign data = ram[addr>>2];
    
endmodule

// 放慢时钟周期
module ClockDivider #(  
    parameter integer N = 2  // 默认放慢2倍  
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


// 将输入的数字转换为数码管对应的编码
module Num2Led(
    input [3:0] num,
    // 从高到低对应 A -> G
    output reg [6:0] led
    );
    always @(*) begin
        case(num)
            0: begin 
                led <= 7'b111_1110;
            end
            1: begin 
                led <= 7'b011_0000;
            end
            2: begin 
                led <= 7'b110_1101;
            end
            3: begin 
                led <= 7'b111_1001;
            end 
            4: begin 
                led <= 7'b011_0011;
            end
            5: begin 
                led <= 7'b101_1011;
            end
            6: begin 
                led <= 7'b101_1111;
            end
            7: begin 
                led <= 7'b111_0000;
            end
            8: begin 
                led <= 7'b111_1111;
            end
            9: begin 
                led <= 7'b111_1011;
            end
            // A
            10: begin
                led <= 7'b111_0111;
            end
            // b
            11: begin 
                led <= 7'b001_1111;
            end
            // c
            12: begin 
                led <= 7'b000_1101;
            end
            // d
            13: begin
                led <= 7'b011_1101; 
            end
            // E
            14: begin 
                led <= 7'b100_1111;
            end
            // F
            15: begin
                led <= 7'b100_0111;
            end
        endcase
    end                 
endmodule