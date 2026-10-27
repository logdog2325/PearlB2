"""Does every Pearl person's Black 2 sheet have the pictures its movement draws? (The white X: Fantina at the
Hearthome Contest Hall, 2026-10-25.) Read-only; offline from Pearl's events and scripts and Black 2's sheets.

    python3 b2tools/frame_check.py [--rom ROM.nds|FILES_DIR] [--zone MAP_NAME ...] [--all] [--sheets]
        --rom     read the sheets of a built ROM (default: Black 2's own files, with the sheets
                  patches/pearl_npc_sprites and pearl_player_sprites repaint taken as whole)
        --all     also list the "maybe" cases (a talk from a side the sheet cannot face)
        --sheets  list every Black 2 sheet with placeholder pictures, and stop

How Black 2 picks a picture [code, external/pokebw2]:
- An object code's record (a/0/4/7, FieldActorConfig) names its sheet (res1 in a/0/4/8) and its
  spriteControllerType, which selects an animation set (ov036 fldmmdl_drawdata.c FIELD_BILLBOARD_ANIM_SETS[type]).
- Each frame the actor shows animation  dir + 4 * draw status  of its set (field_rail_loader.c RailActorAnim_Update;
  dir = up 0, down 1, left 2, right 3; status 0 = standing, 1-9 = walking at some speed, the same pictures for
  every speed in the people's sets 2 (7 frames) and 3 (12 frames)). An animation is a list of frame numbers (and a
  mirror bit). Set 3: stand up 0 / down 3 / left 6 / right 9, walk up 0-2, down 3-5, left 6-8, right 9-11; set 2:
  stand up 0, down 2, left/right 4 (right mirrored), walk up 0-1, down 2-3, left/right 4-6. Pokemon sets 13/14 have
  four looping animations, one per direction (walking uses the same).
- A frame Black 2 never draws for an actor is often a PLACEHOLDER in its sheet: the PWT's Kanto-to-Sinnoh leaders,
  Blue, Lance, Steven, Wallace (codes 252-288, 375) hold a white X in the back view and the steps toward / away from
  the camera (HoennB2 notes/RESEARCH_STORY_SPRITES.md 5.1: 7-frame sheets 0, 1, 3; 12-frame sheets 0-2, 4, 5),
  because the PWT only shows them facing the camera or sideways. Placeholders are found here by their shape: a
  sparse picture (< 100 pixels) drawn as an X or one stroke of it that recurs in 2+ sheets, or
  an empty frame. A frame number past the sheet's end counts too.
What each person draws:
- its movement code (Black 2's, after data/pearl_movement_types.json and pearl_events.fit_move): standing in each
  way it faces (0 / 14-17 one way, 2 / 6-13 / 45 / 46 the ways of its look list, 18 / 19 all four), walking in each
  way it walks (3 all, 4 up/down, 5 left/right, 20 along its direction and back, 21-44 routes: all four, 50 / 51-54
  follow / disguised: all four);
- "talk": a person with a talk script that turns to the player (Pearl's FacePlayer; trainers turn too) faces each
  side with a walkable tile beside it (--all lists these: they need the player to stand there);
- "script": Pearl's scripts' movements of it (ApplyMovement: FACE_x stands that way, WALK/RUN/JUMP/WALK_ON_SPOT_x
  walks; SetObjectEventDir; SetObjectEventMovementType).
Every case where one of those pictures is a placeholder is listed, with the zone, the person and Pearl's move.
The frames patches/pearl_pwt_frames fills (the PWT leaders' back view and steps: copies of each sheet's own front
frame, the user 2026-10-25) count as drawn for walks, scripts and talks; a person whose movement code STANDS in one
of them (Pearl's LOOK_NORTH) is listed too: pearl_events.fit_move turns those to face down (the official front).
Exit status 1 when a MOVE or SCRIPT case is left (TALK cases need the player behind the person: --all).
"""
import collections, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import sprites, narcio  # noqa: E402

DRAWDATA = os.path.join(ROOT, 'external', 'pokebw2', 'src', 'ov036', 'fldmmdl_drawdata.c')
DIRS = ('up', 'down', 'left', 'right')
DIRV = {0: (0, -1), 1: (0, 1), 2: (-1, 0), 3: (1, 0)}
WALK_STATES = range(1, 10)

# Black 2 movement code -> the ways it faces standing (LOOKS) or walks and faces (WALKS); move_uses() has the rest
ALL4 = {(d, k) for d in range(4) for k in ('stand', 'walk')}
LOOKS = {2: (0, 1, 2, 3), 6: (0, 2), 7: (0, 3), 8: (1, 2), 9: (1, 3), 10: (0, 1, 2), 11: (0, 1, 3), 12: (0, 2, 3),
         13: (1, 2, 3), 45: (0, 1), 46: (2, 3), 18: (0, 1, 2, 3), 19: (0, 1, 2, 3), 14: (0,), 15: (1,), 16: (2,),
         17: (3,)}
