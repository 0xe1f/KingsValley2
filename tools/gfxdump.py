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
  gfx/tilesets/<stem>.png   copy_tiles 8x8 1bpp sources
  gfx/fonts/<stem>.png      HUD glyphs / world-map font (copy_tiles)
  gfx/metatiles/<stem>.png  editor minimaps (32×24 1bpp)

Cell header is 4 uppercase hex digits (CPU of that atom), except palette
swatches which use the 2-digit index. In-game MSX2 palette. No PIL.

Usage:  tools/gfxdump.py            (run from the repo root)
"""
import os, sys

_TOOLS = os.path.dirname(os.path.abspath(__file__))
_WB = os.path.join(_TOOLS, "workbench")
sys.path.insert(0, os.path.join(_WB, "msx"))
import pngwrite

ROOT = os.path.dirname(_TOOLS)
ROM_PATH = os.path.join(ROOT, "KingsValley2.rom")
GFX = os.path.join(ROOT, "gfx")
PALETTE_DIR = os.path.join(GFX, "palettes")
TILESET_DIR = os.path.join(GFX, "tilesets")
FONT_DIR = os.path.join(GFX, "fonts")
METATILE_DIR = os.path.join(GFX, "metatiles")

SCALE = 6
GAP = 2
BG = (0x20, 0x28, 0x30)
OFF = (0x30, 0x3A, 0x44)
LABEL_RGB = (200, 200, 205)

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


def load_palette_list(data, file_off):
    """palette_list: (index, rb, g)+ terminated by 0xFF. Missing slots stay 0."""
    pal = [(0, 0, 0)] * 16
    i = file_off
    recs = []
    while i < len(data) and data[i] != 0xFF:
        idx = data[i]
        if idx > 15 or i + 2 >= len(data):
            break
        rb, g = data[i + 1], data[i + 2]
        rgb = (msx2_channel(rb >> 4), msx2_channel(g), msx2_channel(rb))
        pal[idx] = rgb
        recs.append((idx, rgb))
        i += 3
    return pal, recs


def overlay_pal(base, overlay):
    out = list(base)
    for i, rgb in enumerate(overlay):
        if rgb != (0, 0, 0) or i == 0:
            out[i] = rgb
    return out


def default_pal():
    return [(msx2_channel(r), msx2_channel(g), msx2_channel(b))
            for r, g, b in MSX2_DEFAULT_RGB]


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


def render_png(path, cells, palette, cols, labels, size=8, lab_scale=2):
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
                else:
                    rgb = OFF if pix == 0 else palette[pix]
                for dy in range(SCALE):
                    for dx in range(SCALE):
                        o = ((ty + y * SCALE + dy) * W + x0 + x * SCALE + dx) * 3
                        buf[o:o + 3] = bytes(rgb)
    pngwrite.write_rgb(path, W, H, bytes(buf))
    print("wrote", os.path.relpath(path, ROOT))


def tile_1bpp(data8, colour):
    """copy_tiles: 8 bytes, MSB left; on = C high nibble, off = low."""
    hi, lo = colour >> 4, colour & 0x0F
    grid = []
    for byte in data8:
        row = []
        b = byte
        for _ in range(8):
            row.append(hi if (b & 0x80) else lo)
            b = (b << 1) & 0xFF
        grid.append(row)
    return grid


def dump_palette_sheet(rom, path, bank, cpu, play_pal):
    fo = cpu_file(bank, cpu)
    pal, recs = load_palette_list(rom, fo)
    if not recs:
        return pal
    cells, labels = [], []
    for idx, rgb in recs:
        cells.append([[rgb] * 8 for _ in range(8)])
        labels.append("%02X" % idx)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, pal, cols=min(16, len(cells)), labels=labels)
    return overlay_pal(play_pal, pal)


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
    render_png(path, cells, play_pal, cols=cols, labels=labels)


def sprite_16(data32, colour):
    """MSX hardware 16×16: 16 left rows, then 16 right rows. MSB left."""
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


def dump_sprites_16(rom, path, bank, cpu, count, colour, play_pal):
    fo = cpu_file(bank, cpu)
    cells, labels = [], []
    for i in range(count):
        chunk = rom[fo + i * 32:fo + (i + 1) * 32]
        if len(chunk) < 32:
            break
        cells.append(sprite_16(chunk, colour))
        labels.append("%04X" % (cpu + i * 32))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, cells, play_pal, cols=count, labels=labels, size=16)


def dump_1bpp_bitmap(rom, path, bank, cpu, width, height, colour, play_pal):
    """Row-major 1bpp, MSB left, width multiple of 8."""
    fo = cpu_file(bank, cpu)
    nbytes = width * height // 8
    data = rom[fo:fo + nbytes]
    hi, lo = colour >> 4, colour & 0x0F
    grid = []
    i = 0
    for _y in range(height):
        row = []
        for _x in range(0, width, 8):
            b = data[i]
            i += 1
            for _ in range(8):
                row.append(hi if (b & 0x80) else lo)
                b = (b << 1) & 0xFF
        grid.append(row)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    render_png(path, [grid], play_pal, cols=1, labels=["%04X" % cpu],
               size=(width, height))


def word_le(rom, off):
    return rom[off] | (rom[off + 1] << 8)


def main():
    if not os.path.isfile(ROM_PATH):
        sys.exit("missing %s — run make first" % ROM_PATH)
    rom = open(ROM_PATH, "rb").read()
    play = default_pal()
    pal_a7ce, _ = load_palette_list(rom, cpu_file(15, 0xA7CE))
    play = overlay_pal(play, pal_a7ce)

    os.makedirs(PALETTE_DIR, exist_ok=True)
    os.makedirs(TILESET_DIR, exist_ok=True)
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
    dump_palette_sheet(rom, os.path.join(PALETTE_DIR, "bb8b_pal.png"),
                       9, 0xBB8B, play)

    # pal_15: tbl_word[E241] at B97A (even pyramid) / B9F8 (odd). [0] sentinel.
    for stem, tbl in (("pal_w_even", 0xB97A), ("pal_w_odd", 0xB9F8)):
        base = cpu_file(15, tbl)
        for w in range(1, 7):
            ptr = word_le(rom, base + w * 2)
            dump_palette_sheet(
                rom, os.path.join(PALETTE_DIR, "%s_%d.png" % (stem, w)),
                15, ptr, play)

    # copy_tiles 8x8 1bpp (B, C) with in-game ink C.
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "hud_bf36.png"),
                    13, 0xBF36, 18, 0x8B, play)
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "hud_bfc6.png"),
                    13, 0xBFC6, 6, 0x07, play)
    # world-map font is bank 0C @ 0xAA29 (not bank 0B map bytes).
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "wmap_aa29.png"),
                    12, 0xAA29, 42, 0x0A, play)
    dump_1bpp_sheet(rom, os.path.join(FONT_DIR, "wmap_ab79.png"),
                    12, 0xAB79, 5, 0x0A, play)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bbdc.png"),
                    9, 0xBBDC, 13, 0x01, play)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bc44.png"),
                    9, 0xBC44, 13, 0x02, play)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "title_bcac.png"),
                    9, 0xBCAC, 26, 0x03, play)
    dump_1bpp_sheet(rom, os.path.join(TILESET_DIR, "bank0C_afdd.png"),
                    12, 0xAFDD, 0x35, 0xFB, play)
    dump_1bpp_bitmap(rom, os.path.join(METATILE_DIR, "map_bb3c.png"),
                     13, 0xBB3C, 32, 24, 0x62, play)
    dump_1bpp_bitmap(rom, os.path.join(METATILE_DIR, "map_bb9c.png"),
                     13, 0xBB9C, 32, 24, 0x5E, play)


if __name__ == "__main__":
    main()
