#!/usr/bin/env python3
# Copyright 2026 Akop Karapetyan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Expand King's Valley II pyramid maps from ROM and render PNG sheets.

HOW A PYRAMID IS STORED

  unpack_map (0x43C2) reads map_ptr[level-1] into 0xE900: each source byte is
  (tile<<6)|count until 0. Four 2-bit cells pack into one dest byte; 0xC0 bytes
  = one 32×24 screen. stamp_map_at paints: 0 skip (background shows through),
  1 ladder (tiles 3/4), 2 → tile 5, 3 → tile 0x5E.

  load_obj (obj_ptr) ORs overlay runs onto the same grid (always cell 1).
  0xFF advances one screen.

  Composites (gfx/pyramid_NN.png) follow load_stage then the playfield
  stamps: stamp_wpat (HMMM, opaque 8×4 grid), then tile_pset LMMM TIMP
  (colour 0 shows wallpaper) for glyphs, map, exit, E600 actors, gems,
  and map tools. Vic is the unarmed SAT CC pair at B844. Stream sheets are
  unpack_map + overlay only (no wallpaper / sprites).

  load_screens unpacks ab5a_flags (8 bytes, MSB first) into E788 as 8×8 slots,
  screen ids 1..n. That bit grid is the editor / pause-map geography.

  World dest tiles come from blit_list dest_common + dest_wN (same atlas as
  gfxdump dest sheets). Palette is world_play_pal (even pyramid + HUD).

Output:
  gfx/metatiles/map_streams_wN.png  one pyramid per row, screens as columns
  gfx/pyramid_NN.png                screens placed on the ab5a_flags grid

Usage:
  tools/pyramid.py [--rom KingsValley2.rom] [--out-dir gfx]
                   [--pyramid N | --all] [--scale 2]
