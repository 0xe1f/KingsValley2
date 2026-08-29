# KingsValley2 — notes

Mapper: **konami-scc** (RC761). 128 KiB = 16 × 8 KiB banks. SHA-1
`5ec8811254dc762c6852289a08acf22954404f0d`. See [`docs/probe.md`](probe.md).

Source split is one file per bank (`banks/bank00.asm`). No paging-window
files until this cart’s mapper schedule is known.

## Boot (bank 0 @ CPU 0x4000)

- MSX `AB` header; **init = 0x40A3** (`cart_init`).
- `cart_init` does not stay in the cart: it writes `RST 30h` / slot /
  `cart_boot` into **H.STKE** (`0xFEDA`) and `ret`s so BIOS continues, then
  the hook CALSLTs back to **0x40B5** (`cart_boot`).
- `cart_boot`: `im 1`, `ld sp,0xE000`, disable **H.KEYI** (`0xFD9A` ← `RET`),
  page banks 1/2/3 into 0x6000/0x8000/0xA000 (`ld (7000h/9000h/B000h),a`
  with A=1,2,3), then install **H.TIMI** as `JP htimi_isr` (`0x402E`).
- `htimi_isr` is a `DI` that z80dasm had glued onto a preceding `0xF6` as
  `or 0F3h`. The ISR body starts at 0x402F (`ld hl,0xE215` …).
- No `ld (5000h),a` anywhere in this dump, so page 4000–5FFF is likely never
  remapped. Still not treated as a VK-style fixed window.
- SCC enable `ld a,3Fh / ld (9000h),a` is in the ROM (file offset `0x8024`,
  bank 4) — not named yet.

## Stopped here

No ELG, rooms, or gameplay naming on day one.
