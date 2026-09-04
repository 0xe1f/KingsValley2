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

"""Build PNG graphics sheets in gfx/ from identified ROM tables.

  gfx/palettes/<stem>.png   palette_list streams (8x8 swatches)
  gfx/tilesets/<stem>.png   dest-plane 8x8, copy_tiles 1bpp, SCREEN 5 stamps
  gfx/sprites/<stem>.png    16×16 1bpp planes (Vic / hallway Vic-back / tools)
  gfx/fonts/<stem>.png      HUD glyphs / world-map font (copy_tiles)
  gfx/metatiles/<stem>.png  glyph_ptr tile-id stamps; map_streams_wN via pyramid.py
  gfx/<stem>.png            draw_cols / STAMP / draw_tilemap / pyramid_NN composites

Cell header is 4 uppercase hex digits (CPU of that atom), except palette
swatches which use the 2-digit index. In-game MSX2 palette. No PIL.

Usage:  tools/gfxdump.py            (run from the repo root)
"""
import os, sys

_TOOLS = os.path.dirname(os.path.abspath(__file__))
_WB = os.path.join(_TOOLS, "workbench")
sys.path.insert(0, os.path.join(_WB, "msx"))
sys.path.insert(0, os.path.join(_WB, "konami"))
import pngwrite
from rledec import decompress

ROOT = os.path.dirname(_TOOLS)
ROM_PATH = os.path.join(ROOT, "KingsValley2.rom")
GFX = os.path.join(ROOT, "gfx")
PALETTE_DIR = os.path.join(GFX, "palettes")
TILESET_DIR = os.path.join(GFX, "tilesets")
SPRITE_DIR = os.path.join(GFX, "sprites")
FONT_DIR = os.path.join(GFX, "fonts")
METATILE_DIR = os.path.join(GFX, "metatiles")

SCALE = 6
GAP = 2
BG = (0x20, 0x28, 0x30)
OFF = (0x30, 0x3A, 0x44)
LABEL_RGB = (200, 200, 205)

WIN_789 = (7, 8, 9)
WIN_EF = (13, 14, 15)

# 3x5, same as Vampire Killer roomperm FONT3x5 (hex ids only).
FONT3x5 = {
    "0": ("111", "101", "101", "101", "111"),
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "010", "100", "100"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
    "A": ("010", "101", "111", "101", "101"),
    "B": ("110", "101", "110", "101", "110"),
    "C": ("011", "100", "100", "100", "011"),
    "D": ("110", "101", "101", "101", "110"),
    "E": ("111", "100", "110", "100", "111"),
    "F": ("111", "100", "110", "100", "100"),
}

# MSX2 BIOS SCREEN 5 default (3-bit RGB).
MSX2_DEFAULT_RGB = [
    (0, 0, 0), (0, 0, 0), (6, 1, 1), (7, 3, 3),
    (1, 1, 7), (3, 2, 7), (1, 1, 1), (6, 3, 7),
    (1, 1, 1), (3, 3, 3), (6, 6, 1), (6, 6, 4),
    (1, 4, 1), (2, 6, 7), (5, 5, 5), (7, 7, 7),
]


def msx2_channel(n):
    n &= 7
    return (n << 5) | (n << 2) | (n >> 1)


def cpu_file(bank, cpu):
    """ROM file offset for CPU address in mapper bank `bank` (0..15)."""
    if cpu < 0x8000:
        win = 0x6000
    elif cpu < 0xA000:
        win = 0x8000
    else:
        win = 0xA000
    return bank * 0x2000 + (cpu - win)


def cpu_file_win(cpu, banks):
    """banks = (bank@6000, bank@8000, bank@A000)."""
    if cpu < 0x8000:
        return cpu_file(banks[0], cpu)
    if cpu < 0xA000:
        return cpu_file(banks[1], cpu)
    return cpu_file(banks[2], cpu)


def load_palette_list(data, file_off):
    """palette_list: (index, rb, g)+ terminated by 0xFF.

    Missing slots stay (0,0,0) with mask False so overlay can skip them.
    Explicit black is mask True (pal_a7ce index 0F is black, not BIOS white).
    """
    pal = [(0, 0, 0)] * 16
    mask = [False] * 16
    i = file_off
    recs = []
    while i < len(data) and data[i] != 0xFF:
        idx = data[i]
        if idx > 15 or i + 2 >= len(data):
            break
        rb, g = data[i + 1], data[i + 2]
        rgb = (msx2_channel(rb >> 4), msx2_channel(g), msx2_channel(rb))
        pal[idx] = rgb
        mask[idx] = True
        recs.append((idx, rgb))
        i += 3
    return pal, recs, mask


