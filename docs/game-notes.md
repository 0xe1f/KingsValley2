# KingsValley2 — notes

Mapper: **konami-scc** (RC761). 128 KiB = 16 × 8 KiB banks. SHA-1
`5ec8811254dc762c6852289a08acf22954404f0d`. See [`docs/probe.md`](probe.md).

Source split is one window file per paging group (`banks_0`, `banks_123`,
`banks_456`, `banks_789`, `banks_abc`, `banks_d`, `banks_ef`), each with a
matching `banks_*.blocks`. Banks 1–3, 4–6, 7–9, and a–c are 24 KiB
`PHASE 0x6000` files; e–f is 16 KiB at `0x8000`.
[`banks/banks_0.asm`](../banks/banks_0.asm) stays separate (page 4000–5FFF is
never remapped). `ld hl,0E2F3h` at 0x7FFE is a real instruction.

## Gameplay

MSX2 *King's Valley II* (王家の谷II / *The Seal of El Giza*).
Puzzle-platformer: 60 pyramids (levels), grouped into 6 worlds
of 10. Already matches RAM: level `(0xE242)` is 1-based, world `(0xE241)` =
`ceil(level/10)` (`set_world`); bank 0A’s 60-word tables are one entry per
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
  Per-frame: `secret_hit` @ 0xBE15 (bank 03), from `play_tick`.
- HUD / editor names (bank 0D `print_stream`, `TEXT` in [`banks/text.inc`](../banks/text.inc)) — keep these when
  naming types, even if player-facing English differs:
  - Enemies: **Slouman**, **Flouman**, **Pyoncy**, **Rock Roll**.
  - Tools: **knife**, **boomerang**, **shovel** (HUD `scoop`), **pick**, **hammer**, **drill**.
  - Also: **soul stone** (gems), **exit door**, **trap**, **ladder**, **stone**,
    doors `door1`/`door2` with lr/rl variants.
  - A 5×5 sliding puzzle / password UI lives in bank 0C (`disp_b6be` /
    `disp_b7a5`).

### RAM / type ids

| Addr | Layout | Loader | Meaning |
|---|---|---|---|
| `0xE600` | 16 × 16 | `load_actors` (`aae0_tbl`) | Enemies. `ix+0` = type. Tick `d_64a1`. |
| `0xE300` | 64 × 8 | `load_map_tools` (`afb1_tbl`) | On-map tools. `ix+0` low nibble = type 1–6; high nibble = in-use state. Tick `tick_map_tools` / `d_a6dd`. |
| `0xE700` | 16 × 8 | `load_gems` (`a75d_tbl`) | Soul stones. All nonempty slots count in `(0xE2F5)`; door opens at 0. `ix+1` = screen `(0xE243)`. |
| `0xE7C0` | 16 × 4 | `load_obj2` (`obj2_ptr`) | Secret-entrance records (editor tool 7). `secret_hit` @ 0xBE15 / `secret_reveal` @ 0xBE2D. |
| `0xE500` | 8 × 32 | `spawn_tool` / in-play | Thrown / active tools. `ix+0` 1–5. `spawn_tool` rejects C ≥ 5. |
| `0xE287` | byte | `pickup_tool` | Currently held E300 type (0 = none). |

Vic `(0xE280)` is `d_9ecd` (no `dec a`), ticked by `vic_tick` @ 0x9EC4.

| E280 | Label | Meaning |
|---|---|---|
| 0 | `vic_walk` | Ground. Fire with no tool → `vic_begin_jump`; else `use_tool`. Coffin/Pyoncy grab only in this state. |
| 1 | `vic_jump` | Air. Gravity `(0xE292)` += 0x80 → Y; land → 0. |
| 2 | `vic_climb` | Ladder (map tile type 1). `secret_hit` arms bit 5. |
| 3 | `vic_fall` | Drop-in. Boot: `ld a,3 / ld (E280),a / jp 42F3`. Y+=4 until floor/`0xAD`. |
| 4 | `vic_die` | Death anim (D=10). `(0xE20C)` bit 4. |
| 5 | `vic_hit` | Shorter lock-anim (D=5). `vic_e500_overlap`: E500 `ix+13` bit 0. |
| 6 / 7 | `vic_pull_l` / `vic_pull_r` | Coffin / Pyoncy pull left / right. |
| 8 / 9 | `vic_throw` | Knife / boomerang windup (`use_throw`). |
| 10 | `vic_shovel` | Floor, 1 deep (`use_floor`). |
| 11 | `vic_pick` | Floor, 2 deep. |
| 12 | `vic_hammer` | Wall, 1 deep (`use_wall`). |
| 13 | `vic_drill` | Wall, 2 deep. |
| 14 | `vic_hold` | Hold; `vic_reset` if `(0xE202)` bit 6, else 0. Timer `(0xE2A8)`. |

Do not put these labels in `msx.sym` (bank 03 shares 0xA000 with banks 0D/0F).

