# (from HoennB2 work/agents/music_check/scripts/soundheap.py)
"""Black 2's sound heap in RAM: GFL_SndInit (arm9 0x02005b80) makes it with NNS_FrmHeapCreate(0x0209e278, 0x9D000)
(643,072 B, inside arm9's .bss). An NNS frame heap starts with NNSiFndHeapHead (u32 signature 'FRMH', link 8 B, child
list 12 B, heapStart, heapEnd, attribute) and then NNSiFndFrmHeapHead (headAllocator, tailAllocator, state): what is
free is tailAllocator - headAllocator."""
import struct

BASE = 0x0209E278
SIZE = 0x9D000


def frame_heap(e):
    m = e.d.memory.unsigned
    raw = bytes(m[BASE:BASE + 0x40])
    for off in range(0, 0x20, 4):
        if raw[off:off + 4] in (b'HMRF', b'FRMH'):
            start, end, attr, head, tail = struct.unpack_from('<IIIII', raw, off + 24)
            return dict(header=BASE + off, start=start, end=end, head=head, tail=tail, used=head - start,
                        free=tail - head, size=end - start)
    return None
