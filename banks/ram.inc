; ===========================================================================
;  Confirmed work-RAM. Readability only — not emitted, not in msx.sym
;  (z80dasm would rewrite matching immediates).
; ===========================================================================

; BIOS hooks (system work area)
H_KEYI:                  equ 0xFD9A
H_TIMI:                  equ 0xFD9F
H_STKE:                  equ 0xFEDA
H_PHYD:                  equ 0xFFA7

; Boot (bank 00 cart_boot). Stack at 0xE000; 0xE000-0xEFFF and 0xD200-0xD3FF
; are zeroed. Mapper copies at 0xF0F1/F0F2/F0F3 track banks written to
; 0x7000 / 0x9000 / 0xB000 (SCC pages 6000 / 8000 / A000).
mapper_bank_6000:        equ 0xF0F1
mapper_bank_8000:        equ 0xF0F2
mapper_bank_A000:        equ 0xF0F3

; Vic. 0xE280 is d_9ecd (no dec a): 0 walk, 1 jump, 2 climb (ladder;
; secret_hit arms bit 5), 3 fall-in, 4 die, 5 E500-hit, 6/7 coffin pull,
; 8-13 tools, 14 hold. Not an equ — z80dasm would rewrite immediates.
; 0xE282 Y (SAT Y = E282-9), 0xE284 X, 0xE285 vic_hmm frame, 0xE287 held E300 type.
; 0xE24C pause (vic_pause_rle pushups); 0xE298 vic_die / vic_hit SAT (vic_die_rle).
; 0xE200 game mode (mode_tick / d_46ea): 0 boot, 1 hold, 2 attract, 3 title,
; 4 stage card, 5 play, 6 life, 7 game over, 8 room (E248), 9–13 clear /
; world / continue / ending. 0xE201 = substate. 0xE226 packed-BCD score
; (`add_score`). 0xE800 software SAT
; (sat_wipe fills Y=0xE0).
; 0xE207 rising edges of 0xE208 (held keys); bit 4 = fire. keys_apply.
; Editor auto-fire: 0xE21C hold timer (keys_repeat, mode 0x0B).
; Attract: 0xE209 step, 0xE20A duration, 0xE219 slot 1..6 -> demo_lvls.
; 0xE243 current screen. 0xEFC0/EFC2/EFC4 coffin/pyoncy stamp row ptrs
; (`actor_rows`). 0xEFF0 secret_punch extra tile count.
; 0xE248 screen-exit dir 1 up / 2 down / 3 left / 4 right
; (probe_edge / room_exit). 0xE250 unpacked-map base for map_tile.
; 0xE257 is a mode-local script index (title/file e257_jp 0-based
; pwd_wipe..pwd_done; stage-clear / world / ending are 1-based).
; 0xE25A continue script (cont_tick). 0xE25B file I/O / nested editor
; (io_tick / disk_tick / d_7b0b). 0xE260 editor legend (print_legend 0..10);
; 0xE261 subtype; 0xE262 screen slot in E788.
; 0xE2C0 names_enemies spawners (8 × 5): type|0x80, timer, screen, Y, X
; (load_delayed / put_enemy). First timer 0x14; tick_delayed -> E500
; (enemy_sat at E840). enemy_done re-arms bit 7; respawn timer 0x30.
; stamp_delayed case_under at (X, Y−8) for types 1–2 (sarcophagus).
; Type 4 Rock Roll: no case; play SAT boulder D0/D8 cc 07/49.
; delay_sat is editor-only (same packed XY). Not E300 floor tools.
; Editor occupancy: 0xE266 delayed (max 8), 0xE267 E600 (max 16),
; 0xE268 E300 (max 64), 0xE269 gems (max 16), 0xE26A exit, 0xE26B Vic.
; 0xF0F8 load device 0 tape / 1 disk / 2 sram (io_dev); 0xF0F9 present bits
; (io_probe: bit 0 PHYDIO, bit 1 disk ROM). 0xF0E4 H.TIMI stash during disk;
; 0xF0E5 FILE? catalog count (disk_dir). 0xF323 DISKERR (`disk_err` /
; `disk_unwind` during `dos_dir`).
; 0xE788 screen ids from ab5a_flags.
; 0xE1CB sound flags (bit 0 fade, bit 1 paused/stashed, bit 4 fade-4);
; 0xE1CC last id; 0xE1CD packed header; slots E000+n*0x33.
; 0xE1E3 AY mixer shadow; 0xE1E4 tick channel mask; 0xE1E5/E6 noise
; period; 0xE1E7 AY dirty; 0xE1E8-EA env; 0xE1EB SCC dirty; 0xE1ED
; SCC period/vol shadow; 0xE1FC SCC 988F enable.
; 0xED80 up / ED90 down / EDA0 left / EDB0 right (room_link / pause map).
; 0xEDC0 pause-map overlay (pause_overlay: 0 wait / 1 draw / 2 restore / 3 idle).
; 0xEE50 occupied E300 slot ids (e300_list).
; 0xEDCB/EDCC ceremony XY (cer_sat / world_pos); 0xEDD8 walk pose.
; Play: 0xE900 unpacked map (unpack_map). Ending sparks reuse 0xE900–E902
; as timers and 0xE910 as 32 × 16 slots (spark_init / spark_tick).
; 0xE880 sat_fx busy (bank 0E/0F burst); 0xE881 phase 0..2.
; 0xEF10 per-pyramid FX (load_ef10 / tick_ef10 / draw_ef10).
; 0xEF11 fx state 0 land / 1 hold / 2 clear / 3 enter (mode_end).
; 0xEF13/14 dest XY of the 16x16; 0xEF15 hold timer. Type 2 puzzle uses
; 0xEF20 5x5 board, ix+1 UI state, ix+2 row, ix+3 col (puzzle_ui).
; 0xE203 board index 0..3 (puz_ptr). 0xE240 extra lives (BCD).
; Tape: 0xEE50 name/header, 0xE270 expected name, 0xE27F=2 on I/O error.
