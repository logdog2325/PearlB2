"""Scripted-path checker for the translated story (user 2026-10-19: "a careful glitch check"; HoennB2's rooms_check
kind d for PearlB2): every scene played twice offline, once as Pearl plays it (Pearl's script from the dump, the player
where Pearl puts them) and once as Black 2 will (the GENERATED file src/field_scripts/NNNN_pearl_<zone>.s, its pl_
macros as Black 2 runs them, Black 2's warp arrivals from patches/sinnoh_events), and what goes wrong only in Black 2
is reported. Collision is Pearl's for both (the converted maps keep Pearl's tiles; the only extra solid tiles are the
overworld entrance mats made bump warps, which look the same and only move where an arriving player stands).

    python3 b2tools/scene_check.py [chapter N ...] [zone NAME ...] [--all]   (default: chapters 1 2 90)
        --all  also print what goes wrong in Pearl itself (scenes checked from a start the scene is not made for),
               scene actors hidden by a flag on solid tiles, rooms no player reaches, and the ACCEPT list
Regenerate first (pearl_story.py chapter N): the Black 2 side reads the generated files.

Scenes and where the player stands when they start:
- a person's talk script: on each walkable tile beside them, facing them (the person turns: FacePlayer);
- a step trigger: on each of its tiles (its var at its value);
- a map script of the frame table (var == value): after every arrival into the zone (each warp into it: Pearl puts
  the player on a door's outside tile, on a mat, and on the stairs' foot; Black 2 steps them off the warp by its dir:
  the same tiles, except the overworld's entrance mats, bump warps, where Black 2's player stands one tile out), after
  every Pearl Warp into the zone (its tile and facing), and the new game's start; the zone's on-transition script
  (Black 2's zone init) runs first with the same vars;
- the code after a Warp (a continuation, run in the destination): the Warp's tile.
Branches the checker cannot decide (flags, other vars) are all followed (at most PATHS per scene).

Findings (one line each: zone, scene, start, what):
- wall     a scripted walk (ApplyMovement of a person or the player) enters a solid tile or leaves the map
- person   it walks into a person standing there (not one moving in the same batch)
- overlap  two movers end a batch on one tile
- face     a mover ends beside the player and facing them in Pearl, but not in Black 2 (the scene talks past the player)
- place    a script places a person (SetObjectEventPos / SetPosition / AddObject at its place) on a solid tile, or
           Black 2 moves a person who is on screen where Pearl only changes where they appear next time
- stand    a person of the zone's events stands on a solid tile, or two people share a tile
- copy     a copy of a neighbouring zone's object (script 0xFFFF) installed with a hide flag that is not its original's
- flag     a RemoveObject that sets another flag than the removed person's own hide flag
- ontrigger  an arrival that Black 2 puts on a step trigger where Pearl's player stands elsewhere (it does not fire)
Findings checked and left on purpose: ACCEPT below (each with its reason; --all prints them).
Movement lists come from pearl_story.movement_steps (Pearl's, with data/pearl_path_fixes.json applied).
"""
import collections, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import pearl_story, pearl_events, warp_check  # noqa: E402
from patches import sinnoh_events  # noqa: E402

DIRV = {0: (0, -1), 1: (0, 1), 2: (-1, 0), 3: (1, 0)}      # Pearl's (and Black 2's) directions: up, down, left, right
NAME_DIR = {'NORTH': 0, 'SOUTH': 1, 'WEST': 2, 'EAST': 3}
PLAYER = 0xFF
SKIP_ACTORS = {0xF1, 0xF2, 0xFE}                            # the free camera, the follower (its tile is not known here)
PATHS = 48
SIGN_GFX = pearl_events.SIGN_GFX


def step_of(code):
    """(direction or None, tiles moved, turns) of one Pearl movement code."""
    info = pearl_story.MOVEMENT.get(code) or {}
    nm = info.get('pearl_name', '')
    d = next((v for k, v in NAME_DIR.items() if nm.endswith('_' + k)), None)
    if d is None:
        return None, 0, False
    if nm.startswith(('FACE_', 'WALK_ON_SPOT', 'JUMP_ON_SPOT')):
        return d, 0, True
    if nm.startswith('JUMP_FARTHER'):
        return d, 3, True
    if nm.startswith('JUMP_FAR'):
        return d, 2, True
    if nm.startswith(('WALK_', 'RUN_', 'JUMP_NEAR')):
        return d, 1, True
    return d, 0, False


