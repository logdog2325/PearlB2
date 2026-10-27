"""The Pokémon Musical at Hearthome's Contest Hall counters (2026-10-25, the user: "for contests use musicals"; DECISIONS
"Contests -> Black 2's Pokémon Musical"). Pearl's Super Contests can't run on Black 2, so the lobby's three
receptionists send the player to Black 2's own Musical, as HoennB2 does at Hoenn's Contest Halls (its patches/musical.py,
the model; read-only).

The parts:
- the reception: src/include/pearl_musical.inc (Black 2's global script 10450 flow without Nimbasa's walk), put on the
  receptionists by data/pearl_closed_facilities.json rows with "musical": true (b2tools/pearl_story.py), its lines
  data/pearl_musical.json (Black 2's, after Pearl's greeting);
- the backstage: Black 2's zone 78 (map type 9, scripts 156, text 88, area 305), which allocate_sinnoh keeps (DENY);
  its script file src/field_scripts/0156_musical_backstage.s is Black 2's without the fan flags it wrote into Pearl's
  story flags;
- the code (the decomp, branch pearlb2: src/ov012/musical_event.c and src/pearlb2/musical_itcm.c): the event's heap
  is gPearlB2MusicalHeapSize and the show ends where the reception's FieldSetNextZoneHere left the player, instead of
  Nimbasa's theatre lobby (zone 77 = Celestic's Pokémon Center B1F here). This patch sets that size.

What the Musical event does (ov012 musical_event.c, MusicalEvent_Callback): MusicalEvent_Create makes the heap
(HEAPID_MUSICAL_EVENT from HEAPID_USER) and loads the show's program into it (a/1/1/2-5: its timeline and the Props'
sounds; Black 2's four shows about 25 KB each, a downloaded fifth from the save, hence Black 2's 264 KB); states 13/14
warp to zone 78 and run its script 3 (the owner's welcome); 3-8 the dressing room, script 4, the stage, the photo; 19/20
script 5 (the audience's comments); 2: MusicalEvent_Release, MusicalEvent_WarpToHall; 9/10: global script 10454 (the
fade in) where it arrived, then the heap's delete.

Why 64 KB (HoennB2's measurement, the same map types): a Sinnoh room is Black 2 map type 16, whose field heap is
0x136800 of HEAPID_USER; there USER keeps about 110 KB free, so Black 2's 264 KB heap can't be made, and the way back
can't make the room's field heap while it exists (1,382,504 B - 270,336 < 1,271,808). 64 KB holds the program of
shows 0-3 with room to spare (the reception offers only those four), and the heap goes before the way back's map
change (PearlB2_MusicalReturn) instead of after it.

Without this patch (or with an earlier decomp, no gPearlB2MusicalHeapSize) the code is Black 2's: the show would end
in zone 77. So the build list needs `musical` (any place after the code patches that grow ITCM: it only writes a word).
"""
import os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import itcm  # noqa: E402

HEAP_SIZE = 0x10000          # HEAPID_MUSICAL_EVENT (Black 2: 0x42000)


def apply_code(code):
    import decomp
    slot = decomp.symbol('gPearlB2MusicalHeapSize', code)
    assert slot is not None, ('musical: the decomp has no gPearlB2MusicalHeapSize (src/pearlb2/musical_itcm.c): '
                              'without it the show would end in zone 77, Celestic\'s Pokémon Center B1F')
    path = os.path.join(code, 'itcm.bin')
    data = bytearray(open(path, 'rb').read())
    at = slot - itcm.ITCM_BASE
    cur = struct.unpack_from('<I', data, at)[0]
    if cur == HEAP_SIZE:
        return 'musical: already set'
    assert cur == 0, f'gPearlB2MusicalHeapSize at {slot:#x}: {cur:#x}, not 0'
    struct.pack_into('<I', data, at, HEAP_SIZE)
    if os.path.islink(path): os.unlink(path)
    open(path + '.tmp', 'wb').write(data); os.replace(path + '.tmp', path)
    return (f'musical: the Musical\'s heap {HEAP_SIZE:#x} (gPearlB2MusicalHeapSize at {slot:#x}); the show ends where '
            f'the reception stood (PearlB2_MusicalReturn {decomp.symbol("PearlB2_MusicalReturn", code):#x})')


if __name__ == '__main__':          # check against the decomp's last build: python3 b2tools/patches/musical.py
    import decomp
    for name in ('gPearlB2MusicalHeapSize', 'PearlB2_MusicalHeapCreate', 'PearlB2_MusicalReturn',
                 'PearlB2_MusicalHeapDelete'):
        a = decomp.symbol(name)
        print(f'{name}: {a:#x}' if a is not None else f'{name}: missing')
