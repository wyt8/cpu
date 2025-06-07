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
// ��ˮ��CPU�ϰ���Գ��򣬹����ǽ���ð��������ʾ���������
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

    output [6:0] led0,          // 7������ܶ�ѡ�ź�
    output [3:0] led0_digit,    // 7�������λѡ�ź�
    output [6:0] led1,          // 7������ܶ�ѡ�ź�
    output [3:0] led1_digit,    // 7�������λѡ�ź�
    output overflow_flag        // ���ָʾ��
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

    // ���ڱ�Ϊ clk �� n * 2 ��
    parameter CPU_CLK_PERIOD = 100_0000;
    parameter LED_CLK_PERIOD = 10000;

    wire cpu_clk;
    wire led_clk;
    // ����CPU������ܵ�ʱ������
    // ����CPUʱ������ -> ������ʾ�������
    // ���������ʱ������ -> ʵ�����ֱ��ʹ��clk������ʾ������
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
    input write_enable,         // дʹ��
    input [31:0] addr,          // ��д�ڴ��ַ
    input [2:0] len,   
    input [31:0] write_data,    // д�������
    output [31:0] read_data,    // ����������
    // ��ͬ��ַ��������
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
        // ���ڴ���д������
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
    // Ϊ�����ڴ�����ڷô�׶�����ɶ��ڴ��д������������clk���½��ؽ���д����
    // ������ڷô�׶ε���һ�����ڲſ�����ɶ��ڴ��д����
    always @(negedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ÿ���ֽ���Ϊ0
            for(i = 0; i < RAM_SIZE; i = i + 1)
                ram[i] <= 8'h0;
            // ���ڴ���д������
            ram[0] <= 8'd8;
            ram[4] <= 8'd7;
            ram[8] <= 8'd6;
            ram[12] <= 8'd5;
            ram[16] <= 8'd4;
            ram[20] <= 8'd3;
            ram[24] <= 8'd2;
            ram[28] <= 8'd1;
        end
        else if (write_enable) begin // д�ڴ�
            case (len) 
                3'b000: begin // 8λ����
                    ram[addr] <= write_data[7:0];
                end
                3'b001: begin // 16λ����
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                end
                3'b010: begin // 32λ����
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                    ram[addr+2] <= write_data[23:16];
                    ram[addr+3] <= write_data[31:24];
                end
                default: begin // Ĭ��32λ����
                    ram[addr] <= write_data[7:0];
                    ram[addr+1] <= write_data[15:8];
                    ram[addr+2] <= write_data[23:16];
                    ram[addr+3] <= write_data[31:24];
                end
            endcase
        end
    end

    // ���ڴ�
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
    input [31:0] addr,          // ���ڴ��ַ
    output [31:0] data          // ����������
    );
    
    parameter RAM_SIZE = 32;

    reg [31:0] ram[RAM_SIZE-1:0];

    initial begin 
        // $readmemh("E:/inst_mem.txt", ram);
//    # x1�Ĵ�����ų��� ((8-1)*4)
//    addi %t1, %zero, 28
//    # x2 �Ĵ������������ʼ�ڴ��ַ������Ϊ 0
//    addi x2, x0, 0
//    # x3�Ĵ���������ѭ������ i = 28
//    addi x3, x1, 0
//loop:
//    # x4 �Ĵ�������ڲ�ѭ������ j = 0
//    addi x4, x0, 0
//inner_loop:
//    # x5 �Ĵ�����ŵ�ǰ�����ڴ�����Ԫ�صĵ�ַ
//    add x5, x2, x4
//    # x6 ��ŵ�ǰ�����ڴ�����Ԫ��ֵ
//    lw x6, 0(x5)
//    # x7 �����һ���ڴ�����Ԫ��ֵ
//    lw x7, 4(x5)
//    blt x6, x7, inner_loop_end
//    # ����������������Ԫ��
//    sw x7, 0(x5)
//    sw x6, 4(x5)
//inner_loop_end: # ��ѭ����������j+4
//    addi x4, x4, 4
//    blt x4, x3, inner_loop
//loop_end: # ��ѭ����������i-4
//    addi x3, x3, -4
//    bge x3, x0, loop

//    # �ó���ֹͣ������
//finish:
//    bge x0, x0, finish
// ����ð�����򣬶�Ӧ��Դ�ļ�Ϊsrot_8num.asm
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
        if (!rst) begin // ��λ����ÿ���ֽ���Ϊ0
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

    // ���ڴ�
    assign data = ram[addr>>2];
    
endmodule

// ����ʱ������
module ClockDivider #(  
    parameter integer N = 2  // Ĭ�Ϸ���2��  
)(  
    input wire clk,          // ԭʼʱ���ź�  
    output reg clk_slow = 1'b0      // �������ʱ���ź�  
    );
  
    // �ڲ�������  
    reg [31:0] counter = 0;  
    
    always @(posedge clk) begin  
        // ��������1  
        counter <= counter + 1'b1;
          
        // ���������ﵽNʱ����תclk_slow�����ü�����  
        if (counter == N - 1) begin
            clk_slow <= ~clk_slow;
            counter <= 0;
        end
    end

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