# (zone regex, finding regex, reason): checked and left on purpose (--all prints them too)
ACCEPT = [
    # (2026-10-25: the Verity Lakefront ontrigger entry went with sinnoh_events.entrance_arrivals: arrivals through an
    # overworld entrance mat now land on the mat, Pearl's tile)
    ('RESORT_AREA', r'\(stand\) person 11 at \(819, 458\)',
     "Pearl's swimmer in the Resort Area's pool (\"I spend a lot of time in the pool\"): a water tile, as in "
     "Pearl (2026-10-26, chapter 9a)"),
]


class PearlProg:
    """Pearl's own code (one script file, from the dump): positions are addresses."""

    def __init__(self, pd, f):
        self.pd, self.f, self.d = pd, f, pd.disasm(f)

    def entry(self, k):
        return self.d.entries[k - 1] if 1 <= k <= len(self.d.entries) else None

    def insn(self, a):
        """(name, values, next, jump target or None) or None."""
        if a not in self.d.insns:
            return None
        end, op, args = self.d.insns[a]
        name = self.pd.cmd_name(op)
        vals = [v for t, v in args]
        tgt = next((v for t, v in args if t in ('rel',)), None)
        if name in ('GoToIf', 'CallIf'):
            vals = vals[:1]
        if name == 'CallCommonScript':
            name = 'Ignore'
        if name == 'ApplyMovement':
            vals = [vals[0], (self.f, vals[1])]
        return name, vals, end, tgt

    def moves(self, key):
        return [(c, n) for c, n in pearl_story.movement_steps(self.pd, key[0], key[1])]


B2_INVERSE = {}
for _c, _i in sorted(pearl_story.MOVEMENT.items(), key=lambda kv: (not kv[1].get('exact'), kv[0])):
    if _i.get('b2') is not None:
        B2_INVERSE.setdefault(_i['b2'], _c)


def b2_value(tok):
    tok = tok.strip()
    m = re.fullmatch(r'P(VAR|FLAG)_([0-9A-Fa-f]+)', tok)
    if m:
        return int(m.group(2), 16)
    if tok == 'PL_PLAYER':
        return 0xFF
    if tok == 'PL_FOLLOWER':
        return 0xFE
    try:
        return int(tok, 0)
    except ValueError:
        return None


def label_key(lbl):
    """(Pearl file, address) of a generated label (P981_00B0, C205_45_0336, W392_0508_0514), or the label."""
    m = re.fullmatch(r'[PCTW](\d+)(?:_[0-9A-F]+)?_([0-9A-F]{4})', lbl)
    return (int(m.group(1)), int(m.group(2), 16)) if m else lbl


class B2Prog:
    """The generated Black 2 file (src/field_scripts/NNNN_pearl_<zone>.s, the pl_ macros): positions are line
    indices; what the ROM gets (path fixes and the translation's choices included)."""

    def __init__(self, pd, zone, kept):
        num = pd.script_file(zone)
        path = next((os.path.join(pearl_story.SRC_SCRIPTS, n) for n in os.listdir(pearl_story.SRC_SCRIPTS)
                     if n.startswith(f'{num:04d}_pearl_')), None)
        self.ok = path is not None
        self.path = path
        self.kept = kept                                    # NPC index -> Pearl object id
        self.code, self.labels, self.movs, self.entries = [], {}, {}, []
        if not self.ok:
            return
        cur_mov = None
        for raw in open(path):
            ln = raw.split('//', 1)[0].rstrip()
            comment = raw.split('//', 1)[1] if '//' in raw else ''
            if not ln.strip() or ln.strip().startswith('.balign') or ln.startswith('#'):
                continue
            m = re.match(r'^([A-Za-z_.][\w.]*):\s*$', ln)
            if m:
                self.labels[m.group(1)] = len(self.code)
                cur_mov = m.group(1)
                continue
            parts = ln.strip().split(None, 1)
            mac, args = parts[0], [a.strip() for a in parts[1].split(',')] if len(parts) > 1 else []
            if mac == 'ScriptEntry':
                self.entries.append(args[0]); continue
            if mac == 'Move':
                self.movs.setdefault(cur_mov, []).append((B2_INVERSE.get(int(args[0]), int(args[0])), int(args[1])))
                continue
            if mac == 'MoveEnd':
                self.movs.setdefault(cur_mov, []); continue
            cur_mov = None
            self.code.append((mac, args, comment))

    def entry(self, k):
        return self.labels.get(self.entries[k - 1]) if 1 <= k <= len(self.entries) else None

    def insn(self, i):
        if not 0 <= i < len(self.code):
            return None
        mac, args, comment = self.code[i]
        name = mac[3:] if mac.startswith('pl_') else mac
        vals = [b2_value(a) for a in args]
        nxt, tgt = i + 1, None
        if name in ('GoTo', 'Call', 'VMJump', 'VMCall'):
            tgt = self.labels.get(args[0])
            name = {'VMJump': 'GoTo', 'VMCall': 'Call'}.get(name, name)
            if name == 'Call' and args[0][:1] in 'CT':      # Pearl's common scripts (not followed, as Pearl's)
                name = 'Ignore'
        elif name in ('GoToIf', 'CallIf'):
            tgt = self.labels.get(args[1]); vals = vals[:1]
        elif name == 'VMReturn':
            name = 'Return'
        elif name in ('VMHalt',):
            name = 'End'
        elif name in ('ApplyMovement', 'ApplyMovementF'):    # (F: the person, or the follower once they follow)
            name = 'ApplyMovement'
            vals = [vals[0], args[1]]
        elif name.startswith('msg_'):
            name = 'Message'
        elif name == 'SetObjectEventPos':                   # zone init: NPC index, x, z, dir, y
            name = 'B2InitPos'
            vals = [self.kept[vals[0]] if vals[0] is not None and vals[0] < len(self.kept) else None] + vals[1:4]
        elif name == 'SetPosition':                         # the live actor: uid, x, y, z, dir
            name = 'B2LivePos'
            vals = [vals[0], vals[1], vals[3], vals[4], 'SetObjectEventPos' in comment]
        elif name == 'SetObjectEventPosLater':              # slot, uid, x, y, z, dir: the live actor + the slot
            name = 'B2LaterPos'
            vals = [vals[1], vals[2], vals[4], vals[5], vals[0]]
        elif name == 'AddObjectAt':                         # uid, slot, dir
            name = 'B2AddAt'
            vals = [vals[0], vals[1], vals[2]]
        return name, vals, nxt, tgt

    def moves(self, lbl):
        return self.movs.get(lbl, [])


