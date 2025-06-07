#include "base_api.h"
#include "show.h"
#include "music.h"

void player_main() {
    InitLcd();
    ShowLaunchScreen();
    int is_playing = 0;
    int music_index = 0;
    int music_progress = 0;
    SwitchMusic(music_index);
    uint last_time = GetClockCounter();
    uint total_time = 0;
    while (1)
    {
        PrintData(music_index + 1);
        // PrintData(total_time);
        if(CheckButtonPress(PLAY_PAUSE_BTN_MASK)) {
            if (is_playing) {
                is_playing = 0;
            } else {
                is_playing = 1;
            }
        }
        if(CheckButtonPress(LEFT_BTN_MASK)) {
            if(music_index == 0) {
                music_index = MAX_MUSIC_NUM - 1;
            } else {
                music_index--;
            }
            SwitchMusic(music_index);
            is_playing = 1;
            music_progress = 0;
            total_time = 0;
            last_time = GetClockCounter();
        }
        if(CheckButtonPress(RIGHT_BTN_MASK)) {
            if(music_index == MAX_MUSIC_NUM - 1) {
                music_index = 0;
            } else {
                music_index++;
            }
            SwitchMusic(music_index);
            is_playing = 1;
            music_progress = 0;
            total_time = 0;
            last_time = GetClockCounter();
        }
        if(is_playing) {
            total_time += GetClockCounter()  - last_time;
            last_time = GetClockCounter();
            PlayMusic();
            SetLedWithMusic(music_index, music_progress);
            ShowPlayScreen(music_index, music_progress);
        } else {
            last_time = GetClockCounter();
            PauseMusic();
            WriteLed(0);
            ShowPauseScreen(music_index, music_progress);
        }
        music_progress = UintDiv(total_time , 16000000);
        if(music_progress >= 99) {
            music_progress = 0;
            total_time = 0;
            last_time = GetClockCounter();
        }
    }

    return;
}