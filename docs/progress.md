# KingsValley2 — progress

Scaffolded by MSXDAW (`konami-scc`, 16 banks). ROM is gitignored;
`make verify` matches `KingsValley2.sha1`.

- Probe: [`docs/probe.md`](probe.md).
- Mapper schedule from `page_triplet` is in [`docs/game-notes.md`](game-notes.md);
  `workbench.cfg` `bank_org` and master `PHASE` match it.
- Shared CPU windows are one file each: [`banks_0.asm`](../banks/banks_0.asm),
  [`banks_123.asm`](../banks/banks_123.asm), [`banks_456.asm`](../banks/banks_456.asm),
  [`banks_789.asm`](../banks/banks_789.asm), [`banks_abc.asm`](../banks/banks_abc.asm),
  [`banks_d.asm`](../banks/banks_d.asm), [`banks_ef.asm`](../banks/banks_ef.asm),
  each with a matching `banks_*.blocks`. Later windows use `MODULE` so
  z80dasm labels do not collide with banks 1–3.
- Banks 00–0F are source (no leftover `INCBIN`).
- `DISPATCH_A` inline word tables in banks 00–03 are marked (`.blocks` + `defw`).
- Game Master option table at 0x4010 is data (`gm_opt`).
- Stream consumers in bank 00: `palette_list`, `print_stream`, `blit_list`,
  `copy_tiles`, `draw_tilemap` (local names). HUD strings at 0x5EF2–0x5F8D
  (`print_txt`) use `TEXT` / `CHAR` (`banks/text.inc`).
- Pointer / list tables folded as `defw`/`defb` in banks 07–0A and 0D–0F.
  `unpack_map` streams are source (`maps0A.asm` / `maps0B.asm` / `maps0C.asm`).
  Packed-PSG is source (`psg_hdr.asm` /
  `psg_wave.asm` / `psg_env.asm` / `psg04.asm` / `psg05.asm` / `psg06.asm`).
  Bank 07–9 dest planes / title `copy_tiles` are source (`dest07.asm` /
  `dest08.asm` / `dest08b.asm` / `dest09.asm` / `dest09b.asm` / `title_tiles.asm`).
  Bank 0E held-tool lists /
  RLE / `l5508h` lists / `draw_cols` are source (`held.asm`, `rle0E.asm`,
  `lists0E.asm`, `cols0E.asm`); glyph payloads are source (`glyphs0E.asm`).
  Bank 0F tilemaps / stamps / RLE / `pal_15` /
  `hud_world` / `draw_cols` tail / `sat_fx` pals / dest planes are source
  (`ui_maps.asm`, `rle0F.asm`, `ui_tail.asm`, `cols0F.asm`, `sat_fx.asm`,
  `dest0F.asm`).
- Bank 07 second list at 0x6177 is `blit_ptr` (7-word pointer table; `blit_world`
  indexes it by world `(0xE241)` -> `blit_list`). `blit_w1`..`blit_w6` and
  pal-index bytes at 0x60AD are source; dest planes from 0x621C are
  `dest07.asm` (hole `pat_651c`; last blit_recs dest `pat_69d4`). Bank 08/9
  dests are `dest08.asm` / `dest08b.asm` / `dest09.asm` / `dest09b.asm`; title
  `stamp_bb9b` / `title_bbdc`.. are source. Bank 0F dests `pat_b12b` /
  `pat_b72b` are Japanese title glyphs ([`dest0F.asm`](../banks/data/dest0F.asm),
  `title_jp` / `title_jp_gfx`).
- `print_stream` string islands in bank 0C: password / per-world / ending
  credits at 0xAC01–0xAF37 are `TEXT` (`str_pwd_best`, `world_txt`,
  `ad76_tbl`); `end_stamp_tbl` / disk errors / `str_start_sel` /
  `str_clear_card` / `str_secret_cmd` follow. Later UI islands (`lb8afh`,
  `lbe67h`/`lbe6eh`, `lbf0eh`, `lbf94h`; "esc key"/"skip"/"find"/"load error"/"save error"). Bank 0D
  legend + name lists are `TEXT`.
- `(0xE241)` is the **world** index = `ceil(level (0xE242)/10)`, range 1..6
  (`set_world` @ 0x5C80). World-gfx loaders named: `load_world_gfx` (0x5634),
  `blit_world` (0x5640, the `blit_ptr`/`e241_tbl` consumer), `blit_common`
  (0x5655). `blit_ptr`/`e241_tbl` live entries are [1..6]; [0] is a sentinel.
- Bank 0C `ba92_tbl` decoded as per-world attract scripts (`demo_word`,
  `(0xE241)`=1..6); `ba_w1..ba_w6` are duration+key-mask words (each ends
  with a 0xFF00 word).