"""
import argparse, importlib.util, os, sys

_TOOLS = os.path.dirname(os.path.abspath(__file__))
_WB = os.path.join(_TOOLS, "workbench")
sys.path.insert(0, os.path.join(_WB, "msx"))
sys.path.insert(0, _TOOLS)
import pngwrite

ROOT = os.path.dirname(_TOOLS)
ROM_PATH = os.path.join(ROOT, "KingsValley2.rom")
GFX = os.path.join(ROOT, "gfx")

N_PYRAMIDS = 60
SCREEN_W, SCREEN_H = 32, 24
SCREEN_BYTES = 0xC0
GRID_W, GRID_H = 8, 8
WIN_ABC = (10, 11, 12)
WIN_123 = (1, 2, 3)
MAP_PTR = 0x6000
OBJ_PTR = 0x6078
FLAGS_CPU = 0xAB5A
WPAT_PTR = 0x8000          # glyph_ptr[world-1]; stamp_wpat via tbl_word 0x7FFE
LEVEL_PTR = 0x806A         # tbl_word, A = 1-based level
GLYPH_PTR = 0x800C         # tbl_word, A = (world-1)*8 + (B&7)
ACTOR_PTR = 0xAAE0         # tbl_word, A = 1-based level
GEM_PTR = 0xA75D           # tbl_word, A = 1-based level
TOOL_PTR = 0xAFB1          # tbl_word, A = level-1
VIC_SPAWN = 0xB844         # + level*3: Y, X, screen
EXIT_DOOR = 0xB8F8         # + level*3: Y, X, (screen<<5)|shape
EXIT_PAT = 0x9340          # 4×4 dest tiles (E2F6 = 0 at load)
GEM_PAT = 0x9324
TOOL_PAT = 0x9328          # 6 × 2×2 (knife..drill)
STONE_PAT = 0x9370
COFFIN_PAT = 0x9374
PYONCY_L = (0x937C, 0x9384, 0x938C)
PYONCY_R = (0x9394, 0x939C, 0x93A4)
TRAP_TILE = 0xAD           # MSX2 draw_trap (F0F4)
ROCK_TILE = 5
VIC_RLE = (14, 0x86D4)     # first unarmed walk pose, 3 × CC pair
VIC_SAT_DY = 9             # SAT Y = E282 − 9
WPAT_W, WPAT_H = 8, 4
WPAT_BYTES = WPAT_W * WPAT_H
GAP = 4
SHEET_BG = (0x20, 0x28, 0x30)
LABEL_RGB = (200, 200, 205)
BLACK = (0, 0, 0)
MISSING = (255, 0, 255)


def _load_gfxdump():
    path = os.path.join(_TOOLS, "gfxdump.py")
    spec = importlib.util.spec_from_file_location("kv2_gfxdump", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


G = _load_gfxdump()


def cpu_in_abc(cpu):
    return G.cpu_file_win(cpu, WIN_ABC)


def word_abc(rom, cpu):
    fo = cpu_in_abc(cpu)
    return G.word_le(rom, fo)


def unpack_map(rom, ptr):
    """map_ptr stream → packed E900 bytes (4 cells/byte, first cell in bits 7-6)."""
    fo = cpu_in_abc(ptr)
    out = bytearray()
    cur = 0
    n = 0
    i = 0
    while True:
        b = rom[fo + i]
        i += 1
        if b == 0:
            break
        count = b & 0x3F
        tile = (b >> 6) & 3
        for _ in range(count):
            cur = ((cur << 2) | tile) & 0xFF
            n += 1
            if n == 4:
                out.append(cur)
                cur = 0
                n = 0
    if n:
        raise ValueError("unpack_map %04X: trailing %d cells" % (ptr, n))
    if len(out) % SCREEN_BYTES:
        raise ValueError("unpack_map %04X: %d bytes not a multiple of 0xC0"
                         % (ptr, len(out)))
    return out


def overlay_bits(mem, hl, e):
    """Write 2-bit value 1 into packed cell E of byte HL (Z80 overlay_bits)."""
    if not (0 <= hl < len(mem)):
        return
    a = 0x40
    e &= 0xFF
    if e:
        a >>= (2 * e)
        a &= 0xFF
    mask = ((a << 1) | (a >> 7)) & 0xFF
    mem[hl] = (mem[hl] & (mask ^ 0xFF)) | a


def apply_overlay(mem, rom, ptr):
    """load_obj: 2-byte records, 0 end, 0xFF next screen."""
    fo = cpu_in_abc(ptr)
    base = 0
    i = 0
    while True:
        e = rom[fo + i]
        i += 1
        if e == 0:
            return
        if e == 0xFF:
            base += SCREEN_BYTES
            continue
        d = rom[fo + i]
        i += 1
        rec = e | (d << 8)
        hl = base + (rec >> 7)
        run = e & 0x1F or 256
        e_nib = (e >> 5) & 3
        for _ in range(run):
            overlay_bits(mem, hl, e_nib)
            e_nib = (e_nib + 1) & 3
            if e_nib == 0:
                hl += 1
            overlay_bits(mem, hl, e_nib)
            if e_nib == 0:
                hl += 7
                e_nib = 0xFF
            else:
                hl += 8
                e_nib = (e_nib - 1) & 0xFF


def cells_of_screen(packed, screen):
    """32×24 list of 2-bit cells for 1-based screen."""
    off = (screen - 1) * SCREEN_BYTES
    chunk = packed[off:off + SCREEN_BYTES]
    rows = []
    i = 0
    for _y in range(SCREEN_H):
        row = []
        for _x in range(0, SCREEN_W, 4):
            b = chunk[i]
            i += 1
            for s in (6, 4, 2, 0):
                row.append((b >> s) & 3)
        rows.append(row)
    return rows


def stamp_tile_ids(cells):
    """stamp_map_at tile ids; None = skip (empty, background shows through)."""
    efc0 = 0
    out = []
    for row in cells:
        orow = []
        for cell in row:
            if cell == 0:
                orow.append(None)
            elif cell == 1:
                tid = 4 if efc0 == 3 else 3
                efc0 = tid
                orow.append(tid)
            elif cell == 2:
                efc0 = 5
                orow.append(5)
            else:
                efc0 = 0x5E
                orow.append(0x5E)
        out.append(orow)
    return out


def word_ef(rom, cpu):
    return G.word_le(rom, G.cpu_file_win(cpu, G.WIN_EF))


def bytes_ef(rom, cpu, n):
    fo = G.cpu_file_win(cpu, G.WIN_EF)
    return rom[fo:fo + n]


def wpat_grid(rom, world, pyramid):
    """stamp_wpat: 8×4 dest-tile ids, tiled across the 32×24 screen."""
    cpu = word_ef(rom, WPAT_PTR + (world - 1) * 2)
    if pyramid & 1:
        cpu += 0x20
    pat = bytes_ef(rom, cpu, WPAT_BYTES)
    rows = []
    for ty in range(SCREEN_H):
        src = (ty % WPAT_H) * WPAT_W
        prow = pat[src:src + WPAT_W]
        rows.append([prow[tx % WPAT_W] for tx in range(SCREEN_W)])
    return rows


def put_tile(grid, tx, ty, tid):
    if 0 <= tx < SCREEN_W and 0 <= ty < SCREEN_H:
        grid[ty][tx] = tid


def stamp_glyph(grid, rom, world, b, c, dx, dy):
    """stamp_glyph (0x4638): world×8 + (B&7) tile-id list at DE."""
    slot = b & 7
    cpu = word_ef(rom, GLYPH_PTR + 2 * ((world - 1) * 8 + slot))
    tx, ty = dx >> 3, dy >> 3
    kind = slot >> 1
    if kind == 3:
        tiles = bytes_ef(rom, cpu, 6)
        for row in range(c):
            if row == 0:
                pair = tiles[0], tiles[1]
            elif row == c - 1:
                pair = tiles[4], tiles[5]
            else:
                pair = tiles[2], tiles[3]
            put_tile(grid, tx, ty + row, pair[0])
            put_tile(grid, tx + 1, ty + row, pair[1])
        return
    if kind == 0:
        tw, th = 4, 4
    elif kind == 1:
        tw, th = 2, 4
    else:
        tw, th = 4, 2
    tiles = bytes_ef(rom, cpu, tw * th)
    i = 0
    for row in range(th):
        for col in range(tw):
            put_tile(grid, tx + col, ty + row, tiles[i])
            i += 1


def apply_glyphs(grid, rom, world, pyramid, screen):
    """stamp_level (0x4606): 3-byte records for this screen (E243-1)."""
    cpu = word_ef(rom, LEVEL_PTR + pyramid * 2)
    fo = G.cpu_file_win(cpu, G.WIN_EF)
    i = 0
    while rom[fo + i] != 0xFF:
        b0, b1, b2 = rom[fo + i], rom[fo + i + 1], rom[fo + i + 2]
        i += 3
        if (b1 & 7) != (screen - 1):
            continue
        stamp_glyph(grid, rom, world, b0, b2, b1 & 0xF8, b0 & 0xF8)


def bytes_123(rom, cpu, n):
    fo = G.cpu_file_win(cpu, WIN_123)
    return rom[fo:fo + n]


def bytes_d(rom, cpu, n):
    fo = G.cpu_file(13, cpu)
    return rom[fo:fo + n]


def word_d(rom, cpu):
    return G.word_le(rom, G.cpu_file(13, cpu))


def fill_wpat_rect(ids, wpat, px, py, tw, th):
    """stamp_wtiles: restore the repeating wallpaper in a tile rect."""
    tx, ty = px >> 3, py >> 3
    for row in range(th):
        for col in range(tw):
            gx, gy = tx + col, ty + row
            if 0 <= gx < SCREEN_W and 0 <= gy < SCREEN_H:
                ids[gy][gx] = wpat[gy][gx]


def stamp_pat(ids, tiles, px, py, tw, th, skip0=False):
    tx, ty = px >> 3, py >> 3
    i = 0
    for row in range(th):
        for col in range(tw):
            tid = tiles[i]
            i += 1
            if skip0 and tid == 0:
                continue
            put_tile(ids, tx + col, ty + row, tid)


def stamp_actor_rows(ids, rom, row_cpus, frame, px, py, hgt, skip0=False):
    """coffin_stamp / actor_row: first, (hgt-2)× mid, last; 2 tiles wide."""
    srcs = [row_cpus[0]]
    if hgt >= 3:
        srcs.extend([row_cpus[1]] * (hgt - 2))
    srcs.append(row_cpus[2])
    off = frame * 2
    tx, ty = px >> 3, py >> 3
    for i, cpu in enumerate(srcs):
        pair = bytes_123(rom, cpu + off, 2)
        for col, tid in enumerate(pair):
            if skip0 and tid == 0:
                continue
            put_tile(ids, tx + col, ty + i, tid)


def apply_exit(ids, rom, pyramid, screen):
    """draw_exit: 4×4 exit_pat at load (E2F6 = 0)."""
    y, x, packed = bytes_d(rom, EXIT_DOOR + pyramid * 3, 3)
    if (packed >> 5) != screen:
        return
    stamp_pat(ids, bytes_123(rom, EXIT_PAT, 16), x, y, 4, 4)


def apply_actors(ids, wpat, rom, pyramid, screen):
    """E600 dest stamps (actor_draw / draw_stones). Type 3 is idle-undrawn."""
    cpu = word_d(rom, ACTOR_PTR + pyramid * 2)
    fo = G.cpu_file(13, cpu)
    i = 0
    while rom[fo + i]:
        b0, y, x, b3 = rom[fo + i:fo + i + 4]
        i += 4
        typ, scr = b0 >> 4, b0 & 0xF
        if scr != screen:
            continue
        hgt = b3 >> 3
        face = (b3 & 7) != 0
        if typ == 1:
            fill_wpat_rect(ids, wpat, x, y, 2, hgt)
            stamp_actor_rows(ids, rom, (COFFIN_PAT,) * 3, (b3 & 7) * 3,
                             x, y, hgt)
        elif typ == 2:
            fill_wpat_rect(ids, wpat, x, y, 2, hgt)
            rows = PYONCY_R if face else PYONCY_L
            stamp_actor_rows(ids, rom, rows, 0, x, y, hgt, skip0=True)
        elif typ == 3:
            tx, ty = x >> 3, y >> 3
            for row in range(hgt):
                put_tile(ids, tx, ty + row, ROCK_TILE)
        elif typ == 4:
            tx, ty = x >> 3, y >> 3
            for col in range(4):
                put_tile(ids, tx + col, ty, TRAP_TILE)
        elif typ == 5:
            stamp_pat(ids, bytes_123(rom, STONE_PAT, 4), x, y, 2, 2)


def apply_gems(ids, rom, pyramid, screen):
    """draw_gems: 2×2 gem_pat. Record is type/screen, Y, X."""
    cpu = word_d(rom, GEM_PTR + pyramid * 2)
    fo = G.cpu_file(13, cpu)
    i = 0
    pat = bytes_123(rom, GEM_PAT, 4)
    while rom[fo + i]:
        b0, y, x = rom[fo + i:fo + i + 3]
        i += 3
        if (b0 & 0xF) != screen:
            continue
        stamp_pat(ids, pat, x, y, 2, 2, skip0=True)


def apply_tools(ids, rom, pyramid, screen):
    """draw_maptools: 2×2 tool_stamp_pat. Record is (screen<<4)|type, Y, X."""
    cpu = word_d(rom, TOOL_PTR + (pyramid - 1) * 2)
    fo = G.cpu_file(13, cpu)
    i = 0
    while rom[fo + i] != 0xFF:
        packed, y, x = rom[fo + i:fo + i + 3]
        i += 3
        if (packed >> 4) != screen:
            continue
        typ = packed & 0xF
        if not (1 <= typ <= 6):
            continue
        pat = bytes_123(rom, TOOL_PAT + (typ - 1) * 4, 4)
        stamp_pat(ids, pat, x, y, 2, 2, skip0=True)


def screen_tile_ids(rom, world, pyramid, packed, screen, decorate):
    """Terrain; composites also get wpat / glyphs / exit / actors."""
    terrain = stamp_tile_ids(cells_of_screen(packed, screen))
    if not decorate:
        return terrain
    wpat = wpat_grid(rom, world, pyramid)
    ids = [row[:] for row in wpat]
    apply_glyphs(ids, rom, world, pyramid, screen)
    for ty, row in enumerate(terrain):
        for tx, tid in enumerate(row):
            if tid is not None:
                ids[ty][tx] = tid
    apply_exit(ids, rom, pyramid, screen)
    apply_actors(ids, wpat, rom, pyramid, screen)
    apply_gems(ids, rom, pyramid, screen)
    apply_tools(ids, rom, pyramid, screen)
    return ids


def blit_sat(buf, W, H, x0, y0, planes, pal, scale):
    """OR a CC pair onto RGB; index 0 is transparent."""
    for plane in planes:
        for py, row in enumerate(plane):
            for px, idx in enumerate(row):
                if not idx:
                    continue
                rgb = pal[idx & 15]
                for yy in range(scale):
                    qy = (y0 + py) * scale + yy
                    if not (0 <= qy < H):
                        continue
                    for xx in range(scale):
                        qx = (x0 + px) * scale + xx
                        if 0 <= qx < W:
                            o = (qy * W + qx) * 3
                            buf[o:o + 3] = bytes(rgb)


def overlay_vic(img, rom, planes, pal, pyramid, screen, scale):
    """Unarmed walk pose: SAT CC pair at (E284, E282−9)."""
    y, x, scr = bytes_d(rom, VIC_SPAWN + pyramid * 3, 3)
    if scr != screen:
        return img
    w, h, data = img
    buf = bytearray(data)
    blit_sat(buf, w, h, x, y - VIC_SAT_DY, planes, pal, scale)
    return w, h, bytes(buf)


def paint_rgb(ids, atlas, pal, scale, buf=None, skip0=False):
    """Draw dest tiles. skip0 = LMMM TIMP (tile_pset): colour 0 leaves dest."""
    tw = 8 * scale
    w, h = SCREEN_W * tw, SCREEN_H * tw
    if buf is None:
        buf = bytearray(bytes(BLACK) * (w * h))
    else:
        buf = bytearray(buf)
    for ty, row in enumerate(ids):
        for tx, tid in enumerate(row):
            if tid is None:
                continue
            grid = atlas.get(tid)
            if grid is None:
                if skip0:
                    continue
                col = MISSING
                for y in range(tw):
                    for x in range(tw):
                        o = ((ty * tw + y) * w + tx * tw + x) * 3
                        buf[o:o + 3] = bytes(col)
                continue
            for y in range(8):
                for x in range(8):
                    pix = grid[y][x]
                    if isinstance(pix, tuple):
                        rgb = pix
                        if skip0 and rgb == (0, 0, 0):
                            continue
                    else:
                        idx = pix & 15
                        if skip0 and idx == 0:
                            continue
                        rgb = pal[idx]
                    for yy in range(scale):
                        for xx in range(scale):
                            o = ((ty * tw + y * scale + yy) * w
                                 + tx * tw + x * scale + xx) * 3
                            buf[o:o + 3] = bytes(rgb)
    return w, h, bytes(buf)


def flags_grid(rom, pyramid):
    """ab5a_flags → {screen_id: (col, row)} 1-based screen ids."""
    fo = G.cpu_file(13, FLAGS_CPU) + (pyramid - 1) * 8
    pos = {}
    sid = 1
    for row in range(GRID_H):
        b = rom[fo + row]
        for col in range(GRID_W):
            if b & (0x80 >> col):
                pos[sid] = (col, row)
                sid += 1
    return pos


def crop_pos(pos):
    xs = [p[0] for p in pos.values()]
    ys = [p[1] for p in pos.values()]
    minx, miny = min(xs), min(ys)
    pos = {s: (x - minx, y - miny) for s, (x, y) in pos.items()}
    gw = max(x for x, _ in pos.values()) + 1
    gh = max(y for _, y in pos.values()) + 1
    return pos, gw, gh


def draw_text(buf, W, x, y, text, scale, color):
    for chr_ in text:
        glyph = G.FONT3x5.get(chr_)
        if glyph:
            for gy, row in enumerate(glyph):
                for gx, bit in enumerate(row):
                    if bit != "1":
                        continue
                    for yy in range(scale):
                        base = ((y + gy * scale + yy) * W + x + gx * scale) * 3
                        for xx in range(scale):
                            buf[base + xx * 3:base + (xx + 1) * 3] = bytes(color)
        x += 4 * scale


def contact_sheet(images, pos, gw, gh, gap, labels, lab_scale=2):
    cw = max(w for w, h, _ in images)
    ch = max(h for w, h, _ in images)
    lab_h = 5 * lab_scale + 4
    cell_h = lab_h + ch
    W = gw * cw + (gw + 1) * gap
    H = gh * cell_h + (gh + 1) * gap
    buf = bytearray(bytes(SHEET_BG) * (W * H))
    for i, (w, h, data) in enumerate(images):
        if i not in pos:
            continue
        gx, gy = pos[i]
        x0 = gap + gx * (cw + gap)
        y0 = gap + gy * (cell_h + gap)
        lab = labels[i] if i < len(labels) else None
        if lab:
            draw_text(buf, W, x0 + 2, y0 + 2, lab, lab_scale, LABEL_RGB)
        iy = y0 + lab_h
        for y in range(h):
            src = y * w * 3
            dst = ((iy + y) * W + x0) * 3
            buf[dst:dst + w * 3] = data[src:src + w * 3]
    return W, H, bytes(buf)


def world_of(pyramid):
    return (pyramid - 1) // 10 + 1


class Atlases:
    def __init__(self, rom):
        self.rom = rom
        play = G.apply_pal(rom, G.default_pal(), 15, 0xA7CE)
        self.play = play
        common = G.blit_atlas(rom, 0x602A, 0x6000, G.WIN_789)
        blit_ptr = G.cpu_file(7, 0x6177)
        tbl_ptr = G.cpu_file(7, 0x6065)
        self.by_world = {}
        self.pal = {}
        for w in range(1, 7):
            lst = G.word_le(rom, blit_ptr + w * 2)
            tbl = G.word_le(rom, tbl_ptr + w * 2)
            atlas = dict(common)
            atlas.update(G.blit_atlas(rom, lst, tbl, G.WIN_789))
            self.by_world[w] = atlas
            self.pal[w] = G.world_play_pal(rom, play, w)
        blob, _, _ = G.decompress(rom, G.cpu_file(*VIC_RLE), 0)
        # One walk pose = CC pair (16×16). vic_sat_put also writes a 2×2 SAT
        # (patterns 8/12 at Y+16) from the *same* generator after vic_hmm;
        # the unarmed RLE packs 3 poses × 2 planes, so stacking 8/12 here
        # would paste the next walk frame as a second torso.
        self.vic = [
            G.sprite_16(blob[i * 32:(i + 1) * 32], G.SAT_CC[i % 2])
            for i in range(2)
        ]


def load_pyramid(rom, pyramid):
    map_cpu = word_abc(rom, MAP_PTR + (pyramid - 1) * 2)
    obj_cpu = word_abc(rom, OBJ_PTR + (pyramid - 1) * 2)
    packed = unpack_map(rom, map_cpu)
    apply_overlay(packed, rom, obj_cpu)
    nscreens = len(packed) // SCREEN_BYTES
    pos = flags_grid(rom, pyramid)
    if len(pos) != nscreens:
        raise ValueError("pyramid %d: %d screens in stream, %d bits in flags"
                         % (pyramid, nscreens, len(pos)))
    return map_cpu, packed, nscreens, pos


def render_screens(rom, atlases, pyramid, packed, nscreens, scale,
                   decorate=False):
    world = world_of(pyramid)
    atlas, pal = atlases.by_world[world], atlases.pal[world]
    images = []
    for scr in range(1, nscreens + 1):
        ids = screen_tile_ids(rom, world, pyramid, packed, scr, decorate)
        if decorate:
            wpat = wpat_grid(rom, world, pyramid)
            img = paint_rgb(wpat, atlas, pal, scale)
            img = paint_rgb(ids, atlas, pal, scale, buf=img[2], skip0=True)
            img = overlay_vic(img, rom, atlases.vic, pal, pyramid, scr, scale)
        else:
            img = paint_rgb(ids, atlas, pal, scale)
        images.append(img)
    return images


def write_pyramid(rom, atlases, pyramid, out_dir, scale):
    map_cpu, packed, nscreens, pos = load_pyramid(rom, pyramid)
    images = render_screens(rom, atlases, pyramid, packed, nscreens, scale,
                            decorate=True)
    pos, gw, gh = crop_pos(pos)
    # contact_sheet is 0-based image index; flags_grid is 1-based screen id.
    pos0 = {s - 1: xy for s, xy in pos.items()}
    labels = ["%d" % (s + 1) for s in range(nscreens)]
    W, H, data = contact_sheet(images, pos0, gw, gh, GAP, labels)
    path = os.path.join(out_dir, "pyramid_%02d.png" % pyramid)
    pngwrite.write_rgb(path, W, H, data)
    print("wrote %s  %d screens  map %04X" % (
        os.path.relpath(path, ROOT), nscreens, map_cpu))
    return map_cpu, nscreens, images


def write_streams(rom, atlases, out_dir, scale):
    mdir = os.path.join(out_dir, "metatiles")
    os.makedirs(mdir, exist_ok=True)
    for world in range(1, 7):
        lo, hi = (world - 1) * 10 + 1, world * 10
        rows = []
        max_s = 1
        cpus = []
        for pyr in range(lo, hi + 1):
            map_cpu, packed, nscreens, _pos = load_pyramid(rom, pyr)
            images = render_screens(rom, atlases, pyr, packed, nscreens, scale)
            rows.append(images)
            cpus.append(map_cpu)
            if nscreens > max_s:
                max_s = nscreens
        images = []
        pos = {}
        labels = []
        idx = 0
        for r, row in enumerate(rows):
            for c, img in enumerate(row):
                pos[idx] = (c, r)
                images.append(img)
                # Unique 4-hex: map stream CPU for screen 1, else pyramid||screen.
                if c == 0:
                    labels.append("%04X" % cpus[r])
                else:
                    labels.append("%02X%02X" % (lo + r, c + 1))
                idx += 1
            for c in range(len(row), max_s):
                pos[idx] = (c, r)
                images.append((row[0][0], row[0][1], bytes(SHEET_BG) * (
                    row[0][0] * row[0][1])))
                labels.append(None)
                idx += 1
        W, H, data = contact_sheet(images, pos, max_s, 10, GAP, labels)
        path = os.path.join(mdir, "map_streams_w%d.png" % world)
        pngwrite.write_rgb(path, W, H, data)
        print("wrote %s" % os.path.relpath(path, ROOT))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--rom", default=ROM_PATH)
    ap.add_argument("--out-dir", default=GFX)
    ap.add_argument("--pyramid", type=int)
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--scale", type=int, default=2,
                    help="pixels per source pixel (composites; streams use 1)")
    ap.add_argument("--no-streams", action="store_true")
    args = ap.parse_args()
    if not os.path.isfile(args.rom):
        sys.exit("missing %s — run make first" % args.rom)
    rom = open(args.rom, "rb").read()
    atlases = Atlases(rom)
    os.makedirs(args.out_dir, exist_ok=True)
    if args.pyramid:
        pyramids = [args.pyramid]
    else:
        pyramids = list(range(1, N_PYRAMIDS + 1))
    for p in pyramids:
        write_pyramid(rom, atlases, p, args.out_dir, args.scale)
    if not args.no_streams and (args.all or args.pyramid is None):
        write_streams(rom, atlases, args.out_dir, 1)


if __name__ == "__main__":
    main()
