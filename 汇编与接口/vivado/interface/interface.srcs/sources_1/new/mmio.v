`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/31 23:28:45
// Design Name: 
// Module Name: MMIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 统一编址，通过load和store指令来操作外设
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MMIO(
    input clk,
    input rst,
    input write_enable,             // 写使能
    input [31:0] addr,              // 读写内存地址
    input [2:0] len,                // 读写的长度 byte0 / half1 / word2 / u_byte4 / u_half5

    input [31:0] write_data,        // 写入的数据
    output reg [31:0] read_data,        // 读出的数据
    output reg [31:0] display_data,     // 7 段数码管显示的数据
    
    // 连接外设的端口
    input [5:0] button,             // 6个游戏按键
    output reg [7:0] lcd_data,      // 从高位到低位对应 LCD 的 LCD_D7 ~ LCD_D0 原理图标号
    output reg [4:0] lcd_control,   // 从高位到低位对应 LCD 的 LCD_RS LCD_RST LCD_CS LCD_RD LCD_WR 原理图标号
    output reg [7:0] led,           // 8个led灯，从高位到低位分别对应 LED7 ~ LED0 原理图标号
    output buzzer                   // 蜂鸣器
    );

    // 内存映射
    parameter DATA_MEM_START = 32'h0001_0000;
    parameter DATA_MEM_END = 32'h0001_4000;
    parameter LCD_DATA_ADDR = 32'hffff_0000;
    parameter LCD_CONTROL_WR_ADDR = 32'hffff_0004;
    parameter LCD_CONTROL_RD_ADDR = 32'hffff_0008;
    parameter LCD_CONTROL_CS_ADDR = 32'hffff_000c;
    parameter LCD_CONTROL_RST_ADDR = 32'hffff_0010;
    parameter LCD_CONTROL_RS_ADDR = 32'hffff_0014;
    parameter LED_ADDR = 32'hffff_1000;
    parameter BUTTON_ADDR = 32'hffff_2000;
    parameter CLK_ADDR = 32'hffff_3000;
    parameter DISPLAY_ADDR = 32'hffff_4000;
    parameter MUSIC_CONTROL_ADDR = 32'hffff_5000;


    wire [31:0] data_mem_read_data;
    wire data_mem_write_enable;
    // 映射到程序的内存空间，用于显示CPU上电后的周期数
    (*DONT_TOUCH="YES"*) reg [31:0] clk_counter;

    DataMem data_mem(
        .clk(clk),
        .write_enable(data_mem_write_enable),
        .addr((addr - DATA_MEM_START)),
        .len(len),
        .write_data(write_data),
        .read_data(data_mem_read_data)
    );
    
    // 音乐控制寄存器，包括en、addr、dat和ctrl（playing、restart）
    reg [20:0] music_control_reg;
    // 消抖后的按键信息
    reg [5:0] button_reg;

    music music_inst(
        .clk(clk),
        .rstn(rst),
        // 音乐控制信号
        .playing(music_control_reg[0]),
        .restart(music_control_reg[1]),
        // 输入音乐到内部存储
        .w_en(music_control_reg[20]),
        .w_data(music_control_reg[11:4]),
        .w_addr(music_control_reg[19:12]),
        // 输出音乐到外部
        .buzzer_out(buzzer)
    );

    assign data_mem_write_enable = (write_enable && addr >= DATA_MEM_START && addr < DATA_MEM_END) ? 1'b1 :1'b0;

    always @(posedge clk or negedge rst) begin 
        if(!rst) begin 
            lcd_data <= 8'h0;
            lcd_control <= 5'h0;
            led <= 8'h0;
            clk_counter <= 32'h0;
            display_data <= 32'h0;
            
            music_control_reg <= 21'h0;
            button_reg <= 6'h0;
          
        end else begin
            clk_counter <= clk_counter + 1'b1;
            
            if (button != 6'h0) begin 
                button_reg <= button_reg | button;
            end
            
            if(write_enable) begin                
//                if (addr >= DATA_MEM_START && addr < DATA_MEM_END) begin 
//                    data_mem_write_enable <= 1'b1;
//                end
                // 外设寄存器映射的写操作
                if (addr == LCD_DATA_ADDR) begin
                    lcd_data <= write_data[7:0];
                end 
                else if(addr == LCD_CONTROL_WR_ADDR) begin
                    lcd_control[0] <= write_data[0];
                end
                else if(addr == LCD_CONTROL_RD_ADDR) begin
                    lcd_control[1] <= write_data[0];
                end
                else if(addr == LCD_CONTROL_CS_ADDR) begin
                    lcd_control[2] <= write_data[0];
                end
                else if(addr == LCD_CONTROL_RST_ADDR) begin
                    lcd_control[3] <= write_data[0];
                end
                else if(addr == LCD_CONTROL_RS_ADDR) begin
                    lcd_control[4] <= write_data[0];
                end
                else if (addr == LED_ADDR) begin 
                    led <= write_data[7:0];
                end
                else if (addr == DISPLAY_ADDR) begin 
                    display_data <= write_data;
                end 
                else if (addr == MUSIC_CONTROL_ADDR) begin 
                    music_control_reg <= write_data[20:0]; //21位控制码，包含了音乐信息和地址
                end 
                else if (addr == BUTTON_ADDR) begin 
                    button_reg <= write_data[5:0];
                end
            end
        end
    end

    // 外设寄存器映射的读操作 和 数据内存的读写操作
    always @(*) begin
        if(addr >= DATA_MEM_START && addr < DATA_MEM_END) begin 
            read_data <= data_mem_read_data;
        end
        else if (addr == LCD_DATA_ADDR) begin 
            read_data <= {24'b0, lcd_data};
        end
        else if (addr == LED_ADDR) begin 
            read_data <= {24'b0, led};
        end
        else if (addr == BUTTON_ADDR) begin 
            read_data <= {26'b0, button};
        end
        else if (addr == CLK_ADDR) begin 
            read_data <= clk_counter;
        end 
        else if (addr == DISPLAY_ADDR) begin 
            read_data <= display_data;
        end
        else if (addr == MUSIC_CONTROL_ADDR) begin 
            read_data <= {11'b0, music_control_reg};
        end 
        else if (addr == BUTTON_ADDR) begin 
            read_data <= {26'b0, button_reg};
        end
        else begin 
            read_data <= 32'h0;
        end
    end

endmodule