def overlay_pal(base, overlay, mask=None):
    out = list(base)
    for i, rgb in enumerate(overlay):
        if mask is not None:
            if mask[i]:
                out[i] = rgb
        elif rgb != (0, 0, 0) or i == 0:
            out[i] = rgb
    return out


def default_pal():
    return [(msx2_channel(r), msx2_channel(g), msx2_channel(b))
            for r, g, b in MSX2_DEFAULT_RGB]


def apply_pal(rom, base, bank, cpu):
    pal, _, mask = load_palette_list(rom, cpu_file(bank, cpu))
    return overlay_pal(base, pal, mask)


def draw_text(buf, W, x, y, text, scale, color):
    for chr_ in text:
        glyph = FONT3x5.get(chr_)
        if glyph:
            for gy, row in enumerate(glyph):
                for gx, bit in enumerate(row):
                    if bit != "1":
                        continue
                    for yy in range(scale):
                        base = ((y + gy * scale + yy) * W + x + gx * scale) * 3
                        for xx in range(scale):
                            o = base + xx * 3
                            buf[o:o + 3] = bytes(color)
        x += 4 * scale


def render_png(path, cells, palette, cols, labels, size=8, lab_scale=2,
               zero_off=True):
    if not cells:
        return
    if isinstance(size, tuple):
        src_w, src_h = size
    else:
        src_w = src_h = size
    lab_h = 5 * lab_scale + 4
    rows_of = (len(cells) + cols - 1) // cols
    cell_w = src_w * SCALE
    cell_h = lab_h + src_h * SCALE
    W = cols * cell_w + (cols + 1) * GAP
    H = rows_of * cell_h + (rows_of + 1) * GAP
    buf = bytearray(W * H * 3)
    for i in range(W * H):
        buf[i * 3:i * 3 + 3] = bytes(BG)
    for idx, grid in enumerate(cells):
        x0 = GAP + (idx % cols) * (cell_w + GAP)
        y0 = GAP + (idx // cols) * (cell_h + GAP)
        lab = None if idx >= len(labels) else labels[idx]
        if lab is not None:
            draw_text(buf, W, x0 + 2, y0 + 2, lab, lab_scale, LABEL_RGB)
        ty = y0 + lab_h
        for y, row in enumerate(grid):
            for x, pix in enumerate(row):
                if isinstance(pix, tuple):
                    rgb = pix
                elif zero_off and pix == 0:
                    rgb = OFF
                else:
                    rgb = palette[pix]
                for dy in range(SCALE):
                    for dx in range(SCALE):
                        o = ((ty + y * SCALE + dy) * W + x0 + x * SCALE + dx) * 3
                        buf[o:o + 3] = bytes(rgb)
    pngwrite.write_rgb(path, W, H, bytes(buf))
    print("wrote", os.path.relpath(path, ROOT))


def tile_1bpp(data8, colour):
    """copy_tiles: 8 bytes, MSB left; on = C low nibble, off = high."""
    on, off = colour & 0x0F, colour >> 4
    grid = []
    for byte in data8:
        row = []
        b = byte
        for _ in range(8):
            row.append(on if (b & 0x80) else off)
            b = (b << 1) & 0xFF
        grid.append(row)
    return grid


def tile_4bpp(data, width, height):
    """SCREEN 5: high nibble = left pixel. width even."""
    grid = []
    i = 0
    for _y in range(height):
        row = []
        for _x in range(0, width, 2):
            b = data[i]
            i += 1
            row.append(b >> 4)
            row.append(b & 0x0F)
        grid.append(row)
    return grid


def dump_palette_sheet(rom, path, bank, cpu, play_pal):
    fo = cpu_file(bank, cpu)
    pal, recs, mask = load_palette_list(rom, fo)
    if not recs:
        return play_pal
    cells, labels = [], []
    for idx, rgb in recs:
        cells.append([[rgb] * 8 for _ in range(8)])
        labels.append("%02X" % idx)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, pal, cols=min(16, len(cells)), labels=labels)
    return overlay_pal(play_pal, pal, mask)