Actor `ix+0` from continue-editor `put_trap` (`print_legend` 5, `names_terrain`
via `bcbb_tbl[1]`) / `editor_spawn`: E261 0–1 door1 → type 1 coffin, 2–3 door2
→ type 2 Pyoncy, 4 wall → 3 Rock Roll, 5 floor → 4 trap, 6 stone → 5 stone,
7 ladder → secret (`0xE7C0`). Live-checked in the continue editor (legend
**enemy** / Flouman → `E2C0` type 2 boomerang; **trap** door1 / door2 / wall /
floor / stone / ladder → E600 types 1–5 + `E7C0`). `put_enemy` (legend 4, `names_enemies`) writes
delayed pickups at `0xE2C0` (type = E261+1 = knife..pick), not E600. Both
coffin enemies share type 1; editor Flouman writes `ix+8=1` (Slouman 0),
but **ROM lists never store 0/1 there**. `ix+8` is height in tiles (`actor_hgt` @ 0x6445: 2, 1, 1, 4, 2).
Type 1 ROM heights are 2–4; type 4 is always 1; type 5 is always 2.
Type 1 is the only id that sets `ix+5` at spawn (`(byte3 & 7) * 3` = lid
frame). E600 type 1 tick is `tick_coffin` @ 0xBA85 (Vic push, states 6/7);
it does not walk or climb. `d_a6f2` is the **knife** in-use table on E300.
`probe_step` @ 0x9910 (walk/climb; `map_tile` @ 0x98E2) is Vic / E300-tool only — no E600 caller.

| Id | Name | Editor E261 (trap / names_terrain) | Manual / ROM |
|---|---|---|---|
| 1 | Slouman / Flouman | 0 / 1 door1 lr/rl | Stationary coffin; grab Vic (6/7). 75 in lists. Height 2–4; lo3 0/1 = facing. |
| 2 | Pyoncy | 2 / 3 door2 lr/rl | `tick_pyoncy`; grab 6/7 + 4-frame; no X/Y. 9 in lists. |
| 3 | Rock Roll | 4 wall | `start_rockroll` then `tick_rockroll`. 36 in lists. |
| 4 | trap | 5 floor | `tick_trap`; 1×4 tile column (`actor_hgt` 4, tile 0x61). 37 in lists (11 on pyramid 10). |
| 5 | stone | 6 stone | 2×2 pushable block (bifi trap; same family as Rock Roll at rest). 23 in lists. |
| 6 | — | — | no E600 list uses it |

Tool `0xE300` `ix+0` low nibble (`d_a6dd_jp`, 1-based). Packed lists in
`afb1_tbl` (indexed by level−1, `0xFF` term) place **all six** on the stock
60 pyramids (458 total: 123 knife, 43 boomerang, 39 shovel, 55 pick,
43 hammer on 21 pyramids, 155 drill on 42). Pickup (`pickup_tool` @ 0x9A93) copies the
low nibble to `(0xE287)` and ORs `0xF0` into the slot.

Fire (`e207` bit 4) with E287 set: `use_tool` @ 0xA045 scans E300 for high
nibble == 1, then `d_a072` on `(E287)−1`. Vic `(0xE280)` becomes
`(E287 & 0x0F) + 7` (`d_9ecd` states 8–13). Pairs: 1–2 throw (no map
check), 3–4 two floor tiles type 2, 5–6 two wall tiles type 2.

`0xE500` (`d_65fb_jp`) is the thrown/active copy. Delayed pickup table
(`0xB7CD` → `0xE2C0`) and `spawn_tool` @ 0xAC6D only ever create ids
**1–4**; C ≥ 5 is rejected. Hammer still has an E500 tick; drill does not.
Editor `put_tool` (legend 6, `names_tools`) writes E300 type = E261+1.
`put_enemy` (legend 4, `names_enemies`) writes the delayed E2C0 table
(type = E261+1 = knife..pick).

| Id | Name | E300 maps | E500 / Vic |
|---|---|---|---|
| 1 | knife | 123 | `tick_thrown_knife` 0xAD80; Vic 8 |
| 2 | boomerang | 43 | `tick_thrown_boom` 0xAE23 (returns); Vic 9 |
| 3 | shovel | 39 | `tick_thrown_shovel` 0xB2AA; Vic 10 |
| 4 | pick | 55 | `tick_thrown_pick` 0xB68E; Vic 11 |
| 5 | hammer | 43 | wall 1 deep; Vic 12; `tick_thrown_hammer` 0x662D unused in stock |
| 6 | drill | 155 | wall 2 deep; Vic 13; not an E500 id |

Type 4 pick is special-cased (`cp 004h`) vs Vic overlap.

Map: `unpack_map` expands `map_ptr` into `0xE900` (2-bit runs). `load_obj` ORs overlay bits from `obj_ptr` (doors/ladders/etc., not actor ids). Ending sparks reuse `0xE900`–`0xE902` / `0xE910` after play.

