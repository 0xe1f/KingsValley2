# KingsValley2 — notes

Mapper: **konami-scc** (RC761). 128 KiB = 16 × 8 KiB banks. SHA-1
`5ec8811254dc762c6852289a08acf22954404f0d`. See [`docs/probe.md`](probe.md).

Source split is one file per bank. No paging-window files yet (banks 1–3 are
the default triplet and an opcode straddles 0x7FFF→0x8000, but they stay
separate files).

## Boot (bank 0 @ CPU 0x4000)

- MSX `AB` header; **init = 0x40A3** (`cart_init`).
- Game Master relative option table at 0x4010 (`"CD"` / RC761 BCD `07 61`).
  Not code; `H.TIMI` is `JP 0x402E`.
- `cart_init` does not stay in the cart: it writes `RST 30h` / slot /
  `cart_boot` into **H.STKE** (`0xFEDA`) and `ret`s so BIOS continues, then
  the hook CALSLTs back to **0x40B5** (`cart_boot`).
- `cart_boot`: `im 1`, `ld sp,0xE000`, disable **H.KEYI** (`0xFD9A` ← `RET`),
  page banks 1/2/3 into 0x6000/0x8000/0xA000 (`page_triplet` with A=1), then
  install **H.TIMI** as `JP htimi_isr` (`0x402E`).
- `htimi_isr` is a `DI` that z80dasm had glued onto a preceding `0xF6` as
  `or 0F3h`. The ISR body starts at 0x402F (`ld hl,0xE215` …).
- No `ld (5000h),a` anywhere in this dump, so page 4000–5FFF is never remapped.
- Helpers: `ADD_HL_A` (0x408F), `ADD_DE_A` (0x4094), `DISPATCH_A` (0x4099).
  Every `call DISPATCH_A` in banks 0–3 now has its inline word table marked
  (`table[0]` == first handler after the table where that idiom holds;
  otherwise bound by the next real routine). Bank 1’s table at 0x7362 is
  65 words. Some handlers live in the next bank of the triplet
  (0x7E6F → 0x8018) or in bank 0 (`sound_far` stubs at 0x41F4 from 0x43A4).

## Mapper schedule (`page_triplet` @ 0x418D)

Write A / A+1 / A+2 to `7000` / `9000` / `B000` and mirror at
`mapper_bank_6000/8000/A000` (`0xF0F1–F0F3`). Wrappers:

| Helper | A | 6000 | 8000 | A000 |
|---|---|---|---|---|
| `page_banks_123` | 1 | 1 | 2 | 3 |
| `page_banks_456` | 4 | 4 | 5 | 6 |
| `page_banks_789` | 7 | 7 | 8 | 9 |
| `page_banks_10_11_12` | 10 | 10 | 11 | 12 |
| `page_bank_12` / `_13` / `_15` | 12 / 13 / 15 | (keep) | (keep) | 12 / 13 / 15 |
| `page_banks_14_15` | 14 | (keep) | 14 | 15 |

Temporary far calls (H.TIMI, sound stub `l4326h`, `sub_53b6h`) page 4/5/6,
`call 6000h` / `6003h` / `6006h`, then restore from `0xF0F1–F0F3`.

Bank 4 starts with `jp 6009h` / `jp 603dh` / `jp 62f8h` matching those three
entries. SCC enable `ld a,3Fh / ld (9000h),a` is in bank 4 (file offset
`0x8024`).

`workbench.cfg` `bank_org` matches this table. Scaffold `n%4` PHASE was
wrong from bank 4 onward.

## Bank 1 (@ 0x6000)

Folded to [`banks/bank01.asm`](../banks/bank01.asm). Code-heavy. Starts with
`call 51D0h` (twice) / `call 5D41h` into bank 0. Last opcode `ld hl,0E2F3h`
straddles 0x8000 (bank 2); `jr z,08016h` at 0x7FFC.

`.blocks`: 32-byte copy at 0x6039, `DISPATCH_A` word tables (including the
65-word table at 0x7362), byte table at 0x68DD.

## Banks 2–3 (boot triplet @ 0x8000 / 0xA000)

Folded to [`banks/bank02.asm`](../banks/bank02.asm) /
[`banks/bank03.asm`](../banks/bank03.asm).

- Bank 2 byte 0 is the high byte of that `ld hl,0E2F3h`. Real code starts at
  0x8001 (`call 7F39h`). `l8016h` is `or a / ret`, the `jr z` target from
  bank 1. No opcode straddle into bank 3.
- Bank 3 starts `ld a,3 / ld (0xE280),a / jp 0x42F3`. Trailing 283 bytes of
  `0xFF` from 0xBEE5. Several actor `DISPATCH_A` tables share first entry
  `0xA6FF`.

## Bank 4 (@ 0x6000, triplet 4/5/6)

Folded to [`banks/bank04.asm`](../banks/bank04.asm) inside `MODULE bank04`
(same CPU window as bank 1). Jump table:

| CPU | Name | Bank 0 caller |
|---|---|---|
| 0x6000 | `banks456_init` → `sound_init` | `sub_53b6h` |
| 0x6003 | `sound_entry` → `sound_play` | `sound_far` (0x4326) |
| 0x6006 | `tick_entry` → `sound_tick` | `htimi_isr` |

