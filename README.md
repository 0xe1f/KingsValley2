# King's Valley II (MSX2) — disassembly

[![verify](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml/badge.svg)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)

> This project is a human-guided, largely AI-executed workflow.

A work-in-progress, **byte-exact and reassemblable** disassembly of Konami's
*King's Valley II* (*The Seal of El Giza* / 王家の谷II, 1988) for the MSX2 —
a 128 KiB Konami SCC MegaROM (RC761). Not *The Maze of Galious*.

The goal is a readable, commented, buildable source that reproduces the original
ROM exactly, so the game can be understood and modified.

## What's here

```
KingsValley2.asm    master file: stitches 8 KiB banks into the ROM image
KingsValley2.sha1   SHA-1 of the original 128 KiB ROM (`make verify`)
banks/              one file per mapper bank (boot triplet is one window)
  bank00.asm        bank 0: AB header, cart_init / cart_boot / H.TIMI / pager
  banks123.asm      banks 1–3: boot triplet @ 6000–BFFF (page_banks_123)
  bank04.asm        sound/SCC driver @ 6000 (MODULE bank04)
  bank05.asm … 06   packed-PSG payload @ 8000/A000
  bank07.asm        tables / packed lists @ 6000 (MODULE bank07)
  bank08.asm … 09   tileset + gfx @ 8000/A000
  bank10.asm … 11   map tables / streams @ 6000/8000
  bank12.asm        gfx prefix + code @ A000 (MODULE bank12)
  bank13.asm        tables / streams / tiles @ A000 (page_bank_13)
  bank14.asm … 15   font + UI gfx @ 8000/A000 (page_banks_14_15)
tools/workbench/    MSXDAW submodule (regen, romscan, RLE, PSG)
docs/               reverse-engineering notes (`game-notes.md`, `progress.md`)
Makefile            build / verify
```

Bank 0–15 assemble from labeled `.asm`. A clean checkout can assemble and
verify with no leftover `INCBIN` bins.

## Building

You need **sjasmplus**, built from source
([z00m128/sjasmplus](https://github.com/z00m128/sjasmplus)) and placed at
`tools/sjasmplus`. No original ROM and no MSXDAW workbench checkout are
required to assemble or verify. (`make banks` and bank regen use the
`tools/workbench` submodule.)

```sh
make verify     # assemble, then SHA-1 check against KingsValley2.sha1
```

`make` alone produces `KingsValley2.rom` in the repo root (gitignored).
`KingsValley2.sha1` is the SHA-1 of the original 128 KiB MSX2 ROM; `make verify`
rebuilds and confirms the output matches it.

## How it works

128 KiB = 16 × 8 KiB banks (Konami SCC mapping). Each bank is labeled
source (code, named payload `INCBIN`, or a mix). After every change the ROM
is rebuilt and SHA-1 checked so it stays byte-for-byte identical.

See `docs/game-notes.md` for reverse-engineering notes and `docs/progress.md`
for current status and next steps.

## License

Original work in this repository (tools, comments, documentation, labels,
and project structure) is licensed under the Apache License, Version 2.0.
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).

*King's Valley II* (*The Seal of El Giza*) is © 1988 Konami. This project does
not relicense the original game, ROM, graphics, or music.