class Zone:
    """One Pearl zone: its people, collision (Pearl's and Black 2's), its two programs."""

    def __init__(self, ck, pid):
        self.ck, self.pid = ck, pid
        self.z = ck.pd.zones[pid]
        self.name = self.z['name']
        self.b2 = ck.pd.b2_zone[pid]
        self.ev = ck.pd.events(self.z)
        self.objects = {o['id']: o for o in self.ev['object_events'] if o['script'] != pearl_events.COPY_SCRIPT}
        self.f = self.z['scripts']
        self.pearl = PearlProg(ck.pd, self.f)
        self.b2prog = B2Prog(ck.pd, self.z, [None if o['script'] == pearl_events.COPY_SCRIPT else o['id']
                                             for o in pearl_events.kept_objects(ck.pd, self.z)])
        self.entries, self.tables = pearl_events.level_scripts(ck.pd, self.z)

    def prog(self, version, f=None):
        if version == 'b2':
            return self.b2prog
        return self.pearl if f in (None, self.f) else PearlProg(self.ck.pd, f)

    def solid(self, version, x, z):
        """Pearl's collision, for both versions: the only tiles the converted maps make solid besides are bump warps
        (the overworld's entrance mats), which look like Pearl's (a scripted walk onto one looks the same; Black 2's
        scripted moves do not check collision) and only change where an arriving player stands (arrivals())."""
        t = self.ck.W.pl.tile(self.ck.W.pl.matrix(self.z['matrix']), x, z)
        return t is None or bool(t[1])

    def is_sign(self, uid):
        o = self.objects.get(uid)
        return o is not None and o['graphics_id'] in SIGN_GFX