`sound_play` copies 0x12 bytes from `sound_ptr[id*2]` (base 0x6F2C). Id 0
overlaps the preceding `ld (9000h),a / ret` (`90 C9`); first stream is
0x6FB0. Ids 1–0x41 headers live in this bank; channel pointers inside those
headers continue into banks 5–6. Ids 0x80–0x84 are special-cased. SCC enable
`ld a,3Fh / ld (9000h),a`; 32-byte wavetable copy to `9800` + n*0x20.
Packed-PSG payload in this bank is `bytedata` from 0x6FB0.

## Banks 5–6 (@ 0x8000 / 0xA000)

Packed-PSG continuation, not code (`gfxview` is noise). Folded as named
payloads [`banks/bank05.psg.bin`](../banks/bank05.psg.bin) /
[`banks/bank06.psg.bin`](../banks/bank06.psg.bin) (7601 bytes + 591 × `0xFF`
from 0xBDB1).

## Banks 7–9 (@ 0x6000 / 0x8000 / 0xA000)

Tables + tileset + gfx, not code. Folded as named payloads
[`banks/bank07.tbl.bin`](../banks/bank07.tbl.bin) (full 8 KiB) /
[`banks/bank08.gfx.bin`](../banks/bank08.gfx.bin) (full 8 KiB) /
[`banks/bank09.gfx.bin`](../banks/bank09.gfx.bin) (7548 bytes + 644 × `0xFF`
from 0xBD7C), `MODULE bank07` / `bank08` / `bank09`.

- Bank 7: 6-word palette index table at 0x6000 (`[0] == 0x600C`). Packed
  5-byte blit list at 0x602A (consumer `l54a0h` after `page_banks_789`);
  `0xFF` terminator overlaps `e241_tbl[0]` at 0x6065 (`sub_5640h` indexes
  via `(0xE241)`). Second list at 0x6177 uses a different grammar.
- Bank 8: tileset at 0x8000 (`l54a0h` tile base). Palette index table at
  0x8FFC (`[0] == 0x9006`); packed lists at 0x902E onward (`DE=0x8FFC`).
- Bank 9: SCREEN 2-style pattern/color head; lists at 0xB7C7 / 0xB7DF;
  `l4f1ch` streams at 0xBB8B.

## Banks 10–12 (@ 0x6000 / 0x8000 / 0xA000)

Map tables + streams + mixed gfx/code. Folded as
[`banks/bank10.tbl.bin`](../banks/bank10.tbl.bin) /
[`banks/bank11.tbl.bin`](../banks/bank11.tbl.bin) /
[`banks/bank12.gfx.bin`](../banks/bank12.gfx.bin) (5120 bytes, 0xA000–0xB3FF)
plus disassembled code from 0xB400 and 77 × `0xFF` from 0xBFB3.
`MODULE bank10` / `bank11` / `bank12`.

- Bank 10: three parallel 60-word tables indexed by `(0xE242)-1`.
  `map_ptr` @ 0x6000 (`[0] == 0x6168`); entries 33.. continue into bank 11
  (`0x80B0`) and bank 12 (`0xA121`). `obj_ptr` @ 0x6078 and `obj2_ptr` @
  0x60F0 point into bank 12. Packed streams from 0x6168
  (`sub_43cbh` / `sub_4416h` / `sub_440ch`).
- Bank 11: stream continuation + tiles at 0x8030 (`l514ch` after this
  triplet is paged). Not code.
- Bank 12: data prefix, then code from 0xB400 (also reached via
  `page_bank_12`, which leaves 6000/8000 on the previous triplet).
  `DISPATCH_A` tables at 0xB42F / 0xB6BE / 0xB7A5 / 0xB98A (the last
  dispatches into bank 0 `sound_far` stubs at 0x41EA..). `ba92_tbl` @
  0xBA92 overlaps the preceding `ld a,(hl) / ret` (`7E C9`).

## Bank 13 (@ 0xA000)

Tables / text streams / tiles, not code. A000-only via `page_bank_13`.
Folded as [`banks/bank13.tbl.bin`](../banks/bank13.tbl.bin) (8182 bytes +
10 × `0xFF` from 0xBFF6), `MODULE bank13`.

Several 60/61-word tables indexed by `(0xE242)` (`0xA75D`, `0xAAE0`,
`0xADCF`–`0xAF37`, `0xAFB1`); `[0]` is often a sentinel (`0x00A0` /
`0xFFFF`). 8-byte flags @ 0xAB5A; `l51d0h` streams (e.g. 0xBC54);
`l514ch` tiles @ 0xBF36 / 0xBFC6. `ba57_tbl[0] == 0xBA61`.

## Banks 14–15 (@ 0x8000 / 0xA000)

Font + UI gfx, not code. Folded as
[`banks/bank14.gfx.bin`](../banks/bank14.gfx.bin) (full 8 KiB) /
[`banks/bank15.gfx.bin`](../banks/bank15.gfx.bin) (7627 bytes + 565 × `0xFF`
from 0xBDCB), `MODULE bank14` / `bank15`. `page_bank_15` exists but is never
called; 15 is only reached with 14 via `page_banks_14_15`.

- Bank 14: 114-word glyph index @ 0x8000 (`[0] == 0x80E4`). Printable runs
  are glyph bitmaps, not a string table (`sub_4e54h` / `sub_5029h` /
  `l5508h`).
- Bank 15: `l54a0h` at 0xB116 / 0xB120 (`[0] == 0xB118`); `l4f1ch` @
  0xA7CE; `l573bh` tiles @ 0xA2C8 / 0xA358 / 0xA702.
