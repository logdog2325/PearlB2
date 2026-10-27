"""battle_crash: catch ARM9 data reads/writes (and code fetches) that real hardware would abort on.

Black 2 sets the ARM9 protection unit (melonDS 1.1 log, work/agents/museum_freeze/melon/melon_log.txt) to:
  04000000-07FFFFFF, 02000000-03FFFFFF, 027FF000+4K, 08000000-0FFFFFFF, 02FE0000+16K (DTCM),
  01000000-01FFFFFF (ITCM), FFFF0000+32K (BIOS), 02FFF000+4K.
Anything outside is a data abort (crash) on DS/3DS and melonDS. DeSmuME has no protection unit: it masks the address
(0x12345678 reads main RAM, 0x00000010 reads ITCM) and carries on.

How the watcher works (py-desmume 0.0.9's libdesmume, checked by disassembly 2026-10-13):
  * every ARM9/ARM7 load/store handler (and the HLE BIOS copies, DMA) first tests the RAW address against
    `hooked_regions[type]` (a TieredRegion: broad/mid/narrow vectors of [start,end) islands; type 0 write, 1 read,
    2 exec), and only if it is inside looks up `hooks[type][addr]` (std::map<u32, cb>) with operator[] for every byte
    of the access. A missing key is INSERTED with a null callback.
  * desmume_memory_register_* puts one map key per byte (a range of 16 MB would be 16M nodes), so we register a few
    seed bytes (real callbacks) and then overwrite the island vectors in place with the big unmapped ranges.
  * Any access inside them then leaves its address in the map (null callback). Per frame we read the map size; new
    keys are logged with the frame, and get a real callback registered (then the islands are rewritten again), so
    the next access at that address reports PC/LR. Seed addresses report PC/LR immediately.
"""
import ctypes, struct, os

WRITE, READ, EXEC = 0, 1, 2
TYPES = {WRITE: 'write', READ: 'read', EXEC: 'exec'}
# unmapped for ARM9 data and code (BIOS region is FFFF0000-FFFF7FFF: size code 0x0E = 32 KB)
UNMAPPED = [(0x00000000, 0x01000000), (0x10000000, 0xFFFF0000), (0xFFFF8000, 0xFFFFFFFF)]
# EXTRA=1: protection-unit permission guesses (NitroSDK/TwlSDK crt0 style, not measured): region 2 0x027FF000 4 KB
# (old NITRO shared area: no access?), BIOS read-only, and no code fetches from I/O, cartridge, DTCM, shared areas
EXTRA_RW = [(0x027FF000, 0x02800000)]
EXTRA_W = [(0xFFFF0000, 0xFFFF8000)]
EXTRA_X = [(0x027FF000, 0x02800000), (0x02FE0000, 0x02FE4000), (0x02FFF000, 0x03000000), (0x04000000, 0x10000000)]
SEEDS = [0x00000000, 0x00000004, 0x00800000, 0x20000000, 0x40000000, 0x60000000, 0x80000000, 0xA0000000, 0xC0000000,
         0xE0000000]


