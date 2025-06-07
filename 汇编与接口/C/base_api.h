#ifndef BASE_API_H_
#define BASE_API_H_

#define     LCD_DATA_ADDR       (0xffff0000)
// 从高位到低位对应 LCD 的 LCD_RS LCD_RST LCD_CS LCD_RD LCD_WR 原理图标号
#define     LCD_CONTROL_ADDR    (0xffff0004)
#define     LED_ADDR            (0xffff1000)
#define     BUTTON_ADDR         (0xffff2000)
#define     DATA_MEM_START      (0x00000000)
#define     DATA_MEM_END        (0x00004000)
#define     CLK_COUNTER         (0xffff3000)
#define     DISPLAY_ADDR        (0xffff4000)
#define     MUSIC_CONTROL_ADDR  (0xffff5000)

// CPU 的时钟频率为 100 MHz，表示1微秒内有多少个CPU周期
#define     CPU_TIMES_PER_US    (100)

#define     uchar               unsigned char
#define     uint                unsigned int
#define     bit                 unsigned char

#define     BIT_ZERO            (0)
#define     BIT_ONE             (1)
#define     BIT_KEEP            (2)

#define     PLAY_PAUSE_BTN_MASK (0b00000001)
#define     LEFT_BTN_MASK       (0b00000010)
#define     RIGHT_BTN_MASK      (0b00010000)

#define     MAX_MUSIC_NUM       (2)

uint UintMul(uint a, uint b);

uint UintDiv(uint a, uint b);

uint UintMod(uint a, uint b);

// 参数 us 表示休眠 us 微秒
void SleepUs(int us);

// 获取时钟计时器
uint GetClockCounter();

/*  
    操作外设寄存器
*/

// 向 8 个 led 写入数据
void WriteLed(uchar leds);

// 检测按钮是否按下
int CheckButtonPress(uchar mask);

// 向数码管上显示数据（4字节），可以用于程序运行过程中的调试
void PrintData(uint data);

uchar ReadByteArrayValue(uchar* array, int index);

#endif