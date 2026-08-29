# King's Valley II (MSX2) — disassembly

[![verify](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml/badge.svg)](https://github.com/0xe1f/KingsValley2/actions/workflows/verify.yml)

> This project is a human-guided, largely AI-executed workflow.

A work-in-progress, **byte-exact and reassemblable** disassembly of Konami's
*King's Valley II* (*The Maze of Galious*, 1988) for the MSX2 — a 128 KiB
Konami SCC MegaROM (RC761).

The goal is a readable, commented, buildable source that reproduces the original
ROM exactly, so the game can be understood and modified.

## What's here

```
KingsValley2.asm    master file: stitches 8 KiB banks into the ROM image
KingsValley2.sha1   SHA-1 of the original 128 KiB ROM (`make verify`)
banks/              one file per mapper bank
  bank00.asm        bank 0: AB header, cart_init / cart_boot / H.TIMI
  bank01.bin …      leftover banks, still INCBIN until folded
tools/workbench/    MSXDAW submodule (regen, romscan, RLE, PSG)
docs/               reverse-engineering notes (`game-notes.md`, `progress.md`)
Makefile            build / verify
```

Bank 0 assembles from labeled `.asm`. Banks 1–15 are committed leftover
`INCBIN`s so a clean checkout can still assemble and verify.

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

128 KiB = 16 × 8 KiB banks (Konami SCC mapping). Banks start as `INCBIN` and
are converted from raw binary into commented disassembly one at a time. After
every change the ROM is rebuilt and SHA-1 checked so it stays byte-for-byte
identical.

See `docs/game-notes.md` for reverse-engineering notes and `docs/progress.md`
for current status and next steps.

## License

Original work in this repository (tools, comments, documentation, labels,
and project structure) is licensed under the Apache License, Version 2.0.
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).

*King's Valley II* (*The Maze of Galious*) is © 1988 Konami. This project does
not relicense the original game, ROM, graphics, or music.
