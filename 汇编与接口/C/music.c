#include "music.h"

uchar music1[64] = {0b011010,0b011100,0b100001,0b100011,0b100101,0b100101,0b101010,0b101000,0b100101,0b100101,0b011010,0b011010,0b100101,0b100011,0b100001,
                0b011100,0b011010,0b011100,0b100001,0b100011,0b100101,0b100101,0b100011,0b100001,0b011100,0b011010,0b011100,0b100001,0b011100,0b011010,
                0b011001,0b011100,0b011010,0b011100,0b100001,0b100011,0b100101,0b100101,0b101010,0b101000,0b100101,0b100101,0b011010,0b011010,0b100101,
                0b100011,0b100001,0b011100,0b011010,0b011100,0b100001,0b100011,0b100101,0b100101,0b100011,0b100001,0b011100,0b011100,0b100001,0b100001,
                0b100011,0b100011,0b100101,0b100101};

uchar music2[69] = {0b010001,0b010011,0b010101,0b010001,0b011010,0b011000,0b011010,0b011010,0b000000,0b010001,0b011100,0b011010,0b011100,0b011100,0b000000,
                0b011100,0b011010,0b011100,0b010101,0b100001,0b011100,0b011010,0b011000,0b011010,0b011000,0b011010,0b011000,0b011010,0b011000,0b010011,
                0b011000,0b010101,0b010101,0b000000,0b010001,0b010011,0b010101,0b010001,0b011010,0b011000,0b011010,0b011010,0b000000,0b010001,0b011100,
                0b011010,0b011100,0b011100,0b000000,0b011100,0b011010,0b011100,0b010101,0b100001,0b011100,0b011010,0b011000,0b011010,0b100101,0b100101,
                0b011000,0b011010,0b100101,0b100101,0b011000,0b011010,0b011010,0b011010,0b011010};

int music_time_list[MAX_MUSIC_NUM] = {64, 69};
uchar* music_list[MAX_MUSIC_NUM] = {music1, music2};

inline void PlayMusic() {
    *((uint *) MUSIC_CONTROL_ADDR) = 0x1;
}

inline void PauseMusic() {
    *((uint *) MUSIC_CONTROL_ADDR) = 0x0;
}

// 根据当前播放歌曲的进度设置显示的灯
void SetLedWithMusic(int index, int progress) {
    switch (UintMod(progress, 8))
    {
    case 0:
        WriteLed(0b00000011);
        break;
    case 1:
        WriteLed(0b00000001);
        break;
    case 2:
        WriteLed(0b00011111);
        break;
    case 3:
        WriteLed(0b00000111);
        break;
    case 4:
        WriteLed(0b11111111);
        break;
    case 5:
        WriteLed(0b00001111);
        break;
    case 6:
        WriteLed(0b00111111);
        break;
    case 7:
        WriteLed(0b01111111);
        break;
    default:
        WriteLed(0b1);
        break;
    }
}

inline uint GetMusicTimeWithClkCounter(int index) {
    return music_time_list[index] / 4 * 1000000 * CPU_TIMES_PER_US;
}

void SwitchMusic(int index) {
    int music_len = music_time_list[index];
    *((uint *)MUSIC_CONTROL_ADDR) = (0x00100000 | (music_len << 4));
    for (int i = 0; i < music_len; i++)
    {
        *((uint *)MUSIC_CONTROL_ADDR) = 0x00100000 | (((int)ReadByteArrayValue(music_list[index], i)) << 4) | ((i + 1) << 12);
    }
    *((uint *)MUSIC_CONTROL_ADDR) = 0x00000002;
}

// void SwitchMusic(uchar *data, uchar len)
// {
//     *((uint *)MUSIC_CONTROL_ADDR) = (0x00100002 & (len << 4));
//     for (int i = 0; i < len; i++)
//     {
//         *((uint *)MUSIC_CONTROL_ADDR) = (0x00100002 | (int)((ReadByteArrayValue(data, i)) << 4)) | ((i + 1) << 12);
//     }
//     *((uint *)MUSIC_CONTROL_ADDR) = 0x00100002;
//     *((uint *)MUSIC_CONTROL_ADDR) = 0x00100001;
// }

