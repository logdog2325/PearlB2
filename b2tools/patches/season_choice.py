"""Rowan's seasons question (user 2026-10-19: "one Rowan question should be about whether or not you want seasons
on"): YES = Black 2's seasons by the DS clock's month, as before (Jan/May/Sep spring, Feb/Jun/Oct summer, Mar/Jul/Nov
autumn, Apr/Aug/Dec winter); NO = always Pearl's own look, i.e. our spring/summer (patches/sinnoh_reskin.py keeps
Pearl's own textures in spring and summer), everywhere, every month.

The answer is options u16 bit 15 (save block 27; patches/pearl_intro.py asks, src/code/rowan_questions.c sets it):
HoennB2's seasons bit, with the same meaning (1 = Black 2's seasons; HoennB2's 0 is its summer all year, ours is
Pearl's spring). Bits 0-10 are Black 2's, 11-14 Fairy, classic split, music, sprites.

Where Black 2 decides the season (pokebw2 src/system/season.c Season_GetRealTime, src/system/game_data.c
GameData_GetSeason; HoennB2 notes/SEASONS.md and patches/hoenn_season.py found the same two sites): both are pointed
at src/code/season_choice.c in ITCM (b2tools/itcm.py install pattern), which gives Black 2's own answer while bit 15
is set and SEASON_OFF (spring) otherwise:
- Season_GetRealTime (arm9 0x02034f6c): its "ldr r0, [sp, #4]; subs r1, r0, #1; movs r0, #3; ands r0, r1" (the
  month - 1, & 3) -> "ldr r0, [sp, #4]; bl Season_FromMonth; nop" (8 bytes at 0x02034f76).
- GameData_GetSeason (arm9 0x020173ac, 8 bytes, 4-aligned) -> a long jump to Season_Kept (r0 = the GameData).
With both answering the same fixed season, the kept season and the clock's always agree, so no season card plays on
warps and nothing changes with the month. The snowy north is winter all year in both answers (its texture sets are
the same in all four seasons). The place-name banner and the Continue card are already without the season
(pearl_intro).

Test switch (test builds only): SEASON_OFF=1 builds the fixed season as summer instead of spring.
List this patch after the patches that install ITCM code before it (b2tools/itcm.py's literal check); it changes no
file data.
"""
import os, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.dirname(HERE))
import itcm  # noqa: E402

CFG_SEASONS_BIT = 15
GET_REAL_TIME_SITE = 0x02034F76            # in Season_GetRealTime (0x02034f6c), after RTC_GetCachedDate
GET_REAL_TIME_OLD = bytes.fromhex('0198' '411e' '0320' '0840')   # ldr r0,[sp,#4]; subs r1,r0,#1; movs r0,#3; ands r0,r1
GET_SEASON = 0x020173AC                    # GameData_GetSeason
GET_SEASON_OLD = bytes.fromhex('7221' '8900' '405c' '7047')      # movs r1,#114; lsls r1,r1,#2; ldrb r0,[r0,r1]; bx lr


def apply_code(code):
    src = os.path.join(ROOT, 'src', 'code', 'season_choice.c')
    defs = [f'-DSEASON_OFF={int(os.environ["SEASON_OFF"])}'] if os.environ.get('SEASON_OFF') else []
    with tempfile.TemporaryDirectory(dir=code) as tmp:
        base, end, sym = itcm.install(code, lambda b: itcm.build(src, b, tmp, defines=defs))
    path = os.path.join(code, 'arm9.bin')
    arm9 = bytearray(open(path, 'rb').read())
    o = GET_REAL_TIME_SITE - itcm.ARM9
    assert bytes(arm9[o:o + 8]) == GET_REAL_TIME_OLD, f'Season_GetRealTime: unexpected {arm9[o:o + 8].hex()}'
    arm9[o:o + 8] = GET_REAL_TIME_OLD[:2] + itcm.bl(GET_REAL_TIME_SITE + 2, sym['Season_FromMonth'] & ~1) + bytes.fromhex('c046')
    o = GET_SEASON - itcm.ARM9
    assert bytes(arm9[o:o + 8]) == GET_SEASON_OLD, f'GameData_GetSeason: unexpected {arm9[o:o + 8].hex()}'
    arm9[o:o + 8] = itcm.long_jump(GET_SEASON, sym['Season_Kept'] & ~1)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(arm9); os.replace(path + '.tmp', path)
    return (f'season_choice: options bit {CFG_SEASONS_BIT} (1 = Black 2\'s seasons, 0 = '
            f'{"summer" if os.environ.get("SEASON_OFF") == "1" else "spring"} all year); {end - base} B of ITCM at '
            f'{base:#x} (Season_FromMonth {sym["Season_FromMonth"] | 1:#x}, Season_Kept {sym["Season_Kept"] | 1:#x})')