- Bank 0C `DISPATCH_A` tables annotated with their selectors: `disp_b42f`
  (state 0xEF11, 4), `disp_b6be` (5×5 sliding-puzzle UI, `ix+1`, 6 states),
  `disp_b7a5` (slide into empty cell, C=1..4), `disp_b98a` (`ix+2`, 19 ->
  bank-0 sound thunks).
- Bank 0D `print_stream` islands folded: `print_legend` (0xBC54),
  `print_names` (0xBCC1–0xBECF; enemies Slouman/Flouman/Pyoncy/Rock Roll;
  tools knife/boomerang/shovel/pick/hammer/drill; load/save/password).
- Gameplay vocabulary (Vic, gems / soul stone, exit door, pyramids, pick /
  jackhammer / drill, sword / knife, coffin / Slouman / Flouman, secret entrance)
  plus HUD type names is in [`docs/game-notes.md`](game-notes.md);
  60 pyramids × 6 worlds already match `(0xE242)` / `(0xE241)`.
- Actor types from editor `put_trap` (`names_terrain`): 1 = coffin (E261
  0/1 door1), 2 = Pyoncy (2/3 door2), 3 = Rock Roll (4 wall), 4 = trap
  (5 floor), 5 = stone (6 stone). Tick is grab-only (`tick_coffin`); no
  walk/climb in ROM. `ix+8` is height (ROM 2–4, editor door1 rl writes 1).
  `put_enemy` writes E2C0 delayed 1–4 (HUD `names_enemies`). E500 tools
  1–4 = knife / boomerang / shovel / pick (only ids `spawn_tool` accepts
  from `0xB7CD`); hammer / drill live as E300 map tools (`afb1_tbl`,
  Vic states 12 / 13 via `use_tool`).
- Secret reveal named: `secret_hit` (0xBE15) / `secret_reveal` (0xBE2D) in
  bank 03; climb (`E280==2` / `vic_climb`) arms bit 5, jump strobe
  `(0xE2A7)` punches tiles.
- Vic `(0xE280)` named: `vic_tick` (0x9EC4) / `d_9ecd` 0–5 `vic_walk` /
  `vic_jump` / `vic_climb` / `vic_fall` / `vic_die` / `vic_hit`. Not in
  `msx.sym`. Pyoncy / Rock Roll ticks commented (`tick_pyoncy`,
  `start_rockroll` / `tick_rockroll`); type 4 is `tick_trap`.
- Map tools named: `load_map_tools` (0x97BB), `use_tool` (0xA045),
  `tick_map_tools` (0xA6BD). E600 type 1 tick is `tick_coffin` (0xBA85),
  not `d_a6f2` (knife states on E300). Draw tables at 0x64CF / 0x64D9
  folded (`defw`).
- Packed bank 0D lists folded into [`banks/data/`](../banks/data/) (`GEM` /
  `ACTOR` / `TOOL` / `LINK` / `DELAYED` in `objects.inc`): gems, actors,
  tools, screens, links, delayed pickups, Vic spawn / exit door.
  Last records overlap the following pointer table. Map bitmaps/RLE/HUD
  glyphs/`sat_pat` are source (`minimap.asm`, `hud_tiles.asm`).
- Bank 0C `obj_ptr`/`obj2_ptr` overlays (0xA363–0xAA29) and world-map
  `copy_tiles` font (0xAA29) are source (`overlays.asm`, `wmap.asm`).
- Bank 0E/0F UI lists folded: `held_ptr` / `vic_hmm`; RLE `rle_86d4`..`rle_97a1` /
  `rle_a9f6`..; `pat_copy` / `pat_flip`; `end_txt`; `col_ptr` (`col_21` crosses
  A000); `STAMP` / `draw_tilemap` grids; `pal_w_even` / `pal_w_odd` /
  `hud_world_tbl`.
- `unpack_map` streams `map_01`..`map_60` (`MAP_RUN` / `MAP_END`) live in
  [`maps0A.asm`](../banks/data/maps0A.asm) / `maps0B.asm` / `maps0C.asm`.
  `map_33` and `map_59` cross the 8000 / A000 windows.
- Bank 0C attract decoded: `demo_lvls` pyramids 2/18/26/40/48/53 (one per
  world); `ba_w1..ba_w6` are timed joypad scripts (`keys_apply`).
- Vic 6–14 labeled (`vic_pull_l` / `vic_pull_r` / `vic_throw` / tools /
  `vic_hold`). Type 5 tick is `tick_stone`. `use_throw` / `use_floor` /
  `use_wall`. `(0xE200)` game-mode table commented. `keys_apply` @ 0x5434.
- `poll_keys` un-glued from WRTVDP sprite regs at 0x5413. E300 ticks
  `tick_map_knife`..`tick_map_drill`; E500 `tick_thrown_*`. Pickup is
  `pickup_tool`. Modes 9–13 named (stage-clear / world / continue / ending).
