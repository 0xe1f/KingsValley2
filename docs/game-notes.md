# KingsValley2 — notes

Mapper: **konami-scc** (RC761). 128 KiB = 16 × 8 KiB banks. SHA-1
`5ec8811254dc762c6852289a08acf22954404f0d`. See [`docs/probe.md`](probe.md).

Source split is one file per 8 KiB bank, except the boot triplet: banks 1–3
are [`banks/banks123.asm`](../banks/banks123.asm) (CPU 0x6000–0xBFFF, one
`PHASE`). `ld hl,0E2F3h` at 0x7FFE is a real instruction. Bank 0 stays
separate (page 4000–5FFF is never remapped).

## Gameplay

MSX2 *King's Valley II* (王家の谷II / *The Seal of El Giza*), not *The Maze
of Galious*. Puzzle-platformer: 60 pyramids (levels), grouped into 6 worlds
of 10. Already matches RAM: level `(0xE242)` is 1-based, world `(0xE241)` =
`ceil(level/10)` (`set_world`); bank 10’s 60-word tables are one entry per
pyramid.

- Player is **Vic**. Goal per pyramid: collect every **gem**, then enter the
  **exit door** to advance.
- Tools: **picks** / **shovels** break ground vertically; **hammers** /
  **drills** (jackhammers) break walls horizontally. **Knives** / **boomerangs**
  can be picked up and thrown. Ground tools live in `0xE300`; thrown knife /
  boomerang / shovel / pick also use `0xE500`.
- Early enemies are **Slouman** and **Flouman** (editor names for the
  **coffin** / sarcophagus, type 1). Vic push toward it plays states 6/7;
  contact with the grab kills. The tick never writes X/Y and never calls
  the walk/climb probe — no wander/climb split in ROM. Editor Flouman is
  `ix+8=1` (height); ROM type 1 heights are 2–4. Packed lo3 sets facing
  (`ix+7` bit 1) and the initial lid frame.
- **Pyoncy** (type 2) is a stationary grab plus a 4-frame anim — the tick
  does not bounce or chase (`tick_pyoncy` @ 0xBBB0). Same Vic 6/7 pull as
  the coffin when Vic walks into it. **Rock Roll** (type 3) idles until
  Vic is under the column (`start_rockroll` @ 0xBC74), then `tick_rockroll`
  @ 0xBCC0 grows the fall to `ix+8` and clears the type. **Stone** (type 5)
  is the pushable 2×2. Type 4 (`tick_trap` @ 0xBD21) is a 1×4 tile-column
  trap.
- Some pyramids have **secret entrances**. On a ladder (Vic state
  `(0xE280)==2` / `vic_climb` arms bit 5), then jump (`(0xE2A7)` strobe)
  to reveal.
  Per-frame: `secret_hit` @ 0xBE15 (bank 3), `call 0be15h` from bank 0.
- HUD / editor names (bank 13 `print_stream`, `TEXT` in [`banks/text.inc`](../banks/text.inc)) — keep these when
  naming types, even if player-facing English differs:
  - Enemies: **Slouman**, **Flouman**, **Pyoncy**, **Rock Roll**.
  - Tools: **knife**, **boomerang**, **shovel** (HUD `scoop`), **pick**, **hammer**, **drill**.
  - Also: **soul stone** (gems), **exit door**, **trap**, **ladder**, **stone**,
    doors `door1`/`door2` with lr/rl variants.
  - A 5×5 sliding puzzle / password UI lives in bank 12 (`disp_b6be` /
    `disp_b7a5`).

### RAM / type ids

