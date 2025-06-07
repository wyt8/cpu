`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/24 14:11:41
// Design Name: 
// Module Name: PipelineCPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 流水线CPU，顶层模块
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PipelineCPU(
    input clk,                              // 时钟信号
    input rst,                              // 置位信号
    /* 指令内存 */
    output [31:0] inst_mem_read_addr,
    input [31:0] inst_mem_read_data,
    /* 数据内存 */
    output data_mem_write_enable,
    output [31:0] data_mem_addr,
    output [31:0] data_mem_write_data,
    output [2:0] data_mem_len,// byte0 / half1 / word2
    input [31:0] data_mem_read_data,
    /* 标志位 */
    output overflow_flag
    );


    wire reg_write_enable;
    wire [4:0] reg_ra_addr;
    wire [4:0] reg_rb_addr;
    wire [4:0] reg_rw_addr;
    wire [31:0] reg_rw_data;
    wire [31:0] reg_ra_data;
    wire [31:0] reg_rb_data;
    wire [2:0] reg_data_mem_len;
    
    wire [31:0] a0, a1;

    // 寄存器堆
    Regfile regfile(
        .clk(clk),
        .rst(rst),

        .write_enable(reg_write_enable),
        .ra_addr(reg_ra_addr),
        .rb_addr(reg_rb_addr),
        .rw_len(reg_data_mem_len),
        .rw_addr(reg_rw_addr),
        .rw_data(reg_rw_data),
        .ra_data(reg_ra_data),
        .rb_data(reg_rb_data),
        .a0(a0),
        .a1(a1)
    );

    wire [6:0] op_code;
    wire [4:0] rd_addr;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire pc_stall;
    wire if_id_reg_stall;
    wire if_id_reg_bubble;
    wire id_ex_reg_bubble;

    // 冒险处理模块，会处理数据冒险和控制冒险 
    RiskHandle risk_handle(
        .clk(clk),
        .rst(rst),
    
        .op_code(op_code),
        .rd(rd_addr),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
    
        .pc_stall(pc_stall),
        .if_id_reg_stall(if_id_reg_stall),
        .if_id_reg_bubble(if_id_reg_bubble),
        .id_ex_reg_bubble(id_ex_reg_bubble)
    );


    /* ------------------------------------------------------------ */
    /*                          取指阶段 IF                          */
    /* ------------------------------------------------------------ */


    wire [31:0] if_pc;
    wire [31:0] if_instruction;
    wire pc_select;
    wire [31:0] jump_pc; 
    
    PC pc(
        .clk(clk),
        .rst(rst),
        
        .stall(pc_stall),
        
        .jump_pc(jump_pc),
        .select(pc_select),
        .pc(if_pc)
    );

    // 向指令内存读取指令
    assign inst_mem_read_addr = if_pc;
    assign if_instruction = inst_mem_read_data;


    /* ------------------------------------------------------------ */
    /*                            译码阶段 ID                        */
    /* ------------------------------------------------------------ */


    wire [31:0] id_instruction;
    wire [31:0] id_pc;

    IfIdReg if_id_reg(
        .clk(clk),
        .rst(rst),
        
        .stall(if_id_reg_stall),
        .bubble(if_id_reg_bubble),
        
        .if_instruction(if_instruction),
        .if_pc(if_pc),

        .id_instruction(id_instruction),
        .id_pc(id_pc)
    );

    wire [2:0] func3;
    wire [6:0] func7;
    wire [31:0] imm;

    Decoder decoder(
        .instruction(id_instruction),
        .op_code(op_code),
        .func3(func3),
        .func7(func7),
        .rd(rd_addr),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .imm(imm)
    );
   
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;

    // 读寄存器堆
    assign reg_ra_addr = rs1_addr;
    assign reg_rb_addr = rs2_addr;
    assign id_rs1_data = reg_ra_data;
    assign id_rs2_data = reg_rb_data;

    wire [4:0] id_alu_select;
    wire id_reg_write_enable;
    wire id_mem_write_enable;
    wire id_alu_num2_src;
    wire id_reg_write_data_src;
    wire id_jump_type_inst;
    
    wire id_jar_select;
    wire id_alu1_select;
    
    ControlUnit controlUnit(
        .op_code(op_code),
        .func3(func3),
        .func7(func7),
        .alu_num2_src(id_alu_num2_src),
        .reg_write_enable(id_reg_write_enable),
        .mem_write_enable(id_mem_write_enable),
        .reg_write_data_src(id_reg_write_data_src),
        .jump_type_inst(id_jump_type_inst),
        .alu_select(id_alu_select),
        .alu1_select(id_alu1_select),
        .jar_select(id_jar_select)
    );

    wire [31:0] id_imm;
    wire [4:0] id_rd_addr;
    assign id_imm = imm;
    assign id_rd_addr = rd_addr; 

    /* ------------------------------------------------------------ */
    /*                           执行阶段 EX                         */
    /* ------------------------------------------------------------ */

    wire [31:0] ex_imm;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [4:0] ex_rd_addr;
    wire [4:0] ex_alu_select;
    wire ex_reg_write_enable;
    wire ex_mem_write_enable;
    wire ex_alu_num1_src;
    wire ex_alu_num2_src;
    wire ex_reg_write_data_src;
    wire ex_jump_type_inst;
    wire [31:0] ex_pc;
    
    wire ex_jar_select;
    wire ex_alu1_select;
    wire [2:0] ex_data_mem_len;

    IdExReg id_ex_reg(
        .clk(clk),
        .rst(rst),

        .bubble(id_ex_reg_bubble),

        .id_imm(id_imm),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_rd_addr(id_rd_addr),
        .id_alu_select(id_alu_select),
        .id_reg_write_enable(id_reg_write_enable),
        .id_mem_write_enable(id_mem_write_enable),
        .id_alu_num2_src(id_alu_num2_src),
        .id_reg_write_data_src(id_reg_write_data_src),
        .id_jump_type_inst(id_jump_type_inst),
        .id_pc(id_pc),
        .id_jar_select(id_jar_select),
        .id_alu1_select(id_alu1_select),
        .id_data_mem_len(func3),

        .ex_imm(ex_imm),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_rd_addr(ex_rd_addr),
        .ex_alu_select(ex_alu_select),
        .ex_reg_write_enable(ex_reg_write_enable),
        .ex_mem_write_enable(ex_mem_write_enable),
        .ex_alu_num2_src(ex_alu_num2_src),
        .ex_reg_write_data_src(ex_reg_write_data_src),
        .ex_jump_type_inst(ex_jump_type_inst),
        .ex_pc(ex_pc),
        .ex_jar_select(ex_jar_select),
        .ex_alu1_select(ex_alu1_select),
        .ex_data_mem_len(ex_data_mem_len)
    );

    // 二路复用器，用于选择 alu的num2 来自 寄存器堆 还是 指令中的立即数
    wire [31:0] alu_num1 = ex_alu1_select  ? ex_pc : ex_rs1_data; 
    wire [31:0] alu_num2 = ex_alu_num2_src ? ex_rs2_data : ex_imm;
    
    wire [31:0] ex_alu_result;
    wire ex_alu_condition_flag;

    ALU alu(
        .num1(alu_num1),
        .num2(alu_num2),
        .select(ex_alu_select),
        .result(ex_alu_result),
        .condition_flag(ex_alu_condition_flag),
        .overflow_flag(overflow_flag)
    );

    wire [31:0] ex_jump_pc;
    // 进行地址计算
    assign ex_jump_pc = (ex_jar_select ? ex_rs1_data : ex_pc) + ex_imm;

    /* ------------------------------------------------------------ */
    /*                         访存阶段 MEM                          */
    /* ------------------------------------------------------------ */

    wire [31:0] mem_alu_result;
    wire mem_alu_condition_flag;
    wire mem_reg_write_enable;
    wire mem_mem_write_enable;
    wire mem_reg_write_data_src;
    wire [4:0] mem_rd_addr;
    wire [31:0] mem_rs2_data;
    wire mem_jump_type_inst;
    wire [31:0] mem_jump_pc;
    wire [2:0] mem_data_mem_len;

    ExMemReg ex_mem_reg(
        .clk(clk),
        .rst(rst),

        .ex_alu_result(ex_alu_result),
        .ex_alu_condition_flag(ex_alu_condition_flag),
        .ex_reg_write_enable(ex_reg_write_enable),
        .ex_mem_write_enable(ex_mem_write_enable),
        .ex_reg_write_data_src(ex_reg_write_data_src),
        .ex_rd_addr(ex_rd_addr),
        .ex_rs2_data(ex_rs2_data),
        .ex_jump_type_inst(ex_jump_type_inst),
        .ex_jump_pc(ex_jump_pc),
        .ex_data_mem_len(ex_data_mem_len),

        .mem_alu_result(mem_alu_result),
        .mem_alu_condition_flag(mem_alu_condition_flag),
        .mem_reg_write_enable(mem_reg_write_enable),
        .mem_mem_write_enable(mem_mem_write_enable),
        .mem_reg_write_data_src(mem_reg_write_data_src),
        .mem_rd_addr(mem_rd_addr),
        .mem_rs2_data(mem_rs2_data),
        .mem_jump_type_inst(mem_jump_type_inst),
        .mem_jump_pc(mem_jump_pc),
        .mem_data_mem_len(mem_data_mem_len)
    );

    assign data_mem_addr = mem_alu_result;
    // 向数据内存写入数据
    assign data_mem_write_enable = mem_mem_write_enable;
    assign data_mem_len = mem_data_mem_len;
    assign data_mem_write_data = mem_rs2_data;

    wire [31:0] mem_mem_read_data;
    // 从数据内存读取数据
    assign mem_mem_read_data = data_mem_read_data;

    assign pc_select = mem_jump_type_inst & mem_alu_condition_flag;
    assign jump_pc = mem_jump_pc;

    /* ------------------------------------------------------------ */
    /*                        写回阶段 WB                            */
    /* ------------------------------------------------------------ */

    wire [31:0] wb_mem_read_data;
    wire [31:0] wb_alu_result;
    wire wb_reg_write_enable;
    wire wb_reg_write_data_src;
    wire [4:0] wb_rd_addr;
    wire [2:0] wb_data_mem_len;

    MemWbReg mem_wb_reg(
        .clk(clk),
        .rst(rst),

        .mem_mem_read_data(mem_mem_read_data),
        .mem_alu_result(mem_alu_result),
        .mem_reg_write_enable(mem_reg_write_enable),
        .mem_reg_write_data_src(mem_reg_write_data_src),
        .mem_rd_addr(mem_rd_addr),
        .mem_data_mem_len(mem_data_mem_len),

        .wb_mem_read_data(wb_mem_read_data),
        .wb_alu_result(wb_alu_result),
        .wb_reg_write_enable(wb_reg_write_enable),
        .wb_reg_write_data_src(wb_reg_write_data_src),
        .wb_rd_addr(wb_rd_addr),
        .wb_data_mem_len(wb_data_mem_len)
    );

    // 向寄存器堆写数据
    assign reg_write_enable = wb_reg_write_enable;
    assign reg_rw_addr = wb_rd_addr;
    assign reg_data_mem_len = wb_reg_write_data_src ? wb_data_mem_len : 3'h2;// alu / mem
    // 二路复用器，用于选择 写入寄存器堆的数据 来自 alu计算结果 还是 内存中读出数据
    assign reg_rw_data = wb_reg_write_data_src ? wb_mem_read_data : wb_alu_result;

endmodule
