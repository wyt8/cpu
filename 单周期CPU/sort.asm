    # x1寄存器存放常数 ((5-1)*4)
    addi x1, x0, 16
    # x2 寄存器存放数组起始内存地址，这里为 0
    addi x2, x0, 0
    # x3寄存器存放外层循环变量 i = 20
    addi x3, x1, 0
loop:
    # x4 寄存器存放内层循坏变量 j = 0
    addi x4, x0, 0
inner_loop:
    # x5 寄存器存放当前访问内存数组元素的地址
    add x5, x2, x4
    # x6 存放当前访问内存数组元素值
    lw x6, 0(x5)
    # x7 存放下一个内存数组元素值
    lw x7, 4(x5)
    blt x6, x7, inner_loop_end
    # 交换两个相邻数组元素
    sw x7, 0(x5)
    sw x6, 4(x5)
inner_loop_end: # 内循环结束处理，j+4
    addi x4, x4, 4
    blt x4, x3, inner_loop
loop_end: # 外循环结束处理，i-4
    addi x3, x3, -4
    bge x3, x0, loop