Use this vocabulary when naming actors, items, and HUD strings. Do not invent
ROM addresses for them until a consumer is traced.

## Boot (bank 00 @ CPU 0x4000)

- MSX `AB` header; **init = 0x40A3** (`cart_init`).
- Game Master relative option table at 0x4010 (`"CD"` / RC761 BCD `07 61`).
  Not code; `H.TIMI` is `JP 0x402E`.
- `cart_init` does not stay in the cart: it writes `RST 30h` / slot /
  `cart_boot` into **H.STKE** (`0xFEDA`) and `ret`s so BIOS continues, then
  the hook CALSLTs back to **0x40B5** (`cart_boot`).
- `cart_boot`: `im 1`, `ld sp,0xE000`, disable **H.KEYI** (`0xFD9A` ← `RET`),
  page banks 01/2/3 into 0x6000/0x8000/0xA000 (`page_triplet` with A=1), then
  install **H.TIMI** as `JP htimi_isr` (`0x402E`).
- `htimi_isr` is a `DI` that z80dasm had glued onto a preceding `0xF6` as
  `or 0F3h`. The ISR body starts at 0x402F (`ld hl,0xE215` …).
- No `ld (5000h),a` anywhere in this dump, so page 4000–5FFF is never remapped.
- Helpers: `ADD_HL_A` (0x408F), `ADD_DE_A` (0x4094), `DISPATCH_A` (0x4099).
  Every `call DISPATCH_A` in banks 00–03 now has its inline word table marked
  (`table[0]` == first handler after the table where that idiom holds;
  otherwise bound by the next real routine). Bank 01’s `d_735f` at 0x7362 is
  the 65-word **ending** script (`end_tick` / `end_boot`..`end_done`), not
  stage-clear. Some handlers
  live in the next bank of the triplet
  (0x7E6F → 0x8018) or in bank 00 (`sfx_01`..`sfx_84` stubs before `sound_far`).
- Stream consumers (bank 00): `palette_set` / `palette_list` (0x4EF2 / 0x4F1C),
  `print_stream` / `print_stream_blank` (0x51D0 / 0x51D4; `TEXT`/`CHAR` in
  [`banks/text.inc`](../banks/text.inc): space→00h, `'0'`..`'?'`→ch+A0h, else
  ch|80h; `0xFE` next pos, `0xFF` end), `print_at` (0x51DA, DE already set), `blit_list` (0x54A0; 5-byte records, tiles at 0x8000).
  VDP engine: `vdp_ce_wait` / `vdp_status`, `vdp_hmmv` (CMD 70h),
  `vdp_hmmv_hi`, `vdp_lmmv` (C0h), `vdp_hmmm` (D0h), `vdp_hmmc` (F0h),
  `vdp_box`. Title `title_ptr` / `print_ptr` blink game vs edit; `play_clear`
  zeros `E226` before the stage card.
  HUD strings at 0x5EF2–0x5F8D (`print_txt`) are that grammar, not code.
  `copy_tiles` (0x514C) copies B 8×8 tiles; `draw_tilemap` (0x573B) draws a
  B×C grid of tile ids.
- `keys_apply` (0x5434) stores A in `0xE208` (held) and the rising bits in
  `0xE207`. `keys_apply_at` (0x5437) does the same at HL (title uses E20D).
  Fire is E208 bit 4 (edge → jump). Bits 2–3 are walk L/R.
