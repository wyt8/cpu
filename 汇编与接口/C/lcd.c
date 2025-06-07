#include "lcd.h"

inline void SetWR() {
    *((uchar *) 0xffff0004) = 0x01;
}

inline void ClearWR() {
    *((uchar *) 0xffff0004) = 0x00;
}

inline void SetRD() {
    *((uchar *) 0xffff0008) = 0x01;
}

inline void ClearRD() {
    *((uchar *) 0xffff0008) = 0x00;
}

inline void SetCS() {
    *((uchar *) 0xffff000c) = 0x01;
}

inline void ClearCS() {
    *((uchar *) 0xffff000c) = 0x00;
}

inline void SetRST() {
    *((uchar *) 0xffff0010) = 0x01;
}

inline void ClearRST() {
    *((uchar *) 0xffff0010) = 0x00;
}

inline void SetRS() {
    *((uchar *) 0xffff0014) = 0x01;
}

inline void ClearRS() {
    *((uchar *) 0xffff0014) = 0x00;
}

inline void WriteLcdData(uchar data)
{
    *((uchar *)LCD_DATA_ADDR) = data;
}

// // 向 LCD 传送命令
// // 并行版，好像无法使用
// void TransferCommandToLcd(int command) {
//     ClearCS(); ClearRS(); ClearRD();
//     SleepUs(1);
//     ClearWR();
//     WriteLcdData(command & 0xff);
//     SetRD();
//     SleepUs(1);
//     SetCS(); ClearRD();
// }

// 向 LCD 传送命令
// 串行版
void TransferCommandToLcd(uchar command) {
    ClearCS();ClearRS();
    for(int i = 0; i < 8; i++) {
        if(command & 0x80) {
            WriteLcdData(0b10111111);
            // SleepUs(1);
            WriteLcdData(0b11111111);
        }
        else {  
            WriteLcdData(0b00111111);
            // SleepUs(1);
            WriteLcdData(0b01111111);
        }
        // SleepUs(1);
        command <<= 1;
    }
    SetCS();
}

// // 向 LCD 传送数据
// // 并行版，好像无法使用
// void TransferDataToLcd(int data) {
//     ClearCS(); SetRS(); ClearRD();
//     SleepUs(1);
//     ClearWR();
//     WriteLcdData(data & 0xff);
//     SetRD();
//     SleepUs(1);
//     SetCS(); ClearRD();
// }

// 向 LCD 传送数据
// 串行版
void TransferDataToLcd(uchar data) {
    ClearCS();SetRS();
    for(int i = 0; i < 8; i++) {
        if(data & 0x80) {
            WriteLcdData(0b10111111);
            // SleepUs(1);
            WriteLcdData(0b11111111);
        }
        else {  
            WriteLcdData(0b00111111);
            // SleepUs(1);
            WriteLcdData(0b01111111);
        }
        // SleepUs(1);
        data <<= 1;
    }
    SetCS();
}

// 初始化 Lcd，在使用前必须调用
void InitLcd() {
    // 复位，rst保持低电平最少 2us
    ClearRST();
    SleepUs(500);
    SetRST();
    SleepUs(100);
    // 电源控制
    TransferCommandToLcd(0x2c);
    SleepUs(200);
    TransferCommandToLcd(0x2e);
    SleepUs(200);
    TransferCommandToLcd(0x2f);
    SleepUs(10);

    TransferCommandToLcd(0xae); // 显示关
    TransferCommandToLcd(0x38); // 模式设置
    TransferCommandToLcd(0xb8); // 85 Hz
    TransferCommandToLcd(0xc8); // 行扫描顺序
    TransferCommandToLcd(0xa0); // 列扫描顺序

    TransferCommandToLcd(0x44); // Set initial COMO register
    TransferCommandToLcd(0x00);
    TransferCommandToLcd(0x40); // Set initial display line register
    TransferCommandToLcd(0x00);

    TransferCommandToLcd(0xab);
    TransferCommandToLcd(0x67);
    TransferCommandToLcd(0x26); // 粗调对比度的值，可设置范围 0x20 ~ 0x27
    TransferCommandToLcd(0x81); // 微调对比度
    TransferCommandToLcd(0x36); // 微调对比度的值，可设置范围 0x00 ~ 0x3f

    TransferCommandToLcd(0x54); //  1/9 bias
    TransferCommandToLcd(0xf3);
    TransferCommandToLcd(0x04);
    TransferCommandToLcd(0x93);

    // TransferCommandToLcd(0x7b); // 扩展指令集 3
    // TransferCommandToLcd(0x11); // Gray mode
    // TransferCommandToLcd(0x10); // Gray mode
    // TransferCommandToLcd(0x00);
    TransferCommandToLcd(0xaf); // 显示开
}

// 设置 LCD 要操作的地址
// page 的值从 0 ~ 15，colum的值从 0 ~ 127
void SetLcdAddress(int page, int column) {
    ClearCS();
    TransferCommandToLcd(0xb0 + page);
    TransferCommandToLcd(((column >> 4) & 0x0f) + 0x10);
    TransferCommandToLcd(column & 0x0f);
}

// // 清空 LCD 屏幕
// void ClearLcdScreen() {
//     for(int page = 0; page < 16; page++) {
//         SetLcdAddress(page, 0);
//         for(int column = 0; column < 128; column++) {
//             TransferDataToLcd(0x00);
//             TransferDataToLcd(0x00);
//         }
//     }
// }

// // 充满 LCD 屏幕
// void FullLcdScreen() {
//     for(int page = 0; page < 16; page++) {
//         SetLcdAddress(page, 0);
//         for(int column = 0; column < 128; column++) {
//             TransferDataToLcd(0xff);
//             TransferDataToLcd(0xff);
//         }
//     }
// }
