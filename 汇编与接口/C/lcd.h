#ifndef LCD_H_
#define LCD_H_

#include "base_api.h"

void SetWR();

void ClearWR();

void SetRD();

void ClearRD();

void SetCS();

void ClearCS();

void SetRST();

void ClearRST();

void SetRS();

void ClearRS();

void WriteLcdData(uchar data);

// 向 LCD 传送命令
void TransferCommandToLcd(uchar command);

// 向 LCD 传送数据
void TransferDataToLcd(uchar data);

// 初始化 Lcd，在使用前必须调用
void InitLcd();

// 设置 LCD 要操作的地址
// page 的值从 0 ~ 15，colum的值从 0 ~ 127
void SetLcdAddress(int page, int column);

// // 清空 LCD 屏幕
// void ClearLcdScreen();

// // 充满 LCD 屏幕
// void FullLcdScreen();

#endif