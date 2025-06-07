#include "base_api.h"

// 参数 us 表示休眠 us 微秒
void SleepUs(int us)
{
    uint start_counter = GetClockCounter();
    uint end_counter = start_counter + us * CPU_TIMES_PER_US;
    while (1)
    {
        uint curr_counter = GetClockCounter();
        if (end_counter >= start_counter && (curr_counter >= end_counter || curr_counter <= start_counter)
            || end_counter < start_counter && (curr_counter <= start_counter && curr_counter >= end_counter))
        {
            break;
        }
    }
}

// 获取时钟计时器
inline uint GetClockCounter() {
    return *((uint *)CLK_COUNTER);
}

uint UintMul(uint a, uint b) {
    uint res = 0;
    for(int i = 0; i < a; a++) {
        res += b;
    }
    return res;
}

uint UintDiv(uint a, uint b) {
    uint res = 0;
    while (a >= b) {
        a -= b;
        res++;
    }
    return res;
}

uint UintMod(uint a, uint b) {
    while (a >= b) {
        a -= b;
    }
    return a;
}


/*
    操作外设寄存器
*/



inline void WriteLed(uchar led)
{
    *((uchar *)LED_ADDR) = led;
}

// 检测按钮是否按下
int CheckButtonPress(uchar mask) {
    uchar btn = *((uchar *)BUTTON_ADDR);
    if (btn & mask) {
        *((uchar *)BUTTON_ADDR) = btn & ~mask;
        return 1;
    } else {
        return 0;
    }
}

uchar ReadByteArrayValue(uchar* array, int index) {
    uint word = *((uint *)(array + index));
    switch (((int)array+index) & 0b11)
    {
    case 0:
        return word & 0xff;
        break;
    case 1:
        return (word >> 8) & 0xff;
        break;
    case 2:
        return (word >> 16) & 0xff;
        break;
    case 3:
        return (word >> 24) & 0xff;
        break;
    default:
        return 0;
        break;
    }
}

// 向数码管上显示数据（4字节），可以用于程序运行过程中的调试
inline void PrintData(uint data) {
    *((uint *)DISPLAY_ADDR) = data;
}

