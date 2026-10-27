/* Rowan's start-of-game questions (patches/pearl_intro.py): the intro's command 31 and the farewell script that asks
 * them. ITCM, linked by b2tools/itcm.py.
 *
 * Command 31 is Black 2's INTRO_CMD_SET_MSG_LANGUAGE (pokebw2 src/ov294/intro_cmd.c IntroCmd_SetMsgLanguage), which
 * no US script uses; pearl_intro.py points sCommands[31] at Intro_SetConfigBit (HoennB2's fairy.c, the same code):
 * args[0] = a bit of the options u16 (the start of the trainer-data save block, SaveControl block 27), args[1] = its
 * value. Bits (HoennB2's layout, so the link-battle sync and the options mean the same in both projects):
 *   11 = Fairy type on (patches/fairy.py), 12 = classic split (Hoenn only; Pearl never asks: 0),
 *   13 = home-region music, Sinnoh's songs (patches/music_choice.py), 14 = NEW sprites (later),
 *   15 = Black 2's seasons by the DS clock (patches/season_choice.py; 0 = Pearl's own look all year).
 * IntroCmd +4 = IntroParam, IntroParam +4 = the new game's Config (ov162 copies it into the save in NewGame_Exit); the
 * save's own copy gets the bit at once too, so every reader agrees from here.
 * args[0] >= 16 is an event flag instead (HoennB2's sixth question, the same code): set or cleared in the save's
 * EventWork (block 0x2d, what GameData_GetEventWork returns). The Exp. Share question's YES sets Pearl's "received the
 * Exp. Share" flag (patches/exp_share.py: the new game's Bag then gets the Exp. Share, switched on). NewGame_Init
 * cleared the whole save before the intro (func_0200749c -> initSaveBlkCallbacks) and nothing clears EventWork after
 * it, so the flag reaches the field.
 *
 * The script: Black 2's sScripts[INTRO_SCRIPT_FAREWELL] (the professor's last words, after the rival is named) is
 * rewritten into kRowanFarewell with the questions inserted (pearl_intro.py writes rowan_questions.h from the
 * overlay's own entries and points sScripts[12] here: the overlay's 11 entries have no room for 16 more). The intro's
 * runner reads the entries through that pointer only (IntroScript_Get(script)[pc]). */
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef int s32;

#define FN(type, addr) ((type)((addr) | 1))
#define SaveControl_GetBlockPtr FN(u8 *(*)(void *, u32), 0x02007448)
#define EventWork_FlagSet       FN(void (*)(void *, u32), 0x020191d8)
#define EventWork_FlagReset     FN(void (*)(void *, u32), 0x02019200)
#define g_SaveControlWork       (*(void **)0x02140f60)
#define SAVE_BLOCK_CONFIG       27
#define SAVE_BLOCK_EVENTWORK    0x2d

#include "rowan_questions.h"    /* N_FAREWELL, kRowanFarewell[N_FAREWELL][6] = {cmd, args[4], run} */

u32 Intro_SetConfigBit(void *cmd, void *work, s32 *args) {
    u16 *cfg = *(u16 **)(*(u8 **)((u8 *)cmd + 4) + 4);
    u32 mask = 1u << (args[0] & 15);
    void *sc = g_SaveControlWork;
    (void)work;
    if ((u32)args[0] >= 16) {
        if (sc) {
            void *ew = SaveControl_GetBlockPtr(sc, SAVE_BLOCK_EVENTWORK);
            if (args[1]) EventWork_FlagSet(ew, (u32)args[0]); else EventWork_FlagReset(ew, (u32)args[0]);
        }
        return 1;
    }
    if (args[1]) *cfg |= mask; else *cfg &= ~mask;
    if (sc) {
        u16 *save = (u16 *)SaveControl_GetBlockPtr(sc, SAVE_BLOCK_CONFIG);
        if (args[1]) *save |= mask; else *save &= ~mask;
    }
    return 1;
}
