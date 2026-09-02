# King's Valley II (MSX2) — disassembly

[![verify](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml/badge.svg)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)
[![in source](https://img.shields.io/endpoint?style=flat&url=https://raw.githubusercontent.com/0xe1f/KingsValley2/badges/in-source.json)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)
[![named](https://img.shields.io/endpoint?style=flat&url=https://raw.githubusercontent.com/0xe1f/KingsValley2/badges/named.json)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)
[![op comments](https://img.shields.io/endpoint?style=flat&url=https://raw.githubusercontent.com/0xe1f/KingsValley2/badges/op-comments.json)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)
[![sub comments](https://img.shields.io/endpoint?style=flat&url=https://raw.githubusercontent.com/0xe1f/KingsValley2/badges/sub-comments.json)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)

> This project is a human-guided, largely AI-executed workflow.

A work-in-progress, **byte-exact and reassemblable** disassembly of Konami's
*King's Valley II* (*The Seal of El Giza* / 王家の谷II, 1988) for the MSX2 —
a 128 KiB Konami SCC MegaROM (RC761).

The goal is a readable, commented, buildable source that reproduces the original
ROM exactly, so the game can be understood and modified.

You can find random interesting facts from the disassembly at
[@msxti.me](https://bsky.app/profile/msxti.me) on Bluesky.

## What's here

```
KingsValley2.asm    master file: stitches paging windows into the ROM image
KingsValley2.sha1   SHA-1 of the original 128 KiB ROM (`make verify`)
banks/              one file per paging window (stems banks_0 / banks_123 / …)
  banks_0.asm       bank 0: AB header, cart_init / cart_boot / H.TIMI / pager
  banks_123.asm     banks 1-3: boot triplet @ 6000–BFFF
  banks_456.asm     banks 4-6: sound/SCC + packed-PSG (MODULE banks_456)
  banks_789.asm     banks 7-9: blit dests + title tiles (MODULE banks_789)
  banks_abc.asm     banks a-c: maps / overlays / bank c code (MODULE banks_abc)
  banks_d.asm       bank d: tables / streams / tiles (MODULE banks_d)
  banks_ef.asm      banks e-f: font + UI gfx (MODULE banks_ef)
  banks_*.blocks    z80dasm code/data map, one per window (regen-bank.sh)
tools/workbench/    MSXDAW submodule (regen, romscan, RLE, PSG)
tools/gfxdump.py    `make gfx` contact sheets
tools/psgplay.py    `make music` / `make sfx` WAV catalogue
gfx/                PNG catalogue (`palettes/` `tilesets/` `sprites/` `fonts/` `metatiles/`)
music/              BGM WAV previews
sfx/                SFX WAV previews
docs/               reverse-engineering notes (`game-notes.md`, `progress.md`)
Makefile            build / verify
```

Bank 00–0F assemble from labeled `.asm`. A clean checkout can assemble and
verify with no leftover `INCBIN` bins.

## Building

You need **sjasmplus**, built from source
([z00m128/sjasmplus](https://github.com/z00m128/sjasmplus)) and placed at
`tools/sjasmplus`. No original ROM and no MSXDAW workbench checkout are
required to assemble or verify. (`make banks` / `make coverage` / `make gfx` /
`make music` / `make sfx` and bank regen use the `tools/workbench` submodule.)

```sh
make skills     # tools/workbench/bin/install-skills -> .cursor/skills/
make verify     # assemble, then SHA-1 check against KingsValley2.sha1
make coverage   # local Shields JSON under generated/badges/
```

`make` alone produces `KingsValley2.rom` in the repo root (gitignored).
`KingsValley2.sha1` is the SHA-1 of the original 128 KiB MSX2 ROM; `make verify`
rebuilds and confirms the output matches it. `make gfx` writes labelled PNG
sheets under `gfx/`. `make music` / `make sfx` write WAV previews under
`music/` and `sfx/` (needs a built ROM and the workbench player).

## How it works

128 KiB = 16 × 8 KiB banks (hex `0`–`f`, Konami SCC mapping). Shared CPU
windows are one labelled `.asm` plus a matching `.blocks` map (stems
`banks_0`, `banks_123`, `banks_456`, `banks_789`, `banks_abc`, `banks_d`,
`banks_ef`). After every change the ROM is rebuilt and SHA-1 checked so it
stays byte-for-byte identical.

See `docs/game-notes.md` for reverse-engineering notes and `docs/progress.md`
for current status and next steps.

## License

Original work in this repository (tools, comments, documentation, labels,
and project structure) is licensed under the Apache License, Version 2.0.
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).

*King's Valley II* (*The Seal of El Giza*) is © 1988 Konami. This project does
not relicense the original game, ROM, graphics, or music.
