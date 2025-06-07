`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 20:20:20
// Design Name: 
// Module Name: ifu
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


module ifu(
    input clk,
    input rst,
//    input flag,
    input [31:0] pc,
    output [6:0] op_code,   // ������
    output [2:0] func3,     // 3λ������
    output [6:0] func7,     // 7λ������
    output [4:0] rd,        // Ŀ�ļĴ���
    output [4:0] rs1,       // Դ�Ĵ���1
    output [4:0] rs2,       // Դ�Ĵ���2
    output [31:0] imm       // ��չ��32��������
    );
    // ָ��Ĵ���
    reg [31:0] ir;
//    // pc�Ĵ���
//    reg [31:0] pc;
    // ���ָ����ڴ�
    reg [31:0] iram[63:0];

    reg [6:0] op_code_reg;
    reg [2:0] func3_reg;
    reg [6:0] func7_reg;
    reg [4:0] rd_reg;
    reg [4:0] rs1_reg;
    reg [4:0] rs2_reg;
    reg signed [31:0] imm_reg;

    integer i;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // ��λ����ָ�����ָ��洢��
            for(i = 0; i < 64; i = i + 1)
                iram[i] = 32'b0;
            $readmemh("instruction.txt", iram);
//            pc = 32'b0;
            ir = 32'b0;
        end
        else begin
            ir = iram[pc];
            op_code_reg = ir[6:0];
            // ���ݲ������ȡָ��ĸ�������
            case(op_code_reg)
                7'b011_0011: begin // �Ĵ�����ָ��
                    imm_reg = 32'b0;
                    func3_reg = ir[14:12];
                    func7_reg = ir[31:25];
                    rs1_reg = ir[19:15];
                    rs2_reg = ir[24:20];
                    rd_reg = ir[11:7];
                end
                7'b001_0011: begin // ��������ָ��
                    imm_reg = {{20{ir[31]}}, ir[31:20]};
                    func3_reg = ir[14:12];
                    func7_reg = 7'b0;
                    rs1_reg = ir[19:15];
                    rs2_reg = 5'b0;
                    rd_reg = ir[11:7];
                end
                7'b000_0011: begin // lwָ��
                    imm_reg = {{20{ir[31]}}, ir[31:20]};
                    func3_reg = ir[14:12];
                    func7_reg = 7'b0;
                    rs1_reg = ir[19:15];
                    rs2_reg = 5'b0;
                    rd_reg = ir[11:7];
                end
                7'b010_0011: begin // swָ��
                    imm_reg = {{20{ir[31]}}, ir[31:25], ir[11:7]};
                    func3_reg = ir[14:12];
                    func7_reg = 7'b0;
                    rs1_reg = ir[19:15];
                    rs2_reg = ir[24:20];
                    rd_reg = 5'b0;
                end
                7'b110_0011: begin // ��ָ֧��
                    imm_reg = {{20{ir[31]}}, ir[31:25], ir[11:7]};
                    func3_reg = ir[14:12];
                    func7_reg = 7'b0;
                    rs1_reg = ir[19:15];
                    rs2_reg = ir[24:20];
                    rd_reg = 5'b0;
                end
                7'b110_1111: begin // ��תָ��
                    imm_reg = {{12{ir[31]}}, ir[31:12]};
                    func3_reg = 3'b0;
                    func7_reg = 7'b0;
                    rs1_reg = 5'b0;
                    rs2_reg = 5'b0;
                    rd_reg = ir[11:7];
                end
            endcase
//            // �ı�pc
//            if (flag && (op_code_reg == 7'b110_0011 || op_code_reg == 7'b110_1111)) begin
//                pc = pc + $signed(imm_reg >>> 2);
//            end
//            else
//                pc = pc + 32'b1;
//            $display("pc: %d", pc);
        end
    end

    assign op_code = op_code_reg;
    assign imm = imm_reg;
    assign func3 = func3_reg;
    assign func7 = func7_reg;
    assign rs1 = rs1_reg;
    assign rs2 = rs2_reg;
    assign rd = rd_reg;

endmodule
