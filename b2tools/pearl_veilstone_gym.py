"""Pearl's Veilstone Gym: the twelve sliding wall panels (data side, for a Black 2 gimmick; 2026-10-25, chapter 4b).

    python3 b2tools/pearl_veilstone_gym.py        prints the panels, their push spots and their collision

Pearl's own Gym (pokediamond, not Platinum's): Maylene's dojo has 12 wooden wall panels (build models 287-293,
'gym_wall01'..'gym_wall07', texture 'toita') that slide along their row between two places when the player pushes
them. As converted (2026-10-25) they do not exist: the Gym is open (the straight way up the middle reaches Maylene
past two Black Belts) and the panels are not drawn. Decision (lead, 2026-10-25): Pearl's panels as Black 2 gimmick
id 60 on chapter 6a's gimmick dispatcher (src/pearlb2/gimmick_itcm.c) once that is merged; this module is the data.

How Pearl does it (pokediamond):
- InitVeilstoneGym (arm9 0x02064D4C; the Gym's zone script 1 calls it on every entry): the 12 state bits of the
  persisted map-feature record 4 from UNK_020F7E48 (0 = the panel at its place A, 1 = at B): the Gym resets.
- ov06_022425C8 (the map loads): each panel's model at x = (A or B + 2) tiles, y = -1 tile, z = row + 1/2 tile
  (fx32: place << 16, + 2 << 16; z << 16 + 2 << 14; 0xFFFF0000); its collision the two (start, length) spans of
  that state (ov06_0224F918: four bytes for A, four for B; a length 0 = no second span).
- ov06_022426F4 (the movement code asks): a tile of a panel's row inside a span of its current state is solid.
- ov06_022426AC + ov06_0224249C (the player presses a direction while facing): standing on a push spot
  (ov06_0224F834: x, z, side, panel; 14 spots, ended by zeros), facing left (side 1) with the panel at B or right
  (side 0) with it at A, pushes it: ov06_0224252C flips its bit and starts ov06_02242744: sound 0x616
  (SEQ_SE_DP_...), the player walks one tile that way (Pearl movement 0x0E west / 0x0F east) while the panel slides
  2 units a frame to the other place; then its spans switch.
Tables are read from the user's Pearl dump, found by their contents (they equal pokediamond's ov06_0224F834,
ov06_0224F8B8, ov06_0224F918 and UNK_020F7E48).
"""
import functools, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)

GIMMICK_ID = 60                  # lead 2026-10-25: after chapter 6a's 59 (Black 2's ids end at 58)
GYM_ZONE = 'MAP_VEILSTONE_GYM'
PANELS = 12
MODELS = range(287, 294)         # Pearl build models 'gym_wall01'..'gym_wall07'
SLIDE_SPEED = 2                  # units a frame (fx32 2 << 12)
PUSH_SE = 0x616                  # Pearl's sound while a panel slides


@functools.lru_cache(None)
def _rom():
    from gen4rom import Rom
    return Rom(os.path.join(ROOT, 'roms', 'pearl.nds'))


def _find(pat, what):
    d = _rom().data
    hits = [m.start() for m in re.finditer(re.escape(pat), d)]
    assert len(hits) == 1, f'{what}: {len(hits)} matches in the Pearl dump'
    return hits[0]


@functools.lru_cache(None)
def panels():
    """The 12 panels: dicts model, row (z), a, b (x tiles of the two places), start (0 = at a), spans_a, spans_b
    ([(x, length)] solid tiles of the row in each place)."""
    d = _rom().data
    o = _find(bytes([0x24, 1, 0, 0, 9, 9, 10, 0, 0x20, 1, 0, 0, 10, 3, 4, 0]), 'Veilstone Gym panel table')
    s = o + 8 * PANELS                                  # the spans follow the panels (ov06_0224F918)
    init = d[_find(bytes([0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1]),
                   'Veilstone Gym start states (UNK_020F7E48, then the Pastoria Gym\'s)'):][:PANELS]
    out = []
    for i in range(PANELS):
        model, row, a, b, flag = struct.unpack_from('<I4B', d, o + 8 * i)
        sp = d[s + 8 * i: s + 8 * i + 8]
        span = lambda q: [(sp[q + 2 * k], sp[q + 2 * k + 1]) for k in range(2) if sp[q + 2 * k + 1]]
        assert model in MODELS and flag == init[i], (i, model, flag, init[i])
        out.append(dict(model=model, row=row, a=a, b=b, start=init[i], spans_a=span(0), spans_b=span(4)))
    return out


@functools.lru_cache(None)
def push_spots():
    """[(x, z, facing, panel)]: standing on (x, z) facing that way (Pearl's 2 left, 3 right) pushes the panel when it
    is at the place that faces you (left: at b, slides to a; right: at a, slides to b)."""
    d = _rom().data
    o = _find(bytes([0x0C, 0x14, 0x01, 0x0B, 0x02, 0x14, 0x00, 0x0B, 0x12, 0x13]), 'Veilstone Gym push spots')
    out = []
    while True:
        x, z, side, panel = d[o:o + 4]
        if (x, z, side, panel) == (0, 0, 0, 0):
            return out
        out.append((x, z, 2 if side else 3, panel))
        o += 4


def solid(states):
    """{(x, z)} of the Gym's tiles the panels make solid, for 12 states (0 = at a)."""
    out = set()
    for p, st in zip(panels(), states):
        for x0, n in (p['spans_b'] if st else p['spans_a']):
            out |= {(x, p['row']) for x in range(x0, x0 + n)}
    return out


def model_place(p, state):
    """Pearl's model position of a panel (units: x, y, z), ov06_022425C8."""
    return (((p['b'] if state else p['a']) + 2) * 16, -16, p['row'] * 16 + 8)


def main():
    names = {}
    from gen4rom import narc_members
    bm = narc_members(_rom().read('fielddata/build_model/build_model.narc'))
    for m in MODELS:
        names[m] = re.findall(rb'gym_wall0\d', bm[m][:200])[0].decode()
    for i, p in enumerate(panels()):
        print(f'panel {i:2d}: {names[p["model"]]} (model {p["model"]}) row {p["row"]:2d}, x {p["a"]:2d} / {p["b"]:2d}, '
              f'starts at {"b" if p["start"] else "a"}; solid at a {p["spans_a"]}, at b {p["spans_b"]}; '
              f'model at {model_place(p, p["start"])}')
    for x, z, f, i in push_spots():
        print(f'push spot ({x:2d}, {z:2d}) facing {"left" if f == 2 else "right"}: panel {i}')
    print(f'solid tiles at the start: {sorted(solid([p["start"] for p in panels()]))}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
