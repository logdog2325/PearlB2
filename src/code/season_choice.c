/* Rowan's seasons question (patches/season_choice.py; options bit 15, HoennB2's seasons bit with the same meaning):
 * 1 = Black 2's seasons by the DS clock's month, as before the question; 0 = always Pearl's own look: the season is
 * fixed to SEASON_OFF in every month, everywhere. ITCM, linked by b2tools/itcm.py.
 *
 * Black 2 decides the season in two places (pokebw2 src/system/season.c, src/system/game_data.c; HoennB2
 * notes/SEASONS.md):
 *   Season_GetRealTime (arm9 0x02034f6c): (month - 1) % 4 from the cached RTC date. GameData_Create, the new game's
 *     opening (Season_Set), warps into outdoor areas (GameData_GetSeasons: the season card and Season_Set), the
 *     calendar weather and the Pokedex habitat read it. season_choice.py makes its "(month - 1) & 3" call
 *     Season_FromMonth with the month in r0 (r1-r3 are dead there).
 *   GameData_GetSeason (arm9 0x020173ac): the kept season, GameData +0x1c8 (loaded from the save on Continue). Every
 *     reader goes through it (area textures and lights, the day-period hours, music, encounters, map swaps, Deerling's
 *     form, GameSystem_GetSeason). season_choice.py makes it a long jump to Season_Kept (r0 = the GameData).
 * With bit 15 clear both answer SEASON_OFF, so they always agree: no season card, no change on warps.
 *
 * SEASON_OFF = spring (0). Pearl's own look is our spring and summer (sinnoh_reskin: Pearl's own textures in both;
 * light tables 140 and 141 are the same); spring's day-period hours are the closest to Pearl's (Black 2 spring:
 * morning 5, day 10, evening 17, night 20; summer 4, 9, 19, 21; Pearl: morning 4, day 10, night 20). -D SEASON_OFF=1
 * gives summer instead. Before a save exists (title, intro) the bit reads 0: spring. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define FN(type, addr) ((type)((addr) | 1))
#define SaveControl_GetBlockPtr FN(u8 *(*)(void *, u32), 0x02007448)
#define g_SaveControlWork       (*(void **)0x02140f60)
#define SAVE_BLOCK_CONFIG       27
#define CFG_SEASONS             (1u << 15)
#define GAMEDATA_SEASON         0x1c8
#ifndef SEASON_OFF
#define SEASON_OFF              0
#endif

static u32 Seasons_On(void) {
    void *sc = g_SaveControlWork;
    if (!sc) return 0;
    return (*(const u16 *)SaveControl_GetBlockPtr(sc, SAVE_BLOCK_CONFIG) & CFG_SEASONS) != 0;
}

u32 Season_FromMonth(u32 month) { return Seasons_On() ? ((month - 1) & 3) : SEASON_OFF; }
u32 Season_Kept(const u8 *gameData) { return Seasons_On() ? gameData[GAMEDATA_SEASON] : SEASON_OFF; }
