
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/01 09:54:48
// Design Name: 
// Module Name: PlayerTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// ���ֲ������Ķ���ģ��
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PlayerTop(
    input clk,
    input rst,

    // ��������Ķ˿�
    input [5:0] button,             // 6����Ϸ����
    output [7:0] lcd_data,          // �Ӹ�λ����λ��Ӧ LCD �� LCD_D7 ~ LCD_D0 ԭ��ͼ���
    output [4:0] lcd_control,       // �Ӹ�λ����λ��Ӧ LCD �� LCD_RS LCD_RST LCD_CS LCD_RD LCD_WR ԭ��ͼ���
    output [7:0] led,               // 8��led�ƣ��Ӹ�λ����λ�ֱ��Ӧ LED7 ~ LED0 ԭ��ͼ���
    output buzzer,                  // ������
    output [6:0] led0,          // 7������ܶ�ѡ�ź�
    output [3:0] led0_digit,    // 7�������λѡ�ź�
    output [6:0] led1,          // 7������ܶ�ѡ�ź�
    output [3:0] led1_digit    // 7�������λѡ�ź�
    );

    wire data_mem_write_enable;
    wire [31:0] data_mem_addr;
    wire [2:0] data_mem_len;
    wire [31:0] data_mem_write_data;
    wire [31:0] data_mem_read_data;
    wire [31:0] inst_mem_read_addr;
    wire [31:0] inst_mem_read_data;
    wire overflow_flag;
    wire [31:0] display_data;
    
    wire cpu_clk;
    ClockDivider #(.N(2)) cpu_clock_divider(
        .clk(clk),
        .clk_slow(cpu_clk)
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

    MMIO mmio(
        .clk(clk),
        .rst(rst),
        .write_enable(data_mem_write_enable),
        .addr(data_mem_addr),
        .len(data_mem_len),
        .write_data(data_mem_write_data),
        .read_data(data_mem_read_data),
        .display_data(display_data),
        
        .button(button),
        .lcd_data(lcd_data),
        .lcd_control(lcd_control),
        .led(led),
        .buzzer(buzzer)
    );
    
    InstMem inst_mem (
      .clka(clk),    // input wire clka
      .addra(inst_mem_read_addr),  // input wire [31 : 0] addra
      .douta(inst_mem_read_data)  // output wire [31 : 0] douta
    );
    
    // ���ڱ�Ϊ clk �� n * 2 ��
    parameter LED_CLK_PERIOD = 10000;

    wire led_clk;
    ClockDivider #(.N(LED_CLK_PERIOD)) led_clock_divider(
        .clk(clk),
        .clk_slow(led_clk)
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
                num0 <= display_data[7:4];
                num1 <= display_data[23:20];
                showing_digit <= 4'b0010;
            end
            4'b0010: begin
                num0 <= display_data[11:8];
                num1 <= display_data[27:24];
                showing_digit <= 4'b0100;
            end
            4'b0100: begin 
                num0 <= display_data[15:12];
                num1 <= display_data[31:28];
                showing_digit <= 4'b1000;
            end
            4'b1000: begin 
                num0 <= display_data[3:0];
                num1 <= display_data[19:16];
                showing_digit <= 4'b0001;
            end
            default: begin
                num0 <= display_data[3:0];
                num1 <= display_data[19:16];
                showing_digit <= 4'b0001;
            end
        endcase
    end

    assign led0_digit = showing_digit;
    assign led1_digit = showing_digit;
endmodule

// �����������ת��Ϊ����ܶ�Ӧ�ı���
module Num2Led(
    input [3:0] num,
    // �Ӹߵ��Ͷ�Ӧ A -> G
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