def dump_1bpp_sheet(rom, path, bank, cpu, count, colour, play_pal, cols=16):
    fo = cpu_file(bank, cpu)
    cells, labels = [], []
    for i in range(count):
        chunk = rom[fo + i * 8:fo + (i + 1) * 8]
        if len(chunk) < 8:
            break
        cells.append(tile_1bpp(chunk, colour))
        labels.append("%04X" % (cpu + i * 8))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, play_pal, cols=cols, labels=labels, zero_off=False)


# SAT colour low nibbles (high nibble of the byte is EC). Catalogue paints
# each 1bpp plane with that VDP index; pal_* is the palette_list in force.
SAT_CC = (0xD0, 0xE0)          # sat_cc_fill / puz_cc / tour_col: 0x0D / 0x4E
THROWN_KNIFE_CC = (0xB0, 0xC0) # enemy_cc2 type 1 / delay_spr Slouman: 0x0B / 0x4C
MAP_KNIFE_CC = (0xB0, 0x70)    # tool_cc knife: 0x0B / 0x47
MAP_BOOM_CC = (0x70, 0xA0)     # tool_cc boomerang: 0x07 / 0x4A
SHOVEL_CC = (0xA0, 0x70)       # shovel spin / delay_spr shovel: 0x0A / 0x47
PICK_CC = (0x70, 0x90)         # pick_ready / delay_spr pick: 0x07 / 0x49
MARK7 = (0x70,)                # tour_vic / map_vic / kind_sat: index 7
HUD_EXIT_CC = (0xB0, 0x70)     # pause-map exit 0x0B then Vic 0x07
# knife.png: 3 knife poses × 2 then 3 boom poses × 2 (rle_97a1 → F880).
KNIFE_SHEET_CC = MAP_KNIFE_CC * 3 + MAP_BOOM_CC * 3


def sprite_16(data32, colour):
    """MSX hardware 16×16: 16 left rows, then 16 right rows. MSB left.

    `colour` high nibble = on (SAT index); low nibble 0 → catalogue off.
    """
    hi, lo = colour >> 4, colour & 0x0F
    grid = []
    for row in range(16):
        pix = []
        for byte in (data32[row], data32[16 + row]):
            b = byte
            for _ in range(8):
                pix.append(hi if (b & 0x80) else lo)
                b = (b << 1) & 0xFF
        grid.append(pix)
    return grid


def append_sprites(cells, labels, blob, first_cpu, colours=SAT_CC):
    if isinstance(colours, int):
        colours = (colours,)
    for i in range(len(blob) // 32):
        chunk = blob[i * 32:(i + 1) * 32]
        cells.append(sprite_16(chunk, colours[i % len(colours)]))
        labels.append("%04X" % ((first_cpu + i * 32) & 0xFFFF))


def dump_sprite_sheet(path, cells, labels, play_pal, cols=8):
    if not cells:
        return
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, play_pal, cols=min(cols, len(cells)),
               labels=labels, size=16)


def dump_rle_sprites(rom, path, bank, cpu, dest, play_pal, colours=SAT_CC):
    blob, _, _ = decompress(rom, cpu_file(bank, cpu), 0)
    cells, labels = [], []
    append_sprites(cells, labels, blob, dest, colours)
    dump_sprite_sheet(path, cells, labels, play_pal)


# held_ptr Vic SAT (VIC_COPY X-flips are generated, not dumped).
HELD_RLE = (
    ("vic_unarmed", (
        (14, 0x86D4, 0xE000),
        (14, 0x875D, 0xE180),
        (14, 0x8FD9, 0xE300),
        (14, 0x905D, 0xE480),
    )),
    ("vic_knife", (
        (14, 0x87EE, 0xE000),
        (14, 0x8876, 0xE180),
        (14, 0x9510, 0xE240),
        (14, 0x90D4, 0xE300),
        (14, 0x91AA, 0xE480),
        (14, 0x9227, 0xE540),
    )),
    ("vic_boomerang", (
        (14, 0x8911, 0xE000),
        (14, 0x89A0, 0xE180),
        (14, 0x9510, 0xE240),
        (14, 0x90D4, 0xE300),
        (14, 0x91AA, 0xE480),
        (14, 0x9227, 0xE540),
    )),
    ("vic_shovel", (
        (14, 0x8A3F, 0xE000),
        (14, 0x8AFA, 0xE180),
        (14, 0x90D4, 0xE300),
        (14, 0x9158, 0xE480),
        (14, 0x9254, 0xE500),
    )),
    ("vic_pick", (
        (14, 0x8D08, 0xE000),
        (14, 0x8DC1, 0xE180),
        (14, 0x9304, 0xE300),
        (14, 0x9388, 0xE480),
    )),
    ("vic_hammer", (
        (14, 0x8BC6, 0xE000),
        (14, 0x8C4F, 0xE180),
        (14, 0x90D4, 0xE300),
        (14, 0x9158, 0xE480),
        (14, 0x92AD, 0xE500),
    )),
    ("vic_drill", (
        (14, 0x8E86, 0xE000),
        (14, 0x8F0E, 0xE180),
        (14, 0x9432, 0xE300),
        (14, 0x9158, 0xE480),
        (14, 0x94B7, 0xE500),
    )),
)

