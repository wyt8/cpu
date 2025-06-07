    .equ STACK_ADDR, 0x00013ff0         # 设置栈顶位置，要和CPU中的数据内存所对应 
    
    .section .text.start                # 该部分加入到.text.start节中
    .global _start
_start:
    la sp, STACK_ADDR                   # 设置sp，从而支持函数调用
    call main                           # 调用main函数

_finish:                                # 让程序停止在这里
    j _finish