| Addr | Layout | Loader | Meaning |
|---|---|---|---|
| `0xE600` | 16 × 16 | `load_actors` (`aae0_tbl`) | Enemies. `ix+0` = type. Tick `d_64a1`. |
| `0xE300` | 64 × 8 | `load_map_tools` (`afb1_tbl`) | On-map tools. `ix+0` low nibble = type 1–6; high nibble = in-use state. Tick `tick_map_tools` / `d_a6dd`. |
| `0xE700` | 16 × 8 | `load_gems` (`a75d_tbl`) | Soul stones. All nonempty slots count in `(0xE2F5)`; door opens at 0. `ix+1` = screen `(0xE243)`. |
| `0xE7C0` | 16 × 4 | `load_obj2` (`obj2_ptr`) | Secret-entrance records (editor tool 7). `secret_hit` @ 0xBE15 / `secret_reveal` @ 0xBE2D. |
| `0xE500` | 8 × 32 | `spawn_tool` / in-play | Thrown / active tools. `ix+0` 1–5. `spawn_tool` rejects C ≥ 5. |
| `0xE287` | byte | pickup `l9a93h` | Currently held E300 type (0 = none). |

Vic `(0xE280)` is `d_9ecd` (no `dec a`), ticked by `vic_tick` @ 0x9EC4.

| E280 | Label | Meaning |
|---|---|---|
| 0 | `vic_walk` | Ground. Fire with no tool → `vic_begin_jump`; else `use_tool`. Coffin/Pyoncy grab only in this state. |
| 1 | `vic_jump` | Air. Gravity `(0xE292)` += 0x80 → Y; land → 0. |
| 2 | `vic_climb` | Ladder (map tile type 1). `secret_hit` arms bit 5. |
| 3 | `vic_fall` | Drop-in. Boot: `ld a,3 / ld (E280),a / jp 42F3`. Y+=4 until floor/`0xAD`. |
| 4 | `vic_die` | Death anim (D=10). `(0xE20C)` bit 4. |
| 5 | `vic_hit` | Shorter lock-anim (D=5). `vic_e500_overlap`: E500 `ix+13` bit 0. |
| 6 / 7 | | Coffin / Pyoncy pull left / right. |
| 8–13 | | Knife … drill via `use_tool`. |
| 14 | | Hold; `sub_92cah` if `(0xE202)` bit 6, else 0. Timer `(0xE2A8)`. |

Do not put these labels in `msx.sym` (bank 3 shares 0xA000 with banks 13/15).

Actor `ix+0` from editor enemy palette (`bcbb_tbl[0]`, E261 0–3 = Slouman,
Flouman, Pyoncy, Rock Roll) via `l81e9h`. Both coffin enemies share type 1;
editor Flouman writes `ix+8=1` (Slouman 0), but **ROM lists never store 0/1
there**. `ix+8` is height in tiles (`actor_hgt` @ 0x6445: 2, 1, 1, 4, 2).
Type 1 ROM heights are 2–4; type 4 is always 1; type 5 is always 2.
Type 1 is the only id that sets `ix+5` at spawn (`(byte3 & 7) * 3` = lid
frame). E600 type 1 tick is `tick_coffin` @ 0xBA85 (Vic push, states 6/7);
it does not walk or climb. `d_a6f2` is the **knife** in-use table on E300.
`09910h` (walk/climb probe) is Vic / E300-tool only — no E600 caller.

| Id | Name | Editor E261 | Manual / ROM |
|---|---|---|---|
| 1 | Slouman / Flouman | 0 / 1 | Stationary coffin; grab Vic (6/7). 75 in lists. Height 2–4; lo3 0/1 = facing. |
| 2 | Pyoncy | 2 | `tick_pyoncy`; grab 6/7 + 4-frame; no X/Y. 9 in lists. |
| 3 | Rock Roll | 3 | `start_rockroll` then `tick_rockroll`. 36 in lists. |
| 4 | trap | — | `tick_trap`; 1×4 tile column (`actor_hgt` 4, tile 0x61). 37 in lists (11 on pyramid 10). |
| 5 | stone | — | 2×2 pushable block (bifi trap; same family as Rock Roll at rest). 23 in lists. |
| 6 | — | — | no E600 list uses it |

Tool `0xE300` `ix+0` low nibble (`d_a6dd_jp`, 1-based). Packed lists in
`afb1_tbl` (indexed by level−1, `0xFF` term) place **all six** on the stock
60 pyramids (458 total: 123 knife, 43 boomerang, 39 shovel, 55 pick,
43 hammer on 21 pyramids, 155 drill on 42). Pickup (`l9a93h`) copies the
low nibble to `(0xE287)` and ORs `0xF0` into the slot.