class Watch:
    def __init__(self, emu, islands=None, types=(READ, WRITE, EXEC), symbolize=None, log=None):
        self.d = emu.d if hasattr(emu, 'd') else emu
        self.emu = emu
        lib = self.d.lib
        self.lib = lib
        self.hr = ctypes.addressof(ctypes.c_uint8.in_dll(lib, 'hooked_regions'))
        self.hk = ctypes.addressof(ctypes.c_uint8.in_dll(lib, 'hooks'))
        if islands is None:
            islands = {t: list(UNMAPPED) for t in (READ, WRITE, EXEC)}
            if os.environ.get('EXTRA'):
                islands[READ] += EXTRA_RW; islands[WRITE] += EXTRA_RW + EXTRA_W; islands[EXEC] += EXTRA_X
        elif isinstance(islands, list):
            islands = {t: islands for t in (READ, WRITE, EXEC)}
        self.islands = islands
        self.types = types
        self.known = {t: set() for t in (0, 1, 2)}
        self.foreign = {t: set() for t in (0, 1, 2)}
        self._live = {t: set() for t in (0, 1, 2)}
        self.armed = {t: set() for t in (0, 1, 2)}
        self.hits = []            # (frame, type, addr, size, pc, lr, cpsr, regs, who, arm7 pc)
        self.counts = {}
        self.new = []             # (frame, type, addr) seen by polling (no PC yet)
        self.sym = symbolize
        self.logf = log
        self._cbs = {}
        self.frame = 0
        for t in types:
            self._cbs[t] = ctypes.CFUNCTYPE(None, ctypes.c_uint, ctypes.c_int)(self._mk(t))
            for s in SEEDS:
                self._reg(t, s)
        self._rewrite()
        for t in types:
            self.known[t] = set(self.keys(t))

    # --------------------------------------------------------------- dylib internals
    def _reg(self, t, addr, size=1):
        f = {WRITE: self.lib.desmume_memory_register_write, READ: self.lib.desmume_memory_register_read,
             EXEC: self.lib.desmume_memory_register_exec}[t]
        f(ctypes.c_int(addr - (1 << 32) if addr >= 1 << 31 else addr), ctypes.c_int(size), self._cbs[t])
        self.armed[t].add(addr)

    def _vec(self, t, tier):
        base = self.hr + 0x48 * t + 0x18 * tier
        b, e, c = struct.unpack('<3Q', ctypes.string_at(base, 24))
        return base, b, e, c

    def islands_now(self, t):
        out = []
        for tier in range(3):
            base, b, e, c = self._vec(t, tier)
            out.append([struct.unpack('<2I', ctypes.string_at(b + 8 * i, 8)) for i in range((e - b) // 8)])
        return out

    def _rewrite(self):
        for t in self.types:
            isl = list(self.islands[t])
            runs = []
            for a in sorted(self.foreign[t]):                 # other scripts' hooks (exec traps ...) stay reachable
                if runs and runs[-1][1] == a: runs[-1][1] = a + 1
                else: runs.append([a, a + 1])
            isl += [tuple(r) for r in runs]
            self._live[t] = set(self.foreign[t])
            whole = [(min(s for s, _ in isl), max(e for _, e in isl))]
            want = [whole, whole, isl]                       # broad and mid only gate; narrow is exact
            for tier in range(3):
                base, b, e, c = self._vec(t, tier)
                isl = want[tier]
                assert (c - b) // 8 >= len(isl), f'vector capacity {(c - b) // 8} < {len(isl)} (type {t} tier {tier})'
                for i, (s, en) in enumerate(isl):
                    ctypes.memmove(b + 8 * i, struct.pack('<2I', s, en), 8)
                ctypes.memmove(base + 8, struct.pack('<Q', b + 8 * len(isl)), 8)

    def size(self, t):
        return struct.unpack('<Q', ctypes.string_at(self.hk + 0x18 * t + 0x10, 8))[0]

    def keys(self, t, with_cb=False):
        """in-order walk of hooks[t] (libc++ map: node left +0, right +8, parent +0x10, key u32 +0x20, cb +0x28)"""
        root = struct.unpack('<Q', ctypes.string_at(self.hk + 0x18 * t + 0x8, 8))[0]
        out, stack, n = [], [], root
        while stack or n:
            while n:
                stack.append(n); n = struct.unpack('<Q', ctypes.string_at(n, 8))[0]
            n = stack.pop()
            k = struct.unpack('<I', ctypes.string_at(n + 0x20, 4))[0]
            if with_cb: out.append((k, struct.unpack('<Q', ctypes.string_at(n + 0x28, 8))[0]))
            else: out.append(k)
            n = struct.unpack('<Q', ctypes.string_at(n + 8, 8))[0]
        return out

    # --------------------------------------------------------------- reporting
    def _mk(self, t):
        def cb(addr, size):
            addr &= 0xffffffff
            m = self.d.memory
            r7pc = m.register_arm7.r15 & 0xffffffff
            r = m.register_arm9
            try:
                nxt = self.lib.desmume_memory_get_next_instruction() & 0xffffffff
            except Exception:
                nxt = 0
            cpsr = r.cpsr & 0xffffffff
            thumb = bool(cpsr & 0x20)
            ins = (nxt - (2 if thumb else 4)) & 0xffffffff
            regs = [r[i] & 0xffffffff for i in range(13)] + [r.r13 & 0xffffffff, r.lr & 0xffffffff]
            who = self.classify(t, addr, size, ins, thumb, regs, r7pc)
            key = (TYPES[t], addr, who, ins if who.startswith('arm9') else r7pc)
            self.counts[key] = self.counts.get(key, 0) + 1
            if who == 'arm7': return
            h = (self.frame, TYPES[t], addr, size, ins, r.lr & 0xffffffff, cpsr, regs, who, r7pc)
            self.hits.append(h)
            if self.logf and self.counts[key] <= 3: self.logf.write(self.fmt(h) + '\n'); self.logf.flush()
        return cb

    def _u16(self, a): return self.d.memory.unsigned.read_short(a) & 0xffff
    def _u32(self, a): return self.d.memory.unsigned.read_long(a) & 0xffffffff

    def classify(self, t, addr, size, ins, thumb, regs, r7pc):
        """'arm9' when the ARM9's current instruction makes this access (decoded with its registers), 'arm7' when the
        ARM7 is in its BIOS (DeSmuME's HLE stub at 0: its IRQ vector) or executes at the address, else 'other'
        (DMA, or an ARM7 access from elsewhere)."""
        if t == EXEC:
            if ins == addr or abs(ins - addr) <= 4: return 'arm9'
            if abs(r7pc - addr) <= 8 or r7pc < 0x4000: return 'arm7'
            return 'other'
        try:
            ea = self.ea(ins, thumb, regs)
        except Exception:
            ea = None
        if ea is not None and ea != (-1, -1):
            lo, hi = ea
            if lo <= addr < hi or lo <= addr + size - 1 < hi: return 'arm9'
        if r7pc < 0x4000 and addr < 0x4000: return 'arm7'
        if ea == (-1, -1): return 'arm9?'
        return 'other'

    def ea(self, ins, thumb, R):
        """[lo, hi) of the bytes the instruction at ins touches, (-1, -1) = a memory instruction we do not decode
        exactly (SWI BIOS copies, register-shifted ARM forms); None = no memory access."""
        if thumb:
            op = self._u16(ins)
            if 0x4800 <= op < 0x5000: a = ((ins + 4) & ~3) + (op & 0xff) * 4; return a, a + 4
            if 0x5000 <= op < 0x6000:
                a = (R[(op >> 3) & 7] + R[(op >> 6) & 7]) & 0xffffffff
                n = {0: 4, 1: 2, 2: 1, 3: 1, 4: 4, 5: 2, 6: 1, 7: 2}[(op >> 9) & 7]; return a, a + n
            if 0x6000 <= op < 0x7000: a = (R[(op >> 3) & 7] + ((op >> 6) & 31) * 4) & 0xffffffff; return a, a + 4
            if 0x7000 <= op < 0x8000: a = (R[(op >> 3) & 7] + ((op >> 6) & 31)) & 0xffffffff; return a, a + 1
            if 0x8000 <= op < 0x9000: a = (R[(op >> 3) & 7] + ((op >> 6) & 31) * 2) & 0xffffffff; return a, a + 2
            if 0x9000 <= op < 0xa000: a = (R[13] + (op & 0xff) * 4) & 0xffffffff; return a, a + 4
            if (op & 0xfe00) == 0xb400:
                n = bin(op & 0x1ff).count('1'); return R[13] - 4 * n, R[13]
            if (op & 0xfe00) == 0xbc00:
                n = bin(op & 0x1ff).count('1'); return R[13], R[13] + 4 * n
            if 0xc000 <= op < 0xd000:
                n = bin(op & 0xff).count('1'); b = R[(op >> 8) & 7]; return b, b + 4 * n
            if 0xdf00 <= op < 0xe000: return -1, -1
            return None
        op = self._u32(ins)
        rn = (op >> 16) & 15
        base = (ins + 8) if rn == 15 else (R[rn] if rn < 15 else 0)
        if rn == 14: base = R[14]
        if (op & 0x0c000000) == 0x04000000:          # LDR/STR/LDRB/STRB
            n = 1 if op & (1 << 22) else 4
            if op & (1 << 25):
                if op & 0x10: return -1, -1
                rm = R[op & 15] if (op & 15) < 15 else ins + 8
                sh, typ = (op >> 7) & 31, (op >> 5) & 3
                if typ == 0: off = (rm << sh) & 0xffffffff
                elif typ == 1: off = (rm >> sh) if sh else 0
                elif typ == 2: off = ((rm - (1 << 32) if rm >> 31 else rm) >> (sh or 32)) & 0xffffffff
                else: off = ((rm >> sh) | (rm << (32 - sh))) & 0xffffffff if sh else rm
            else:
                off = op & 0xfff
            a = base if not (op & (1 << 24)) else (base + off if op & (1 << 23) else base - off)
            a &= 0xffffffff; return a, a + n
        if (op & 0x0e000090) == 0x00000090 and (op & 0x60):   # halfword / signed / LDRD/STRD
            off = (((op >> 4) & 0xf0) | (op & 0xf)) if op & (1 << 22) else R[op & 15]
            a = base if not (op & (1 << 24)) else (base + off if op & (1 << 23) else base - off)
            a &= 0xffffffff; return a, a + 8
        if (op & 0x0e000000) == 0x08000000:          # LDM/STM
            n = bin(op & 0xffff).count('1')
            if op & (1 << 23): return (base, base + 4 * n + 4)
            return (base - 4 * n - 4) & 0xffffffff, base + 4
        if (op & 0x0f000000) == 0x0f000000: return -1, -1
        if (op & 0x0fb00ff0) == 0x01000090: return base, base + 4    # SWP
        return None

    def fmt(self, h):
        f, t, a, s, pc, lr, cpsr, regs, who, r7 = h
        nm = (lambda x: self.sym(x) if self.sym else hex(x))
        return (f'HIT f{f} {who} {t} addr {a:#010x} size {s} pc {pc:#010x} {nm(pc)} lr {lr:#010x} {nm(lr)} '
                f'{"T" if cpsr & 0x20 else "A"} mode {cpsr & 0x1f:#x} arm7pc {r7:#x} regs ' + ' '.join(f'{x:#x}' for x in regs))

    def poll(self, frame=None):
        """call once per frame: new addresses get a real callback (PC/LR on the next access)"""
        if frame is not None: self.frame = frame
        fresh = []
        for t in self.types:
            if self.size(t) == len(self.known[t]): continue
            kc = dict(self.keys(t, True))
            ks = set(kc)
            for a in sorted(ks - self.known[t]):
                if kc[a] and a not in self.armed[t]:      # another hook of the script (its own callback): keep it live
                    self.foreign[t].add(a); continue
                fresh.append((self.frame, TYPES[t], a))
            self.known[t] = ks
            if self.foreign[t] - self._live[t]: self._rewrite()
        if fresh:
            self.new.extend(fresh)
            for f, tn, a in fresh:
                if self.logf: self.logf.write(f'NEW f{f} {tn} addr {a:#010x}\n')
                t = {v: k for k, v in TYPES.items()}[tn]
                if a not in self.armed[t]: self._reg(t, a)
            self._rewrite()
            for t in self.types: self.known[t] = set(self.keys(t))
            if self.logf: self.logf.flush()
        return fresh

    def summary(self):
        by = {}
        for (t, a, who, pc), n in self.counts.items(): by[who] = by.get(who, 0) + n
        return f'{len(self.new)} new bad addresses, hits by source {by}'

    def report(self):
        out = []
        for (t, a, who, pc), n in sorted(self.counts.items(), key=lambda kv: (kv[0][2], kv[0][1])):
            out.append(f'{who:6s} {t:5s} {a:#010x} x{n:<6d} at {pc:#010x} {self.sym(pc) if self.sym else ""}')
        return out
