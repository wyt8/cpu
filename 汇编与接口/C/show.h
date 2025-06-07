#ifndef SHOW_H_
#define SHOW_H_

#include "lcd.h"
#include "base_api.h"

// 显示启动画面
void ShowLaunchScreen();

// 显示骨架屏，该屏幕作为显示模板
// 从上到下分别为：图片（64 * 64 灰度） 文字（128 * 16 单色） 进度条 
void ShowScaffoldScreen(uchar* image, uchar* text, int progress);

// 暂停播放时的显示画面
void ShowPlayScreen(int music_index, int progress);

// 暂停播放时的显示画面
void ShowPauseScreen(int music_index, int progress);

#endif