Fire (`e207` bit 4) with E287 set: `use_tool` @ 0xA045 scans E300 for high
nibble == 1, then `d_a072` on `(E287)−1`. Vic `(0xE280)` becomes
`(E287 & 0x0F) + 7` (`d_9ecd` states 8–13). Pairs: 1–2 throw (no map
check), 3–4 two floor tiles type 2, 5–6 two wall tiles type 2.

`0xE500` (`d_65fb_jp`) is the thrown/active copy. Delayed pickup table
(`0xB7CD` → `0xE2C0`) and `spawn_tool` @ 0xAC6D only ever create ids
**1–4**; C ≥ 5 is rejected. Hammer still has an E500 tick; drill does not.
Editor tool-weapon palette E261 0–5 writes E300 type = E261+1.

| Id | Name | E300 maps | E500 / Vic |
|---|---|---|---|
| 1 | knife | 123 | thrown 0xAD80; Vic 8 |
| 2 | boomerang | 43 | thrown 0xAE23 (returns); Vic 9 |
| 3 | shovel | 39 | floor 1 deep 0xB2AA; Vic 10 |
| 4 | pick | 55 | floor 2 deep 0xB68E; Vic 11 |
| 5 | hammer | 43 | wall 1 deep; Vic 12; E500 tick 0x662D unused in stock |
| 6 | drill | 155 | wall 2 deep; Vic 13; not an E500 id |

Type 4 pick is special-cased (`cp 004h`) vs Vic overlap.

Map: `unpack_map` expands `map_ptr` into `0xE900` (2-bit runs). `load_obj` ORs overlay bits from `obj_ptr` (doors/ladders/etc., not actor ids).

Use this vocabulary when naming actors, items, and HUD strings. Do not invent
ROM addresses for them until a consumer is traced.

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
- Stream consumers (bank 0): `palette_set` / `palette_list` (0x4EF2 / 0x4F1C),
  `print_stream` / `print_stream_blank` (0x51D0 / 0x51D4; `TEXT`/`CHAR` in
  [`banks/text.inc`](../banks/text.inc): space→00h, `'0'`..`'?'`→ch+A0h, else
  ch|80h; `0xFE` next pos, `0xFF` end), `blit_list` (0x54A0; 5-byte records, tiles at 0x8000).
  HUD strings at 0x5EF2–0x5F8D (`print_txt`) are that grammar, not code.
  `copy_tiles` (0x514C) copies B 8×8 tiles; `draw_tilemap` (0x573B) draws a
  B×C grid of tile ids.

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

## Banks 1–3 (boot triplet @ 0x6000 / 0x8000 / 0xA000)

One window file [`banks/banks123.asm`](../banks/banks123.asm) (`page_banks_123`,
`PHASE 0x6000` for 24 KiB).

- Bank 1 starts `call print_stream` (twice) / `call 5D41h` into bank 0.
  `ld hl,0E2F3h` at 0x7FFE continues into bank 2; `jr z,l8016h` at 0x7FFC.
  `.blocks`: 32-byte copy at 0x6039, `DISPATCH_A` word tables (including the
  65-word table at 0x7362), byte table at 0x68DD.
- Bank 2: `l8016h` is `or a / ret`. No opcode straddle into bank 3.
  `vic_tick` @ 0x9EC4 / `vic_walk` @ 0x9EEE / `vic_e500_overlap` @ 0x9AB1.