# copy_pat payloads in lists0E.asm (n × 32 bytes → F800). Grouped by
# character, not by copy_pat record (Vic climb is the tail of the n=6 Flouman copy).
# Colours: delay_spr types 1–2 share pat_9977 (y=0x68) with cc 0x0B/0x4C
# vs 0x0A/0x47 — not sat_cc_fill. Type 3 y=0x88 / type 4 y=0xC0. Vic-shaped
# catalogue cells keep SAT_CC; pyoncy/rock_roll sheets use delay_spr cc.
PAT_COPY = (
    ("flouman", 14, 0x98F7, 6, SAT_CC),       # cer_sat poses 4–5
    ("vic_climb", 14, 0x99B7, 4, SAT_CC),     # cer_sat / Vic-shaped
    ("pyoncy", 14, 0x9A37, 10, SHOVEL_CC),    # delay_spr / pyoncy_fr 0x88
    ("rock_roll", 14, 0x9B77, 6, PICK_CC),    # delay_spr / pick_ready 0xC0
    ("explode", 14, 0x9C37, 8, SHOVEL_CC),    # shovel/pick spin puffs 0xE0
)

# RLE not already in HELD_RLE. pal_k is the palette_list in force on that screen.
RLE_OTHER = (
    (14, 0x953D, 0xE000, "vic_die", "hud", SAT_CC),
    (14, 0x97A1, 0xF880, "knife", "hud", KNIFE_SHEET_CC),
    (15, 0xA9F6, 0xFE80, "rle_a9f6", "end", MARK7),
    (15, 0xA9FB, 0xFE80, "rle_a9fb", "wmap", MARK7),
    (15, 0xAA00, 0xE080, "vic_pushup", "hud", SAT_CC),
    (15, 0xAB59, 0xF800, "rle_ab59", "pwd", SAT_CC),
    (15, 0xABB9, 0xF800, "rle_abb9", "hud", SAT_CC),
    (15, 0xAE08, 0xFA00, "rle_ae08", "pwd", SAT_CC),
    (15, 0xAF21, 0xF820, "vic_back", "wmap", SAT_CC),
    (15, 0xBA9A, 0xF800, "pointer", "pwd", SAT_CC),
    (13, 0xBBFC, 0xF880, "rle_bbfc", "hud", MARK7),
    (13, 0xBF29, 0xF800, "rle_bf29", "hud", HUD_EXIT_CC),
)


def dump_held_sheet(rom, stem, recs, play_pal, colours=SAT_CC):
    cells, labels = [], []
    for bank, cpu, dest in recs:
        blob, _, _ = decompress(rom, cpu_file(bank, cpu), 0)
        append_sprites(cells, labels, blob, dest, colours)
    dump_sprite_sheet(os.path.join(SPRITE_DIR, stem + ".png"),
                      cells, labels, play_pal)


def dump_pat_copy(rom, play_pal):
    for stem, bank, cpu, n, colours in PAT_COPY:
        cells, labels = [], []
        fo = cpu_file(bank, cpu)
        blob = rom[fo:fo + n * 32]
        append_sprites(cells, labels, blob, cpu, colours)
        dump_sprite_sheet(os.path.join(SPRITE_DIR, stem + ".png"),
                          cells, labels, play_pal)


def dump_4bpp_sheet(rom, path, bank, cpu, width, height, play_pal):
    fo = cpu_file(bank, cpu)
    nbytes = width * height // 2
    data = rom[fo:fo + nbytes]
    if len(data) < nbytes:
        return
    grid = tile_4bpp(data, width, height)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, [grid], play_pal, cols=1, labels=["%04X" % cpu],
               size=(width, height), zero_off=False)


