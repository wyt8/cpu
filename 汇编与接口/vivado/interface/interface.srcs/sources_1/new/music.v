`timescale 1ns / 1ps

module music(
    input clk,
    input rstn,
    // 音乐控制信号
    input playing,
    input restart,
    // 输入音乐到内部存储
    input w_en,
    input [7:0] w_data,
    input [7:0] w_addr,
    output buzzer_out
    );

    // 内存中存储的音乐信息
    reg [7:0] music_memory [0:128]; 
     // 初始化音乐内存（初始为1首音乐）
    initial begin
        music_memory[0] = 8'd64;

        music_memory[1] = 6'b01_1010; //l6
        music_memory[2] = 6'b01_1100; //l7
        music_memory[3] = 6'b10_0001; //m1
        music_memory[4] = 6'b10_0011; //m2
        music_memory[5] = 6'b10_0101; //m3
        music_memory[6] = 6'b10_0101; //m3
        music_memory[7] = 6'b10_1010; //m6
        music_memory[8] = 6'b10_1000; //m5

        music_memory[9] = 6'b10_0101; //m3
        music_memory[10] = 6'b10_0101; //m3
        music_memory[11] = 6'b01_1010; //l6
        music_memory[12] = 6'b01_1010; //l6
        music_memory[13] = 6'b10_0101; //m3
        music_memory[14] = 6'b10_0011; //m2
        music_memory[15] = 6'b10_0001; //m1
        music_memory[16] = 6'b01_1100; //l7

        music_memory[17] = 6'b01_1010; //l6
        music_memory[18] = 6'b01_1100; //l7
        music_memory[19] = 6'b10_0001; //m1
        music_memory[20] = 6'b10_0011; //m2
        music_memory[21] = 6'b10_0101; //m3
        music_memory[22] = 6'b10_0101; //m3
        music_memory[23] = 6'b10_0011; //m2
        music_memory[24] = 6'b10_0001; //m1

        music_memory[25] = 6'b01_1100; //l7
        music_memory[26] = 6'b01_1010; //l6
        music_memory[27] = 6'b01_1100; //l7
        music_memory[28] = 6'b10_0001; //m1
        music_memory[29] = 6'b01_1100; //l7
        music_memory[30] = 6'b01_1010; //l6
        music_memory[31] = 6'b01_1001; //l5s
        music_memory[32] = 6'b01_1100; //l7

        music_memory[33] = 6'b01_1010; //l6
        music_memory[34] = 6'b01_1100; //l7
        music_memory[35] = 6'b10_0001; //m1
        music_memory[36] = 6'b10_0011; //m2
        music_memory[37] = 6'b10_0101; //m3
        music_memory[38] = 6'b10_0101; //m3
        music_memory[39] = 6'b10_1010; //m6
        music_memory[40] = 6'b10_1000; //m5

        music_memory[41] = 6'b10_0101; 
        music_memory[42] = 6'b10_0101; 
        music_memory[43] = 6'b01_1010; 
        music_memory[44] = 6'b01_1010; 
        music_memory[45] = 6'b10_0101; 
        music_memory[46] = 6'b10_0011; 
        music_memory[47] = 6'b10_0001; 
        music_memory[48] = 6'b01_1100; 

        music_memory[49] = 6'b01_1010; 
        music_memory[50] = 6'b01_1100; 
        music_memory[51] = 6'b10_0001; 
        music_memory[52] = 6'b10_0011; 
        music_memory[53] = 6'b10_0101; 
        music_memory[54] = 6'b10_0101; 
        music_memory[55] = 6'b10_0011; 
        music_memory[56] = 6'b10_0001; 
        
        music_memory[57] = 6'b01_1100; //l7 
        music_memory[58] = 6'b01_1100; //l7 
        music_memory[59] = 6'b10_0001; //m1
        music_memory[60] = 6'b10_0001; //m1
        music_memory[61] = 6'b10_0011; //m2
        music_memory[62] = 6'b10_0011; //m2
        music_memory[63] = 6'b10_0101; //m3
        music_memory[64] = 6'b10_0101; //m3
    end

    // 音乐播放控制信号
    reg [7:0] music_index; // 当前播放的音乐索引
    reg [7:0] song_start_index; // 当前歌曲的起始索引
    reg [7:0] song_end_index; // 当前歌曲的结束索引
    // 读取音乐内存中的数据
    reg [1:0] level;
    reg [3:0] tone;
    // 计时器相关
    reg [32:0] timer; // 计数器，计数??5000万个时钟周期??0.5秒）

    // 控制逻辑
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            music_index <= 1;
            song_start_index <= 1;
            song_end_index <= 64;

            level <= 0;
            tone <= 0;
            timer <= 0;
        end
        else if (restart) begin
            song_end_index <= music_memory[0];
            music_index <= song_start_index;
        end
        else if (w_en) begin
            music_memory[w_addr] <= w_data;
        end
        else if (timer >= 31'd2500_0000) begin
            timer <= 0;
            if (playing) begin
                if (music_index > song_end_index) begin
                    music_index <= song_start_index; // 播放结束，循环播放当前歌
                end
                else begin
                    level <= music_memory[music_index][5:4];
                    tone <= music_memory[music_index][3:0];
                    music_index <= music_index + 1;
                end
            end
            else begin
                level <= 0;
                tone <= 0;
                music_index <= music_index;
            end
        end
        else begin
            timer <= timer + 1;
        end
    end

    // 实例化蜂鸣器模块
    buzzer buzzer_inst (
        .clk(clk),
        .rstn(rstn),
        .level(level),
        .tone(tone),
        .buzzer_out(buzzer_out)
    );

endmodule