/* Rowan's music question (patches/music_choice.py; options bit 13, HoennB2's "home-region music" bit): 1 = Sinnoh's
 * songs, as sinnoh_music installs them; 0 = UNOVA, a Black 2 song for each Sinnoh zone song (data/unova_music.json).
 *
 * Black 2's DecideZoneHeaderBGMID (arm9 0x02018968) is a long jump (ldr r3, [pc, #0]; bx r3; .word) to sinnoh_music's
 * Pearl_ZoneBGM (src/code/night_music.c: the zone's Pearl song, its night version at night). music_choice.py points
 * that jump's word here instead; this calls Pearl_ZoneBGM (PREV_ZONE_BGM) and, with the UNOVA answer, swaps a Pearl
 * song for its Black 2 one, by the DS clock's season. Songs that are not Pearl's (Black 2's own zones: the Union Room,
 * ...) pass through. Black 2 functions are called by address.
 *
 * The songs Pearl's scripts start themselves (Barry's, Rowan's, "follow me": sinnoh_music EVENT_SONGS) do not come
 * from the zone header: with the UNOVA answer they become Black 2's (kStory, data/unova_music.json "story") where Black
 * 2 starts a BGM, as HoennB2's hoenn_music does it (its addresses, tested there): GFL_SndBGMPlayCore, the threaded load
 * func_02006424 and the faded change func_02005e08. Every other sequence passes through unchanged. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef int s32;

#define FN(type, addr) ((type)((addr) | 1))
#define SaveControl_GetBlockPtr FN(u8 *(*)(void *, u32), 0x02007448)
#define g_SaveControlWork       (*(void **)0x02140f60)
#define CFG_HOME_MUSIC          (1u << 13)

#include "music_choice.h"   /* PREV_ZONE_BGM, FIRST_SEQ, N_SEQ, kSong[N_SEQ] (0 = keep, else kUnova index + 1),
                               N_UNOVA, kUnova[N_UNOVA][4] (spring, summer, autumn, winter), N_STORY, kStory[N_STORY][2]
                               {Pearl story song, Black 2 song}; MUSIC_FORCE (tests) */
#define RequestBGMChange FN(void (*)(u32, u32, s32, s32), 0x02005fe0)
#define PrevZoneBGM FN(u16 (*)(u16, u8), PREV_ZONE_BGM)

/* 1 = Sinnoh's songs (also before a save exists: Sinnoh is the default) */
u32 Music_IsHome(void) {
#ifdef MUSIC_FORCE
    return MUSIC_FORCE;
#else
    void *sc = g_SaveControlWork;
    if (!sc) return 1;
    return (*(const u16 *)SaveControl_GetBlockPtr(sc, 27) & CFG_HOME_MUSIC) ? 1 : 0;
#endif
}

u16 Choice_ZoneBGM(u16 zoneId, u8 season) {
    u16 bgm = PrevZoneBGM(zoneId, season);
    u32 k;
    if (Music_IsHome() || bgm < FIRST_SEQ || bgm >= FIRST_SEQ + N_SEQ) return bgm;
    k = kSong[bgm - FIRST_SEQ];
    return k ? kUnova[k - 1][season & 3] : bgm;
}

/* ---- story songs (UNOVA): where Black 2 starts a BGM ------------------------------------------------------------- */
u32 Music_Redirect(u32 seq) {
    u32 i;
    if (Music_IsHome()) return seq;
    for (i = 0; i < N_STORY; i++)
        if (kStory[i][0] == seq) return kStory[i][1];
    return seq;
}

/* GFL_SndBGMPlayCore (arm9 0x02005d98) `adds r4, r0, #0; adds r5, r1, #0` (0x02005d9c) -> bl here */
__attribute__((naked)) void Music_PlayCoreShim(void) {
    __asm__ volatile("push {r1, lr}\n\tbl Music_Redirect\n\tadds r4, r0, #0\n\tpop {r1}\n\tadds r5, r1, #0\n\tpop {pc}\n");
}

/* func_02006424 (seq, step, start), the threaded BGM load (the field's faded BGM changes, the evolution and egg scenes):
 * `adds r5, r0, #0; adds r4, r1, #0` (0x02006428) -> bl here (r2, the start flag, is read after) */
__attribute__((naked)) void Music_LoadShim(void) {
    __asm__ volatile("push {r1, r2, r3, lr}\n\tbl Music_Redirect\n\tadds r5, r0, #0\n\tpop {r1, r2, r3}\n\tadds r4, r1, #0\n"
                     "\tpop {pc}\n");
}

/* func_02005e08 (a faded BGM change): its `bl RequestBGMChange` (0x02005e0a) -> here */
void Music_RequestChange(u32 seq, u32 mask, s32 fade_out, s32 fade_in) {
    RequestBGMChange(Music_Redirect(seq), mask, fade_out, fade_in);
}