def word_le(rom, off):
    return rom[off] | (rom[off + 1] << 8)


def pal_idx_len(flags):
    n = (flags & 6) * 2
    return n if n else 2


def nplanes(flags):
    return 1 + ((flags & 7) >> 1)


def dest_tile_grid(data, planes, pal_idx):
    """Interleaved dest planes: planes bytes/row, 8 rows. Plane 0 is LSB."""
    grid = []
    i = 0
    nidx = 1 << planes
    table = list(pal_idx) + [0] * nidx
    for _row in range(8):
        row_planes = [data[i + p] for p in range(planes)]
        i += planes
        pix = []
        for x in range(8):
            v = 0
            for p, b in enumerate(row_planes):
                if (b >> (7 - x)) & 1:
                    v |= 1 << p
            pix.append(table[v] & 0x0F)
        grid.append(pix)
    return grid


def parse_blit(rom, list_cpu, banks):
    recs = []
    i = cpu_file_win(list_cpu, banks)
    while i < len(rom) and rom[i] != 0xFF:
        flags, tile, count = rom[i], rom[i + 1], rom[i + 2]
        dest = rom[i + 3] | (rom[i + 4] << 8)
        recs.append((flags, tile, count, dest))
        i += 5
    return recs


def pal_idx_at(rom, tbl_cpu, flags, banks):
    fo = cpu_file_win(tbl_cpu, banks)
    ptr = word_le(rom, fo + (flags >> 3) * 2)
    n = pal_idx_len(flags)
    pfo = cpu_file_win(ptr, banks)
    return list(rom[pfo:pfo + n])


def dump_blit_sheet(rom, path, list_cpu, tbl_cpu, banks, play_pal, cols=16):
    """Expand blit_list dest planes; skip X-flip recs that reuse a dest."""
    cells, labels = [], []
    seen = set()
    for flags, _tile, count, dest in parse_blit(rom, list_cpu, banks):
        if dest in seen:
            continue
        seen.add(dest)
        planes = nplanes(flags)
        bpt = 8 * planes
        pidx = pal_idx_at(rom, tbl_cpu, flags, banks)
        fo = cpu_file_win(dest, banks)
        for t in range(count):
            chunk = rom[fo + t * bpt:fo + (t + 1) * bpt]
            if len(chunk) < bpt:
                break
            cells.append(dest_tile_grid(chunk, planes, pidx))
            labels.append("%04X" % (dest + t * bpt))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, play_pal, cols=cols, labels=labels, zero_off=False)


def world_play_pal(rom, base, world, odd=False):
    """pal_15 world table + pal_hud on top of base (pal_a7ce).

    pal_15 picks even (0xB97A) or odd (0xB9F8) from (level-1)&2, then
    indexes that table by world.
    """
    tbl = cpu_file(15, 0xB9F8 if odd else 0xB97A)
    ptr = word_le(rom, tbl + world * 2)
    pal = apply_pal(rom, base, 15, ptr)
    return apply_pal(rom, pal, 15, 0xB95D)


def xflip_grid(grid):
    return [list(reversed(row)) for row in grid]


def blit_atlas(rom, list_cpu, tbl_cpu, banks):
    """VRAM tile id → 8×8 dest-plane grid, including X-flip recs."""
    atlas = {}
    for flags, tile, count, dest in parse_blit(rom, list_cpu, banks):
        planes = nplanes(flags)
        bpt = 8 * planes
        pidx = pal_idx_at(rom, tbl_cpu, flags, banks)
        fo = cpu_file_win(dest, banks)
        flip = flags & 1
        for t in range(count):
            chunk = rom[fo + t * bpt:fo + (t + 1) * bpt]
            if len(chunk) < bpt:
                break
            grid = dest_tile_grid(chunk, planes, pidx)
            if flip:
                grid = xflip_grid(grid)
            atlas[tile + t] = grid
    return atlas


def merge_atlas(*atlases):
    out = {}
    for a in atlases:
        out.update(a)
    return out


def empty_tile():
    return [[OFF] * 8 for _ in range(8)]


def lookup_tile(atlas, tid):
    return atlas.get(tid, empty_tile())


def compose_grid(atlas, ids, width):
    height = (len(ids) + width - 1) // width
    pix = []
    for ty in range(height):
        tiles = []
        for tx in range(width):
            i = ty * width + tx
            tid = ids[i] if i < len(ids) else 0
            tiles.append(lookup_tile(atlas, tid))
        for y in range(8):
            row = []
            for t in tiles:
                row.extend(t[y])
            pix.append(row)
    return pix