WALKS = {3: (0, 1, 2, 3), 4: (0, 1), 5: (2, 3)}


def move_uses(move, d):
    """{(dir, kind)} a Black 2 movement code draws by itself (d = the person's direction field)."""
    if move in LOOKS:
        return {(x, 'stand') for x in LOOKS[move]}
    if move in WALKS:
        return {(x, k) for x in WALKS[move] for k in ('stand', 'walk')}
    if move == 20:
        return {(x, k) for x in (d, d ^ 1) for k in ('stand', 'walk')}
    if 21 <= move <= 44 or move in (50, 51, 52, 53, 54, 85):
        return set(ALL4)
    return {(d & 3, 'stand')}


# ---------------------------------------------------------------------------------------------------- the sheets

def anim_sets():
    """{set number: [[frame, ...] per animation]} from the decomp's FIELD_BILLBOARD_ANIM_SETS."""
    src = open(DRAWDATA).read()
    steps = {}
    for m in re.finditer(r'static const BlActAnimStep (\w+)\[\] = \{(.*?)\};', src, re.S):
        rows = re.findall(r'\{\s*(\w+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\}', m.group(2))
        steps[m.group(1)] = [int(a, 0) for a, *_ in rows if not a.startswith('BLACT')]
    sets = {}
    for m in re.finditer(r'static const BlActAnimStep \*const sBillboardSet(\d+)Animations\[\] = \{(.*?)\};', src, re.S):
        sets[int(m.group(1))] = [steps[n] for n in re.findall(r'\w+', m.group(2))]
    return sets


class Sheets:
    """Black 2's object table and sheets (a built ROM's, or the base files with Pearl's repainted sheets whole)."""

    def __init__(self, rom=None):
        if rom:
            import npc_check
            f = npc_check.Files(rom)
            raw = f.narc(47)[0]
            self.sheets = f.narc(48)
            import struct
            n = struct.unpack_from('<I', raw, 0)[0]
            keys = ('uid entityType sceneNodeType shadow footprint reflections billboardSize spriteAtlasSize '
                    'spriteControllerType gender collWidth collHeight offX offY offZ res1 res2 anim0 anim1 anim2').split()
            self.table = [dict(zip(keys, struct.unpack_from('<HBBBBBBBBBBBbbbHHHHH', raw, 4 + 28 * i)))
                          for i in range(n)]
            self.whole = set()
        else:
            self.table = sprites.ow_table(sprites.SRC_FILES)
            self.sheets = narcio.load(sprites.SRC_FILES, sprites.ARC_OW_SHEETS)
            self.whole = repainted_codes()
        self.sets = anim_sets()
        self._info = {}
        self._place = None

    def placeholders(self):
        """Masks (and sizes) that are placeholders: sparse pictures recurring in 2+ sheets, drawn as an X or one
        stroke of it (Unown's thin side views recur too, but are bars)."""
        if self._place is None:
            seen = collections.defaultdict(set)
            for s, b in enumerate(self.sheets):
                for _, w, h, pix in self._frames(b):
                    m = bytes(v != 0 for v in pix)
                    if 0 < sum(m) < 100 and is_x(m, w):
                        seen[(w, h, m)].add(s)
            self._place = {k for k, v in seen.items() if len(v) >= 2}
        return self._place

    @staticmethod
    def _frames(b):
        if b[:4] != b'BTX0':
            return []
        try:
            return sprites.btx_decode(b)[0]
        except AssertionError:
            return []

    def info(self, code):
        """dict(ctrl, frames, bad {frame: why}, anims) of an object code, None for a 3D object or no sheet."""
        if code in self._info:
            return self._info[code]
        r = sprites.obj_record(code)
        rec = self.table[r] if r < len(self.table) else None
        out = None
        if rec and rec['entityType'] == 1 and rec['res1'] < len(self.sheets):
            fr = self._frames(self.sheets[rec['res1']])
            if fr:
                bad = {}
                if code not in self.whole:
                    for i, (_, w, h, pix) in enumerate(fr):
                        m = bytes(v != 0 for v in pix)
                        if not any(m):
                            bad[i] = 'empty'
                        elif (w, h, m) in self.placeholders():
                            bad[i] = 'placeholder X'
                made = set()
                if code in made_frames():               # frames patches/pearl_pwt_frames fills in the build
                    made = set(made_frames()[code].get(len(fr), ()))
                    bad = {i: why for i, why in bad.items() if i not in made}
                anims = self.sets.get(rec['spriteControllerType']) or []
                out = dict(ctrl=rec['spriteControllerType'], frames=len(fr), bad=bad, made=made, anims=anims,
                           sheet=rec['res1'])
        self._info[code] = out
        return out

    def frames_for(self, code, uses):
        """{(dir, kind): [frames]} a person of this code draws for `uses`."""
        inf = self.info(code)
        out = {}
        if not inf or not inf['anims']:
            return out
        anims = inf['anims']
        for d, kind in uses:
            ids = [d] if kind == 'stand' else [d + 4 * s for s in WALK_STATES]
            ids = [a for a in ids if a < len(anims)] or [d % len(anims)]
            out[(d, kind)] = sorted({f for a in ids for f in anims[a]})
        return out

    def missing(self, code, uses, official=False):
        """[(dir, kind, [bad frames])] of `uses` that draw a placeholder or a frame past the sheet's end (official:
        standing in a frame patches/pearl_pwt_frames filled counts too)."""
        inf = self.info(code)
        if not inf:
            return []
        out = []
        for (d, kind), frs in sorted(self.frames_for(code, uses).items()):
            bad = [f for f in frs if f in inf['bad'] or f >= inf['frames']
                   or official and kind == 'stand' and f in inf['made']]
            if bad:
                out.append((d, kind, bad))
        return out

    def can(self, code, d, kind='stand'):
        return not self.missing(code, {(d, kind)})