- Bank 3 starts `ld a,3 / ld (0xE280),a / jp 0x42F3` (`vic_fall`).
  `vic_begin_jump` @ 0xA008, `vic_jump` @ 0xA190, `vic_climb` @ 0xA20F,
  `vic_fall` @ 0xA2F0, `vic_die` @ 0xA315, `vic_hit` @ 0xA31C.
  Trailing 283 bytes of `0xFF` from 0xBEE5. `use_tool` @ 0xA045 /
  `tick_map_tools` @ 0xA6BD / `spawn_tool` @ 0xAC6D. E300 tool `DISPATCH_A`
  tables often share first entry `0xA6FF`. `tick_coffin` @ 0xBA85 is E600
  type 1. `secret_hit` @ 0xBE15 (`secret_reveal` @ 0xBE2D); bank 0 calls
  `0xBE15` each frame.

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
[`banks/bank07.tbl.bin`](../banks/bank07.tbl.bin) (payload after 0x60AD) /
[`banks/bank08.gfx.bin`](../banks/bank08.gfx.bin) (full 8 KiB) /
[`banks/bank09.gfx.bin`](../banks/bank09.gfx.bin) (7548 bytes + 644 × `0xFF`
from 0xBD7C), `MODULE bank07` / `bank08` / `bank09`.

- Bank 7: `idx6` / `pal_list` / `blit_recs` / `e241_tbl` are source `defw`/`defb`;
  packed lists after 0x60AD stay in [`bank07.tbl.bin`](../banks/bank07.tbl.bin).
  6-word palette index table at 0x6000 (`[0] == 0x600C`). Packed
  5-byte blit list at 0x602A (consumer `blit_list` after `page_banks_789`);
  `0xFF` terminator overlaps `e241_tbl[0]` at 0x6065 (`blit_world` indexes
  via world `(0xE241)`). `blit_ptr` @ 0x6177 is a 7-word pointer table
  (`[1] == 0x6185` == table end); `blit_world` reads `blit_ptr[world]` ->
  `blit_list` while `e241_tbl[world]` supplies the palette-index source.
  Records after 0x6185 stay `INCBIN`.
- Bank 8: tileset 0x8000–0x8FFC stays `INCBIN`; `pal_idx` / `pal_list` /
  packed blit lists at 0x902E are source. `blit_list` tile base is 0x8000.
- Bank 9: SCREEN 2-style pattern/color head; `b7c7_idx` / `b7df_blit` and
  `bb8b_pal` (`palette_list`) are source.

## Banks 10–12 (@ 0x6000 / 0x8000 / 0xA000)

Map tables + streams + mixed gfx/code. Folded as
[`banks/bank10.tbl.bin`](../banks/bank10.tbl.bin) (streams after 0x6168) /
[`banks/bank11.tbl.bin`](../banks/bank11.tbl.bin) /
[`banks/bank12.gfx.bin`](../banks/bank12.gfx.bin) (5120 bytes, 0xA000–0xB3FF)
plus disassembled code from 0xB400 and 77 × `0xFF` from 0xBFB3.
`MODULE bank10` / `bank11` / `bank12`.

- Bank 10: `map_ptr` / `obj_ptr` / `obj2_ptr` are source `defw`; streams from
  0x6168 stay in [`bank10.tbl.bin`](../banks/bank10.tbl.bin).
  Three parallel 60-word tables indexed by `(0xE242)-1`.
  `map_ptr` @ 0x6000 (`[0] == 0x6168`); entries 33.. continue into bank 11
  (`0x80B0`) and bank 12 (`0xA121`). `obj_ptr` @ 0x6078 is a packed **map-bit
  overlay** (`load_obj`). `obj2_ptr` @ 0x60F0 is secret-entrance records
  (`load_obj2` → `0xE7C0`). Packed streams from 0x6168
  (`unpack_map` / `load_obj` / `load_obj2`).
- Bank 11: stream continuation + tiles at 0x8030 (`copy_tiles` after this
  triplet is paged). Not code.
