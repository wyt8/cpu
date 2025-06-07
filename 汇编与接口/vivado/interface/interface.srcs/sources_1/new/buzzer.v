`timescale 1ns / 1ps

module buzzer(
    input clk,
    input rstn,
    input [1:0]level, // 0: off, 1: low, 2: medium, 3: high
    input [3:0]tone, // 0: off, 1: C, 2: D, 3: E, 4: F, 5: G, 6: A, 7: B
    output buzzer_out
    );

    reg pwm; // output of the buzzer
    reg state; // state of the buzzer (1: on, 0: off)
    reg [31:0]cnt; // counter for the tone (number of clock cycles)
    reg [31:0]half_t_clk; // half period of the tone (number of clock cycles)

    parameter C5 = 95556;
    parameter C5s = 90155;
    parameter D5 = 85131;
    parameter D5s = 80345;
    parameter E5 = 75873;
    parameter F5 = 71586;
    parameter F5s = 67627;
    parameter G5 = 63776;
    parameter G5s = 60172;
    parameter A5 = 56818;
    parameter A5s = 53654;
    parameter B5 = 50619;


    always@(posedge clk or negedge rstn) begin
        if (~rstn) begin
            state <= 0;
            half_t_clk <= 0; 
        end
        else if (level != 2'b0 && tone != 4'b0)begin
            state <= 1;
            if (level == 2'b01) begin
                case (tone)
                    4'b0001: half_t_clk <= C5*2;
                    4'b0010: half_t_clk <= C5s*2;
                    4'b0011: half_t_clk <= D5*2;
                    4'b0100: half_t_clk <= D5s*2;
                    4'b0101: half_t_clk <= E5*2;
                    4'b0110: half_t_clk <= F5*2;
                    4'b0111: half_t_clk <= F5s*2;
                    4'b1000: half_t_clk <= G5*2;
                    4'b1001: half_t_clk <= G5s*2;
                    4'b1010: half_t_clk <= A5*2;
                    4'b1011: half_t_clk <= A5s*2;
                    4'b1100: half_t_clk <= B5*2;
                    default: half_t_clk <= 0;
                endcase
            end
            else if (level == 2'b10) begin
                case (tone)
                    4'b0001: half_t_clk <= C5;
                    4'b0010: half_t_clk <= C5s;
                    4'b0011: half_t_clk <= D5;
                    4'b0100: half_t_clk <= D5s;
                    4'b0101: half_t_clk <= E5;
                    4'b0110: half_t_clk <= F5;
                    4'b0111: half_t_clk <= F5s;
                    4'b1000: half_t_clk <= G5;
                    4'b1001: half_t_clk <= G5s;
                    4'b1010: half_t_clk <= A5;
                    4'b1011: half_t_clk <= A5s;
                    4'b1100: half_t_clk <= B5;
                    default: half_t_clk <= 0;
                endcase
            end
            else if (level == 2'b11) begin
                case (tone)
                    4'b0001: half_t_clk <= C5/2;
                    4'b0010: half_t_clk <= C5s/2;
                    4'b0011: half_t_clk <= D5/2;
                    4'b0100: half_t_clk <= D5s/2;
                    4'b0101: half_t_clk <= E5/2;
                    4'b0110: half_t_clk <= F5/2;
                    4'b0111: half_t_clk <= F5s/2;
                    4'b1000: half_t_clk <= G5/2;
                    4'b1001: half_t_clk <= G5s/2;
                    4'b1010: half_t_clk <= A5/2;
                    4'b1011: half_t_clk <= A5s/2;
                    4'b1100: half_t_clk <= B5/2;
                    default: half_t_clk <= 0;
                endcase
            end
            else begin
                half_t_clk <= 0;
            end
        end
        else begin
            state <= 0;
            half_t_clk <= 0;
        end
    end


    always@(posedge clk or negedge rstn) begin
        if (~rstn) begin
            pwm <= 0;
            cnt <= 0; 
        end
        else if (state) begin
            if (cnt >= half_t_clk) begin
                pwm <= ~pwm;
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
        else begin
            cnt <= 0; 
            pwm <= 0;
        end
    end

    assign buzzer_out = pwm;
    
endmodule