def is_x(mask, w):
    """Do a frame's pixels lie on the diagonals of their bounding box (an X, or one stroke of it)?"""
    pts = [(i % w, i // w) for i, v in enumerate(mask) if v]
    x0, y0 = min(p[0] for p in pts), min(p[1] for p in pts)
    x1, y1 = max(p[0] for p in pts), max(p[1] for p in pts)
    if x1 - x0 < 7 or y1 - y0 < 7:
        return False
    sx, sy = (x1 - x0) / (y1 - y0), (x1 - x0)
    return all(min(abs((x - x0) - (y - y0) * sx), abs((x1 - x) - (y - y0) * sx)) <= 2.5 for x, y in pts)


def made_frames():
    """{code: {frame count: [frames]}} that patches/pearl_pwt_frames fills (the PWT leaders' back views and steps)."""
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    import pearl_pwt_frames as P
    return {code: {n: [lay['back'], *lay['back_steps'], *lay['front_steps']] for n, lay in P.LAYOUT.items()}
            for code in P.SHEETS}


def repainted_codes():
    """Codes whose sheets Pearl's own sprites replace whole (patches/pearl_npc_sprites, pearl_player_sprites)."""
    sys.path.insert(0, os.path.join(HERE, 'patches'))
    smap = json.load(open(os.path.join(ROOT, 'data', 'pearl_sprite_map.json')))
    import pearl_npc_sprites
    out = {smap[str(g)]['code'] for _, g, _, _ in pearl_npc_sprites.PEOPLE}
    out.add(smap[str(pearl_npc_sprites.DOOR[1])]['code'])
    out |= {231, 240}                   # the players' walk + run sheets (pearl_player_sprites), also the counterpart
    return out


# ---------------------------------------------------------------------------------------------------- the people

def step_use(code):
    """(dir, kind) a Pearl movement action draws, or None."""
    import pearl_story
    nm = (pearl_story.MOVEMENT.get(code) or {}).get('pearl_name', '')
    d = next((i for i, k in enumerate(('NORTH', 'SOUTH', 'WEST', 'EAST')) if nm.endswith('_' + k)), None)
    if d is None:
        return None
    return (d, 'stand' if nm.startswith('FACE_') or nm.startswith('JUMP_ON_SPOT') else 'walk')


def scripted_uses(pd, zone, uid):
    """[(where, (dir, kind), what)] of Pearl's scripts of `zone` moving its object uid."""
    import pearl_story
    out = []
    try:
        d = pd.disasm(zone['scripts'])
    except Exception:
        return out
    for a, (end, op, args) in sorted(d.insns.items()):
        name = pd.cmd_name(op)
        if not args or args[0][1] != uid:
            continue
        if name == 'ApplyMovement':
            for c, n in pearl_story.movement_steps(pd, zone['scripts'], args[1][1]):
                u = step_use(c)
                if u:
                    out.append((f'file {zone["scripts"]} 0x{a:x}', u, pearl_story.MOVEMENT[c]['pearl_name']))
        elif name == 'SetObjectEventDir' and args[1][0] != 'var' or name == 'SetObjectEventDir' and args[1][1] < 4:
            out.append((f'file {zone["scripts"]} 0x{a:x}', (args[1][1] & 3, 'stand'), f'SetObjectEventDir {args[1][1]}'))
        elif name == 'SetObjectEventMovementType':
            import pearl_events
            for u in move_uses(pearl_events.b2_move(args[1][1]), 1):
                out.append((f'file {zone["scripts"]} 0x{a:x}', u, f'SetObjectEventMovementType {args[1][1]}'))
    return out


def turns_on_talk(pd, zone, o):
    """Does talking to object o turn it to the player? (its local script has FacePlayer; trainers turn)."""
    import pearl_events
    kind = pearl_events.script_kind(o['script'])
    if kind == 'trainer':
        return True
    if kind != 'local':
        return kind == 'global'
    try:
        d = pd.disasm(zone['scripts'])
    except Exception:
        return False
    if o['script'] - 1 >= len(d.entries):
        return False
    start = d.entries[o['script'] - 1]
    seen, todo = set(), [start]
    while todo and len(seen) < 400:            # the script's own code, through jumps and calls
        a = todo.pop()
        while a in d.insns and a not in seen:
            seen.add(a)
            end, op, args = d.insns[a]
            nm = pd.cmd_name(op)
            if nm == 'FacePlayer':
                return True
            todo += [v for k, v in args if k == 'rel']
            if pd.table[op]['flow'] in ('end', 'jump', 'return'):
                break
            a = end
    return False


def people(pd, zones=None):
    """Every Pearl person Black 2 shows, with its code, Black 2 move code and direction (pearl_events.entities')."""
    import pearl_events
    for zone in pd.zones:
        if zones and zone['name'] not in zones:
            continue
        b2 = pd.b2_zone.get(zone['id'])
        if b2 is None:
            continue
        for o in pearl_events.kept_objects(pd, zone):
            code = pearl_events.sprite_code(o['graphics_id'], zone['name'])
            move, d = pearl_events.fit_move(o, code)
            yield zone, b2, o, code, move, d


def check(sh, pd, zones=None, maybe=False):
    import pearl_events
    heights = pearl_events.Heights()
    rows = []
    for zone, b2, o, code, move, d in people(pd, zones):
        inf = sh.info(code)
        if not inf or not inf['bad'] and not inf['made'] and all(f < inf['frames'] for a in inf['anims'][:8] for f in a):
            continue
        who = (f'{zone["name"]} (zone {b2}) obj {o["id"]} at ({o["x"]},{o["z"]}) gfx {o["graphics_id"]} '
               f'-> code {code}')
        miss = sh.missing(code, move_uses(move, d), official=True)
        if miss:
            rows.append(('MOVE', who, f'Pearl move {o["movement_type"]} dir {o["initial_dir"]} -> Black 2 move {move} '
                                      f'dir {d}: ' + ', '.join(f'{k} {DIRS[x]} = frames {b}' for x, k, b in miss)))
        for where, u, what in scripted_uses(pd, zone, o['id']):
            m = sh.missing(code, {u})
            if m:
                rows.append(('SCRIPT', who, f'{where} {what}: {u[1]} {DIRS[u[0]]} = frames {m[0][2]}'))
        if maybe and pearl_events.script_kind(o['script']) != 'none' and turns_on_talk(pd, zone, o):
            for side, (dx, dz) in DIRV.items():
                if not heights.solid(zone, o['x'] + dx, o['z'] + dz) and not sh.can(code, side):
                    rows.append(('TALK', who, f'talked to from the {DIRS[side]} side ({o["x"] + dx},{o["z"] + dz}): '
                                              f'turns {DIRS[side]} = frames {sh.missing(code, {(side, "stand")})[0][2]}'))
    return rows


def main(argv):
    import argparse
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--rom')
    ap.add_argument('--zone', nargs='*')
    ap.add_argument('--all', action='store_true')
    ap.add_argument('--sheets', action='store_true')
    a = ap.parse_args(argv)
    sh = Sheets(a.rom)
    if a.sheets:
        for code in list(range(377)) + list(range(0x1000, 0x126C)):
            inf = sh.info(code)
            if inf and inf['bad']:
                print(f'code {code}: sheet {inf["sheet"]}, set {inf["ctrl"]}, {inf["frames"]} frames, '
                      f'placeholders {inf["bad"]}')
        return 0
    import pearl_story
    pd = pearl_story.PearlData()
    rows = check(sh, pd, set(a.zone) if a.zone else None, maybe=a.all)
    for kind, who, what in rows:
        print(f'{kind:6} {who}: {what}')
    n = collections.Counter(k for k, _, _ in rows)
    print(f'\n{len(rows)} cases: ' + ', '.join(f'{v} {k}' for k, v in n.items()) if rows else 'no person draws a '
          'placeholder picture')
    return 1 if n['MOVE'] or n['SCRIPT'] else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
