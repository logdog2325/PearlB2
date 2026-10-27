/* Sinnoh's weather by season (patches/season_weather.py; notes/SEASONS.md). ITCM, linked by b2tools/itcm.py.
 *
 * Black 2 asks GetWeatherAll (arm9 0x02032e94) for a zone's weather on every zone change and warp: first
 * GetDefaultWeatherValue (ov012, a stub: none), then the Entralink, Route 7 and birthday weathers, then the calendar
 * a/0/9/6 (24 Unova zone ids, a weather for each day of the year, used while the kept season is the clock's), else
 * the zone header's weather. season_weather.py points the first call at SeasonWeather below, which answers for every
 * Sinnoh zone, so none of them takes the Unova zone's Entralink, Route 7, birthday or calendar weather (Sandgem had
 * Lentimas Town's sandstorm on about half the days, Eterna and Verity Lakefront Unova's snow and rain):
 *   ZONE_KIND 1 (rooms, caves, buildings, zones with Pearl weather of their own): the zone header's weather;
 *   ZONE_KIND 2 (outdoors): in winter, on Black 2's own snow days (the calendar days of SNOW_TEMPLATE, a Black 2
 *     zone's year: SNOW_DAYS, 2 bits a day), its snow; every other day and season the header's weather;
 *   ZONE_KIND 3 (the north with Pearl's day-by-day weather: Route 216, Acuity Lakefront, Snowpoint): Pearl's weather
 *     of the day (NORTH_EXC: the days that differ from the header's), in every season and with seasons on or off;
 *   ZONE_KIND 0 (not Sinnoh's): none, so Black 2 goes on as before.
 * Winter = GameData_GetSeason (season_choice's Season_Kept: spring all year with seasons off, so never winter then)
 * and the clock's season both 3, as Black 2 uses the calendar only while they agree. The day is the cached RTC date
 * counted as Black 2's calendar counts it (February always 29 days; Pearl's table counts the same way). */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define FN(type, addr) ((type)((addr) | 1))
#define GameData_GetSeason     FN(u32 (*)(const void *), 0x020173ac)
#define Season_GetRealTime     FN(u32 (*)(void), 0x02034f6c)
#define GetZoneEnvFlagsWeather FN(u32 (*)(u32), 0x0201899c)
#define RTC_GetCachedDate      FN(void (*)(u32 *), 0x0204424c)
#define WEATHER_NONE 0xffff
#define WINTER 3

#include "season_weather_data.h"   /* ZONE_COUNT, ZONE_KIND[], SNOW_DAYS[], SNOW_WEATHER[], NORTH_EXC_* (generated) */

static const u16 MONTH_START[13] = {0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335};

static u32 DayOfYear(void) {
    u32 date[4];                    /* RTCDate: year, month 1-12, day 1-31, week */
    RTC_GetCachedDate(date);
    if (date[1] < 1 || date[1] > 12 || date[2] < 1) return 0;
    return MONTH_START[date[1]] + date[2] - 1;
}

u32 SeasonWeather(const void *gameData, u32 zone) {
    u32 kind, day, i, code;
    zone &= 0xffff;
    if (zone >= ZONE_COUNT) return WEATHER_NONE;
    kind = (ZONE_KIND[zone >> 2] >> ((zone & 3) * 2)) & 3;
    if (kind == 0) return WEATHER_NONE;
    if (kind == 3) {
        day = DayOfYear();
        for (i = 0; i < NORTH_EXC_COUNT; i++)
            if (NORTH_EXC_ZONE[i] == zone && NORTH_EXC_DAY[i] == day) return NORTH_EXC_WEATHER[i];
    } else if (kind == 2 && GameData_GetSeason(gameData) == WINTER && Season_GetRealTime() == WINTER) {
        day = DayOfYear();
        code = (SNOW_DAYS[day >> 2] >> ((day & 3) * 2)) & 3;
        if (code) return SNOW_WEATHER[code];
    }
    return GetZoneEnvFlagsWeather(zone);
}
