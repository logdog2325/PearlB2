"""Event flags/works (read; write only for the crash tour's save setup)."""
def ew(g):
    return g.u32(g.gdata() + 0x1ac)
def flag(g, n):
    if n >= 0x4000: return None
    return (g.u8(ew(g) + 0x35e + (n >> 3)) >> (n & 7)) & 1
def work(g, n):
    return g.u16(ew(g) + 2 * (n - 0x4000))
def set_flag(g, n, v=1):
    a = ew(g) + 0x35e + (n >> 3); b = g.u8(a)
    b = (b | (1 << (n & 7))) if v else (b & ~(1 << (n & 7)))
    g.e.d.memory.write_byte(a, b)
def set_work(g, n, v):
    a = ew(g) + 2 * (n - 0x4000)
    g.e.d.memory.write_short(a, v)
