OUTPUT_ARCH(riscv)
ENTRY(_start)                       # 用于定义程序入口点，这里的_start在汇编文件start.S中定义
INST_BASE_ADDRESS = 0x00000000;     # 该地址要和CPU上电后执行的第一条指令所对应
DATA_BASE_ADDRESS = 0x00010000;     # 该地址要和数据内存区域的起始地址对应

SECTIONS
{
    . = INST_BASE_ADDRESS;
    . = ALIGN(4K);
    .text : {
        *(.text.start)              # 该节名在汇编文件start.asm中定义
        *(.text .text.*)
    }

    . = DATA_BASE_ADDRESS;
    . = ALIGN(4K);
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }
    
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
    }

    .bss : {
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }
}