class Checker:
    def __init__(self):
        self.pd = pearl_story.PearlData()
        self.W = warp_check.Warps('offline')
        self._zones = {}
        self._reach = None

    def zone(self, pid):
        if pid not in self._zones:
            self._zones[pid] = Zone(self, pid)
        return self._zones[pid]

    # ---- arrivals
    def arrivals(self, zn):
        """[(label, Pearl (x, z, dir), Black 2 (x, z, dir))] of every way into zone zn (dir None: unknown)."""
        W, out = self.W, []
        pl = W.pl
        m = pl.matrix(zn.z['matrix'])
        for b2, ws in W.warps.items():
            for i, w in enumerate(ws):
                if w['dest_zone'] != zn.b2 or w['x'] >= warp_check.OFF_MAP:
                    continue
                dw = w['dest_warp']
                if dw == sinnoh_events.DEST_NEXT_ZONE or dw >= len(W.warps[zn.b2]):
                    continue
                d = W.warps[zn.b2][dw]
                if d['x'] >= warp_check.OFF_MAP:
                    continue
                tx, tz = W.at(d)
                b = W.arrival(zn.b2, dw)
                bdir = {0: 0, 1: 0, 2: 1, 3: 2, 4: 3}.get(d['dir']) if d['type'] not in (0, 1) else None   # stepped that way
                t = pl.tile(m, tx, tz)
                beh = t[0] if t else 0
                if beh == 0x5e:                                 # Pearl: on the stairs, walked off them westwards
                    p = (tx, tz, 2)
                elif beh == 0x5f:
                    p = (tx, tz, 3)
                elif t and t[1]:                                # a door / cave mouth: walked out onto its neighbour
                    p = (b[0], b[1], bdir)
                else:                                           # a mat: on it
                    p = (tx, tz, None)
                key = (p, (b[0], b[1], bdir))
                if key not in [(a[1], a[2]) for a in out]:
                    out.append((f'arriving from {W.name(b2)} warp {i} (warp {dw})', p, (b[0], b[1], bdir)))
        for f, a, after, bank in self.pd.warp_continuations(zn.pid):
            e, op, args = self.pd.disasm(f).insns[a]
            x, z, dr = args[2][1], args[3][1], args[4][1]
            if x < 0x4000 and z < 0x4000:
                out.append((f'after the Warp of Pearl file {f} at {a:04X}', (x, z, dr), (x, z, dr)))
        if zn.name == pearl_story.PEARL_START[0]:
            _, x, z, dr = pearl_story.PEARL_START
            out.append(('the new game', (x, z, dr), (x, z, dr)))
        return out

    # ---- scenes
    def scenes(self, zn):
        """[(label, {'pearl': (file, start), 'b2': start}, {'pearl': (x, z, dir), 'b2': ...}, vars, talker, pre)]."""
        out = []
        nent = len(zn.pearl.d.entries)
        both = lambda k: {'pearl': (zn.f, zn.pearl.entry(k)), 'b2': zn.b2prog.entry(k)}
        for o in zn.ev['object_events']:
            k = o['script']
            if not 1 <= k <= nent or o['trainer_type'] or zn.is_sign(o['id']):
                continue
            for dr, (dx, dz) in DIRV.items():
                x, z = o['x'] - dx, o['z'] - dz                 # the player stands there facing dr, at the person
                if zn.solid('pearl', x, z) and zn.solid('b2', x, z):
                    continue
                st = (x, z, dr)
                out.append((f'talk to {o["id"]} from {(x, z)}', both(k), {'pearl': st, 'b2': st}, {}, o['id'], False))
        for c in zn.ev['coord_events']:
            k = c['script']
            if not 1 <= k <= nent:
                continue
            for x in range(c['x'], c['x'] + c['width']):
                for z in range(c['z'], c['z'] + c['length']):
                    st = (x, z, None)
                    out.append((f'trigger {k} at {(x, z)}', both(k), {'pearl': st, 'b2': st}, {c['var']: c['value']},
                                None, False))
        arr = None
        for rows in zn.tables:
            for var, val, k in rows:
                if not 1 <= k <= nent:
                    continue
                arr = arr if arr is not None else self.arrivals(zn)
                for lbl, p, b in arr:
                    out.append((f'map script {k} ({var:#x} == {val}), {lbl}', both(k), {'pearl': p, 'b2': b},
                                {var: val}, None, True))
        for f, a, after, bank in self.pd.warp_continuations(zn.pid):
            e, op, args = self.pd.disasm(f).insns[a]
            x, z, dr = args[2][1], args[3][1], args[4][1]
            lbl = f'W{f}_{a:04X}_S'
            if x < 0x4000 and z < 0x4000 and lbl in zn.b2prog.labels:
                out.append((f'continuation of Pearl file {f} at {a:04X}', {'pearl': (f, after), 'b2': zn.b2prog.labels[lbl]},
                            {'pearl': (x, z, dr), 'b2': (x, z, dr)}, {}, None, False))
        return out

    def installed(self, z):
        """The zone's Black 2 people as sinnoh_story installs them (pearl_events.entities), by Pearl object."""
        if not hasattr(self, '_ids'):
            import pearl_ids
            self._ids, self._heights = pearl_ids.Ids(), pearl_events.Heights()
        npcs = pearl_events.entities(self.pd, z, self._ids, self._heights, lambda s: s)[0]
        return list(zip(pearl_events.kept_objects(self.pd, z), npcs))

    def copies(self, zn):
        """(copy) a copy of a neighbouring zone's object (script 0xFFFF) whose Black 2 hide flag is not its original's
        (Pearl keeps the live original when you cross: the copy must be hidden exactly when the original is)."""
        out = []
        for o, n in self.installed(zn.z):
            if o['script'] != pearl_events.COPY_SCRIPT:
                continue
            orig = pearl_events.copy_original(self.pd, o)
            if orig is None:
                out.append(f'(copy) object {o["id"]} at {(o["x"], o["z"])}: a copy without an original in zone '
                           f'{o["hidden_flag"]}')
                continue
            oz = self.pd.zones[o['hidden_flag']]
            on = next((n2 for o2, n2 in self.installed(oz) if o2 is orig), None) if oz['id'] in self.pd.b2_zone else None
            want = on['flag'] if on is not None else (self._ids.flag_value(orig['hidden_flag']) if orig['hidden_flag'] else 0)
            if n['flag'] != want:
                out.append(f'(copy) object {o["id"]} at {(o["x"], o["z"])} (a copy of {oz["name"]} object {orig["id"]}): '
                           f'hide flag {n["flag"]}, its original {want}')
        return out

    def run(self, zn, version, scene):
        label, starts, st, known, talker, pre = scene
        sim = Sim(self, zn, version, st[version], dict(known), talker)
        if pre:
            for t, s in zn.entries:
                if t == 2 and 1 <= s <= len(zn.pearl.d.entries):
                    sim.explore(zn.prog(version), zn.pearl.entry(s) if version == 'pearl' else zn.b2prog.entry(s), 2)
            sim.commit_pre()
        if version == 'pearl':
            f, a = starts['pearl']
            sim.explore(zn.prog('pearl', f), a, 0)
        else:
            sim.explore(zn.b2prog, starts['b2'], 0)
        return sim

    def check_zone(self, pid, show_all=False):
        zn = self.zone(pid)
        lines = []
        if not zn.b2prog.ok:
            return zn, ['(no generated file: run pearl_story.py for its chapter)']
        if self._reach is None:
            self._reach = self.W.reachable()
        region, usable, overworld = self._reach
        if zn.b2 not in overworld and not region.get(zn.b2) and not show_all:
            return zn, []                                      # no player gets there (warp_check: accepted)
        seen = {}
        for o in zn.ev['object_events']:
            if zn.is_sign(o['id']) or pearl_events.object_skipped(o, zn.z):
                continue
            x, z = o['x'], o['z']
            if zn.solid('b2', x, z) and (show_all or not o['hidden_flag']):
                # (a person hidden by a flag on a solid tile is Pearl's own scene actor in a doorway or the grass:
                # Barry at his door, Dawn at the lab's, the Starly at the lake; listed with --all)
                lines.append(f'(stand) person {o["id"]} at {(x, z)} stands on a solid tile')
            if (x, z) in seen and not (o['hidden_flag'] and zn.objects[seen[(x, z)]]['hidden_flag']):
                lines.append(f'(stand) people {seen[(x, z)]} and {o["id"]} share {(x, z)}')
            seen.setdefault((x, z), o['id'])
        lines += self.copies(zn)
        trig = collections.defaultdict(list)                # an arrival onto a step trigger: Black 2 fires it only
        for c in zn.ev['coord_events']:                    # when the player steps onto it, not on arrival
            for x in range(c['x'], c['x'] + c['width']):
                for z in range(c['z'], c['z'] + c['length']):
                    trig[(x, z)].append(f'{c["script"]} ({c["var"]:#x} == {c["value"]})')
        for lbl, p, b in self.arrivals(zn):
            if p[:2] != b[:2] and b[:2] in trig:
                lines.append(f'(ontrigger) {lbl}: Black 2\'s player arrives on {b[:2]} (Pearl\'s on {p[:2]}), a step '
                             f'trigger ({", ".join(trig[b[:2]])}) that then does not fire')
        for mac, args, comment in zn.b2prog.code:          # RemoveObject sets the removed person's own hide flag
            if mac == 'pl_RemoveObject' and len(args) == 2:
                uid, flag = b2_value(args[0]), b2_value(args[1])
                o = zn.objects.get(uid)
                if o is not None and (flag or 0) != o['hidden_flag']:
                    lines.append(f'(flag) RemoveObject {uid} sets Pearl flag {flag:#x}, not the person\'s own hide flag '
                                 f'{o["hidden_flag"]:#x}: they come back when the zone reloads')
        for scene in self.scenes(zn):
            res = {v: self.run(zn, v, scene) for v in ('pearl', 'b2')}
            pk = {k for k, _ in res['pearl'].findings}
            for key, msg in res['b2'].findings:
                if key not in pk:
                    lines.append(f'[{scene[0]}] {msg}')
            bk = res['b2'].facing
            for key, ok in res['pearl'].facing.items():
                if ok and not bk.get(key, False):
                    lines.append(f'[{scene[0]}] (face) person {key[0]} ends beside Pearl\'s player and facing them after '
                                 f'movement {key[1][0]}:{key[1][1]:04X}, not beside / facing the player in Black 2 '
                                 f'({res["b2"].where.get(key, "?")})')
            if show_all:
                for key, msg in res['pearl'].findings:
                    lines.append(f'[{scene[0]}] PEARL {msg}')
        lines = [ln for ln in lines if show_all or not any(re.fullmatch(zr, zn.name[4:]) and re.search(rx, ln)
                                                           for zr, rx, why in ACCEPT)]
        out, dup = [], set()
        for ln in lines:                                       # the same problem from several starts: once
            k = re.sub(r'^\[[^\]]*\] ', '', ln)
            if k in dup:
                continue
            dup.add(k)
            out.append(ln)
        return zn, out


