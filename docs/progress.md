# KingsValley2 — progress

Scaffolded by MSXDAW (`konami-scc`, 16 banks). ROM is gitignored;
`make verify` matches `KingsValley2.sha1`.

- Probe: [`docs/probe.md`](probe.md).
- Mapper schedule from `page_triplet` is in [`docs/game-notes.md`](game-notes.md);
  `workbench.cfg` `bank_org` and master `PHASE` match it.
- Boot triplet (banks 1–3) is one window file [`banks/banks123.asm`](../banks/banks123.asm)
  (`PHASE 0x6000`, 24 KiB). `ld hl,0E2F3h` at 0x7FFE is a real instruction.
- Banks 0–15 are source (no leftover `INCBIN`).
- `DISPATCH_A` inline word tables in banks 0–3 are marked (`.blocks` + `defw`).
- Game Master option table at 0x4010 is data (`gm_opt`).
- Stream consumers in bank 0: `palette_list`, `print_stream`, `blit_list`,
  `copy_tiles`, `draw_tilemap` (local names). HUD strings at 0x5EF2–0x5F8D
  (`print_txt`) use `TEXT` / `CHAR` (`banks/text.inc`).
- Pointer / list tables folded as `defw`/`defb` in banks 7–10 and 13–15;
  packed streams and tile bitmaps stay `INCBIN`.
- Bank 7 second list at 0x6177 is `blit_ptr` (7-word pointer table; `blit_world`
  indexes it by world `(0xE241)` -> `blit_list`). Pointed-at records stay `INCBIN`.
- `print_stream` string islands in bank 12 bounded and marked `TEXT`
  (`lb8afh`, `lbe67h`/`lbe6eh`, `lbf0eh`, `lbf94h`; "esc key"/"skip"/"find"/
  "load error"/"save error"). Bank 13 legend + name lists are `TEXT`.
- `(0xE241)` is the **world** index = `ceil(level (0xE242)/10)`, range 1..6
  (`set_world` @ 0x5C80). World-gfx loaders named: `load_world_gfx` (0x5634),
  `blit_world` (0x5640, the `blit_ptr`/`e241_tbl` consumer), `blit_common`
  (0x5655). `blit_ptr`/`e241_tbl` live entries are [1..6]; [0] is a sentinel.
- Bank 12 `ba92_tbl` decoded as per-world (`sub_ba80h`, `(0xE241)`=1..6);
  `ba_lists` is now 6 per-world `defw` word tables `ba_w1..ba_w6` (each ends
  with a 0xFF00 word).
- Bank 12 `DISPATCH_A` tables annotated with their selectors: `disp_b42f`
  (state 0xEF11, 4), `disp_b6be` (5×5 sliding-puzzle UI, `ix+1`, 6 states),
  `disp_b7a5` (slide into empty cell, C=1..4), `disp_b98a` (`ix+2`, 19 ->
  bank-0 sound thunks).
- Bank 13 `print_stream` islands folded: `print_legend` (0xBC54),
  `print_names` (0xBCC1–0xBECF; enemies Slouman/Flouman/Pyoncy/Rock Roll;
  tools knife/boomerang/shovel/pick/hammer/drill; load/save/password).
- Gameplay vocabulary (Vic, gems / soul stone, exit door, pyramids, pick /
  jackhammer / drill, sword / knife, coffin / Slouman / Flouman, secret entrance)
  plus HUD type names is in [`docs/game-notes.md`](game-notes.md);
  60 pyramids × 6 worlds already match `(0xE242)` / `(0xE241)`.
- Actor types from editor enemy palette: 1 = coffin (Slouman E261 0 /
  Flouman E261 1). Tick is grab-only (`tick_coffin`); no walk/climb in
  ROM. `ix+8` is height (ROM 2–4, editor Flouman writes 1). 2 = Pyoncy
  (stationary grab), 3 = Rock Roll (triggered fall), 4 = trap (1×4),
  5 = stone (2×2). E500 tools
  1–4 = knife / boomerang / shovel / pick (only ids `spawn_tool` accepts
  from `0xB7CD`); hammer / drill live as E300 map tools (`afb1_tbl`,
  Vic states 12 / 13 via `use_tool`).
- Secret reveal named: `secret_hit` (0xBE15) / `secret_reveal` (0xBE2D) in
  bank 3; climb (`E280==2` / `vic_climb`) arms bit 5, jump strobe
  `(0xE2A7)` punches tiles.
- Vic `(0xE280)` named: `vic_tick` (0x9EC4) / `d_9ecd` 0–5 `vic_walk` /
  `vic_jump` / `vic_climb` / `vic_fall` / `vic_die` / `vic_hit`. Not in
  `msx.sym`. Pyoncy / Rock Roll ticks commented (`tick_pyoncy`,
  `start_rockroll` / `tick_rockroll`); type 4 is `tick_trap`.
- Map tools named: `load_map_tools` (0x97BB), `use_tool` (0xA045),
  `tick_map_tools` (0xA6BD). E600 type 1 tick is `tick_coffin` (0xBA85),
  not `d_a6f2` (knife states on E300). Draw tables at 0x64CF / 0x64D9
  folded (`defw`).
- Packed bank 13 lists folded (`GEM` / `ACTOR` / `TOOL` / `LINK` /
  `DELAYED` in `objects.inc`): gems, actors, tools, screen bits, door
  links, delayed pickups, Vic spawn, exit door + metatiles, `ba57_tbl`.
  Last records overlap the following pointer table. `bank13.tbl.bin` is
  575 bytes (was 2549): map bitmaps/RLE @ 0xBB3C and tiles @ 0xBECF.
- Generic split/graduation workflow: workbench skill `msx-code-data`.

## Next

1. Remaining payload bins (PSG / gfx / map streams, including bank 13
   tiles and `bb38` bitmaps) stay `INCBIN`. No mass-`defb`.

Do not invent further paging-window files. Later banks that share a CPU
window use `MODULE bankNN` so z80dasm labels do not collide.