- `poll_keys` (0x541C) is `read_stick` (PSG R#15/14 + SNSMAT 4/8) then
  `read_keyrow` (SNSMAT 6/7). Boot VDP sprite regs at 0x5413 (R#1/5/6/11)
  were glued onto that poll; 0x541B is a `ret` (`poll_skip`) so mode 0
  substate 0 does not read the stick.
- Sound ids `sfx_01`..`sfx_41` and `sfx_80`..`sfx_84` (`SFX`/`SFXR` in
  [`banks/sfx.inc`](../banks/sfx.inc)) are 5-byte `jp` then 4-byte `jr`
  thunks onto `sound_far` (0x4326). `sfx_82`/`sfx_83` also write `(0xE21A)`.
  Boot `vic_fall` `jp`s `sfx_3c`.
- Game mode `(0xE200)` is `mode_tick` → `d_46ea` (14 states). Handlers:
  `mode_boot` (nested `d_470a`), `mode_hold`, `mode_attract`, `mode_title`
  (`d_47c2`: `title_jingle`..`title_go`; **edit** on the flash → continue
  editor (`mode_cont`); **game** → `file_menu` `E24B` 0 normal / 1 password /
  2 stage load). `mode_stage`, `mode_play`,
  `mode_life`, `mode_over`, `mode_room`, `mode_clear` (`clear_tick` / `clear_door`..`clear_done`),
  `mode_world` (`world_tick` / `world_scr`..`world_exit`; `wpic0`..`wpic2`),
  `mode_cont`
  (`cont_tick` / `cont_boot`..`cont_esc` on `E25A`; file I/O `io_tick` /
  `io_ask`..`io_list` on `E25B`; nested editor `edit_hud`..`edit_yn`),
  `mode_end`, `mode_endtxt`
  (`end_tick` / `d_735f`, 65 states). `(0xE201)` is the substate
  (`sub_next` / `mode_goto`). H.TIMI runs `poll_keys` then `mode_frame`.
  Play frames: `sat_flip` / `play_tick` / `sat_blit`. `play_tick` is Vic,
  tools, gems, actors, exit, secrets, then `tick_ef10` (bank 0C).
  `sat_wipe` (0x5D41) fills the software SAT at `0xE800` with Y=0xE0.
  Room change: `probe_edge` writes `E248` (1 L / 2 R / 3 U / 4 D);
  `mode_room` runs `room_exit` (wrap Vic, `room_link` via ED80..EDB0) then
  `room_draw` (includes `draw_ef10`). World load (`set_world`) runs
  `load_vic`, then `load_delayed` / `load_gems_far` / `load_exit` /
  `load_screens` / `load_links` / `screen_idx`, then `load_pyramid`
  (`unpack_map` + `load_map_obj`), then `load_actors_far` /
  `load_map_tools_far` / `e300_list` / `load_ef10`. `(0xE257)` is a
  **mode-local** script
  index — title/file `e257_jp` is 0-based (`pwd_wipe`..`pwd_done`;
  `pwd_txt` is `"pass word"`); stage-clear is `clear_door`..`clear_done`
  (1-based); world-complete is `world_scr`..`world_exit` (map tour then
  `wpic0`..`wpic2`); ending is `d_735f` (1-based). Do not treat the
  65-word table as one script for all modes.

## Mapper schedule (`page_triplet` @ 0x418D)

Write A / A+1 / A+2 to `7000` / `9000` / `B000` and mirror at
`mapper_bank_6000/8000/A000` (`0xF0F1–F0F3`). Wrappers:

| Helper | A | 6000 | 8000 | A000 |
|---|---|---|---|---|
| `page_banks_123` | 01 | 01 | 02 | 03 |
| `page_banks_456` | 04 | 04 | 05 | 06 |
| `page_banks_789` | 07 | 07 | 08 | 09 |
| `page_banks_abc` | 0A | 0A | 0B | 0C |
| `page_bank_c` / `_d` / `_f` | 0C / 0D / 0F | (keep) | (keep) | 0C / 0D / 0F |
| `page_banks_ef` | 0E | (keep) | 0E | 0F |

Temporary far calls (H.TIMI, sound stub `l4326h`, `sub_53b6h`) page 04/05/06,
`call 6000h` / `6003h` / `6006h`, then restore from `0xF0F1–F0F3`.

Bank 04 starts with `jp 6009h` / `jp 603dh` / `jp 62f8h` matching those three
entries. SCC enable `ld a,3Fh / ld (9000h),a` is in bank 04 (file offset
`0x8024`).

`workbench.cfg` `bank_org` matches this table. Scaffold `n%4` PHASE was
wrong from bank 04 onward.

## Banks 01–03 (boot triplet @ 0x6000 / 0x8000 / 0xA000)

One window file [`banks/banks_123.asm`](../banks/banks_123.asm) (`page_banks_123`,
`PHASE 0x6000` for 24 KiB).

- Bank 01 starts `call print_stream` (twice) / `call sat_wipe` into bank 00.
  `ld hl,0E2F3h` at 0x7FFE continues into bank 02; `jr z,l8016h` at 0x7FFC.
  `.blocks`: 32-byte copy at 0x6039, `DISPATCH_A` word tables (including
  `d_735f` @ 0x7362, ending ceremony, 65 words; `d_71e3` stage-clear
  `clear_door`..`clear_done`; `d_6f6b` world-complete `world_scr`..
  `world_exit`; `e257_jp` title/file continue anim
  `pwd_wipe`..`pwd_done`; `pwd_txt` @ 0x69FF). `print_world` @ 0x71A5
  (`world_txt`). `world_xy` / `world_xy2`
  / `world_len` / `clear_spr` are byte tables. Byte table at 0x68DD.
  `sat_fx` @ 0x77D7 / `sat_fx_tick` (`d_7835` on E881) is the bank 0E/0F
  SAT burst used by password, world-complete, and the ending ceremony.
  Ending `d_735f` (65, 1-based): `end_boot`..`end_clear`, then nine text
  pages `end_page`..`end_pclr` (last `end_done` waits fire). `end_next` /
  `end_delay` / `print_12` / `end_print_i` shared. `spark_far` @ 0x7703
  pages `spark_tick`; `pose_step` / `pose_tbl` / `pose_pat` / `cer_sat` /
  `cer_pair` stamp the 2×2 walk. `pal_blink_a` / `pal_blink_c` / `pal_black`
  are the ending palette helpers. Not in `msx.sym` (0x6000 window).
- Bank 02: `l8016h` is `or a / ret`. No opcode straddle into bank 03.
  `load_vic` @ 0x929D (spawn from `0xB844`); `vic_reset` @ 0x92CA;
  `e300_list` @ 0x921A (occupied slots → `0xEE50`). `tool_cc` /
  `tool_pat` feed `tools_sat`. `io_tick` @ 0x8B95 (`d_8b99` continue
  load/save) / `disk_tick` @ 0x8EDA (`d_8ede` title editor; `edit_boot`).
  Shared: `io_dev` / `io_name` / `io_pick` / `io_list`. Cursor SAT
  `io_dev_sat` / `io_yn_sat` / `io_pick_sat` (`sat_col`). `io_set_dev`
  (`F0F8`), `io_do_load` / `io_save`, `io_nofile`, `disk_err` (`0xF323` →
  `disk_print` / `disk_err_tbl`). Continue editor
  `cont_boot`..`cont_esc`; nested `edit_hud` / `edit_kind` / `edit_sub` /
  `edit_scr` / `edit_put` / `edit_yn` (`E260` = `print_legend`). `edit_put`
  `d_7e6c`: `put_floor1` / `put_floor2` / `put_ladder` / `put_player` /
  `put_enemy` (E2C0 delayed 1–4) / `put_trap` (E600 / secret) / `put_tool`
  (E300) / `put_gem` (E700) / `put_exit` (E2F1). `draw_minimap` @ 0x886A
  (A indexes bank 0D `bb38_tbl`). Not in `msx.sym` (0x8000
  window). `F0F8` is tape/disk/sram. `vic_tick` @ 0x9EC4 / `vic_walk` @ 0x9EEE /
  `vic_e500_overlap` @ 0x9AB1. `tick_stone` @ 0x93F3 (E600 type 5).
- Bank 03 starts `ld a,3 / ld (0xE280),a / jp sfx_3c` (`vic_fall`).
  `vic_begin_jump` @ 0xA008, `vic_jump` @ 0xA190, `vic_climb` @ 0xA20F,
  `vic_fall` @ 0xA2F0, `vic_die` @ 0xA315, `vic_hit` @ 0xA31C,
  `vic_pull_l` / `vic_pull_r` @ 0xA350 / 0xA36C, `vic_throw` @ 0xA384,
  `vic_shovel`..`vic_drill` @ 0xA405, `vic_hold` @ 0xA43C.
  Trailing 283 bytes of `0xFF` from 0xBEE5. `use_tool` @ 0xA045 /
  `tick_map_tools` @ 0xA6BD / `tick_map_knife`..`tick_map_drill` /
  `spawn_tool` @ 0xAC6D. E500 `tick_thrown_knife` @ 0xAD80. E300 tool `DISPATCH_A`
  tables often share first entry `0xA6FF`. `tick_coffin` @ 0xBA85 is E600
  type 1. `secret_hit` @ 0xBE15 (`secret_reveal` @ 0xBE2D); bank 00 calls
  `0xBE15` each frame.

## Bank 04 (@ 0x6000, triplet 04/05/06)

Folded to [`banks/banks_456.asm`](../banks/banks_456.asm) inside `MODULE banks_456`
(same CPU window as bank 01). Jump table:

| CPU | Name | Bank 00 caller |
|---|---|---|
| 0x6000 | `banks_456_init` → `sound_init` | `sub_53b6h` |
| 0x6003 | `sound_entry` → `sound_play` | `sound_far` (0x4326) |
| 0x6006 | `tick_entry` → `sound_tick` | `htimi_isr` |

`sound_play` copies 18 bytes from `sound_ptr[id*2]` (base 0x6F2C). Id 0
overlaps the preceding `ld (9000h),a / ret` (`90 C9`); first header is
`psg_01` @ 0x6FB0. Ids 1–0x41 are `psg_01`..`psg_41` (`sfx_01`..`sfx_41`);
`bgm_stage` uses ids 5–9. Packed header: `db flags, pri` then one `dw` per
SET bit (bit 7 first). Flags bits 7..0 → channel slots E000, E033, E066,
E099, E0CC, E0FF, E132, E165. Header length is `2 + 2×popcount(flags)`
(4 / 6 / 14 / 18); the 18-byte copy window may overlap the next header.
Channel ptrs continue into banks 05–06 (`ch_*` labels, same window).
Ids 0x80–0x84 are special-cased. SCC enable `ld a,3Fh / ld (9000h),a`;
opcode loads `wave_ptr` (0x7210, 72 words) and copies 32 bytes to
`9800` + n*0x20. Unique waves `wave_72a0`..`wave_7680`; many index slots
point at `env_0`. Envelope tables `env_0`..`env_5` (`sub_653dh`); channel
streams `ch_785e`..`ch_7fd7` then banks 05–06. This is not Vampire Killer’s
6-byte music-rec driver — do not point workbench `psgplay.py` at these
headers without adapting it.

## Banks 05–06 (@ 0x8000 / 0xA000)

Same window file as bank 04 ([`banks_456.asm`](../banks/banks_456.asm)).
Packed-PSG channel streams, not code. Source
[`psg05.asm`](../banks/data/psg05.asm) / [`psg06.asm`](../banks/data/psg06.asm)
(`ch_80a0`.. / `ch_a01f`.. through `ch_bd79`). `ch_7fd7` crosses 0x8000;
`ch_9ffa` crosses 0xA000. 591 × `0xFF` from 0xBDB1.

## Banks 07–09 (@ 0x6000 / 0x8000 / 0xA000)

Tables + dest planes + title tiles, not code. `MODULE banks_789`. Dest size is `count × 8 × (1+((flags&7)>>1))` (8 / 16 / 24 bytes
per tile). Even/odd `flags&7` pick unflipped / X-flipped expander.

- Bank 07: `idx6` / `pal_list` / `blit_recs` / `e241_tbl` / pal-index bytes
  (`pal_idx_60ad`) / `blit_ptr` / `blit_w1`..`blit_w6` are source.
  6-word palette index table at 0x6000 (`[0] == 0x600C`). Packed
  5-byte blit list at 0x602A (consumer `blit_list` after `page_banks_789`);
  last dest `pat_69d4` dest-hi + `0xFF` terminator overlap `e241_tbl[0]`
  (`0xFF69`). `blit_world` indexes via world `(0xE241)`. `blit_ptr` @ 0x6177
  is a 7-word pointer table (`[1] == blit_w1` == table end). Dest planes
  0x621C–0x8000 are [`dest07.asm`](../banks/data/dest07.asm) (`pat_621c`..;
  `pat_7fbc` continues into bank 08). One unreferenced hole `pat_651c` (80
  bytes). w2 `pat_74fc` overlaps w3 from `pat_77fc`. Dests in this window use
  `pat_*` labels.
- Bank 08: dests 0x8000–0x8FFC ([`dest08.asm`](../banks/data/dest08.asm),
  `pat_8000` tile base / tail of `pat_7fbc`) and 0x907F–0xA000
  ([`dest08b.asm`](../banks/data/dest08b.asm), `pat_907f` / `pat_9667` /
  `pat_982f` / `pat_9d27`). `pat_9667` overlaps `pat_982f` from 0x982F.
  `pal_idx` / `pal_9006`.. / `BLIT` lists `blit_902e`..`blit_9074` are
  source (`blit_9058` unreferenced). `pat_9d27` continues into bank 09.
- Bank 09: dests 0xA000–0xB7C7 / 0xB82B–0xBB8B
  ([`dest09.asm`](../banks/data/dest09.asm) / [`dest09b.asm`](../banks/data/dest09b.asm));
  `b7c7_idx` / `b7df_blit` / `bb8b_pal` / `stamp_bb9b` / title `copy_tiles`
  1bpp `title_bbdc` / `title_bc44` / `title_bcac` are source. 644 × `0xFF`
  from 0xBD7C is `ds`.

## Banks 0A–0C (@ 0x6000 / 0x8000 / 0xA000)

Map tables + streams + mixed gfx/code. 341 × `0xFF` pad 0xB2AB–0xB3FF, code
from 0xB400, and 77 × `0xFF` from 0xBFB3. `MODULE banks_abc`.

- Bank 0A: `map_ptr` / `obj_ptr` / `obj2_ptr` are source `defw`;
  `unpack_map` streams `map_01`..`map_33` are [`maps0A.asm`](../banks/data/maps0A.asm)
  (`MAP_RUN`). Three parallel 60-word tables indexed by `(0xE242)-1`.
  `map_ptr` @ 0x6000 (`[0] == map_01`); entries 34.. continue into bank 0B
  (`map_34` @ 0x80B0) and bank 0C (`map_60` @ 0xA121). `obj_ptr` @ 0x6078 is a packed **map-bit
  overlay** (`load_obj`). `obj2_ptr` @ 0x60F0 is secret-entrance records
  (`load_obj2` → `0xE7C0`). Packed streams from 0x6168
  (`unpack_map` / `load_obj` / `load_obj2`). `unpack_map` byte = `(tile<<6)|count`
  (count in bits 0–5, tile in 6–7; `0` ends). Dest `0xE900` packs four 2-bit
  cells/byte; pyramid size is 1/2/3/4/6 screens × 0xC0 bytes (768 tiles/screen).
- Bank 0B: `map_33` tail + `map_34`..`map_59` ([`maps0B.asm`](../banks/data/maps0B.asm)). Not code.
- Bank 0C: `map_59` tail + `map_60` through 0xA363 ([`maps0C.asm`](../banks/data/maps0C.asm)); `load_obj` / `load_obj2`
  overlays 0xA363–0xAA29 (`OVERLAY` in [`objects.inc`](../banks/objects.inc),
  [`banks/data/overlays.asm`](../banks/data/overlays.asm)); world-map
  `copy_tiles` font 0xAA29–0xAC01 ([`banks/data/wmap.asm`](../banks/data/wmap.asm)).
  `tiles_afdd` 1bpp (53 tiles, B=35h C=FBh), `file_pat` 1bpp (file_blit), and
  `ef10_spr` 16×16 HMMC are source ([`tiles0C.asm`](../banks/data/tiles0C.asm) /
  [`file_pat.asm`](../banks/data/file_pat.asm) /
  [`ef10_spr.asm`](../banks/data/ef10_spr.asm)).
  Then code from 0xB400 (also reached via
  `page_bank_c`, which leaves 6000/8000 on the previous triplet).
  `load_ef10` @ 0xB400 copies `ef10_tbl` for the current level into
  `0xEF10` (12 pyramids; type 1 sound-select / type 2 puzzle). `tick_ef10`
  @ 0xB422 / `disp_b42f` `ef10_land`..`ef10_enter` / `draw_ef10` @ 0xB51C /
  bank 00 `ef10_restore` @ 0x56C5 stamp or restore the 16×16. Jump onto the
  spot (Vic state 1), hold, restore, down → `mode_end`. `end_menu` @ 0xB534
  (`mode_end` E201=2) is `snd_sel` or `puzzle_ui`. `DISPATCH_A` tables at 0xB42F / 0xB6BE / 0xB7A5 / 0xB98A (the last
  dispatches into bank 00 `sound_far` stubs at 0x41EA..). `disp_b6be` is the
  5×5 sliding-puzzle / password UI (`ix+1` states: init, wait-space, load
  board, cursor+slide, solved, exit). `disp_b7a5` slides the current tile
  into the adjacent empty cell (C=1..4 → D−1 / D+1 / E−1 / E+1; `[3]`
  overlaps the first instruction after the table, not a no-op). Attract
  (`E200==2`): `demo_init` @ 0xBA11 picks the next pyramid from `demo_lvls`
  (`[1..6]` = 2, 18, 26, 40, 48, 53; `[0]` overlaps `jp 4388h`). `demo_tick`
  @ 0xBA66 feeds `ba_w1..ba_w6` through `keys_apply`. `ba92_tbl` @ 0xBA92
  is per-world (`demo_word`, world 1..6); `[0]==0xC97E` overlaps the
  preceding `ld a,(hl) / ret` (`7E C9`). Each `ba_wN` word is
  duration (lo → `0xE20A`) + held mask (hi → `0xE208`); terminator
  `0xFF00`. Bounds w1 0xBAA0, w2 0xBAD6, w3 0xBB14, w4 0xBB5A, w5 0xBBBA,
  w6 0xBC16. After `ba_w6` terminator: `spark_init` @ 0xBC6E (clears
  `0xE910`, sets `0xE900`), `spark_spawn` / `spark_tick` / `spark_move` /
  `spark_wipe` / `spark_sat` (32 × 16 slots; play map at `0xE900` is gone
  by `mode_end`). Far call is `spark_far` (numeric `0xBCD2` — `MODULE`).
  `print_stream` at 0xAC01–0xAF37 is source `TEXT`: password `str_pwd_best`,
  `world_txt` / `print_world` (five `defw`; world 6 index reads `str_w1` AT as
  ptr 0x9020 inside bank 0B map stream `0x8EA8`, not a TEXT island). Ending
  `str_end_boot`..`str_end_congrats`, credits `ad76_tbl`
  (I.Akada / K.Nagae / K.Uehara / … / presented by Konami). Ending font is
  stored letters +4. After that: `end_stamp_tbl` @ 0xAF37 (9 × X,Y,pat),
  `disk_err_tbl` @ 0xAF52 (`str_disk_io`..`str_datatype`; header `str_disk_err`),
  `str_start_sel` @ 0xB185 (normal / password / stage load), `str_clear_card`
  @ 0xB256, `str_secret_cmd` @ 0xB284. Later islands: 0xB8AF ("esc key"/"push space key"), 0xBE67
  ("skip")/0xBE6E ("find"), 0xBF0E ("load error"), 0xBF94 ("save error").
  Each `0xFF` terminator can fall mid-instruction, so re-sync the following
  code (one dropped byte) after bounding.

## Bank 0D (@ 0xA000)

Tables / text streams / tiles, not code. A000-only via `page_bank_d`.
`MODULE banks_d`. Packed lists live in [`banks/data/`](../banks/data/)
(`GEM` / `ACTOR` / `TOOL` / `LINK` / `DELAYED` in
[`banks/objects.inc`](../banks/objects.inc)): gems, actors, tools,
screen bits (`ab5a_flags`, 60 × 8 → `0xE788`), door links (`adcf`/`ae47`/
`aebf`/`af37` → ED80 up / ED90 down / EDA0 left / EDB0 right), delayed
pickups (`b7cd_tbl` → `0xE2C0`), Vic spawn (`0xB844` + level×3), exit door
(`0xB8F8` + level×3, packed `(screen<<5)|shape`), exit metatiles
(`b9ad_tbl`), world idx pairs (`ba57_tbl`). Last records overlap the next
pointer table the usual way. Minimap / RLE / SAT pattern ids / HUD glyphs
are source ([`minimap.asm`](../banks/data/minimap.asm),
[`hud_tiles.asm`](../banks/data/hud_tiles.asm)); 10 × `0xFF` from 0xBFF6.

Several 60/61-word tables indexed by `(0xE242)` (`0xA75D`, `0xAAE0`,
`0xADCF`–`0xAF37`, `0xAFB1`, `0xB7CD`); `[0]` is often a sentinel (`0x00A0` /
`0xFFFF` / `0x0050`). `afb1_tbl` is 60 words indexed by **level−1**.
`print_legend` @ 0xBC54. `bcbb_tbl` @ 0xBCBB is three `print_stream` pointers.
`print_names` 0xBCC1–0xBECF continues through load/save/password UI
  (`str_load_data` / `str_load_mode` / `str_input_name` / `str_loading`).
`copy_tiles` 18+6 glyphs @ 0xBF36 / 0xBFC6; `sat_pat` @ 0xBECF is an E500
pattern-id table (ix+11), not pixel planes. `bb38_tbl` is two 32×24 1bpp
minimaps (MSX1 vs MSX2). Konami RLE (`sub_4e54h`) @ 0xBBFC / 0xBF29.

## Banks 0E–0F (@ 0x8000 / 0xA000)

Font + UI gfx, not code. `MODULE banks_ef`. Trailing 565 × `0xFF`
from 0xBDCB is `ds`. `page_bank_f` exists but is never called; 0F is only
reached with 0E via `page_banks_ef`. Data labels
are module-local; bank 00 loaders (`pic_a358`, `wpic0`, `pal_15`, `hud_world`)
keep numeric immediates.

- Bank 0E: `glyph_ptr` is source `defw` (114 words, `[0] == glyphs`); payloads
  are [`glyphs0E.asm`](../banks/data/glyphs0E.asm) (`gly_80e4`..; last
  `gly_858a` is one `0xFF`). `sub_4638h` indexes 0x800C (6 worlds × 8 tile-id
  lists); `sub_4606h` indexes 0x806A (per-level 2-byte records, 1-based).
  `vic_reload` / `sub_58dbh` lists
  ([`held.asm`](../banks/data/held.asm)): `held_ptr` 7 words (`(0xE287)` =
  0 none, 1–6 tool) → `VIC_RLE` / `VIC_COPY` streams; `vic_hmm` / `vic_hmm2`
  14 `vdp_hmmm` dests (`(0xE285)*2`). Packed RLE 0x86D4–0x98C9 is source
  ([`rle0E.asm`](../banks/data/rle0E.asm)) plus copy lists / `draw_cols`
  ([`lists0E.asm`](../banks/data/lists0E.asm),
  [`cols0E.asm`](../banks/data/cols0E.asm)): `rle_86d4`..`rle_97a1`;
  `pat_copy` (`l5508h`) / `pat_flip` (`l553dh`); `end_txt` `"music stage"` /
  `"puzzle stage"`; `col_ptr` 48 words, 27-row columns (`col_21` crosses
  into bank 0F).
- Bank 0F source: `draw_cols` tail
  ([`cols0F.asm`](../banks/data/cols0F.asm) 0xA000–0xA2C8);
  tile-id grids + `STAMP` streams
  ([`ui_maps.asm`](../banks/data/ui_maps.asm) 0xA2C8–0xA792);
  Konami RLE ([`rle0F.asm`](../banks/data/rle0F.asm) 0xA9F6–0xB116);
  `idx2` / `pal_list` / `blit_recs` / dest planes
  ([`dest0F.asm`](../banks/data/dest0F.asm) `pat_b12b` 64×24 / `pat_b72b` 18×24);
  stamp + `pal_hud` / `pal_w_even` /
  `pal_w_odd` (overlap sentinels like `e241_tbl`) + RLE `ba9a` + `pat_bb05`
  + `pic_bc05` + `hud_world_tbl`
  ([`ui_tail.asm`](../banks/data/ui_tail.asm) 0xB8DB–0xBDCB);
  `palette_list` streams `pal_a7ce` / `pal_a7ff` / `pal_a870` / `pal_a8bb`.
  `sat_fx` scripts (`sat_fx_tbl` / `SATFX`) and 16×GRB morph pals (`fx_a830`..)
  live in [`sat_fx.asm`](../banks/data/sat_fx.asm) /
  [`sat_pals1.asm`](../banks/data/sat_pals1.asm) /
  [`sat_pals2.asm`](../banks/data/sat_pals2.asm).