class Sim:
    """One scene played in one version: positions, facing, visibility, known vars; paths forked on unknowns."""

    def __init__(self, ck, zn, version, start, known, talker):
        self.ck, self.zn, self.version = ck, zn, version
        self.findings = []          # [(key, message)]
        self.facing = {}            # (mover, movement key) -> beside + facing the player at the next line
        self.where = {}
        pos, dirs, vis = {}, {}, {}
        for o in zn.ev['object_events']:
            if (version == 'b2' and pearl_events.object_skipped(o, zn.z)) or o['script'] == pearl_events.COPY_SCRIPT:
                continue
            pos[o['id']] = (o['x'], o['z'])
            dirs[o['id']] = o['initial_dir']
            vis[o['id']] = None if o['hidden_flag'] else True        # hidden by a flag: not known
        x, z, dr = start
        pos[PLAYER], dirs[PLAYER], vis[PLAYER] = (x, z), dr, True
        self.base = dict(pos=pos, dirs=dirs, vis=vis, tmpl={}, slots={}, vars=known, flags={}, talker=talker)
        self.pre_states = None

    def commit_pre(self):
        """After the zone init / on-transition script: its first path's object places become the scene's start."""
        if self.pre_states:
            self.base = self.pre_states[0]
        self.pre_states = None

    def note(self, key, msg):
        if key not in [k for k, _ in self.findings]:
            self.findings.append((key, msg))

    def explore(self, prog, a, level):
        if a is None:
            return
        st = self.copy(self.base)
        st.update(stack=[], pending=[], moved=[], cmp=None, steps=0)
        todo, paths, ends = [(a, st)], 0, []
        while todo and paths < PATHS:
            a, st = todo.pop()
            paths += 1
            while True:
                st['steps'] += 1
                ins = prog.insn(a) if st['steps'] < 3000 else None
                if ins is None:
                    break
                name, vals, nxt, tgt = ins
                if name in ('End', 'ReturnCommonScript', 'Warp'):
                    self.batch(st, prog)
                    break
                if name == 'Return':
                    if not st['stack']:
                        self.batch(st, prog)
                        break
                    nxt = st['stack'].pop()
                elif name == 'GoTo':
                    nxt = tgt
                elif name == 'Call':
                    st['stack'].append(nxt); nxt = tgt
                elif name in ('GoToIf', 'CallIf'):
                    taken = self.cond(st['cmp'], vals[0])
                    if taken is None:                        # unknown: both ways
                        other = self.copy(st)
                        if name == 'CallIf':
                            other['stack'].append(nxt)
                        todo.append((tgt, other))
                        taken = False
                    if taken:
                        if name == 'CallIf':
                            st['stack'].append(nxt)
                        nxt = tgt
                else:
                    self.op(st, name, vals, prog, level)
                if nxt is None:
                    break
                a = nxt
            ends.append(st)
        if level == 2:
            self.pre_states = [{k: st[k] for k in self.base} for st in ends] or None

    @staticmethod
    def copy(st):
        return {k: (dict(v) if isinstance(v, dict) else list(v) if isinstance(v, list) else v) for k, v in st.items()}

    @staticmethod
    def cond(cmp, c):
        if cmp is None or c is None or c >= 6:
            return None
        lut = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (0, 1, 1), (1, 0, 1)]
        return bool(lut[c][cmp])

    @staticmethod
    def value(st, v):
        if v is None:
            return None
        if v >= 0x4000:
            return st['vars'].get(v)
        return v

    def op(self, st, name, vals, prog, level):
        pos, dirs, vis = st['pos'], st['dirs'], st['vis']
        b2 = self.version == 'b2'
        if name == 'CompareVarToValue':
            x = self.value(st, vals[0])
            st['cmp'] = None if x is None else (0 if x < vals[1] else 1 if x == vals[1] else 2)
        elif name == 'CompareVarToVar':
            x, y = self.value(st, vals[0]), self.value(st, vals[1])
            st['cmp'] = None if x is None or y is None else (0 if x < y else 1 if x == y else 2)
        elif name == 'CheckFlag':
            v = st['flags'].get(vals[0])
            st['cmp'] = None if v is None else int(v)
        elif name == 'SetFlag':
            st['flags'][vals[0]] = True
        elif name == 'ClearFlag':
            st['flags'][vals[0]] = False
        elif name == 'SetVarFromValue':
            if vals[0] is not None:
                st['vars'][vals[0]] = vals[1]
        elif name == 'SetVarFromVar':
            if vals[0] is not None:
                st['vars'][vals[0]] = self.value(st, vals[1])
        elif name == 'GetPlayerDir':
            st['vars'][vals[0]] = dirs.get(PLAYER)
        elif name == 'GetPlayerMapPos':
            x, z = pos[PLAYER]
            st['vars'][vals[0]], st['vars'][vals[1]] = x, z
        elif name.startswith(('Get', 'Show', 'Check', 'Count', 'Can', 'Find', 'AddVar', 'SubVar', 'Open')) and vals \
                and vals[-1] is not None and vals[-1] >= 0x4000:
            st['vars'][vals[-1]] = None                          # a result var: not known here
            if name in ('AddVar', 'SubVar'):
                st['vars'][vals[0]] = None
        elif name == 'FacePlayer':
            t = st['talker']
            if t is not None and t in pos:
                dx, dz = pos[PLAYER][0] - pos[t][0], pos[PLAYER][1] - pos[t][1]
                dirs[t] = next((k for k, v in DIRV.items() if v == (dx, dz)), dirs[t])
        elif name == 'ApplyMovement':
            uid = self.value(st, vals[0])
            if uid is not None and uid not in SKIP_ACTORS:
                st['pending'].append((uid, vals[1]))
        elif name == 'WaitMovement':
            self.batch(st, prog)
        elif name == 'Message' or name in pearl_story.FileTr.MSG_OPS:
            self.batch(st, prog)
            for uid, key in st['moved']:
                if uid == PLAYER or not vis.get(uid) or uid not in pos:
                    continue
                (x, z), (px, pz) = pos[uid], pos[PLAYER]
                d = dirs.get(uid)
                ok = abs(x - px) + abs(z - pz) == 1 and d is not None and DIRV[d] == (px - x, pz - z)
                self.facing[(uid, key)] = ok
                self.where[(uid, key)] = f'person at {(x, z)}, the player at {(px, pz)}'
            st['moved'] = []
        elif name == 'AddObject':
            uid = self.value(st, vals[0])
            if uid in pos or uid in st['tmpl']:
                if uid in st['tmpl']:
                    pos[uid] = st['tmpl'][uid]
                vis[uid] = True
                if level != 2 and self.zn.solid(self.version, *pos[uid]):
                    self.note(('place', uid, pos[uid]), f'(place) person {uid} appears on solid {pos[uid]} (AddObject)')
        elif name == 'B2LaterPos':
            uid, x, z, dr = (self.value(st, v) for v in vals[:4])
            slot = vals[4]
            if uid is None or x is None or z is None:
                return
            if self.zn.solid(self.version, x, z):
                self.note(('place', uid, (x, z)), f'(place) person {uid} placed on solid {(x, z)} (SetObjectEventPos)')
            if vis.get(uid) and pos.get(uid) not in (None, (x, z)):
                self.note(('teleport', uid, (x, z)), f'(place) person {uid} on screen at {pos.get(uid)} jumps to '
                          f'{(x, z)}: Black 2 moves the live person where Pearl only sets where they appear next time')
            if vis.get(uid):
                pos[uid] = (x, z)
            st['slots'][slot] = (x, z)
        elif name == 'B2AddAt':
            uid, slot, dr = self.value(st, vals[0]), vals[1], vals[2]
            if uid in pos:
                if slot in st['slots']:
                    pos[uid] = st['slots'][slot]
                vis[uid] = True
                if self.zn.solid(self.version, *pos[uid]):
                    self.note(('place', uid, pos[uid]), f'(place) person {uid} appears on solid {pos[uid]} (AddObject)')
        elif name == 'RemoveObject':
            vis[self.value(st, vals[0])] = False
        elif name in ('SetObjectEventPos', 'B2InitPos'):            # Pearl's (any level) / Black 2's zone init
            uid, x, z = (self.value(st, v) for v in vals[:3])
            if uid is None or x is None or z is None:
                return
            if self.zn.solid(self.version, x, z):
                self.note(('place', uid, (x, z)), f'(place) person {uid} placed on solid {(x, z)} (SetObjectEventPos)')
            st['tmpl'][uid] = (x, z)
            if level == 2 or name == 'B2InitPos':
                pos[uid] = (x, z)
                if name == 'B2InitPos' and len(vals) > 3 and vals[3] is not None:
                    dirs[uid] = vals[3]
        elif name == 'SetObjectEventDir':
            uid, dr = (self.value(st, v) for v in vals)
            if uid is not None and dr is not None and level == 2:
                dirs[uid] = dr
        elif name in ('SetPosition', 'B2LivePos'):
            if name == 'SetPosition':
                uid, x, y, z, dr = (self.value(st, v) for v in vals)
                from_ev = False
            else:
                uid, x, z, dr = (self.value(st, v) for v in vals[:4])
                from_ev = vals[4]
            if uid is None or x is None or z is None:
                return
            if self.zn.solid(self.version, x, z):
                self.note(('place', uid, (x, z)), f'(place) person {uid} set on solid {(x, z)} (SetPosition)')
            if from_ev and vis.get(uid) and pos.get(uid) not in (None, (x, z)):
                self.note(('teleport', uid, (x, z)), f'(place) person {uid} on screen at {pos.get(uid)} jumps to '
                          f'{(x, z)}: Black 2 moves the live person where Pearl only sets where they appear next time')
            st['tmpl'][uid] = (x, z)
            pos[uid] = (x, z)
            if dr is not None:
                dirs[uid] = dr

    def batch(self, st, prog):
        """Run the pending movements (they started together; WaitMovement waits for all)."""
        if not st['pending']:
            return
        pos, dirs, vis = st['pos'], st['dirs'], st['vis']
        movers = [u for u, _ in st['pending']]
        start = {u: pos.get(u) for u in movers}
        for uid, mov in st['pending']:
            if pos.get(uid) is None or (uid != PLAYER and vis.get(uid) is False):
                continue
            if vis.get(uid) is None and any(step_of(c)[1] for c, n in prog.moves(mov)):
                vis[uid] = True                                  # (hidden by a flag, walking now: on screen)
            key = mov if isinstance(mov, tuple) else label_key(mov)
            lbl = f'{key[0]}:{key[1]:04X}' if isinstance(key, tuple) else key
            who = 'the player' if uid == PLAYER else f'person {uid}'
            x, z = pos[uid]
            for code, n in prog.moves(mov):
                d, tiles, turns = step_of(code)
                if d is None:
                    continue
                for _ in range(n):
                    dirs[uid] = d
                    for _t in range(tiles):
                        x, z = x + DIRV[d][0], z + DIRV[d][1]
                        if self.zn.solid(self.version, x, z):
                            self.note(('wall', uid, key), f'(wall) {who} walks from {start[uid]} into solid {(x, z)} '
                                      f'(movement {lbl})')
                        for o, p in pos.items():
                            if o != uid and o not in movers and p == (x, z) and vis.get(o):
                                ow = 'the player' if o == PLAYER else f'person {o}'
                                self.note(('person', uid, key), f'(person) {who} walks from {start[uid]} into {ow} '
                                          f'at {(x, z)} (movement {lbl})')
            pos[uid] = (x, z)
            st['moved'].append((uid, key))
        ends = collections.Counter(pos[u] for u in set(movers) if pos.get(u) is not None and vis.get(u))
        for p, n in ends.items():
            if n > 1:
                who = sorted(u for u in set(movers) if pos.get(u) == p)
                self.note(('overlap', tuple(who), p), f'(overlap) {who} all end on {p}')
        st['pending'] = []


def main(argv):
    chapters, zones, show_all = [], [], '--all' in argv
    args = [a for a in argv if a != '--all']
    i = 0
    while i < len(args):
        if args[i] == 'chapter':
            chapters.append(int(args[i + 1]) if args[i + 1].isdigit() else args[i + 1]); i += 2
        elif args[i] == 'zone':
            zones.append(args[i + 1]); i += 2
        else:
            i += 1
    if not chapters and not zones:
        chapters = [1, 2, 90]
    names = [n for c in chapters for n in pearl_story.CHAPTERS[c]] + zones
    ck = Checker()
    total = collections.Counter()
    for n in names:
        pid = ck.pd.by_name[n]['id'] if n in ck.pd.by_name else int(n)
        zn, lines = ck.check_zone(pid, show_all)
        for ln in lines:
            print(f'{zn.name[4:]}: {ln}')
            m = re.search(r'\((\w+)\)', ln)
            total[m.group(1) if m else '?'] += 1
    print('summary:', dict(total))
    return 1 if total else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
