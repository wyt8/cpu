#############################
# 	WYT 于 2024-9-1 编写
#############################

TOOLS_BASE_PATH := ./assets/riscv/bin
CROSS_PREFIX := riscv32-unknown-elf-

#############################
# 	需要的一些文件路径
#############################

# 源文件
SRC_FILES := ./start.S ./main.c 
# 链接脚本
LINKER_SCRIPT := ./linker.ld

PYTHON_SCRIPT := ./gen_coe.py

MAIN_ELF := ./main.elf
MAIN_BIN := ./main.bin
MAIN_ELF_ASM := ./main_elf.asm
MAIN_BIN_ASM := ./main_bin.asm

INST_MEM_TXT := ./inst_mem.coe
DATA_MEM_TXT := ./data_mem.coe

#############################
# 	命令和命令行参数
#############################

# GCC
GCC := ${TOOLS_BASE_PATH}/${CROSS_PREFIX}gcc
GCC_FLAGS := ${SRC_FILES} \
	-nostdlib -nostdinc -march=rv32i -mabi=ilp32 -lgcc \
	-T ${LINKER_SCRIPT} \
	-o ${MAIN_ELF}

# objdump
OBJDUMP := ${TOOLS_BASE_PATH}/${CROSS_PREFIX}objdump

# objcopy
OBJCOPY := ${TOOLS_BASE_PATH}/${CROSS_PREFIX}objcopy
OBJCOPY_FLAGS := --strip-all ${MAIN_ELF} ${MAIN_BIN}

PYTHON := python3

# ECHO：显示文字
ECHO := echo
ECHO_FLAGS := -e # 用于启用转义字符

###########################

.DEFAULT_GOAL := all

.PHONY: clean
clean:
	@rm ${MAIN_ELF}
	@rm ${MAIN_BIN}
	@rm ${MAIN_ELF_ASM}
	@rm ${MAIN_BIN_ASM}
	@rm ${INST_MEM_TXT}
	@rm ${DATA_MEM_TXT}

.PHONY: build
build:
	@${GCC} ${GCC_FLAGS}
	@${OBJCOPY} ${OBJCOPY_FLAGS}

.PHONY: dump
dump:
	@${OBJDUMP} -D ${MAIN_ELF} > ${MAIN_ELF_ASM}
	@${OBJDUMP} -D ${MAIN_BIN} > ${MAIN_BIN_ASM}
	@${PYTHON} ${PYTHON_SCRIPT} ${MAIN_BIN_ASM} ${INST_MEM_TXT} ${MAIN_ELF} ${DATA_MEM_TXT}

.PHONY: all
all: build dump
	@${ECHO} "生成COE文件成功"