def parse_stamp(rom, cpu, banks):
    """STAMP rows: (x_tiles, [ids]). FE,dx starts the next row at x+(signed dx)/8."""
    i = cpu_file_win(cpu, banks)
    rows = []
    row = []
    x0 = 0
    while True:
        b = rom[i]
        i += 1
        if b == 0xFF:
            if row:
                rows.append((x0, row))
            break
        if b == 0xFE:
            if row:
                rows.append((x0, row))
            dx = rom[i]
            i += 1
            if dx >= 128:
                dx -= 256
            x0 += dx // 8
            row = []
            continue
        row.append(b)
    return rows


def compose_stamp(atlas, rows):
    if not rows:
        return None
    min_x = min(x for x, _ids in rows)
    max_x = max(x + len(ids) for x, ids in rows)
    width = max(1, max_x - min_x)
    pix = []
    for x, ids in rows:
        full = [None] * (x - min_x) + ids
        full += [None] * (width - len(full))
        tiles = [lookup_tile(atlas, t) if t is not None else empty_tile()
                 for t in full]
        for y in range(8):
            row = []
            for t in tiles:
                row.extend(t[y])
            pix.append(row)
    return pix


def dump_composite(path, grid, pal, cpu):
    if not grid:
        return
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    render_png(path, [grid], pal, cols=1, labels=["%04X" % cpu],
               size=(len(grid[0]), len(grid)), zero_off=False)


def col_ids(rom, start_idx):
    """32 × 27 tile ids for draw_cols A=start_idx (row-major)."""
    cols = []
    base = cpu_file(14, 0x9D58)
    for n in range(32):
        cpu = word_le(rom, base + (start_idx + n) * 2)
        fo = cpu_file_win(cpu, WIN_EF)
        cols.append(list(rom[fo:fo + 27]))
    ids = []
    for y in range(27):
        for x in range(32):
            ids.append(cols[x][y])
    return ids


def pad_8(grid):
    out = []
    h = len(grid)
    w = len(grid[0]) if grid else 0
    for y in range(8):
        row = []
        for x in range(8):
            if y < h and x < w:
                row.append(grid[y][x])
            else:
                row.append(OFF)
        out.append(row)
    return out


def atlas_1bpp(rom, recs):
    """recs: (bank, cpu, count, first_id, colour)."""
    atlas = {}
    for bank, cpu, count, first, colour in recs:
        fo = cpu_file(bank, cpu)
        for i in range(count):
            atlas[first + i] = tile_1bpp(rom[fo + i * 8:fo + (i + 1) * 8],
                                         colour)
    return atlas