- Bank 12: data prefix, then code from 0xB400 (also reached via
  `page_bank_12`, which leaves 6000/8000 on the previous triplet).
  `DISPATCH_A` tables at 0xB42F / 0xB6BE / 0xB7A5 / 0xB98A (the last
  dispatches into bank 0 `sound_far` stubs at 0x41EA..). `disp_b6be` is the
  5×5 sliding-puzzle / password UI (`ix+1` states: init, wait-space, load
  board, cursor+slide, solved, exit). `disp_b7a5` slides the current tile
  into the adjacent empty cell (C=1..4 → D−1 / D+1 / E−1 / E+1; `[3]`
  overlaps the first instruction after the table, not a no-op). `ba92_tbl` @
  0xBA92 is per-world (`ba92_tbl[world]` -> a word sub-table in `ba_lists`,
  read by `sub_ba80h` indexed by `(0xE241)`=1..6); `[0]==0xC97E` overlaps the
  preceding `ld a,(hl) / ret` (`7E C9`) so the routine falls through into it.
  `ba_lists` (0xBAA0–0xBC6E) is 6 per-world word tables (bounds w1 0xBAA0,
  w2 0xBAD6, w3 0xBB14, w4 0xBB5A, w5 0xBBBA, w6 0xBC16). `print_stream`
  string islands are `defb`: 0xB8AF ("esc key"/"push space key"), 0xBE67
  ("skip")/0xBE6E ("find"), 0xBF0E ("load error"), 0xBF94 ("save error").
  Each `0xFF` terminator can fall mid-instruction, so re-sync the following
  code (one dropped byte) after bounding.

## Bank 13 (@ 0xA000)

Tables / text streams / tiles, not code. A000-only via `page_bank_13`.
`MODULE bank13`. Packed lists are source (`GEM` / `ACTOR` / `TOOL` / `LINK` /
`DELAYED` in [`banks/objects.inc`](../banks/objects.inc)): gems, actors, tools,
screen bits (`ab5a_flags`, 60 × 8 → `0xE788`), door links (`adcf`/`ae47`/
`aebf`/`af37` → ED80 up / ED90 down / EDA0 left / EDB0 right), delayed
pickups (`b7cd_tbl` → `0xE2C0`), Vic spawn (`0xB844` + level×3), exit door
(`0xB8F8` + level×3, packed `(screen<<5)|shape`), exit metatiles
(`b9ad_tbl`), world idx pairs (`ba57_tbl`). Last records overlap the next
pointer table the usual way. [`bank13.tbl.bin`](../banks/bank13.tbl.bin) is
575 bytes (map bitmaps + RLE @ 0xBB3C, tiles @ 0xBECF); 10 × `0xFF` from
0xBFF6.

Several 60/61-word tables indexed by `(0xE242)` (`0xA75D`, `0xAAE0`,
`0xADCF`–`0xAF37`, `0xAFB1`, `0xB7CD`); `[0]` is often a sentinel (`0x00A0` /
`0xFFFF` / `0x0050`). `afb1_tbl` is 60 words indexed by **level−1**.
`print_legend` @ 0xBC54. `bcbb_tbl` @ 0xBCBB is three `print_stream` pointers.
`print_names` 0xBCC1–0xBECF continues through load/save/password UI.
`copy_tiles` 18+6 glyphs @ 0xBF36 / 0xBFC6; SAT patterns indexed from 0xBECF.
`bb38_tbl` is two 96-byte map bitmaps (MSX1 vs MSX2). `04e54h` streams @
0xBBFC / 0xBF29.

## Banks 14–15 (@ 0x8000 / 0xA000)

Font + UI gfx, not code. Folded as
[`banks/bank14.gfx.bin`](../banks/bank14.gfx.bin) (glyphs after 0x80E4) /
[`banks/bank15.gfx.bin`](../banks/bank15.gfx.bin) (7627 bytes + 565 × `0xFF`
from 0xBDCB), `MODULE bank14` / `bank15`. `page_bank_15` exists but is never
called; 15 is only reached with 14 via `page_banks_14_15`.

- Bank 14: `glyph_ptr` is source `defw` (114 words, `[0] == 0x80E4`); glyph
  bitmaps stay in [`bank14.gfx.bin`](../banks/bank14.gfx.bin). Printable runs
  are glyph bitmaps, not a string table (`sub_4e54h` / `sub_5029h` /
  `l5508h`).
- Bank 15: `idx2` / `pal_list` / `blit_recs` at 0xB116 (`[0] == 0xB118`);
  `palette_list` streams `pal_a7ce` / `pal_a7ff` / `pal_a8bb`; `draw_tilemap`
  tiles @ 0xA2C8 / 0xA358 / 0xA702.
