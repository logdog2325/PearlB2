/* Pearl's night themes (patches/sinnoh_music.py). Replaces Black 2's DecideZoneHeaderBGMID (arm9 0x02018968,
 * src/system/zonedata.c:392): the zone header's song for the season, then, at night (Black 2's day periods NIGHT and
 * MIDNIGHT, rtc.h), Pearl's night version of a Pearl day theme. The pairs table is generated (night_music.h).
 * Black 2 functions are called by address. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#include "night_music.h"   /* N_PAIRS, kPairs[N_PAIRS][2] = {day seq, night seq} */

#define ZoneData_GetHeader ((u8 *(*)(u16))(0x02018860 | 1))
#define GetRealTimeDayPeriod ((u32(*)(u32))(0x02015a90 | 1))
#define DAY_PERIOD_NIGHT 3
#define DAY_PERIOD_MIDNIGHT 4
#define HEADER_BGM 0x0C    /* u16 bgm[4]: spring, summer, autumn, winter */

u16 Pearl_ZoneBGM(u16 zoneId, u8 season) {
    const u8 *header = ZoneData_GetHeader(zoneId);
    u16 bgm = season < 4 ? *(const u16 *)(header + HEADER_BGM + 2 * season) : 0;
    u32 period = GetRealTimeDayPeriod(season);
    if (period == DAY_PERIOD_NIGHT || period == DAY_PERIOD_MIDNIGHT) {
        for (u32 i = 0; i < N_PAIRS; i++) {
            if (kPairs[i][0] == bgm) return kPairs[i][1];
        }
    }
    return bgm;
}
