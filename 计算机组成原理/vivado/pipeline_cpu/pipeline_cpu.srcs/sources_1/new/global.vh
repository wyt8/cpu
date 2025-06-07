// 上电后CPU执行第一条指令的地址
`define FIRST_PC 0

// 气泡指令
`define BUBBLE_INST 0
 
// ALU 功能码
`define ALU_ADD 0
`define ALU_SUB 1
`define ALU_BIT_AND 2
`define ALU_BIT_OR 3
`define ALU_BIT_XOR 4
`define ALU_SLL 5
`define ALU_SRL 6
`define ALU_SRA 7
`define ALU_SLT 8
`define ALU_SLTU 9
`define ALU_LT 10
`define ALU_LTU 11
`define ALU_GE 12
`define ALU_GEU 13
`define ALU_EQ 14
`define ALU_NEQ 15
`define ALU_JAL 16
`define ALU_LUI 17
`define ALU_AUIPC 18
`define ALU_MUL 19
`define ALU_DIV 20
`define ALU_MOD 21

// 不同类型指令的操作码
`define BUBBLE_OP_CODE 7'b000_0000
`define R_TYPE_OP_CODE 7'b011_0011
`define I_TYPE_OP_CODE 7'b001_0011
`define LOAD_TYPE_OP_CODE 7'b000_0011
`define S_TYPE_OP_CODE 7'b010_0011
`define B_TYPE_OP_CODE 7'b110_0011
`define JAL_TYPE_OP_CODE 7'b110_1111
`define JALR_TYPE_OP_CODE 7'b110_0111
`define LUI_OP_CODE 7'b011_0111
`define AUIPC_OP_CODE 7'b001_0111