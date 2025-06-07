#ifndef MUSIC_H_
#define MUSIC_H_

#include "base_api.h"

// 播放音乐
void PlayMusic();

// 暂停播放
void PauseMusic();

// 切换音乐
void SwitchMusic(int index);

// 根据当前播放歌曲的进度设置显示的灯
void SetLedWithMusic(int index, int progress);

// 获取某一首歌的时钟数
uint GetMusicTimeWithClkCounter(int index);

#endif