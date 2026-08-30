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
; 0xE282 X, 0xE284 Y, 0xE285 vic_hmm frame, 0xE287 held E300 type.
; 0xE200 game mode (mode_tick / d_46ea): 0 boot, 1 hold, 2 attract, 3 title,
; 4 stage card, 5 play, 6 life, 7 game over, 8 room (E248), 9–13 clear /
; world / continue / ending. 0xE201 = substate. 0xE800 software SAT
; (sat_wipe fills Y=0xE0).
; 0xE207 rising edges of 0xE208 (held keys); bit 4 = fire. keys_apply.
; Attract: 0xE209 step, 0xE20A duration, 0xE219 slot 1..6 -> demo_lvls.
; 0xE243 current screen. 0xE248 screen-exit dir 1 L / 2 R / 3 U / 4 D
; (probe_edge / room_exit). 0xE250 unpacked-map base for map_tile.
; 0xE257 is a mode-local script index (title/file e257_jp 0-based
; pwd_wipe..pwd_done; stage-clear / world / ending are 1-based).
; 0xE25A continue script (cont_tick). 0xE25B file I/O / nested editor
; (io_tick / disk_tick / d_7b0b). 0xE260 editor legend (print_legend 0..10);
; 0xE261 subtype; 0xE262 screen slot in E788.
; Editor occupancy: 0xE266 delayed (max 8), 0xE267 E600 (max 16),
; 0xE268 E300 (max 64), 0xE269 gems (max 16), 0xE26A exit, 0xE26B Vic.
; 0xF0F8 load device 0 tape / 1 disk / 2 sram (io_dev); 0xF0F9 present bits.
; 0xE788 screen ids from ab5a_flags.
; 0xED80/90/A0/B0 door links (4 dirs).
; 0xEE50 occupied E300 slot ids (e300_list).
; 0xEDCB/EDCC ceremony XY (cer_sat / world_pos); 0xEDD8 walk pose.
; Play: 0xE900 unpacked map (unpack_map). Ending sparks reuse 0xE900–E902
; as timers and 0xE910 as 32 × 16 slots (spark_init / spark_tick).
; 0xE880 sat_fx busy (bank 0E/0F burst); 0xE881 phase 0..2.
; 0xEF10 per-pyramid FX (load_ef10 / tick_ef10 / draw_ef10).
; 0xEF11 fx state 0 land / 1 hold / 2 clear / 3 enter (mode_end).
