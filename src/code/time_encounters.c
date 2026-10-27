/* Pearl's morning/day/night wild Pokémon (patches/sinnoh_encounters.py; user 2026-10-18). Replaces Black 2's
 * EventData_LoadEncData (ov012 0x0215ce60, src/ov012/eventdata_system.c:50): the zone's encounter file holds 4 tables
 * (Black 2's season slots); this picks one by Black 2's day period instead of the season (rtc.h: MORNING -> 0,
 * DAY and EVENING -> 1, NIGHT and MIDNIGHT -> 2). Files with one table still use it (EncData_Load). The table is
 * chosen when the zone's encounters load (entering a zone or reloading the field), as Black 2 does with seasons.
 * Black 2 functions are called by address; EventData offsets from include/field/event_data.h. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define EncData_Load ((u32(*)(void *, void *, u16, u8))(0x021590ec | 1))
#define GetRealTimeDayPeriod ((u32(*)(u32))(0x02015a90 | 1))
#define EVENTDATA_ENCARC 8
#define EVENTDATA_ENCLOADED 52
#define EVENTDATA_ENCDATA 56

void Pearl_LoadEncData(u8 *eventData, u16 zoneId, u8 season) {
    u32 period = GetRealTimeDayPeriod(season);
    u8 table = period == 0 ? 0 : period >= 3 ? 2 : 1;
    EncData_Load(eventData + EVENTDATA_ENCDATA, *(void **)(eventData + EVENTDATA_ENCARC), zoneId, table);
    *(u32 *)(eventData + EVENTDATA_ENCLOADED) = 1;
}