- `sfx_01`..`sfx_41` / `sfx_80`..`sfx_84` thunks (`SFX` / `SFXR` in
  [`banks/sfx.inc`](../banks/sfx.inc)) sit at 0x41E0–0x4324. Boot fall-in
  `jp`s `sfx_3c`. `map_tile` / `probe_step` named. Editor E600 place is
  `put_trap` / `editor_spawn` (`d_7e6c`).
- `d_46ea` handlers labeled (`mode_boot`..`mode_endtxt`). `mode_goto` /
  `mode_next` / `sub_next`. `sat_wipe` @ 0x5D41, `play_tick` @ 0x5D6D,
  `scr_reset` @ 0x4E98, `title_load` @ 0x5B6A, `title_jp` @ 0x5F8D, `bgm_stage` @ 0x4388.
  H.TIMI calls `poll_keys` then `mode_frame`.
- `play_tick` callees named (`vic_sat`, `tools_sat`, `tick_actors`,
  `touch_gems`, `probe_pickup`, `probe_exit`, `tick_e500`, …). Title
  `d_47c2` is `title_jingle`..`title_go`. `E257` scripts: `clear_tick`,
  `world_tick`, `end_tick` (65-word `d_735f`), title/file `e257_jp`.
  Stage-clear handlers `clear_door`..`clear_done`; world-complete
  `world_scr`..`world_exit` (`wpic0`..`wpic2` @ 0x5A17). `world_xy` /
  `world_xy2` / `clear_spr` folded. Title `e257_jp` handlers
  `pwd_wipe`..`pwd_done`; `pwd_txt` is `"pass word"` (`pwd_print` /
  `pwd_gen`). Room change: `probe_edge` / `room_exit` / `room_link` /
  `room_draw`. `load_pyramid` unpacks a new map; `load_vic` / `load_*_far`
  / `e300_list` / `load_ef10` fill Vic and lists. File I/O: `io_tick`
  (`io_ask`..`io_list`) and title `disk_tick` (`edit_boot` / `edit_gfx` /
  `edit_play`). `disk_err` / `disk_print`. Continue: `cont_boot`..`cont_esc`; editor `edit_hud`..
  `edit_yn`. `edit_put` `d_7e6c` is `put_floor1`..`put_exit` (legend 0..8).
  Pyramid FX `disp_b42f` is `ef10_land`..`ef10_enter`; `sat_fx` / `d_7835`
  is the bank 0E/0F SAT burst (`pwd_idle` / `world_sat` / `end_tick`).
  Bank 00 UI blit wrappers `blit_902e`..`blit_9074`, `pic_a358`, `tiles_wmap`,
  `spr_vram` @ 0x583B, `vic_reload` @ 0x5859, `pat_15` / `col_15` /
  `draw_cols`. Ending `d_735f` is fully named (`end_boot`..`end_done`,
  nine `end_page` cycles). `print_12` / `end_print_i` far-print bank 0C
  streams (`str_end_boot`..`ad76_tbl` credits). `print_world` @ 0x71A5
  prints `world_txt`. File menu is `str_start_sel`. Editor HUD is `edit_legend`; `draw_minimap` @ 0x886A stamps
  `bb38_tbl`. Ceremony SAT is `cer_sat` / `cer_pair` / `pose_step` / `pose_tbl` /
  `pose_pat`; `spark_far` pages bank 0C `spark_init` / `spark_tick`
  (E910 slots). `pal_blink_a` / `pal_blink_c` / `pal_black` are ending
  palette helpers. `print_at` @ 0x51DA. `tbl_word` @ 0x4D4C. VDP CMD
  `vdp_hmmv` / `vdp_lmmv` / `vdp_hmmm` / `vdp_hmmc` (`vdp_ce_wait`).
- Generic split/graduation workflow: workbench skill `msx-code-data`.
- `make gfx` (`tools/gfxdump.py`) writes `gfx/palettes/`, `gfx/tilesets/`,
  `gfx/sprites/`, `gfx/fonts/`, `gfx/metatiles/` from `palette_list` /
  dest-plane `BLIT` lists (`dest_w1`..`dest_w6`, common / UI) / `copy_tiles`
  / held-tool Konami RLE / `pat_copy` / minimaps. Overlay applies explicit
  black (pal_a7ce 0F); 1bpp inks are palette indices, not canvas-off.
  World-map font is bank 0C `0xAA29` (not bank 0B). `0xBECF` is SAT pattern
  ids, not sprite planes.
- `make music` / `make sfx` (`tools/psgplay.py`) write `music/` and `sfx/`
  WAVs from packed-PSG ids 1–0x41 via workbench `konami/sccplay.py`.

## Next

1. Name remaining `NN_psg` / `NN_sfx` stems from call sites.
2. Glyph_ptr tile-id stamps and `draw_cols` / `STAMP` composites still have
   no catalogue sheets.