def main():
    if not os.path.isfile(ROM_PATH):
        sys.exit("missing %s — run make first" % ROM_PATH)
    rom = open(ROM_PATH, "rb").read()
    play = apply_pal(rom, default_pal(), 15, 0xA7CE)
    title_pal = apply_pal(rom, default_pal(), 9, 0xBB8B)
    hud_pal = apply_pal(rom, play, 15, 0xB95D)
    pwd_pal = apply_pal(rom, default_pal(), 15, 0xA7FF)
    wmap_pal = apply_pal(rom, default_pal(), 15, 0xA870)
    a8bb_pal = apply_pal(rom, default_pal(), 15, 0xA8BB)
    ba78_pal = apply_pal(rom, default_pal(), 15, 0xBA78)

    os.makedirs(PALETTE_DIR, exist_ok=True)
    os.makedirs(TILESET_DIR, exist_ok=True)
    os.makedirs(SPRITE_DIR, exist_ok=True)
    os.makedirs(FONT_DIR, exist_ok=True)
    os.makedirs(METATILE_DIR, exist_ok=True)

    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "pal_a7ce.png"),
                       15, 0xA7CE, play)
    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "pal_a7ff.png"),
                       15, 0xA7FF, play)
    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "pal_a8bb.png"),
                       15, 0xA8BB, play)
    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "pal_hud.png"),
                       15, 0xB95D, play)
    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "pal_bb8b.png"),
                       9, 0xBB8B, play)

    for stem, tbl in (("pal_w_even", 0xB97A), ("pal_w_odd", 0xB9F8)):
        base = cpu_file(15, tbl)
        for w in range(1, 7):
            ptr = word_le(rom, base + w * 2)
            dump_palette_sheet(
                rom, os.path.join(PALETTE_DIR, "%s_%d.png" % (stem, w)),
                15, ptr, play)

    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "hud_bf36.png"),
                    13, 0xBF36, 18, 0x8B, hud_pal)
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "hud_bfc6.png"),
                    13, 0xBFC6, 6, 0x07, hud_pal)
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "wmap_aa29.png"),
                    12, 0xAA29, 42, 0x0A, wmap_pal)
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "wmap_ab79.png"),
                    12, 0xAB79, 5, 0x0A, wmap_pal)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bbdc.png"),
                    9, 0xBBDC, 13, 0x01, title_pal)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bc44.png"),
                    9, 0xBC44, 13, 0x02, title_pal)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bcac.png"),
                    9, 0xBCAC, 26, 0x03, title_pal)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "tiles_afdd.png"),
                    12, 0xAFDD, 0x35, 0xFB, play)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "file_pat.png"),
                    12, 0xB1B6, 4, 0xFB, play)
    dump_4bpp_sheet(rom, os.path.join(TILESET_DIR, "ef10_spr.png"),
                    12, 0xB1D6, 16, 16, play)

    blit_ptr = cpu_file(7, 0x6177)
    for w in range(1, 7):
        lst = word_le(rom, blit_ptr + w * 2)
        tbl = word_le(rom, cpu_file(7, 0x6065) + w * 2)
        dump_blit_sheet(
            rom, os.path.join(TILESET_DIR, "dest_w%d.png" % w),
            lst, tbl, WIN_789, world_play_pal(rom, play, w))

    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_common.png"),
                    0x602A, 0x6000, WIN_789, world_play_pal(rom, play, 1))
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_wpic.png"),
                    0x902E, 0x8FFC, WIN_789, wmap_pal)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_pwd.png"),
                    0x9043, 0x8FFC, WIN_789, pwd_pal)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_end2.png"),
                    0x9063, 0x8FFC, WIN_789, play)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_end3.png"),
                    0x9069, 0x8FFC, WIN_789, a8bb_pal)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_title_jp_ext.png"),
                    0x9074, 0x8FFC, WIN_789, play)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_title.png"),
                    0xB7DF, 0xB7C7, WIN_789, ba78_pal)
    dump_blit_sheet(rom, os.path.join(TILESET_DIR, "dest_title_jp.png"),
                    0xB120, 0xB116, WIN_EF, play)

    dump_pat_copy(rom, hud_pal)
    for stem, recs in HELD_RLE:
        dump_held_sheet(rom, stem, recs, hud_pal)
    # world_scr / pal_a8bb overlay slots they list; D/E stay pal_hud.
    pals = {
        "hud": hud_pal,
        "pwd": pwd_pal,
        "play": play,
        "wmap": apply_pal(rom, hud_pal, 15, 0xA870),
        "end": apply_pal(rom, hud_pal, 15, 0xA8BB),
    }
    for bank, cpu, dest, stem, pal_k, colours in RLE_OTHER:
        dump_rle_sprites(rom, os.path.join(SPRITE_DIR, stem + ".png"),
                         bank, cpu, dest, pals[pal_k], colours)

    atlas_9074 = blit_atlas(rom, 0x9074, 0x8FFC, WIN_789)
    atlas_jp = merge_atlas(atlas_9074, blit_atlas(rom, 0xB120, 0xB116, WIN_EF))
    atlas_pwd = blit_atlas(rom, 0x9043, 0x8FFC, WIN_789)
    atlas_wpic = blit_atlas(rom, 0x902E, 0x8FFC, WIN_789)
    atlas_end2 = blit_atlas(rom, 0x9063, 0x8FFC, WIN_789)
    atlas_end3 = blit_atlas(rom, 0x9069, 0x8FFC, WIN_789)
    blit_ptr = cpu_file(7, 0x6177)
    w1 = word_le(rom, blit_ptr + 2)
    t1 = word_le(rom, cpu_file(7, 0x6065) + 2)
    atlas_w1 = merge_atlas(
        blit_atlas(rom, w1, t1, WIN_789),
        blit_atlas(rom, 0x602A, 0x6000, WIN_789))

    dump_composite(os.path.join(GFX, "cols_title.png"),
                   compose_grid(atlas_jp, col_ids(rom, 0), 32), play, 0x9DB8)
    dump_composite(os.path.join(GFX, "cols_pwd.png"),
                   compose_grid(atlas_pwd, col_ids(rom, 4), 32), pwd_pal, 0x9E24)
    dump_composite(os.path.join(GFX, "cols_end.png"),
                   compose_grid(atlas_pwd, col_ids(rom, 15), 32), play, 0x9F4D)

    for cpu, atlas, pal, stem in (
            (0xA3E8, atlas_wpic, wmap_pal, "stamp_hallway0"),
            (0xA4C7, atlas_wpic, wmap_pal, "stamp_hallway1"),
            (0xA642, atlas_wpic, wmap_pal, "stamp_a642"),
            (0xA6B1, atlas_wpic, wmap_pal, "stamp_a6b1"),
            (0xA6E0, atlas_end3, a8bb_pal, "stamp_a6e0"),
            (0xB8DB, atlas_jp, play, "stamp_logo_jp"),
    ):
        dump_composite(os.path.join(GFX, stem + ".png"),
                       compose_stamp(atlas, parse_stamp(rom, cpu, WIN_EF)),
                       pal, cpu)

    title_1bpp = atlas_1bpp(rom, (
        (9, 0xBBDC, 13, 1, 0x01),
        (9, 0xBC44, 13, 14, 0x02),
        (9, 0xBCAC, 26, 27, 0x03),
    ))
    dump_composite(os.path.join(GFX, "stamp_logo_konami.png"),
                   compose_stamp(title_1bpp,
                                 parse_stamp(rom, 0xBB9B, WIN_789)),
                   title_pal, 0xBB9B)

    dump_composite(os.path.join(GFX, "pic_a2c8.png"),
                   compose_grid(atlas_end2, list(rom[cpu_file(15, 0xA2C8):
                                                     cpu_file(15, 0xA2C8) + 144]),
                                12), play, 0xA2C8)
    dump_composite(os.path.join(GFX, "pic_a358.png"),
                   compose_grid(atlas_pwd, list(rom[cpu_file(15, 0xA358):
                                                    cpu_file(15, 0xA358) + 144]),
                                12), pwd_pal, 0xA358)
    dump_composite(os.path.join(GFX, "pic_a702.png"),
                   compose_grid(atlas_end3, list(rom[cpu_file(15, 0xA702):
                                                     cpu_file(15, 0xA702) + 144]),
                                12), a8bb_pal, 0xA702)
    dump_composite(os.path.join(GFX, "wpic0.png"),
                   compose_grid(atlas_wpic, list(rom[cpu_file(15, 0xA5A6):
                                                     cpu_file(15, 0xA5A6) + 24]),
                                12), wmap_pal, 0xA5A6)
    dump_composite(os.path.join(GFX, "wpic1.png"),
                   compose_grid(atlas_wpic, list(rom[cpu_file(15, 0xA5BE):
                                                     cpu_file(15, 0xA5BE) + 48]),
                                12), wmap_pal, 0xA5BE)
    dump_composite(os.path.join(GFX, "wpic2.png"),
                   compose_grid(atlas_wpic, list(rom[cpu_file(15, 0xA5EE):
                                                     cpu_file(15, 0xA5EE) + 84]),
                                14), wmap_pal, 0xA5EE)

    ptrs = [word_le(rom, cpu_file(14, 0x8000) + i * 2) for i in range(114)]
    uniq = []
    seen = set()
    for p in ptrs:
        if p not in seen:
            seen.add(p)
            uniq.append(p)
    uniq.sort()
    cells, labels = [], []
    for i, p in enumerate(uniq):
        end = uniq[i + 1] if i + 1 < len(uniq) else p + 1
        fo = cpu_file_win(p, WIN_EF)
        blob = list(rom[fo:fo + (end - p)])
        if 0xFF in blob:
            continue
        n = len(blob)
        if n == 64:
            w = 8
        elif n == 16:
            w = 4
        elif n == 8:
            w = 4
        elif n == 6:
            w = 3
        else:
            continue
        cells.append(pad_8(compose_grid(atlas_w1, blob, w)))
        labels.append("%04X" % p)
    if cells:
        render_png(os.path.join(METATILE_DIR, "glyphs0E.png"),
                   cells, world_play_pal(rom, play, 1),
                   cols=min(8, len(cells)), labels=labels, zero_off=False)


if __name__ == "__main__":
    main()
