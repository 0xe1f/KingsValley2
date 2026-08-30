#!/usr/bin/env python3
# Copyright 2026 Akop Karapetyan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Render King's Valley II BGM and SFX via tools/workbench/konami/sccplay.py.

Reads the rebuilt KingsValley2.rom (banks 4/5/6 at 0x6000/0x8000/0xA000)
and writes 16-bit mono WAVs into music/ (pri 0xA0 arrangements) or sfx/.

Usage (from repo root):
  python3 tools/psgplay.py              # music/ (stage BGM + other 0xA0 ids)
  python3 tools/psgplay.py --id 0x05
  python3 tools/psgplay.py --sfx         # sfx/ (remaining ids 1-0x41)
  python3 tools/psgplay.py --sfx --id 0x3C
"""
from __future__ import annotations

import argparse
import os
import sys

_TOOLS = os.path.dirname(os.path.abspath(__file__))
_WB = os.path.join(_TOOLS, "workbench")
sys.path.insert(0, os.path.join(_WB, "konami"))
import sccplay  # noqa: E402

ROOT = os.path.dirname(_TOOLS)
MUSIC = os.path.join(ROOT, "music")
SFX_DIR = os.path.join(ROOT, "sfx")

MAP = sccplay.BankMap([(0x6000, 4), (0x8000, 5), (0xA000, 6)])
PTR = 0x6F2E  # sound_ptr; id 1 is the first word

# Call-site names. Unlisted 0xA0 ids still go to music/ as NN_psg.
MUSIC_NAMES = {
    0x03: "03_boot",
    0x04: "04_psg",
    0x05: "05_bgm_stage",
    0x06: "06_bgm_stage",
    0x07: "07_bgm_stage",
    0x08: "08_bgm_stage",
    0x09: "09_bgm_stage",
    0x0A: "0A_puzzle",
    0x0B: "0B_psg",
    0x0C: "0C_psg",
    0x0D: "0D_psg",
    0x0E: "0E_psg",
    0x0F: "0F_life",
    0x10: "10_title",
    0x11: "11_title_sel",
    0x12: "12_psg",
    0x23: "23_psg",
    0x28: "28_die",
    0x29: "29_psg",
    0x30: "30_psg",
    0x3A: "3A_psg",
}

SFX_NAMES = {
    0x01: "01_stop",
    0x02: "02_sfx",
    0x13: "13_sfx",
    0x14: "14_sfx",
    0x15: "15_sfx",
    0x16: "16_sfx",
    0x17: "17_sfx",
    0x18: "18_sfx",
    0x19: "19_sfx",
    0x1A: "1A_sfx",
    0x1B: "1B_sfx",
    0x1C: "1C_sfx",
    0x1D: "1D_sfx",
    0x1E: "1E_sfx",
    0x1F: "1F_sfx",
    0x20: "20_sfx",
    0x21: "21_sfx",
    0x22: "22_sfx",
    0x24: "24_sfx",
    0x25: "25_sfx",
    0x26: "26_sfx",
    0x27: "27_sfx",
    0x2A: "2A_sfx",
    0x2B: "2B_sfx",
    0x2C: "2C_sfx",
    0x2D: "2D_sfx",
    0x2E: "2E_sfx",
    0x2F: "2F_sfx",
    0x31: "31_sfx",
    0x32: "32_sfx",
    0x33: "33_sfx",
    0x34: "34_sfx",
    0x35: "35_sfx",
    0x36: "36_sfx",
    0x37: "37_sfx",
    0x38: "38_sfx",
    0x39: "39_sfx",
    0x3B: "3B_sfx",
    0x3C: "3C_fall",
    0x3D: "3D_sfx",
    0x3E: "3E_sfx",
    0x3F: "3F_sfx",
    0x40: "40_sfx",
    0x41: "41_sfx",
}

ALL_IDS = list(range(1, 0x42))


def load_rom() -> bytes:
    path = os.path.join(ROOT, "KingsValley2.rom")
    if not os.path.isfile(path):
        sys.exit("no ROM: run make to produce KingsValley2.rom")
    data = open(path, "rb").read()
    if len(data) != 0x20000:
        sys.exit("expected 128 KiB ROM at %s (got %d)" % (path, len(data)))
    return data


def music_ids(rom: bytes) -> list[int]:
    out = []
    for i in ALL_IDS:
        if i in MUSIC_NAMES or sccplay.header_pri(rom, MAP, PTR, i) == 0xA0:
            out.append(i)
    return out


def sfx_ids(rom: bytes) -> list[int]:
    skip = set(music_ids(rom))
    return [i for i in ALL_IDS if i not in skip]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--sfx", action="store_true", help="render sfx into sfx/")
    ap.add_argument("--id", type=lambda s: int(s, 0), help="single id 1-0x41")
    ap.add_argument("--loops", type=int, default=2, help="FD-jump repeats before fade (BGM)")
    ap.add_argument("--min-seconds", type=float, default=20.0,
                    help="play at least this long if the track loops")
    ap.add_argument("--seconds", type=float, default=None,
                    help="hard cap (default 90 BGM / 4 sfx)")
    ap.add_argument("--rate", type=int, default=22050)
    ap.add_argument("-o", "--out", default=None)
    args = ap.parse_args()

    rom = load_rom()
    if args.sfx:
        names = SFX_NAMES
        ids = [args.id] if args.id is not None else sfx_ids(rom)
        for i in ids:
            if i not in names:
                names[i] = "%02X_sfx" % i
        sccplay.run(
            rom, MAP, PTR, ids,
            sfx=True, names=names, out_dir=args.out or SFX_DIR,
            rate=args.rate, seconds=args.seconds,
        )
        return

    names = dict(MUSIC_NAMES)
    ids = [args.id] if args.id is not None else music_ids(rom)
    for i in ids:
        if i not in names:
            names[i] = "%02X_psg" % i
    sccplay.run(
        rom, MAP, PTR, ids,
        names=names, out_dir=args.out or MUSIC,
        rate=args.rate, loops=args.loops,
        min_seconds=args.min_seconds, seconds=args.seconds,
    )


if __name__ == "__main__":
    main()
