; ===========================================================================
;  banks 1-3 — boot triplet via page_banks_123, CPU 0x6000–0xBFFF (one PHASE).
;  24 KiB window file. Bank 0 @ 0x4000 stays separate (never remapped).
;  ld hl,0E2F3h @ 0x7FFE is a real instruction.
;  Regen one 8K bank at a time:
;    tools/workbench/msx/regen-bank.sh 1 0x6000 banks/banks_123.blocks
;    tools/workbench/msx/regen-bank.sh 2 0x8000 banks/banks_123.blocks
;    tools/workbench/msx/regen-bank.sh 3 0xA000 banks/banks_123.blocks
; ===========================================================================

; (org set by PHASE 0x6000 in master; 24 KiB through 0xBFFF)
; SAT template + colour RAM for the pause map. Not called (romscan).
pause_sat:                        ; 0x6000
	call print_stream
	call print_stream
	call sat_wipe
	ld de,0e800h            ; SAT
	ld hl,e800_copy_start
	ld bc,00020h
	ldir
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,00040h
	ld (hl),00dh
	ldir
	ld hl,0d240h
	ld de,0d241h
	ld bc,00040h
	ld (hl),00eh
	ldir
	call spr_vram
	ld a,001h
	ld (0e2c2h),a
	ld b,0b4h
	ret

; BLOCK 'e800_copy' (start 0x6039 end 0x6059)
e800_copy_start:
	defb 014h, 048h, 000h, 000h   ; 2x4 SAT: Y, X, pat
	defb 014h, 058h, 008h, 000h
	defb 014h, 068h, 010h, 000h
	defb 014h, 078h, 018h, 000h
	defb 014h, 048h, 004h, 000h
	defb 014h, 058h, 00ch, 000h
	defb 014h, 068h, 014h, 000h
	defb 014h, 078h, 01ch, 000h
e800_copy_end:
; Pause map overlay. pause_tick calls here; EDC0 is 0 wait / 1 draw / 2 restore / 3 idle.
pause_overlay:                    ; 0x6059
	ld a,(0edc0h)           ; pause overlay
	call DISPATCH_A

; BLOCK 'edc0_jp' (start 0x605f end 0x6067)
edc0_jp_start:
	defw pause_map_wait
	defw pause_map_draw
	defw pause_map_done
	defw pause_map_idle
edc0_jp_end:
pause_map_wait:                   ; 0x6067  E20C bit 1 -> HUD tiles
	ld a,(0e20ch)           ; vic_die flag
	rra
	rra
	ret nc                        ; bit 1 (F2): open map
	call scr_reset
	call hud_load
pause_next:                       ; 0x6073
	ld hl,0edc0h            ; pause overlay
	inc (hl)
pause_map_idle:                   ; 0x6077  EDC0 = 3
	ret
; HUD 1bpp + SAT from bank 0D (pause map / play restore).
hud_load:                         ; 0x6078
	call page_bank_d
	ld hl,0bf36h                  ; hud_bf36
	ld de,00838h
	ld bc,0128bh
	call copy_tiles
	ld hl,0bfc6h                  ; hud_bfc6
	ld de,09838h
	ld bc,00607h
	call copy_tiles
	ld de,0bf29h                  ; rle_bf29 HUD SAT
	ld hl,0f800h
	call rle_vram
	jp page_banks_123
pause_map_draw:                   ; 0x609F  doors / gems / screens / Vic / exit
	call map_screens
	call map_doors
	call map_gems
	call sat_wipe
	call map_exit
	call map_vic
	call spr_vram
	ld de,0c000h
	ld hl,0f400h
	ld bc,00280h
	call ldirvm
	jr pause_next
pause_map_done:                   ; 0x60C2  E20C bit 1 -> restore play
	ld a,(0e20ch)           ; vic_die flag
	rra
	rra
	ret nc
	call scr_reset
	call wmap_font
	call room_draw
	call vic_reload
	call vic_sat
	call e500_sat
	xor a
	ld (0edc0h),a           ; pause overlay
	jp sat_flip
; Door-link arrows on the pause map (ED80 up / ED90 down / EDA0 left / EDB0 right).
map_doors:                        ; 0x60E1
	call map_doors_up
	call map_doors_down
	call map_doors_left
	jp map_doors_right
; ED80 up
map_doors_up:                     ; 0x60ED  ED80 up
	ld de,0ed80h            ; link up
	ld b,008h
map_up_loop:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_up
	inc de
	inc de
	djnz map_up_loop
	ret
; screen id A -> print_at up glyph
map_arrow_up:                     ; 0x60FE  screen id A -> print_at up glyph
	push bc
	push de
	ld c,a
	and 0f8h
	rra
	rra
	rra
	ld b,a
	inc b
	ld a,0f8h
	ld e,018h
map_up_row:
	add a,e
	djnz map_up_row
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,008h
	ld d,020h
map_up_col:
	add a,d
	djnz map_up_col
	ld d,a
	ld hl,map_glyph_up
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
; ED90 down
map_doors_down:                    ; 0x6128  ED90 down
	ld de,0ed90h            ; link down
	ld b,008h
map_down_loop:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_down
	inc de
	inc de
	djnz map_down_loop
	ret
; screen id A -> print_at down glyph
map_arrow_down:                      ; 0x6139
	push bc
	push de
	ld c,a
	and 0f8h
	rra
	rra
	rra
	ld b,a
	inc b
	ld a,018h
	ld e,018h
map_down_row:
	add a,e
	djnz map_down_row
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,008h
	ld d,020h
map_down_col:
	add a,d
	djnz map_down_col
	ld d,a
	ld hl,map_glyph_down
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
; EDA0 left
map_doors_left:                    ; 0x6163  EDA0 left
	ld de,0eda0h            ; link left
	ld b,008h
map_left_loop:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_left
	inc de
	inc de
	djnz map_left_loop
	ret
; screen id A -> print_at left glyph
map_arrow_left:                      ; 0x6174
	push bc
	push de
	ld c,a
	and 0f8h
	rra
	rra
	rra
	ld b,a
	inc b
	ld a,008h
	ld e,018h
map_left_row:
	add a,e
	djnz map_left_row
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,0f8h
	ld d,020h
map_left_col:
	add a,d
	djnz map_left_col
	ld d,a
	ld hl,map_glyph_left
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
map_doors_right:                   ; 0x619E  EDB0 right
	ld de,0edb0h            ; link right
	ld b,008h
map_right_loop:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_right
	inc de
	inc de
	djnz map_right_loop
	ret
; screen id A -> print_at right glyph
map_arrow_right:                      ; 0x61AF
	push bc
	push de
	ld c,a
	and 0f8h
	rra
	rra
	rra
	ld b,a
	inc b
	ld a,008h
	ld e,018h
map_right_row:
	add a,e
	djnz map_right_row
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,020h
	ld d,020h
map_right_col:
	add a,d
	djnz map_right_col
	ld d,a
	ld hl,map_glyph_right
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
; BLOCK 'map_arrow' (start 0x61D9 end 0x61E3)
map_glyph_up:                      ; 0x61D9  two-tile up
	defb 0f3h, 0f4h, 0ffh
map_glyph_down:                    ; 0x61DC  two-tile down
	defb 0f5h, 0f6h, 0ffh
map_glyph_left:                    ; 0x61DF
	defb 0f7h, 0ffh
map_glyph_right:                   ; 0x61E1
	defb 0f8h, 0ffh
; Vic marker on E243's cell in E788.
map_vic:                          ; 0x61E3
	ld a,(0e243h)           ; screen
	ld hl,0e788h            ; screen ids
	ld c,007h
map_vic_row:
	ld b,008h
map_vic_col:
	cp (hl)
	jr z,map_vic_at
	inc hl
	djnz map_vic_col
	dec c
	jr nz,map_vic_row
	ret
map_vic_at:
	ld hl,0e282h            ; Vic Y
	call map_cell
	ld a,(hl)
	ld c,a
	inc hl
	inc hl
	rra
	rra
	rra
	and 01fh
	add a,e
	ld e,a
	ld a,(hl)
	ld b,a
	rra
	rra
	rra
	and 01fh
	add a,d
	ld d,a
	call map_origin
	ld hl,0e804h
	dec e
	ld (hl),e
	inc hl
	ld a,d
	sub 003h
	ld (hl),a
	inc hl
	ld (hl),004h
	ld de,0d211h
	ld hl,0d210h
	ld bc,0000fh
	ld (hl),007h
	ldir
	ret
; Exit-door marker (E2F3 screen, E2F1 XY).
map_exit:                         ; 0x622F
	ld a,(0e2f3h)
	ld hl,0e788h            ; screen ids
	ld c,007h
map_exit_row:
	ld b,008h
map_exit_col:
	cp (hl)
	jr z,map_exit_at
	inc hl
	djnz map_exit_col
	dec c
	jr nz,map_exit_row
	ret
map_exit_at:
	ld hl,0e2f1h
	call map_xy
	call map_origin
	ld hl,0e800h            ; SAT
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (hl),000h
	ld de,0d201h
	ld hl,0d200h            ; boot spare
	ld bc,0000fh
	ld (hl),00bh
	ldir
	ret
; Soul stones on the pause map (E700).
map_gems:                         ; 0x6263
	ld hl,0e700h            ; gems
	ld b,010h
map_gems_loop:
	ld a,(hl)
	or a
	call nz,map_gem
	ld de,00008h
	add hl,de
	djnz map_gems_loop
	ret
; soul stone on the pause map
map_gem:                          ; 0x6274
	push hl
	push bc
	call map_gem_put
	pop bc
	pop hl
	ret
; skip if screen not in E788
map_gem_put:                      ; 0x627C  skip if screen not in E788
	inc hl
	ld a,(hl)
	inc hl
	ld (0efc0h),hl          ; stamp row
	ld hl,0e788h            ; screen ids
	ld c,007h
map_gem_row:
	ld b,008h
map_gem_col:
	cp (hl)
	jr z,map_gem_at
	inc hl
	djnz map_gem_col
	dec c
	jr nz,map_gem_row
	pop hl
	ret
map_gem_at:
	ld hl,(0efc0h)          ; stamp row
	call map_xy
	call map_origin
	ld a,b
	rlca
	rlca
	and 003h
	ld b,a
	ld a,c
	rra
	rra
	rra
	rra
	and 00ch
	add a,b
	ld hl,gem_stamp
	call ADD_HL_A
	ld a,(hl)
	jp tile_pset
; packed X/Y at HL -> DE + map_cell
map_xy:                           ; 0x62B5  packed X/Y at HL -> DE + map_cell
	call map_cell
	ld a,(hl)
	ld c,a
	inc hl
	rra
	rra
	rra
	and 018h
	add a,e
	ld e,a
	ld a,(hl)
	ld b,a
	rra
	rra
	rra
	and 018h
	add a,d
	ld d,a
	ret
; BLOCK 'gem_stamp' (start 0x62CC end 0x62D8)
; Tile ids by gem frame; [12..15] overlap map_screens.
gem_stamp:
	defb 0eah, 0ebh, 0ebh, 0ech
	defb 0edh, 0eeh, 0eeh, 0efh
	defb 0f0h, 0f1h, 0f1h, 0f2h
; Occupied E788 cells (HL already E788 from the overlap).
map_screens:                      ; 0x62D8
	ld hl,0e788h            ; screen ids
	ld c,007h
map_scr_row:
	ld b,008h
map_scr_col:
	ld a,(hl)
	or a
	call nz,map_screen
	inc hl
	djnz map_scr_col
	dec c
	jr nz,map_scr_row
	ret
; E788 cell glyph (save regs)
map_screen:                       ; 0x62EB
	push af
	push bc
	push hl
	call map_screen_put
	pop hl
	pop bc
	pop af
	ret
; E788 cell -> stamp_at
map_screen_put:                   ; 0x62F5
	call map_cell
	call map_origin
	ld hl,scr_stamp
	jp stamp_at
; E788 (B col, C row) -> pixel DE
map_cell:                         ; 0x6301  E788 (B col, C row) -> pixel DE
	ld a,008h
	sub b
	add a,a
	add a,a
	add a,a
	add a,a
	add a,a
	ld d,a
	ld a,007h
	sub c
	add a,a
	add a,a
	add a,a
	ld e,a
	add a,a
	add a,e
	ld e,a
	ret
; + (0x20, 0x18) map origin
map_origin:                       ; 0x6315  + (0x20, 0x18) map origin
	ld a,d
	add a,020h
	ld d,a
	ld a,e
	add a,018h
	ld e,a
	ret
; BLOCK 'scr_stamp' (start 0x631E end 0x632D)
scr_stamp:                        ; 0x631E  4x3 occupied-cell stamp (FE row, FF end)
	defb 0e1h, 0e2h, 0e2h, 0e3h, 0feh
	defb 0e4h, 0e5h, 0e5h, 0e6h, 0feh
	defb 0e7h, 0e8h, 0e8h, 0e9h, 0ffh
; Page 13, then load_actors.
load_actors_far:                  ; 0x632D
	call page_bank_d
	call load_actors
	jp page_banks_123
; Packed aae0_tbl[level] → E600 (16 × 16).
load_actors:                      ; 0x6336
	ld a,(0e242h)           ; level
	ld hl,0aae0h
	call tbl_word
	ld ix,0e600h            ; actors
actor_unpack:
	ld a,(hl)
	ld b,a
	and a
	ret z
	rrca
	rrca
	rrca
	rrca
	and 00fh
	ld (ix+000h),a
	ld a,(hl)
	and 00fh
	ld (ix+004h),a
	ld (ix+009h),a
	inc hl
	ld a,(hl)
	ld (ix+002h),a
	inc hl
	ld a,(hl)
	ld (ix+003h),a
	inc hl
	ld a,(hl)
	rrca
	rrca
	rrca
	and 01fh
	ld (ix+008h),a                ; height in tiles (type 1: 2–4; type 4: 1; type 5: 2)
	ld a,(hl)
	and 007h
	jr z,actor_face0
	set 1,(ix+007h)               ; lo3 != 0: facing / lid side (not Flouman)
	jr actor_lid
actor_face0:
	res 1,(ix+007h)
actor_lid:
	ld b,a
	add a,a
	add a,b
	ld b,a
	ld a,(ix+000h)                ; 1=coffin (Slouman/Flouman), 2=Pyoncy, 3=Rock Roll, 4=trap, 5=stone
	cp 001h
	jr z,actor_lid_set
	ld b,000h
actor_lid_set:
	ld (ix+005h),b                ; type 1 only: lid frame = (byte3 & 7) * 3
	ld (ix+006h),000h
	inc hl
	ld de,00010h
	add ix,de
	jr actor_unpack
; stamp E600 including stones (C≠0 skips stone_clear)
stamp_actors_c3:                  ; 0x6398  stamp E600 including stones
	ld c,003h
	jr stamp_actors_go
; stamp E600 onto the map (C=0)
stamp_actors:                     ; 0x639C  stamp E600 onto the map (C=0)
	ld c,000h
stamp_actors_go:
	ld b,010h
	ld ix,0e600h            ; actors
stamp_actors_loop:
	push bc
	ld a,(ix+000h)
	and a
	call nz,stamp_actor
	ld bc,00010h
	add ix,bc
	pop bc
	djnz stamp_actors_loop
	ret
; skip Rock Roll; stone via stone_clear if C=0
stamp_actor:                      ; 0x63B5  skip Rock Roll; stone via stone_clear if C=0
	cp 003h
	ret z
	cp 005h
	jr nz,stamp_xy
	ld a,c
	and a
	jp z,stone_clear
	ld a,(ix+001h)
	and a
	ret nz
stamp_xy:
	ld h,(ix+003h)
	ld l,(ix+002h)
	cp 002h
	jr nz,stamp_hgt
	bit 1,(ix+007h)
	jr z,stamp_hgt
	ld a,h
	add a,008h
	ld h,a
stamp_hgt:
	ld a,(ix+000h)
	ld de,actor_hgt-1
	call ADD_DE_A
	ld a,(de)
	ld d,a
	ld a,c
	ld b,(ix+008h)
	ld c,d
	ld d,(ix+004h)
; 2-bit rect at HL, size B×C, screen D
stamp_rect:                       ; 0x63ED  2-bit rect at HL, size B×C, screen D
	ld (0efc0h),a           ; stamp row
	ld a,d
	ld (0efc1h),a
	call scr5_addr
	ld de,03800h
	or a
	sbc hl,de
stamp_row:
	push hl
	push bc
	ld b,c
stamp_col:
	push hl
	ld c,l
	srl h
	rr l
	srl h
	rr l
	ld a,l
	ld hl,(0efc1h)
	dec l
	ld h,000h
	call map_base
	call ADD_HL_A
	push bc
	ld a,0fch
	call map_mask
	and (hl)
	ld (hl),a
	ld a,(0efc0h)           ; stamp row
	and a
	jr z,stamp_next
	call map_mask
	or (hl)
	ld (hl),a
stamp_next:
	pop bc
	pop hl
	inc hl
	djnz stamp_col
	pop bc
	pop hl
	ld a,020h
	call ADD_HL_A
	djnz stamp_row
	ret
; 2-bit mask for X in C; rotates A
map_mask:                         ; 0x6439  2-bit mask for X in C; rotates A
	push af
	ld a,c
	and 003h
	inc a
	ld b,a
	pop af
mask_rot:
	rrca
	rrca
	djnz mask_rot
	ret
actor_hgt:                        ; 0x6445  tile height by ix+0 type (index from actor_hgt-1)
	defb 002h                     ; 1 Slouman / Flouman
	defb 001h                     ; 2 Pyoncy
	defb 001h                     ; 3 Rock Roll
	defb 004h                     ; 4 trap (1×4 column, tile 0x61)
	defb 002h                     ; 5 stone (2×2, bifi pushable)
; on-screen E600 via draw_actor / actor_draw
draw_actors:                      ; 0x644A  on-screen E600 via draw_actor / actor_draw
	ld ix,0e600h            ; actors
	ld b,010h
draw_actors_loop:
	push bc
	ld a,(ix+000h)
	and a
	call nz,draw_actor
	ld bc,00010h
	add ix,bc
	pop bc
	djnz draw_actors_loop
draw_nop:                         ; 0x6460  actor_draw[3,5] / actor_redraw[4]
	ret
; type 5 on current screen
draw_stones:                      ; 0x6461  type 5 on current screen
	ld ix,0e600h            ; actors
	ld b,010h
draw_stones_loop:
	push bc
	ld a,(ix+000h)
	cp 005h
	jr nz,draw_stones_next
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	jr nz,draw_stones_next
	call draw_stone1
draw_stones_next:
	ld bc,00010h
	add ix,bc
	pop bc
	djnz draw_stones_loop
	ret
; Per-frame E600: d_64a1, dirty redraw, start_rockroll.
tick_actors:                      ; 0x6483
	ld ix,0e600h            ; actors
	ld b,010h
tick_actors_loop:
	push bc
	call tick_actor
	call actor_dirty
	ld bc,00010h
	add ix,bc
	pop bc
	djnz tick_actors_loop
	jp start_rockroll
; d_64a1 by ix+0
tick_actor:                       ; 0x649B  d_64a1 by ix+0
	ld a,(ix+000h)
	and a
	ret z
	dec a
	call DISPATCH_A

; BLOCK 'd_64a1_jp' (start 0x64a4 end 0x64ae)
d_64a1_jp_start:
	defw tick_coffin              ; type 1 coffin (grab Vic 6/7; no walk)
	defw tick_pyoncy              ; type 2 Pyoncy (grab + 4-frame; no X/Y)
	defw tick_rockroll            ; type 3 Rock Roll (triggered fall)
	defw tick_trap                ; type 4 trap (1x4 column)
	defw tick_stone               ; type 5 stone (pushable)
d_64a1_jp_end:
; ix+7 bit 0 -> redraw table
actor_dirty:                      ; 0x64AE  ix+7 bit 0 -> redraw table
	ld a,(ix+007h)
	rra
	ret nc
	res 0,(ix+007h)
	ld hl,actor_redraw
	jr actor_go
; on-screen draw table
draw_actor:                       ; 0x64BC  on-screen draw table
	ld hl,actor_draw
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
actor_go:
	ld a,(ix+000h)
	and a
	ret z
	dec a
	jp dispatch_hl
actor_redraw:                     ; 0x64CF  dirty redraw (ix+7 bit 0)
	defw draw_coffin              ; 1 coffin
	defw draw_pyoncy              ; 2 Pyoncy
	defw draw_rockroll            ; 3 Rock Roll (falling tiles)
	defw draw_nop                   ; 4 trap (ret)
	defw draw_stone               ; 5 stone
actor_draw:                       ; 0x64D9  on-screen draw
	defw draw_coffin              ; 1 coffin
	defw draw_pyoncy              ; 2 Pyoncy
	defw draw_nop                   ; 3 (ret)
	defw draw_trap                ; 4 trap tiles
	defw draw_nop                   ; 5 (ret)
; clear E700, page 13, load_gems
load_gems_far:                    ; 0x64E3  clear E700, page 13, load_gems
	ld hl,0e700h            ; gems
	ld b,080h
	xor a
gems_wipe:
	ld (hl),a
	inc hl
	djnz gems_wipe
	call page_bank_d
	call load_gems
	jp page_banks_123
; a75d_tbl[level] -> 0xE700 soul stones (16 x 8)
load_gems:                        ; 0x64F6  a75d_tbl[level] -> 0xE700 soul stones (16 x 8)
	ld a,(0e242h)           ; level
	ld hl,0a75dh
	call tbl_word
	ld de,0e700h            ; gems
gems_unpack:
	ld a,(hl)
	and a
	ret z
	rra
	rra
	rra
	rra
	and 00fh
	ld (de),a
	ld a,(hl)
	and 00fh
	inc e
	ld (de),a
	inc e
	inc hl
	ldi
	ldi
	inc e
	inc e
	inc e
	inc e
	jr gems_unpack
; Soul stones on this screen (E700).
draw_gems:                        ; 0x651C
	ld bc,01000h
	ld ix,0e700h            ; gems
draw_gems_loop:
	push bc
	ld a,(ix+000h)
	and a
	call nz,gem_draw
	ld de,00008h
	add ix,de
	pop bc
	inc c
	djnz draw_gems_loop
	ret
; soul stone on this screen -> gem_tiles
gem_draw:                       ; 0x6536  soul stone on this screen -> gem_tiles
	ld a,(0e243h)           ; screen
	cp (ix+001h)
	ret nz
; 2x2 tiles from gem_pat at DE
gem_tiles:                      ; 0x653D  2x2 tiles from gem_pat at DE
	ld hl,gem_pat
	ld e,(ix+002h)
	ld d,(ix+003h)
	ld bc,00202h
	jp draw_tilemap
; thrown/active tools at E500
tick_e500:                        ; 0x654C  thrown/active tools at E500
	ld ix,0e500h            ; thrown tools
	ld b,008h
tick_e500_loop:
	push bc
	ld a,(ix+000h)
	and a
	jr z,tick_e500_next
	call tick_thrown
	bit 0,(ix+006h)
	call nz,e500_move
tick_e500_next:
	ld de,00020h
	add ix,de
	pop bc
	djnz tick_e500_loop
	ret
; apply ix+7/9 velocity; wrap via e500_wrap
e500_move:                      ; 0x656C  apply ix+7/9 velocity; wrap via e500_wrap
	ld a,(ix+00bh)
	cp 002h
	jr c,e500_move_y
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+009h)
	ld d,(ix+00ah)
	jr z,e500_sub_x
	add hl,de
	ld a,h
	cp 0f1h
	jr nc,e500_wrap_right
e500_put_x:
	ld (ix+004h),l
	ld (ix+005h),h
	ret
e500_sub_x:
	and a
	sbc hl,de
	jr c,e500_wrap_left
	jr e500_put_x
e500_move_y:
	ld l,(ix+002h)
	ld h,(ix+003h)
	ld e,(ix+007h)
	ld d,(ix+008h)
	and a
	jr nz,e500_add_y
	sbc hl,de
	jr c,e500_wrap_up
	jr e500_put_y
e500_add_y:
	add hl,de
	ld a,h
	cp 0b1h
	jr nc,e500_wrap_down
e500_put_y:
	ld (ix+002h),l
	ld (ix+003h),h
	ret
e500_wrap_left:
	ld a,003h
	call e500_wrap
	ld hl,0f000h
	jr e500_put_x
e500_wrap_right:
	ld a,004h
	call e500_wrap
	ld hl,00000h
	jr e500_put_x
e500_wrap_up:
	ld a,001h
	call e500_wrap
	ld hl,0b000h            ; mapper A000
	jr e500_put_y
e500_wrap_down:
	ld a,002h
	call e500_wrap
	ld hl,00000h
	jr e500_put_y
; room_link A; update ix+16 screen + map ptr
e500_wrap:                      ; 0x65DF  room_link A; update ix+16 screen + map ptr
	ld b,(ix+016h)
	call room_link                 ; A = 1 up / 2 down / 3 left / 4 right
	ld (ix+016h),h
	ld (ix+010h),l
	ld a,l
	call map_of_a
	ld (ix+00ch),e
	ld (ix+00dh),d
	ret
; DISPATCH_A on E500 type 1-5
tick_thrown:                    ; 0x65F6  DISPATCH_A on E500 type 1-5
	ld a,(ix+000h)
	dec a
	ret m
	call DISPATCH_A

; BLOCK 'd_65fb_jp' (start 0x65fe end 0x6608)
d_65fb_jp_start:
	defw tick_thrown_knife        ; tool 1 knife (thrown; 5 states)
	defw tick_thrown_boom         ; tool 2 boomerang (returns; 6 states)
	defw tick_thrown_shovel       ; tool 3 shovel (HUD "scoop"; floor, 1 deep)
	defw tick_thrown_pick         ; tool 4 pick (floor, 2 deep)
	defw tick_thrown_hammer       ; tool 5 hammer (wall, 1 deep; not in stock pickups)
d_65fb_jp_end:
; Stop a thrown E500 (type 5, clear flags).
thrown_stop:                      ; 0x6608
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	call z,sfx_2d
	ld (ix+000h),005h
	xor a
	ld (ix+013h),a
	ld (ix+014h),a
	ld (ix+006h),a
	ld a,(0f0f4h)
	and a
	ret z
	ld (ix+01eh),00ah
	ld (ix+01fh),04bh
	ret
tick_thrown_hammer:               ; 0x662D  E500; unused in stock maps
	ld hl,hammer_msx1
	ld de,hammer_msx2
	call pick_frame
	jp z,thrown_done
	ld (ix+011h),a
	ret
; BLOCK 'hammer_msx1' (start 0x663D end 0x6641)
hammer_msx1:                      ; 0x663D  pick_frame ids; FF end (MSX1)
	defb 015h, 016h, 017h, 0ffh
; BLOCK 'hammer_msx2' (start 0x6641 end 0x6645)
hammer_msx2:                      ; 0x6641  pick_frame ids; FF end (MSX2)
	defb 015h, 016h, 016h, 0ffh
; E500 sprite cells -> E840 / D300
e500_sat:                         ; 0x6645  E500 sprite cells -> E840 / D300
	call e500_sat_put
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,0e843h
	ld de,0d300h
	ld c,010h
e500_cc_loop:
	ld a,(hl)
	ld b,010h
e500_cc_fill:
	ld (de),a
	inc de
	djnz e500_cc_fill
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz,e500_cc_loop
	ret
; E500 on-screen -> SAT at E840
e500_sat_put:                   ; 0x6664  E500 on-screen -> SAT at E840
	ld ix,0e500h            ; thrown tools
	ld de,0e840h
	ld b,008h
	ld a,(0f0f4h)
	and a
	jr z,e500_sat_msx1
e500_sat_msx2:
	push bc
	ld a,(ix+000h)
	and a
	jr z,e500_sat_hide2
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jr nz,e500_sat_hide2
	ld l,(ix+011h)
	ld a,l
	inc a
	jr z,e500_sat_hide2
	ld h,000h
	add hl,hl
	call page_bank_d
	ld bc,0beedh
	add hl,bc
	ld c,(ix+01eh)
	call e500_sat1
	ld c,(ix+01fh)
	call e500_sat1
	call page_banks_123
e500_sat_next2:
	ld bc,00020h
	add ix,bc
	pop bc
	djnz e500_sat_msx2
	ret
e500_sat_hide2:
	ld a,0e0h
	ld (de),a
	inc e
	inc e
	inc e
	inc e
	ld (de),a
	inc e
	inc e
	inc e
	inc e
	jr e500_sat_next2
e500_sat_msx1:
	push bc
	ld a,(ix+000h)
	and a
	jr z,e500_sat_hide1
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jr nz,e500_sat_hide1
	ld l,(ix+011h)
	ld a,l
	inc a
	jr z,e500_sat_hide1
	ld h,000h
	call page_bank_d
	ld bc,0becfh                  ; E500 SAT patterns (ix+11)
	add hl,bc
	ld c,(ix+01eh)
	call e500_sat1
	call page_banks_123
e500_sat_next1:
	ld bc,00020h
	add ix,bc
	pop bc
	djnz e500_sat_msx1
	ret
e500_sat_hide1:
	ld a,0e0h
	ld (de),a
	inc e
	inc e
	inc e
	inc e
	jr e500_sat_next1
; one SAT entry: Y-1, X, pat, C
e500_sat1:                      ; 0x66F3  one SAT entry: Y-1, X, pat, C
	ld a,(ix+003h)
	dec a
	ld (de),a
	inc e
	ld a,(ix+005h)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	inc hl
	inc e
	ld a,c
	ld (de),a
	inc e
	ret
; Clear E500 slot; mark delayed pickup bit 7.
thrown_done:                      ; 0x6706
	xor a
	ld (ix+000h),a
	ld (ix+013h),a
	ld a,(ix+015h)
	ld c,a
	add a,a
	add a,a
	add a,c
	ld hl,0e2c0h            ; delayed pickups
	call ADD_HL_A
	set 7,(hl)
	ret
; E2C0 delayed pickups -> spawn_tool
tick_delayed:                     ; 0x671D  E2C0 delayed pickups -> spawn_tool
	ld a,(0e203h)           ; puzzle board
	and 003h
	ret nz
	ld hl,0e2c0h            ; delayed pickups
	ld bc,00800h
delayed_loop:
	push bc
	push hl
	bit 7,(hl)
	jr z,delayed_next
	inc hl
	dec (hl)
	jr nz,delayed_next
	ld b,c
	dec hl
	res 7,(hl)
	ld c,(hl)
	inc hl
	ld (hl),030h
	inc hl
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	call spawn_tool
delayed_next:
	pop hl
	pop bc
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc c
	djnz delayed_loop
	ret
; b7cd_tbl -> E2C0 delayed pickups
load_delayed:                     ; 0x674F  b7cd_tbl -> E2C0 delayed pickups
	call page_bank_d
	ld hl,0e2c0h            ; delayed pickups
	ld b,028h
	xor a
delayed_wipe:
	ld (hl),a
	inc hl
	djnz delayed_wipe
	ld hl,0b7cdh                  ; delayed pickups -> 0xE2C0
	ld a,(0e242h)           ; level
	call tbl_word
	ld de,0e2c0h            ; delayed pickups
delayed_unpack:
	ld a,(hl)
	inc hl
	and a
	jp z,page_banks_123
	or 080h
	ld (de),a
	inc e
	ld a,014h
	ld (de),a
	inc e
	ldi
	ldi
	ldi
	jr delayed_unpack
; start select (E24B 0 normal / 1 password / 2 stage load)
file_menu:                        ; 0x677E  start select (E24B 0 normal / 1 password / 2 stage load)
	call scr_reset
	call page_bank_c
	ld hl,0b185h                  ; str_start_sel
	call print_stream
	call page_banks_123
	xor a
	ld (0e24bh),a
	jp file_blit
; L/R on E24B 0..2 (normal / password / stage load); fire -> E24A
file_menu_w:                      ; 0x6794  L/R on E24B 0..2 (normal / password / stage load); fire -> E24A
	call spr_vram
	ld hl,0e24bh
	ld a,(0e207h)           ; key edges
	rra
	jr c,file_left
	rra
	jr c,file_right
	rra
	rra
	rra
	jr nc,file_sat
	ld a,001h
	ld (0e24ah),a
	ret
file_left:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	jr nc,file_sat
	ld (hl),002h
	jr file_sat
file_right:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(hl)
	cp 003h
	jr c,file_sat
	ld (hl),000h
file_sat:
	ld a,(hl)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,050h
	ld hl,0e800h            ; SAT
	ld (hl),a
	inc hl
	ld (hl),050h
	inc hl
	ld (hl),014h
	inc hl
	ld (hl),008h
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld (hl),007h
	ld bc,0000fh
	ldir
	ret
; 32 bytes from bank 0C 0xB1B6
file_blit:                        ; 0x67EC  32 bytes from bank 0C 0xB1B6
	call page_bank_c
	ld a,(0f0f4h)
	and a
	ld de,018a0h
	jr z,file_blit_go
	ld de,0f8a0h
file_blit_go:
	ld hl,0b1b6h
	ld bc,00020h
	call ldirmv
	jp page_banks_123
; start e257_jp password/continue anim
pwd_init:                         ; 0x6807  start e257_jp password/continue anim
	call scr_reset
	ld bc,0a201h
	call WRTVDP
	call blit_9043
	call pal_a7ff
	call copy_pwd
	call sat_wipe
	ld a,004h
	call draw_cols
	ld bc,0e201h            ; substate
	call WRTVDP
	xor a
	ld (0e257h),a           ; script index
	ld (0edcch),a           ; ceremony Y
	ld (0edc9h),a
	ld (0edceh),a
	inc a
	ld (0edd8h),a           ; walk pose
	ld a,0e0h
	ld (0edcbh),a           ; ceremony X
	ret
; run pwd_script; fire -> pwd_card
pwd_tick:                         ; 0x683E  run pwd_script; fire -> pwd_card
	ld a,(0e257h)           ; script index
	cp 009h
	jr nc,pwd_run
	ld a,(0e207h)           ; key edges
	and 010h
	jp nz,pwd_card
pwd_run:
	call pwd_script
	ld a,(0e257h)           ; script index
	cp 009h
	call c,cer_sat
	jp spr_vram
; 0-based E257 -> e257_jp
pwd_script:                       ; 0x685B  0-based E257 -> e257_jp
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)           ; script index
	call DISPATCH_A

; BLOCK 'e257_jp' (start 0x6865 end 0x687b)  title/file continue anim (0-based E257)
e257_jp_start:
	defw pwd_wipe
	defw pwd_drop
	defw pwd_in
	defw pwd_bob
	defw pwd_stop
	defw pwd_pose6
	defw pwd_pose0
	defw pwd_burst
	defw pwd_idle
	defw pwd_show
	defw pwd_done
e257_jp_end:
pwd_wipe:                         ; 0x687B
	call sat_wipe
	ld a,010h
pwd_delay:
	ld hl,0e204h
	ld (hl),a
pwd_next:
	ld hl,0e257h            ; script index
	inc (hl)
	ret
pwd_drop:                         ; 0x6889  EDCB Y=0xA8
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,0a8h
	ld (0edcbh),a           ; ceremony X
	jr pwd_next
pwd_in:                           ; 0x6895  walk in until EDCC=0x60
	call pose_step
	ld a,(0edc9h)
	rra
	ret c
	ld hl,0edcch            ; ceremony Y
	inc (hl)
	ld a,(hl)
	cp 060h
	ret c
	ld a,001h
	ld (0edd8h),a           ; walk pose
	ld a,0ffh
	ld (0edceh),a
	jr pwd_next
pwd_bob:                          ; 0x68B1  Y += edcb_delta[EDCE]
	ld a,(0edc9h)
	rra
	ret c
	ld hl,0edceh
	inc (hl)
	ld a,(hl)
	cp 01eh
	jr nc,pwd_bob_done
	ld hl,edcb_delta_start
	call ADD_HL_A
	ld a,(0edcbh)           ; ceremony X
	add a,(hl)
	ld (0edcbh),a           ; ceremony X
	ld hl,0edcch            ; ceremony Y
	inc (hl)
	ret
pwd_bob_done:
	ld a,0a0h
	ld (0edcbh),a           ; ceremony X
	ld a,002h
	ld (0edd8h),a           ; walk pose
	jr pwd_next

; BLOCK 'edcb_delta' (start 0x68dd end 0x68fb)
edcb_delta_start:
	defb 0fdh
	defb 0fdh
	defb 0fdh
	defb 0fdh
	defb 0feh
	defb 0feh
	defb 0feh
	defb 0feh
	defb 0feh
	defb 0ffh
	defb 0ffh
	defb 0ffh
	defb 0ffh
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 001h
	defb 001h
	defb 001h
	defb 001h
	defb 002h
	defb 002h
	defb 002h
	defb 002h
	defb 002h
	defb 003h
	defb 003h
edcb_delta_end:
pwd_stop:                         ; 0x68FB  wait EDCC=0xD8, then pose 0
	call pose_step
	ld a,(0edc9h)
	rra
	ret c
	ld hl,0edcch            ; ceremony Y
	inc (hl)
	ld a,(hl)
	cp 0d8h
	ret c
	xor a
	ld (0edd8h),a           ; walk pose
	ld a,010h
	jp pwd_delay
pwd_pose6:                        ; 0x6914  EDD8=6
	ld a,006h
pwd_pose_set:
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (0edd8h),a           ; walk pose
	ld a,010h
	jp pwd_delay
pwd_pose0:                        ; 0x6923  EDD8=0
	xor a
	jr pwd_pose_set
pwd_burst:                        ; 0x6926  8 sprites via sat_fx
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,008h
	call sat_fx
	jp pwd_next
pwd_idle:                         ; 0x6933  wait sat_fx (E880) empty
	call sat_fx_tick
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,020h
	jp pwd_delay
pwd_show:                         ; 0x6940
	ld hl,0e204h
	dec (hl)
	ret nz
pwd_card:                         ; 0x6945  file card (fire skip lands here)
	call scr_reset
	call spr_clear
	call sat_wipe
	ld bc,0a201h
	call WRTVDP
	ld de,05040h
	call pic_a358
	ld bc,0e201h            ; substate
	call WRTVDP
	ld hl,0ac01h                  ; str_pwd_best
	call print_12
	ld a,080h
	ld (0e204h),a
	ld a,00ah
	ld (0e257h),a           ; script index
	ret
pwd_done:                         ; 0x6971  E24A=1 (leave title file UI)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,001h
	ld (0e24ah),a
	ret
; generate + "pass word" + glyphs at EDD9
pwd_print:                        ; 0x697C  generate + "pass word" + glyphs at EDD9
	call pwd_gen
	ld a,0ffh
	ld (0ede1h),a
	ld hl,pwd_txt
	call print_stream
	ld de,05ca0h
	ld hl,0edd9h
	call print_at
	ret
; level/E240/R -> 8 glyphs at EDD9
pwd_gen:                          ; 0x6994  level/E240/R -> 8 glyphs at EDD9
	ld de,0ede2h
	ld a,(0e242h)           ; level
	ld (de),a
	inc de
	ld h,a
	ld a,(0e240h)           ; lives
	ld (de),a
	inc de
	ld l,a
	ld a,r
	ld (de),a
	ld c,a
	and 007h
	jr z,pwd_emit
	ld b,a
pwd_rot:
	rr h
	rr l
	jr nc,pwd_rot_nc
	set 7,h
pwd_rot_nc:
	or a
	djnz pwd_rot
pwd_emit:
	ld de,0edd9h
	ld a,h
	ld (0ede5h),a
	call pwd_hex
	ld h,l
	ld a,h
	ld (0ede6h),a
	call pwd_hex
	ld h,c
	ld a,h
	ld (0ede7h),a
	call pwd_hex
	ld hl,0ede5h
	ld a,(hl)
	inc hl
	add a,(hl)
	inc hl
	add a,(hl)
	inc hl
	ld (hl),a
	ld h,a
	call pwd_hex
	ret
; H as two glyphs -> (DE)+
pwd_hex:                        ; 0x69E0  H as two glyphs -> (DE)+
	ld a,h
	rrca
	rrca
	rrca
	rrca
	and 00fh
	call pwd_glyph
	ld (de),a
	inc de
	ld a,h
	and 00fh
	call pwd_glyph
	ld (de),a
	inc de
	ret
; nibble A -> glyph (0xE1/0xD1 +)
pwd_glyph:                      ; 0x69F5  nibble A -> glyph (0xE1/0xD1 +)
	ld b,0e1h
	cp 019h
	jr c,pwd_glyph_add
	ld b,0d1h
pwd_glyph_add:
	add a,b
	ret
pwd_txt:                          ; 0x69FF  print_stream "pass word"
	defb 058h, 090h         ; D,E
	TEXT "pass word"
	defb 0ffh               ; end
; password input (print_names 0xBE91)
pwd_enter:                        ; 0x6A0B  password input (print_names 0xBE91)
	call scr_reset
	call rle_minimap
	ld hl,0edd9h
	ld de,0eddah
	ld bc,00025h
	ld (hl),a
	ldir
	ld a,020h
	ld (0edeeh),a
	xor a
	ld (0e207h),a           ; key edges
	call page_bank_d
	ld hl,0be91h
	call print_stream
	jp page_banks_123
; wait E24A from password UI
pwd_enter_w:                      ; 0x6A32  wait E24A from password UI
	call spr_vram
	ld hl,0edebh
	ld a,(hl)
	or a
	jr z,pwd_idle_keys
	inc hl
	dec (hl)
	ret nz
	inc hl
	ld a,(hl)
	ld (0e24ah),a
	ld hl,0edebh
	ld (hl),000h
	ret
pwd_idle_keys:
	call pwd_cursor
	ld hl,0edefh
	ld a,(0e207h)           ; key edges
	rra
	rra
	rra
	jp c,pwd_slot_left
	rra
	jp c,pwd_slot_right
	call keys_snap
	call pwd_decode
	ld a,(0ededh)
	or a
	jr z,pwd_unpack_nib
	call pwd_type
pwd_unpack_nib:
	ld a,(0edf7h)
	rla
	ret c
	ld hl,0edd9h
	ld b,008h
pwd_nib_loop:
	ld a,(hl)
	ld d,0e1h
	cp d
	jr nc,pwd_nib_lo
	ld d,0d0h
pwd_nib_lo:
	sub d
	ld (hl),a
	inc hl
	djnz pwd_nib_loop
	call pwd_cheat
	jp z,pwd_ok
	ld hl,0edd9h
	ld b,007h
	ld a,(hl)
	inc hl
pwd_sum:
	add a,(hl)
	inc hl
	djnz pwd_sum
	or a
	jp z,pwd_bad
	ld hl,0edd9h
	ld b,008h
pwd_range:
	ld a,(hl)
	or a
	jr c,pwd_bad
	cp 010h
	jr nc,pwd_bad
	inc hl
	djnz pwd_range
	ld hl,0ede2h
	ld a,(hl)
	inc hl
	add a,(hl)
	inc hl
	add a,(hl)
	inc hl
	cp (hl)
	jr nz,pwd_bad
	ld hl,0edd9h
	ld de,0ede2h
	ld b,004h
pwd_pack:
	ld a,(hl)
	inc hl
	rlca
	rlca
	rlca
	rlca
	and 0f0h
	or (hl)
	inc hl
	ld (de),a
	inc de
	djnz pwd_pack
	ld hl,0ede2h
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld a,(hl)
	and 007h
	ld b,a
pwd_unrot:
	rl e
	rl d
	jr nc,pwd_unrot_nc
	set 0,e
pwd_unrot_nc:
	or a
	djnz pwd_unrot
	ld a,d
	cp 03dh
	jr nc,pwd_bad
	push de
	call play_clear
	pop de
	ld a,d
	or a
	jr z,pwd_bad
	ld (0e242h),a           ; level
	ld a,e
	or a
	jr z,pwd_bad
	ld (0e240h),a           ; lives
pwd_ok:
	ld hl,0edebh
	inc (hl)
	inc hl
	inc hl
	ld (hl),001h
	ld hl,0bebeh
	jr pwd_msg
pwd_bad:
	ld hl,0edebh
	inc (hl)
	inc hl
	inc hl
	ld (hl),002h
	ld hl,0beadh
pwd_msg:
	call page_bank_d
	call print_stream
	call page_banks_123
	call sat_wipe
	ld hl,0edebh
	inc (hl)
	inc hl
	ld (hl),080h
	ret
; FESTIVAL / TRYAGAIN 8-glyph cheats
pwd_cheat:                      ; 0x6B24  FESTIVAL / TRYAGAIN 8-glyph cheats
	ld de,pwd_fest
	call pwd_cmp
	jr z,pwd_fest_hit
	ld de,pwd_try
	call pwd_cmp
	ret nz
	call play_clear
	ld a,001h
	ld (0e217h),a
	xor a
	ret
pwd_fest_hit:
	call play_clear
	ld a,001h
	ld (0e255h),a
	xor a
	ret
; EDD9 vs 8 bytes at DE
pwd_cmp:                        ; 0x6B47  EDD9 vs 8 bytes at DE
	ld hl,0edd9h
	ld b,008h
pwd_cmp_loop:
	ld a,(de)
	sub 041h
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz pwd_cmp_loop
	xor a
	ret
; BLOCK 'pwd_fest' (start 0x6b57 end 0x6b5f)
pwd_fest:
	defb "FESTIVAL"
; BLOCK 'pwd_try' (start 0x6b5f end 0x6b67)
pwd_try:
	defb "TRYAGAIN"
; SAT at E800 for password slot
pwd_cursor:                     ; 0x6B67  SAT at E800 for password slot
	ld hl,0e800h            ; SAT
	ld (hl),06fh
	inc hl
	ld a,(0edefh)
	ld de,pwd_x
	call ADD_DE_A
	ld a,(de)
	ld (hl),a
	inc hl
	ld (hl),020h
	inc hl
	jp sat_col
pwd_slot_left:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
pwd_slot_right:
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp sfx_32
; SNSMAT snapshot -> glyph at EDED
pwd_decode:                     ; 0x6B8E  SNSMAT snapshot -> glyph at EDED
	ld a,(0edf0h)
	ld bc,008d0h
pwd_row0:
	rra
	jr nc,pwd_got
	inc c
	djnz pwd_row0
	ld a,(0edf1h)
	ld b,002h
pwd_row1:
	rra
	jr nc,pwd_got
	inc c
	djnz pwd_row1
	ld a,(0edf9h)
	ld b,005h
	ld c,0d0h
	rra
	rra
	rra
pwd_row9:
	rra
	jr nc,pwd_got
	inc c
	djnz pwd_row9
	ld a,(0edfah)
	ld b,005h
pwd_row10:
	rra
	jr nc,pwd_got
	inc c
	djnz pwd_row10
	jr pwd_graph
pwd_got:
	ld a,c
	jr pwd_store
pwd_graph:
	ld a,(0edf8h)
	rra
	jr c,pwd_letter
	ld a,0e0h
	jr pwd_store
pwd_letter:
	ld a,(0edf2h)
	ld d,0e2h
	rla
	jr nc,pwd_let_hit
	ld d,0e1h
	rla
	jr nc,pwd_let_hit
	ld hl,0edf3h
	ld d,0e3h
	ld c,003h
pwd_let_row:
	ld b,008h
	ld a,(hl)
pwd_let_bit:
	rra
	jr nc,pwd_let_hit
	inc d
	djnz pwd_let_bit
	inc hl
	dec c
	jr nz,pwd_let_row
	xor a
	jr pwd_store
pwd_let_hit:
	ld a,d
pwd_store:
	ld hl,0edeeh
	ld c,(hl)
	ld (hl),a
	cp c
	jr nz,pwd_edge
	xor a
pwd_edge:
	ld (0ededh),a
	ret
; stamp decoded glyph into EDD9
pwd_type:                       ; 0x6C01  stamp decoded glyph into EDD9
	ld a,(0edefh)
	ld hl,pwd_x
	call ADD_HL_A
	ld d,(hl)
	ld e,070h
	ld a,(0ededh)
	call tile_hmmm_at
	ld a,(0edefh)
	ld hl,0edd9h
	call ADD_HL_A
	ld a,(0ededh)
	ld (hl),a
	ld hl,0edefh
	jp pwd_slot_right
; BLOCK 'pwd_x' (start 0x6c26 end 0x6c2e)
pwd_x:
	defb 060h, 068h, 070h, 078h, 080h, 088h, 090h, 098h
; SNSMAT rows 0-10 -> EDFA..
keys_snap:                      ; 0x6C2E  SNSMAT rows 0-10 -> EDFA..
	ld hl,0edfah
	ld b,00bh
keys_snap_loop:
	ld a,b
	dec a
	call SNSMAT
	ld (hl),a
	dec hl
	djnz keys_snap_loop
	ret
; disk_load with H.TIMI = RET.
disk_do_load:                     ; 0x6C3D
	ld a,(0fd9fh)                 ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	call disk_buf
	call disk_load
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ret
; disk_save with H.TIMI = RET.
disk_do_save:                     ; 0x6C55
	ld a,(0fd9fh)                 ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	call disk_buf
	call disk_save
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ret
; BLOCK 'save_map' (start 0x6c6d end 0x6c85)  RAM addr, length (6 chunks)
save_map:
	defw 0e243h, 00001h
	defw 0e25ch, 00023h
	defw 0e282h, 00003h
	defw 0e2c0h, 00240h
	defw 0e600h, 00200h
	defw 0e900h, 004c0h
; password + slot id into EE00 FCB
disk_buf:                       ; 0x6C85  password + slot id into EE00 FCB
	ld hl,0e270h            ; tape name
	ld de,0ee00h
	ld (0f0e0h),de
	ld bc,00005h
	ldir
	ld de,0ee05h
	xor a
	ld b,008h
disk_buf_pad:
	ld (de),a
	inc de
	djnz disk_buf_pad
	inc de
	inc de
	inc de
	inc de
	ld a,(0f0e9h)           ; cart slot
	ld (de),a
	ret
; disk-ROM 8000: open/read/close
disk_load:                      ; 0x6CA7  disk-ROM 8000: open/read/close
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,000h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,002h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	ld b,006h
	ld hl,save_map
disk_read_chunk:
	push bc
	ld de,0ee0dh
	ld bc,00004h
	ldir
	push hl
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,009h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	pop hl
	pop bc
	or a
	jp nz,disk_abort
	djnz disk_read_chunk
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,001h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	or a
	jp nz,disk_abort
	xor a
	ld (0e27fh),a           ; I/O error
	ret
; disk-ROM 8000: create/write/close
disk_save:                      ; 0x6D57  disk-ROM 8000: create/write/close
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,000h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,002h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	ld b,006h
	ld hl,save_map
disk_write_chunk:
	push bc
	ld de,0ee0dh
	ld bc,00004h
	ldir
	push hl
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,008h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	pop hl
	pop bc
	djnz disk_write_chunk
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,001h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	or a
	jr nz,disk_fail
	xor a
	ld (0e27fh),a           ; I/O error
	ret
disk_abort:
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,006h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
disk_fail:
	ld a,002h
	ld (0e27fh),a           ; I/O error
	ret
; BLOCK 'str_file' (start 0x6E28 end 0x6E2D)
str_file:                         ; 0x6E28  FCB name
	defb "FILE?"
; Catalog FCB FILE? (H.TIMI off).
disk_dir:                         ; 0x6E2D
	di
	ld a,(0fd9fh)           ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	ld hl,0ee50h            ; E300 list / tape
	ld de,0ee51h
	ld bc,00020h
	ld (hl),000h
	ldir
	ld hl,str_file
	ld de,0ee00h
	ld bc,00005h
	ldir
	ld hl,0ee50h            ; E300 list / tape
	ld (0ee0dh),hl
	ld de,0ee00h
	ld (0f0e0h),de
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,003h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	and a
	jr nz,disk_dir_done
disk_dir_next:
	ld hl,(0ee0dh)
	ld a,008h
	call ADD_HL_A
	ld (0ee0dh),hl
	ld a,(0f0f7h)
	ld h,080h
	call 00024h             ; ENASLT
	ld a,004h
	ld (08000h),a
	ld c,004h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)           ; cart slot
	ld h,080h
	call 00024h             ; ENASLT
	pop af
	jr z,disk_dir_next
disk_dir_done:
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ei
	xor a
	ld (0f0e5h),a           ; catalog count
	ld de,0ee50h            ; E300 list / tape
disk_dir_scan:
	ld a,(de)
	or a
	ret z
	push de
	ld a,(de)
	cp 046h
	jr nz,disk_dir_skip
	inc de
	ld a,(de)
	cp 049h
	jr nz,disk_dir_skip
	inc de
	ld a,(de)
	cp 04ch
	jr nz,disk_dir_skip
	inc de
	ld a,(de)
	cp 045h
	jr z,disk_dir_file
disk_dir_skip:
	pop de
disk_dir_step:
	ld a,008h
	call ADD_DE_A
	jr disk_dir_scan
disk_dir_file:
	pop de
	ld hl,0f0e5h            ; catalog count
	inc (hl)
	ld a,(hl)
	cp 003h
	ret nc
	jr disk_dir_step
; F0F9: bit 0 = PHYDIO present, bit 1 = disk ROM.
io_probe:                         ; 0x6EEA
	ld b,000h
	ld a,(0ffa7h)                 ; H.PHYD
	cp 0c9h
	jr z,io_probe_phy
	inc b
io_probe_phy:
	push bc
	call disk_find
	pop bc
	ld a,(0f0f7h)
	inc a
	jr z,io_probe_set
	set 1,b
io_probe_set:
	ld a,b
	ld (0f0f9h),a           ; io present
	ret
; scan slots for disk ROM (YZ header)
disk_find:                      ; 0x6F06  scan slots for disk ROM (YZ header)
	ld bc,00400h
	ld hl,0fcc1h            ; EXPTBL
disk_find_slot:
	push bc
	push hl
	ld a,(hl)
	bit 7,a
	jr nz,disk_find_exp
	ld a,c
	call disk_yz
	jr disk_find_next
disk_find_exp:
	call disk_exp
disk_find_next:
	pop hl
	pop bc
	ret c
	inc hl
	inc c
	djnz disk_find_slot
	ld a,0ffh
	ld (0f0f7h),a
	ret
; probe expanded slot 4 subslots
disk_exp:                       ; 0x6F29  probe expanded slot 4 subslots
	and 080h
	or c
	ld b,004h
disk_exp_loop:
	push bc
	call disk_yz
	pop bc
	ret c
	add a,004h
	djnz disk_exp_loop
	ret
; RDSLT 4010/4011 == 'Y''Z'
disk_yz:                        ; 0x6F39  RDSLT 4010/4011 == 'Y''Z'
	ld (0f0f7h),a
	ld hl,04010h
	call 0000ch             ; RDSLT
	cp 059h
	jr nz,disk_yz_no
	ld hl,04011h
	ld a,(0f0f7h)
	call 0000ch             ; RDSLT
	cp 05ah
	jr nz,disk_yz_no
	ld a,(0f0f7h)
	scf
	ret
disk_yz_no:
	ld a,(0f0f7h)
	and a
	ret
; mode_world: E257-1 -> d_6f6b
world_tick:                       ; 0x6F5D  mode_world: E257-1 -> d_6f6b
	call world_script
	jp spr_vram
; world ceremony: E257-1 -> d_6f6b
world_script:                     ; 0x6F63
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)           ; script index
	dec a
	call DISPATCH_A

; BLOCK 'd_6f6b_jp' (start 0x6f6e end 0x6f84)  world-complete script (1-based)
d_6f6b_jp_start:
	defw world_scr
	defw world_hold
	defw world_tour
	defw world_pic0
	defw world_pic1
	defw world_pic2
	defw world_out
	defw world_count
	defw world_sat
	defw world_in
	defw world_exit
d_6f6b_jp_end:
world_scr:                        ; 0x6F84  map gfx, palette, start XY
	call vdp_fill
	ld bc,00007h
	call vdp_wr
	call page_banks_ef
	ld hl,0a870h
	call palette_list
	call page_banks_123
	call blit_902e
	call tiles_wmap
	call sat_wipe
	call strm_hallway
	ld hl,world_xy
	call world_pos
	xor a
	ld (0edc8h),a
	call scr_reset
	ld bc,0a201h
	call WRTVDP
	call pic_a358_at
	call copy_af21
	call world_far
	ld bc,0e201h            ; substate
	call WRTVDP
	call sfx_0d                   ; world-map BGM
	ld a,03ch
; wait A frames in E204
world_delay:
	ld hl,0e204h
	ld (hl),a
world_next:
	ld hl,0e257h            ; script index
	inc (hl)
	ret
; word[world-1] at HL -> EDCB/EDCC
world_pos:                        ; 0x6FD5  word[world-1] at HL -> EDCB/EDCC
	ld a,(0e241h)           ; world
	dec a
	add a,a
	call ADD_HL_A
	ld de,0edcbh            ; ceremony X
	ldi
	ldi
	ret
world_hold:                       ; 0x6FE5
	call world_far
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	ld (0edd8h),a           ; walk pose
	inc a
	ld (0edceh),a
	call print_world
	ld a,008h
	jp world_delay
world_tour:                       ; 0x6FFD  walk map; E207 0x30 skips to world_xy2
	ld a,(0e207h)           ; key edges
world_tour_keys:
	and 030h
	jr z,world_tour_walk
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,world_xy2
	call world_pos
	call world_hold8
	jp tour_far
world_tour_walk:
	call world_step
	jp tour_far
; tour pose + path + move
world_step:                     ; 0x701B  tour pose + path + move
	ld b,007h
	call world_pose
	ld a,(0edceh)
	cp 007h
	ld a,(0edd8h)           ; walk pose
	call z,world_blit
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),008h
	call world_path
	call world_done
	jr z,world_hold8
	call world_delta
	ld hl,0edc8h
	inc (hl)
	ret
; A=8 -> world_delay
world_hold8:                    ; 0x7042  A=8 -> world_delay
	ld a,008h
	jp world_delay
world_pic0:                       ; 0x7047  stamp wpic0
	ld b,007h
	call world_pose
	ld hl,0e204h
	dec (hl)
	jp nz,tour_far
	xor a
	call world_blit
	call wpic0
world_pic_done:
	ld a,008h
	call world_delay
	jp tour_far
world_pic1:                       ; 0x7062  stamp wpic1
	ld b,007h
	call world_pose
	ld hl,0e204h
	dec (hl)
	jp nz,tour_far
	ld a,001h
	call world_blit
	call wpic1
	jr world_pic_done
world_pic2:                       ; 0x7078  stamp wpic2, then overlay
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	call world_blit
	call wpic2
	call vdp_fill
	call strm_a642
	jp world_next
world_out:                        ; 0x708D  EDC8=6, start shrink
	ld a,006h
	ld (0edc8h),a
	call world_shrink
	ld a,010h
	jp world_delay
world_count:                      ; 0x709A  shrink EDC8; 4 sprites at 0
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),010h
	ld hl,0edc8h
	dec (hl)
	ld a,(hl)
	cp 005h
	push hl
	call z,sfx_3e
	pop hl
	ld a,(hl)
	cp 0ffh
	jp nz,world_shrink
	ld (hl),000h
	ld a,004h
	call sat_fx
	jp world_next
world_sat:                        ; 0x70BD  wait sat_fx (E880) empty
	call sat_fx_tick
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call sat_wipe
	ld a,010h
	jp world_delay
world_in:                         ; 0x70CD  grow EDC8 to 7
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),010h
	ld hl,0edc8h
	inc (hl)
	ld a,(hl)
	dec a
	push hl
	call z,sfx_3e
	pop hl
	ld a,(hl)
	cp 006h
	call z,sfx_25
	ld a,(hl)
	cp 007h
	jp nz,world_shrink
	call sfx_83
	ld a,0c0h
	jp world_delay
world_exit:                       ; 0x70F3  E257=0; copy pyramid tiles
	ld hl,0e204h
	dec (hl)
	ret nz
	call sfx_82
	call sfx_01                   ; stop
	xor a
	ld (0e257h),a           ; script index
	call scr_reset
	jp wmap_font
; HMMM 96×128 hallway: pose0 (0,40) / pose1 (96,40) → (136,40)
world_blit:                     ; 0x7108  HMMM hallway; A=0 hallway0 else hallway1
	ld hl,00040h                  ; stamp_hallway0
	or a
	jr z,world_hmmm
	ld h,060h                     ; stamp_hallway1
world_hmmm:
	ld de,08828h
	ld bc,06080h
	ld a,001h
	jp vdp_hmmm
; HMMM shrink tiles for count-down
world_shrink:                   ; 0x711B  HMMM shrink tiles for count-down
	push af
	ld hl,06040h                  ; HMMM src XY (not the SAT template)
	ld de,0a030h
	ld bc,03070h
	ld a,001h
	call vdp_hmmm
	pop af
	ld hl,09040h
	rla
	rla
	rla
	and 0f8h
	add a,040h
	ld e,a
	ld d,0a0h
	ld bc,03030h
	ld a,001h
	jp vdp_hmmm
; EDCA 1 inc Y / 2 dec X / 3 inc X / 4 dec Y
world_delta:                    ; 0x7140  EDCA 1 inc Y / 2 dec X / 3 inc X / 4 dec Y
	ld hl,0edcbh            ; ceremony X
	ld a,(0edcah)
	dec a
	jr z,world_inc_y              ; 1: Y++
	dec a
	jr z,world_dec_x              ; 2: X--
	dec a
	jr z,world_inc_x              ; 3: X++
	dec (hl)                      ; 4: Y--
	ret
world_inc_y:
	inc (hl)
	ret
world_dec_x:
	inc hl
	dec (hl)
	ret
world_inc_x:
	inc hl
	inc (hl)
	ret
; toggle EDD8 every B frames
world_pose:                     ; 0x7159  toggle EDD8 every B frames
	ld hl,0edceh
	dec (hl)
	ret nz
	ld (hl),b
	ld a,(0edd8h)           ; walk pose
	xor 003h
	ld (0edd8h),a           ; walk pose
	ret
; Z if EDC8 == world_len[world]
world_done:                     ; 0x7168  Z if EDC8 == world_len[world]
	ld a,(0e241h)           ; world
	dec a
	ld hl,world_len
	call ADD_HL_A
	ld a,(0edc8h)
	cp (hl)
	ret
; BLOCK 'world_len' (start 0x7177 end 0x717c)  tour steps; [5]=CDh overlaps world_path
world_len:
	defb 058h
	defb 0b8h
	defb 088h
	defb 08eh
	defb 095h
; page D; path byte -> EDCA
world_path:                     ; 0x717C  page D; path byte -> EDCA
	call page_bank_d
	call world_path_d
	jp page_banks_123
; ba57 tour path for this world
world_path_d:                   ; 0x7185  ba57 tour path for this world
	ld hl,0ba57h
	ld a,(0e241h)           ; world
	dec a
	call tbl_word
	ld d,h
	ld e,l
	ld a,(0edc8h)
	ld b,a
world_path_scan:
	ld a,(de)
	cp 0ffh
	ret z
	inc de
	cp b
	jr z,world_path_hit
	inc de
	jr world_path_scan
world_path_hit:
	ld a,(de)
	ld (0edcah),a
	ret
; print_stream world_txt[E241-1]
print_world:                      ; 0x71A5  print_stream world_txt[E241-1]
	call page_bank_c
	ld hl,0ac13h                  ; world_txt (bank 0C MODULE)
	ld a,(0e241h)           ; world
	dec a
	call tbl_word
	call print_stream
	jp page_banks_123
tour_far:                         ; 0x71B8  page C tour_sat, back to 123
	call page_bank_c
	call 0bdd7h                   ; tour_sat (bank 0C MODULE)
	jp page_banks_123
; page C tour_vic, back to 123
world_far:                        ; 0x71C1  page C tour_vic, back to 123
	call page_bank_c
	call 0bddah                   ; tour_vic (bank 0C MODULE)
	jp page_banks_123
; BLOCK 'world_xy' (start 0x71ca end 0x71d4)  start XY per world; [5] overlaps world_xy2
world_xy:
	defb 02bh, 04eh
	defb 03bh, 02eh
	defb 063h, 030h
	defb 066h, 053h
	defb 053h, 05eh
; BLOCK 'world_xy2' (start 0x71d4 end 0x71de)  skip-tour XY; [5]=1157h overlaps clear_tick
world_xy2:
	defb 03bh, 038h
	defb 05eh, 02bh
	defb 06bh, 04eh
	defb 04eh, 063h
	defb 048h, 046h
; mode_clear: E257-1 -> d_71e3
clear_tick:                       ; 0x71DE  mode_clear: E257-1 -> d_71e3
	ld de,0e257h            ; script index
	ld a,(de)
	dec a
	call DISPATCH_A

; BLOCK 'd_71e3_jp' (start 0x71e6 end 0x71f6)  stage-clear script (1-based)
d_71e3_jp_start:
	defw clear_door
	defw clear_walk
	defw clear_wipe
	defw clear_card
	defw clear_score
	defw clear_pwd
	defw clear_key
	defw clear_done
d_71e3_jp_end:
clear_door:                       ; 0x71F6  open exit (E2F0) then draw_exit
	ld a,(0e2f0h)
	cp 001h
	jr z,clear_open
	jr nc,clear_opened
clear_open:
	ld hl,0e2f7h
	dec (hl)
	ret nz
	ld (hl),01eh
	dec hl
	inc (hl)
	ld hl,0e2f0h
	inc (hl)
	jp draw_exit
clear_opened:
	ld hl,0e2f7h
	dec (hl)
	ret nz
	ld hl,0e257h            ; script index
	inc (hl)
	inc hl
	ld (hl),000h
	inc hl
	ld (hl),020h
	ret
clear_walk:                       ; 0x721F  Vic left 4 frames; SAT from clear_spr
	ld hl,0e259h
	dec (hl)
	jr nz,clear_walk_sat
	ld (hl),020h
	dec hl
	inc (hl)
	ld a,(hl)
	cp 004h
	jp nc,clear_walk_done
	inc hl
clear_walk_sat:
	ld a,(hl)
	and 00fh
	jr nz,clear_walk_spr
clear_walk_up:
	ld de,0e282h            ; Vic Y
	ld a,(de)
	sub 002h
	ld (de),a
clear_walk_spr:
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 001h
	ld c,a
	ld a,(0e258h)
	add a,a
	add a,c
	add a,a
	add a,a
	add a,a
	add a,a
	ld c,a
	ld hl,clear_spr
	ld de,0e800h            ; SAT
	ld b,004h
	exx
	ld hl,0d200h            ; boot spare
	exx
clear_spr_loop:
	ld a,(0e282h)           ; Vic Y
	add a,(hl)
	ld (de),a
	inc hl
	inc de
	ld a,(0e284h)           ; Vic X
	ld (de),a
	inc de
	ld a,c
	ld (de),a
	ld a,c
	add a,004h
	ld c,a
	inc de
	inc de
	ld a,(hl)
	inc hl
	exx
	ld d,h
	ld e,l
	inc de
	ld bc,0000fh
	ld (hl),a
	ldir
	inc hl
	exx
	djnz clear_spr_loop
	ret
; BLOCK 'clear_spr' (start 0x7280 end 0x7288)  4 SAT (Y offset, pattern)
clear_spr:
	defb 0f8h, 00dh
	defb 0f8h, 04eh
	defb 008h, 00dh
	defb 008h, 04eh
clear_walk_done:
	call sat_wipe
	ld hl,0e257h            ; script index
	inc (hl)
	inc hl
	ld (hl),000h
	inc hl
	ld (hl),004h
	ret
clear_wipe:                       ; 0x7296  erase 12 columns from both edges
	ld hl,0e259h
	dec (hl)
	ret nz
	ld a,(0e258h)
	ld c,a
	add a,a
	add a,a
	add a,a
	ld e,a
	push bc
	call clear_blank
	pop bc
	ld a,017h
	sub c
	add a,a
	add a,a
	add a,a
	ld e,a
	call clear_blank
	ld hl,0e258h
	inc (hl)
	ld a,(hl)
	inc hl
	ld (hl),004h
	cp 00ch
	ret c
	ld hl,0e800h            ; SAT
	ld b,002h
clear_lift:
	ld a,(hl)
	sub 010h
	ld (hl),a
	ld a,004h
	call ADD_HL_A
	djnz clear_lift
	ld hl,0e257h            ; script index
	inc (hl)
	ret
; stamp 32 empty tiles across X
clear_blank:                    ; 0x72D2  stamp 32 empty tiles across X
	ld b,020h
	ld d,000h
clear_blank_loop:
	xor a
	call tile_hmmm_at
	ld a,d
	add a,008h
	ld d,a
	djnz clear_blank_loop
	ret
clear_card:                       ; 0x72E1  next level; "rest" + score
	ld hl,0e242h            ; level
	inc (hl)
	xor a
	ld (0e249h),a
	call scr_reset
	call page_bank_c
	ld hl,0b256h                  ; str_clear_card
	call print_stream
	call page_banks_123
	ld c,0ffh
	ld hl,txt_rest
	ld de,edc0_jp_end+1
	call print_at
	ld de,08868h
	call print_lives_at
	ld a,03ch
clear_delay:
	ld (0e204h),a
	ld hl,0e257h            ; script index
	inc (hl)
	ret
clear_score:                      ; 0x7313  BCD-inc E240 (cap 0x99)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0e240h            ; lives
	ld a,(hl)
	cp 099h
	jr nc,clear_score_put
	add a,001h
	daa
	ld (hl),a
clear_score_put:
	ld de,08868h
	push hl
	call print_lives_at
	pop hl
	inc (hl)
	ld a,078h
	jr clear_delay
clear_pwd:                        ; 0x7331  show generated password
	ld hl,0e204h
	dec (hl)
	ret nz
	call pwd_print
	jr clear_delay
clear_key:                        ; 0x733B  wait any rising key
	ld a,(0e207h)           ; key edges
	and a
	ret z
	jr clear_delay
clear_done:                       ; 0x7342  E257=0 (mode_clear advances)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0e257h            ; script index
	ld (hl),000h
	ret
; mode_endtxt: E257-1 -> d_735f (65)
end_tick:                         ; 0x734D  mode_endtxt: E257-1 -> d_735f (65)
	call end_script
	jp spr_vram
; ending: E257-1 -> d_735f
end_script:                       ; 0x7353
	ld hl,0edc9h
	inc (hl)
	call sat_fx_tick
	ld de,0e257h            ; script index
	ld a,(de)
	dec a
	call DISPATCH_A

; BLOCK 'd_735f_jp' (start 0x7362 end 0x73e4)  ending ceremony; E257 1-based
d_735f_jp_start:
	defw end_boot
	defw end_wait0
	defw end_fx3
	defw end_scr1
	defw end_txt2
	defw end_idle
	defw end_fx3b
	defw end_scr2
	defw end_pic2
	defw end_wait2
	defw end_timer
	defw end_stamp
	defw end_fx1
	defw end_scr3
	defw end_txt3
	defw end_key
	defw end_flash
	defw end_txt4
	defw end_wait3
	defw end_fx3c
	defw end_cols
	defw end_wait4
	defw end_spawn
	defw end_swait
	defw end_txt5
	defw end_swait2
	defw end_pose
	defw end_walk
	defw end_clear
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_pclr
	defw end_page
	defw end_pwait
	defw end_pfx
	defw end_done
d_735f_jp_end:
end_boot:                         ; 0x73E4  map tiles, sat_fx 0Ah, print 0xACC3
	call scr_reset
	call pal_black
	call sat_wipe
	call tiles_wmap
	ld a,00ah
	call sat_fx
	ld hl,0acc3h                  ; str_end_boot
	call print_12
	jr end_next
end_wait0:                        ; 0x73FD  wait sat_fx, delay 0xF0
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,0f0h
	jr end_delay
end_fx3:                          ; 0x7406
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sat_fx
	jr end_next
end_scr1:                         ; 0x7412  blit_9043 + copy_ab59 + pic
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call scr_reset
	call pal_black
	call blit_9043
	call copy_ab59
	call sat_wipe
	ld bc,0a201h
	call WRTVDP
	ld de,05010h
	call pic_a358
	ld a,009h
	call sat_fx
	ld bc,0e201h            ; substate
	call WRTVDP
	call sfx_12                   ; ending
end_next:                         ; 0x7440  inc E257
	ld hl,0e257h            ; script index
	inc (hl)
	ret
end_txt2:                         ; 0x7445  print 0xAD12, sat_fx 0Ah
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld hl,0ad12h                  ; str_end_txt2
	call print_12
	ld a,00ah
	call sat_fx
	jr end_next
end_idle:                         ; 0x7457  wait sat_fx, delay 0
	ld a,(0e880h)           ; sat_fx
	and a
	ret nz
; A → E204, then end_next
end_delay:                        ; 0x745C  A → E204, then end_next
	ld hl,0e204h
	ld (hl),a
	jr end_next
end_fx3b:                         ; 0x7462
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sat_fx
	jp end_next
end_scr2:                         ; 0x746F  blit_9063, bank12 0xBC6E
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call scr_reset
	call scr_reset
	call blit_9063
	ld de,07707h
	ld a,005h
	call palette_set
	call page_bank_c
	call 0bc6eh                   ; spark_init (bank 0C MODULE)
	call page_banks_123
	call spark_far
	ld a,060h
	jp end_delay
end_pic2:                         ; 0x7496  sat_fx 0, pic_a2c8
	call spark_far
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	call sat_fx
	ld bc,0a201h
	call WRTVDP
	ld de,05020h
	call pic_a2c8
	ld bc,0e201h            ; substate
	call WRTVDP
	jp end_next
end_wait2:                        ; 0x74B7
	call spark_far
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,0a0h
	jr end_delay
end_timer:                        ; 0x74C3  E902 at t=30
	ld hl,0e204h
	dec (hl)
	jr z,end_timer_done
	ld a,(hl)
	cp 030h
	call z,end_flag
	jp spark_far
; E902=1 (spark spawn enable)
end_flag:                       ; 0x74D2  E902=1 (spark spawn enable)
	ld a,001h
	ld (0e902h),a
	ret
end_timer_done:
	xor a
	ld (0edceh),a
	ld a,050h
	jp end_delay
end_stamp:                        ; 0x74E1  bank12 0xAF37 stamps
	call spark_far
	ld hl,0e204h
	dec (hl)
	jr z,end_stamp_done
	ld a,(hl)
	and 007h
	ret nz
	call page_bank_c
	ld hl,0af37h                  ; end_stamp_tbl
	ld a,(0edceh)
	ld b,a
	add a,a
	add a,b
	call ADD_HL_A
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld a,(hl)
	call tile_pset
	ld hl,0edceh
	inc (hl)
	call page_banks_123
	jp sfx_3d
end_stamp_done:
	ld a,090h
	jp end_delay
end_fx1:                          ; 0x7514
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,001h
	call sat_fx
	jp end_next
end_scr3:                         ; 0x7521  pal_a8bb, blit_9069, pic_a702
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call scr_reset
	call scr_reset
	call spr_clear
	call pal_a8bb
	call blit_9069
	call sat_wipe
	ld bc,0a201h
	call WRTVDP
	ld de,05020h
	call pic_a702
	call strm_a6e0
	ld bc,0e201h            ; substate
	call WRTVDP
	ld hl,0ad69h                  ; str_end_danger
	call print_12
	ld a,080h
	call end_delay
	jp sfx_37
end_txt3:                         ; 0x755B  print 0xAD58
	call pal_blink_a
	call pal_blink_c
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0ad58h                  ; str_end_key
	call print_12
	jp end_next
end_key:                          ; 0x756F  fire/space, then blit
	call pal_blink_a
	ld a,(0e208h)           ; keys held
	and 030h
	ret z
	ld de,03000h
	ld a,00ah
	call palette_set
	ld de,00406h
	ld a,006h
	call palette_set
	ld hl,08848h
	ld de,08838h
	ld bc,01838h
	ld a,001h
	call vdp_hmmm
	ld hl,048b0h
	ld de,008a0h
	xor a
	call vdp_ymmm
	xor a
	call end_delay
	jp sfx_39
end_flash:                        ; 0x75A7  border flash via end_flash_border
	ld hl,0e204h
	dec (hl)
	ld a,(hl)
	or a
	jr z,end_flash_done
	cp 080h
	jp c,end_flash_border
	jp z,sfx_3a
	ret
end_flash_done:
	ld bc,00007h
	call WRTVDP
	call scr_reset
	call pal_black
	ld a,078h
	jp end_delay
end_txt4:                         ; 0x75C9  print 0xAEDD
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0aeddh                  ; str_end_txt5
	call print_12
	ld a,00ah
	call sat_fx
	jp end_next
end_wait3:                        ; 0x75DC
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	jp end_delay
end_fx3c:                         ; 0x75E4
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sat_fx
	jp end_next
end_cols:                         ; 0x75F1  sat_fx 2, draw_cols 0Fh
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call scr_reset
	ld a,002h
	call sat_fx
	ld a,00fh
	call draw_cols
	call sfx_0e                   ; ending
	jp end_next
end_wait4:                        ; 0x7609
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,020h
	jp end_delay
end_spawn:                        ; 0x7613  Vic-like XY, sat_fx 6
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,09fh
	ld (0edcbh),a           ; ceremony X
	ld a,080h
	ld (0edcch),a           ; ceremony Y
	xor a
	ld (0edd8h),a           ; walk pose
	ld (0edceh),a
	call cer_sat
	ld a,006h
	call sat_fx
	jp end_next
end_swait:                        ; 0x7634
	call cer_sat
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,030h
	jp end_delay
end_txt5:                         ; 0x7641  print 0xAF21, pose 4
	call cer_sat
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,004h
	ld (0edd8h),a           ; walk pose
	ld hl,0af21h                  ; str_end_congrats
	call print_12
	ld a,00bh
	call sat_fx
	jp end_next
end_swait2:                       ; 0x765C
	call cer_sat
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	ld a,0b4h
	jp end_delay
end_pose:                         ; 0x7669  pose 2
	call cer_sat
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,002h
	ld (0edd8h),a           ; walk pose
	jp end_next
end_walk:                         ; 0x7679  walk until EDCC=30h, sat_fx 7
	call pose_step
	ld hl,0edc9h
	ld a,(hl)
	and 003h
	jp nz,cer_sat
	ld hl,0edcch            ; ceremony Y
	dec (hl)
	ld a,(hl)
	cp 030h
	jp nc,cer_sat
	ld a,007h
	call sat_fx
	jp end_next
end_clear:                        ; 0x7697  wipe, EDCF=0, delay 8 → pages
	call pose_step
	ld hl,0edc9h
	ld a,(hl)
	and 003h
	jp nz,end_clear_sat
	ld hl,0edcch            ; ceremony Y
	dec (hl)
end_clear_sat:
	ld a,(0e880h)           ; sat_fx
	or a
	jp nz,cer_sat
	call scr_reset
	call sat_wipe
	xor a
	ld (0edcfh),a
	ld a,008h
	jp end_delay
end_page:                         ; 0x76BD  print_stream[EDCF], sat_fx 0Ah
	ld hl,0e204h
	dec (hl)
	ret nz
	call end_print_i
	ld hl,0edcfh
	inc (hl)
	ld a,00ah
	call sat_fx
	jp end_next
end_pwait:                        ; 0x76D1
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	jp end_delay
end_pfx:                          ; 0x76D9  sat_fx 3 if EDCF<9
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,(0edcfh)
	cp 009h
	ld a,003h
	call c,sat_fx
	jp end_next
end_pclr:                         ; 0x76EB
	ld a,(0e880h)           ; sat_fx
	or a
	ret nz
	call scr_reset
	ld a,020h
	jp end_delay
end_done:                         ; 0x76F8  fire/space → E257=0
	ld a,(0e208h)           ; keys held
	and 030h
	ret z
	sub a
	ld (0e257h),a           ; script index
	ret
; page 12 spark_tick
spark_far:                        ; 0x7703  page 12 spark_tick
	call page_bank_c
	call 0bcd2h                   ; spark_tick (bank 0C MODULE)
	jp page_banks_123
end_flash_border:
	ld a,(0edc9h)
	rra
	rra
	ld bc,00007h
	jp c,WRTVDP
	ld b,00bh
	jp WRTVDP
; print_stream with bank 0C paged
print_12:                         ; 0x771C  print_stream with bank 0C paged
	call page_bank_c
	call print_stream
	jp page_banks_123
; print_stream ad76_tbl[EDCF]
end_print_i:                      ; 0x7725  print_stream ad76_tbl[EDCF]
	call page_bank_c
	ld a,(0edcfh)
	ld hl,0ad76h                  ; ad76_tbl
	call tbl_word
	call print_stream
	jp page_banks_123
; pal 0x0A from EDC9 bit 4
pal_blink_a:                      ; 0x7737  pal 0x0A from EDC9 bit 4
	ld a,(0edc9h)
	rra
	rra
	rra
	rra
	ld de,03000h
	jr c,pal_blink_a_set
	ld de,07101h
pal_blink_a_set:
	ld a,00ah
	jp palette_set
; pal 0x0C from E204 bit 2
pal_blink_c:                      ; 0x774B  pal 0x0C from E204 bit 2
	ld a,(0e204h)
	rra
	rra
	ld de,07000h                  ; GRB
	jr c,pal_blink_c_set
	ld de,00007h
pal_blink_c_set:
	ld a,00ch
	jp palette_set
; palettes A=B+1, B=16..1 → 0000h
pal_black:                        ; 0x775D  palettes A=B+1, B=16..1 → 0000h
	ld b,010h
pal_black_loop:
	ld a,b
	inc a
	ld de,00000h
	call palette_set
	djnz pal_black_loop
	ret
; every 16 frames: EDCE++, EDD8 from pose_tbl
pose_step:                        ; 0x776A  every 16 frames: EDCE++, EDD8 from pose_tbl
	ld a,(0edc9h)
	and 00fh
	ret nz
	ld hl,0edceh
	inc (hl)
	ld a,(hl)
	and 003h
	ld hl,pose_tbl
	call ADD_HL_A
	ld a,(hl)
	ld (0edd8h),a           ; walk pose
	ret
pose_tbl:                         ; 0x7782  walk poses 1,2,3,2
	defb 001h, 002h, 003h, 002h
; 2x2 SAT at EDCB/EDCC, pose EDD8
cer_sat:                          ; 0x7786  2x2 SAT at EDCB/EDCC, pose EDD8
	ld hl,0e800h            ; SAT
	exx
	ld de,pose_pat
	ld a,(0edd8h)           ; walk pose
	add a,a
	add a,a
	call ADD_DE_A
	exx
	ld a,(0edcbh)           ; ceremony X
	ld e,a
	ld a,(0edcch)           ; ceremony Y
	ld d,a
	call cer_pair
	ld a,e
	add a,010h
	ld e,a
	call cer_pair
	jp sat_cc_fill                   ; SAT colour fill 0x0D/0x4E
; two SAT entries (Y,X,pat) at DE
cer_pair:                         ; 0x77AB  two SAT entries (Y,X,pat) at DE
	ld b,002h
cer_pair_loop:
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	exx
	ld a,(de)
	inc de
	exx
	ld (hl),a
	inc hl
	inc hl
	djnz cer_pair_loop
	ret
pose_pat:                         ; 0x77BB  7×4 sprite pats; cer_sat uses EDD8×4
	defb 000h, 004h, 008h, 00ch
	defb 010h, 014h, 028h, 02ch
	defb 018h, 01ch, 030h, 034h
	defb 020h, 024h, 038h, 03ch
	defb 060h, 064h, 068h, 06ch
	defb 040h, 044h, 048h, 04ch
	defb 050h, 054h, 058h, 05ch
; A = script; load from bank 0E/0F 0xA792 → E880
sat_fx:                           ; 0x77D7  A = script; load from bank 0E/0F 0xA792 → E880
	call page_banks_ef
	ld hl,0e880h            ; sat_fx
	ld de,0e881h            ; sat_fx phase
	ld (hl),000h
	ld bc,00027h
	ldir
	ld l,a
	ld h,000h
	ld e,a
	ld d,h
	add hl,hl
	add hl,hl
	add hl,de
	ld de,0a792h
	add hl,de
	push hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld de,0e887h
	ld bc,00020h
	ldir
	pop hl
	inc hl
	inc hl
	push hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld (0e884h),hl
	pop hl
	inc hl
	inc hl
	ld a,(hl)
	ld (0e883h),a
	ld (0e882h),a
	ld hl,0e880h            ; sat_fx
	inc (hl)
	jp page_banks_123
; page 14/15, run if E880
sat_fx_tick:                      ; 0x781C  page 14/15, run if E880
	call page_banks_ef
	call sat_fx_run
	jp page_banks_123
; DISPATCH_A on E881
sat_fx_run:                       ; 0x7825  DISPATCH_A on E881
	ld a,(0e880h)           ; sat_fx
	or a
	ret z
	call sat_fx_done
	ld a,(0e880h)           ; sat_fx
	or a
	ret z
	ld a,(0e881h)           ; sat_fx phase
	call DISPATCH_A

; BLOCK 'd_7835_jp' (start 0x7838 end 0x783e)  sat_fx: DISPATCH_A on E881
d_7835_jp_start:
	defw sat_fx0
	defw sat_fx1
	defw sat_fx2
d_7835_jp_end:
sat_fx0:                          ; 0x783E  nibble expand (sat_fx_hi)
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sat_fx_ptr
	ld b,010h
sat_fx0_loop:
	push bc
	push hl
	push de
	call sat_fx_hi
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz sat_fx0_loop
	call sat_fx_pal
sat_fx_next:
	ld hl,0e881h            ; sat_fx phase
	inc (hl)
	ret
sat_fx1:                          ; 0x7863
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sat_fx_ptr
	ld b,010h
sat_fx1_loop:
	push bc
	push hl
	push de
	call sat_fx_lo
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz sat_fx1_loop
	call sat_fx_pal
	jr sat_fx_next
sat_fx2:                          ; 0x7885  last pass, E881=0
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sat_fx_ptr
	inc hl
	inc de
	ld b,010h
sat_fx2_loop:
	push bc
	push hl
	push de
	call sat_fx_lo2
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz sat_fx2_loop
	call sat_fx_pal
	ld hl,0e881h            ; sat_fx phase
	ld (hl),000h
	ret
; morph dest high nibble toward src
sat_fx_hi:                      ; 0x78AD  morph dest high nibble toward src
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	ld c,a
	ld a,(de)
	rra
	rra
	rra
	rra
	and 00fh
	cp c
	ret z
	ld c,010h
	jr nc,sat_fx_hi_add
	ld c,0f0h
sat_fx_hi_add:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
; morph dest low nibble toward src
sat_fx_lo:                      ; 0x78C8  morph dest low nibble toward src
	ld a,(hl)
	and 00fh
	ld c,a
	ld a,(de)
	and 00fh
	cp c
	ret z
	ld c,001h
	jr nc,sat_fx_lo_add
	ld c,0ffh
sat_fx_lo_add:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
; last-pass low nibble morph
sat_fx_lo2:                     ; 0x78DB  last-pass low nibble morph
	ld a,(hl)
	and 00fh
	ld c,a
	ld a,(de)
	and 00fh
	cp c
	ret z
	ld c,001h
	jr nc,sat_fx_lo2_add
	ld c,0ffh
sat_fx_lo2_add:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
; palette_set E887 16 colours
sat_fx_pal:                     ; 0x78EE  palette_set E887 16 colours
	ld hl,0e887h
	xor a
sat_fx_pal_loop:
	ld d,(hl)
	inc hl
	ld e,(hl)
	push af
	push hl
	call palette_set
	pop hl
	pop af
	inc hl
	inc a
	cp 010h
	ret z
	jr sat_fx_pal_loop
; Z if E887 matches dest; clear E880
sat_fx_done:                    ; 0x7903  Z if E887 matches dest; clear E880
	ld b,020h
	ld de,0e887h
	ld hl,(0e884h)
sat_fx_cmp:
	ld a,(de)
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz sat_fx_cmp
	ld hl,0e880h            ; sat_fx
	ld (hl),000h
	ret
; HL=E884 dest, DE=E887 work
sat_fx_ptr:                     ; 0x7918  HL=E884 dest, DE=E887 work
	ld hl,(0e884h)
	ld de,0e887h
	ex de,hl
	ret
; mode_cont: E25A-1 -> d_7924
cont_tick:                        ; 0x7920  mode_cont: E25A-1 -> d_7924
	ld a,(0e25ah)           ; continue script
	dec a
	call DISPATCH_A

; BLOCK 'd_7924_jp' (start 0x7927 end 0x7933)  continue (F5) script (1-based)
d_7924_jp_start:
	defw cont_boot
	defw cont_io
	defw cont_map
	defw cont_curs
	defw cont_edit
	defw cont_esc
d_7924_jp_end:
cont_boot:                        ; 0x7933  gfx, E25B=1 (io_ask)
	call scr_reset
	ld a,001h
	ld (0e241h),a           ; world
	call load_world_gfx
	call pal_15
	call edit_pat
	call cont_next
	ld a,001h
	ld (0e25bh),a           ; file I/O
	ld hl,0e2c0h            ; delayed pickups
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),000h
	ldir
	call sat_wipe
	ld hl,0e25ch
	ld de,0e25dh
	ld bc,00013h
	ld (hl),000h
	ldir
; Fill E270 with 11 spaces (filename / password).
name_wipe:                        ; 0x7969
	ld hl,0e270h            ; tape name
	ld de,0e271h
	ld bc,0000bh
	ld (hl),020h
	ldir
	ret
cont_io:                          ; 0x7977  io_tick until E25B=0; E27E 1=loaded
	call io_tick
	ld a,(0e25bh)           ; file I/O
	and a
	ret nz
	call cont_next
	ld a,(0e27eh)
	and a
	ret z
	dec a
	jr nz,cont_io_back
	call cont_next
	jp edit_enter
cont_io_back:
	ld a,001h
	ld (0e25ah),a           ; continue script
	ret
cont_map:                         ; 0x7996  draw 7-row screen map
	call scr_reset
	call scr_grid
; next continue beat; clear file I/O
cont_next:                        ; 0x799C  next continue beat; clear file I/O
	ld hl,0e25ah            ; continue script
	inc (hl)
	inc hl
	ld (hl),000h
	ret
cont_curs:                        ; 0x79A4  cursor E25C/D/E on E788
	call map_stick
	jp curs_sat
; continue-map cursor on E25C/D/E
map_stick:                      ; 0x79AA  continue-map cursor on E25C/D/E
	ld a,(0e20ch)           ; vic_die flag
	rla
	jp c,map_number
	ld a,(0e207h)           ; key edges
	rra
	ld hl,0e25ch
	jp c,stick_dec
	rra
	jp c,stick_inc
	rra
	ld hl,0e25dh
	jp c,stick_dec
	rra
	jp c,stick_inc
	rra
	ld hl,0e25eh
	jr c,map_occupy
	rra
	ret nc
	ld a,(hl)
	and a
	ret z
	push hl
	call scr_used
	pop hl
	ret z
	dec (hl)
	ld b,000h
	jp map_cell_draw
map_occupy:
	ld a,(hl)
	and a
	jr z,map_occupy_inc
	push hl
	call scr_free
	pop hl
	ret z
map_occupy_inc:
	ld a,(hl)
	cp 006h
	ret nc
	inc (hl)
	ld b,001h
map_cell_draw:
	call scr_ptr
	ld (hl),b
	ld hl,(0e25ch)
	ld a,l
	add a,a
	add a,a
	add a,a
	ld l,a
	add a,a
	add a,l
	add a,023h
	ld l,a
	ld a,h
	add a,a
	add a,a
	add a,a
	add a,a
	add a,a
	add a,020h
	ld h,a
	ld a,b
	and a
	ld a,0cch
	jr nz,map_cell_fill
	xor a
map_cell_fill:
	ld bc,02017h
	ld d,000h
	push hl
	call vdp_lmmv
	pop hl
	ld bc,0170bh
	jp vdp_hmmv_hi
; E25C/D -> HL in E788
scr_ptr:                        ; 0x7A23  E25C/D -> HL in E788
	ld hl,(0e25ch)
	ld a,l
	add a,a
	add a,a
	add a,a
	add a,h
	ld hl,0e788h            ; screen ids
	jp ADD_HL_A
stick_inc:
	ld a,(hl)
	cp 005h
	ret nc
	inc (hl)
	jp sfx_32
stick_dec:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
map_number:
	ld hl,0e788h            ; screen ids
	ld bc,03001h
map_num_loop:
	ld a,(hl)
	and a
	jr z,map_num_next
	ld (hl),c
	inc c
map_num_next:
	ld a,c
	cp 007h
	jr nc,map_num_done
	inc hl
	djnz map_num_loop
	dec c
	ret z
map_num_done:
	call link_build
	call edit_first
edit_enter:
	xor a
	ld hl,0e260h            ; legend
	ld (hl),a
	inc hl
	ld (hl),a
	call edit_font
	jp cont_next
curs_sat:
	ld hl,0e800h            ; SAT
	ld a,(0e25ch)
	add a,a
	add a,a
	add a,a
	ld b,a
	add a,a
	add a,b
	add a,026h
	ld (hl),a
	inc hl
	ld a,(0e25dh)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,a
	add a,028h
	ld (hl),a
	inc hl
	ld (hl),010h
	inc hl
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld (hl),007h
	ld bc,0000fh
	ldir
	ret
; pat_15 + clear held + vic_reload
edit_pat:                       ; 0x7A96  pat_15 + clear held + vic_reload
	call pat_15
	xor a
	ld (0e285h),a           ; vic frame
	ld (0e298h),a           ; die SAT
	ld (0e287h),a           ; held tool
	call vic_reload
; bank D rle_bbfc -> F880
rle_minimap:                    ; 0x7AA6  bank D rle_bbfc -> F880
	call page_bank_d
	ld de,0bbfch                  ; rle_bbfc minimap
	ld hl,0f880h
	call rle_vram
	jp page_banks_123
; Z if E788 neighbours empty
scr_free:                       ; 0x7AB5  Z if E788 neighbours empty
	call scr_ptr
	ld a,(hl)
	and a
	jr nz,scr_free_no
	ld d,h
	ld e,l
	dec hl
	ld a,(hl)
	and a
	ret nz
	inc hl
	inc hl
	ld a,(hl)
	and a
	ret nz
	ld a,007h
	call ADD_HL_A
	ld a,(hl)
	and a
	ret nz
	ex de,hl
	ld de,00008h
	or a
	sbc hl,de
	ld a,(hl)
	and a
	ret nz
scr_free_no:
	xor a
	ret
; Z if E788[cursor] occupied
scr_used:                       ; 0x7ADB  Z if E788[cursor] occupied
	call scr_ptr
	ld a,(hl)
	and a
	ret
; 7-row HMMV screen-map boxes
scr_grid:                       ; 0x7AE1  7-row HMMV screen-map boxes
	ld hl,02022h
	ld d,h
	ld e,l
	ld b,007h
scr_grid_row:
	push bc
	ld bc,0900bh
	push hl
	push de
	call vdp_hmmv_hi
	pop de
	ex de,hl
	ld bc,0c00bh
	push hl
	call vdp_hmmv
	pop de
	pop hl
	ld a,h
	add a,020h
	ld h,a
	ld a,e
	add a,018h
	ld e,a
	pop bc
	djnz scr_grid_row
	ret
cont_edit:                        ; 0x7B08  nested editor: 0-based E25B -> d_7b0b
	ld a,(0e25bh)           ; file I/O
	call DISPATCH_A

; BLOCK 'd_7b0b_jp' (start 0x7b0e end 0x7b1a)  editor (E260 legend; 0-based E25B)
d_7b0b_jp_start:
	defw edit_hud
	defw edit_kind
	defw edit_sub
	defw edit_scr
	defw edit_put
	defw edit_yn
d_7b0b_jp_end:
edit_hud:                         ; 0x7B1A  legend + screen map
	call scr_reset
	call sat_wipe
	call edit_legend
	call scr_sat
	ld a,007h
	ld hl,0d220h
	call cc_fill
edit_next:                        ; 0x7B2E  inc E25B
	ld hl,0e25bh            ; file I/O
	inc (hl)
	ret
; bank D 2x13 tiles -> F038
edit_font:                      ; 0x7B33  bank D 2x13 tiles -> F038
	call page_bank_d
	ld hl,0bc44h
	ld de,0f038h
	ld bc,0020dh
	call copy_tiles
	jp page_banks_123
edit_kind:                        ; 0x7B45  E260 = legend 0..10
	ld a,(0e20ch)           ; vic_die flag
	rla
	jr nc,kind_keys
	ld a,(0e260h)           ; legend
	sub 009h
	jp z,kind_play
	dec a
	jr z,kind_minimap
	sub 004h
	cp 003h
	jp nc,edit_to_put
	call edit_wipe
	ld a,007h
	ld hl,0d200h            ; boot spare
	call cc_fill
	jr kind_help
kind_keys:
	call kind_sat
	ld hl,0e260h            ; legend
	ld a,(0e207h)           ; key edges
	rra
	jr c,kind_left
	rra
	jr c,kind_right
	rra
	rra
	rra
	ret nc
	push hl
	call edit_wipe
	ld a,007h
	ld hl,0d200h            ; boot spare
	call cc_fill
	pop hl
	ld a,(hl)
	cp 009h
	jp z,kind_play
	cp 00ah
	jr z,kind_minimap
	sub 004h
	cp 003h
	jr nc,kind_skip_sub
kind_help:
	xor a
	ld (0e261h),a           ; subtype
	call edit_help
	jp edit_next
kind_skip_sub:
	ld hl,0e25bh            ; file I/O
	inc (hl)
	inc (hl)
	ret
kind_minimap:
	ld a,005h
	ld (0e25bh),a           ; file I/O
	call sat_wipe
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0be77h
	call print_stream
	jp page_banks_123
kind_left:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld (hl),00ah
	ret
kind_right:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(hl)
	cp 00bh
	ret c
	ld (hl),000h
	ret
; legend cursor SAT at E800
kind_sat:                       ; 0x7BDA  legend cursor SAT at E800
	ld b,010h
	ld a,(0e260h)           ; legend
	ld hl,0e800h            ; SAT
edit_sat_xy:
	add a,a
	add a,a
	add a,a
	add a,a
	add a,010h
	ld (hl),a
	inc hl
	ld (hl),b
	inc hl
	ld (hl),014h
	ld de,0d200h            ; boot spare
	ld a,l
	and 07ch
	ld h,000h
	ld l,a
	add hl,hl
	add hl,hl
	add hl,de
	ld a,(0e203h)           ; puzzle board
	and 008h
	ld a,007h
	jr z,cc_fill
	xor a
; 16 colour bytes at HL = A
cc_fill:                        ; 0x7C04  16 colour bytes at HL = A
	ld d,h
	ld e,l
	inc de
	ld (hl),a
	ld bc,0000fh
	ldir
	ret
; print bcbb stream for E260-4
edit_help:                      ; 0x7C0E  print bcbb stream for E260-4
	call page_bank_d
	ld a,(0e260h)           ; legend
	sub 004h
	ld hl,0bcbbh
	call tbl_word
	ld a,(hl)
	ld (0e263h),a
	inc hl
	call print_stream
	jp page_banks_123
; LMMV wipe + hide SAT+4
edit_wipe:                      ; 0x7C27  LMMV wipe + hide SAT+4
	ld hl,0a010h
	ld bc,05078h
	ld a,0ffh
	ld d,000h
	call vdp_lmmv
	ld a,0e0h
	ld (0e804h),a
	ret
edit_sub:                         ; 0x7C3A  E261 subtype (bcbb_tbl / E263 max)
	ld a,(0e20ch)           ; vic_die flag
	rla
	jp c,edit_to_put
	call sub_sat
	ld hl,0e261h            ; subtype
	ld a,(0e207h)           ; key edges
	rra
	jr c,sub_left
	rra
	jr c,sub_right
	rra
	rra
	rra
	ret nc
	ld a,007h
	ld hl,0d210h
	call cc_fill
	jp edit_next
sub_left:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld a,(0e263h)
	ld (hl),a
	ret
sub_right:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(0e263h)
	cp (hl)
	ret nc
	ld (hl),000h
	ret
; subtype cursor SAT at E804
sub_sat:                        ; 0x7C77  subtype cursor SAT at E804
	ld b,088h
	ld a,(0e261h)           ; subtype
	ld hl,0e804h
	jp edit_sat_xy
edit_scr:                         ; 0x7C82  E262 slot in E788
	ld a,(0e20ch)           ; vic_die flag
	rla
	jp c,edit_to_put
	call scr_sat
	ld hl,0e262h            ; screen slot
	ld de,0e788h            ; screen ids
	ld a,(0e207h)           ; key edges
	rra
	jr c,edit_slot_up
	rra
	jr c,edit_slot_down
	rra
	jp c,edit_slot_left
	rra
	jp c,edit_slot_right
	rra
	ret nc
	ld a,007h
	ld hl,0d220h
	call cc_fill
	ld a,001h
	ld (0e25bh),a           ; file I/O
	ret
edit_to_put:
	call scr_reset
	ld hl,0e264h
	ld (hl),00bh
	inc hl
	ld (hl),00fh
	call sat_wipe
	call edit_redraw
	ld a,004h
	ld (0e25bh),a           ; file I/O
	ld a,(0e260h)           ; legend
	ld b,a
	add a,a
	add a,b
	ld hl,edit_sz
	call ADD_HL_A
	ld a,(hl)
	ld (0e27ch),a
	inc hl
	ld a,(hl)
	ld (0e27dh),a
	inc hl
	ld a,(hl)
	ld (0e2fbh),a
	ret
; BLOCK 'edit_sz' (start 0x7ce4 end 0x7cff)  W,H,flags per legend 0..8; [9][10] overlap edit_first
edit_sz:
	defb 018h, 020h, 000h
	defb 018h, 020h, 000h
	defb 018h, 01eh, 001h
	defb 016h, 01eh, 011h
	defb 016h, 01eh, 011h
	defb 016h, 01eh, 011h
	defb 016h, 01eh, 011h
	defb 016h, 01eh, 011h
	defb 014h, 01ch, 011h
; first nonempty E788 -> E262
edit_first:                       ; 0x7CFF  first nonempty E788 -> E262
	ld hl,0e788h            ; screen ids
	ld c,000h
edit_first_loop:
	ld a,(hl)
	dec a
	jr z,edit_first_hit
	inc hl
	inc c
	jr edit_first_loop
edit_first_hit:
	ld a,c
	ld (0e262h),a           ; screen slot
	ret
edit_slot_up:
	ld a,(hl)
	and 038h
	ret z
	ld a,(hl)
	sub 008h
	jr edit_slot_move
edit_slot_down:
	ld a,(hl)
	and 038h
	rrca
	rrca
	rrca
	cp 005h
	ret nc
	ld a,(hl)
	add a,008h
edit_slot_move:
	ld b,a
	call ADD_DE_A
	ld a,(de)
	and a
	ret z
	ld (hl),b
	jp sfx_32
edit_slot_left:
	ld a,(hl)
	and 007h
	ret z
	ld a,(hl)
	dec a
	jr edit_slot_move
edit_slot_right:
	ld a,(hl)
	and 007h
	cp 005h
	ret nc
	ld a,(hl)
	inc a
	jr edit_slot_move
; E262 slot cursor SAT at E808
scr_sat:                        ; 0x7D43  E262 slot cursor SAT at E808
	ld a,(0e262h)           ; screen slot
	ld b,a
	and 038h
	add a,08fh
	ld hl,0e808h
	ld (hl),a
	inc hl
	ld a,b
	and 007h
	add a,a
	add a,a
	add a,a
	add a,0a0h
	ld (hl),a
	inc hl
	ld (hl),018h
	inc hl
	ld a,(0e203h)           ; puzzle board
	and 008h
	ld a,007h
	jr z,scr_sat_cc
	xor a
scr_sat_cc:
	ld hl,0d220h
	jp cc_fill
kind_play:
	ld hl,0e26ah            ; exit
	ld a,(hl)
	inc hl
	and (hl)
	ret z
	call count_gems
	call scr_reset
	call sat_wipe
	call cont_next
	ld a,001h
	ld (0e25bh),a           ; file I/O
	ret
; nonempty E700 -> E2F4/E2F5
count_gems:                     ; 0x7D86  nonempty E700 -> E2F4/E2F5
	ld hl,0e700h            ; gems
	ld bc,01000h
gems_count_loop:
	ld a,(hl)
	and a
	jr z,gems_count_next
	inc c
gems_count_next:
	ld a,008h
	call ADD_HL_A
	djnz gems_count_loop
	ld a,c
	ld (0e2f4h),a
	ld (0e2f5h),a           ; gems left
	ret
; stamp map + gems/actors/tools/Vic
edit_redraw:                    ; 0x7DA0  stamp map + gems/actors/tools/Vic
	call edit_unpack
	ld a,(0e26ch)
	and a
	call nz,secret_redraw
	call edit_screen
	ld c,a
	ld ix,0e700h            ; gems
	ld b,010h
edit_gems_loop:
	push bc
	ld a,(ix+000h)
	and a
	jr z,edit_gems_next
	ld a,(ix+001h)
	cp c
	jr nz,edit_gems_next
	call gem_tiles
edit_gems_next:
	ld bc,00008h
	add ix,bc
	pop bc
	djnz edit_gems_loop
	call edit_screen
	ld hl,0e2f3h
	cp (hl)
	jr nz,edit_tools_go
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)
	ld hl,exit_pat
	ld bc,00404h
	push bc
	push de
	call tilemap_hmmm
	pop hl
	pop bc
	call edit_stamp0
edit_tools_go:
	call edit_screen
	ld c,a
	ld hl,0e300h            ; map tools
	ld b,040h
edit_tools_loop:
	push bc
	ld a,(hl)
	and a
	push hl
	jr z,edit_tools_next
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	dec a
	ld b,a
	inc hl
	ld a,(hl)
	cp c
	jr nz,edit_tools_next
	ld a,b
	call tool_tiles
	ld bc,00202h
	call tilemap_hmmm
edit_tools_next:
	pop hl
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz edit_tools_loop
	ld a,(0e267h)           ; E600 count
	and a
	call nz,edit_actors
	ld a,(0e266h)           ; delayed count
	and a
	call nz,delay_sat
	ld a,(0e26bh)           ; Vic slot
	and a
	ret z
	ld a,(0e243h)           ; screen
	ld b,a
	call edit_screen
	cp b
	call z,vic_edit_sat
	ret
; map_base[screen] -> stamp_map body
edit_unpack:                    ; 0x7E35  map_base[screen] -> stamp_map body
	call edit_screen
	dec a
	ld h,000h
	ld l,a
	call map_base
	push hl
	pop ix
	xor a
	ld (0efc0h),a           ; stamp row
	jp stamp_map_at
edit_yn:                          ; 0x7E49  "edit end" Y/N; yes -> E25A=0
	call yn_keys
	and a
	ret z
	dec a
	jr z,yn_quit
	xor a
	ld (0e25bh),a           ; file I/O
	ret
yn_quit:
	xor a
	ld (0e25ah),a           ; continue script
	ret
edit_put:                         ; 0x7E5B  place current kind (d_7e6c on E260)
	ld a,(0e20ch)           ; vic_die flag
	rla
	jr nc,put_go
	xor a
	ld (0e25bh),a           ; file I/O
	ret
put_go:
	call place_sat
	ld a,(0e260h)           ; legend
	call DISPATCH_A

; BLOCK 'd_7e6c_jp' (start 0x7e6f end 0x7e81)  edit_put: DISPATCH_A on E260 (legend 0..8)
d_7e6c_jp_start:
	defw put_floor1               ; 0 floor1
	defw put_floor2               ; 1 floor2
	defw put_ladder               ; 2 ladder
	defw put_player               ; 3 player
	defw put_enemy                ; 4 enemy → E2C0 delayed 1-4
	defw put_trap                 ; 5 trap → E600 / secret
	defw put_tool                 ; 6 tool weapon → E300
	defw put_gem                  ; 7 soul stone → E700
	defw put_exit                 ; 8 exit door → E2F1
d_7e6c_jp_end:
put_floor1:                       ; 0x7E81  floor1 stamp (HL=0502h)
	ld hl,00502h
put_floor:
	ld (0efd0h),hl
	call edit_cursor
	call exit_hit
	ret c
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	jr nz,put_floor_tile
	xor a
	ld (0efd0h),a
put_floor_tile:
	ld a,(0efd0h)
	ld b,a
	call edit_screen
	ld h,a
	call edit_xy
	ex de,hl
	push hl
	ld a,d
	exx
	call screen_base
	pop hl
	call map_tile_de
	exx
	ld c,a
	ld a,b
	and a
	jr nz,put_floor_erase
	ld a,c
	cp 002h
	jr nc,put_floor_stamp
	ret
put_floor_erase:
	ld a,c
	dec a
	ret z
put_floor_stamp:
	ld a,b
	push hl
	push hl
	push af
	ld bc,00101h
	call stamp_rect
	pop af
	pop de
	and a
	jr nz,put_floor_draw
	ld a,0e0h
	ld (0efd1h),a
put_floor_draw:
	ld a,(0efd1h)
	call tile_hmmm_at
	pop de
	push de
	call edit_wrap_x
	pop hl
	and a
	ret z
	ld d,a
	dec c
	dec c
	dec c
	jr nz,put_floor_wrap
	push hl
	ld h,0f8h
	call edit_stamp1
	pop hl
put_floor_wrap:
	dec c
	ret nz
	ld h,000h
; 1x1 stamp_rect at DE; tile if same screen
edit_stamp1:                    ; 0x7EF4  1x1 stamp_rect at DE; tile if same screen
	push bc
	push de
	ld bc,00101h
	ld a,(0efd0h)
	push hl
	push de
	call stamp_rect
	call edit_screen
	pop bc
	pop de
	cp b
	ld a,(0efd1h)
	call z,tile_hmmm_at
	pop de
	pop bc
	ret
; C=3/4 at left/right edge, else 0
edit_wrap_x:                    ; 0x7F10  C=3/4 at left/right edge, else 0
	ld c,003h
	ld a,d
	and a
	jr z,wrap_link
	inc c
	cp 0f8h
	jr z,wrap_link
	xor a
	ld c,a
	ret
wrap_link:
	ld a,(0e262h)           ; screen slot
	ld b,a
	ld a,c
	push bc
	call room_link
	pop bc
	ld a,l
	ret
; E264/E265 * 8 -> DE (pixel Y, X)
edit_xy:                        ; 0x7F2A  E264/E265 * 8 -> DE (pixel Y, X)
	ld a,(0e264h)
	add a,a
	add a,a
	add a,a
	ld e,a
	ld a,(0e265h)
	add a,a
	add a,a
	add a,a
	ld d,a
	ret
; E788[E262] screen id
edit_screen:                    ; 0x7F39  E788[E262] screen id
	ld de,0e788h            ; screen ids
	ld a,(0e262h)           ; screen slot
	call ADD_DE_A
	ld a,(de)
	ret
put_floor2:                       ; 0x7F44  floor2 stamp (HL=5E03h) → put_floor1 tail
	ld hl,05e03h
	jp put_floor
put_ladder:                       ; 0x7F4A
	call edit_cursor
	call exit_hit8
	ret c
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld a,001h
	jr nz,put_ladder_id
	xor a
put_ladder_id:
	ld (0efd0h),a
	ld b,a
	call edit_screen
	ld h,a
	exx
	call screen_base
	ld (0e250h),de          ; map base
	exx
	call edit_xy
	ex de,hl
	ld a,b
	and a
	jr nz,put_ladder_stamp
	push hl
	exx
	pop hl
	ld de,(0e250h)          ; map base
	push hl
	call map_tile_de
	pop hl
	dec a
	ret nz
	call 0a60fh                   ; probe_ladder_span from L
	exx
	jr nc,put_ladder_stamp
	ld a,h
	sub 008h
	ld h,a
put_ladder_stamp:
	ld a,b
	push hl
	push af
	ld bc,00102h
	push hl
	call stamp_rect
	pop de
	call edit_stamp_wrap
	pop af
	pop de
	and a
	jr z,edit_tile2
	ld a,003h
; editor tile stamp (C=3)
edit_tile2:
	push af
	push de
	call tile_hmmm_at
	pop de
	ld a,d
	add a,008h
	ld d,a
	pop af
	jr z,edit_tile
	inc a
edit_tile:
	jp tile_hmmm_at
; stamp_rect on wrapped neighbour
edit_stamp_wrap:                ; 0x7FB5  stamp_rect on wrapped neighbour
	push de
	call edit_wrap_y
	pop hl
	and a
	ret z
	ld d,a
	dec c
	ld l,0b8h
	jr z,wrap_stamp
	ld l,000h
wrap_stamp:
	ld bc,00102h
	ld a,(0efd0h)
	push hl
	push de
	call stamp_rect
	call edit_screen
	pop bc
	pop de
	cp b
	ret nz
	ld a,(0efd0h)
	and a
	jr z,wrap_tile0
	ld a,003h
wrap_tile0:
	jp edit_tile2
; C=1/2 at top/bottom edge, else 0
edit_wrap_y:                    ; 0x7FE1  C=1/2 at top/bottom edge, else 0
	ld c,001h
	ld a,e
	and a
	jp z,wrap_link
	inc c
	cp 0b8h
	jp z,wrap_link
	xor a
	ret
; CY if cursor overlaps exit (0,0)
exit_hit:                       ; 0x7FF0  CY if cursor overlaps exit (0,0)
	ld bc,02000h
	jr exit_hit_go
; same with 8px X inset
exit_hit8:                      ; 0x7FF5  same with 8px X inset
	ld bc,02808h
exit_hit_go:
	ld a,(0e26ah)           ; exit
	and a
	jr z,exit_hit_no
	ld hl,0e2f3h                 ; was split: 021h,0f3h | bank2 0e2h

; ---------------------------------------------------------------------------
;  bank 02 continues at 0x8001 (ld hl high byte was 0x8000)
; ---------------------------------------------------------------------------
	call edit_screen
	cp (hl)
	jr nz,exit_hit_no
	dec hl
	call edit_xy
	ld a,d
	add a,c
	sub (hl)
	cp b
	ret nc
	dec hl
	ld a,e
	sub (hl)
	cp 020h
	ret
exit_hit_no:
	or a
	ret
put_player:                       ; 0x8018  Vic spawn E282 / E26B; fire places, else erase
	call edit_cursor
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld hl,0e282h            ; Vic Y
	jr z,vic_erase
	call edit_screen
	ld (0e243h),a           ; screen
	call edit_xy
	ld (hl),e
	inc hl
	inc hl
	ld (hl),d
	ld a,001h
	jr vic_flag
vic_erase:
	ld a,(0e243h)           ; screen
	ld b,a
	call edit_screen
	cp b
	ret nz
	xor a
vic_flag:
	ld (0e26bh),a           ; Vic slot
; Vic 2x2 SAT at E808 in the editor.
vic_edit_sat:                     ; 0x8046
	ld hl,0e808h
	ld de,0e80ch
	exx
	ld hl,0e810h
	ld de,0e814h
	exx
	and a
	ld a,0e0h
	jr z,vic_hide
	ld a,(0e282h)           ; Vic Y
	sub 008h
vic_hide:
	ld (hl),a
	ld (de),a
	inc hl
	inc de
	exx
	add a,010h
	ld (hl),a
	ld (de),a
	inc hl
	inc de
	exx
	ld a,(0e284h)           ; Vic X
	ld (hl),a
	ld (de),a
	inc hl
	inc de
	exx
	ld (hl),a
	ld (de),a
	inc hl
	inc de
	exx
	ld (hl),000h
	ld a,004h
	ld (de),a
	inc hl
	inc de
	exx
	ld (hl),008h
	ld a,00ch
	ld (de),a
	inc hl
	inc de
	exx
	ld a,00dh
	ld hl,0d220h
	call cc_fill
	ld a,04eh
	ld hl,0d230h
	call cc_fill
	ld a,00dh
	ld hl,0d240h
	call cc_fill
	ld a,04eh
	ld hl,0d250h
	jp cc_fill
put_enemy:                        ; 0x80A7  E2C0 delayed pickups; type=E261+1 (HUD names_enemies)
	call edit_cursor
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld hl,0e266h            ; delayed count
	jr z,put_enemy_erase
	ld a,(hl)
	cp 008h
	ret nc
	push hl
	call delay_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e2c0h            ; delayed pickups
delay_find:
	ld a,(hl)
	and a
	jr z,delay_slot
	ld a,005h
	call ADD_HL_A
	jr delay_find
delay_slot:
	ld a,(0e261h)           ; subtype
	inc a
	or 080h
	ld (hl),a
	inc hl
	ld (hl),020h
	inc hl
	call edit_screen
	ld (hl),a
	inc hl
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	jr delay_sat
; Z if E2C0 slot at editor XY
delay_free:                     ; 0x80E8  Z if E2C0 slot at editor XY
	ld hl,0e2c0h            ; delayed pickups
	ld b,008h
delay_free_loop:
	ld a,(hl)
	and a
	jr z,delay_free_next
	push hl
	call delay_at
	pop hl
	ret z
delay_free_next:
	ld a,005h
	call ADD_HL_A
	djnz delay_free_loop
	ld a,001h
	and a
	ret
put_enemy_erase:
	ld a,(hl)
	and a
	ret z
	ld hl,0e2c0h            ; delayed pickups
	ld b,008h
delay_erase_loop:
	ld a,(hl)
	and a
	jr z,delay_erase_next
	push hl
	call delay_at
	pop hl
	push hl
	call z,delay_erase
	pop hl
delay_erase_next:
	ld a,005h
	call ADD_HL_A
	djnz delay_erase_loop
; E2C0 delayed-pickup SAT at E840.
delay_sat:                        ; 0x811F
	ld hl,0e2c0h            ; delayed pickups
	ld b,008h
	ld de,0e840h
delay_sat_loop:
	push hl
	exx
	call edit_screen
	exx
	inc hl
	inc hl
	cp (hl)
	pop hl
	jr nz,delay_sat_next
	push de
	exx
	pop de
	ld a,004h
	call ADD_DE_A
	exx
	push bc
	push hl
	push de
	ld a,(hl)
	and 07fh
	ld c,a
	inc hl
	inc hl
	inc hl
	ld a,(hl)
	jr nz,delay_sat_y
	ld a,0e0h
delay_sat_y:
	ld (de),a
	exx
	ld (de),a
	inc de
	exx
	inc hl
	inc de
	ld a,(hl)
	ld (de),a
	exx
	ld (de),a
	inc de
	exx
	inc hl
	inc de
	ld a,c
	dec a
	ld c,a
	add a,a
	add a,c
	ld hl,delay_spr
	call ADD_HL_A
	ld a,(hl)
	ld (de),a
	exx
	add a,004h
	ld (de),a
	exx
	inc hl
	ld b,(hl)
	inc hl
	ld c,(hl)
	ld a,e
	ld de,0d200h            ; boot spare
	and 07ch
	ld h,000h
	ld l,a
	add hl,hl
	add hl,hl
	add hl,de
	push hl
	ld a,b
	push bc
	call cc_fill
	pop bc
	ld a,c
	exx
	pop hl
	ld bc,00010h
	add hl,bc
	call cc_fill
	exx
	pop de
	pop hl
	pop bc
delay_sat_next:
	ld a,005h
	call ADD_HL_A
	ld a,008h
	call ADD_DE_A
	djnz delay_sat_loop
	ret
; Z if this E2C0 rec is at editor XY
delay_at:                       ; 0x819E  Z if this E2C0 rec is at editor XY
	call edit_screen
	inc hl
	inc hl
	cp (hl)
	ret nz
	call edit_xy
	inc hl
	ld a,(hl)
	cp e
	ret nz
	inc hl
	ld a,(hl)
	cp d
	ret
; clear E2C0 rec; dec E266
delay_erase:                    ; 0x81B0  clear E2C0 rec; dec E266
	ld (hl),000h
	ld hl,0e266h            ; delayed count
	dec (hl)
	ret
put_trap:                         ; 0x81B7  E600 via editor_spawn; E261=7 → secret (obj2)
	call edit_cursor2
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld hl,0e267h            ; E600 count
	jp z,put_trap_erase
	ld a,(0e261h)           ; subtype
	cp 007h                       ; editor tool 7 = secret entrance (obj2 / 0xE7C0)
	jp z,secret_add
	ld a,(hl)
	cp 010h
	ret nc
	push hl
	call actor_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e600h            ; actors
trap_find:
	ld a,(hl)
	and a
	jr z,editor_spawn
	ld a,010h
	call ADD_HL_A
	jr trap_find
editor_spawn:                     ; 0x81E9  empty E600 slot; type from put_trap E261 (names_terrain)
	push hl
	pop ix
	ld b,010h
spawn_wipe:
	ld (hl),000h
	inc hl
	djnz spawn_wipe
	ld a,(0e261h)           ; subtype
	ld b,a
	dec b
	cp 004h
	jr nc,spawn_type
	cp 002h
	ld b,001h
	jr c,spawn_type
	inc b
spawn_type:
	ld a,b
	ld (ix+000h),a
	call edit_xy
	ld (ix+002h),e
	ld (ix+003h),d
	call edit_screen
	ld (ix+004h),a
	ld (ix+009h),a
	call edit_place
; Draw E600 actors on the current edit screen.
edit_actors:                      ; 0x821C
	call edit_screen
	ld c,a
	ld ix,0e600h            ; actors
	ld b,010h
edit_actors_loop:
	push bc
	ld a,(ix+004h)
	cp c
	jr nz,edit_actors_next
	ld a,(ix+000h)
	and a
	call nz,edit_draw
edit_actors_next:
	ld bc,00010h
	add ix,bc
	pop bc
	djnz edit_actors_loop
	ret
; DISPATCH actor stamp by type
edit_draw:                      ; 0x823D  DISPATCH actor stamp by type
	dec a
	call DISPATCH_A

; BLOCK 'd823e_jp' (start 0x8241 end 0x824b)
d823e_jp_start:
	defw stamp_coffin             ; type 1 Slouman / Flouman (coffin)
	defw stamp_pyoncy             ; type 2 Pyoncy
	defw stamp_rock               ; type 3 Rock Roll
	defw stamp_trap               ; type 4 trap (1×4 tile column)
	defw stamp_stone              ; type 5 stone (2×2, pushable)
d823e_jp_end:
; Z if no E600 actor at editor XY.
actor_free:                       ; 0x824B
	ld ix,0e600h            ; actors
	ld b,010h
actor_free_loop:
	ld a,(ix+000h)
	and a
	jr z,actor_free_next
	call actor_at
	ret z
actor_free_next:
	ld de,00010h
	add ix,de
	djnz actor_free_loop
	ld a,001h
	and a
	ret
stamp_coffin:                     ; 0x8266  editor preview: coffin facing
	ld a,(ix+007h)
	and 002h
	ld a,003h
	jr nz,coffin_face
	xor a
coffin_face:
	ld (ix+005h),a
	ld hl,coffin_pat
	ld de,coffin_pat
	ld bc,coffin_pat
	jp actor_rows
stamp_pyoncy:                     ; 0x827F  editor preview: pyoncy
	ld a,(ix+007h)
	rra
	rra
	ld hl,pyoncy_l0
	ld de,pyoncy_l1
	ld bc,pyoncy_l2
	jp nc,actor_rows
	ld hl,pyoncy_r0
	ld de,pyoncy_r1
	ld bc,pyoncy_r2
	jp actor_rows
stamp_rock:                       ; 0x829C  editor preview: rock-roll row
	ld e,(ix+002h)
	ld d,(ix+003h)
	ld b,(ix+008h)
rock_tiles:
	ld a,0feh
	call tile_hmmm_at
	ld a,e
	add a,008h
	ld e,a
	djnz rock_tiles
	ret
put_trap_erase:
	ld a,(0e261h)           ; subtype
	cp 007h                       ; editor tool 7 = secret entrance
	jp z,secret_erase_all
	ld a,(hl)
	and a
	ret z
	ld ix,0e600h            ; actors
	ld b,010h
put_trap_erase_loop:
	ld a,(ix+000h)
	and a
	jr z,put_trap_erase_next
	push hl
	call actor_at
	call z,edit_erase
	pop hl
put_trap_erase_next:
	ld de,00010h
	add ix,de
	djnz put_trap_erase_loop
	ret
; clear actor at IX; stamp floor
edit_erase:                     ; 0x82D8  clear actor at IX; stamp floor
	ld a,(ix+000h)
	ld (ix+000h),000h
	dec (hl)
	ld hl,erase_w-1
	call ADD_HL_A
	ld c,(hl)
	ld b,(ix+008h)
	call edit_xy
	ld hl,floor_tiles
	jp tilemap_hmmm
; BLOCK 'erase_w' (start 0x82F3 end 0x82F8)
erase_w:                          ; 0x82F3  tilemap width by type 1..5 (base erase_w-1)
	defb 002h, 002h, 001h, 004h, 002h
; Z if IX actor is at editor XY this screen
actor_at:                       ; 0x82F8  Z if IX actor is at editor XY this screen
	call edit_screen
	cp (ix+004h)
	ret nz
	call edit_xy
	ld a,(ix+002h)
	cp e
	ret nz
	ld a,(ix+003h)
	cp d
	ret
; DISPATCH_A on E261 (editor tool)
edit_place:                     ; 0x830C  DISPATCH_A on E261 (editor tool)
	ld a,(0e261h)           ; subtype
	call DISPATCH_A

; BLOCK 'd830f_jp' (start 0x8312 end 0x8320)
d830f_jp_start:
	defw place_lr                 ; E261 0 door1 lr  coffin ix+8=0
	defw place_coffin_rl          ; E261 1 door1 rl  coffin ix+8=1 (editor)
	defw place_lr                 ; E261 2 door2 lr  pyoncy (same init)
	defw place_pyoncy_rl          ; E261 3 door2 rl  ix+8=2
	defw place_rock               ; E261 4 wall      rock roll
	defw place_trap               ; E261 5 floor     trap
	defw place_stone              ; E261 6 stone
d830f_jp_end:
place_lr:                         ; 0x8320  door / coffin / pyoncy facing left
	ld c,000h
	xor a
	ld b,003h
place_scan:
	ld (ix+005h),c
	ld (ix+007h),a
	call edit_vscan
	ld (ix+008h),c
	dec c
	ret nz
	ld (ix+000h),000h
	ld hl,0e267h            ; E600 count
	dec (hl)
	ret
place_trap:                       ; 0x833C
	ld (ix+008h),001h
	ret
place_stone:                      ; 0x8341
	ld (ix+008h),002h
	ret
place_rock:                       ; 0x8346
	xor a
	ld c,a
	ld b,01eh
	jp place_scan
place_coffin_rl:                  ; 0x834D
	ld c,003h
	jr place_rl
place_pyoncy_rl:                  ; 0x8351
	ld c,000h
place_rl:
	ld a,002h
	ld b,003h
	jr place_scan
; walk DE down; count free map cells
edit_vscan:                     ; 0x8359  walk DE down; count free map cells
	ld c,001h
	call edit_xy
vscan_loop:
	ld a,e
	add a,008h
	ld e,a
	cp 0b8h
	ret nc
	push bc
	push de
	call edit_mapbit
	pop de
	pop bc
	ret nc
	inc c
	djnz vscan_loop
	ret
; CY if map cell at DE is empty
edit_mapbit:                    ; 0x8371  CY if map cell at DE is empty
	push de
	call edit_screen
	dec a
	ld l,a
	ld h,000h
	call map_base
	pop de
	push hl
	ex de,hl
	call scr5_addr
	or a
	ld de,03800h
	sbc hl,de
	ld c,l
	srl h
	rr l
	srl h
	rr l
	ld a,l
	pop hl
	call ADD_HL_A
	ld a,c
	and 003h
	inc a
	ld b,a
	ld a,(hl)
mapbit_rot:
	rlca
	rlca
	djnz mapbit_rot
	and 003h
	cp 002h
	ret
secret_add:
	ld hl,0e26ch
	ld a,(hl)
	cp 010h
	ret nc
	push hl
	call secret_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e7c0h            ; secrets
secret_find:
	ld a,(hl)
	and a
	jr z,secret_slot
	ld a,004h
	call ADD_HL_A
	jr secret_find
secret_slot:
	ld d,h
	ld e,l
	ld b,004h
	xor a
secret_wipe:
	ld (de),a
	inc de
	djnz secret_wipe
	push hl
	call edit_screen
	ld (hl),a
	inc hl
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	ld b,01eh
	push hl
	call edit_vscan
	pop hl
	inc hl
	ld a,080h
	or c
	ld (hl),a
	pop hl
; Stamp E7C0 secrets on this screen (C=1 door tiles).
secret_redraw:                    ; 0x83E3
	ld c,001h
	ld ix,0e7c0h            ; secrets
	ld b,010h
secret_put_loop:
	push bc
	call edit_screen
	cp (ix+000h)
	call z,secret_stamp
	ld bc,00004h
	add ix,bc
	pop bc
	djnz secret_put_loop
	ret
; stamp ix+3 count of door tiles
secret_stamp:                   ; 0x83FE  stamp ix+3 count of door tiles
	ld a,(ix+003h)
	and 01fh
	ld b,a
	ld d,(ix+002h)
	ld e,(ix+001h)
secret_stamp_loop:
	push de
	push bc
	ld a,c
	and a
	call edit_tile2
	pop bc
	pop de
	ld a,e
	add a,008h
	ld e,a
	djnz secret_stamp_loop
	ret
; Z if E7C0 slot at editor XY
secret_free:                    ; 0x841A  Z if E7C0 slot at editor XY
	ld ix,0e7c0h            ; secrets
	ld b,010h
secret_free_loop:
	ld a,(ix+000h)
	and a
	jr z,secret_free_next
	call secret_at
	ret z
secret_free_next:
	ld de,00004h
	add ix,de
	djnz secret_free_loop
	ld a,001h
	and a
	ret
secret_erase_all:
	ld a,(0e26ch)
	and a
	ret z
	ld ix,0e7c0h            ; secrets
	ld b,010h
secret_erase_loop:
	push bc
	ld a,(ix+000h)
	and a
	jr z,secret_erase_next
	call secret_at
	call z,secret_erase
secret_erase_next:
	ld bc,00004h
	add ix,bc
	pop bc
	djnz secret_erase_loop
	ret
; Z if this secret rec is at editor XY
secret_at:                      ; 0x8456  Z if this secret rec is at editor XY
	call edit_screen
	cp (ix+000h)
	ret nz
	call edit_xy
	ld a,(ix+001h)
	cp e
	ret nz
	ld a,(ix+002h)
	cp d
	ret
; clear secret rec; stamp floor
secret_erase:                   ; 0x846A  clear secret rec; stamp floor
	ld hl,0e26ch
	dec (hl)
	ld (ix+000h),000h
	ld c,000h
	jp secret_stamp
put_tool:                         ; 0x8477  E300 map tool; type=E261+1 (names_tools 1-6)
	call edit_cursor
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld hl,0e268h            ; E300 count
	jr z,put_tool_erase
	ld a,000h
	ld (0efd0h),a
	ld a,(hl)
	cp 040h
	ret nc
	push hl
	call tool_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e300h            ; map tools
tool_find:
	ld a,(hl)
	and a
	jr z,tool_slot
	ld a,008h
	call ADD_HL_A
	jr tool_find
tool_slot:
	ld a,(0e261h)                 ; editor tool-weapon palette: type = E261+1 (1-6)
	inc a
	ld (hl),a
	inc hl
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	call edit_screen
	ld (hl),a
	jr tool_draw
put_tool_erase:
	ld a,001h
	ld (0efd0h),a
	ld a,(hl)
	and a
	ret z
	ld hl,0e300h            ; map tools
	ld b,040h
tool_erase_loop:
	push bc
	ld a,(hl)
	and a
	jr z,tool_erase_next
	push hl
	call tool_at
	pop hl
	push hl
	call z,tool_erase
	pop hl
tool_erase_next:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz tool_erase_loop
	ret
tool_draw:
	call edit_xy
	ld a,(0e261h)           ; subtype
	call tool_tiles
	ld a,(0efd0h)
	and a
	jr z,tool_draw_go
	ld hl,floor_tiles
tool_draw_go:
	ld bc,00202h
	push bc
	push de
	call tilemap_hmmm
	pop hl
	pop bc
	call edit_screen
	ld d,a
	xor a
	jp stamp_rect
; Z if E300 slot at editor XY
tool_free:                      ; 0x8501  Z if E300 slot at editor XY
	ld hl,0e300h            ; map tools
	ld b,040h
tool_free_loop:
	ld a,(hl)
	and a
	jr z,tool_free_next
	push hl
	call tool_at
	pop hl
	ret z
tool_free_next:
	ld a,008h
	call ADD_HL_A
	djnz tool_free_loop
	ld a,001h
	and a
	ret
; Z if this E300 rec is at editor XY
tool_at:                        ; 0x851B  Z if this E300 rec is at editor XY
	call edit_screen
	inc hl
	inc hl
	inc hl
	cp (hl)
	ret nz
	call edit_xy
	dec hl
	ld a,(hl)
	cp d
	ret nz
	dec hl
	ld a,(hl)
	cp e
	ret
; clear E300 rec; dec E268
tool_erase:                     ; 0x852E  clear E300 rec; dec E268
	ld (hl),000h
	ld hl,0e268h            ; E300 count
	dec (hl)
	jp tool_draw
; HL = tool_stamp_pat + A*4
tool_tiles:                     ; 0x8537  HL = tool_stamp_pat + A*4
	ld hl,tool_stamp_pat
	add a,a
	add a,a
	jp ADD_HL_A
put_gem:                          ; 0x853F  E700 soul stone (max 16)
	call edit_cursor
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	ld a,001h
	jr nz,put_gem_flag
	ld a,000h
put_gem_flag:
	ld (0efd0h),a
	ld hl,0e269h            ; gem count
	jr z,put_gem_erase
	ld a,(hl)
	cp 010h
	ret nc
	ld a,(hl)
	inc (hl)
	ld hl,0e700h            ; gems
gem_find:
	ld a,(hl)
	and a
	jr z,gem_slot
	ld a,008h
	call ADD_HL_A
	jr gem_find
gem_slot:
	ld (hl),001h
	inc hl
	call edit_screen
	ld (hl),a
	inc hl
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	jr edit_gem_put
put_gem_erase:
	ld a,(hl)
	and a
	ret z
	ld hl,0e700h            ; gems
	ld b,010h
gem_erase_loop:
	push bc
	ld a,(hl)
	and a
	jr z,gem_erase_next
	push hl
	call gem_at
	pop hl
	push hl
	call z,gem_erase
	pop hl
gem_erase_next:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz gem_erase_loop
	ret
; Z if this E700 rec is at editor XY
gem_at:                         ; 0x859C  Z if this E700 rec is at editor XY
	call edit_screen
	inc hl
	cp (hl)
	ret nz
	call edit_xy
	inc hl
	ld a,(hl)
	cp e
	ret nz
	inc hl
	ld a,(hl)
	cp d
	ret
; clear E700 rec; stamp floor
gem_erase:                      ; 0x85AD  clear E700 rec; stamp floor
	ld (hl),000h
	ld hl,0e269h            ; gem count
	dec (hl)
edit_gem_put:
	call edit_xy
	ld a,(0efd0h)
	and a
	ld hl,gem_pat
	jr nz,edit_gem_tiles
	ld hl,floor_tiles
edit_gem_tiles:
	ld bc,00202h
	push bc
	push de
	call tilemap_hmmm
	pop hl
	pop bc
	call edit_screen
	ld d,a
	xor a
	jp stamp_rect
put_exit:                         ; 0x85D4  E2F1 exit door / E26A placed
	call edit_cursor
	ld a,(0e207h)           ; key edges
	and 030h
	ret z
	and 010h
	jr z,put_exit_erase
	ld a,(0e26ah)           ; exit
	and a
	call nz,exit_undraw
	call exit_clear
	ld hl,0e2f1h
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	call edit_screen
	ld (hl),a
	ld a,001h
	ld (0e26ah),a           ; exit
	call edit_xy
	ld hl,exit_pat
exit_draw:
	ld bc,00404h
	push de
	push bc
	call tilemap_hmmm
	pop bc
	pop hl
; stamp_rect A=0 at HL after a tilemap blit.
edit_stamp0:                      ; 0x860E
	call edit_screen
	ld d,a
	xor a
	jp stamp_rect
put_exit_erase:
	call exit_undraw
	call exit_clear
	xor a
	ld (0e26ah),a           ; exit
	ret
; erase exit tiles if this screen
exit_undraw:                    ; 0x8621  erase exit tiles if this screen
	ld hl,0e2f3h
	call edit_screen
	cp (hl)
	ret nz
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)
	ld hl,floor_tiles
	jp exit_draw
; zero E2F0..E2F7
exit_clear:                     ; 0x8633  zero E2F0..E2F7
	ld hl,0e2f0h
	ld de,0e2f1h
	ld bc,00007h
	ld (hl),000h
	ldir
	ret
; Place-mode cursor SAT at E800 (E264/E265).
place_sat:                        ; 0x8641
	ld hl,0e800h            ; SAT
	ld a,(0e264h)
	add a,a
	add a,a
	add a,a
	ld (hl),a
	inc hl
	ld a,(0e265h)
	add a,a
	add a,a
	add a,a
	ld (hl),a
	inc hl
	ld (hl),01ch
	inc hl
	ld a,(0e203h)           ; puzzle board
	and 008h
	ld a,007h
	jr z,place_sat_cc
	xor a
place_sat_cc:
	ld hl,0d200h            ; boot spare
	jp cc_fill
cont_esc:                         ; 0x8667  GRAPH/ESC or after place -> E25A=5 (cont_edit)
	ld a,(0e20ch)           ; vic_die flag
	rla
	rla
	jr c,cont_to_edit
	call io_menu
	ld a,(0e25bh)           ; file I/O
	and a
	ret nz
cont_to_edit:
	ld hl,00005h
	ld (0e25ah),hl          ; continue script
	ret
; print_legend + 6x6 E788 map
edit_legend:                      ; 0x867D  print_legend + 6x6 E788 map
	ld a,001h
	call draw_minimap
	call page_bank_d
	ld hl,0bc54h                  ; print_legend
	call print_stream
	call page_banks_123
	ld de,0a090h
	ld hl,0e788h            ; screen ids
	ld bc,00606h
legend_row:
	push de
	push bc
	ld b,c
legend_col:
	ld a,(hl)
	and a
	ld c,0ffh
	jr z,legend_tile
	add a,0d0h
	ld c,a
legend_tile:
	ld a,c
	call tile_hmmm
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz legend_col
	pop bc
	pop de
	ld a,e
	add a,008h
	ld e,a
	inc hl
	inc hl
	djnz legend_row
	ret
; BLOCK 'delay_spr' (start 0x86B9 end 0x86C5)
delay_spr:                        ; 0x86B9  4 x (pat, cc, cc) for E2C0 SAT
	defb 068h, 00bh, 04ch
	defb 068h, 00ah, 047h
	defb 088h, 00ah, 047h
	defb 0c0h, 007h, 049h
; BLOCK 'floor_tiles' (start 0x86C5 end 0x86DD)
floor_tiles:                      ; 0x86C5  0xE0 fill (2x2 / 4x4 stamps)
	defb 0e0h, 0e0h, 0e0h, 0e0h
	defb 0e0h, 0e0h, 0e0h, 0e0h
	defb 0e0h, 0e0h, 0e0h, 0e0h
	defb 0e0h, 0e0h, 0e0h, 0e0h
	defb 0e0h, 0e0h, 0e0h, 0e0h
	defb 0e0h, 0e0h, 0e0h, 0e0h
; Repeat timer E21C; editor (mode 0x0B) auto-fire.
keys_repeat:                      ; 0x86DD
	ld hl,0e21ch            ; key repeat
	ld de,0e207h            ; key edges
	ld bc,0e208h            ; keys held
	ld a,(hl)
	cp 02dh
	jr nc,keys_hold
	ld a,(de)
	and 00fh
	jr nz,keys_reset
	ld a,(bc)
	and a
	jr z,keys_reset
	inc (hl)
	ret
keys_hold:
	ld a,(bc)
	and a
	jr z,keys_reset
	inc hl
	inc (hl)
	ld a,(hl)
	cp 005h
	ret nz
	ld (hl),000h
	ld a,(bc)
	ld (de),a
	ret
keys_reset:
	ld (hl),000h
	ret
; cursor with 2x1 / 2x2 step
edit_cursor2:                   ; 0x8708  cursor with 2x1 / 2x2 step
	exx
	ld a,(0e261h)           ; subtype
	ld bc,00201h
	cp 004h
	jr c,cursor_box
	ld c,002h
	cp 006h
	jr z,cursor_box
	jr cursor_1x1
; stick moves E264/E265 in E27C box
edit_cursor:                    ; 0x871B  stick moves E264/E265 in E27C box
	exx
cursor_1x1:
	ld bc,00101h
cursor_box:
	ld a,(0e2fbh)
	ld h,a
	and 00fh
	ld d,a
	ld a,h
	rrca
	rrca
	rrca
	rrca
	and 00fh
	ld e,a
	exx
	ld hl,0e264h
	ld de,0e265h
	ld bc,(0e27ch)
	ld a,(0e207h)           ; key edges
	rra
	jr c,cursor_up
	rra
	jr c,cursor_down
	rra
	jr c,cursor_left
	rra
	ret nc
	call sfx_32                   ; cursor
	ex de,hl
	ld a,(hl)
	exx
	add a,b
	exx
	ld (hl),a
	cp b
	ret c
	exx
	ld a,d
	exx
	ld (hl),a
	ret
cursor_up:
	call sfx_32                   ; cursor
	ld a,(hl)
	exx
	sub c
	exx
	ld (hl),a
	rla
	jr c,cursor_up_wrap
	exx
	cp e
	exx
	ret nc
cursor_up_wrap:
	ld (hl),c
	dec (hl)
	ret
cursor_down:
	call sfx_32                   ; cursor
	ld a,(hl)
	exx
	add a,c
	exx
	ld (hl),a
	cp c
	ret c
	exx
	ld a,e
	exx
	ld (hl),a
	ret
cursor_left:
	call sfx_32                   ; cursor
	ex de,hl
	ld a,(hl)
	exx
	sub b
	exx
	ld (hl),a
	rla
	jr c,cursor_left_wrap
	exx
	cp d
	exx
	ret nc
cursor_left_wrap:
	ld (hl),b
	dec (hl)
	ret
; each E7C0 rec -> secret_rect
secret_draw:                    ; 0x878B  each E7C0 rec -> secret_rect
	ld hl,0e7c0h            ; secrets
	ld b,010h
secret_draw_loop:
	push bc
	ld a,(hl)
	and a
	push hl
	call nz,secret_rect
	pop hl
	pop bc
	ld a,004h
	call ADD_HL_A
	djnz secret_draw_loop
	ret
; stamp_rect secret door at rec XY
secret_rect:                    ; 0x87A1  stamp_rect secret door at rec XY
	ld a,(hl)
	push af
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld a,(hl)
	and 01fh
	ld b,a
	ld c,002h
	ex de,hl
	pop de
	ld a,001h
	jp stamp_rect
; Rebuild ED80..EDB0 door links from E788.
link_build:                       ; 0x87B5
	ld hl,0e788h            ; screen ids
	ld bc,03001h
	xor a
	ld (0efc0h),a           ; stamp row
	ld (0efc1h),a
link_build_loop:
	ld a,(hl)
	cp c
	jr nz,link_build_next
	push hl
	push bc
	call link_scan
	pop bc
	pop hl
	inc c
	ld a,c
	cp 007h
	jr nc,link_build_ff
link_build_next:
	inc hl
	djnz link_build_loop
link_build_ff:
	ld a,(0efc0h)           ; stamp row
	ld hl,0ed80h            ; link up
	ld de,0ed90h            ; link down
	call link_ff
	ld a,(0efc1h)
	ld hl,0eda0h            ; link left
	ld de,0edb0h            ; link right
; write 0xFF into link table pair
link_ff:                        ; 0x87EB  write 0xFF into link table pair
	add a,a
	ld b,a
	call ADD_HL_A
	ld (hl),0ffh
	ld a,b
	call ADD_DE_A
	ld a,0ffh
	ld (de),a
	ret
; build ED80-EDB0 from E788 neighbours
link_scan:                      ; 0x87FA  build ED80-EDB0 from E788 neighbours
	push hl
	dec hl
	ld b,(hl)
	ld de,00007h
	or a
	sbc hl,de
	ld a,(hl)
	pop hl
	and a
	jr nz,link_scan_lr
	push hl
	push bc
	ld bc,0ed80h            ; link up
	ld de,0ed91h
	call link_ud
	ld hl,0efc0h            ; stamp row
	inc (hl)
	pop bc
	pop hl
link_scan_lr:
	ld a,b
	and a
	ret nz
	ld bc,0eda0h            ; link left
	ld de,0edb1h
	call link_lr
	ld hl,0efc1h
	inc (hl)
	ret
; fill up/down link words
link_ud:                        ; 0x882A  fill up/down link words
	ld a,(0efc0h)           ; stamp row
	add a,a
	push af
	add a,c
	ld c,a
	pop af
	add a,e
	ld e,a
	ld a,l
	sub 088h
	ld (bc),a
	ld (de),a
link_ud_scan:
	ld a,l
	add a,008h
	ld l,a
	ld a,(hl)
	and a
	jr nz,link_ud_scan
	ld a,l
	sub 008h
	ld l,a
	ld a,l
	sub 088h
	inc bc
	ld (bc),a
	dec de
	ld (de),a
	ret
; fill left/right link words
link_lr:                        ; 0x884D  fill left/right link words
	ld a,(0efc1h)
	add a,a
	push af
	add a,c
	ld c,a
	pop af
	add a,e
	ld e,a
	ld a,l
	sub 088h
	ld (bc),a
	ld (de),a
link_lr_scan:
	inc hl
	ld a,(hl)
	and a
	jr nz,link_lr_scan
	dec hl
	ld a,l
	sub 088h
	inc bc
	ld (bc),a
	dec de
	ld (de),a
	ret
; A indexes bb38_tbl (96-byte 1bpp map)
draw_minimap:                     ; 0x886A  A indexes bb38_tbl (96-byte 1bpp map)
	push af
	call scr_off
	pop af
	call page_bank_d
	ld hl,0bb38h
	call tbl_word
	ld de,00000h
	ld b,060h
	ld a,(0f0f4h)
	and a
	ld c,062h
	jr z,minimap_byte
	ld c,05eh
minimap_byte:
	push bc
	push hl
	ld a,(hl)
	ld b,008h
minimap_bit:
	rla
	push af
	ld a,c
	call c,tile_pset
	ld a,d
	add a,008h
	ld d,a
	jr nc,minimap_wrap
	ld a,e
	add a,008h
	ld e,a
minimap_wrap:
	pop af
	djnz minimap_bit
	pop hl
	inc hl
	pop bc
	djnz minimap_byte
	call page_banks_123
	call scr_on
	ret
; DISPATCH_A on E25B (file submenu)
io_menu:                        ; 0x88AB  DISPATCH_A on E25B (file submenu)
	ld a,(0e25bh)           ; file I/O
	dec a
	call DISPATCH_A

; BLOCK 'd88af_jp' (start 0x88b2 end 0x88be)
d88af_jp_start:
	defw io_open
	defw io_dev_keys
	defw io_save_yn
	defw io_enter
	defw io_commit
	defw io_go
d88af_jp_end:
io_open:                          ; 0x88BE  password / file menu + minimap
	call pwd_spaces
	call wmap_font
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0be14h
	call print_stream
	ld a,(0f0f9h)           ; io present
	rra
	ld de,06060h
	push af
	jr nc,io_open_disk
	ld hl,0be30h
	ld c,0ffh
	push de
	call print_at
	pop de
	ld a,e
	add a,010h
	ld e,a
io_open_disk:
	pop af
	rra
	ld hl,0be3ah
	ld c,0ffh
	call c,print_at
	call page_banks_123
	xor a
	ld (0e26dh),a
	ld (0e26eh),a
	ld (0e27fh),a           ; I/O error
	ld (0e21eh),a
; next file I/O substate
io_step:                        ; 0x8903  next file I/O substate
	ld hl,0e25bh            ; file I/O
	inc (hl)
	ret
; 0 in E270.. -> space
pwd_spaces:                     ; 0x8908  0 in E270.. -> space
	ld hl,0e270h            ; tape name
	ld b,00bh
pwd_space_loop:
	ld a,(hl)
	and a
	jr nz,pwd_space_next
	ld (hl),020h
pwd_space_next:
	inc hl
	djnz pwd_space_loop
	ret
io_dev_keys:                      ; 0x8917  stick: pick tape/disk/sram
	call io_dev_sat
	ld hl,0e26dh
	ld a,(0e207h)           ; key edges
	rra
	jr c,dev_left
	rra
	jr c,dev_right
	rra
	rra
	rra
	ret nc
	call sat_wipe
	call io_step
	call io_set_dev
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld a,(0f0f8h)           ; load device
	ld hl,0be26h
	and a
	jr z,io_dev_print
	ld hl,0be30h
	dec a
	jr z,io_dev_print
	ld hl,0be3ah
io_dev_print:
	ld de,05848h
	ld c,0ffh
	call print_at
	ld hl,0be82h
	call print_stream
	jp page_banks_123
dev_right:
	ld a,(0f0f9h)           ; io present
	and a
	ret z
	cp 003h
	ld b,002h
	jr z,dev_right_max
	dec b
dev_right_max:
	ld a,(hl)
	cp b
	ret nc
	inc (hl)
	jp sfx_32
dev_left:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
; cursor SAT for tape/disk/sram
io_dev_sat:                       ; 0x897A  cursor SAT for tape/disk/sram
	ld hl,0e800h            ; SAT
	ld a,(0e26dh)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,050h
	ld (hl),a
	inc hl
	ld (hl),048h
	inc hl
	ld (hl),014h
	inc hl
; SAT CC=8; MSX2 0xD200 fill
sat_col:                          ; 0x898E  SAT CC=8; MSX2 0xD200 fill
	ld (hl),008h
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,00010h
	ld (hl),007h
	ldir
	ret
; SRAM catalog UI (FILE1..3); save-Y/N when F0F8==2.
sram_menu:                        ; 0x89A3
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0be5ch
	call print_stream
	ld hl,0be44h
	call print_stream
	ld hl,0be4ch
	call print_stream
	ld hl,0be54h
	call print_stream
	call page_banks_123
	ld a,003h
	ld (0f0e5h),a           ; catalog count
	jp io_step
; E26D → F0F8 (tape/disk/sram)
io_set_dev:                       ; 0x89CD  E26D → F0F8 (tape/disk/sram)
	ld a,(0e26dh)
	ld b,a
	ld a,(0f0f9h)           ; io present
	and a
	jr z,io_dev_write
	cp 003h
	jr z,io_dev_write
	dec a
	jr z,io_dev_write
	ld a,b
	and a
	jr z,io_dev_write
	ld b,002h
io_dev_write:
	ld a,b
	ld (0f0f8h),a           ; load device
	ret
io_save_yn:                       ; 0x89E9  GRAPH/ESC then name or catalog
	call yn_keys
	and a
	ret z
	dec a
	jp nz,io_abort
	ld a,0e0h
	ld a,(0edeeh)
	call scr_reset
	ld a,(0f0f8h)           ; load device
	cp 002h
	jr z,sram_menu
	xor a
	call draw_minimap
	call io_step
	call page_bank_d
	ld hl,0bde9h
	call print_stream
	call page_banks_123
; 8 glyphs at E270 from 6058
pwd_print8:                     ; 0x8A14  8 glyphs at E270 from 6058
	ld de,06058h
; HL=E270 then print_name (B=8)
print_e270:                     ; 0x8A17  HL=E270 then print_name (B=8)
	ld hl,0e270h            ; tape name
; B glyphs at HL; +0xA0 stamp
print_name:                     ; 0x8A1A  B glyphs at HL; +0xA0 stamp
	ld b,008h
name_glyph:
	push bc
	ld a,(hl)
	cp 020h
	ld b,000h
	jr z,name_space
	add a,0a0h
	ld b,a
name_space:
	ld a,b
	push hl
	push de
	call tile_hmmm_at
	pop de
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	pop bc
	djnz name_glyph
	ret
; A=2 GRAPH, 1 ESC, 0 none
yn_keys:                        ; 0x8A38  A=2 GRAPH, 1 ESC, 0 none
	ld a,004h
	call SNSMAT
	cpl
	and 008h
	jr nz,yn_graph
	ld a,005h
	call SNSMAT
	cpl
	and 040h
	jr nz,yn_esc
	xor a
	ret
yn_graph:
	ld a,002h
	ret
yn_esc:
	ld a,001h
	ret
io_enter:                         ; 0x8A54  type filename / password glyphs
	ld a,(0f0f8h)           ; load device
	cp 002h
	jp z,sram_pick
; Type filename / password glyphs (tape pick also).
name_type:                        ; 0x8A5C
	call name_sat
	call keys_snap
	call pwd_decode
	ld a,(0ededh)
	and a
	jr z,name_idle
	cp 0e0h
	ld b,0a0h
	jr nz,name_graph
	ld b,0c0h
name_graph:
	sub b
	ld b,a
	ld hl,0e26eh
	ld a,(hl)
	cp 007h
	jr nc,name_add
	push af
	call sfx_32                   ; cursor
	pop af
	inc (hl)
name_add:
	ld hl,0e270h            ; tape name
	call ADD_HL_A
	ld (hl),b
	call pwd_print8
name_idle:
	ld a,(0e207h)           ; key edges
	rra
	rra
	rra
	jr c,name_left
	rra
	jr c,name_right
	ld a,(0e20ch)           ; vic_die flag
	rla
	ret nc
	call sat_wipe
	call sfx_01                   ; stop
	jp io_step
name_right:
	ld hl,0e26eh
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp sfx_32
name_left:
	ld hl,0e26eh
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
; filename cursor SAT
name_sat:                       ; 0x8ABB  filename cursor SAT
	ld hl,0e800h            ; SAT
	ld (hl),057h
	inc hl
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	add a,060h
	ld (hl),a
	inc hl
	ld (hl),020h
	inc hl
	jp sat_col
; SRAM: sram_keys then copy FILE n into E270.
sram_pick:                        ; 0x8AD1
	call sram_keys
	ret nc
sram_copy:
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	ld hl,file_name
	call ADD_HL_A
	ld de,0e270h            ; tape name
	ld bc,00008h
	ldir
	call sfx_01                   ; stop
	jp io_step
; BLOCK 'file_name' (start 0x8aef end 0x8b07)  8-byte slots FILE1..3
file_name:
	defb "FILE1   "
	defb "FILE2   "
	defb "FILE3   "
; SRAM catalog: file_pick_sat then CY from fire.
sram_keys:                        ; 0x8B07
	call file_pick_sat
io_file_keys:                     ; 0x8B0A  stick left/right on E26E
	ld hl,0e26eh
	ld a,(0e207h)           ; key edges
	rra
	jr c,slot_left
	rra
	jr c,slot_right
	rra
	rra
	rra
	ret c
	ld a,(0e20ch)           ; vic_die flag
	rla
	ret
slot_left:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	ret
slot_right:
	ld a,(0f0e5h)           ; catalog count
	dec a
	cp (hl)
	ret z
	inc (hl)
	ret
; SRAM slot cursor SAT (Y from E26E).
file_pick_sat:                    ; 0x8B2C
	ld hl,0e800h            ; SAT
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,050h
	ld (hl),a
	inc hl
	ld (hl),058h
	inc hl
	ld (hl),014h
	inc hl
	jp sat_col
io_commit:                        ; 0x8B43
	call io_save
io_sfx:
	call sfx_11                   ; title cursor
	ld a,(0e27fh)           ; I/O error
	cp 002h
	jr z,io_err
; GRAPH from save Y/N: clear E25B.
io_abort:                         ; 0x8B50
	xor a
	ld (0e25bh),a           ; file I/O
	jp scr_reset
io_err:
	ld a,(0f0f8h)           ; load device
	dec a
	jr z,io_next_jp
	call sat_wipe
	call scr_reset
	call page_bank_d
	ld hl,0be6ah
	call print_stream
	call page_banks_123
io_next_jp:
	jp io_step
; save via tape/disk/sram
io_save:                          ; 0x8B72  save via tape/disk/sram
	ld a,(0f0f8h)           ; load device
	or a
	jr z,io_tape_save
	dec a
	jp z,dos_do_save
	jp disk_do_load
io_tape_save:
	call page_bank_c
	call 0bf2bh                   ; tape_save (bank 0C MODULE)
	jp page_banks_123
io_go:                            ; wait any key, E25B=1
	ld a,(0e207h)           ; key edges
	and a
	ret z
	ld a,001h
	ld (0e25bh),a           ; file I/O
	jp scr_reset
; continue/file I/O: E25B-1 -> d_8b99
io_tick:                          ; 0x8B95  continue/file I/O: E25B-1 -> d_8b99
	ld a,(0e25bh)           ; file I/O
	dec a
	call DISPATCH_A

; BLOCK 'd_8b99_jp' (start 0x8b9c end 0x8bac)  continue load/save (1-based E25B)
d_8b99_jp_start:
	defw io_ask
	defw io_yn
	defw io_dev
	defw io_name
	defw io_pick
	defw io_load
	defw io_done
	defw io_list
d_8b99_jp_end:
io_ask:                           ; 0x8BAC  "load data } yes/no"
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0bd6dh                  ; "load data } yes/no"
	call print_stream
	call page_banks_123
	call ram_wipe
	call name_wipe
; next file I/O substate
io_next:                          ; 0x8BC5  next file I/O substate
	ld hl,0e25bh            ; file I/O
	inc (hl)
	ret
io_yn:                            ; 0x8BCA  E26D 0/1; fire yes -> io_mode, no -> E25B=0
	call io_yn_sat
	ld hl,0e26dh
	ld a,(0e207h)           ; key edges
	ld b,a
	and 003h
	jr z,yn_fire
	ld a,(hl)
	xor 001h
	ld (hl),a
	jp sfx_32
yn_fire:
	ld a,b
	and 010h
	ret z
	ld a,(hl)
	and a
	jr nz,yn_no
io_mode:                          ; 0x8BE7  "| load mode |" + tape/disk/sram
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0bdb9h                  ; "| load mode |" / "tape load"
	call print_stream
	call page_banks_123
	ld a,(0f0f9h)           ; io present
	rra
	ld de,06060h
	push af
	jr nc,io_mode_disk
	call page_bank_d
	ld hl,0bdd5h
	ld c,0ffh
	push de
	call print_at
	pop de
	ld a,e
	add a,010h
	ld e,a
	call page_banks_123
io_mode_disk:
	pop af
	rra
	call page_bank_d
	ld hl,0bddfh
	ld c,0ffh
	call c,print_at
	call page_banks_123
	xor a
	ld (0e26dh),a
	jr io_next
yn_no:
	xor a
	ld (0e25bh),a           ; file I/O
	ret
; yes/no cursor SAT
io_yn_sat:                        ; 0x8C33  yes/no cursor SAT
	ld hl,0e800h            ; SAT
	ld a,(0e26dh)
	and a
	ld a,058h
	jr z,io_yn_x
	ld a,068h
io_yn_x:
	ld (hl),a
	inc hl
	ld (hl),068h
	inc hl
	ld (hl),014h
	inc hl
	call sat_col
	ret
; GRAPH: E25B=1 (back to device pick).
io_esc:                           ; 0x8C4C
	ld a,001h
	ld (0e25bh),a           ; file I/O
	ret
io_dev:                           ; 0x8C52  pick tape/disk/sram -> F0F8
	ld a,(0e20ch)           ; vic_die flag
	rla
	rla
	jr c,io_esc
	call io_dev_sat
	ld hl,0e26dh
	ld a,(0e207h)           ; key edges
	rra
	jr c,io_dev_left
	rra
	jr c,io_dev_right
	rra
	rra
	rra
	ret nc
	call io_set_dev
	call sat_wipe
	call scr_reset
	call io_next
	jp sfx_01
io_dev_right:
	ld a,(0f0f9h)           ; io present
	and a
	ret z
	cp 003h
	ld b,002h
	jr z,io_dev_right_max
	dec b
io_dev_right_max:
	ld a,(hl)
	cp b
	ret nc
	inc (hl)
	jp sfx_32
io_dev_left:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
io_name:                          ; 0x8C95  F0F8: tape name / disk catalog / sram files
	ld a,(0f0f8h)           ; load device
	dec a
	jp z,io_dos_dir
	dec a
	jr z,io_sram_dir
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0bde9h
	call print_stream
	call page_banks_123
	call sfx_11                   ; title cursor
	jp io_next
io_sram_dir:
	call disk_dir
	ld a,(0f0e5h)           ; catalog count
	and a
	jr z,io_nofile
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0be5ch
	call print_stream
	call page_banks_123
	ld hl,0ee54h
	ld de,07050h
	ld b,003h
dir_loop:
	ld a,(hl)
	and a
	jr z,dir_skip
	push hl
	push de
	push bc
	call page_bank_d
	call print_mode
	call page_banks_123
	pop bc
	pop de
	pop hl
	ld a,e
	add a,010h
	ld e,a
dir_skip:
	ld a,008h
	call ADD_HL_A
	djnz dir_loop
	call io_next
	jp sfx_11
; tape/disk/sram stream from A-'1'
print_mode:                     ; 0x8CFA  tape/disk/sram stream from A-'1'
	sub 031h
	and a
	jr z,mode_tape
	dec a
	jr z,mode_disk
	ld hl,0be56h
	ld c,0ffh
	jp print_at
mode_tape:
	ld hl,0be46h
	ld c,0ffh
	jp print_at
mode_disk:
	ld hl,0be4eh
	ld c,0ffh
	jp print_at
io_nofile:                        ; 0x8D1A  str_nofile
	call scr_reset
	call page_bank_c
	ld hl,0af7dh                  ; str_nofile
	call print_stream
	call page_banks_123
	ld a,007h
	ld (0e25bh),a           ; file I/O
	jp sfx_11
; Disk catalog then file_list.
io_dos_dir:                       ; 0x8D31
	call dos_dir
	ld a,(0f0e5h)           ; catalog count
	and a
	jr z,io_nofile
	call io_next
	call sfx_11                   ; title cursor
; draw EE50 catalog names
file_list:                      ; 0x8D40  draw EE50 catalog names
	call scr_reset
	ld a,001h
	call draw_minimap
	call page_bank_d
	ld hl,0bd86h
	call print_stream
	call page_banks_123
	ld hl,0ee50h            ; E300 list / tape
	ld de,03020h
	ld b,008h
file_loop:
	push bc
	push hl
	push de
	call print_name
	pop de
	pop hl
	pop bc
	ld a,00bh
	call ADD_HL_A
	ld a,(hl)
	and a
	ret z
	push bc
	push hl
	push de
	ld d,0a0h
	call print_name
	pop de
	pop hl
	pop bc
	ld a,00bh
	call ADD_HL_A
	ld a,(hl)
	and a
	ret z
	ld a,e
	add a,010h
	ld e,a
	djnz file_loop
	ret
io_pick:                          ; 0x8D87  cursor on EE50 files; M=next, RET=load
	ld a,(0e20ch)           ; vic_die flag
	rla
	rla
	jp c,io_esc
	ld a,(0f0f8h)           ; load device
	and a
	jp z,name_type
	dec a
	jp nz,sram_load_name
	ld a,(0e207h)           ; key edges
	and 020h
	jr nz,pick_m
	call io_pick_sat
	ld a,(0f0e5h)           ; catalog count
	ld b,a
	ld hl,0e26eh
	ld a,(0e207h)           ; key edges
	rra
	jr c,pick_up
	rra
	jr c,pick_down
	rra
	jr c,pick_left
	rra
	jr c,pick_right
	ld a,(0e20ch)           ; vic_die flag
	rla
	ret nc
	ld a,(hl)
	and a
	jr z,pick_base
	ld b,a
	xor a
pick_off:
	add a,00bh
	djnz pick_off
pick_base:
	ld hl,0ee50h            ; E300 list / tape
	call ADD_HL_A
	ld de,0e270h            ; tape name
	ld bc,0000bh
	ldir
	call scr_reset
	call sat_wipe
	call page_bank_d
	ld hl,0be06h                  ; "now loading"
	call print_stream
	call page_banks_123
	call sfx_01                   ; stop
	jp io_next
pick_m:
	call sfx_01                   ; stop
	ld a,008h
pick_set:
	ld (0e25bh),a           ; file I/O
	ret
io_list:                          ; 0x8DF8  catalog; continue -> io_pick, title -> edit_gfx
	call dos_dir
	call file_list
	xor a
	ld (0e26eh),a
	call sfx_11                   ; title cursor
	ld a,(0e200h)           ; game mode
	cp 00bh
	ld a,005h
	jr z,pick_set
	dec a
	jr pick_set
pick_up:
	ld a,(hl)
	cp 002h
	ret c
	dec (hl)
	dec (hl)
	jp sfx_32
pick_down:
	ld a,(hl)
	inc a
	inc a
	cp b
	ret nc
	inc (hl)
	inc (hl)
	jp sfx_32
pick_left:
	ld a,(hl)
	rra
	ret nc
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
pick_right:
	ld a,(hl)
	rra
	ret c
	ld a,(hl)
	inc a
	cp b
	ret nc
	inc (hl)
	jp sfx_32
; file-list cursor SAT
io_pick_sat:                      ; 0x8E39  file-list cursor SAT
	ld de,0e26eh
	ld hl,0e800h            ; SAT
	ld a,(de)
	and 0feh
	add a,a
	add a,a
	add a,a
	add a,020h
	ld (hl),a
	inc hl
	ld a,(de)
	rra
	ld a,018h
	jr nc,pick_sat_x
	ld a,088h
pick_sat_x:
	ld (hl),a
	inc hl
	ld (hl),014h
	inc hl
	call sat_col
	ret
; SRAM load: sram_keys then copy EE50 slot name.
sram_load_name:                   ; 0x8E5A
	call sram_keys
	ret nc
	ld hl,0e270h            ; tape name
	ld de,0e271h
	ld bc,00007h
	ld (hl),020h
	ldir
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	ld hl,0ee50h            ; E300 list / tape
	call ADD_HL_A
	ld de,0e270h            ; tape name
	ld bc,00005h
	ldir
	call sat_wipe
	call sfx_01                   ; stop
	jp io_next
io_load:                          ; 0x8E88  do load (tape/disk/sram)
	call io_do_load
	ld a,001h
	ld (0e27eh),a
	call sfx_11                   ; title cursor
	ld a,(0e27fh)           ; I/O error
	cp 002h
	jp z,io_next
	call scr_reset
	xor a
	ld (0e25bh),a           ; file I/O
	ret
; F0F8 → tape/disk/sram load
io_do_load:                       ; 0x8EA3  F0F8 → tape/disk/sram load
	ld a,(0f0f8h)           ; load device
	or a
	jr z,io_tape_load
	dec a
	jp z,dos_do_load
	jp disk_do_save
io_tape_load:
	call page_bank_c
	call 0be7eh                   ; tape_load (bank 0C MODULE)
	jp page_banks_123
io_done:                          ; 0x8EB9  wait key; E27E=2, E25B=0
	ld a,(0e207h)           ; key edges
	and a
	ret z
	ld a,002h
	ld (0e27eh),a
	call scr_reset
	xor a
	ld (0e25bh),a           ; file I/O
	ret
; file_blit + E25B=1 (disk/editor)
disk_init:                        ; 0x8ECB  file_blit + E25B=1 (disk/editor)
	call file_blit
	call sat_wipe
	xor a
	ld (0e24ah),a
	inc a
	ld (0e25bh),a           ; file I/O
	ret
; E25B-1 -> d_8ede
disk_tick:                        ; 0x8EDA  E25B-1 -> d_8ede
	ld a,(0e25bh)           ; file I/O
	dec a
	call DISPATCH_A

; BLOCK 'd_8ede_jp' (start 0x8ee1 end 0x8ef1)  title disk/editor (1-based E25B)
d_8ede_jp_start:
	defw edit_boot
	defw io_dev
	defw io_name
	defw io_pick
	defw edit_gfx
	defw edit_play
	defw edit_key
	defw io_list
d_8ede_jp_end:
edit_boot:                        ; 0x8EF1  world 1, gfx, then io_mode
	ld a,001h
	ld (0e241h),a           ; world
	call load_world_gfx
	ld a,(0f0f4h)
	and a
	call nz,pal_15
	call rle_minimap
	call ram_wipe
	call name_wipe
	jp io_mode
; clear E226 and E280 work RAM
ram_wipe:                       ; 0x8F0C  clear E226 and E280 work RAM
	xor a
	ld hl,0e226h            ; score
	ld de,0e227h
	ld bc,00032h
	ld (hl),a
	ldir
	ld hl,0e280h            ; Vic state
	ld de,0e281h
	ld bc,00d7fh
	ld (hl),a
	ldir
	ld (0e26dh),a
	ld (0e26eh),a
	ld (0e27fh),a           ; I/O error
	ld (0e26fh),a
	ld (0e27eh),a
	jp sat_wipe
edit_gfx:                         ; 0x8F37  reload world gfx
	call edit_reset
	jp io_next
edit_play:                        ; 0x8F3D  enter play (E24A=1, E254=1)
	call io_do_load
	ld a,(0e27fh)           ; I/O error
	and a
	jp nz,io_next
	call screen_idx
	call vic_reset
	call e300_list
	call secret_draw
	ld a,001h
	ld (0e24ah),a
	ld (0e254h),a
	ld a,(0e282h)           ; Vic Y
	or a
	ret nz
	ld (0e294h),a
	ret
edit_key:                         ; 0x8F64  wait key, E24A=2
	ld a,(0e207h)           ; key edges
	and a
	ret z
	call scr_reset
	ld a,002h
	ld (0e24ah),a
	ret
; reload pats; clear E2C0; world 1
edit_reset:                     ; 0x8F72  reload pats; clear E2C0; world 1
	call pat_15
	call col_15
	call vic_pat_far
	xor a
	ld hl,0e2c0h            ; delayed pickups
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),a
	ldir
	ld (0e287h),a           ; held tool
	ld (0edcdh),a
	inc a
	ld (0e241h),a           ; world
	call sat_wipe
	ret
; b8f8_tbl[level] -> E2F1 exit door
load_exit:                        ; 0x8F96  b8f8_tbl[level] -> E2F1 exit door
	call page_bank_d
	ld a,(0e242h)           ; level
	ld b,a
	add a,a
	add a,b
	ld hl,0b8f8h                  ; exit door X/Y/(scr<<5|shape)
	call ADD_HL_A
	ld de,0e2f1h
	ldi
	ldi
	ld a,(hl)
	rlca
	rlca
	rlca
	and 007h
	ld (de),a
	inc de
	inc de
	inc de
	xor a
	ld (de),a
	call page_banks_123
	jp count_gems
; all gems + Vic at door -> E257=0, mode_clear
probe_exit:                       ; 0x8FBE  all gems + Vic at door -> E257=0, mode_clear
	ld hl,0e2f3h
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	ld a,(0e2f5h)           ; gems left
	and a
	ret nz
	ld a,(0e282h)           ; Vic Y
	ld b,a
	ld a,(0e284h)           ; Vic X
	ld c,a
	ld a,(0e2f1h)
	add a,012h
	sub b
	cp 004h
	ret nc
	ld a,(0e2f2h)
	add a,00ah
	sub c
	cp 004h
	ret nc
	call wipe_tools
	xor a
	ld (0e2f0h),a
	ld hl,0e257h            ; script index
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld (hl),a
	inc a
	ld (0e249h),a
	ld hl,0e2f7h
	ld (hl),01eh
	call sfx_23                   ; walk-in clear
	call copy_abb9
	xor a
	ld (0e21bh),a
	call 0723dh
	ld bc,00007h
	jp WRTVDP
; exit-door metatile if this is its screen
draw_exit:                        ; 0x9010  exit-door metatile if this is its screen
	ld a,(0e2f3h)
	ld b,a
	ld a,(0e243h)           ; screen
	cp b
	ret nz
	ld hl,exit_pat
	ld a,(0e2f6h)
	add a,a
	add a,a
	add a,a
	add a,a
	call ADD_HL_A
	ld bc,00404h
	ld de,(0e2f1h)
exit_row:
	push bc
	push de
	ld b,c
exit_col:
	ld a,(hl)
	push hl
	call tile_pset
	pop hl
	inc hl
	ld a,d
	add a,008h
	ld d,a
	djnz exit_col
	pop de
	pop bc
	ld a,e
	add a,008h
	ld e,a
	djnz exit_row
	ld de,(0e2f4h)
	ld a,d
	and a
	ret z
	call page_bank_d
	ld a,e
	ld hl,0b9adh                  ; exit-door metatile by shape
	call tbl_word
	ld b,d
exit_mark:
	ld de,(0e2f1h)
	ld a,(hl)
	and 003h
	add a,a
	add a,a
	add a,a
	add a,d
	ld d,a
	ld a,(hl)
	and 00ch
	add a,a
	add a,e
	ld e,a
	ld a,(0f0f4h)
	and a
	ld a,060h
	jr z,exit_msx1
	ld a,0aeh
exit_msx1:
	push hl
	call tile_pset
	pop hl
	inc hl
	djnz exit_mark
	call page_banks_123
	ret
; zero E500 and E300; sat_wipe
wipe_tools:                     ; 0x907F  zero E500 and E300; sat_wipe
	ld hl,0e500h            ; thrown tools
	ld de,0e501h
	ld bc,000ffh
	ld (hl),000h
	ldir
	ld hl,0e300h            ; map tools
	ld de,0e301h
	ld bc,001ffh
	ld (hl),000h
	ldir
	call sat_wipe
	jp spr_clear
; scan EE50 then pack + draw_maptools
tools_redraw:                   ; 0x909F  scan EE50 then pack + draw_maptools
	push ix
	call tools_scan
	pop ix
	call tools_pack
	jr draw_maptools
; each occupied E300: undraw / draw if on-screen
tools_scan:                     ; 0x90AB  each occupied E300: undraw / draw if on-screen
	ld hl,0ee50h            ; E300 list / tape
	ld b,040h
scan_loop:
	ld a,(hl)
	or a
	ret z
	call e300_ix
	ld a,(ix+000h)
	or a
	jr z,scan_next
	and 0f0h
	jr z,scan_draw
	cp 0f0h
	jr nz,scan_next
	call tool_id
scan_draw:
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	jr nz,scan_next
	push hl
	push bc
	call tool_undraw
	pop bc
	pop hl
scan_next:
	inc hl
	djnz scan_loop
	ret
; ix+0 &= 0x1F (drop in-use nibble)
tool_id:                        ; 0x90DA  ix+0 &= 0x1F (drop in-use nibble)
	ld a,(ix+000h)
	and 01fh
	ld (ix+000h),a
	ret
; 16x16 HMMM restore under a map tool
tool_undraw:                    ; 0x90E3  16x16 HMMM restore under a map tool
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+001h)
	ld d,(ix+002h)
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
; E300 on this screen -> tiles
draw_maptools:                    ; 0x90F7  E300 on this screen -> tiles
	ld hl,0ee8fh
	ld b,040h
maptools_loop:
	ld a,(hl)
	or a
	jr z,maptools_next
	call e300_ix
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	jr nz,maptools_next
	push bc
	push hl
	call tool_stamp
	pop hl
	pop bc
maptools_next:
	dec hl
	djnz maptools_loop
	ret
; 2x2 tool tiles at ix+1/2
tool_stamp:                     ; 0x9116  2x2 tool tiles at ix+1/2
	ld a,(ix+000h)
	or a
	ret z
	and 0f0h
	ret nz
	call tool_save
	ld hl,tool_stamp_pat
	ld a,(ix+000h)
	dec a
	add a,a
	add a,a
	ld e,a
	ld d,000h
	add hl,de
	ld e,(ix+001h)
	ld d,(ix+002h)
	ld bc,00202h
	jp draw_tilemap
; 16x16 HMMM backup under a map tool
tool_save:                      ; 0x913A  16x16 HMMM backup under a map tool
	call tool_vram
	ld (ix+004h),e
	ld (ix+005h),d
	ld l,(ix+001h)
	ld h,(ix+002h)
	ld bc,01010h
	ld a,004h
	jp vdp_hmmm
; E300 slot -> VRAM backup dest DE
tool_vram:                      ; 0x9151  E300 slot -> VRAM backup dest DE
	push ix
	pop hl
	ld de,0e300h            ; map tools
	and a
	sbc hl,de
	ld a,l
	rla
	ld a,h
	rla
	rla
	rla
	rla
	rla
	and 030h
	add a,060h
	ld e,a
	ld a,l
	rla
	and 0f8h
	ld d,a
	ret
; E300 in-use -> SAT at E810
tools_sat:                        ; 0x916D  E300 in-use -> SAT at E810
	call tools_sat_off
	ld hl,0e300h            ; map tools
	ld de,0e810h
	ld b,040h
sat_loop:
	push bc
	push hl
	ld a,(hl)
	and 00fh
	cp 003h
	jr nc,sat_next
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	cp 002h
	call nc,tool_sat2
sat_next:
	pop hl
	ld bc,00008h
	add hl,bc
	pop bc
	djnz sat_loop
	ret
; park 12 SAT slots at E810 (Y=0xE0)
tools_sat_off:                  ; 0x9196  park 12 SAT slots at E810 (Y=0xE0)
	ld b,00ch
	ld hl,0e810h
sat_off_loop:
	ld (hl),0e0h
	ld de,00004h
	add hl,de
	djnz sat_off_loop
	ret
; two SAT entries, DE += 8
tool_sat2:                      ; 0x91A4  two SAT entries, DE += 8
	push de
	call tool_sat1
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	ret
; one E300 slot -> SAT + colour
tool_sat1:                      ; 0x91B2  one E300 slot -> SAT + colour
	ld a,(hl)
	ex af,af'
	ld a,(0e243h)           ; screen
	inc l
	ldi
	ldi
	cp (hl)
	jr nz,sat_hide
	inc l
	ld a,(hl)
	ld hl,tool_pat
	call ADD_HL_A
	ldi
	push de
	dec e
	ld a,(de)
	ld c,a
	dec e
	ld a,(de)
	ld b,a
	dec e
	ld a,(de)
	pop hl
	push de
	inc l
	ld (hl),a
	inc l
	ld (hl),b
	inc l
	ld a,c
	add a,004h
	ld (hl),a
	ex af,af'
	and 00fh
	dec a
	add a,a
	ld hl,tool_cc
	call ADD_HL_A
	ld a,(hl)
	inc hl
	ld d,(hl)
	exx
	pop hl
	push af
	ld de,01800h
	add hl,de
	ld a,l
	rla
	rla
	and 0f0h
	ld hl,0d200h            ; boot spare
	call ADD_HL_A
	pop af
	ld d,h
	ld e,l
	inc de
	ld bc,0000fh
	ld (hl),a
	ldir
	exx
	ld a,d
	exx
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),a
	ldir
	exx
	ret
sat_hide:
	dec de
	dec de
	ld a,0e0h
	ld (de),a
	ret
; occupied E300 slots -> 0-term ids at EE50
e300_list:                        ; 0x921A  occupied E300 slots -> 0-term ids at EE50
	ld ix,0e300h            ; map tools
	ld hl,0ee50h            ; E300 list / tape
	ld bc,04001h
	ld de,00008h
e300_occ:
	ld a,(ix+000h)
	or a
	jr z,e300_skip
	ld (hl),c
	inc hl
e300_skip:
	inc c
	add ix,de
	djnz e300_occ
	ld (hl),000h
	ret
; Move this E300 id to the front of EE50.
e300_front:                       ; 0x9237
	call e300_index
	ld a,c
	or a
	ret z
	ld b,000h
	ld d,h
	ld e,l
	ld a,(hl)
	dec hl
	lddr
	ld hl,0ee50h            ; E300 list / tape
	ld (hl),a
	ret
; compact EE50 occupancy list
tools_pack:                     ; 0x924A  compact EE50 occupancy list
	call e300_index
	ld d,h
	ld e,l
	ld b,(hl)
	inc hl
	ld a,(hl)
	or a
	ret z
	push bc
pack_loop:
	ldi
	ld a,(hl)
	or a
	jr nz,pack_loop
	pop af
	ld (de),a
	ret
; IX-E300 -> slot index A
e300_index:                     ; 0x925E  IX-E300 -> slot index A
	push ix
	pop hl
	ld de,0e300h            ; map tools
	and a
	sbc hl,de
	ld a,l
	rr h
	rra
	rr h
	rra
	rr h
	rra
	inc a
	ld c,000h
	ld hl,0ee50h            ; E300 list / tape
index_loop:
	cp (hl)
	ret z
	inc hl
	inc c
	jr index_loop
; A = slot id at (HL) -> IX = E300+n*8
e300_ix:                        ; 0x927D  A = slot id at (HL) -> IX = E300+n*8
	push hl
	call e300_ix_a
	pop hl
	ret
; A = 1-based slot -> IX = E300+(A-1)*8
e300_ix_a:                      ; 0x9283  A = 1-based slot -> IX = E300+(A-1)*8
	dec a
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,0e300h            ; map tools
	add hl,de
	push hl
	pop ix
	ret

; BLOCK 'tool_cc' (start 0x9292 end 0x9296)  knife/boomerang SAT colour words
tool_cc:
	defw 0470bh
	defw 04a07h
; BLOCK 'tool_pat' (start 0x9296 end 0x929d)  E300 ix+4 -> sprite pattern
tool_pat:
	defb 010h
	defb 018h
	defb 020h
	defb 028h
	defb 030h
	defb 038h
	defb 040h
; clear E280, spawn from 0xB844 + level*3
load_vic:                         ; 0x929D  clear E280, spawn from 0xB844 + level*3
	ld hl,0e280h            ; Vic state
	ld de,0e281h
	ld (hl),000h
	ld bc,00040h
	ldir
	call page_bank_d
	ld a,(0e242h)           ; level
vic_ptr:
	ld b,a
	add a,a
	add a,b
	ld hl,0b844h                  ; Vic spawn Y/X/screen; e242*3
	call ADD_HL_A
	ld a,(hl)
	ld (0e282h),a                 ; Y
	inc hl
	ld a,(hl)
	ld (0e284h),a                 ; X
vic_scr:
	inc hl
	ld a,(hl)
	ld (0e243h),a           ; screen
	call page_banks_123
; pose bytes, walk or hold (E202 bit 6)
vic_reset:                        ; 0x92CA  pose bytes, walk or hold (E202 bit 6)
	ld hl,vic_pose
	ld de,0e28ah
	ld bc,00008h
	ldir
	ld a,004h
	ld (0e296h),a
	ld a,001h
	ld (0e285h),a           ; vic frame
	ld a,(0e202h)           ; vic flags
	and 040h
	ld a,00eh                     ; 14 hold if e202 bit 6, else walk
	jr nz,vic_pose_set
	xor a
vic_pose_set:
	ld (0e280h),a           ; Vic state
	ld a,020h
	ld (0e2a8h),a           ; hold timer
	ld a,006h
	ld (0e2a4h),a
	ret

; BLOCK 'vic_pose' (start 0x92f7 end 0x92ff)  8 bytes copied to E28A
vic_pose:
	defb 000h
	defb 0feh
	defb 000h
	defb 002h
	defb 000h
	defb 0feh
	defb 000h
	defb 002h
; vic_die / vic_hit: overlay SAT (E298) and unpack rle_953d (vic_die.png).
vic_hurt:                         ; 0x92FF
	xor a
	ld (0e295h),a
	ld (0e285h),a                 ; hmm frame
	ld a,(0e280h)           ; Vic state
	cp 004h                       ; vic_die
	jr nz,hurt_die
	ld a,004h
	ld (0e285h),a           ; vic frame
hurt_die:
	ld a,001h
	ld (0e298h),a                 ; die / hit SAT
	ld hl,0e215h            ; H.TIMI debounce
	ld (hl),000h
	ld a,003h
	ld (0e296h),a
	jp vic_die_rle
gem_pat:                          ; 0x9324  2x2 soul-stone tiles
	defb 0afh, 0b0h, 0b1h, 080h
tool_stamp_pat:                   ; 0x9328  6 tools x 2x2 (knife..drill)
	defb 081h, 082h, 0bch, 0bdh
	defb 000h, 000h, 089h, 08ah
	defb 086h, 087h, 0b8h, 088h
	defb 0b9h, 0bbh, 0bah, 083h
	defb 0b4h, 0b5h, 0b6h, 084h
	defb 0b2h, 0b3h, 0b7h, 085h
exit_pat:                         ; 0x9340  3 x 4x4 exit-door shapes (E2F6)
	defb 063h, 064h, 065h, 066h, 067h, 068h, 069h, 06ah, 06bh, 06ch, 06dh, 06eh, 06fh, 070h, 071h, 072h
	defb 064h, 058h, 059h, 065h, 068h, 05ah, 05bh, 069h, 06ch, 05ch, 05dh, 06dh, 070h, 078h, 078h, 071h
	defb 073h, 058h, 059h, 074h, 075h, 05ah, 05bh, 076h, 075h, 05ch, 05dh, 076h, 077h, 078h, 078h, 079h
stone_pat:                        ; 0x9370  2x2 stone
	defb 05fh, 060h, 061h, 062h
coffin_pat:                       ; 0x9374  editor coffin preview (stamp_coffin)
	defb 08bh, 08ch, 08dh, 08eh, 092h, 091h, 090h, 08fh
pyoncy_l0:                        ; 0x937C  editor pyoncy, facing clear
	defb 0beh, 000h, 095h, 0c1h, 07ah, 07bh, 095h, 0c1h
pyoncy_l1:                        ; 0x9384
	defb 0bfh, 000h, 096h, 0c1h, 07ch, 07dh, 096h, 0c1h
pyoncy_l2:                        ; 0x938C
	defb 0c0h, 000h, 097h, 0c3h, 07eh, 07fh, 097h, 0c3h
pyoncy_r0:                        ; 0x9394  editor pyoncy, facing set
	defb 000h, 0c4h, 0c7h, 098h, 07ah, 07bh, 0c7h, 098h
pyoncy_r1:                        ; 0x939C
	defb 000h, 0c5h, 0c8h, 099h, 07ch, 07dh, 0c8h, 099h
pyoncy_r2:                        ; 0x93A4
	defb 000h, 0c6h, 0c9h, 09ah, 07eh, 07fh, 0c9h, 09ah
throw_under:                      ; 0x93AC  3x2 under a thrown tool
	defb 09bh, 09ch, 09dh, 09eh, 09fh, 0a0h
knife_stamp:                      ; 0x93B2
	defb 0a1h, 0a2h, 0a3h, 0a4h, 0a5h, 0a6h
boom_stamp:                       ; 0x93B8
	defb 0a7h, 0a8h, 0a9h, 0aah, 0abh, 0ach
; if entered from U/D, bump type-5 stones
nudge_stones:                     ; 0x93BE  if entered from U/D, bump type-5 stones
	ld a,(0e2f9h)
	cp 003h
	ret c
	ld ix,0e600h            ; actors
	ld b,010h
stone_nudge_loop:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_clamp
	ld bc,00010h
	add ix,bc
	pop bc
	djnz stone_nudge_loop
	ret
; clamp stone X to 0x10..0xE0
stone_clamp:                    ; 0x93DC  clamp stone X to 0x10..0xE0
	ld a,(ix+003h)
	cp 010h
	jr nc,clamp_right
	ld (ix+003h),010h
	jr clamp_done
clamp_right:
	cp 0e8h
	ret c
	ld (ix+003h),0e0h
clamp_done:
	jp stone_under_xy
tick_stone:                       ; 0x93F3  E600 type 5: d93f6 on ix+1
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd93f6_jp' (start 0x93f9 end 0x93ff)
d93f6_jp_start:
	defw stone_idle
	defw stone_push
	defw stone_fall
d93f6_jp_end:
stone_idle:                       ; 0x93FF  wait for Vic shove
	call stone_probe
	jr nc,stone_shove
	ld a,002h
	ld (ix+001h),a
	dec a
	ld (ix+006h),a
	ret
stone_shove:
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld a,(0e280h)           ; Vic state
	and a
	ret nz
	ld a,(0e282h)           ; Vic Y
	add a,00fh
	sub (ix+002h)
	cp 010h
	jr nc,stone_wait
	ld a,(0e294h)
	and a
	ld a,(0e284h)           ; Vic X
	ld b,(ix+003h)
	jr z,shove_left
	add a,014h
	sub b
	cp 008h
	jr nc,stone_wait
	ld a,(0e208h)           ; keys held
	and 008h
	jr z,stone_wait
	dec (ix+006h)
	ret nz
	res 1,(ix+007h)
stone_go_push:
	inc (ix+001h)
	ret
shove_left:
	sub 00ch
	sub b
	cp 008h
	jr nc,stone_wait
	ld a,(0e208h)           ; keys held
	and 004h
	jr z,stone_wait
	dec (ix+006h)
	ret nz
	set 1,(ix+007h)
	jr stone_go_push
stone_wait:
	ld (ix+006h),00ah
	ret
stone_push:                       ; 0x9469  slide on facing until wall
	bit 1,(ix+007h)
	ld bc,00002h
	jr nz,push_left
	ld bc,0f003h
push_left:
	ld a,(ix+003h)
	cp b
	jr z,push_edge
	call stone_step
	jr nc,stone_idle_set
	bit 1,(ix+007h)
	ld a,(ix+003h)
	ld (ix+00bh),a
	jr nz,push_x_r
	add a,008h
	jr push_x
push_x_r:
	sub 008h
push_x:
	ld (ix+003h),a
	set 0,(ix+007h)
	call sfx_24                   ; stone
	ld l,(ix+002h)
	ld (ix+00ah),l
	call stone_probe
	jr nc,stone_idle_set
	ld (ix+006h),001h
	jr stone_go_push
stone_idle_set:
	xor a
	ld (ix+001h),a
	jr stone_wait
push_edge:
	set 0,(ix+007h)
	bit 1,(ix+007h)
	ld bc,01004h
	jr z,push_room
	ld bc,0e003h
push_room:
	push bc
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld (ix+003h),b
	call stone_under
	call stone_write
	pop bc
	call stone_room
	jp stone_idle_set
; move stone onto neighbour screen
stone_room:                     ; 0x94DA  move stone onto neighbour screen
	push bc
	call stone_restore
	call stone_slot
	pop bc
	ld b,a
	ld a,c
	call room_link
	ld (ix+004h),l
	ret
; E788 index of stone screen -> A
stone_slot:                     ; 0x94EB  E788 index of stone screen -> A
	ld a,(ix+004h)
	ld hl,0e788h            ; screen ids
	ld bc,03000h
stone_slot_scan:
	cp (hl)
	jr z,slot_found
	inc c
	inc hl
	djnz stone_slot_scan
	ld c,000h
slot_found:
	ld a,c
	ret
stone_fall:                       ; 0x94FF  drop 8px when no floor
	dec (ix+006h)
	ret nz
	ld (ix+006h),002h
	set 0,(ix+007h)
	ld a,(ix+002h)
	ld (ix+00ah),a
	add a,008h
	ld (ix+002h),a
	ld e,a
	ld h,(ix+003h)
	ld (ix+00bh),h
	cp 0b8h
	jr nc,fall_wrap
	cp 0b0h
	ret nc
	call stone_probe
	ret c
	call sfx_25                   ; thud
	jp stone_idle_set
fall_wrap:
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld (ix+002h),000h
	call stone_under
	call stone_write
	ld c,002h
	jp stone_room
; probe_step_de from stone XY
stone_step:                     ; 0x9543  probe_step_de from stone XY
	call stone_xy
	jp probe_step_de
; CY/NC: floor under 2-tile stone width
stone_probe:                    ; 0x9549  CY/NC: floor under 2-tile stone width
	call stone_xy
	ld bc,00410h
	add hl,bc
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	cp 001h
	ret nc
	ld a,h
	add a,008h
	ld h,a
	call map_tile_de
	cp 001h
	ret
; HL = stone pixel XY; DE = screen map
stone_xy:                       ; 0x9564  HL = stone pixel XY; DE = screen map
	ld a,(ix+004h)
	call screen_base
	ld h,(ix+003h)
	ld l,(ix+002h)
	ret
; A = screen id -> DE = E900 row
screen_base:                    ; 0x9571  A = screen id -> DE = E900 row
	ld l,a
	dec l
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld d,h
	ld e,l
	add hl,hl
	add hl,de
	ld de,0e900h            ; unpacked map
	add hl,de
	ex de,hl
	ret
; write map + stamp_rect 2x2
stone_stamp:                    ; 0x9585  write map + stamp_rect 2x2
	call stone_under
	push de
	call stone_write
	pop hl
	call stone_read
	ld a,003h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld d,(ix+004h)
	ld bc,00202h
	jp stamp_rect
stone_under_xy:
	ld h,(ix+003h)
	ld l,(ix+002h)
	call stone_under
; copy 2x2 map types under stone
stone_read:                     ; 0x95AA  copy 2x2 map types under stone
	ld a,(ix+004h)
	ld (ix+009h),a
	ld bc,(0e2feh)
	ld de,(0e2fch)
	push hl
	call stone_read1
	pop hl
	ld a,l
	add a,008h
	ld l,a
; two map_tile_de into (BC)+
stone_read1:                    ; 0x95C1  two map_tile_de into (BC)+
	push hl
	push de
	push bc
	call map_tile_de
	pop bc
	pop de
	pop hl
	ld (bc),a
	inc bc
	ld a,h
	add a,008h
	ld h,a
	push de
	push bc
	call map_tile_de
	pop bc
	pop de
	ld (bc),a
	inc bc
	ret
; map ptr + EF40 backup for this stone
stone_under:                    ; 0x95DA  map ptr + EF40 backup for this stone
	exx
	ld a,(ix+004h)
	call screen_base
	ld (0e2fch),de
	push ix
	pop hl
	ld a,l
	and 0f0h
	rrca
	rrca
	ld hl,0ef40h
	call ADD_HL_A
	ld (0e2feh),hl
	exx
	ret
; Unstamp type-5 stone (stamp_actor C=0).
stone_clear:                      ; 0x95F8
	ld h,(ix+003h)
	ld l,(ix+002h)
	call stone_under
; restore 2x2 map types under stone
stone_write:                    ; 0x9601  restore 2x2 map types under stone
	ld a,(ix+004h)
	cp (ix+009h)
	ret nz
	ld de,(0e2feh)
	push hl
	call stone_write1
	pop hl
	ld a,l
	add a,008h
	ld l,a
; two stamp_rect 1x1 from backup
stone_write1:                   ; 0x9615  two stamp_rect 1x1 from backup
	push hl
	push de
	ld a,(de)
	ld d,(ix+004h)
	ld bc,00101h
	call stamp_rect
	pop de
	pop hl
	inc de
	ld a,h
	add a,008h
	ld h,a
	ld a,(de)
	push de
	ld d,(ix+004h)
	ld bc,00101h
	call stamp_rect
	pop de
	inc de
	ret
draw_stone:                       ; 0x9636  restore underfoot, then 2×2 at stone_pat
	call stone_restore
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld d,(ix+003h)
	ld e,(ix+002h)
	call stone_stamp
	ld a,(0e243h)           ; screen
	cp (ix+009h)
	ret nz
	call stone_save
stamp_stone:                      ; 0x9652  type 5 stone: 2×2 tiles at stone_pat
	ld hl,stone_pat
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld bc,00202h
	jp draw_tilemap
; Save underfoot, then stamp this stone.
draw_stone1:                      ; 0x9661
	call stone_save
	jr stamp_stone
; stash XY; copy 16x16 under stone
stone_save:                     ; 0x9666  stash XY; copy 16x16 under stone
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld (ix+00bh),h
	ld (ix+00ah),l
	ld a,(0f0f4h)
	and a
	jr nz,stone_save_msx2
	call scr5_addr
	push ix
	pop de
	ld a,00ch
	call ADD_DE_A
	jp vram_pair
stone_save_msx2:
	push ix
	pop de
	ld a,e
	add a,a
	ld d,a
	ld e,040h
	jr nc,save_page
	ld e,050h
save_page:
	ld bc,01010h
	ld a,004h
	jp vdp_hmmm
; put 16x16 back at stashed XY
stone_restore:                  ; 0x969A  put 16x16 back at stashed XY
	ld d,(ix+00bh)
	ld e,(ix+00ah)
restore_here:
	ld a,(0e243h)           ; screen
	cp (ix+009h)
	ret nz
	push ix
	pop hl
	ld a,(0f0f4h)
	and a
	jr nz,restore_msx2
	ld a,00ch
	call ADD_HL_A
	ld bc,00202h
	jp draw_tilemap
restore_msx2:
	push ix
	pop hl
	ld a,l
	add a,a
	ld h,a
	ld l,040h
	jr nc,restore_page
	ld l,050h
restore_page:
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
; each E600 type-5 on this screen
stones_redraw:                  ; 0x96CF  each E600 type-5 on this screen
	ld ix,0e600h            ; actors
	ld b,010h
redraw_loop:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_redraw1
	ld bc,00010h
	add ix,bc
	pop bc
	djnz redraw_loop
	ret
; one stone: under + save + draw
stone_redraw1:                  ; 0x96E7  one stone: under + save + draw
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	call stone_under
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop hl
	call stone_save
	jp stamp_stone
; each E600 type-5: restore tiles
stones_undraw:                  ; 0x96FF  each E600 type-5: restore tiles
	ld ix,0e600h            ; actors
	ld b,010h
undraw_loop:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_undraw1
	ld bc,00010h
	add ix,bc
	pop bc
	djnz undraw_loop
	ret
; one stone restore if this screen
stone_undraw1:                  ; 0x9717  one stone restore if this screen
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	call stone_under
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop de
	jp restore_here
disk_err:                         ; 0x972C  DISKERR (F323); C → disk_err_tbl
	ld l,097h
	push bc
	call dos_leave
	ld a,001h
	ld (0f0e6h),a
	ld a,(0f0e9h)           ; cart slot
	ld h,040h
	call 00024h             ; ENASLT
	pop bc
	ld a,c
	and 00eh
	rrca
	cp 002h
	jr c,err_low
	cp 006h
	jr c,err_mid
	jr err_high
err_low:
	ld c,004h
	rrca
	jr nc,err_print
err_high:
	ld c,003h
	jr err_print
err_mid:
	ld c,000h
err_print:
	jp disk_print
	ld c,006h
err_leave:
	push bc
	call dos_leave
	pop bc
disk_print:                       ; 0x9763  print disk_err_tbl[C] + str_disk_err
	ld b,000h
	ld a,c
	add a,a
	ld c,a
	call page_bank_c
	ld hl,0af52h                  ; disk_err_tbl
	add hl,bc
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	push hl
	call scr_reset
	pop hl
	call print_stream
	ld hl,0af60h                  ; str_disk_err
	call print_stream
	call page_banks_123
	call hook_wait
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ld a,002h
	ld (0e27fh),a           ; I/O error
	ld sp,(0f0e2h)
	ret
; DISKERR (F323) during dos_dir; first two ops fall into dos_leave.
disk_unwind:                      ; 0x9797
	sbc a,c
	sub a
	call dos_leave
	ld a,(0f0e9h)           ; cart slot
	ld h,040h
	call 00024h             ; ENASLT
	call hook_wait
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ld sp,(0f0e2h)
	ret
; page 13, load_map_tools
load_map_tools_far:               ; 0x97B2  page 13, load_map_tools
	call page_bank_d
	call load_map_tools
	jp page_banks_123
; afb1_tbl[level-1] -> 0xE300 (64 x 8)
load_map_tools:                   ; 0x97BB  afb1_tbl[level-1] -> 0xE300 (64 x 8)
	ld ix,0e300h            ; map tools
	ld hl,0afb1h
	ld a,(0e242h)           ; level
	dec a
	call tbl_word
load_tool_loop:
	call load_tool
	ret z
	ld de,00008h
	add ix,de
	jr load_tool_loop
; one AFB1 rec: type=lo4 -> ix+0, screen=hi4 -> ix+3, Y, X
load_tool:                      ; 0x97D4  one AFB1 rec: type=lo4 -> ix+0, screen=hi4 -> ix+3, Y, X
	ld a,(hl)
	cp 0ffh
	ret z
	and 00fh
	ld (ix+000h),a
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	ld (ix+003h),a
	inc hl
	ld a,(hl)
	ld (ix+001h),a
	inc hl
	ld a,(hl)
	ld (ix+002h),a
	inc hl
	xor a
	ld (ix+004h),a
	ld (ix+005h),a
	ld (ix+006h),a
	ld (ix+007h),a
	inc a
	ret
; Pause push-up anim (E2B0 state, E2B1 timer, E2B2 reload, E2B3 frame).
pause_anim:                       ; 0x9801
	ld a,(0e2b0h)
	call DISPATCH_A

; BLOCK 'd9804_jp' (start 0x9807 end 0x980f)
d9804_jp_start:
	defw pause_hold
	defw pause_begin
	defw pause_up
	defw pause_down
d9804_jp_end:
pause_hold:                       ; 0x980F
	ld hl,0e2b0h
	ld (hl),001h
	inc hl
	ld (hl),020h
	inc hl
	inc hl
	ld (hl),000h
	ret
pause_begin:                      ; 0x981C  then copy pause_pose
	ld hl,0e2b1h
	dec (hl)
	ret nz
	ld hl,pause_pose
	ld de,0e2b0h
	ld bc,00004h
	ldir
	ret
; BLOCK 'pause_pose' (start 0x982D end 0x9831)
pause_pose:
	defb 002h, 030h, 030h, 001h   ; state, timer, reload, frame
pause_up:                         ; 0x9831  xor mask 3; pose last byte overlaps `ld bc`
	ld c,003h
	call pause_frame
	ld a,(0e2b2h)
	cp 010h
	ret nz
	ld a,003h
	ld (0e2b3h),a
	ld hl,0e2b0h
	inc (hl)
	ret
pause_down:                       ; 0x9846
	ld c,007h
	jp pause_frame
; xor E2B3 with C; maybe shrink E2B2
pause_frame:                      ; 0x984B  xor E2B3 with C; maybe shrink E2B2
	ld hl,0e2b1h
	dec (hl)
	ret nz
	ld a,(0e2b2h)
	ld (hl),a
	inc hl
	inc hl
	ld a,(hl)
	xor c
	ld (hl),a
	rra
	ret c
	ld a,(0e2b2h)
	cp 005h
pause_shrink:
	ret c
	dec a
	ld (0e2b2h),a
	ret
; Vic cells into software SAT E800.
vic_sat:                          ; 0x9866
	ld a,(0e280h)           ; Vic state
	cp 00eh
	jr nz,vic_sat_put
	ld a,(0e2a8h)           ; hold timer
	rra
	jr c,vic_sat_put
	ld hl,0e800h            ; SAT
	ld de,0e801h
	ld (hl),0e0h
	ld bc,0000fh
	ldir
	ret
; 2x2 SAT at Vic Y/X (pause_tick also)
vic_sat_put:                      ; 0x9881  2x2 SAT at Vic Y/X (pause_tick also)
	ld b,000h
	ld hl,0e800h            ; SAT
	ld a,(0e282h)                 ; SAT Y = E282-9
	sub 009h
	ld d,a
	ld a,(0e284h)                 ; SAT X = E284
	ld e,a
	ld a,(0e280h)           ; Vic state
	cp 002h
	jr z,sat_cell
	ld a,(0e294h)
	or a
	jr z,sat_cell
	inc e
	inc e
sat_cell:
	ld (hl),d
	inc hl
	ld (hl),e
	inc hl
	ld (hl),b
	inc hl
	inc hl
	ld a,b
	add a,004h
	ld b,a
	ld a,b
	cp 010h
	jr z,sat_cc_fill
	cp 008h
	jr nz,sat_cell
	ld a,d
	add a,010h
	ld d,a
	jr sat_cell
; SAT colour planes: 0x0D then fill_4e (0x4E).
sat_cc_fill:                      ; 0x98B9
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,0000fh
	ld (hl),00dh
	ldir
	call fill_4e
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),00dh
	ldir
; 15 bytes of 0x4E after inc HL/DE
fill_4e:                        ; 0x98D2  15 bytes of 0x4E after inc HL/DE
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),04eh
	ldir
	ret
; 2-bit map type at HL (Y=L, X=H); keeps HL
map_tile_xy:                      ; 0x98DC  2-bit map type at HL (Y=L, X=H); keeps HL
	push hl
	call map_tile
	pop hl
	ret
; type in A; base (0xE250)
map_tile:                         ; 0x98E2  type in A; base (0xE250)
	ld de,(0e250h)          ; map base
; same with caller DE
map_tile_de:                      ; 0x98E6  same with caller DE
	ld a,l
	and 0f8h
	ld l,a
	ld a,h
	and 0f8h
	ld h,000h
	add hl,de
	rra
	rra
	rra
	and 01fh
	ld b,a
	rra
	rra
	and 007h
	ld d,000h
	ld e,a
	add hl,de
	ld a,b
	and 003h
	xor 003h
	ld b,a
	push bc
	ld a,(hl)
	jr z,tile_mask
tile_shift:
	rra
	rra
	djnz tile_shift
tile_mask:
	pop bc
	and 003h
	ret
; carry if two/three tiles type < 2 (walk/climb)
probe_step:                       ; 0x9910  carry if two/three tiles type < 2 (walk/climb)
	push bc
	call step_origin
	push hl
	call map_tile
	pop hl
	pop bc
	sub 002h
	ret nc
	push bc
	call step_next
	push hl
	call map_tile
	pop hl
	pop bc
	sub 002h
	ret nc
	call step_next
	call map_tile
	sub 002h
	ret
; same with caller DE as map base
probe_step_de:                    ; 0x9933  same with caller DE as map base
	push bc
	call step_origin
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	pop bc
	sub 002h
	ret nc
	push bc
	call step_next
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	pop bc
	sub 002h
	ret nc
	call step_next
	call map_tile_de
	sub 002h
	ret
; C = 0 up / 1 down / 2 left / 3 right: first tile of the 3-tile probe.
step_origin:                      ; 0x995A
	ld a,c
	dec a
	jr z,step_down                   ; 1 down: Y+16
	dec a
	jr z,step_left                   ; 2 left: X-1
	dec a
	jr z,step_right                   ; 3 right: X+16
	ld a,h                        ; 0 up: X+2, Y-1
	add a,002h
	ld h,a
	ld a,l
	sub 001h
	ld l,a
	ret nc
	ld l,000h
	ret
step_down:
	ld a,h
	add a,002h
	ld h,a
	ld a,l
	add a,010h
	ld l,a
	cp 0b8h
	ret c
	ld l,0b8h
	ret
step_left:
	ld a,h
	sub 001h
	ld h,a
	ret nc
	ld h,000h
	ret
step_right:
	ld a,h
	add a,010h
	ld h,a
	ret nc
	ld h,0f8h
	ret
; Next tile: up/down X+6, left/right Y+6.
step_next:                        ; 0x998E
	ld a,c
	cp 002h
	jr nc,step_lr
	ld a,h
	add a,006h
	ld h,a
	ret
step_lr:
	ld a,l
	add a,006h
	ld l,a
	ret
; Vic overlap E700 -> collect, last gem opens door
touch_gems:                       ; 0x999D  Vic overlap E700 -> collect, last gem opens door
	call vic_xy
	ld a,(0e243h)           ; screen
	ld c,a
	ld b,010h
	ld hl,0e700h            ; gems
gem_loop:
	ld a,(hl)
	and a
	jr z,gem_next
	inc l
	ld a,(hl)
	cp c
	jr nz,gem_next
	inc l
	ld a,(hl)
	sub e
	add a,00ch
	cp 018h
	jr nc,gem_next
	inc l
	ld a,(hl)
	sub d
	add a,00ch
	cp 018h
	jr c,gem_take
gem_next:
	ld a,008h
	add a,l
	and 0f8h
	ld l,a
	djnz gem_loop
	ret
gem_take:
	push hl
	call stones_undraw
	call tools_scan
	pop hl
	ld d,(hl)
	dec l
	ld e,(hl)
	dec l
	dec l
	ld (hl),000h
	ld bc,00202h
	call stamp_wtiles
	ld hl,0e2f5h            ; gems left
	dec (hl)
	jr nz,gem_sfx
	call sfx_0b                   ; last gem / door open
	xor a
	ld (0e216h),a
	dec a
	ld (0e215h),a           ; H.TIMI debounce
	ld a,010h
	ld (0e21bh),a
gem_sfx:
	call sfx_1a                   ; gem
	call draw_exit
	call draw_maptools
	call stones_redraw
	ld de,00500h
	call add_score
	ret
; Vic pixel Y,X -> DE
vic_xy:                         ; 0x9A0B  Vic pixel Y,X -> DE
	ld a,(0e282h)           ; Vic Y
	ld e,a
	ld a,(0e284h)           ; Vic X
	ld d,a
	ret
; walk onto E300 tool -> pickup_tool
probe_pickup:                     ; 0x9A14  walk onto E300 tool -> pickup_tool
	ld a,(0e248h)           ; exit dir
	or a
	ret nz
	ld a,(0e287h)           ; held tool
	or a
	ret nz
	ld hl,0ee50h            ; E300 list / tape
pickup_loop:
	ld a,(hl)
	or a
	ret z
	call e300_ix
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	jr nz,pickup_next
	ld a,(ix+000h)
	and a
	jr z,pickup_next
	and 0f0h
	jr nz,pickup_next
	push hl
	push bc
	call pickup_box
	pop bc
	pop hl
	jr c,pickup_tool
pickup_next:
	inc hl
	djnz pickup_loop
	ret
; CY if Vic AABB overlaps this E300
pickup_box:                     ; 0x9A46  CY if Vic AABB overlaps this E300
	ld a,(0e282h)           ; Vic Y
	sub (ix+001h)
	jr nc,box_dy
	neg
	cp 008h
	ret nc
box_dy:
	cp 00dh
	ret nc
	ld b,000h
	ld a,(0e284h)           ; Vic X
	rla
	rl b
	sla b
	ld a,(ix+002h)
	rlca
	and 001h
	add a,b
	call DISPATCH_A

; BLOCK 'd9a67_jp' (start 0x9a6a end 0x9a72)
d9a67_jp_start:
	defw pickup_dx
	defw pickup_left
	defw pickup_right
	defw pickup_dx
d9a67_jp_end:
pickup_dx:                        ; 0x9A72  |Vic X - item X| < 14
	ld a,(0e284h)           ; Vic X
	sub (ix+002h)
	jr nc,dx_abs
	neg
dx_abs:
	cp 00eh
	ret
pickup_left:                      ; 0x9A7F  item left of Vic, dx < 14
	ld a,(0e284h)           ; Vic X
	ld b,a
	ld a,(ix+002h)
	sub b
	cp 00eh
	ret
pickup_right:                     ; 0x9A8A  Vic left of item, dx < 14
	ld a,(0e284h)           ; Vic X
	sub (ix+002h)
	cp 00eh
	ret
pickup_tool:                      ; 0x9A93  E287 = type, slot |= 0xF0
	push ix
	call stones_undraw
	pop ix
	ld a,(ix+000h)
	and 00fh
	ld (0e287h),a           ; held tool
	or 0f0h
	ld (ix+000h),a
	call sfx_19                   ; pickup
	call tools_redraw
	call stones_redraw
	ret
; active E500 (ix+13 bit 0) -> vic_hit
vic_e500_overlap:                 ; 0x9AB1  active E500 (ix+13 bit 0) -> vic_hit
	ld a,(0e255h)
	and a
	ret nz
	ld a,(0e298h)           ; die SAT
	or a
	ret nz
	ld ix,0e500h            ; thrown tools
	ld b,008h
e500_loop:
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jr nz,e500_next
	bit 0,(ix+013h)
	jr z,e500_next
	ld a,(0e282h)           ; Vic Y
	add a,008h
	sub (ix+003h)
	cp 010h
	jr nc,e500_next
	ld a,(0e284h)           ; Vic X
	add a,00ah
	jr c,e500_next
	sub (ix+005h)
	jr c,e500_next
	cp 014h
	jr c,e500_hit
e500_next:
	ld de,00020h
	add ix,de
	djnz e500_loop
	ret
e500_hit:
	ld a,005h
	ld (0e280h),a                 ; vic_hit
	call vic_hurt
	jp sfx_28
; thrown E500 vs map E300
e300_e500_hit:                    ; 0x9AFE  thrown E500 vs map E300
	ld ix,0e300h            ; map tools
	ld b,040h
clash_loop:
	exx
	ld a,(ix+000h)
	ld c,a
	and 00fh
	dec a
	cp 003h
	jr nc,clash_ix
	ld a,c
	rrca
	rrca
	rrca
	rrca
	and 00fh
	cp 002h
	jr c,clash_ix
	ld l,(ix+001h)
	ld h,(ix+002h)
	ld c,(ix+003h)
	ld iy,0e500h            ; thrown tools
	ld b,008h
clash_e500:
	ld a,(iy+000h)
	and a
	jr z,clash_iy
	bit 1,(iy+013h)
	jr z,clash_iy
	ld a,c
	cp (iy+010h)
	jr nz,clash_iy
	ld a,l
	add a,00ch
	sub (iy+003h)
	cp 018h
	jr nc,clash_iy
	ld a,(iy+005h)
	sub h
	jr nc,clash_dx
	neg
clash_dx:
	cp 00ch
	jr c,clash_hit
	jr clash_iy
clash_iy:
	ld de,00020h
	add iy,de
	djnz clash_e500
clash_ix:
	exx
	ld de,00008h
	add ix,de
	djnz clash_loop
	ret
; Clash: stash E300, clear thrown, add score.
clash_hit:                        ; 0x9B64
	push ix
	pop hl
	ld (0e2e8h),hl
	push iy
	pop ix
	ld a,001h
	ld (0edcdh),a
	call clash_clear
	ld de,00100h
	call add_score
	call sfx_26                   ; clash
	ret
; undraw thrown knife/boom on clash
clash_clear:                    ; 0x9B80  undraw thrown knife/boom on clash
	ld a,(ix+000h)
	cp 004h
	jp z,pick_park
	ld hl,06611h
	push hl
	cp 003h
	ret nc
	ld a,(ix+001h)
	cp 002h
	ret nc
	jp e500_undraw
; Disk load via BDOS (H.TIMI = RET).
dos_do_load:                      ; 0x9B98
	di
	ld a,(0fd9fh)           ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	ld (0f0e2h),sp
	call dos_enter
	ld hl,0c270h
	ld de,0ce00h
	call fcb_copy
	call dos_open
	call fcb_init
	call dos_load
	call dos_close
	di
	call dos_leave
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ei
	ret
; SETDTA + sequential read of save chunks
dos_load:                       ; 0x9BCC  SETDTA + sequential read of save chunks
	ld de,0c243h
	ld c,01ah
	call 0f37dh
	ld hl,00001h
	call dos_read
	ld de,0c25ch
	ld c,01ah
	call 0f37dh
	ld hl,00023h
	call dos_read
	ld de,0c282h
	ld c,01ah
	call 0f37dh
	ld hl,00003h
	call dos_read
	ld de,0c2c0h
	ld c,01ah
	call 0f37dh
	ld hl,00240h
	call dos_read
	ld de,0c600h
	ld c,01ah
	call 0f37dh
	ld hl,00200h
	call dos_read
	ld de,0c900h
	ld c,01ah
	call 0f37dh
	ld hl,004c0h
	jp dos_read
; Disk save via BDOS (H.TIMI = RET).
dos_do_save:                      ; 0x9C20
	di
	ld a,(0fd9fh)           ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	ld (0f0e2h),sp
	call dos_enter
	ld hl,0c270h
	ld de,0ce00h
	call fcb_skip
	call fcb_ext
	call dos_create
	call fcb_init
	call dos_save
	call dos_close
	di
	call dos_leave
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ei
	ret
; SETDTA + sequential write of save chunks
dos_save:                       ; 0x9C57  SETDTA + sequential write of save chunks
	ld de,0c243h
	ld c,01ah
	call 0f37dh
	ld hl,00001h
	call dos_write
	ld de,0c25ch
	ld c,01ah
	call 0f37dh
	ld hl,00023h
	call dos_write
	ld de,0c282h
	ld c,01ah
	call 0f37dh
	ld hl,00003h
	call dos_write
	ld de,0c2c0h
	ld c,01ah
	call 0f37dh
	ld hl,00240h
	call dos_write
	ld de,0c600h
	ld c,01ah
	call 0f37dh
	ld hl,00200h
	call dos_write
	ld de,0c900h
	ld c,01ah
	call 0f37dh
	ld hl,004c0h
	jp dos_write
; hook DOS; scan directory into D0E5
dos_dir:                        ; 0x9CAB  hook DOS; scan directory into D0E5
	di
	ld a,(0fd9fh)           ; H.TIMI
	ld (0f0e4h),a           ; H.TIMI stash
	ld a,0c9h
	ld (0fd9fh),a           ; H.TIMI
	ld (0f0e2h),sp
	call dos_enter
	ld hl,disk_unwind
	ld (0f323h),hl          ; DISKERR
	call dos_fcb
	call dir_clear
	xor a
	ld (0d0e5h),a
	call dos_scan
	di
	ld hl,(0d0e7h)
	ld (0f323h),hl          ; DISKERR
	call dos_leave
	ld a,(0f0e4h)           ; H.TIMI stash
	ld (0fd9fh),a           ; H.TIMI
	ei
	ret
; BDOS FOPEN (C=0x0F)
dos_open:                       ; 0x9CE3  BDOS FOPEN (C=0x0F)
	ld de,(0d0e0h)
	ld c,00fh
	call 0f37dh
	ld c,001h
	inc a
	jp z,err_leave
	ret
; BDOS FMAKE (C=0x16)
dos_create:                     ; 0x9CF3  BDOS FMAKE (C=0x16)
	ld de,(0d0e0h)
	di
	ld c,016h
	call 0f37dh
	ei
	ld c,003h
	inc a
	jp z,err_leave
	ret
; BDOS FCLOSE (C=0x10)
dos_close:                      ; 0x9D05  BDOS FCLOSE (C=0x10)
	ld de,(0d0e0h)
	ld c,010h
	call 0f37dh
	ld c,002h
	inc a
	jp z,err_leave
	ret
; zero 37 bytes at CE00
fcb_clear:                      ; 0x9D15  zero 37 bytes at CE00
	ld hl,0ce00h
	ld de,0ce01h
	ld (hl),000h
	ld bc,00024h            ; ENASLT
	ldir
	ret
	ld (0d0e0h),hl
; extent/record fields at D0E0 FCB
fcb_init:                       ; 0x9D26  extent/record fields at D0E0 FCB
	ld hl,(0d0e0h)
	ld bc,0000ch            ; RDSLT
	add hl,bc
	ld (hl),b
	inc hl
	ld (hl),b
	inc hl
	ld bc,00001h
	ld (hl),c
	inc hl
	ld (hl),b
	ld bc,00011h
	add hl,bc
	ld b,005h
	xor a
fcb_zero:
	ld (hl),a
	inc hl
	djnz fcb_zero
	ret
; zero CE50 directory buffer
dir_clear:                      ; 0x9D43  zero CE50 directory buffer
	ld hl,0ce50h
	ld de,0ce51h
	ld (hl),000h
	ld bc,000afh
	ldir
	ret
; HL name -> DE FCB (11+pad)
fcb_copy:                       ; 0x9D51  HL name -> DE FCB (11+pad)
	ld (0d0e0h),de
	xor a
	ld (de),a
	inc de
	ld bc,0000bh
	ldir
	xor a
	ld b,019h
fcb_pad:
	ld (de),a
	inc de
	djnz fcb_pad
	ret
; FCB from HL skipping leading 0
fcb_skip:                       ; 0x9D65  FCB from HL skipping leading 0
	ld (0d0e0h),de
	xor a
	ld (de),a
	inc de
	push de
	push hl
	ld h,d
	ld l,e
	inc de
	ld (hl),000h
	ld bc,0000bh
	ldir
	pop hl
	pop de
	ld b,00bh
skip_nul:
	ld a,(hl)
	or a
	jr nz,skip_copy
	inc hl
	djnz skip_nul
skip_copy:
	ld c,b
	ld b,000h
	ldir
	ld de,0ce0ch
	xor a
	ld b,019h
	ld (de),a
	inc de
	djnz fcb_pad
	ret
; BDOS WRND (C=0x26)
dos_write:                      ; 0x9D93  BDOS WRND (C=0x26)
	ld de,(0d0e0h)
	ld c,026h
	call 0f37dh
	ld c,004h
	or a
	jp nz,err_leave
	ret
; BDOS RDND (C=0x27)
dos_read:                       ; 0x9DA3  BDOS RDND (C=0x27)
	ld de,(0d0e0h)
	ld c,027h
	call 0f37dh
	ld c,000h
	or a
	jp nz,err_leave
	ret
; swap F100/DOS page; DISKERR hook
dos_enter:                      ; 0x9DB3  swap F100/DOS page; DISKERR hook
	ld hl,0f100h
	ld de,0d780h
	ld bc,00280h
	ldir
	ld de,0f0ffh
	ld hl,0d0ffh
	exx
	ld de,0f37fh
	ld bc,01100h
enter_swap:
	exx
	ld b,(hl)
	ld a,(de)
	dec de
	ld (hl),a
	dec hl
	ld a,b
	exx
	ld (de),a
	dec de
	dec bc
	ld a,b
	or c
	jr nz,enter_swap
	ld hl,00000h
	ld (0f1c0h),hl
	ld hl,disk_err
	ld (0f323h),hl          ; DISKERR
	ret
; restore work RAM + F100 from stash
dos_leave:                      ; 0x9DE7  restore work RAM + F100 from stash
	call dos_wait
	ld de,0e000h            ; work RAM / stack
	ld hl,0c000h
	exx
	ld de,0e280h            ; Vic state
	ld bc,01100h
leave_swap:
	exx
	ld a,(hl)
	ld (de),a
	inc de
	exx
	ld a,(de)
	inc de
	exx
	ld (hl),a
	inc hl
	exx
	dec bc
	ld a,b
	or c
	jr nz,leave_swap
	ld de,0f100h
	ld hl,0d780h
	ld bc,00280h
	ldir
	ret
; 256x call D0EA
dos_wait:                       ; 0x9E13  256x call D0EA
	ld b,000h
wait_d0:
	push bc
	call 0d0eah
	pop bc
	djnz wait_d0
	ret
; 256x call F0EA
hook_wait:                      ; 0x9E1D  256x call F0EA
	ld b,000h
wait_f0:
	push bc
	call 0f0eah
	pop bc
	djnz wait_f0
	ret
; FCB ext = ELG
fcb_ext:                        ; 0x9E27  FCB ext = ELG
	ld hl,0ce09h
	ld (hl),045h
	inc hl
	ld (hl),04ch
	inc hl
	ld (hl),047h
	ret
; BDOS FFIRST/FNEXT into catalog
dos_scan:                       ; 0x9E33  BDOS FFIRST/FNEXT into catalog
	ld de,0ce25h
	ld c,01ah
	call 0f37dh
	ld hl,0c26fh
	ld a,(hl)
	and a
	ld de,0ce00h
	jr nz,dos_fnext
	inc (hl)
	ld c,011h
	call 0f37dh
	inc a
	ret z
	jr dos_got
dos_fnext:
	ld c,012h
	call 0f37dh
	inc a
	jr nz,dos_got
	xor a
	ld (0c26fh),a
	jr dos_scan
dos_got:
	ld hl,0d0e5h
	inc (hl)
	push hl
	call dos_copyent
	pop hl
	ld a,(hl)
	cp 010h
	jr z,dos_scandone
	ld de,0ce00h
	ld c,012h
	call 0f37dh
	inc a
	jr nz,dos_got
dos_scandone:
	ld a,(0d0e5h)
	or a
	ret
; dir ent D0E5-1 -> CE26
dos_copyent:                    ; 0x9E7B  dir ent D0E5-1 -> CE26
	ld de,0ce26h
	ld a,(0d0e5h)
	dec a
	call dos_ent
	ex de,hl
	ld bc,0000bh
	ldir
	ret
; A -> HL = CE50 + A*11
dos_ent:                        ; 0x9E8C  A -> HL = CE50 + A*11
	ld l,a
	ld h,000h
	ld b,h
	ld c,l
	add hl,hl
	add hl,bc
	add hl,hl
	add hl,hl
	and a
	sbc hl,bc
	ld bc,0ce50h
	add hl,bc
	ret
; BLOCK 'dos_wild' (start 0x9e9d end 0x9ea8)
dos_wild:
	defb "????????ELG"
; wild FCB + fcb_clear
dos_fcb:                        ; 0x9EA8  wild FCB + fcb_clear
	ld hl,0ce25h
	ld de,0ce26h
	ld (hl),000h
	ld bc,00024h            ; ENASLT
	ldir
	call fcb_clear
	ld hl,dos_wild
	ld de,0ce01h
	ld bc,0000bh
	ldir
	ret
; per-frame; d_9ecd[(0xE280)]
vic_tick:                         ; 0x9EC4  per-frame; d_9ecd[(0xE280)]
	call vic_dispatch
	jp probe_edge

; d_9ecd[E280]
vic_dispatch:                     ; 0x9ECA
	ld a,(0e280h)           ; Vic state
	call DISPATCH_A

; BLOCK 'd_9ecd_jp' (start 0x9ed0 end 0x9eee)
d_9ecd_jp_start:
	defw vic_walk                 ; 0 ground
	defw vic_jump                 ; 1 air (e292 gravity)
	defw vic_climb                ; 2 ladder; secret_hit arms bit 5
	defw vic_fall                 ; 3 drop-in (boot); Y+=4 until floor
	defw vic_die                  ; 4 e20c bit 4 / 92ffh
	defw vic_hit                  ; 5 E500 overlap (ix+13 bit 0)
	defw vic_pull_l               ; 6 coffin / Pyoncy pull left
	defw vic_pull_r               ; 7 coffin / Pyoncy pull right
	defw vic_throw                ; 8 knife
	defw vic_throw                ; 9 boomerang (same windup)
	defw vic_shovel               ; 10 shovel
	defw vic_pick                 ; 11 pick
	defw vic_hammer               ; 12 hammer
	defw vic_drill                ; 13 drill
	defw vic_hold                 ; 14 hold (e2a8; vic_reset if e202 bit 6)
d_9ecd_jp_end:
vic_walk:                         ; 0x9EEE  ground: floor, use_tool, jump/walk
	call vic_keys_lr
	call vic_face
	call vic_align_y
	call probe_floor
	jr nz,walk_tool
	call probe_ladder
	jp nz,vic_off_floor
walk_tool:
	call use_tool
	ld a,(0e280h)           ; Vic state
	or a
	ret nz
	call vic_walk_move
	ld a,(0e280h)           ; Vic state
	or a
	ret nz
	ld a,(0e288h)
	and 00ch
	jr z,walk_idle
vic_walk_anim:                    ; 0x9F19  E296 timer -> E285 from vic_walk_l/r
	ld hl,0e296h
	dec (hl)
	ret nz
	ld (hl),004h
; walk anim frame 0-3
vic_walk_frame:                   ; 0x9F20
	ld a,(0e295h)
	inc a
	and 003h
	ld b,a
	ld (0e295h),a
	ld a,(0e294h)
	or a
	ld hl,vic_walk_l
	jr z,walk_fr
	ld hl,vic_walk_r
walk_fr:
	ld a,b
	call ADD_HL_A
	ld a,(hl)
	ld (0e285h),a           ; vic frame
	ret
walk_idle:
	ld a,001h
	ld (0e296h),a
	ret

; BLOCK 'vic_walk_fr' (start 0x9F45 end 0x9F4D)
vic_walk_l:                       ; 0x9F45  facing 0: frames 0,1,2,1
	defb 000h, 001h, 002h, 001h
vic_walk_r:                       ; 0x9F49  facing 1: frames 3,4,5,4
	defb 003h, 004h, 005h, 004h
; Snap Y to 8px when E2A6 and the tile below is solid (type >= 2).
vic_align_y:                      ; 0x9F4D
	ld a,(0e2a6h)
	or a
	ret z
	ld a,(0e282h)           ; Vic Y
	add a,010h
	ld l,a
	ld a,(0e294h)
	or a
	ld a,(0e284h)           ; Vic X
	jr z,align_x
	add a,00fh
align_x:
	ld h,a
	call map_tile
	sub 002h
	ret c
	ld a,(0e282h)           ; Vic Y
	and 0f8h
	ld (0e282h),a           ; Vic Y
	xor a
	ld (0e2a6h),a
	ret
; Fire -> jump; up/down -> ladder; else E288 L/R + E28E/E290 delta.
vic_walk_move:                    ; 0x9F77
	call vic_busy
	jr c,walk_busy
	ld a,(0e207h)           ; key edges
	bit 4,a
	jp nz,vic_begin_jump          ; fire, not holding: 0 -> 1
	ld a,(0e208h)           ; keys held
	rra
	jr nc,walk_up
	call vic_grab_up
	jr walk_busy
walk_up:
	rra
	jr nc,walk_lr
	call vic_grab_dn
walk_busy:
	ld a,(0e280h)           ; Vic state
	or a
	ret nz
walk_lr:
	ld a,(0e288h)
	ld de,(0e28eh)
	ld c,002h
	bit 2,a
	jr nz,walk_go
	ld de,(0e290h)
	ld c,003h
	bit 3,a
	ret z
walk_go:
	push bc
	ld hl,(0e283h)
	add hl,de
	push hl
	ld a,(0e282h)           ; Vic Y
	ld l,a
	call probe_step
	pop hl
	pop bc
	jr c,vic_set_x
vic_snap_x:                       ; 0x9FC1  blocked: snap X to 8px from facing
	ld a,(0e294h)
	or a
	ld a,007h
	jr z,snap_right
	xor a
snap_right:
	ld l,000h
	add a,h
	and 0f8h
	ld h,a
vic_set_x:                        ; 0x9FD0
	ld (0e283h),hl
	ret
; No floor and no ladder: pose, then fall through to vic_enter_fall.
vic_off_floor:                    ; 0x9FD4
	ld a,001h
	ld (0e2a7h),a           ; jump strobe
	ld a,(0e280h)           ; Vic state
	or a
	jr nz,off_pose
	ld a,(0e2a6h)
	or a
	jr nz,off_pose
	xor a
	ld (0e2a7h),a           ; jump strobe
off_pose:
	xor a
	ld (0e295h),a
	ld a,007h
	ld (0e296h),a
	ld b,001h
	ld a,(0e294h)
	or a
	jr z,off_right
	ld b,004h
off_right:
	ld a,b
	ld (0e285h),a           ; vic frame

; ---------------------------------------------------------------------------
;  bank 03 @ 0xA000
; ---------------------------------------------------------------------------
vic_enter_fall:                   ; 0xA000  E280=3; boot jp and walk-off both land here
	ld a,003h
	ld (0e280h),a           ; Vic state
	jp sfx_3c
vic_begin_jump:                   ; 0xA008  from walk + fire; inc E280 0->1
	ld a,(0e2a6h)
	or a
	ret nz
	ld a,(0e287h)           ; held tool
	or a
	ret nz
	ld a,(0e282h)           ; Vic Y
	cp 0f8h
	ret nc
	ld l,a
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld c,000h
	call probe_step
	ret nc
	ld a,(0e288h)
	ld (0e289h),a
	ld a,(0e294h)
	ld b,a
	ld a,008h
	add a,b
	ld (0e285h),a           ; vic frame
	xor a
	ld (0e2a5h),a
	ld hl,0fc00h
	ld (0e292h),hl          ; jump gravity
	call sfx_13                   ; jump
	ld hl,0e280h            ; Vic state
	inc (hl)
	ret
; fire + E287 -> E300 (high nibble 1), then d_a072
use_tool:                         ; 0xA045  fire + E287 -> E300 (high nibble 1), then d_a072
	ld a,(0e2a6h)
	or a
	ret nz
	ld a,(0e287h)           ; held tool
	and a
	ret z
	ld a,(0e207h)           ; key edges
	bit 4,a
	ret z
	ld hl,0e300h            ; map tools
	ld b,040h
use_scan:
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	dec a
	jr z,use_found
	ld de,00008h
	add hl,de
	djnz use_scan
	ret
use_found:
	ld (0e2a0h),hl
	ld a,(0e287h)           ; held tool
	dec a
	call DISPATCH_A

; BLOCK 'd_a072_jp' (start 0xa075 end 0xa081)
d_a072_jp_start:
	defw use_throw                ; 1 knife / 2 boomerang (no map check; Vic 8/9)
	defw use_throw
	defw use_floor                ; 3 shovel / 4 pick (two floor tiles type 2; Vic 10/11)
	defw use_floor
	defw use_wall                 ; 5 hammer / 6 drill (two wall tiles type 2; Vic 12/13)
	defw use_wall
d_a072_jp_end:
use_throw:                        ; 0xA081
	ld hl,0e2a9h
	ld a,(hl)
	cp 006h
	ret nc
	inc (hl)
	ld a,(0e294h)
	or a
	ld a,00ah
	jr z,throw_fr
	ld a,00ch
throw_fr:
	ld (0e285h),a           ; vic frame
	ld a,008h
	ld (0e286h),a
throw_set:
	ld a,(0e287h)           ; held tool
	and 00fh
	add a,007h
	ld (0e280h),a           ; Vic state
	ret
use_floor:                        ; 0xA0A6  shovel / pick: two floor tiles type 2
	ld a,(0e294h)
	or a
	ld bc,0f80ah
	jr z,floor_x
	ld bc,0080ch
floor_x:
	ld a,c
	exx
	ld c,a
	exx
	ld a,(0e284h)           ; Vic X
	add a,004h
	and 0f8h
	add a,b
	ld h,a
	ld a,(0e282h)           ; Vic Y
	add a,010h
	and 0f8h
	ld l,a
	ld (0e2a2h),hl
	push hl
	call map_tile
	pop hl
	cp 002h
	ret nz
	ld a,h
	add a,008h
	ld h,a
	call map_tile
	cp 002h
	ret nz
	exx
	ld a,c
	ld (0e285h),a           ; vic frame
	exx
	ld hl,(0e2a0h)
	ld a,010h
	add a,(hl)
	ld (hl),a
	ld a,020h
	ld (0e286h),a
	jr throw_set
use_wall:                         ; 0xA0F0  hammer / drill: two wall tiles type 2
	ld a,(0e294h)
	or a
	ld b,0feh
	ld a,00ah
	jr z,wall_x
	ld b,012h
	ld a,00ch
wall_x:
	exx
	ld c,a
	exx
	ld a,(0e284h)           ; Vic X
	add a,b
	and 0f8h
	ld h,a
	ld a,(0e282h)           ; Vic Y
	and 0f8h
	ld l,a
	ld (0e2a2h),hl
	call map_tile_xy
	cp 002h
	ret nz
	ld a,l
	add a,008h
	ld l,a
	call map_tile
	cp 002h
	ret nz
	exx
	ld a,c
	ld (0e285h),a           ; vic frame
	exx
	ld hl,(0e2a0h)
	ld a,010h
	add a,(hl)
	ld (hl),a
	ld a,020h
	ld (0e286h),a
	jp throw_set
; Air L/R from A = E289 & 0x0C. DE = ±0x140, C = 2/3.
vic_jump_x:                       ; 0xA136
	ld de,0fec0h
	ld c,002h
	bit 2,a
	jp nz,jump_go
	ld de,00140h
	ld c,003h
	bit 3,a
	jp nz,jump_go
	ret
jump_go:
	ld hl,(0e283h)
	add hl,de
	ld a,h
	cp 0f0h
	jp nc,vic_set_x
	push bc
	push hl
	ld a,(0e2a5h)
	or a
	ld a,(0e282h)           ; Vic Y
	jr z,jump_y
	add a,006h
jump_y:
	call probe_air_x
	pop hl
	pop bc
	jp c,vic_set_x
	jp vic_snap_x
; Solid at (Y=A+8, X+(-1 or +16)) and the tile 6 below.
probe_air_x:                      ; 0xA16D
	add a,008h
	ld l,a
	ld a,c
	sub 002h
	ld h,0ffh
	jr z,air_right
	ld h,010h
air_right:
	ld a,(0e284h)           ; Vic X
	add a,h
	ld h,a
	call map_tile_xy
	sub 002h
	ret nc
	ld a,l
	and 0f8h
	add a,006h
	ld a,a
	call map_tile
	sub 002h
	ret
vic_jump:                         ; 0xA190  air: gravity, optional L/R, land -> walk
	xor a
	ld (0e2a5h),a
	call vic_gravity
	ld a,(0e289h)
	and 00ch
	call nz,vic_jump_x
	call probe_land
	ld a,(0efc0h)           ; stamp row
	or a
	ret z
	call vic_snap_y
	xor a
	ld (0e280h),a           ; Vic state
	ld (0e2a6h),a
	ld (0e2a5h),a
	ld (0e295h),a
	inc a
	ld (0e296h),a
	call vic_walk_frame
	jp sfx_38
; E292 += 0x80 (cap 4.00) → E281 Y. CY from probe_air_y = blocked.
vic_gravity:                      ; 0xA1C1
	ld hl,(0e292h)          ; jump gravity
	ld a,h
	cp 004h
	jr z,grav_cap
	ld de,00080h
	add hl,de
	ld (0e292h),hl          ; jump gravity
	ex de,hl
grav_y:
	ld hl,(0e281h)
	add hl,de
	ld (0e281h),hl
	call probe_air_y
	ret c
	ld hl,0e2a5h
	inc (hl)
	ret
grav_cap:
	ld de,00400h
	jr grav_y
; Two Y samples vs solid (X+2 and X+14).
probe_air_y:                      ; 0xA1E6
	ld l,h
	dec l
	call probe_solid
	ret nc
	ld a,l
	inc a
	and 0f8h
	add a,008h
	ld l,a
	call probe_solid
	ret nc
	inc l
	inc l
; type >= 2 at (Y=L, X+2) and (Y=L, X+14)
probe_solid:                      ; 0xA1F9  type >= 2 at (Y=L, X+2) and (Y=L, X+14)
	ld a,(0e284h)           ; Vic X
	add a,002h
	ld h,a
	call map_tile_xy
	sub 002h
	ret nc
	ld a,h
	add a,00ch
	ld h,a
	call map_tile_xy
	sub 002h
	ret
vic_climb:                        ; 0xA20F  ladder (tile type 1); L/R probe / U-D
	call vic_keys_ud
	ld a,(0e208h)           ; keys held
	and 00ch
	jr z,climb_ud
	rra
	rra
	rra
	ld c,002h
	jr c,climb_side
	inc c
climb_side:
	ld a,(0e282h)           ; Vic Y
	ld l,a
	ld a,(0e284h)           ; Vic X
	ld h,a
	push hl
	push bc
	call probe_step
	pop bc
	pop hl
	jr nc,climb_ud
	ld a,l
	add a,004h
	ld l,a
	ld a,c
	cp 002h
	ld a,0fch
	jr z,climb_dx
	ld a,014h
climb_dx:
	add a,h
	ld h,a
	call map_tile_xy
	or a
	jr nz,climb_dn
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr nz,climb_dn
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr z,climb_dn
	ld a,l
	sub 010h
climb_land:
	and 0f8h
	ld h,a
	xor a
	ld (0e280h),a           ; Vic state
	ld (0e2a4h),a
	ld (0e2a6h),a
	ld l,a
	ld (0e281h),hl
	ret
climb_dn:
	ld a,(0e282h)           ; Vic Y
	add a,004h
	ld l,a
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld c,001h
	push hl
	call probe_step
	pop hl
	ld a,l
	jr nc,climb_land
	xor a
	ld (0e280h),a           ; Vic state
	ld (0e2a4h),a
	inc a
	ld (0e2a6h),a
	ret
climb_ud:
	call vic_climb_exit
	ld a,(0e280h)           ; Vic state
	cp 002h
	ret nz
	call vic_climb_stay
	ld a,(0e280h)           ; Vic state
	cp 002h
	ret nz
	call vic_climb_move
	ld a,(0e288h)
	and 003h
	ret z
	ld hl,0e296h
	dec (hl)
	ret nz
	ld (hl),004h
	ld a,(0e285h)           ; vic frame
	xor 001h
	ld (0e285h),a           ; vic frame
	ret
; E288 up/down → E28A/E28C delta; C=0/1 for probe_step.
vic_climb_move:                   ; 0xA2BB
	ld de,(0e28ah)
	ld c,000h
	ld a,(0e288h)
	rra
	jr c,climb_go
	ld de,(0e28ch)
	ld c,001h
	rra
	jr c,climb_go
	ld hl,0e296h
	ld (hl),001h
	ret
climb_go:
	ld hl,(0e281h)
	add hl,de
	ld a,h
	cp 0e8h
	jr nc,climb_put
	push bc
	push hl
	ld l,h
	ld a,(0e284h)           ; Vic X
	ld h,a
	call probe_step
	pop hl
	pop bc
	ret nc
climb_put:
	ld (0e281h),hl
	ret
vic_fall:                         ; 0xA2F0  Y+=4 until 0xAD or floor, then walk
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld a,(0e282h)           ; Vic Y
	add a,004h
	ld l,a
	ld (0e282h),a           ; Vic Y
	cp 0adh
	ret nc
	call probe_floor
	ret z
	call vic_snap_y
	xor a
	ld (0e280h),a           ; Vic state
	ld (0e2a6h),a
	inc a
	ld (0e296h),a
	jp sfx_38
vic_die:                          ; 0xA315  D=10, sprite 4..6; shared hurt_tick
	ld de,00a06h
	ld c,004h
	jr hurt_tick
vic_hit:                          ; 0xA31C  D=5, sprite 0..4 (E500 overlap)
	ld de,00504h
	ld c,000h
hurt_tick:
	ld hl,0e296h
	dec (hl)
	ret nz
	ld a,(0e295h)
	cp d
	jr z,hurt_over
	ld (hl),003h
	ld hl,0e285h            ; vic frame
	inc (hl)
	ld a,(hl)
	cp e
	ret nz
	ld a,(0e295h)
	inc a
	ld (0e295h),a
	cp d
	jr z,hurt_wait
	ld (hl),c
	ret
hurt_wait:
	ld (hl),006h
	ld hl,0e296h
	ld (hl),028h
	jp sfx_29
hurt_over:
	xor a
	ld (0e246h),a
	ret
vic_pull_l:                       ; 0xA350  coffin / Pyoncy pull left
	ld hl,0e299h
	inc (hl)
	ld a,(hl)
	sub 012h
	jr z,pull_done
	xor a
	ld (0e283h),a
	ld a,(0e284h)           ; Vic X
	dec a
	dec a
	ld (0e284h),a           ; Vic X
	jp vic_walk_anim
pull_done:
	ld (0e280h),a           ; Vic state
	ret
vic_pull_r:                       ; 0xA36C  coffin / Pyoncy pull right
	ld hl,0e299h
	inc (hl)
	ld a,(hl)
	sub 012h
	jr z,pull_done
	xor a
	ld (0e283h),a
	ld a,(0e284h)           ; Vic X
	inc a
	inc a
	ld (0e284h),a           ; Vic X
	jp vic_walk_anim
vic_throw:                        ; 0xA384  knife / boomerang windup
	ld hl,0e286h
	dec (hl)
	jr z,throw_done
	ld a,(hl)
	cp 004h
	ret nz
	ld hl,0e285h            ; vic frame
	inc (hl)
	ret
throw_done:
	xor a
	ld (0e287h),a           ; held tool
	ld (0e280h),a           ; Vic state
	ld a,(0e294h)
	or a
	ld a,003h
	jr nz,throw_idle
	xor a
throw_idle:
	ld (0e285h),a           ; vic frame
	ld hl,0e2a0h
	ld a,(hl)
	inc l
	ld h,(hl)
	ld l,a
	ld a,010h
	add a,(hl)
	ld (hl),a
	inc l
	push hl
	ld a,(0e282h)           ; Vic Y
	and 0f8h
	ld (hl),a
	ld l,a
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld b,000h
	ld a,(0e294h)
	or a
	ld c,003h
	jr z,throw_left
	cp 0e8h
	jr nc,throw_put
	jr throw_probe
throw_left:
	dec c
	ld a,h
	cp 010h
	jr c,throw_put
throw_probe:
	call probe_step
	ld b,000h
	jr nc,throw_put
	ld b,010h
throw_put:
	pop hl
	inc l
	ld c,004h
	ld a,(0e294h)
	or a
	ld a,(0e284h)           ; Vic X
	jr nz,throw_right
	ld c,003h
	sub b
	jr throw_x
throw_right:
	add a,b
throw_x:
	ld (hl),a
	ret nc
	inc l
	push hl
	ld a,(0e243h)           ; screen
	push bc
	call screen_slot
	pop bc
	ld b,a
	ld a,c
	call room_link
	ld a,l
	pop hl
	ld (hl),a
	ret
vic_shovel:                       ; 0xA405
	ld a,(0e286h)
	and 003h
	call z,sfx_15
	jr tool_anim
vic_pick:                         ; 0xA40F
	ld a,(0e286h)
	and 003h
	call z,sfx_17
	jr tool_anim
vic_hammer:                       ; 0xA419  wall, 1 deep
	ld a,(0e286h)
	and 003h
	call z,sfx_18
	jr tool_anim
vic_drill:                        ; 0xA423  wall, 2 deep
	ld a,(0e286h)
	and 003h
	call z,sfx_16
tool_anim:
	ld hl,0e286h
	dec (hl)
	ld a,(hl)
	rra
	rra
	ret c
	ld a,(0e285h)           ; vic frame
	xor 001h
	ld (0e285h),a           ; vic frame
	ret
vic_hold:                         ; 0xA43C  until e2a8 hits 0
	ld hl,0e2a8h            ; hold timer
	dec (hl)
	ret nz
	xor a
	ld (0e280h),a           ; Vic state
	ret
; E281/E282: subpixel 0, Y &= ~7
vic_snap_y:                       ; 0xA446  E281/E282: subpixel 0, Y &= ~7
	ld a,(0e282h)           ; Vic Y
	and 0f8h
	ld h,a
	ld l,000h
	ld (0e281h),hl
	ret
; CY while E2A4 < 6 (lock jump/climb; walk still applies).
vic_busy:                         ; 0xA452
	ld a,(0e2a4h)
	cp 006h
	ret nc
	inc a
	ld (0e2a4h),a
	scf
	ret
; Z if a ladder (type 1) under Vic at X+2 or X+14.
probe_ladder:                     ; 0xA45E
	ld a,(0e284h)           ; Vic X
	add a,002h
	ld h,a
	ld a,(0e282h)           ; Vic Y
	ld l,a
	call map_tile_xy
	dec a
	ret z
	ld a,h
	add a,00ch
	ld h,a
	call map_tile
	dec a
	ret
; Still on a ladder (type 1 at Y or Y+16), else vic_off_floor.
vic_climb_stay:                   ; 0xA476
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld a,(0e282h)           ; Vic Y
	ld l,a
	call map_tile_xy
	dec a
	ret z
	ld a,l
	add a,010h
	ld l,a
	call map_tile
	dec a
	ret z
	jp vic_off_floor
; E288 up/down off the ladder onto floor (or empty above).
vic_climb_exit:                   ; 0xA48F
	ld a,(0e284h)           ; Vic X
	ld h,a
	ld a,(0e282h)           ; Vic Y
	add a,012h
	ld l,a
	ld a,(0e288h)
	rra
	jr c,exit_up
	rra
	ret nc
	call map_tile_xy
	cp 002h
	jr nc,exit_dn
	ld a,h
	add a,008h
	ld h,a
	call map_tile_xy
	cp 002h
	ret c
exit_dn:
	ld a,l
	cp 0c0h
	ret nc
	sub 00bh
exit_snap:
	and 0f8h
	ld h,a
	xor a
	ld l,a
	ld (0e281h),hl
	ld (0e280h),a           ; Vic state
	ld (0e2a6h),a
	inc a
	ld (0e2a7h),a           ; jump strobe
	ld (0e296h),a
	jp vic_walk_anim
exit_up:
	ld a,(0e282h)           ; Vic Y
	sub 008h
	cp 008h
	ret c
	ld a,l
	sub 010h
	ld l,a
	call map_tile_xy
	or a
	ret nz
	ld a,l
	add a,009h
	ld l,a
	call map_tile_xy
	or a
	ret nz
	ld a,l
	sub 009h
	jr exit_snap
; E288 bits 2–3 → E294 facing (0 left / 1 right); reset walk frame on change.
vic_face:                         ; 0xA4EF
	ld b,000h
	ld a,(0e288h)
	rra
	rra
	and 003h
	ret z
	rra
	jr c,face_set
	inc b
	rra
	ret nc
face_set:
	ld a,b
	ld a,(0e294h)
	cp b
	ld a,b
	ld (0e294h),a
	ret z
	xor a
	ld (0e295h),a
	inc a
	ld (0e296h),a
	ret
; NZ if any of three tiles under Vic (Y+16, X+3 / +8 / +13) is nonempty.
probe_floor:                      ; 0xA512
	ld a,(0e282h)           ; Vic Y
	add a,010h
	ld l,a
	ld a,(0e284h)           ; Vic X
	add a,003h
	ld h,a
	call map_tile_xy
	or a
	ret nz
	ld a,h
	add a,005h
	ld h,a
	call map_tile_xy
	or a
	ret nz
	ld a,h
	add a,005h
	ld h,a
	call map_tile_xy
	or a
	ret
; jump: EFC0=1 if floor (not ladder)
probe_land:                       ; 0xA535  jump: EFC0=1 if floor (not ladder)
	xor a
	ld (0efc0h),a           ; stamp row
	call probe_floor
	ret z
	dec a
	jr nz,land_yes
	ld a,l
	sub 00ch
	and 0f8h
	ld l,a
	call map_tile_xy
	or a
	jr nz,land_under
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr nz,land_under
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	ret z
land_yes:
	ld a,001h
	ld (0efc0h),a           ; stamp row
	ret
land_under:
	ld a,(0e282h)           ; Vic Y
	add a,010h
	ld l,a
	call probe_under
	ret c
	jr land_yes
; three tiles at L, X+3/+8/+13; CY if all type < 2
probe_under:                      ; 0xA571  three tiles at L, X+3/+8/+13; CY if all type < 2
	ld a,(0e284h)           ; Vic X
	add a,003h
	ld h,a
	call map_tile_xy
	sub 002h
	ret nc
	ld a,h
	add a,005h
	ld h,a
	call map_tile_xy
	sub 002h
	ret nc
	ld a,h
	add a,005h
	ld h,a
	call map_tile_xy
	sub 002h
	ret
; down onto ladder (Y+16)
vic_grab_dn:                      ; 0xA591  down onto ladder (Y+16)
	call vic_grab_y2
	ld a,(0e280h)           ; Vic state
	cp 002h
	ret z
	ld a,(0e282h)           ; Vic Y
	add a,010h
	ld l,a
	jr grab_tile
; up onto ladder (Y+10)
vic_grab_up:                      ; 0xA5A2  up onto ladder (Y+10)
	call vic_grab_y2
	ld a,(0e280h)           ; Vic state
	cp 002h
	ret z
	ld a,(0e282h)           ; Vic Y
	add a,00ah
	ld l,a
grab_tile:
	ld a,(0e284h)           ; Vic X
	ld h,a
	call map_tile_xy
	dec a
	ld bc,00c0ch
	jr z,grab_ok
	ld bc,0f400h
	ld a,h
	add a,010h
	ld h,a
	push bc
	call map_tile_xy
	pop bc
	dec a
	ret nz
grab_ok:
	ld a,h
	add a,b
	ld h,a
	push bc
	call map_tile_xy
	pop bc
	dec a
	ret nz
	ld a,h
	sub c
	and 0f8h
	ld h,a
	ld l,000h
	push hl
	call probe_ladder_span
	pop hl
	ret c
	ld (0e283h),hl
	xor a
	ld (0e295h),a
	ld (0e2a4h),a
	inc a
	ld (0e296h),a
	inc a
	ld (0e280h),a                 ; 2 vic_climb (ladder, tile type 1)
	ld a,006h
	ld (0e285h),a           ; vic frame
	ret
; Y+2, then shared grab
vic_grab_y2:                      ; 0xA5FB  Y+2, then shared grab
	ld a,(0e282h)           ; Vic Y
	add a,002h
	ld l,a
	jr grab_tile
; Count type-1 tiles left of H; CY if odd (ladder not centered).
probe_ladder_span:                ; 0xA603
	ld a,(0e208h)           ; keys held
	rra
	ld a,(0e282h)           ; Vic Y
	jr c,span_y
	add a,010h
span_y:
	ld l,a
	ld c,0ffh
span_loop:
	inc c
	ld a,h
	or a
	jr z,span_odd
	sub 008h
	ld h,a
	push bc
	call map_tile_xy
	pop bc
	dec a
	jr z,span_loop
span_odd:
	ld a,c
	rra
	ret
; E208/E207 bits 2–3 → E288 (4 left / 8 right). Both bits together: ignore.
vic_keys_lr:                      ; 0xA624
	ld a,(0e208h)           ; keys held
	and 00ch
	ld b,a
	ld c,000h
	jr z,keys_store
	ld a,(0e207h)           ; key edges
	and 00ch
	cp 00ch
	ret z
	bit 2,a
	ld c,004h
	jr nz,keys_store
	bit 3,a
	ld c,008h
	jr nz,keys_store
	ld a,b
	cp 00ch
	ret z
	bit 2,a
	ld c,004h
	jr nz,keys_store
	ld c,008h
keys_store:
	ld a,c
	ld (0e288h),a
	ret
; Same for bits 0–1 → E288 (1 up / 2 down).
vic_keys_ud:                      ; 0xA653
	ld a,(0e208h)           ; keys held
	and 003h
	ld b,a
	ld c,000h
	jr z,keys_store
	ld a,(0e207h)           ; key edges
	and 003h
	cp 003h
	ret z
	rra
	ld c,001h
	jr c,keys_store
	rra
	ld c,002h
	jr c,keys_store
	ld a,b
	cp 003h
	ret z
	rra
	ld c,001h
	jr c,keys_store
	ld c,002h
	jr keys_store
probe_edge:                       ; 0xA67C  E248 = 1 up / 2 down / 3 left / 4 right
	ld a,(0e282h)                 ; Y
	add a,008h
	cp 002h
	jr c,edge_up                   ; top + climb -> 1 up
	sub 008h
	cp 0aeh
	jr nc,edge_dn_y                  ; bottom -> 2 down
	ld a,(0e294h)
	or a
	ld a,(0e284h)                 ; X
	jr z,edge_left
	cp 0f1h
	ret c
	ld a,004h                     ; facing right, X >= 0xF1 -> 4 right
	ld (0e248h),a           ; exit dir
	ret
edge_left:
	add a,008h
	cp 00ah
	ret nc
	ld a,003h                     ; facing left, X small -> 3 left
	ld (0e248h),a           ; exit dir
	ret
edge_up:
	ld a,(0e280h)           ; Vic state
	sub 002h
	ret nz
	ld a,001h                     ; climb off top -> 1 up
	ld (0e248h),a           ; exit dir
	ret
edge_dn_y:
	cp 0f0h
	ret nc
	ld a,002h                     ; Y >= 0xAE -> 2 down
	ld (0e248h),a           ; exit dir
	ret
; 0xE300 64 x 8 (afb1_tbl); skip if (0xE248)
tick_map_tools:                   ; 0xA6BD  0xE300 64 x 8 (afb1_tbl); skip if (0xE248)
	ld a,(0e248h)           ; exit dir
	or a
	ret nz
	ld ix,0e300h            ; map tools
	ld b,040h
mtick_loop:
	push bc
	call tick_map_tool
	pop bc
	ld de,00008h
	add ix,de
	djnz mtick_loop
	ret
; one E300 slot; d_a6dd by lo-nibble
tick_map_tool:                    ; 0xA6D5  one E300 slot; d_a6dd by lo-nibble
	ld a,(ix+000h)
	or a
	ret z
	dec a
	and 00fh
	call DISPATCH_A

; BLOCK 'd_a6dd_jp' (start 0xa6e0 end 0xa6ec)
d_a6dd_jp_start:
	defw tick_map_knife           ; type 1 knife
	defw tick_map_boom            ; type 2 boomerang
	defw tick_map_shovel          ; type 3 shovel (floor, 1 deep)
	defw tick_map_pick            ; type 4 pick (floor, 2 deep)
	defw tick_map_hammer          ; type 5 hammer (wall, 1 deep)
	defw tick_map_drill           ; type 6 drill (wall, 2 deep)
d_a6dd_jp_end:
tick_map_knife:                   ; 0xA6EC  then d_a6f2 (in-use states)
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_a6f2_jp' (start 0xa6f5 end 0xa6ff)
d_a6f2_jp_start:
	defw tool_scr                 ; knife: snap screen
	defw knife_go                 ; fly
	defw knife_fly
	defw knife_wait
	defw knife_sfx
d_a6f2_jp_end:
tool_scr:                         ; 0xA6FF  ix+3 = E243 (also boomerang)
	ld a,(0e243h)           ; screen
	ld (ix+003h),a
	ret
knife_go:                         ; 0xA706
	ld (ix+004h),000h
	ld a,(0e294h)
	ld (ix+007h),a
	call tool_next
	call knife_probe
	ret nc
knife_fly:                        ; 0xA717  shared tail of knife_go
	call knife_anim
	call tool_lock
	jr nc,knife_x
	ld a,(ix+007h)
	jr knife_dir
knife_x:
	call tool_step_x
	ret c
	ld a,c
knife_dir:
	rra
	ld a,004h
	jr nc,knife_align
	xor a
knife_align:
	add a,(ix+002h)
	and 0f8h
	cp 0f1h
	jr c,knife_xok
	ld a,0f0h
knife_xok:
	ld (ix+002h),a
	call tool_next
	jp tool_hold
knife_wait:                       ; 0xA743
	call tool_lock
	call knife_anim
	dec (ix+006h)
	ret nz
	xor a
	ld (ix+006h),004h
	ld (ix+005h),a
	ld (ix+007h),a
	call tool_next
	call tool_sat
	ld a,(ix+000h)
	and 0f0h
	ret nz
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	ret nz
	jp sfx_36
knife_sfx:                        ; 0xA76E
	call tool_lock
	call knife_anim
	call tool_fall
	ld a,(ix+000h)
	and 0f0h
	ret nz
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	ret nz
	jp sfx_36
; CY if IX is E2E8; clear EDCD
tool_lock:                      ; 0xA787  CY if IX is E2E8; clear EDCD
	ld a,(0edcdh)
	and a
	ret z
	push ix
	pop de
	ld hl,(0e2e8h)
	and a
	sbc hl,de
	jr nz,lock_no
	xor a
	ld (0edcdh),a
	scf
	ret
lock_no:
	and a
	ret
; wall/X probe; B = 8 or 16 step
knife_probe:                    ; 0xA79F  wall/X probe; B = 8 or 16 step
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	ret nz
	ld a,008h
	add a,(ix+002h)
	cp 0eeh
	jr c,probe_hi
	ld a,0e8h
	jr probe_xy
probe_hi:
	cp 008h
	jr nc,probe_xy
	ld a,008h
probe_xy:
	ld h,a
	ld l,(ix+001h)
	call map_tile_xy
	sub 002h
	ld b,010h
	jr nc,probe_face
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	sub 002h
	ld b,010h
	jr nc,probe_face
	ld a,l
	sub 008h
	ld l,a
	ld a,(0e294h)
	or a
	ld a,h
	jr nz,probe_r
	sub 008h
	jr probe_h
probe_r:
	add a,008h
probe_h:
	ld h,a
	ret c
	call map_tile_xy
	sub 002h
	jr nc,probe_8
	ld a,l
	add a,009h
	ld l,a
	call map_tile_xy
	sub 002h
	ret c
probe_8:
	ld b,008h
probe_face:
	ld a,(0e294h)
	or a
	ld a,b
	jr z,probe_put
	sub 008h
	neg
probe_put:
	add a,(ix+002h)
	and 0f8h
	ld (ix+002h),a
	call tool_hold
	call tool_next
	and a
	ret
; Map-tool hold timer = 0x18.
tool_hold:                        ; 0xA814
	ld (ix+006h),018h
	ret
; signed X step from B; C dir 2/3
tool_add_x:                     ; 0xA819  signed X step from B; C dir 2/3
	ld a,b
	bit 7,a
	ld c,003h
	jr z,add_pos
	neg
	ld b,a
	dec c
	jr add_neg
; X step from ix+7 facing
tool_step_x:                    ; 0xA826  X step from ix+7 facing
	ld a,(ix+007h)
	or a
	ld bc,00402h
	jr z,add_neg
	inc c
add_pos:
	ld a,(ix+002h)
	add a,b
	jr step_put
add_neg:
	ld a,(ix+002h)
	sub b
step_put:
	ld (ix+002h),a
	jr c,step_wrap
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	jr nz,step_scr
	ld h,(ix+002h)
	ld l,(ix+001h)
	push bc
	call probe_step
	pop bc
	ret
step_wrap:
	ld a,(ix+003h)
	push bc
	call screen_slot
	pop bc
	ld b,a
	push bc
	ld a,c
	inc a
	call room_link
	pop bc
	ld (ix+003h),l
step_scr:
	ld b,(ix+003h)
	ld hl,0e840h
	ld de,000c0h
e840_loop:
	add hl,de
	djnz e840_loop
	ex de,hl
	ld h,(ix+002h)
	ld l,(ix+001h)
	push bc
	call probe_step_de
	pop bc
	ret
; ix+4 mod 3; sfx_1c on wrap
knife_anim:                     ; 0xA87F  ix+4 mod 3; sfx_1c on wrap
	ld a,(0e203h)           ; puzzle board
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 003h
	jr c,anim_put
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	call z,sfx_1c
	xor a
anim_put:
	ld (ix+004h),a
	ret
tick_map_boom:                    ; 0xA89B
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_a8a1_jp' (start 0xa8a4 end 0xa8ae)
d_a8a1_jp_start:
	defw tool_scr                 ; boomerang: snap screen
	defw boom_go
	defw boom_fly
	defw boom_wait
	defw boom_sfx
d_a8a1_jp_end:
boom_go:                          ; 0xA8AE
	ld (ix+004h),003h
	ld (ix+005h),000h
	ld (ix+006h),008h
	ld a,(0e294h)
	ld (ix+007h),a
	call tool_next
	call knife_probe
	ret nc
boom_fly:                         ; 0xA8C7  shared tail of boom_go
	call boom_anim
	call tool_lock
	jr nc,boom_x
	ld a,(ix+007h)
	jr boom_dir
boom_x:
	dec (ix+006h)
	jr nz,boom_dx_go
	ld a,(ix+005h)
	inc a
	cp 009h
	jr c,boom_cap
	ld a,009h
boom_cap:
	ld (ix+005h),a
	ld e,a
	ld d,000h
	ld hl,boom_dt
	add hl,de
	ld a,(hl)
	ld (ix+006h),a
boom_dx_go:
	ld e,(ix+005h)
	ld d,000h
	ld hl,boom_dx
	add hl,de
	ld a,(ix+007h)
	or a
	ld a,(hl)
	jr nz,boom_neg
	neg
boom_neg:
	ld b,a
	call tool_add_x
	jr c,boom_vic
	ld a,c
boom_dir:
	rra
	ld a,004h
	jr nc,boom_align
	xor a
boom_align:
	add a,(ix+002h)
	and 0f8h
	cp 0f1h
	jr c,boom_xok
	ld a,0f0h
boom_xok:
	ld (ix+002h),a
	call tool_hold
; ix+0 += 0x10 (next in-use state)
tool_next:                        ; 0xA921  ix+0 += 0x10 (next in-use state)
	ld a,(ix+000h)
	add a,010h
	ld (ix+000h),a
	ret
boom_vic:
	ld a,(0e287h)           ; held tool
	or a
	ret nz
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	ret nz
	ld a,(0e282h)           ; Vic Y
	sub (ix+001h)
	jr nc,boom_dy
	neg
boom_dy:
	cp 00dh
	ret nc
	ld a,(0e284h)           ; Vic X
	sub (ix+002h)
	jr nc,boom_dx_abs
	neg
boom_dx_abs:
	cp 00dh
	ret nc
	ld hl,0e2a9h
	dec (hl)
	call sfx_35                   ; boom
	ld (ix+000h),012h
	ld a,002h
	ld (0e287h),a           ; held tool
	ret
; BLOCK 'boom_dx' (start 0xa961 end 0xa96b)
boom_dx:
	defb 004h, 003h, 002h, 001h, 000h, 0ffh, 0feh, 0fdh, 0fch, 0fbh
; BLOCK 'boom_dt' (start 0xa96b end 0xa975)
boom_dt:
	defb 008h, 006h, 004h, 003h, 002h, 003h, 004h, 006h, 008h, 0ffh
boom_wait:                        ; 0xA975
	call tool_lock
	call boom_anim
	dec (ix+006h)
	ret nz
	xor a
	ld (ix+004h),003h
	ld (ix+005h),a
	ld (ix+006h),004h
	ld (ix+007h),a
	call tool_next
	jp tool_sat
boom_sfx:                         ; 0xA994
	call tool_lock
	call boom_anim
	jp tool_fall
; ix+4 mod 6; sfx_1b on wrap
boom_anim:                      ; 0xA99D  ix+4 mod 6; sfx_1b on wrap
	ld a,(0e203h)           ; puzzle board
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 006h
	jr c,banim_put
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	call z,sfx_1b
	ld a,003h
banim_put:
	ld (ix+004h),a
	ret
; gravity Y for a map tool
tool_fall:                      ; 0xA9BA  gravity Y for a map tool
	dec (ix+006h)
	ld a,(ix+005h)
	jr nz,fall_y
	cp 005h
	jr nc,fall_cap
	inc a
	ld (ix+005h),a
fall_cap:
	ld e,a
	ld d,000h
	ld hl,fall_dt
	add hl,de
	ld a,(hl)
	ld (ix+006h),a
	ld a,e
fall_y:
	inc a
	add a,(ix+001h)
	ld (ix+001h),a
	cp 0b8h
	jr nc,tool_wrap_y
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	jr nz,tool_sat
	ld a,(ix+001h)
	add a,010h
	cp 0b8h
	jr c,fall_floor
	ld a,0b8h
fall_floor:
	ld l,a
	ld a,(ix+002h)
	add a,008h
	ld h,a
	call map_tile
	cp 002h
	jr nc,tool_land
	ret
tool_wrap_y:
	ld a,008h
	ld (ix+001h),a
	ld a,(ix+003h)
	call screen_slot
	ld b,a
	ld a,002h
	call room_link
	ld (ix+003h),l
; map-tool SAT at E840 + screen*0xC0
tool_sat:                       ; 0xAA17  map-tool SAT at E840 + screen*0xC0
	ld b,(ix+003h)
	ld hl,0e840h
	ld de,000c0h
tsat_loop:
	add hl,de
	djnz tsat_loop
	ex de,hl
	ld h,(ix+002h)
	ld l,(ix+001h)
	ld c,001h
	call probe_step_de
	ret c
tool_land:
	ld hl,0e2a9h
	dec (hl)
	ld a,(ix+001h)
	and 0f8h
	ld (ix+001h),a
	ld a,(ix+000h)
	and 00fh
	ld (ix+000h),a
	ld a,(0e243h)           ; screen
	cp (ix+003h)
	ret nz
	call e300_front
	push ix
	call stones_undraw
	pop ix
	call tool_stamp
	push ix
	call stones_redraw
	pop ix
	ret
; BLOCK 'fall_dt' (start 0xaa60 end 0xaa66)
fall_dt:
	defb 003h, 003h, 003h, 003h, 003h, 0ffh
tick_map_shovel:                  ; 0xAA66
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_aa6c_jp' (start 0xaa6f end 0xaa75)
d_aa6c_jp_start:
	defw tool_scr                 ; shovel: snap screen
	defw shovel_go
	defw shovel_dig
d_aa6c_jp_end:
shovel_go:                        ; 0xAA75
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp tool_next
shovel_dig:                       ; 0xAA84
	call shovel_anim
	ld a,(ix+007h)
	or a
	ret z
; Dig finished: restore Vic pose, clear E287.
dig_done:                         ; 0xAA8C
	ld a,(0e294h)
	or a
	ld a,003h
	jr nz,dig_face
	xor a
dig_face:
	ld (0e285h),a           ; vic frame
	xor a
	ld (ix+000h),a
	ld (0e287h),a           ; held tool
	ld a,(0e298h)           ; die SAT
	or a
	ret nz
	xor a
	ld (0e280h),a           ; Vic state
	ret
; dig frames; stamp from AB03
shovel_anim:                    ; 0xAAA9  dig frames; stamp from AB03
	dec (ix+006h)
	ret nz
	ld (ix+006h),008h
	ld a,(ix+005h)
	inc a
	cp 003h
	jr z,shovel_cut
	push af
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00102h
	call stamp_wtiles
	pop af
	ld (ix+005h),a
	add a,a
	ld e,a
	ld d,000h
	ld hl,shovel_id
	add hl,de
	ex de,hl
	ld hl,(0e2a2h)
	ld a,(de)
	ex de,hl
	inc hl
	push hl
	push de
	call tile_pset
	pop de
	pop hl
	ld a,d
	add a,008h
	ld d,a
	ld a,(hl)
	jp tile_pset
shovel_cut:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00102h
	call stamp_wtiles
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)           ; screen
	ld d,a
	ld bc,00102h
	xor a
	jp stamp_rect
; BLOCK 'shovel_id' (start 0xab03 end 0xab09)
shovel_id:
	defb 006h, 007h, 008h, 009h, 00ah, 00bh
tick_map_pick:                    ; 0xAB09
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_ab0f_jp' (start 0xab12 end 0xab1a)
d_ab0f_jp_start:
	defw tool_scr                 ; pick: snap screen
	defw pick_go
	defw pick_dig
	defw pick_dig2
d_ab0f_jp_end:
; thrown pick: start
pick_go:                          ; 0xAB1A
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp tool_next
pick_dig:                         ; 0xAB29
	call shovel_anim
	ld a,(ix+007h)
	or a
	ret z
	ld hl,(0e2a2h)
	ld a,l
	add a,008h
	ld l,a
	ld (0e2a2h),hl
	call map_tile_xy
	cp 002h
	jp nz,dig_done
	ld a,h
	add a,008h
	ld h,a
	call map_tile
	cp 002h
	jp nz,dig_done
	call pick_go
pick_dig2:                        ; 0xAB52
	call shovel_anim
	ld a,(ix+007h)
	or a
	ret z
	jp dig_done
tick_map_hammer:                  ; 0xAB5D
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_ab63_jp' (start 0xab66 end 0xab6c)
d_ab63_jp_start:
	defw tool_scr                 ; hammer: snap screen
	defw hammer_go
	defw hammer_dig
d_ab63_jp_end:
hammer_go:                        ; 0xAB6C
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp tool_next
hammer_dig:                       ; 0xAB7B
	call wall_anim
	ld a,(ix+007h)
	or a
	ret z
	jp dig_done
; hammer/drill wall frames from ABE9
wall_anim:                      ; 0xAB86  hammer/drill wall frames from ABE9
	dec (ix+006h)
	ret nz
	ld (ix+006h),008h
	ld a,(ix+005h)
	inc a
	cp 003h
	jr z,wall_cut
	push af
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00201h
	call stamp_wtiles
	pop af
	ld (ix+005h),a
	add a,a
	ld e,a
	ld d,000h
	ld hl,hammer_l
	ld a,(0e294h)
	or a
	jr z,wall_pat
	ld hl,hammer_r
wall_pat:
	add hl,de
	ex de,hl
	ld hl,(0e2a2h)
	ld a,(de)
	ex de,hl
	inc hl
	push hl
	push de
	call tile_pset
	pop de
	pop hl
	ld a,e
	add a,008h
	ld e,a
	ld a,(hl)
	jp tile_pset
wall_cut:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00201h
	call stamp_wtiles
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)           ; screen
	ld d,a
	ld bc,00201h
	xor a
	jp stamp_rect
; BLOCK 'hammer_l' (start 0xabe9 end 0xabef)
hammer_l:
	defb 00ch, 00dh, 00eh, 00fh, 010h, 011h
; BLOCK 'hammer_r' (start 0xabef end 0xabf5)
hammer_r:
	defb 012h, 013h, 014h, 015h, 016h, 017h
tick_map_drill:                   ; 0xABF5
	call tool_phase
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_abfb_jp' (start 0xabfe end 0xac06)
d_abfb_jp_start:
	defw tool_scr                 ; drill: snap screen
	defw drill_go
	defw drill_dig
	defw drill_dig2
d_abfb_jp_end:
drill_go:                         ; 0xAC06
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp tool_next
drill_dig:                        ; 0xAC15
	call wall_anim
	ld a,(ix+007h)
	or a
	ret z
	ld hl,(0e2a2h)
	ld b,0f8h
	ld a,(0e294h)
	or a
	jr z,drill_x
	ld b,008h
drill_x:
	ld a,h
	add a,b
	ld h,a
	ld (0e2a2h),hl
	call map_tile_xy
	cp 002h
	jp nz,dig_done
	ld a,l
	add a,008h
	ld l,a
	call map_tile
	cp 002h
	jp nz,dig_done
	ld a,(0e294h)
	or a
	ld b,008h
	jr nz,drill_vic
	ld b,0f8h
drill_vic:
	ld a,(0e284h)           ; Vic X
	add a,b
	ld (0e284h),a           ; Vic X
	jp drill_go
drill_dig2:                       ; 0xAC58
	call wall_anim
	ld a,(ix+007h)
	or a
	ret z
	jp dig_done
; ix+0 high nibble (in-use state)
tool_phase:                       ; 0xAC63  ix+0 high nibble (in-use state)
	ld a,(ix+000h)
	rra
	rra
	rra
	rra
	and 00fh
	ret
; C = E500 id; reject C >= 5
spawn_tool:                       ; 0xAC6D  C = E500 id; reject C >= 5
	ld (0e252h),a
	ld a,c
	cp 005h
	ret nc
	exx
	ld hl,0e500h            ; thrown tools
	ld b,008h
	ld de,00020h
	xor a
spawn_scan:
	cp (hl)
	jr z,spawn_free
	add hl,de
	djnz spawn_scan
	scf
	ret
spawn_free:
	push hl
	push hl
	pop ix
	exx
	pop hl
	call spawn_fill
	xor a
	ret
; fill a free E500 slot from spawn_tool
spawn_fill:                     ; 0xAC91  fill a free E500 slot from spawn_tool
	ld (hl),c
	inc l
	ld (hl),000h
	inc l
	ld (hl),000h
	inc l
	ld (hl),e
	inc l
	ld (hl),000h
	inc l
	ld (hl),d
	inc l
	ld (hl),000h
	ld de,00006h
	add hl,de
	push hl
	ld a,(0e252h)
	call map_of_a
	pop hl
	ld (hl),e
	inc l
	ld (hl),d
	inc l
	ld (hl),000h
	inc l
	ld (hl),000h
	inc l
	ld a,(0e252h)
	ld (hl),a
	inc l
	inc l
	ld (hl),001h
	inc l
	ld (hl),000h
	inc l
	inc l
	ld (hl),b
	inc l
	push hl
	call d_acd9_jp_end
	ld a,(0e252h)
	call screen_of
	pop hl
	ld (hl),a
	ld de,0ffeah
	add hl,de
	ld a,(hl)
	dec a
	call DISPATCH_A

; BLOCK 'd_acd9_jp' (start 0xacdc end 0xace4)
d_acd9_jp_start:
	defw spawn_kb
	defw spawn_kb
	defw spawn_shovel
	defw spawn_pick
; spawn_tool: type in ix+0
d_acd9_jp_end:
	ld a,(0f0f4h)
	and a
	ld a,(ix+000h)
	jr z,spawn_msx1
	add a,a
	ld de,e500_cc2
	call ADD_DE_A
	ld a,(de)
	ld (ix+01eh),a
	inc de
	ld a,(de)
	ld (ix+01fh),a
	ret
; MSX1 SAT cc byte from e500_cc1[type].
spawn_msx1:                       ; 0xACFE
	ld de,e500_cc1
	call ADD_DE_A
	ld a,(de)
	ld (ix+01eh),a
e500_cc1:                           ; 0xAD08  MSX1 SAT cc[0] overlaps RET
	ret
	defb 00fh, 00ah               ; 0xAD09
e500_cc2:                         ; 0xAD0B  MSX2 SAT cc words
	defb 00ah, 009h
	defb 00bh, 04ch
	defb 00ah, 047h
	defb 00bh, 04ch
	defb 00bh, 04ch
; A = screen id -> DE = E900 base
map_of_a:                       ; 0xAD15  A = screen id -> DE = E900 base
	dec a
	ld h,a
	ld l,000h
	ld e,l
	ld d,h
	srl d
	rr e
	srl d
	rr e
	and a
	sbc hl,de
	ld de,0e900h            ; unpacked map
	add hl,de
	ex de,hl
	ret
spawn_kb:                         ; 0xAD2C  knife / boomerang E500 init
	ld (ix+018h),000h
	ld (ix+011h),0ffh
	ld hl,knife_stamp
	call e500_stamp
	call vic_side_x
	inc c
	inc c
	ld (ix+00bh),c
	ld a,(ix+000h)
	dec a
	call z,e500_flip
	ld (ix+014h),020h
	ld hl,sfx_1e
	jp thrown_sfx
; 3x2 draw_tilemap under a thrown tool
e500_stamp:                     ; 0xAD53  3x2 draw_tilemap under a thrown tool
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
	push ix
	push hl
	call stones_undraw
	call tools_scan
	pop hl
	pop ix
	ld a,(ix+003h)
	sub 008h
	ld e,a
	ld d,(ix+005h)
	ld bc,00302h
	call draw_tilemap
	push ix
	call draw_maptools
	call stones_redraw
	pop ix
	ret
tick_thrown_knife:                ; 0xAD80  E500; d_ad83 (5 states)
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_ad83_jp' (start 0xad86 end 0xad90)
d_ad83_jp_start:
	defw thrown_wind              ; knife: throw / fall / land (5 states)
	defw thrown_hide
	defw knife_toss
	defw knife_seek
	defw knife_home
d_ad83_jp_end:
knife_toss:                       ; 0xAD90
	call thrown_drop
	ld a,004h
	jp c,thrown_fall
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	ld de,00180h
	call thrown_xy_d
	call e500_flip
	call thrown_step
	jp c,thrown_next
	call e500_flip
	call thrown_step
	jp nc,thrown_stop
	jp thrown_next
knife_seek:                       ; 0xADBB
	ld (ix+006h),001h
	call thrown_dir
	call thrown_drop
	jr nc,seek_go
	call thrown_snap
	ld a,004h
	jp thrown_fall
seek_go:
	call thrown_step
	jr nc,seek_count
	call thrown_edge
	dec a
	cp (ix+00bh)
	ret nz
	jp thrown_nudge
seek_count:
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,thrown_stop
; E500 state 2: snap + timer
thrown_air:                     ; 0xADEA  E500 state 2: snap + timer
	call thrown_snap
	ld (ix+014h),010h
	ld (ix+006h),000h
	ld (ix+001h),002h
	ret
knife_home:                       ; 0xADFA
	ld (ix+006h),001h
	call thrown_origin
	ret c
	call thrown_snap
	call shovel_sfx
	call thrown_air
	ld (ix+006h),000h
	ld a,(ix+019h)
	xor 001h
	or 002h
	ld (ix+00bh),a
	ret
; xor ix+11 facing
e500_flip:                      ; 0xAE1A  xor ix+11 facing
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
tick_thrown_boom:                 ; 0xAE23  E500; returns
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_ae26_jp' (start 0xae29 end 0xae35)
d_ae26_jp_start:
	defw thrown_wind              ; boomerang: throw / fly / return (6 states)
	defw thrown_hide
	defw boom_toss
	defw boom_seek
	defw boom_turn
	defw boom_catch
d_ae26_jp_end:
thrown_wind:                      ; 0xAE35  shared knife/boom wind-up
	dec (ix+014h)
	ret nz
	ld hl,boom_stamp
	call e500_stamp
	ld hl,sfx_41
	call thrown_sfx
	ld (ix+013h),002h
	ld (ix+011h),000h
	ld (ix+014h),020h
; Advance thrown E500 state (ix+1).
thrown_next:                      ; 0xAE51
	inc (ix+001h)
	ret
thrown_hide:                      ; 0xAE55  shared: undraw then next state
	dec (ix+014h)
	ret nz
	call e500_undraw
	ld (ix+013h),003h
	ld (ix+014h),020h
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	call z,sfx_25
	jr thrown_next
; restore 3x2 world tiles under throw
e500_undraw:                    ; 0xAE6F  restore 3x2 world tiles under throw
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
	ld d,(ix+005h)
	ld a,(ix+003h)
	sub 008h
	ld e,a
	ld bc,00302h
	call stamp_wtiles
	ld hl,throw_under
	jp e500_stamp
boom_toss:                        ; 0xAE8B
	call thrown_drop
	jp c,boom_drop
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	call thrown_reset
	call thrown_face
	ld de,00180h
	call thrown_xy_d
	call thrown_step
	jr c,thrown_next
	call e500_flip
	call thrown_step
	jp nc,thrown_stop
	jr thrown_next
boom_seek:                        ; 0xAEB5
	ld (ix+006h),001h
	call thrown_dir
	call thrown_drop
	jr nc,bseek_go
	call thrown_snap
	jr boom_drop
bseek_go:
	call thrown_edge
	dec a
	cp (ix+00bh)
	jp z,thrown_nudge
	call thrown_step
	jr c,bseek_floor
	call thrown_snap
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,thrown_stop
	jp boom_air
bseek_floor:
	call vic_side_y
	dec c
	ret m
	jr z,bseek_here
	call floor_down
	ret nz
	ld a,001h
	jr bseek_dir
bseek_here:
	call floor_here
	ret nz
	xor a
bseek_dir:
	ld (ix+00bh),a
	ld de,00280h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld a,(ix+005h)
	and 0f8h
	ld (ix+005h),a
	jp thrown_next
; ix+11 from facing + E203 bit 2
thrown_dir:                     ; 0xAF14  ix+11 from facing + E203 bit 2
	ld c,001h
	bit 0,(ix+00bh)
	jr z,dir_left
	ld c,003h
; C = facing (1 left / 3 right)
dir_left:
	ld a,(0e203h)           ; puzzle board
	and 004h
	jr z,dir_put
	inc c
dir_put:
	ld (ix+011h),c
	ret
boom_drop:
	ld a,005h
thrown_fall:
	ld (ix+001h),a
	xor a
	ld (ix+009h),a
	ld (ix+00ah),a
	ld a,(ix+00bh)
	ld (ix+019h),a
	ld (ix+00bh),001h
	ld (ix+007h),000h
	ld (ix+008h),005h
drop_sfx:
	ld hl,sfx_2c
	jp thrown_sfx
boom_turn:                        ; 0xAF4E  reverse when blocked
	ld (ix+006h),001h
	ld c,005h
	call dir_left
	call thrown_block
	jp c,turn_snap
	call thrown_edge
	dec a
	cp (ix+00bh)
	jr z,turn_flip
	call thrown_step
	ret c
turn_flip:
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
turn_snap:
	call thrown_snap
	xor a
	ld (ix+002h),a
	ld (ix+018h),a
; boomerang airborne
boom_air:
	ld (ix+014h),010h
	ld (ix+006h),000h
	ld (ix+001h),002h
	ret
boom_catch:                       ; 0xAF8A
	ld (ix+006h),001h
	call thrown_origin
	ret c
	call thrown_snap
	call shovel_sfx
	call boom_air
	ld a,(ix+019h)
	xor 001h
	or 003h
	ld (ix+00bh),a
	ld (ix+006h),000h
	ret
; ix+11 = vic_side_x | 2
thrown_face:                    ; 0xAFAA  ix+11 = vic_side_x | 2
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
; E500 vs Vic on room change (pick type 4)
e500_room:                        ; 0xAFB4  E500 vs Vic on room change (pick type 4)
	ld ix,0e500h            ; thrown tools
	call vic_xy
	ld b,008h
room_loop:
	ld a,(ix+000h)
	and a
	jr z,room_next
	bit 0,(ix+013h)
	jr z,room_next
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jr nz,room_next
	ld a,(ix+003h)
	sub e
	add a,018h
	cp 030h
	jr nc,room_next
	ld a,(ix+005h)
	sub d
	add a,018h
	cp 030h
	jr nc,room_next
	push de
	push bc
	call thrown_hit
	pop bc
	pop de
room_next:
	ex de,hl
	ld de,00020h
	add ix,de
	ex de,hl
	djnz room_loop
	ret
; room-change overlap: pick vs kill
thrown_hit:                     ; 0xAFF6  room-change overlap: pick vs kill
	ld a,(ix+000h)
	cp 004h
	jp nz,thrown_done
	ld a,(ix+001h)
	cp 004h
	jr z,hit_pick
	dec a
	jp nz,thrown_done
hit_pick:
	call map_restore
	jp thrown_done
; Vic near screen edge vs this E500
thrown_edge:                    ; 0xB00F  Vic near screen edge vs this E500
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jp z,edge_no
	call vic_xy
	ld l,(ix+003h)
	ld h,(ix+005h)
	ld a,(ix+00bh)
	ret z
	dec a
	jr z,edge_bot
	dec a
	jr z,edge_lf
	dec a
	jr z,edge_rt
	ld a,l
	cp 018h
	jr nc,edge_no
	ld a,e
	cp 098h
	jr c,edge_no
	ld a,h
	sub d
	add a,018h
	cp 030h
	jr nc,edge_no
	ld a,001h
	call thrown_link
	jr nz,edge_no
	ret
edge_bot:
	ld a,l
	cp 098h
	jr c,edge_no
	ld a,e
	cp 010h
	jr nc,edge_no
	ld a,h
	sub d
	add a,018h
	cp 030h
	jr nc,edge_no
	ld a,002h
	call thrown_link
	jr nz,edge_no
	ret
edge_lf:
	ld a,h
	cp 018h
	jr nc,edge_no
	ld a,d
	cp 0d8h
	jr c,edge_no
	ld a,l
	sub e
	add a,018h
	cp 030h
	jr nc,edge_no
	ld a,003h
	call thrown_link
	jr nz,edge_no
	ret
edge_rt:
	ld a,h
	cp 0d8h
	jr c,edge_no
	ld a,d
	cp 018h
	jr nc,edge_no
	ld a,l
	sub e
	add a,018h
	cp 030h
	jr nc,edge_no
	ld a,004h
	call thrown_link
	jr nz,edge_no
	ret
; room_link ix+16; Z if H==E244
thrown_link:                    ; 0xB096  room_link ix+16; Z if H==E244
	push af
	ld b,(ix+016h)
	call room_link
	ld a,(0e244h)
	cp h
	pop bc
	ld a,b
	ret
edge_no:
	xor a
	ret
; Nudge thrown tool 16px in ix+11 dir if 2x2 is air.
thrown_nudge:                     ; 0xB0A6
	ld a,(ix+00bh)
	add a,a
	ld hl,thrown_delta
	call ADD_HL_A
	ld c,(hl)
	inc hl
	ld b,(hl)
	call thrown_map
	ld a,c
	add a,l
	ld l,a
	ld a,b
	add a,h
	ld h,a
	call tile_empty
	ret nc
	ld a,008h
	add a,h
	ld h,a
	call tile_empty
	ret nc
	ld a,008h
	add a,l
	ld l,a
	call tile_empty
	ld a,0f8h
	add a,h
	ld h,a
	call tile_empty
	ret nc
	call thrown_xy
	ld a,c
	add a,l
	ld (ix+003h),a
	ld a,b
	add a,h
	ld (ix+005h),a
	ret
; NC if map_tile_de is air (0)
tile_empty:                     ; 0xB0E5  NC if map_tile_de is air (0)
	push de
	push hl
	push bc
	call map_tile_de
	pop bc
	pop hl
	pop de
	sub 001h
	ret
; BLOCK 'thrown_delta' (start 0xb0f1 end 0xb0f9)
thrown_delta:
	defb 010h, 000h
	defb 0f0h, 000h
	defb 000h, 010h
	defb 000h, 0f0h
; CY if next 2x2 is blocked
thrown_block:                   ; 0xB0F9  CY if next 2x2 is blocked
	ld a,(ix+00bh)
	dec a
	jr z,block_up
block_ahead:
	call thrown_ahead
	ccf
	ret nc
	ld a,l
	add a,007h
	and 0f8h
	ld l,a
	call tile_at
	ret z
	ld a,008h
	add a,l
	ld l,a
	call tile_at
	ret z
	ld a,008h
	add a,h
	ld h,a
	call tile_at
	ret z
	ld a,l
	sub 008h
	ld l,a
	call tile_at
	ret z
	scf
	ret
block_up:
	call thrown_step
	ccf
	ret c
	jr block_ahead
; map_tile_de at HL vs ix+C/D base
tile_at:                        ; 0xB12F  map_tile_de at HL vs ix+C/D base
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	push hl
	call map_tile_de
	pop hl
	and a
	dec a
	ret
; Probe 2 tiles at thrown XY; C=0 (up).
floor_up:                         ; 0xB13D
	call floor_here
	ld c,000h
	ret z
; probe 2 tiles 16px below
floor_down:                     ; 0xB143  probe 2 tiles 16px below
	call thrown_xy
	ld a,010h
	add a,l
	ld l,a
	call floor_span
	ld c,001h
	ret
; probe 2 tiles at thrown XY
floor_here:                     ; 0xB150  probe 2 tiles at thrown XY
	call thrown_xy
; two tile_at, H += 8
floor_span:                     ; 0xB153  two tile_at, H += 8
	call tile_at
	ret nz
	ld a,h
	add a,008h
	ld h,a
	jp tile_at
; down probe via step_origin
thrown_drop:                    ; 0xB15E  down probe via step_origin
	call thrown_xy
	ld c,001h
	jr drop_probe
; probe_step_de in ix+11 dir
thrown_step:                    ; 0xB165  probe_step_de in ix+11 dir
	ld c,(ix+00bh)
; ahead + probe_step_de; C=dir
thrown_probe:                   ; 0xB168  ahead + probe_step_de; C=dir
	call thrown_ahead
	ret c
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	push hl
	push de
	call probe_step_de
	pop de
	pop hl
	ret
; step_origin then two tile_air
thrown_origin:                  ; 0xB17A  step_origin then two tile_air
	ld c,(ix+00bh)
	call thrown_ahead
	ret c
drop_probe:
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	call step_origin
	call tile_air
	ret nc
	call step_shift
; Z if map_tile_de is air
tile_air:                       ; 0xB191  Z if map_tile_de is air
	push hl
	push de
	push bc
	call map_tile_de
	pop bc
	pop de
	pop hl
	sub 001h
	ret
; HL += 8 on the travel axis
step_shift:                     ; 0xB19D  HL += 8 on the travel axis
	ld a,c
	cp 002h
	jr c,shift_x
	ld a,l
	add a,008h
	ld l,a
	ret
shift_x:
	ld a,h
	add a,008h
	ld h,a
	ret
; next pixel XY from velocity
thrown_ahead:                   ; 0xB1AC  next pixel XY from velocity
	ld a,(ix+006h)
	and a
	jp z,thrown_xy
	ld a,c
	dec a
	jr z,ahead_down
	dec a
	jr z,ahead_left
	dec a
	jr z,ahead_right
	xor a
	jr ahead_y
ahead_down:
	ld a,001h
ahead_y:
	ld l,(ix+002h)
	ld h,(ix+003h)
	ld e,(ix+007h)
	ld d,(ix+008h)
	and a
	call z,neg_de
	add hl,de
	ld l,h
	ld h,(ix+005h)
	ld a,l
	cp 0c0h
	ccf
	ret
ahead_left:
	xor a
	jr ahead_x
ahead_right:
	ld a,001h
ahead_x:
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+009h)
	ld b,h
	ld d,(ix+00ah)
	and a
	call z,neg_de
	add hl,de
	ld l,(ix+003h)
	ld a,h
	sub b
	jr nc,ahead_dx
	neg
ahead_dx:
	cp 080h
	ccf
	ret
; two's complement DE
neg_de:                         ; 0xB200  two's complement DE
	ld a,e
	cpl
	ld e,a
	ld a,d
	cpl
	ld d,a
	inc de
	ret
thrown_hold4:                   ; 0xB208  A=4 then thrown_hold
	ld a,004h
; thrown hold timer; CY when ix+14 reaches A
thrown_hold:                    ; 0xB20A  thrown hold timer; CY when ix+14 reaches A
	inc (ix+00eh)
	cp (ix+00eh)
	ret
; clear thrown hold timer
thrown_reset:                   ; 0xB211  clear thrown hold timer
	xor a
	ld (ix+00eh),a
	ret
; DE = map ptr; HL = thrown XY
thrown_map:                     ; 0xB216  DE = map ptr; HL = thrown XY
	ld e,(ix+00ch)
	ld d,(ix+00dh)
; HL = ix+3 Y, ix+5 X
thrown_xy:                      ; 0xB21C  HL = ix+3 Y, ix+5 X
	ld l,(ix+003h)
	ld h,(ix+005h)
	ret
; C = 0/1 Vic vs thrown on X
vic_side_x:                     ; 0xB223  C = 0/1 Vic vs thrown on X
	ld a,(ix+016h)
	and 007h
	ld c,a
	ld a,(0e244h)
	and 007h
	cp c
	ld c,000h
	jr z,side_x_same
	ret c
	inc c
	ret
side_x_same:
	ld a,(0e284h)           ; Vic X
	cp (ix+005h)
	ret c
	inc c
	ret
; C = row/Y side vs Vic
vic_side_y:                     ; 0xB23F  C = row/Y side vs Vic
	ld a,(ix+016h)
	and 038h
	ld c,a
	ld a,(0e244h)
	and 038h
	cp c
	ld c,000h
	jr z,side_y_below
	inc c
	ret c
	inc c
	ret
side_y_below:
	ld a,(0e282h)           ; Vic Y
	sub (ix+003h)
	jr c,side_y_above
	cp 010h
	ret c
	ld c,002h
	ret
side_y_above:
	add a,010h
	ret c
	inc c
	ret
; A = E788 index of ix+16
screen_of:                      ; 0xB266  A = E788 index of ix+16
	ld hl,0e788h            ; screen ids
	ld bc,00040h
	cpir
	ld a,c
	sub 03fh
	neg
	ret
spawn_shovel:                     ; 0xB274  shovel E500 init
	ld (ix+01bh),0ffh
	ld (ix+01dh),080h
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	ld (ix+011h),018h
	ld (ix+018h),0ffh
	ld (ix+01ch),000h
	ld hl,sfx_1d
; packed-PSG in HL if this thrown tool is on the current screen
thrown_sfx:                     ; 0xB294  jp (hl) when E243 == ix+16
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
	jp (hl)
; thrown XY delta
thrown_xy_d:                    ; 0xB29C  thrown XY delta
	ld (ix+009h),e
	ld (ix+00ah),d
	ret
; ix+7/8 = DE
thrown_dxy:                     ; 0xB2A3  ix+7/8 = DE
	ld (ix+007h),e
	ld (ix+008h),d
	ret
tick_thrown_shovel:               ; 0xB2AA  E500; floor 1 deep
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_b2ad_jp' (start 0xb2b0 end 0xb2ba)
d_b2ad_jp_start:
	defw shov_spin                ; shovel: floor hole 1 deep
	defw shov_drop
	defw shov_cut
	defw shov_turn
	defw shov_end
d_b2ad_jp_end:
shov_spin:                        ; 0xB2BA
	ld a,(0f0f4h)
	ld hl,shovel_fr
	ld de,shovel_fr2
	call pick_frame
	jr z,spin_next
	cp 007h
	jr nz,spin_pat
	bit 0,(ix+00bh)
	jr z,spin_face
	inc a
spin_face:
	ld (ix+011h),a
	ld a,(0f0f4h)
	and a
	ret z
	ld (ix+01eh),00ah
	ld (ix+01fh),047h
	ret
spin_pat:
	ld (ix+011h),a
	ret
spin_next:
	ld (ix+014h),008h
	ld (ix+013h),003h
thrown_inc:
	inc (ix+001h)
	ret
; BLOCK 'shovel_fr' (start 0xb2f4 end 0xb2fe)
shovel_fr:
	defb 018h, 019h, 018h, 019h, 018h, 019h, 01ah, 007h, 007h, 0ffh
; BLOCK 'shovel_fr2' (start 0xb2fe end 0xb307)
shovel_fr2:
	defb 018h, 019h, 018h, 019h, 018h, 019h, 007h, 007h, 0ffh
shov_drop:                        ; 0xB307
	call floor_zero
	jp z,cut_fall
	ld c,009h
shov_pat_c:
	call shovel_pat
	dec (ix+014h)
	ret nz
	ld a,(ix+01dh)
drop_slow:
	cp 002h
drop_near:
	jr nc,drop_home
drop_far:
	ld a,(ix+018h)
	sub (ix+005h)
	add a,00ch
	cp 019h
	jr c,drop_turn
drop_home:
	call vic_side_y
	dec c
	jp z,try_up
	dec c
	jp z,try_dn
	ld a,(ix+01ch)
	cp 002h
	jp nc,drop_alt
drop_turn:
	call boom_home
	call shovel_ceil
	jr c,drop_go
	ld a,(ix+00bh)
	xor 001h
	or 002h
	ld (ix+00bh),a
	call shovel_ceil
	jp nc,thrown_stop
	ld a,(ix+01ch)
	cp 010h
	jp nc,thrown_stop
	inc (ix+01ch)
drop_go:
	ld de,000f0h
	call thrown_xy_d
	ld (ix+006h),000h
	ld (ix+014h),011h
	ld a,(ix+005h)
	ld (ix+018h),a
	ld a,(ix+00bh)
	ld (ix+019h),a
	inc (ix+01dh)
	ld hl,sfx_1f
	call thrown_sfx
	jp thrown_inc
; CY if 3 tiles above are floor
shovel_ceil:                    ; 0xB385  CY if 3 tiles above are floor
	call thrown_map
	ld a,l
	sub 008h
	ld l,a
	jr c,ceil_no
	call shovel_wall
	jr c,ceil_side
	call thrown_map
	call shovel_wall
	ret nc
ceil_side:
	call thrown_map
	ld a,l
	sub 008h
	ld l,a
	bit 0,(ix+00bh)
	jr z,ceil_left
	ld a,h
	add a,008h
	jr c,ceil_x
	ld h,a
	jr ceil_x
ceil_left:
	ld a,h
	sub 008h
	jr c,ceil_x
	ld h,a
ceil_x:
	ld b,003h
ceil_loop:
	push bc
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	pop bc
	cp 002h
	jr nc,ceil_no
	ld a,h
	add a,008h
	ld h,a
	djnz ceil_loop
	ld (ix+01ah),000h
	scf
	ret
ceil_no:
	ld (ix+01ah),001h
	scf
	ret
; NC if side tile is solid (>=2)
shovel_wall:                    ; 0xB3D6  NC if side tile is solid (>=2)
	bit 0,(ix+00bh)
	jr nz,wall_r
	ld a,h
	add a,007h
	sub 008h
	jr nc,wall_l
	xor a
	ld h,a
wall_l:
	jr wall_tile
wall_r:
	ld a,h
	add a,011h
	jr nc,wall_tile
	ld a,0f8h
wall_tile:
	ld h,a
	call map_tile_de
	sub 002h
	ret
drop_alt:
	bit 0,(ix+01ch)
	jr z,alt_up
	call thrown_xy
	ld a,l
	add a,010h
	ld l,a
	call shovel_gap
	ld a,001h
	jr nc,shov_set_dir
	jr try_up
alt_up:
	call thrown_xy
	call shovel_gap
	ld a,000h
	jr nc,shov_set_dir
	jr try_dn
try_up:
	ld a,(ix+01bh)
	and a
	jr z,try_up_gap
	ld a,(ix+01dh)
	cp 002h
	jp c,drop_turn
try_up_gap:
	call thrown_xy
	call shovel_gap
	jp c,drop_turn
	xor a
shov_set_dir:
	ld (ix+00bh),a
	ld (ix+01bh),a
	ld (ix+01dh),000h
	ld (ix+006h),001h
	ld (ix+01ch),000h
	ld de,00000h
	call thrown_xy_d
	ld de,00100h
	call thrown_dxy
	ld (ix+001h),003h
	ret
try_dn:
	ld a,(ix+01bh)
	dec a
	jr z,try_dn_gap
	ld a,(ix+01dh)
	cp 002h
	jp c,drop_turn
try_dn_gap:
	call thrown_xy
	ld a,l
	add a,010h
	ld l,a
	call shovel_gap
	jp c,drop_turn
	ld a,001h
	jr shov_set_dir
; nudge X when 1 of 2 floor cells
shovel_gap:                     ; 0xB471  nudge X when 1 of 2 floor cells
	call tile_at
	ld c,000h
	jr z,gap_r
	inc c
gap_r:
	ld a,h
	add a,008h
	ld h,a
	push bc
	call tile_at
	pop bc
	jr z,gap_bits
	set 1,c
gap_bits:
	ld a,c
	and a
	jr z,gap_snap
	cp 003h
	scf
	ret z
	dec a
	jr z,gap_l
	ld a,h
	and 007h
	cp 007h
	ccf
	ret c
	ld c,0f8h
	jr gap_snap
gap_l:
	ld a,h
	and 007h
	cp 001h
	ret c
	ld c,008h
gap_snap:
	ld a,(ix+005h)
	add a,c
	and 0f8h
	ld (ix+005h),a
	xor a
	ret
; ix+11 = C (+2 if facing)
shovel_pat:                     ; 0xB4AF  ix+11 = C (+2 if facing)
	bit 0,(ix+00bh)
	jr z,pat_put
	inc c
	inc c
pat_put:
	ld (ix+011h),c
	ret
shov_cut:                         ; 0xB4BB
	call thrown_edge
	dec a
	cp (ix+00bh)
	ld (ix+006h),000h
	ret z
	ld (ix+006h),001h
	ld c,00ah
	call shovel_pat
	ld a,(ix+014h)
	and a
	jr z,cut_fall
	dec (ix+014h)
	ld de,000f0h
	call thrown_xy_d
	call shovel_land
	call nc,thrown_still
	ld a,(ix+014h)
	cp 008h
	jr nc,cut_dy
	call floor_dy
	jr nz,cut_land
cut_dy:
	ld a,(ix+014h)
	bit 0,(ix+01ah)
	ld hl,ix14_da_start
	jr z,cut_add
	ld hl,ix14_da_end
cut_add:
	call ADD_HL_A
	ld a,(hl)
	add a,(ix+003h)
	ld (ix+003h),a
	ret
cut_fall:
	ld (ix+014h),000h
	ld (ix+006h),001h
	call floor_dy
	jr nz,cut_land
	ld de,00500h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld (ix+00bh),001h
	ld (ix+001h),004h
	jp drop_sfx
cut_land:
	call thrown_still
	ld (ix+006h),000h
	ld (ix+014h),008h
	ld a,(ix+003h)
	add a,007h
	and 0f8h
	ld (ix+003h),a
	ld (ix+001h),001h
; sfx_14 if this screen
shovel_sfx:                     ; 0xB548  sfx_14 if this screen
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	jp z,sfx_14
	ret
; floor_ok with A=0 extra Y
floor_zero:                     ; 0xB552  floor_ok with A=0 extra Y
	xor a
	jr floor_y
; floor_ok with ix14_val extra Y
floor_dy:                       ; 0xB555  floor_ok with ix14_val extra Y
	call ix14_val
floor_y:
	call thrown_map
	add a,l
	add a,010h
	cp 0b8h
	jr c,floor_clamp
	ld a,0b8h
floor_clamp:
	ld l,a
	ld a,h
	add a,004h
	ld h,a
	call floor_ok
	ret nz
	ld a,h
	add a,008h
	ld h,a
; Z if cell is ladder with air above
floor_ok:                       ; 0xB571  Z if cell is ladder with air above
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	and a
	ret z
	dec a
	ret nz
	push hl
	push de
	ld a,l
	sub 008h
	ld l,a
	call map_tile_de
	pop de
	pop hl
	dec a
	jr nz,floor_nz
	xor a
	ret
floor_nz:
	or 0ffh
	ret
; ix+9/10 = 0
thrown_still:                   ; 0xB58F  ix+9/10 = 0
	ld de,00000h
	jp thrown_xy_d

; BLOCK 'ix14_da' (start 0xb595 end 0xb5a6)
ix14_da_start:
	defb 005h
	defb 005h
	defb 004h
	defb 003h
	defb 002h
	defb 002h
	defb 001h
	defb 001h
	defb 000h
	defb 000h
	defb 0ffh
	defb 0ffh
	defb 0feh
	defb 0feh
	defb 0fdh
	defb 0fch
	defb 0fbh
ix14_da_end:

; BLOCK 'ix14_db' (start 0xb5a6 end 0xb5b7)
ix14_db_start:
	defb 005h
	defb 004h
	defb 003h
	defb 002h
	defb 002h
	defb 001h
	defb 001h
	defb 001h
	defb 000h
	defb 000h
	defb 0ffh
	defb 0ffh
	defb 0ffh
	defb 0feh
	defb 0feh
	defb 0fdh
	defb 0fch
ix14_db_end:
shov_turn:                        ; 0xB5B7
	call thrown_edge
	dec a
	cp (ix+00bh)
	ld (ix+006h),000h
	ret z
	ld (ix+006h),001h
	ld c,00dh
	call dir_left
	call thrown_block
	jr c,turn_stop
	call thrown_step
	ret c
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
turn_stop:
	call thrown_snap
	ld de,00000h
	call thrown_dxy
	call thrown_xy_d
	ld (ix+006h),000h
	ld (ix+014h),008h
	ld (ix+018h),0ffh
	ld (ix+001h),001h
	ret
shov_end:                         ; 0xB5FB
	call floor_dy
	ret z
	ld de,00000h
	call thrown_dxy
	ld a,(ix+019h)
	ld (ix+00bh),a
	jp cut_land
; turn when X matches home / Vic
boom_home:                      ; 0xB60E  turn when X matches home / Vic
	set 1,(ix+00bh)
	ld a,(ix+018h)
	cp 0ffh
	jr z,home_vic
	cp (ix+005h)
	ret nz
	ld a,(ix+00bh)
	xor 001h
	or 002h
	ld (ix+00bh),a
	jp thrown_reset
home_vic:
	ld a,(0e284h)           ; Vic X
	sub (ix+005h)
	add a,002h
	cp 004h
	jr nc,home_side
	ld a,(0e203h)           ; puzzle board
	ld c,002h
	and 080h
	jr z,home_c
	inc c
home_c:
	ld (ix+00bh),c
	ret
home_side:
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
; NC if floor under shovel
shovel_land:                    ; 0xB64E  NC if floor under shovel
	ld c,(ix+00bh)
	call thrown_ahead
	ret c
	call ix14_val
	add a,l
	add a,00fh
	ld l,a
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	bit 0,(ix+00bh)
	jr z,land_tile
	ld a,010h
	add a,h
	ld h,a
	ret c
land_tile:
	call map_tile_de
	sub 002h
	ret
; A = ix14_da[ix+14]
ix14_val:                       ; 0xB673  A = ix14_da[ix+14]
	ld a,(ix+014h)
	ld de,ix14_da_start
	call ADD_DE_A
	ld a,(de)
	ret
spawn_pick:                       ; 0xB67E  pick E500 init
	xor a
	ld (ix+014h),a
	ld (ix+01ch),a
	ld (ix+013h),a
	ld hl,sfx_1d
	jp thrown_sfx
tick_thrown_pick:                 ; 0xB68E  E500; floor 2 deep
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_b691_jp' (start 0xb694 end 0xb6a0)
d_b691_jp_start:
	defw pick_spin                ; pick: floor hole 2 deep
	defw pick_drop
	defw pick_cut
	defw pick_push
	defw pick_stash
	defw pick_tick
d_b691_jp_end:
pick_spin:                        ; 0xB6A0
	ld hl,pick_pat
	ld de,pick_pat2
	call pick_frame
	jr z,pick_ready
	ld (ix+011h),a
	ret
; BLOCK 'pick_pat' (start 0xb6af end 0xb6b6)
pick_pat:
	defb 01bh, 01bh, 01ch, 01ch, 01dh, 01dh, 0ffh
; BLOCK 'pick_pat2' (start 0xb6b6 end 0xb6bd)
pick_pat2:
	defb 018h, 019h, 018h, 019h, 018h, 019h, 0ffh
pick_ready:
	ld (ix+013h),003h
	ld (ix+014h),03ch
	ld a,(0f0f4h)
	and a
	jr z,pick_next
	ld (ix+01eh),007h
	ld (ix+01fh),049h
spin_mark:
	call map_mark
	call map_hit
	jp c,pick_abort
pick_next:
	inc (ix+001h)
	ret
; A = table[ix+14>>3]; FF = end
pick_frame:                     ; 0xB6E0  A = table[ix+14>>3]; FF = end
	ld a,(0f0f4h)
	and a
	jr z,frame_msx1
	ex de,hl
frame_msx1:
	inc (ix+014h)
	ld a,(ix+014h)
	rra
	rra
	rra
	and 01fh
	call ADD_HL_A
	ld a,(hl)
	cp 0ffh
	ret
pick_drop:                        ; 0xB6F9
	ld c,001h
	call thrown_probe
	jr nc,pick_stash_go
	call map_restore
	jp pick_fall
pick_stash_go:
	call map_stash
	dec (ix+014h)
	jr z,pick_pat_c
	ld (ix+013h),003h
	ld a,(ix+014h)
	and 010h
	ld c,00fh
	jr z,pick_hold
	ld c,010h
pick_hold:
	ld (ix+011h),c
	ret
pick_pat_c:
	call map_restore
	ld a,003h
	call thrown_hold
	jp c,thrown_stop
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	call thrown_step
	jr c,pick_fly
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	call thrown_step
	jp nc,thrown_stop
pick_fly:
	ld de,00200h
	call thrown_xy_d
	ld (ix+006h),001h
	jr pick_next
pick_cut:                         ; 0xB754
	call thrown_edge
	dec a
	cp (ix+00bh)
	jp z,thrown_nudge
	dec (ix+014h)
	call pick_anim
	ld a,(ix+005h)
	and 007h
	cp 003h
	jr nc,cut_step
	call thrown_map
	ld c,001h
	call probe_step_de
	jp c,pick_fall
cut_step:
	call thrown_step
	jr nc,clash_snap
	call pick_clash
	ret nc
	ld a,(ix+00bh)
	cp 002h
	ld a,(ix+005h)
	jr nz,cut_align
	add a,007h
cut_align:
	and 0f8h
	ld (ix+005h),a
	ld a,(iy+006h)
	and a
	jr z,clash_iy_x
	ld a,(iy+00bh)
	cp 002h
	jr c,clash_iy_x
	ld a,(iy+005h)
	jr nz,clash_x
	add a,007h
clash_x:
	and 0f8h
	ld (iy+005h),a
clash_iy_x:
	call pick_mark
	jp cut_sfx
clash_snap:
	call thrown_snap
	ld c,001h
	call probe_step_de
	jp c,pick_fall
	call pick_mark
cut_sfx:
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
	jp sfx_24
pick_land:                      ; 0xB7C9  zero vel, hold 60, state 1
	ld (ix+006h),000h
	ld de,00000h
	call thrown_xy_d
	call thrown_dxy
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
; CY if another pick overlaps
pick_clash:                     ; 0xB7DF  CY if another pick overlaps
	ld l,(ix+003h)
	ld h,(ix+005h)
	call thrown_ahead
	ccf
	ret nc
	ld iy,0e500h            ; thrown tools
	ld b,008h
	ld de,00020h
pick_loop:
	ld a,(iy+000h)
	cp 004h
	jr nz,pick_skip
	ld a,(ix+015h)
	cp (iy+015h)
	jr z,pick_skip
	ld a,(ix+010h)
	cp (iy+010h)
	jr nz,pick_skip
	ld a,l
	sub (iy+003h)
	add a,00fh
	cp 01eh
	jr nc,pick_skip
	ld a,h
	sub (iy+005h)
	add a,00fh
	cp 01eh
	jr c,clash_dir
pick_skip:
	add iy,de
	djnz pick_loop
	xor a
	ret
clash_dir:
	ld a,(iy+006h)
	and a
	jr z,clash_yes
	ld a,(ix+00bh)
	cp (iy+00bh)
	ret z
clash_yes:
	scf
	ret
; snap X or Y to 8px from ix+11
thrown_snap:                    ; 0xB833  snap X or Y to 8px from ix+11
	ld a,(ix+00bh)
	cp 002h
	jr c,snap_y
	ld a,(ix+005h)
	jr z,snap_x
	add a,007h
snap_x:
	and 0f8h
	ld (ix+005h),a
	ret
snap_y:
	and a
	ld b,a
	ld a,(ix+003h)
	jr z,snap_y7
	add a,007h
snap_y7:
	and 0f8h
	ld (ix+003h),a
	ret
pick_fall:
	call thrown_reset
	ld (ix+00bh),001h
	ld de,00500h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld (ix+01ch),000h
	ld (ix+001h),003h
	jp drop_sfx
; ix+11 = 0x11 + (ix+14>>2)&3
pick_anim:                      ; 0xB874  ix+11 = 0x11 + (ix+14>>2)&3
	ld a,(ix+014h)
	rra
	rra
	and 003h
	add a,011h
	ld (ix+011h),a
	ret
pick_push:                        ; 0xB881
	inc (ix+01ch)
	jr nz,push_go
	dec (ix+01ch)
push_go:
	ld (ix+006h),001h
	call pick_anim
	call thrown_step
	jr nc,push_stop
	call pick_clash
	ret nc
	call thrown_snap
	call pick_mark
	ld a,(ix+01ch)
	cp 003h
	ret c
	jp cut_sfx
push_stop:
	call thrown_snap
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+014h),000h
	ld (ix+001h),005h
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
	jp sfx_25
; clash_clear lands here when the thrown tool is a pick
pick_park:                      ; 0xB8C5  align / stash after clash
	ld (ix+013h),001h
	ld a,(ix+001h)
	dec a
	jr z,pick_align
	dec a
	ret nz
	call thrown_align
	jr pick_mark
pick_align:
	call thrown_align
	jr pick_wait
; snap both X and Y to 8px
thrown_align:                   ; 0xB8DB  snap both X and Y to 8px
	ld a,(ix+005h)
	and 0f8h
	ld (ix+005h),a
	ld a,(ix+003h)
	and 0f8h
	ld (ix+003h),a
	ret
pick_stash:                       ; 0xB8EC
	call map_stash
	ld c,001h
	call thrown_probe
	jr c,stash_hit
	ld a,(0e203h)           ; puzzle board
	and 003h
	dec (ix+014h)
	ret nz
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
stash_hit:
	call map_restore
	jp pick_fall
pick_tick:                        ; 0xB90E
	ld a,(ix+014h)
	cp 012h
	jr z,pick_mark
	inc (ix+014h)
	ld hl,ix14_dc_start
	call ADD_HL_A
	ld a,(hl)
	add a,(ix+003h)
	ld (ix+003h),a
	ret

; BLOCK 'ix14_dc' (start 0xb926 end 0xb938)
ix14_dc_start:
	defb 0fdh
	defb 0feh
	defb 0ffh
	defb 0ffh
	defb 000h
	defb 000h
	defb 001h
	defb 001h
	defb 002h
	defb 003h
	defb 0feh
	defb 0ffh
	defb 000h
	defb 001h
	defb 002h
	defb 0ffh
	defb 000h
	defb 001h
ix14_dc_end:
; OR this pick's 2x2 into the packed map (callers used ix14_dc_end)
pick_mark:                      ; 0xB938
	call map_mark
	call map_hit
	jp c,pick_abort
pick_wait:
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+013h),001h
	ld (ix+014h),0b4h
	ld (ix+001h),004h
	ret
; OR 2x2 bits into ix+18..1B
map_stash:                      ; 0xB956  OR 2x2 bits into ix+18..1B
	call thrown_map
	call map_index
	call map_or
	ld a,e
	and a
	jr z,stash_e
	jp pe,stash_e2
stash_e:
	ld (ix+018h),e
stash_e2:
	ld a,d
	and a
	jr z,stash_d
	jp pe,stash_d2
stash_d:
	ld (ix+019h),d
stash_d2:
	call thrown_map
	ld a,h
	add a,008h
	ld h,a
	call map_index
	call map_or
	ld a,e
	and a
	jr z,stash_e3
	jp pe,stash_d3
stash_e3:
	ld (ix+01ah),e
stash_d3:
	ld a,d
	jr z,stash_d4
	ret pe
stash_d4:
	ld (ix+01bh),d
	ret
; map_mark if pick state 1/4
map_if_pick:                    ; 0xB992  map_mark if pick state 1/4
	ld a,(ix+001h)
	cp 004h
	jr z,mark_scr
	dec a
	ret nz
mark_scr:
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
; OR current 2x2 into packed map
map_mark:                       ; 0xB9A2  OR current 2x2 into packed map
	call thrown_map
	call map_index
	call map_or
	ld (ix+018h),e
	ld (ix+019h),d
	call thrown_map
	ld a,h
	add a,008h
	ld h,a
	call map_index
	call map_or
	ld (ix+01ah),e
	ld (ix+01bh),d
	ret
; OR bitmask into two map bytes
map_or:                         ; 0xB9C5  OR bitmask into two map bytes
	ld b,c
	ld a,003h
or_shift:
	rrca
	rrca
	djnz or_shift
	ld b,a
	ld e,(hl)
	or (hl)
	ld (hl),a
	ld a,e
	and b
	ld e,a
	ld a,008h
	call ADD_HL_A
	ld a,b
	ld d,(hl)
	or (hl)
	ld (hl),a
	ld a,d
	and b
	ld d,a
	ret
; map_restore if pick state 1/4
map_if_pick2:                   ; 0xB9E0  map_restore if pick state 1/4
	ld a,(ix+001h)
	cp 004h
	jr z,rest_scr
	dec a
	ret nz
rest_scr:
	ld a,(0e243h)           ; screen
	cp (ix+010h)
	ret nz
; put stashed 2x2 back into map
map_restore:                    ; 0xB9F0  put stashed 2x2 back into map
	call thrown_map
	ld a,h
	add a,008h
	ld h,a
	call map_index
	ld e,(ix+01ah)
	ld d,(ix+01bh)
	call map_put
	call thrown_map
	call map_index
	ld e,(ix+018h)
	ld d,(ix+019h)
; AND/OR two map bytes from DE
map_put:                        ; 0xBA0F  AND/OR two map bytes from DE
	ld a,0fch
	ld b,c
put_shift:
	rrca
	rrca
	djnz put_shift
	ld b,a
	and (hl)
	or e
	ld (hl),a
	ld a,008h
	call ADD_HL_A
	ld a,b
	and (hl)
	or d
	ld (hl),a
	ret
; pixel HL + base DE -> packed HL
map_index:                      ; 0xBA24  pixel HL + base DE -> packed HL
	ld a,h
	rra
	rra
	rra
	ld b,a
	and 003h
	ld c,a
	inc c
	ld a,b
	rra
	rra
	and 007h
	ld b,a
	ld a,l
	and 0f8h
	or b
	ld l,a
	ld h,000h
	add hl,de
	ret
; restore packed-map bits for every live pick (load_stage)
picks_restore:                  ; 0xBA3C  map_if_pick2 over E500
	ld ix,0e500h            ; thrown tools
	ld b,008h
rest_loop:
	push bc
	ld a,(ix+000h)
	cp 004h
	call z,map_if_pick2
	ld de,00020h
	add ix,de
	pop bc
	djnz rest_loop
	ret
; mark packed-map bits for every live pick (load_stage tail)
picks_mark:                     ; 0xBA54  map_if_pick over E500
	ld ix,0e500h            ; thrown tools
	ld b,008h
mark_loop:
	push bc
	ld a,(ix+000h)
	cp 004h
	jr nz,mark_next
	call map_if_pick
mark_next:
	ld de,00020h
	add ix,de
	pop bc
	djnz mark_loop
	ret
; CY if stashed 2x2 has bit 0xAA
map_hit:                        ; 0xBA6E  CY if stashed 2x2 has bit 0xAA
	ld a,(ix+018h)
	or (ix+019h)
	or (ix+01ah)
	or (ix+01bh)
	and 0aah
	ret z
	scf
	ret
; stash collided with a wall bit; put map back and despawn
pick_abort:                     ; 0xBA7F
	call map_restore
	jp thrown_stop
tick_coffin:                      ; 0xBA85  E600 type 1: Vic push opens lid (states 6/7); no walk
	ld a,(ix+001h)
	cp 001h
	jp z,coffin_open_tick                   ; opening
	jp nc,coffin_close                  ; closing
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld a,(0e280h)           ; Vic state
	and a
	jr nz,coffin_wait
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld b,a
	ld a,(0e282h)           ; Vic Y
	add a,00fh
	sub (ix+002h)
	sub b
	jr nc,coffin_wait
	ld a,(ix+007h)
	rra
	rra
	ld a,(0e284h)           ; Vic X
	ld b,(ix+003h)
	jr c,coffin_left
	cp b
	jr nc,coffin_wait
	add a,014h
	sub b
	jr c,coffin_wait
	ld a,(0e208h)           ; keys held
	and 008h
	jr z,coffin_wait
	dec (ix+006h)
	ret nz
	inc (ix+005h)
	ld a,007h
	ld (0e280h),a           ; Vic state
	call sfx_21                   ; coffin
; Vic grab: E299=0, lid bit, next state
coffin_open:                    ; 0xBADA  Vic grab: E299=0, lid bit, next state
	xor a
	ld (0e299h),a
	set 0,(ix+007h)
	inc (ix+001h)
; reset lid timer (open/close ticks call this)
coffin_wait:                    ; 0xBAE5  ix+6 = 10
	ld (ix+006h),00ah
	ret
coffin_left:
	cp b
	jr c,coffin_wait
	sub 014h
	sub b
	jr nc,coffin_wait
	ld a,(0e208h)           ; keys held
	and 004h
	jr z,coffin_wait
	dec (ix+006h)
	ret nz
	dec (ix+005h)
	ld a,006h
	ld (0e280h),a           ; Vic state
	call coffin_open
	inc (ix+001h)
	jp sfx_21
coffin_open_tick:
	dec (ix+006h)
	ret nz
	call coffin_wait
	set 0,(ix+007h)
	inc (ix+005h)
	ld a,(ix+005h)
	cp 003h
	ret nz
	ld (ix+001h),000h
	set 1,(ix+007h)
	ret
coffin_close:
	dec (ix+006h)
	ret nz
	call coffin_wait
	set 0,(ix+007h)
	dec (ix+005h)
	ret nz
	xor a
	ld (ix+001h),a
	res 1,(ix+007h)
	ret
draw_coffin:                      ; 0xBB43  stamp via coffin_stamp (coffin_pat)
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld hl,coffin_pat
	ld de,coffin_pat
	ld bc,coffin_pat
; 2-wide stamp: first stamp_wtiles then actor_rows
coffin_stamp:                   ; 0xBB53  coffin / pyoncy body
	exx
	ld b,(ix+008h)
	ld c,002h
	ld d,(ix+003h)
	ld e,(ix+002h)
	call stamp_wtiles
	exx
actor_rows:                     ; 0xBB63  EFC0/2/4 row ptrs (editor skips first stamp)
	ld (0efc0h),hl          ; stamp row
	ld (0efc2h),de          ; stamp row
	ld (0efc4h),bc          ; stamp row
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld hl,(0efc0h)          ; stamp row
	call actor_row
	ld a,(ix+008h)
	cp 003h
	jr c,actor_last
	ld b,a
	dec b
	dec b
actor_mid:
	ld hl,(0efc2h)          ; stamp row
	push hl
	push bc
	call actor_row
	pop bc
	pop hl
	djnz actor_mid
actor_last:
	ld hl,(0efc4h)          ; stamp row
; 2-tile stamp row (coffin/pyoncy)
actor_row:                      ; 0xBB93  2-tile stamp row (coffin/pyoncy)
	push de
	ld a,(ix+005h)
	add a,a
	call ADD_HL_A
	ld a,(hl)
	push hl
	call tile_pset
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	ld a,(hl)
	call tile_pset
	pop de
	ld a,e
	add a,008h
	ld e,a
	ret
tick_pyoncy:                      ; 0xBBB0  E600 type 2: grab like coffin, then 4 frames
	ld a,(ix+001h)
	and a
	jr nz,pyoncy_anim                  ; ix+1: 0 idle, else anim
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld a,(0e280h)           ; Vic state
	and a
	jr nz,pyoncy_wait                  ; Vic must be walking
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld b,a                        ; height in pixels
	ld a,(0e282h)           ; Vic Y
	add a,00fh
	sub (ix+002h)
	sub b
	jr nc,pyoncy_wait
	ld a,(ix+007h)
	rra
	rra                           ; bit 1 = facing
	ld a,(0e284h)           ; Vic X
	ld b,(ix+003h)
	jr c,pyoncy_left                   ; face right: Vic from the left
	cp b
	jr nc,pyoncy_wait
	add a,014h
	sub b
	jr c,pyoncy_wait
	ld a,(0e208h)           ; keys held
	and 008h                      ; Vic holding right
	jr z,pyoncy_wait
	dec (ix+006h)
	ret nz
	ld a,007h
	ld (0e280h),a                 ; coffin-pull right
pyoncy_grab:
	xor a
	ld (0e299h),a
	set 0,(ix+007h)
	inc (ix+005h)
	inc (ix+001h)
	ld (ix+006h),008h
	call sfx_22                   ; pyoncy
	ret
pyoncy_wait:
	ld (ix+006h),01eh
	ret
pyoncy_left:
	cp b
	jr c,pyoncy_wait
	sub 014h
	sub b
	jr nc,pyoncy_wait
	ld a,(0e208h)           ; keys held
	and 004h                      ; Vic holding left
	jr z,pyoncy_wait
	dec (ix+006h)
	ret nz
	ld a,006h
	ld (0e280h),a                 ; coffin-pull left
	jr pyoncy_grab
pyoncy_anim:
	dec (ix+006h)
	ret nz
	set 0,(ix+007h)
	inc (ix+005h)                 ; frames 0..3, then idle
	ld a,(ix+005h)
	ld (ix+006h),008h
	cp 004h
	ret nz
	call sfx_22                   ; pyoncy
	xor a
	ld (ix+005h),a
	ld (ix+001h),a
	jr pyoncy_wait
draw_pyoncy:                      ; 0xBC50  same stamp path as coffin; facing picks pyoncy_l / pyoncy_r
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld a,(ix+007h)
	rra
	rra
	ld hl,pyoncy_l0
	ld de,pyoncy_l1
	ld bc,pyoncy_l2
	jp nc,coffin_stamp
	ld hl,pyoncy_r0
	ld de,pyoncy_r1
	ld bc,pyoncy_r2
	jp coffin_stamp
start_rockroll:                   ; 0xBC74  post-pass: idle type 3 + Vic overlap -> fall
	ld ix,0e600h            ; actors
	ld b,010h
rock_loop:
	ld a,(ix+000h)
	cp 003h
	jr z,rock_try
rock_next:
	ld de,00010h
	add ix,de
	djnz rock_loop
	ret
rock_try:
	ld a,(ix+001h)
	and a
	jr nz,rock_next                  ; already falling
	call rock_under
	jr nc,rock_next
	inc (ix+001h)
	ld (ix+006h),01eh
	ret
; CY if Vic is under the column (same screen)
rock_under:                     ; 0xBC9C  CY if Vic is under the column (same screen)
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	jr nz,rock_off
	ld a,(0e284h)           ; Vic X
	add a,008h
	sub (ix+003h)
	cp 008h
	ret nc
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld c,a                        ; height in pixels
	ld a,(0e282h)           ; Vic Y
	sub (ix+002h)
	cp c
	ret
rock_off:
	or a
	ret
tick_rockroll:                    ; 0xBCC0  grow ix+5 to height ix+8, then clear type
	ld a,(ix+001h)
	and a
	ret z
	dec (ix+006h)
	ret nz
	set 0,(ix+007h)
	ld (ix+006h),01eh
	ld a,(ix+005h)
	cp (ix+008h)
	jr nc,rock_done
	inc (ix+005h)
	ret
rock_done:
	ld (ix+000h),000h             ; gone; draw punches the fallen tiles
	ret
draw_rockroll:                    ; 0xBCE2  fallen column: map bit + tile 5 + sfx_31
	ld a,(ix+005h)
	dec a
	add a,a
	add a,a
	add a,a
	ld e,a
	ld h,(ix+003h)
	add a,(ix+002h)
	ld l,a
	ld d,(ix+004h)
	ld bc,00101h
	ld a,002h
	push de
	call stamp_rect
	pop de
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld d,(ix+003h)
	ld a,(ix+002h)
	add a,e
	ld e,a
	push ix
	push de
	call tools_scan
	pop de
	ld a,005h
	call tile_pset
	call draw_maptools
	pop ix
	jp sfx_31
tick_trap:                        ; 0xBD21  E600 type 4: Vic in column -> punch 1x4
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
	ld a,(ix+00ah)
	ld (ix+00bh),a
	ld a,(0e282h)           ; Vic Y
	add a,014h
	sub (ix+002h)
	cp 008h
	jr nc,trap_idle
	ld a,(0e284h)           ; Vic X
	add a,008h
	sub (ix+003h)
	cp 020h
	jr c,trap_arm
trap_idle:
	ld (ix+00ah),000h
	ld a,(ix+00bh)
	and a
	ret z
	ld a,(0e280h)           ; Vic state
	and a
	ret nz
	inc (ix+006h)
	ld a,(ix+006h)
	cp 002h
	ret c
	ld (ix+000h),000h
	call trap_punch
	xor a
; stamp_rect 1x4 at trap XY
trap_erase:                     ; 0xBD65  stamp_rect 1x4 at trap XY
	ld bc,00104h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld d,(ix+004h)
	call stamp_rect
	ret
trap_arm:
	ld (ix+00ah),001h
	ret
; sfx_27 + punch tiles / HMMM
trap_punch:                     ; 0xBD7A  sfx_27 + punch tiles / HMMM
	call sfx_27                   ; trap
	ld d,(ix+003h)
	ld e,(ix+002h)
	push ix
	pop hl
	ld a,(0f0f4h)
	and a
	jr nz,punch_msx2
	ld a,00ch
	call ADD_HL_A
	ld bc,00104h
	call draw_tilemap
	ret
punch_msx2:
	ld a,l
	add a,a
	ld h,a
	ld l,040h
	jr nc,punch_page
	ld l,050h
punch_page:
	ld bc,02008h
	ld a,001h
	call vdp_hmmm
	ret
draw_trap:                        ; 0xBDAA  type 4: 4 × tile 0x61
	xor a
	ld (ix+00ah),a
	ld (ix+00bh),a
	call trap_save
	ld a,003h
	call trap_erase
	ld a,(0e243h)           ; screen
	cp (ix+004h)
	ret nz
stamp_trap:                       ; 0xBDC0  4× tile 0x61 (editor + draw_trap tail)
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld b,004h
trap_loop:
	push de
	ld a,(0f0f4h)
	and a
	ld a,061h
	jr z,trap_msx1
	ld a,0adh
trap_msx1:
	call tile_pset
	pop de
	ld a,d
	add a,008h
	ld d,a
	djnz trap_loop
	ret
; stash trap tiles before punch
trap_save:                      ; 0xBDDE  stash trap tiles before punch
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld a,(0f0f4h)
	and a
	jr nz,save_msx2
	call scr5_addr
	push ix
	pop de
	ld a,00ch
	call ADD_DE_A
	ld b,004h
save_loop:
	call NRDVRM
	ld (de),a
	inc hl
	inc de
	djnz save_loop
	ret
save_msx2:
	push ix
	pop de
	ld a,e
	add a,a
	ld d,a
	ld e,040h
	jr nc,trap_save_pg
	ld e,050h
trap_save_pg:
	ld bc,02008h
	ld a,004h
	call vdp_hmmm
	ret
; jump/land on obj2 (0xE7C0) to reveal
secret_hit:                       ; 0xBE15  jump/land on obj2 (0xE7C0) to reveal
	ld hl,0e7c0h            ; secrets
	ld b,010h
secret_loop:
	ld a,(0e243h)           ; screen
	cp (hl)
	push bc
	push hl
	call z,secret_reveal
	pop hl
	ld a,004h
	call ADD_HL_A
	pop bc
	djnz secret_loop
	ret
; E2A7 (air/land strobe) + bit5 armed
secret_reveal:                    ; 0xBE2D  E2A7 (air/land strobe) + bit5 armed
	inc l
	ld e,(hl)
	inc l
	ld d,(hl)
	inc l
	ld a,(hl)
	and 01fh
	add a,a
	add a,a
	add a,a
	add a,018h
	ld b,a
	ld a,e
	sub 014h
	ld c,a
	ld a,(0e282h)           ; Vic Y
	sub c
	cp b
	ret nc
	ld a,(0e284h)           ; Vic X
	sub d
	cp 010h
	ret nc
	ld a,(0e2a7h)           ; jump strobe
	and a
	jr z,secret_arm
	xor a
	ld (0e2a7h),a           ; jump strobe
	ld a,(hl)
	and 020h                      ; armed by vic_climb (E280==2)
	ret z
	res 5,(hl)                    ; reveal
	ld a,(hl)
	and 0c0h
	rlca
	rlca
	dec a
	jr z,secret_punch                   ; punch tiles / spawn door
	rrca
	rrca
	ld c,a
	ld a,(hl)
	and 03fh
	or c
	ld (hl),a
	ret
secret_arm:
	ld a,(0e280h)           ; Vic state
	cp 002h                       ; vic_climb arms bit 5
	ret nz
	set 5,(hl)
	ret
secret_punch:
	push hl
	push de
	push bc
	call stones_undraw
	call tools_scan
	pop bc
	pop de
	pop hl
	push hl
	push de
	ld a,005h
	call tile_pair
	ld a,(hl)
	and 01fh
	dec a
	ld (0eff0h),a           ; secret punch
	ld b,a
	push bc
	call nz,stamp_w2
	pop bc
	pop de
	pop hl
	dec hl
	dec hl
	dec hl
	ld (hl),000h
	ex de,hl
	ld a,(0e243h)           ; screen
	ld d,a
	ld c,002h
	push hl
	push de
	push bc
	ld a,002h
	ld b,001h
	call stamp_rect
	pop bc
	pop de
	pop hl
	ld a,l
	add a,008h
	ld l,a
	ld a,(0eff0h)           ; secret punch
	and a
	ld a,000h
	call nz,stamp_rect
	call stones_redraw
	call draw_maptools
	ld hl,0e282h            ; Vic Y
	ld a,(hl)
	add a,003h
	and 0f8h
	ld (hl),a
	jp sfx_40
; two tile_pset, 8px apart in X then Y
tile_pair:                      ; 0xBED0  two tile_pset, 8px apart in X then Y
	push hl
	push de
	push af
	call tile_pset
	ld a,d
	add a,008h
	ld d,a
	pop af
	call tile_pset
	pop de
	pop hl
	ld a,e
	add a,008h
	ld e,a
	ret

; BLOCK 'pad_ff' (start 0xbee5 end 0xc000)
pad_ff_start:
	ds 283, 0ffh
pad_ff_end:
