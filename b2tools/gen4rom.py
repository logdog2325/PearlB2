"""Read-only access to a DS ROM's file system (NitroFS) and NARC archives, for the Pearl dump.

    python3 gen4rom.py ROM ls [PREFIX]        list files (path, size)
    python3 gen4rom.py ROM narc PATH          count a NARC's members and their sizes

No third-party modules. Nothing is written to the ROM.
"""
import struct, sys


class Rom:
    def __init__(self, path):
        self.data = open(path, 'rb').read()
        d = self.data
        self.title = d[0:12].rstrip(b'\0').decode('ascii')
        self.code = d[12:16].decode('ascii')
        self.revision = d[0x1e]
        fnt_off, fnt_len, fat_off, fat_len = struct.unpack_from('<4I', d, 0x40)
        self.fat = [struct.unpack_from('<2I', d, fat_off + 8 * i) for i in range(fat_len // 8)]
        self.files = {}  # path -> file id
        self._walk(fnt_off, 0xf000, '')

    def _walk(self, fnt, dir_id, prefix):
        sub_off, first_id, _ = struct.unpack_from('<IHH', self.data, fnt + 8 * (dir_id & 0xfff))
        p, fid = fnt + sub_off, first_id
        while True:
            n = self.data[p]; p += 1
            if n == 0:
                break
            name = self.data[p:p + (n & 0x7f)].decode('ascii'); p += n & 0x7f
            if n & 0x80:
                sub, = struct.unpack_from('<H', self.data, p); p += 2
                self._walk(fnt, sub, prefix + name + '/')
            else:
                self.files[prefix + name] = fid; fid += 1

    def read(self, path_or_id):
        fid = self.files[path_or_id] if isinstance(path_or_id, str) else path_or_id
        start, end = self.fat[fid]
        return self.data[start:end]


def narc_members(data):
    """List of member byte strings of a NARC (BTAF/BTNF/GMIF)."""
    assert data[:4] == b'NARC', 'not a NARC'
    p = struct.unpack_from('<H', data, 0xc)[0]
    assert data[p:p + 4] == b'BTAF'
    btaf_len, count = struct.unpack_from('<IH', data, p + 4)
    offs = [struct.unpack_from('<2I', data, p + 12 + 8 * i) for i in range(count)]
    p += btaf_len
    assert data[p:p + 4] == b'BTNF'
    p += struct.unpack_from('<I', data, p + 4)[0]
    assert data[p:p + 4] == b'GMIF'
    base = p + 8
    return [data[base + s:base + e] for s, e in offs]


if __name__ == '__main__':
    rom = Rom(sys.argv[1])
    cmd = sys.argv[2] if len(sys.argv) > 2 else 'ls'
    if cmd == 'ls':
        prefix = sys.argv[3] if len(sys.argv) > 3 else ''
        for path in sorted(rom.files):
            if path.startswith(prefix):
                s, e = rom.fat[rom.files[path]]
                print(f'{e - s:10d}  {path}')
    elif cmd == 'narc':
        members = narc_members(rom.read(sys.argv[3]))
        sizes = [len(m) for m in members]
        print(f'{len(members)} members, total {sum(sizes)} B, largest {max(sizes) if sizes else 0} B')
