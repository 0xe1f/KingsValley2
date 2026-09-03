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
	ld de,0e800h
	ld hl,e800_copy_start
	ld bc,00020h
	ldir
	ld hl,0d200h
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
	ld a,(0edc0h)
	call DISPATCH_A

; BLOCK 'edc0_jp' (start 0x605f end 0x6067)
edc0_jp_start:
	defw pause_map_wait
	defw pause_map_draw
	defw pause_map_done
	defw pause_map_idle
edc0_jp_end:
pause_map_wait:                   ; 0x6067  E20C bit 1 -> HUD tiles
	ld a,(0e20ch)
	rra
	rra
	ret nc                        ; bit 1 (F2): open map
	call scr_reset
	call hud_load
pause_next:                       ; 0x6073
	ld hl,0edc0h
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
	ld a,(0e20ch)
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
	ld (0edc0h),a
	jp sat_flip
; Door-link arrows on the pause map (ED80 up / ED90 down / EDA0 left / EDB0 right).
map_doors:                        ; 0x60E1
	call map_doors_up
	call map_doors_down
	call map_doors_left
	jp map_doors_right
map_doors_up:                     ; 0x60ED  ED80 up
	ld de,0ed80h
	ld b,008h
l60f2h:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_up
	inc de
	inc de
	djnz l60f2h
	ret
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
l610ch:
	add a,e
	djnz l610ch
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,008h
	ld d,020h
l6119h:
	add a,d
	djnz l6119h
	ld d,a
	ld hl,map_glyph_up
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
map_doors_down:                    ; 0x6128  ED90 down
	ld de,0ed90h
	ld b,008h
l612dh:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_down
	inc de
	inc de
	djnz l612dh
	ret
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
l6147h:
	add a,e
	djnz l6147h
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,008h
	ld d,020h
l6154h:
	add a,d
	djnz l6154h
	ld d,a
	ld hl,map_glyph_down
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
map_doors_left:                    ; 0x6163  EDA0 left
	ld de,0eda0h
	ld b,008h
l6168h:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_left
	inc de
	inc de
	djnz l6168h
	ret
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
l6182h:
	add a,e
	djnz l6182h
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,0f8h
	ld d,020h
l618fh:
	add a,d
	djnz l618fh
	ld d,a
	ld hl,map_glyph_left
	ld c,0ffh
	call print_at
	pop de
	pop bc
	ret
map_doors_right:                   ; 0x619E  EDB0 right
	ld de,0edb0h
	ld b,008h
l61a3h:
	ld a,(de)
	inc a
	ret z
	dec a
	call map_arrow_right
	inc de
	inc de
	djnz l61a3h
	ret
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
l61bdh:
	add a,e
	djnz l61bdh
	ld e,a
	ld a,c
	and 007h
	ld b,a
	inc b
	ld a,020h
	ld d,020h
l61cah:
	add a,d
	djnz l61cah
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
	ld a,(0e243h)
	ld hl,0e788h
	ld c,007h
l61ebh:
	ld b,008h
l61edh:
	cp (hl)
	jr z,l61f7h
	inc hl
	djnz l61edh
	dec c
	jr nz,l61ebh
	ret
l61f7h:
	ld hl,0e282h
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
	ld hl,0e788h
	ld c,007h
l6237h:
	ld b,008h
l6239h:
	cp (hl)
	jr z,l6243h
	inc hl
	djnz l6239h
	dec c
	jr nz,l6237h
	ret
l6243h:
	ld hl,0e2f1h
	call map_xy
	call map_origin
	ld hl,0e800h
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (hl),000h
	ld de,0d201h
	ld hl,0d200h
	ld bc,0000fh
	ld (hl),00bh
	ldir
	ret
; Soul stones on the pause map (E700).
map_gems:                         ; 0x6263
	ld hl,0e700h
	ld b,010h
l6268h:
	ld a,(hl)
	or a
	call nz,map_gem
	ld de,00008h
	add hl,de
	djnz l6268h
	ret
map_gem:                          ; 0x6274
	push hl
	push bc
	call map_gem_put
	pop bc
	pop hl
	ret
map_gem_put:                      ; 0x627C  skip if screen not in E788
	inc hl
	ld a,(hl)
	inc hl
	ld (0efc0h),hl
	ld hl,0e788h
	ld c,007h
l6287h:
	ld b,008h
l6289h:
	cp (hl)
	jr z,l6294h
	inc hl
	djnz l6289h
	dec c
	jr nz,l6287h
	pop hl
	ret
l6294h:
	ld hl,(0efc0h)
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
	ld hl,0e788h
	ld c,007h
l62ddh:
	ld b,008h
l62dfh:
	ld a,(hl)
	or a
	call nz,map_screen
	inc hl
	djnz l62dfh
	dec c
	jr nz,l62ddh
	ret
map_screen:                       ; 0x62EB
	push af
	push bc
	push hl
	call map_screen_put
	pop hl
	pop bc
	pop af
	ret
map_screen_put:                   ; 0x62F5
	call map_cell
	call map_origin
	ld hl,scr_stamp
	jp stamp_at
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
	ld a,(0e242h)
	ld hl,0aae0h
	call tbl_word
	ld ix,0e600h
l6343h:
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
	jr z,l6378h
	set 1,(ix+007h)               ; lo3 != 0: facing / lid side (not Flouman)
	jr l637ch
l6378h:
	res 1,(ix+007h)
l637ch:
	ld b,a
	add a,a
	add a,b
	ld b,a
	ld a,(ix+000h)                ; 1=coffin (Slouman/Flouman), 2=Pyoncy, 3=Rock Roll, 4=trap, 5=stone
	cp 001h
	jr z,l6389h
	ld b,000h
l6389h:
	ld (ix+005h),b                ; type 1 only: lid frame = (byte3 & 7) * 3
	ld (ix+006h),000h
	inc hl
	ld de,00010h
	add ix,de
	jr l6343h
stamp_actors_c3:                  ; 0x6398  C=3
	ld c,003h
	jr l639eh
stamp_actors:                     ; 0x639C  stamp E600 onto the map (C=0)
	ld c,000h
l639eh:
	ld b,010h
	ld ix,0e600h
l63a4h:
	push bc
	ld a,(ix+000h)
	and a
	call nz,stamp_actor
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l63a4h
	ret
stamp_actor:                      ; 0x63B5  skip Rock Roll; stone via 95f8h if C=0
	cp 003h
	ret z
	cp 005h
	jr nz,l63c6h
	ld a,c
	and a
	jp z,095f8h
	ld a,(ix+001h)
	and a
	ret nz
l63c6h:
	ld h,(ix+003h)
	ld l,(ix+002h)
	cp 002h
	jr nz,l63dah
	bit 1,(ix+007h)
	jr z,l63dah
	ld a,h
	add a,008h
	ld h,a
l63dah:
	ld a,(ix+000h)
	ld de,l6444h
	call ADD_DE_A
	ld a,(de)
	ld d,a
	ld a,c
	ld b,(ix+008h)
	ld c,d
	ld d,(ix+004h)
stamp_rect:                       ; 0x63ED  2-bit rect at HL, size B×C, screen D
	ld (0efc0h),a
	ld a,d
	ld (0efc1h),a
	call scr5_addr
	ld de,03800h
	or a
	sbc hl,de
l63fdh:
	push hl
	push bc
	ld b,c
l6400h:
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
	ld a,(0efc0h)
	and a
	jr z,l642ah
	call map_mask
	or (hl)
	ld (hl),a
l642ah:
	pop bc
	pop hl
	inc hl
	djnz l6400h
	pop bc
	pop hl
	ld a,020h
	call ADD_HL_A
	djnz l63fdh
	ret
map_mask:                         ; 0x6439  2-bit mask for X in C; rotates A
	push af
	ld a,c
	and 003h
	inc a
	ld b,a
	pop af
l6440h:
	rrca
	rrca
	djnz l6440h
l6444h:
	ret
actor_hgt:                        ; 0x6445  tile height by ix+0 type (index from l6444h)
	defb 002h                     ; 1 Slouman / Flouman
	defb 001h                     ; 2 Pyoncy
	defb 001h                     ; 3 Rock Roll
	defb 004h                     ; 4 trap (1×4 column, tile 0x61)
	defb 002h                     ; 5 stone (2×2, bifi pushable)
draw_actors:                      ; 0x644A  on-screen E600 via draw_actor / actor_draw
	ld ix,0e600h
	ld b,010h
l6450h:
	push bc
	ld a,(ix+000h)
	and a
	call nz,draw_actor
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l6450h
	ret
draw_stones:                      ; 0x6461  type 5 on current screen
	ld ix,0e600h
	ld b,010h
l6467h:
	push bc
	ld a,(ix+000h)
	cp 005h
	jr nz,l647ah
	ld a,(0e243h)
	cp (ix+004h)
	jr nz,l647ah
	call 09661h
l647ah:
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l6467h
	ret
; Per-frame E600: d_64a1, dirty redraw, start_rockroll.
tick_actors:                      ; 0x6483
	ld ix,0e600h
	ld b,010h
l6489h:
	push bc
	call tick_actor
	call actor_dirty
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l6489h
	jp start_rockroll
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
actor_dirty:                      ; 0x64AE  ix+7 bit 0 -> redraw table
	ld a,(ix+007h)
	rra
	ret nc
	res 0,(ix+007h)
	ld hl,actor_redraw
	jr l64c6h
draw_actor:                       ; 0x64BC  on-screen draw table
	ld hl,actor_draw
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
l64c6h:
	ld a,(ix+000h)
	and a
	ret z
	dec a
	jp dispatch_hl
actor_redraw:                     ; 0x64CF  dirty redraw (ix+7 bit 0)
	defw draw_coffin              ; 1 coffin
	defw draw_pyoncy              ; 2 Pyoncy
	defw draw_rockroll            ; 3 Rock Roll (falling tiles)
	defw 06460h                   ; 4 trap (ret)
	defw draw_stone               ; 5 stone
actor_draw:                       ; 0x64D9  on-screen draw
	defw draw_coffin              ; 1 coffin
	defw draw_pyoncy              ; 2 Pyoncy
	defw 06460h                   ; 3 (ret)
	defw draw_trap                ; 4 trap tiles
	defw 06460h                   ; 5 (ret)
load_gems_far:                    ; 0x64E3  clear E700, page 13, load_gems
	ld hl,0e700h
	ld b,080h
	xor a
l64e9h:
	ld (hl),a
	inc hl
	djnz l64e9h
	call page_bank_d
	call load_gems
	jp page_banks_123
load_gems:                        ; 0x64F6  a75d_tbl[level] -> 0xE700 soul stones (16 x 8)
	ld a,(0e242h)
	ld hl,0a75dh
	call tbl_word
	ld de,0e700h
l6502h:
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
	jr l6502h
	ld bc,01000h
	ld ix,0e700h
l6524h:
	push bc
	ld a,(ix+000h)
	and a
	call nz,gem_draw
	ld de,00008h
	add ix,de
	pop bc
	inc c
	djnz l6524h
	ret
gem_draw:                       ; 0x6536  soul stone on this screen -> gem_tiles
	ld a,(0e243h)
	cp (ix+001h)
	ret nz
gem_tiles:                      ; 0x653D  2x2 tiles from 9324 at DE
	ld hl,09324h
	ld e,(ix+002h)
	ld d,(ix+003h)
	ld bc,00202h
	jp draw_tilemap
tick_e500:                        ; 0x654C  thrown/active tools at E500
	ld ix,0e500h
	ld b,008h
l6552h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l6563h
	call tick_thrown
	bit 0,(ix+006h)
	call nz,e500_move
l6563h:
	ld de,00020h
	add ix,de
	pop bc
	djnz l6552h
	ret
e500_move:                      ; 0x656C  apply ix+7/9 velocity; wrap via e500_wrap
	ld a,(ix+00bh)
	cp 002h
	jr c,l6595h
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+009h)
	ld d,(ix+00ah)
	jr z,l658eh
	add hl,de
	ld a,h
	cp 0f1h
	jr nc,l65c1h
l6587h:
	ld (ix+004h),l
	ld (ix+005h),h
	ret
l658eh:
	and a
	sbc hl,de
	jr c,l65b7h
	jr l6587h
l6595h:
	ld l,(ix+002h)
	ld h,(ix+003h)
	ld e,(ix+007h)
	ld d,(ix+008h)
	and a
	jr nz,l65aah
	sbc hl,de
	jr c,l65cbh
	jr l65b0h
l65aah:
	add hl,de
	ld a,h
	cp 0b1h
	jr nc,l65d5h
l65b0h:
	ld (ix+002h),l
	ld (ix+003h),h
	ret
l65b7h:
	ld a,003h
	call e500_wrap
	ld hl,0f000h
	jr l6587h
l65c1h:
	ld a,004h
	call e500_wrap
	ld hl,00000h
	jr l6587h
l65cbh:
	ld a,001h
	call e500_wrap
	ld hl,0b000h
	jr l65b0h
l65d5h:
	ld a,002h
	call e500_wrap
	ld hl,00000h
	jr l65b0h
e500_wrap:                      ; 0x65DF  room_link A; update ix+16 screen + map ptr
	ld b,(ix+016h)
	call 05e38h
	ld (ix+016h),h
	ld (ix+010h),l
	ld a,l
	call map_of_a
	ld (ix+00ch),e
	ld (ix+00dh),d
	ret
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
	ld a,(0e243h)
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
	ld hl,l663dh
	ld de,l6641h
	call pick_frame
	jp z,l6706h
	ld (ix+011h),a
	ret
l663dh:
	dec d
	ld d,017h
	rst 38h
l6641h:
	dec d
	ld d,016h
	rst 38h
e500_sat:                         ; 0x6645  E500 sprite cells -> E840 / D300
	call e500_sat_put
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,0e843h
	ld de,0d300h
	ld c,010h
l6655h:
	ld a,(hl)
	ld b,010h
l6658h:
	ld (de),a
	inc de
	djnz l6658h
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz,l6655h
	ret
e500_sat_put:                   ; 0x6664  E500 on-screen -> SAT at E840
	ld ix,0e500h
	ld de,0e840h
	ld b,008h
	ld a,(0f0f4h)
	and a
	jr z,l66b9h
l6673h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l66abh
	ld a,(0e243h)
	cp (ix+010h)
	jr nz,l66abh
	ld l,(ix+011h)
	ld a,l
	inc a
	jr z,l66abh
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
l66a2h:
	ld bc,00020h
	add ix,bc
	pop bc
	djnz l6673h
	ret
l66abh:
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
	jr l66a2h
l66b9h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l66eah
	ld a,(0e243h)
	cp (ix+010h)
	jr nz,l66eah
	ld l,(ix+011h)
	ld a,l
	inc a
	jr z,l66eah
	ld h,000h
	call page_bank_d
	ld bc,0becfh                  ; E500 SAT patterns (ix+11)
	add hl,bc
	ld c,(ix+01eh)
	call e500_sat1
	call page_banks_123
l66e1h:
	ld bc,00020h
	add ix,bc
	pop bc
	djnz l66b9h
	ret
l66eah:
	ld a,0e0h
	ld (de),a
	inc e
	inc e
	inc e
	inc e
	jr l66e1h
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
l6706h:
	xor a
	ld (ix+000h),a
	ld (ix+013h),a
	ld a,(ix+015h)
	ld c,a
	add a,a
	add a,a
	add a,c
	ld hl,0e2c0h
	call ADD_HL_A
	set 7,(hl)
	ret
tick_delayed:                     ; 0x671D  E2C0 delayed pickups -> spawn_tool
	ld a,(0e203h)
	and 003h
	ret nz
	ld hl,0e2c0h
	ld bc,00800h
l6729h:
	push bc
	push hl
	bit 7,(hl)
	jr z,l6744h
	inc hl
	dec (hl)
	jr nz,l6744h
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
l6744h:
	pop hl
	pop bc
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc c
	djnz l6729h
	ret
load_delayed:                     ; 0x674F  b7cd_tbl -> E2C0 delayed pickups
	call page_bank_d
	ld hl,0e2c0h
	ld b,028h
	xor a
l6758h:
	ld (hl),a
	inc hl
	djnz l6758h
	ld hl,0b7cdh                  ; delayed pickups -> 0xE2C0
	ld a,(0e242h)
	call tbl_word
	ld de,0e2c0h
l6768h:
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
	jr l6768h
file_menu:                        ; 0x677E  start select (E24B 0 normal / 1 password / 2 stage load)
	call scr_reset
	call page_bank_c
	ld hl,0b185h                  ; str_start_sel
	call print_stream
	call page_banks_123
	xor a
	ld (0e24bh),a
	jp file_blit
file_menu_w:                      ; 0x6794  L/R on E24B 0..2 (normal / password / stage load); fire -> E24A
	call spr_vram
	ld hl,0e24bh
	ld a,(0e207h)
	rra
	jr c,l67aeh
	rra
	jr c,l67bah
	rra
	rra
	rra
	jr nc,l67c5h
	ld a,001h
	ld (0e24ah),a
	ret
l67aeh:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	jr nc,l67c5h
	ld (hl),002h
	jr l67c5h
l67bah:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(hl)
	cp 003h
	jr c,l67c5h
	ld (hl),000h
l67c5h:
	ld a,(hl)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,050h
	ld hl,0e800h
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
	ld hl,0d200h
	ld de,0d201h
	ld (hl),007h
	ld bc,0000fh
	ldir
	ret
file_blit:                        ; 0x67EC  32 bytes from bank 0C 0xB1B6
	call page_bank_c
	ld a,(0f0f4h)
	and a
	ld de,018a0h
	jr z,l67fbh
	ld de,0f8a0h
l67fbh:
	ld hl,0b1b6h
	ld bc,00020h
	call 04e05h
	jp page_banks_123
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
	ld bc,0e201h
	call WRTVDP
	xor a
	ld (0e257h),a
	ld (0edcch),a
	ld (0edc9h),a
	ld (0edceh),a
	inc a
	ld (0edd8h),a
	ld a,0e0h
	ld (0edcbh),a
	ret
pwd_tick:                         ; 0x683E  run pwd_script; fire -> pwd_card
	ld a,(0e257h)
	cp 009h
	jr nc,l684dh
	ld a,(0e207h)
	and 010h
	jp nz,pwd_card
l684dh:
	call pwd_script
	ld a,(0e257h)
	cp 009h
	call c,cer_sat
	jp spr_vram
pwd_script:                       ; 0x685B  0-based E257 -> e257_jp
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)
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
	ld hl,0e257h
	inc (hl)
	ret
pwd_drop:                         ; 0x6889  EDCB Y=0xA8
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,0a8h
	ld (0edcbh),a
	jr pwd_next
pwd_in:                           ; 0x6895  walk in until EDCC=0x60
	call pose_step
	ld a,(0edc9h)
	rra
	ret c
	ld hl,0edcch
	inc (hl)
	ld a,(hl)
	cp 060h
	ret c
	ld a,001h
	ld (0edd8h),a
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
	jr nc,l68d1h
	ld hl,edcb_delta_start
	call ADD_HL_A
	ld a,(0edcbh)
	add a,(hl)
	ld (0edcbh),a
	ld hl,0edcch
	inc (hl)
	ret
l68d1h:
	ld a,0a0h
	ld (0edcbh),a
	ld a,002h
	ld (0edd8h),a
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
	ld hl,0edcch
	inc (hl)
	ld a,(hl)
	cp 0d8h
	ret c
	xor a
	ld (0edd8h),a
	ld a,010h
	jp pwd_delay
pwd_pose6:                        ; 0x6914  EDD8=6
	ld a,006h
l6916h:
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (0edd8h),a
	ld a,010h
	jp pwd_delay
pwd_pose0:                        ; 0x6923  EDD8=0
	xor a
	jr l6916h
pwd_burst:                        ; 0x6926  8 sprites via sat_fx
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,008h
	call sat_fx
	jp pwd_next
pwd_idle:                         ; 0x6933  wait sat_fx (E880) empty
	call sat_fx_tick
	ld a,(0e880h)
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
	ld bc,0e201h
	call WRTVDP
	ld hl,0ac01h                  ; str_pwd_best
	call print_12
	ld a,080h
	ld (0e204h),a
	ld a,00ah
	ld (0e257h),a
	ret
pwd_done:                         ; 0x6971  E24A=1 (leave title file UI)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,001h
	ld (0e24ah),a
	ret
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
pwd_gen:                          ; 0x6994  level/E240/R -> 8 glyphs at EDD9
	ld de,0ede2h
	ld a,(0e242h)
	ld (de),a
	inc de
	ld h,a
	ld a,(0e240h)
	ld (de),a
	inc de
	ld l,a
	ld a,r
	ld (de),a
	ld c,a
	and 007h
	jr z,l69b7h
	ld b,a
l69ach:
	rr h
	rr l
	jr nc,l69b4h
	set 7,h
l69b4h:
	or a
	djnz l69ach
l69b7h:
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
pwd_glyph:                      ; 0x69F5  nibble A -> glyph (0xE1/0xD1 +)
	ld b,0e1h
	cp 019h
	jr c,l69fdh
	ld b,0d1h
l69fdh:
	add a,b
	ret
pwd_txt:                          ; 0x69FF  print_stream "pass word"
	defb 058h, 090h         ; D,E
	TEXT "pass word"
	defb 0ffh               ; end
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
	ld (0e207h),a
	call page_bank_d
	ld hl,0be91h
	call print_stream
	jp page_banks_123
pwd_enter_w:                      ; 0x6A32  wait E24A from password UI
	call spr_vram
	ld hl,0edebh
	ld a,(hl)
	or a
	jr z,l6a4ah
	inc hl
	dec (hl)
	ret nz
	inc hl
	ld a,(hl)
	ld (0e24ah),a
	ld hl,0edebh
	ld (hl),000h
	ret
l6a4ah:
	call pwd_cursor
	ld hl,0edefh
	ld a,(0e207h)
	rra
	rra
	rra
	jp c,l6b7fh
	rra
	jp c,l6b86h
	call keys_snap
	call pwd_decode
	ld a,(0ededh)
	or a
	jr z,l6a6ch
	call pwd_type
l6a6ch:
	ld a,(0edf7h)
	rla
	ret c
	ld hl,0edd9h
	ld b,008h
l6a76h:
	ld a,(hl)
	ld d,0e1h
	cp d
	jr nc,l6a7eh
	ld d,0d0h
l6a7eh:
	sub d
	ld (hl),a
	inc hl
	djnz l6a76h
	call pwd_cheat
	jp z,l6af8h
	ld hl,0edd9h
	ld b,007h
	ld a,(hl)
	inc hl
l6a90h:
	add a,(hl)
	inc hl
	djnz l6a90h
	or a
	jp z,l6b05h
	ld hl,0edd9h
	ld b,008h
l6a9dh:
	ld a,(hl)
	or a
	jr c,l6b05h
	cp 010h
	jr nc,l6b05h
	inc hl
	djnz l6a9dh
	ld hl,0ede2h
	ld a,(hl)
	inc hl
	add a,(hl)
	inc hl
	add a,(hl)
	inc hl
	cp (hl)
	jr nz,l6b05h
	ld hl,0edd9h
	ld de,0ede2h
	ld b,004h
l6abch:
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
	djnz l6abch
	ld hl,0ede2h
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld a,(hl)
	and 007h
	ld b,a
l6ad5h:
	rl e
	rl d
	jr nc,l6addh
	set 0,e
l6addh:
	or a
	djnz l6ad5h
	ld a,d
	cp 03dh
	jr nc,l6b05h
	push de
	call 04c01h
	pop de
	ld a,d
	or a
	jr z,l6b05h
	ld (0e242h),a
	ld a,e
	or a
	jr z,l6b05h
	ld (0e240h),a
l6af8h:
	ld hl,0edebh
	inc (hl)
	inc hl
	inc hl
	ld (hl),001h
	ld hl,0bebeh
	jr l6b10h
l6b05h:
	ld hl,0edebh
	inc (hl)
	inc hl
	inc hl
	ld (hl),002h
	ld hl,0beadh
l6b10h:
	call page_bank_d
	call print_stream
	call page_banks_123
	call sat_wipe
	ld hl,0edebh
	inc (hl)
	inc hl
	ld (hl),080h
	ret
pwd_cheat:                      ; 0x6B24  FESTIVAL / TRYAGAIN 8-glyph cheats
	ld de,pwd_fest
	call pwd_cmp
	jr z,l6b3dh
	ld de,pwd_try
	call pwd_cmp
	ret nz
	call 04c01h
	ld a,001h
	ld (0e217h),a
	xor a
	ret
l6b3dh:
	call 04c01h
	ld a,001h
	ld (0e255h),a
	xor a
	ret
pwd_cmp:                        ; 0x6B47  EDD9 vs 8 bytes at DE
	ld hl,0edd9h
	ld b,008h
l6b4ch:
	ld a,(de)
	sub 041h
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz l6b4ch
	xor a
	ret
; BLOCK 'pwd_fest' (start 0x6b57 end 0x6b5f)
pwd_fest:
	defb "FESTIVAL"
; BLOCK 'pwd_try' (start 0x6b5f end 0x6b67)
pwd_try:
	defb "TRYAGAIN"
pwd_cursor:                     ; 0x6B67  SAT at E800 for password slot
	ld hl,0e800h
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
	jp 0898eh
l6b7fh:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
l6b86h:
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp sfx_32
pwd_decode:                     ; 0x6B8E  SNSMAT snapshot -> glyph at EDED
	ld a,(0edf0h)
	ld bc,008d0h
l6b94h:
	rra
	jr nc,l6bc2h
	inc c
	djnz l6b94h
	ld a,(0edf1h)
	ld b,002h
l6b9fh:
	rra
	jr nc,l6bc2h
	inc c
	djnz l6b9fh
	ld a,(0edf9h)
	ld b,005h
	ld c,0d0h
	rra
	rra
	rra
l6bafh:
	rra
	jr nc,l6bc2h
	inc c
	djnz l6bafh
	ld a,(0edfah)
	ld b,005h
l6bbah:
	rra
	jr nc,l6bc2h
	inc c
	djnz l6bbah
	jr l6bc5h
l6bc2h:
	ld a,c
	jr l6bf4h
l6bc5h:
	ld a,(0edf8h)
	rra
	jr c,l6bcfh
	ld a,0e0h
	jr l6bf4h
l6bcfh:
	ld a,(0edf2h)
	ld d,0e2h
	rla
	jr nc,l6bf3h
	ld d,0e1h
	rla
	jr nc,l6bf3h
	ld hl,0edf3h
	ld d,0e3h
	ld c,003h
l6be3h:
	ld b,008h
	ld a,(hl)
l6be6h:
	rra
	jr nc,l6bf3h
	inc d
	djnz l6be6h
	inc hl
	dec c
	jr nz,l6be3h
	xor a
	jr l6bf4h
l6bf3h:
	ld a,d
l6bf4h:
	ld hl,0edeeh
	ld c,(hl)
	ld (hl),a
	cp c
	jr nz,l6bfdh
	xor a
l6bfdh:
	ld (0ededh),a
	ret
pwd_type:                       ; 0x6C01  stamp decoded glyph into EDD9
	ld a,(0edefh)
	ld hl,pwd_x
	call ADD_HL_A
	ld d,(hl)
	ld e,070h
	ld a,(0ededh)
	call 0576ah
	ld a,(0edefh)
	ld hl,0edd9h
	call ADD_HL_A
	ld a,(0ededh)
	ld (hl),a
	ld hl,0edefh
	jp l6b86h
; BLOCK 'pwd_x' (start 0x6c26 end 0x6c2e)
pwd_x:
	defb 060h, 068h, 070h, 078h, 080h, 088h, 090h, 098h
keys_snap:                      ; 0x6C2E  SNSMAT rows 0-10 -> EDFA..
	ld hl,0edfah
	ld b,00bh
l6c33h:
	ld a,b
	dec a
	call 00141h
	ld (hl),a
	dec hl
	djnz l6c33h
	ret
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	call disk_buf
	call disk_load
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ret
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	call disk_buf
	call disk_save
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ret
; BLOCK 'save_map' (start 0x6c6d end 0x6c85)  RAM addr, length (6 chunks)
save_map:
	defw 0e243h, 00001h
	defw 0e25ch, 00023h
	defw 0e282h, 00003h
	defw 0e2c0h, 00240h
	defw 0e600h, 00200h
	defw 0e900h, 004c0h
disk_buf:                       ; 0x6C85  password + slot id into EE00 FCB
	ld hl,0e270h
	ld de,0ee00h
	ld (0f0e0h),de
	ld bc,00005h
	ldir
	ld de,0ee05h
	xor a
	ld b,008h
l6c9ah:
	ld (de),a
	inc de
	djnz l6c9ah
	inc de
	inc de
	inc de
	inc de
	ld a,(0f0e9h)
	ld (de),a
	ret
disk_load:                      ; 0x6CA7  disk-ROM 8000: open/read/close
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,000h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,002h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	ld b,006h
	ld hl,save_map
l6cf4h:
	push bc
	ld de,0ee0dh
	ld bc,00004h
	ldir
	push hl
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,009h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	pop hl
	pop bc
	or a
	jp nz,l6e02h
	djnz l6cf4h
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,001h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	or a
	jp nz,l6e02h
	xor a
	ld (0e27fh),a
	ret
disk_save:                      ; 0x6D57  disk-ROM 8000: create/write/close
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,000h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,002h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	ld b,006h
	ld hl,save_map
l6da4h:
	push bc
	ld de,0ee0dh
	ld bc,00004h
	ldir
	push hl
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,008h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	pop hl
	pop bc
	djnz l6da4h
	ld de,(0f0e0h)
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,001h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	or a
	jr nz,l6e22h
	xor a
	ld (0e27fh),a
	ret
l6e02h:
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,006h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
l6e22h:
	ld a,002h
	ld (0e27fh),a
	ret
l6e28h:
	ld b,(hl)
	ld c,c
	ld c,h
	ld b,l
	ccf
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	ld hl,0ee50h
	ld de,0ee51h
	ld bc,00020h
	ld (hl),000h
	ldir
	ld hl,l6e28h
	ld de,0ee00h
	ld bc,00005h
	ldir
	ld hl,0ee50h
	ld (0ee0dh),hl
	ld de,0ee00h
	ld (0f0e0h),de
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,003h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	and a
	jr nz,l6eaeh
l6e81h:
	ld hl,(0ee0dh)
	ld a,008h
	call ADD_HL_A
	ld (0ee0dh),hl
	ld a,(0f0f7h)
	ld h,080h
	call 00024h
	ld a,004h
	ld (08000h),a
	ld c,004h
	ld de,(0f0e0h)
	call 08000h
	push af
	ld a,(0f0e9h)
	ld h,080h
	call 00024h
	pop af
	jr z,l6e81h
l6eaeh:
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	xor a
	ld (0f0e5h),a
	ld de,0ee50h
l6ebch:
	ld a,(de)
	or a
	ret z
	push de
	ld a,(de)
	cp 046h
	jr nz,l6ed7h
	inc de
	ld a,(de)
	cp 049h
	jr nz,l6ed7h
	inc de
	ld a,(de)
	cp 04ch
	jr nz,l6ed7h
	inc de
	ld a,(de)
	cp 045h
	jr z,l6edfh
l6ed7h:
	pop de
l6ed8h:
	ld a,008h
	call ADD_DE_A
	jr l6ebch
l6edfh:
	pop de
	ld hl,0f0e5h
	inc (hl)
	ld a,(hl)
	cp 003h
	ret nc
	jr l6ed8h
	ld b,000h
	ld a,(0ffa7h)
	cp 0c9h
	jr z,l6ef4h
	inc b
l6ef4h:
	push bc
	call disk_find
	pop bc
	ld a,(0f0f7h)
	inc a
	jr z,l6f01h
	set 1,b
l6f01h:
	ld a,b
	ld (0f0f9h),a
	ret
disk_find:                      ; 0x6F06  scan slots for disk ROM (YZ header)
	ld bc,00400h
	ld hl,0fcc1h
l6f0ch:
	push bc
	push hl
	ld a,(hl)
	bit 7,a
	jr nz,l6f19h
	ld a,c
	call disk_yz
	jr l6f1ch
l6f19h:
	call disk_exp
l6f1ch:
	pop hl
	pop bc
	ret c
	inc hl
	inc c
	djnz l6f0ch
	ld a,0ffh
	ld (0f0f7h),a
	ret
disk_exp:                       ; 0x6F29  probe expanded slot 4 subslots
	and 080h
	or c
	ld b,004h
l6f2eh:
	push bc
	call disk_yz
	pop bc
	ret c
	add a,004h
	djnz l6f2eh
	ret
disk_yz:                        ; 0x6F39  RDSLT 4010/4011 == 'Y''Z'
	ld (0f0f7h),a
	ld hl,04010h
	call 0000ch
	cp 059h
	jr nz,l6f58h
	ld hl,04011h
	ld a,(0f0f7h)
	call 0000ch
	cp 05ah
	jr nz,l6f58h
	ld a,(0f0f7h)
	scf
	ret
l6f58h:
	ld a,(0f0f7h)
	and a
	ret
world_tick:                       ; 0x6F5D  mode_world: E257-1 -> d_6f6b
	call world_script
	jp spr_vram
world_script:                     ; 0x6F63
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)
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
	call strm_a3e8
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
	ld bc,0e201h
	call WRTVDP
	call sfx_0d                   ; world-map BGM
	ld a,03ch
world_delay:
	ld hl,0e204h
	ld (hl),a
world_next:
	ld hl,0e257h
	inc (hl)
	ret
world_pos:                        ; 0x6FD5  word[world-1] at HL -> EDCB/EDCC
	ld a,(0e241h)
	dec a
	add a,a
	call ADD_HL_A
	ld de,0edcbh
	ldi
	ldi
	ret
world_hold:                       ; 0x6FE5
	call world_far
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	ld (0edd8h),a
	inc a
	ld (0edceh),a
	call print_world
	ld a,008h
	jp world_delay
world_tour:                       ; 0x6FFD  walk map; E207 0x30 skips to world_xy2
	ld a,(0e207h)
l7000h:
	and 030h
	jr z,l7015h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,world_xy2
	call world_pos
	call world_hold8
	jp l71b8h
l7015h:
	call world_step
	jp l71b8h
world_step:                     ; 0x701B  tour pose + path + move
	ld b,007h
	call world_pose
	ld a,(0edceh)
	cp 007h
	ld a,(0edd8h)
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
world_hold8:                    ; 0x7042  A=8 -> world_delay
	ld a,008h
	jp world_delay
world_pic0:                       ; 0x7047  stamp wpic0
	ld b,007h
	call world_pose
	ld hl,0e204h
	dec (hl)
	jp nz,l71b8h
	xor a
	call world_blit
	call wpic0
l705ah:
	ld a,008h
	call world_delay
	jp l71b8h
world_pic1:                       ; 0x7062  stamp wpic1
	ld b,007h
	call world_pose
	ld hl,0e204h
	dec (hl)
	jp nz,l71b8h
	ld a,001h
	call world_blit
	call wpic1
	jr l705ah
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
	ld a,(0e880h)
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
	ld (0e257h),a
	call scr_reset
	jp wmap_font
world_blit:                     ; 0x7108  HMMM 60x80 from 0040/6000
	ld hl,00040h
	or a
	jr z,l7110h
	ld h,060h
l7110h:
	ld de,08828h
	ld bc,06080h
	ld a,001h
	jp vdp_hmmm
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
world_delta:                    ; 0x7140  EDCA dir -> step EDCB/EDCC
	ld hl,0edcbh
	ld a,(0edcah)
	dec a
	jr z,l7151h
	dec a
	jr z,l7153h
	dec a
	jr z,l7156h
	dec (hl)
	ret
l7151h:
	inc (hl)
	ret
l7153h:
	inc hl
	dec (hl)
	ret
l7156h:
	inc hl
	inc (hl)
	ret
world_pose:                     ; 0x7159  toggle EDD8 every B frames
	ld hl,0edceh
	dec (hl)
	ret nz
	ld (hl),b
	ld a,(0edd8h)
	xor 003h
	ld (0edd8h),a
	ret
world_done:                     ; 0x7168  Z if EDC8 == world_len[world]
	ld a,(0e241h)
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
world_path:                     ; 0x717C  page D; path byte -> EDCA
	call page_bank_d
	call world_path_d
	jp page_banks_123
world_path_d:                   ; 0x7185  ba57 tour path for this world
	ld hl,0ba57h
	ld a,(0e241h)
	dec a
	call tbl_word
	ld d,h
	ld e,l
	ld a,(0edc8h)
	ld b,a
l7195h:
	ld a,(de)
	cp 0ffh
	ret z
	inc de
	cp b
	jr z,l71a0h
	inc de
	jr l7195h
l71a0h:
	ld a,(de)
	ld (0edcah),a
	ret
print_world:                      ; 0x71A5  print_stream world_txt[E241-1]
	call page_bank_c
	ld hl,0ac13h                  ; world_txt (bank 0C MODULE)
	ld a,(0e241h)
	dec a
	call tbl_word
	call print_stream
	jp page_banks_123
l71b8h:
	call page_bank_c
	call 0bdd7h
	jp page_banks_123
world_far:                      ; 0x71C1  page C 0xBDDA then banks 123
	call page_bank_c
	call 0bddah
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
clear_tick:                       ; 0x71DE  mode_clear: E257-1 -> d_71e3
	ld de,0e257h
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
	jr z,l71ffh
	jr nc,l720fh
l71ffh:
	ld hl,0e2f7h
	dec (hl)
	ret nz
	ld (hl),01eh
	dec hl
	inc (hl)
	ld hl,0e2f0h
	inc (hl)
	jp draw_exit
l720fh:
	ld hl,0e2f7h
	dec (hl)
	ret nz
	ld hl,0e257h
	inc (hl)
	inc hl
	ld (hl),000h
	inc hl
	ld (hl),020h
	ret
clear_walk:                       ; 0x721F  Vic left 4 frames; SAT from clear_spr
	ld hl,0e259h
	dec (hl)
	jr nz,l7230h
	ld (hl),020h
	dec hl
	inc (hl)
	ld a,(hl)
	cp 004h
	jp nc,l7288h
	inc hl
l7230h:
	ld a,(hl)
	and 00fh
	jr nz,l723ch
l7235h:
	ld de,0e282h
	ld a,(de)
	sub 002h
	ld (de),a
l723ch:
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
	ld de,0e800h
	ld b,004h
	exx
	ld hl,0d200h
	exx
l725bh:
	ld a,(0e282h)
	add a,(hl)
	ld (de),a
	inc hl
	inc de
	ld a,(0e284h)
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
	djnz l725bh
	ret
; BLOCK 'clear_spr' (start 0x7280 end 0x7288)  4 SAT (Y offset, pattern)
clear_spr:
	defb 0f8h, 00dh
	defb 0f8h, 04eh
	defb 008h, 00dh
	defb 008h, 04eh
l7288h:
	call sat_wipe
	ld hl,0e257h
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
	ld hl,0e800h
	ld b,002h
l72c2h:
	ld a,(hl)
	sub 010h
	ld (hl),a
	ld a,004h
	call ADD_HL_A
	djnz l72c2h
	ld hl,0e257h
	inc (hl)
	ret
clear_blank:                    ; 0x72D2  stamp 32 empty tiles across X
	ld b,020h
	ld d,000h
l72d6h:
	xor a
	call 0576ah
	ld a,d
	add a,008h
	ld d,a
	djnz l72d6h
	ret
clear_card:                       ; 0x72E1  next level; "rest" + score
	ld hl,0e242h
	inc (hl)
	xor a
	ld (0e249h),a
	call scr_reset
	call page_bank_c
	ld hl,0b256h                  ; str_clear_card
	call print_stream
	call page_banks_123
	ld c,0ffh
	ld hl,l5f0eh
	ld de,edc0_jp_end+1
	call print_at
	ld de,08868h
	call 04d1fh
	ld a,03ch
clear_delay:
	ld (0e204h),a
	ld hl,0e257h
	inc (hl)
	ret
clear_score:                      ; 0x7313  BCD-inc E240 (cap 0x99)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0e240h
	ld a,(hl)
	cp 099h
	jr nc,l7324h
	add a,001h
	daa
	ld (hl),a
l7324h:
	ld de,08868h
	push hl
	call 04d1fh
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
	ld a,(0e207h)
	and a
	ret z
	jr clear_delay
clear_done:                       ; 0x7342  E257=0 (mode_clear advances)
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0e257h
	ld (hl),000h
	ret
end_tick:                         ; 0x734D  mode_endtxt: E257-1 -> d_735f (65)
	call end_script
	jp spr_vram
end_script:                       ; 0x7353
	ld hl,0edc9h
	inc (hl)
	call sat_fx_tick
	ld de,0e257h
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
	ld a,(0e880h)
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
	ld a,(0e880h)
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
	ld bc,0e201h
	call WRTVDP
	call sfx_12                   ; ending
end_next:                         ; 0x7440  inc E257
	ld hl,0e257h
	inc (hl)
	ret
end_txt2:                         ; 0x7445  print 0xAD12, sat_fx 0Ah
	ld a,(0e880h)
	or a
	ret nz
	ld hl,0ad12h                  ; str_end_txt2
	call print_12
	ld a,00ah
	call sat_fx
	jr end_next
end_idle:                         ; 0x7457  wait sat_fx, delay 0
	ld a,(0e880h)
	and a
	ret nz
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
	ld a,(0e880h)
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
	ld bc,0e201h
	call WRTVDP
	jp end_next
end_wait2:                        ; 0x74B7
	call spark_far
	ld a,(0e880h)
	or a
	ret nz
	ld a,0a0h
	jr end_delay
end_timer:                        ; 0x74C3  E902 at t=30
	ld hl,0e204h
	dec (hl)
	jr z,l74d8h
	ld a,(hl)
	cp 030h
	call z,end_flag
	jp spark_far
end_flag:                       ; 0x74D2  E902=1 (spark spawn enable)
	ld a,001h
	ld (0e902h),a
	ret
l74d8h:
	xor a
	ld (0edceh),a
	ld a,050h
	jp end_delay
end_stamp:                        ; 0x74E1  bank12 0xAF37 stamps
	call spark_far
	ld hl,0e204h
	dec (hl)
	jr z,l750fh
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
l750fh:
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
	ld a,(0e880h)
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
	ld bc,0e201h
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
	ld a,(0e208h)
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
	call 050beh
	xor a
	call end_delay
	jp sfx_39
end_flash:                        ; 0x75A7  border flash via l770ch
	ld hl,0e204h
	dec (hl)
	ld a,(hl)
	or a
	jr z,l75b8h
	cp 080h
	jp c,l770ch
	jp z,sfx_3a
	ret
l75b8h:
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
	ld a,(0e880h)
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
	ld a,(0e880h)
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
	ld a,(0e880h)
	or a
	ret nz
	ld a,020h
	jp end_delay
end_spawn:                        ; 0x7613  Vic-like XY, sat_fx 6
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,09fh
	ld (0edcbh),a
	ld a,080h
	ld (0edcch),a
	xor a
	ld (0edd8h),a
	ld (0edceh),a
	call cer_sat
	ld a,006h
	call sat_fx
	jp end_next
end_swait:                        ; 0x7634
	call cer_sat
	ld a,(0e880h)
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
	ld (0edd8h),a
	ld hl,0af21h                  ; str_end_congrats
	call print_12
	ld a,00bh
	call sat_fx
	jp end_next
end_swait2:                       ; 0x765C
	call cer_sat
	ld a,(0e880h)
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
	ld (0edd8h),a
	jp end_next
end_walk:                         ; 0x7679  walk until EDCC=30h, sat_fx 7
	call pose_step
	ld hl,0edc9h
	ld a,(hl)
	and 003h
	jp nz,cer_sat
	ld hl,0edcch
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
	jp nz,l76a7h
	ld hl,0edcch
	dec (hl)
l76a7h:
	ld a,(0e880h)
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
	ld a,(0e880h)
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
	ld a,(0e880h)
	or a
	ret nz
	call scr_reset
	ld a,020h
	jp end_delay
end_done:                         ; 0x76F8  fire/space → E257=0
	ld a,(0e208h)
	and 030h
	ret z
	sub a
	ld (0e257h),a
	ret
spark_far:                        ; 0x7703  page 12 spark_tick
	call page_bank_c
	call 0bcd2h                   ; spark_tick (bank 0C MODULE)
	jp page_banks_123
l770ch:
	ld a,(0edc9h)
	rra
	rra
	ld bc,00007h
	jp c,WRTVDP
	ld b,00bh
	jp WRTVDP
print_12:                         ; 0x771C  print_stream with bank 0C paged
	call page_bank_c
	call print_stream
	jp page_banks_123
end_print_i:                      ; 0x7725  print_stream ad76_tbl[EDCF]
	call page_bank_c
	ld a,(0edcfh)
	ld hl,0ad76h                  ; ad76_tbl
	call tbl_word
	call print_stream
	jp page_banks_123
pal_blink_a:                      ; 0x7737  pal 0x0A from EDC9 bit 4
	ld a,(0edc9h)
	rra
	rra
	rra
	rra
	ld de,03000h
	jr c,l7746h
	ld de,07101h
l7746h:
	ld a,00ah
	jp palette_set
pal_blink_c:                      ; 0x774B  pal 0x0C from E204 bit 2
	ld a,(0e204h)
	rra
	rra
	ld de,l7000h
	jr c,l7758h
	ld de,00007h
l7758h:
	ld a,00ch
	jp palette_set
pal_black:                        ; 0x775D  palettes A=B+1, B=16..1 → 0000h
	ld b,010h
l775fh:
	ld a,b
	inc a
	ld de,00000h
	call palette_set
	djnz l775fh
	ret
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
	ld (0edd8h),a
	ret
pose_tbl:                         ; 0x7782  walk poses 1,2,3,2
	defb 001h, 002h, 003h, 002h
cer_sat:                          ; 0x7786  2x2 SAT at EDCB/EDCC, pose EDD8
	ld hl,0e800h
	exx
	ld de,pose_pat
	ld a,(0edd8h)
	add a,a
	add a,a
	call ADD_DE_A
	exx
	ld a,(0edcbh)
	ld e,a
	ld a,(0edcch)
	ld d,a
	call cer_pair
	ld a,e
	add a,010h
	ld e,a
	call cer_pair
	jp 098b9h                     ; SAT colour fill 0x0D/0x4E
cer_pair:                         ; 0x77AB  two SAT entries (Y,X,pat) at DE
	ld b,002h
l77adh:
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
	djnz l77adh
	ret
pose_pat:                         ; 0x77BB  7×4 sprite pats; cer_sat uses EDD8×4
	defb 000h, 004h, 008h, 00ch
	defb 010h, 014h, 028h, 02ch
	defb 018h, 01ch, 030h, 034h
	defb 020h, 024h, 038h, 03ch
	defb 060h, 064h, 068h, 06ch
	defb 040h, 044h, 048h, 04ch
	defb 050h, 054h, 058h, 05ch
sat_fx:                           ; 0x77D7  A = script; load from bank 0E/0F 0xA792 → E880
	call page_banks_ef
	ld hl,0e880h
	ld de,0e881h
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
	ld hl,0e880h
	inc (hl)
	jp page_banks_123
sat_fx_tick:                      ; 0x781C  page 14/15, run if E880
	call page_banks_ef
	call sat_fx_run
	jp page_banks_123
sat_fx_run:                       ; 0x7825  DISPATCH_A on E881
	ld a,(0e880h)
	or a
	ret z
	call sat_fx_done
	ld a,(0e880h)
	or a
	ret z
	ld a,(0e881h)
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
l784ch:
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
	djnz l784ch
	call sat_fx_pal
l785eh:
	ld hl,0e881h
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
l7871h:
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
	djnz l7871h
	call sat_fx_pal
	jr l785eh
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
l7895h:
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
	djnz l7895h
	call sat_fx_pal
	ld hl,0e881h
	ld (hl),000h
	ret
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
	jr nc,l78c4h
	ld c,0f0h
l78c4h:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
sat_fx_lo:                      ; 0x78C8  morph dest low nibble toward src
	ld a,(hl)
	and 00fh
	ld c,a
	ld a,(de)
	and 00fh
	cp c
	ret z
	ld c,001h
	jr nc,l78d7h
	ld c,0ffh
l78d7h:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
sat_fx_lo2:                     ; 0x78DB  last-pass low nibble morph
	ld a,(hl)
	and 00fh
	ld c,a
	ld a,(de)
	and 00fh
	cp c
	ret z
	ld c,001h
	jr nc,l78eah
	ld c,0ffh
l78eah:
	ld a,(hl)
	add a,c
	ld (hl),a
	ret
sat_fx_pal:                     ; 0x78EE  palette_set E887 16 colours
	ld hl,0e887h
	xor a
l78f2h:
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
	jr l78f2h
sat_fx_done:                    ; 0x7903  Z if E887 matches dest; clear E880
	ld b,020h
	ld de,0e887h
	ld hl,(0e884h)
l790bh:
	ld a,(de)
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz l790bh
	ld hl,0e880h
	ld (hl),000h
	ret
sat_fx_ptr:                     ; 0x7918  HL=E884 dest, DE=E887 work
	ld hl,(0e884h)
	ld de,0e887h
	ex de,hl
	ret
cont_tick:                        ; 0x7920  mode_cont: E25A-1 -> d_7924
	ld a,(0e25ah)
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
	ld (0e241h),a
	call load_world_gfx
	call pal_15
	call edit_pat
	call cont_next
	ld a,001h
	ld (0e25bh),a
	ld hl,0e2c0h
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
	ld hl,0e270h
	ld de,0e271h
	ld bc,0000bh
	ld (hl),020h
	ldir
	ret
cont_io:                          ; 0x7977  io_tick until E25B=0; E27E 1=loaded
	call io_tick
	ld a,(0e25bh)
	and a
	ret nz
	call cont_next
	ld a,(0e27eh)
	and a
	ret z
	dec a
	jr nz,l7990h
	call cont_next
	jp l7a5ch
l7990h:
	ld a,001h
	ld (0e25ah),a
	ret
cont_map:                         ; 0x7996  draw 7-row screen map
	call scr_reset
	call scr_grid
cont_next:                        ; 0x799C  inc E25A, E25B=0
	ld hl,0e25ah
	inc (hl)
	inc hl
	ld (hl),000h
	ret
cont_curs:                        ; 0x79A4  cursor E25C/D/E on E788
	call map_stick
	jp l7a69h
map_stick:                      ; 0x79AA  continue-map cursor on E25C/D/E
	ld a,(0e20ch)
	rla
	jp c,l7a40h
	ld a,(0e207h)
	rra
	ld hl,0e25ch
	jp c,l7a39h
	rra
	jp c,l7a31h
	rra
	ld hl,0e25dh
	jp c,l7a39h
	rra
	jp c,l7a31h
	rra
	ld hl,0e25eh
	jr c,l79e1h
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
	jp l79f2h
l79e1h:
	ld a,(hl)
	and a
	jr z,l79ebh
	push hl
	call scr_free
	pop hl
	ret z
l79ebh:
	ld a,(hl)
	cp 006h
	ret nc
	inc (hl)
	ld b,001h
l79f2h:
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
	jr nz,l7a13h
	xor a
l7a13h:
	ld bc,02017h
	ld d,000h
	push hl
	call vdp_lmmv
	pop hl
	ld bc,0170bh
	jp vdp_hmmv_hi
scr_ptr:                        ; 0x7A23  E25C/D -> HL in E788
	ld hl,(0e25ch)
	ld a,l
	add a,a
	add a,a
	add a,a
	add a,h
	ld hl,0e788h
	jp ADD_HL_A
l7a31h:
	ld a,(hl)
	cp 005h
	ret nc
	inc (hl)
	jp sfx_32
l7a39h:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
l7a40h:
	ld hl,0e788h
	ld bc,03001h
l7a46h:
	ld a,(hl)
	and a
	jr z,l7a4ch
	ld (hl),c
	inc c
l7a4ch:
	ld a,c
	cp 007h
	jr nc,l7a56h
	inc hl
	djnz l7a46h
	dec c
	ret z
l7a56h:
	call 087b5h
	call edit_first
l7a5ch:
	xor a
	ld hl,0e260h
	ld (hl),a
	inc hl
	ld (hl),a
	call edit_font
	jp cont_next
l7a69h:
	ld hl,0e800h
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
	ld hl,0d200h
	ld de,0d201h
	ld (hl),007h
	ld bc,0000fh
	ldir
	ret
edit_pat:                       ; 0x7A96  pat_15 + clear held + vic_reload
	call pat_15
	xor a
	ld (0e285h),a
	ld (0e298h),a
	ld (0e287h),a
	call vic_reload
rle_minimap:                    ; 0x7AA6  bank D rle_bbfc -> F880
	call page_bank_d
	ld de,0bbfch                  ; rle_bbfc minimap
	ld hl,0f880h
	call rle_vram
	jp page_banks_123
scr_free:                       ; 0x7AB5  Z if E788 neighbours empty
	call scr_ptr
	ld a,(hl)
	and a
	jr nz,l7ad9h
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
l7ad9h:
	xor a
	ret
scr_used:                       ; 0x7ADB  Z if E788[cursor] occupied
	call scr_ptr
	ld a,(hl)
	and a
	ret
scr_grid:                       ; 0x7AE1  7-row HMMV screen-map boxes
	ld hl,02022h
	ld d,h
	ld e,l
	ld b,007h
l7ae8h:
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
	djnz l7ae8h
	ret
cont_edit:                        ; 0x7B08  nested editor: 0-based E25B -> d_7b0b
	ld a,(0e25bh)
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
	ld hl,0e25bh
	inc (hl)
	ret
edit_font:                      ; 0x7B33  bank D 2x13 tiles -> F038
	call page_bank_d
	ld hl,0bc44h
	ld de,0f038h
	ld bc,0020dh
	call copy_tiles
	jp page_banks_123
edit_kind:                        ; 0x7B45  E260 = legend 0..10
	ld a,(0e20ch)
	rla
	jr nc,l7b6ah
	ld a,(0e260h)
	sub 009h
	jp z,l7d6dh
	dec a
	jr z,l7baah
	sub 004h
	cp 003h
	jp nc,l7cb3h
	call edit_wipe
	ld a,007h
	ld hl,0d200h
	call cc_fill
	jr l7b9ah
l7b6ah:
	call kind_sat
	ld hl,0e260h
	ld a,(0e207h)
	rra
	jr c,l7bc5h
	rra
	jr c,l7bcfh
	rra
	rra
	rra
	ret nc
	push hl
	call edit_wipe
	ld a,007h
	ld hl,0d200h
	call cc_fill
	pop hl
	ld a,(hl)
	cp 009h
	jp z,l7d6dh
	cp 00ah
	jr z,l7baah
	sub 004h
	cp 003h
	jr nc,l7ba4h
l7b9ah:
	xor a
	ld (0e261h),a
	call edit_help
	jp edit_next
l7ba4h:
	ld hl,0e25bh
	inc (hl)
	inc (hl)
	ret
l7baah:
	ld a,005h
	ld (0e25bh),a
	call sat_wipe
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0be77h
	call print_stream
	jp page_banks_123
l7bc5h:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld (hl),00ah
	ret
l7bcfh:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(hl)
	cp 00bh
	ret c
	ld (hl),000h
	ret
kind_sat:                       ; 0x7BDA  legend cursor SAT at E800
	ld b,010h
	ld a,(0e260h)
	ld hl,0e800h
l7be2h:
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
	ld de,0d200h
	ld a,l
	and 07ch
	ld h,000h
	ld l,a
	add hl,hl
	add hl,hl
	add hl,de
	ld a,(0e203h)
	and 008h
	ld a,007h
	jr z,cc_fill
	xor a
cc_fill:                        ; 0x7C04  16 colour bytes at HL = A
	ld d,h
	ld e,l
	inc de
	ld (hl),a
	ld bc,0000fh
	ldir
	ret
edit_help:                      ; 0x7C0E  print bcbb stream for E260-4
	call page_bank_d
	ld a,(0e260h)
	sub 004h
	ld hl,0bcbbh
	call tbl_word
	ld a,(hl)
	ld (0e263h),a
	inc hl
	call print_stream
	jp page_banks_123
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
	ld a,(0e20ch)
	rla
	jp c,l7cb3h
	call sub_sat
	ld hl,0e261h
	ld a,(0e207h)
	rra
	jr c,l7c5fh
	rra
	jr c,l7c6bh
	rra
	rra
	rra
	ret nc
	ld a,007h
	ld hl,0d210h
	call cc_fill
	jp edit_next
l7c5fh:
	call sfx_32                   ; cursor
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld a,(0e263h)
	ld (hl),a
	ret
l7c6bh:
	call sfx_32                   ; cursor
	inc (hl)
	ld a,(0e263h)
	cp (hl)
	ret nc
	ld (hl),000h
	ret
sub_sat:                        ; 0x7C77  subtype cursor SAT at E804
	ld b,088h
	ld a,(0e261h)
	ld hl,0e804h
	jp l7be2h
edit_scr:                         ; 0x7C82  E262 slot in E788
	ld a,(0e20ch)
	rla
	jp c,l7cb3h
	call scr_sat
	ld hl,0e262h
	ld de,0e788h
	ld a,(0e207h)
	rra
	jr c,l7d11h
	rra
	jr c,l7d1ah
	rra
	jp c,l7d31h
	rra
	jp c,l7d39h
	rra
	ret nc
	ld a,007h
	ld hl,0d220h
	call cc_fill
	ld a,001h
	ld (0e25bh),a
	ret
l7cb3h:
	call scr_reset
	ld hl,0e264h
	ld (hl),00bh
	inc hl
	ld (hl),00fh
	call sat_wipe
	call edit_redraw
	ld a,004h
	ld (0e25bh),a
	ld a,(0e260h)
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
edit_first:                       ; 0x7CFF  first nonempty E788 -> E262
	ld hl,0e788h
	ld c,000h
l7d04h:
	ld a,(hl)
	dec a
	jr z,l7d0ch
	inc hl
	inc c
	jr l7d04h
l7d0ch:
	ld a,c
	ld (0e262h),a
	ret
l7d11h:
	ld a,(hl)
	and 038h
	ret z
	ld a,(hl)
	sub 008h
	jr l7d26h
l7d1ah:
	ld a,(hl)
	and 038h
	rrca
	rrca
	rrca
	cp 005h
	ret nc
	ld a,(hl)
	add a,008h
l7d26h:
	ld b,a
	call ADD_DE_A
	ld a,(de)
	and a
	ret z
	ld (hl),b
	jp sfx_32
l7d31h:
	ld a,(hl)
	and 007h
	ret z
	ld a,(hl)
	dec a
	jr l7d26h
l7d39h:
	ld a,(hl)
	and 007h
	cp 005h
	ret nc
	ld a,(hl)
	inc a
	jr l7d26h
scr_sat:                        ; 0x7D43  E262 slot cursor SAT at E808
	ld a,(0e262h)
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
	ld a,(0e203h)
	and 008h
	ld a,007h
	jr z,l7d67h
	xor a
l7d67h:
	ld hl,0d220h
	jp cc_fill
l7d6dh:
	ld hl,0e26ah
	ld a,(hl)
	inc hl
	and (hl)
	ret z
	call count_gems
	call scr_reset
	call sat_wipe
	call cont_next
	ld a,001h
	ld (0e25bh),a
	ret
count_gems:                     ; 0x7D86  nonempty E700 -> E2F4/E2F5
	ld hl,0e700h
	ld bc,01000h
l7d8ch:
	ld a,(hl)
	and a
	jr z,l7d91h
	inc c
l7d91h:
	ld a,008h
	call ADD_HL_A
	djnz l7d8ch
	ld a,c
	ld (0e2f4h),a
	ld (0e2f5h),a
	ret
edit_redraw:                    ; 0x7DA0  stamp map + gems/actors/tools/Vic
	call edit_unpack
	ld a,(0e26ch)
	and a
	call nz,083e3h
	call edit_screen
	ld c,a
	ld ix,0e700h
	ld b,010h
l7db4h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l7dc4h
	ld a,(ix+001h)
	cp c
	jr nz,l7dc4h
	call gem_tiles
l7dc4h:
	ld bc,00008h
	add ix,bc
	pop bc
	djnz l7db4h
	call edit_screen
	ld hl,0e2f3h
	cp (hl)
	jr nz,l7de9h
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)
	ld hl,09340h
	ld bc,00404h
	push bc
	push de
	call 05737h
	pop hl
	pop bc
	call 0860eh
l7de9h:
	call edit_screen
	ld c,a
	ld hl,0e300h
	ld b,040h
l7df2h:
	push bc
	ld a,(hl)
	and a
	push hl
	jr z,l7e0dh
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	dec a
	ld b,a
	inc hl
	ld a,(hl)
	cp c
	jr nz,l7e0dh
	ld a,b
	call tool_tiles
	ld bc,00202h
	call 05737h
l7e0dh:
	pop hl
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz l7df2h
	ld a,(0e267h)
	and a
	call nz,0821ch
	ld a,(0e266h)
	and a
	call nz,0811fh
	ld a,(0e26bh)
	and a
	ret z
	ld a,(0e243h)
	ld b,a
	call edit_screen
	cp b
	call z,08046h
	ret
edit_unpack:                    ; 0x7E35  map_base[screen] -> stamp_map body
	call edit_screen
	dec a
	ld h,000h
	ld l,a
	call map_base
	push hl
	pop ix
	xor a
	ld (0efc0h),a
	jp 04553h
edit_yn:                          ; 0x7E49  "edit end" Y/N; yes -> E25A=0
	call yn_keys
	and a
	ret z
	dec a
	jr z,l7e56h
	xor a
	ld (0e25bh),a
	ret
l7e56h:
	xor a
	ld (0e25ah),a
	ret
edit_put:                         ; 0x7E5B  place current kind (d_7e6c on E260)
	ld a,(0e20ch)
	rla
	jr nc,l7e66h
	xor a
	ld (0e25bh),a
	ret
l7e66h:
	call 08641h
	ld a,(0e260h)
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
l7e84h:
	ld (0efd0h),hl
	call edit_cursor
	call exit_hit
	ret c
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	jr nz,l7e9ch
	xor a
	ld (0efd0h),a
l7e9ch:
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
	jr nz,l7ebeh
	ld a,c
	cp 002h
	jr nc,l7ec1h
	ret
l7ebeh:
	ld a,c
	dec a
	ret z
l7ec1h:
	ld a,b
	push hl
	push hl
	push af
	ld bc,00101h
	call stamp_rect
	pop af
	pop de
	and a
	jr nz,l7ed5h
	ld a,0e0h
	ld (0efd1h),a
l7ed5h:
	ld a,(0efd1h)
	call 0576ah
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
	jr nz,l7ef0h
	push hl
	ld h,0f8h
	call edit_stamp1
	pop hl
l7ef0h:
	dec c
	ret nz
	ld h,000h
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
	call z,0576ah
	pop de
	pop bc
	ret
edit_wrap_x:                    ; 0x7F10  C=3/4 at left/right edge, else 0
	ld c,003h
	ld a,d
	and a
	jr z,l7f1eh
	inc c
	cp 0f8h
	jr z,l7f1eh
	xor a
	ld c,a
	ret
l7f1eh:
	ld a,(0e262h)
	ld b,a
	ld a,c
	push bc
	call 05e38h
	pop bc
	ld a,l
	ret
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
edit_screen:                    ; 0x7F39  E788[E262] screen id
	ld de,0e788h
	ld a,(0e262h)
	call ADD_DE_A
	ld a,(de)
	ret
put_floor2:                       ; 0x7F44  floor2 stamp (HL=5E03h) → put_floor1 tail
	ld hl,05e03h
	jp l7e84h
put_ladder:                       ; 0x7F4A
	call edit_cursor
	call exit_hit8
	ret c
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld a,001h
	jr nz,l7f5eh
	xor a
l7f5eh:
	ld (0efd0h),a
	ld b,a
	call edit_screen
	ld h,a
	exx
	call screen_base
	ld (0e250h),de
	exx
	call edit_xy
	ex de,hl
	ld a,b
	and a
	jr nz,l7f8fh
	push hl
	exx
	pop hl
	ld de,(0e250h)
	push hl
	call map_tile_de
	pop hl
	dec a
	ret nz
	call 0a60fh
	exx
	jr nc,l7f8fh
	ld a,h
	sub 008h
	ld h,a
l7f8fh:
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
	jr z,l7fa4h
	ld a,003h
l7fa4h:
	push af
	push de
	call 0576ah
	pop de
	ld a,d
	add a,008h
	ld d,a
	pop af
	jr z,l7fb2h
	inc a
l7fb2h:
	jp 0576ah
edit_stamp_wrap:                ; 0x7FB5  stamp_rect on wrapped neighbour
	push de
	call edit_wrap_y
	pop hl
	and a
	ret z
	ld d,a
	dec c
	ld l,0b8h
	jr z,l7fc4h
	ld l,000h
l7fc4h:
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
	jr z,l7fdeh
	ld a,003h
l7fdeh:
	jp l7fa4h
edit_wrap_y:                    ; 0x7FE1  C=1/2 at top/bottom edge, else 0
	ld c,001h
	ld a,e
	and a
	jp z,l7f1eh
	inc c
	cp 0b8h
	jp z,l7f1eh
	xor a
	ret
exit_hit:                       ; 0x7FF0  CY if cursor overlaps exit (0,0)
	ld bc,02000h
	jr l7ff8h
exit_hit8:                      ; 0x7FF5  same with 8px X inset
	ld bc,02808h
l7ff8h:
	ld a,(0e26ah)
	and a
	jr z,l8016h
	ld hl,0e2f3h                 ; was split: 021h,0f3h | bank2 0e2h

; ---------------------------------------------------------------------------
;  bank 02 continues at 0x8001 (ld hl high byte was 0x8000)
; ---------------------------------------------------------------------------
	call edit_screen
	cp (hl)
	jr nz,l8016h
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
l8016h:
	or a
	ret
put_player:                       ; 0x8018  Vic spawn E282 / E26B; fire places, else erase
	call edit_cursor
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld hl,0e282h
	jr z,l8039h
	call edit_screen
	ld (0e243h),a
	call edit_xy
	ld (hl),e
	inc hl
	inc hl
	ld (hl),d
	ld a,001h
	jr l8043h
l8039h:
	ld a,(0e243h)
	ld b,a
	call edit_screen
	cp b
	ret nz
	xor a
l8043h:
	ld (0e26bh),a
	ld hl,0e808h
	ld de,0e80ch
	exx
	ld hl,0e810h
	ld de,0e814h
	exx
	and a
	ld a,0e0h
	jr z,l805eh
	ld a,(0e282h)
	sub 008h
l805eh:
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
	ld a,(0e284h)
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
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld hl,0e266h
	jr z,l8102h
	ld a,(hl)
	cp 008h
	ret nc
	push hl
	call delay_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e2c0h
l80c5h:
	ld a,(hl)
	and a
	jr z,l80d0h
	ld a,005h
	call ADD_HL_A
	jr l80c5h
l80d0h:
	ld a,(0e261h)
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
	jr l811fh
delay_free:                     ; 0x80E8  Z if E2C0 slot at editor XY
	ld hl,0e2c0h
	ld b,008h
l80edh:
	ld a,(hl)
	and a
	jr z,l80f7h
	push hl
	call delay_at
	pop hl
	ret z
l80f7h:
	ld a,005h
	call ADD_HL_A
	djnz l80edh
	ld a,001h
	and a
	ret
l8102h:
	ld a,(hl)
	and a
	ret z
	ld hl,0e2c0h
	ld b,008h
l810ah:
	ld a,(hl)
	and a
	jr z,l8118h
	push hl
	call delay_at
	pop hl
	push hl
	call z,delay_erase
	pop hl
l8118h:
	ld a,005h
	call ADD_HL_A
	djnz l810ah
l811fh:
	ld hl,0e2c0h
	ld b,008h
	ld de,0e840h
l8127h:
	push hl
	exx
	call edit_screen
	exx
	inc hl
	inc hl
	cp (hl)
	pop hl
	jr nz,l8191h
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
	jr nz,l814bh
	ld a,0e0h
l814bh:
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
	ld hl,l86b9h
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
	ld de,0d200h
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
l8191h:
	ld a,005h
	call ADD_HL_A
	ld a,008h
	call ADD_DE_A
	djnz l8127h
	ret
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
delay_erase:                    ; 0x81B0  clear E2C0 rec; dec E266
	ld (hl),000h
	ld hl,0e266h
	dec (hl)
	ret
put_trap:                         ; 0x81B7  E600 via editor_spawn; E261=7 → secret (obj2)
	call edit_cursor2
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld hl,0e267h
	jp z,l82b1h
	ld a,(0e261h)
	cp 007h                       ; editor tool 7 = secret entrance (obj2 / 0xE7C0)
	jp z,l83a5h
	ld a,(hl)
	cp 010h
	ret nc
	push hl
	call d823e_jp_end
	pop hl
	ret z
	inc (hl)
	ld hl,0e600h
l81deh:
	ld a,(hl)
	and a
	jr z,editor_spawn
	ld a,010h
	call ADD_HL_A
	jr l81deh
editor_spawn:                     ; 0x81E9  empty E600 slot; type from put_trap E261 (names_terrain)
	push hl
	pop ix
	ld b,010h
l81eeh:
	ld (hl),000h
	inc hl
	djnz l81eeh
	ld a,(0e261h)
	ld b,a
	dec b
	cp 004h
	jr nc,l8203h
	cp 002h
	ld b,001h
	jr c,l8203h
	inc b
l8203h:
	ld a,b
	ld (ix+000h),a
	call edit_xy
	ld (ix+002h),e
	ld (ix+003h),d
	call edit_screen
	ld (ix+004h),a
	ld (ix+009h),a
	call edit_place
	call edit_screen
	ld c,a
	ld ix,0e600h
	ld b,010h
l8226h:
	push bc
	ld a,(ix+004h)
	cp c
	jr nz,l8234h
	ld a,(ix+000h)
	and a
	call nz,edit_draw
l8234h:
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l8226h
	ret
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
	ld ix,0e600h
	ld b,010h
l8251h:
	ld a,(ix+000h)
	and a
	jr z,l825bh
	call actor_at
	ret z
l825bh:
	ld de,00010h
	add ix,de
	djnz l8251h
	ld a,001h
	and a
	ret
stamp_coffin:                     ; 0x8266  editor preview: coffin facing
	ld a,(ix+007h)
	and 002h
	ld a,003h
	jr nz,l8270h
	xor a
l8270h:
	ld (ix+005h),a
	ld hl,l9374h
	ld de,l9374h
	ld bc,l9374h
	jp 0bb63h
stamp_pyoncy:                     ; 0x827F  editor preview: pyoncy
	ld a,(ix+007h)
	rra
	rra
	ld hl,l937ch
	ld de,l9384h
	ld bc,l938ch
	jp nc,0bb63h
	ld hl,09394h
	ld de,l939ch
	ld bc,l93a4h
	jp 0bb63h
stamp_rock:                       ; 0x829C  editor preview: rock-roll row
	ld e,(ix+002h)
	ld d,(ix+003h)
	ld b,(ix+008h)
l82a5h:
	ld a,0feh
	call 0576ah
	ld a,e
	add a,008h
	ld e,a
	djnz l82a5h
	ret
l82b1h:
	ld a,(0e261h)
	cp 007h                       ; editor tool 7 = secret entrance
	jp z,l8435h
	ld a,(hl)
	and a
	ret z
	ld ix,0e600h
	ld b,010h
l82c2h:
	ld a,(ix+000h)
	and a
	jr z,l82d0h
	push hl
	call actor_at
	call z,edit_erase
	pop hl
l82d0h:
	ld de,00010h
	add ix,de
	djnz l82c2h
	ret
edit_erase:                     ; 0x82D8  clear actor at IX; stamp floor
	ld a,(ix+000h)
	ld (ix+000h),000h
	dec (hl)
	ld hl,082f2h
	call ADD_HL_A
	ld c,(hl)
	ld b,(ix+008h)
	call edit_xy
	ld hl,l86c5h
	jp 05737h
	ld (bc),a
	ld (bc),a
	ld bc,00204h
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
edit_place:                     ; 0x830C  DISPATCH_A on E261 (editor tool)
	ld a,(0e261h)
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
l8325h:
	ld (ix+005h),c
	ld (ix+007h),a
	call edit_vscan
	ld (ix+008h),c
	dec c
	ret nz
	ld (ix+000h),000h
	ld hl,0e267h
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
	jp l8325h
place_coffin_rl:                  ; 0x834D
	ld c,003h
	jr l8353h
place_pyoncy_rl:                  ; 0x8351
	ld c,000h
l8353h:
	ld a,002h
	ld b,003h
	jr l8325h
edit_vscan:                     ; 0x8359  walk DE down; count free map cells
	ld c,001h
	call edit_xy
l835eh:
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
	djnz l835eh
	ret
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
l839ch:
	rlca
	rlca
	djnz l839ch
	and 003h
	cp 002h
	ret
l83a5h:
	ld hl,0e26ch
	ld a,(hl)
	cp 010h
	ret nc
	push hl
	call secret_free
	pop hl
	ret z
	inc (hl)
	ld hl,0e7c0h
l83b6h:
	ld a,(hl)
	and a
	jr z,l83c1h
	ld a,004h
	call ADD_HL_A
	jr l83b6h
l83c1h:
	ld d,h
	ld e,l
	ld b,004h
	xor a
l83c6h:
	ld (de),a
	inc de
	djnz l83c6h
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
	ld c,001h
	ld ix,0e7c0h
	ld b,010h
l83ebh:
	push bc
	call edit_screen
	cp (ix+000h)
	call z,secret_stamp
	ld bc,00004h
	add ix,bc
	pop bc
	djnz l83ebh
	ret
secret_stamp:                   ; 0x83FE  stamp ix+3 count of door tiles
	ld a,(ix+003h)
	and 01fh
	ld b,a
	ld d,(ix+002h)
	ld e,(ix+001h)
l840ah:
	push de
	push bc
	ld a,c
	and a
	call 07fa4h
	pop bc
	pop de
	ld a,e
	add a,008h
	ld e,a
	djnz l840ah
	ret
secret_free:                    ; 0x841A  Z if E7C0 slot at editor XY
	ld ix,0e7c0h
	ld b,010h
l8420h:
	ld a,(ix+000h)
	and a
	jr z,l842ah
	call secret_at
	ret z
l842ah:
	ld de,00004h
	add ix,de
	djnz l8420h
	ld a,001h
	and a
	ret
l8435h:
	ld a,(0e26ch)
	and a
	ret z
	ld ix,0e7c0h
	ld b,010h
l8440h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l844dh
	call secret_at
	call z,secret_erase
l844dh:
	ld bc,00004h
	add ix,bc
	pop bc
	djnz l8440h
	ret
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
secret_erase:                   ; 0x846A  clear secret rec; stamp floor
	ld hl,0e26ch
	dec (hl)
	ld (ix+000h),000h
	ld c,000h
	jp secret_stamp
put_tool:                         ; 0x8477  E300 map tool; type=E261+1 (names_tools 1-6)
	call edit_cursor
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld hl,0e268h
	jr z,l84b8h
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
	ld hl,0e300h
l849ah:
	ld a,(hl)
	and a
	jr z,l84a5h
	ld a,008h
	call ADD_HL_A
	jr l849ah
l84a5h:
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
	jr l84ddh
l84b8h:
	ld a,001h
	ld (0efd0h),a
	ld a,(hl)
	and a
	ret z
	ld hl,0e300h
	ld b,040h
l84c5h:
	push bc
	ld a,(hl)
	and a
	jr z,l84d4h
	push hl
	call tool_at
	pop hl
	push hl
	call z,tool_erase
	pop hl
l84d4h:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz l84c5h
	ret
l84ddh:
	call edit_xy
	ld a,(0e261h)
	call tool_tiles
	ld a,(0efd0h)
	and a
	jr z,l84efh
	ld hl,l86c5h
l84efh:
	ld bc,00202h
	push bc
	push de
	call 05737h
	pop hl
	pop bc
	call edit_screen
	ld d,a
	xor a
	jp 063edh
tool_free:                      ; 0x8501  Z if E300 slot at editor XY
	ld hl,0e300h
	ld b,040h
l8506h:
	ld a,(hl)
	and a
	jr z,l8510h
	push hl
	call tool_at
	pop hl
	ret z
l8510h:
	ld a,008h
	call ADD_HL_A
	djnz l8506h
	ld a,001h
	and a
	ret
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
tool_erase:                     ; 0x852E  clear E300 rec; dec E268
	ld (hl),000h
	ld hl,0e268h
	dec (hl)
	jp l84ddh
tool_tiles:                     ; 0x8537  HL = 9328 + A*4 tool stamp
	ld hl,l9328h
	add a,a
	add a,a
	jp ADD_HL_A
put_gem:                          ; 0x853F  E700 soul stone (max 16)
	call edit_cursor
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld a,001h
	jr nz,l8550h
	ld a,000h
l8550h:
	ld (0efd0h),a
	ld hl,0e269h
	jr z,l857ch
	ld a,(hl)
	cp 010h
	ret nc
	ld a,(hl)
	inc (hl)
	ld hl,0e700h
l8561h:
	ld a,(hl)
	and a
	jr z,l856ch
	ld a,008h
	call ADD_HL_A
	jr l8561h
l856ch:
	ld (hl),001h
	inc hl
	call edit_screen
	ld (hl),a
	inc hl
	call edit_xy
	ld (hl),e
	inc hl
	ld (hl),d
	jr l85b3h
l857ch:
	ld a,(hl)
	and a
	ret z
	ld hl,0e700h
	ld b,010h
l8584h:
	push bc
	ld a,(hl)
	and a
	jr z,l8593h
	push hl
	call gem_at
	pop hl
	push hl
	call z,gem_erase
	pop hl
l8593h:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz l8584h
	ret
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
gem_erase:                      ; 0x85AD  clear E700 rec; stamp floor
	ld (hl),000h
	ld hl,0e269h
	dec (hl)
l85b3h:
	call edit_xy
	ld a,(0efd0h)
	and a
	ld hl,l9324h
	jr nz,l85c2h
	ld hl,l86c5h
l85c2h:
	ld bc,00202h
	push bc
	push de
	call 05737h
	pop hl
	pop bc
	call edit_screen
	ld d,a
	xor a
	jp 063edh
put_exit:                         ; 0x85D4  E2F1 exit door / E26A placed
	call edit_cursor
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	jr z,l8616h
	ld a,(0e26ah)
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
	ld (0e26ah),a
	call edit_xy
	ld hl,l9340h
l8604h:
	ld bc,00404h
	push de
	push bc
	call 05737h
	pop bc
	pop hl
	call edit_screen
	ld d,a
	xor a
	jp 063edh
l8616h:
	call exit_undraw
	call exit_clear
	xor a
	ld (0e26ah),a
	ret
exit_undraw:                    ; 0x8621  erase exit tiles if this screen
	ld hl,0e2f3h
	call edit_screen
	cp (hl)
	ret nz
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)
	ld hl,l86c5h
	jp l8604h
exit_clear:                     ; 0x8633  zero E2F0..E2F7
	ld hl,0e2f0h
	ld de,0e2f1h
	ld bc,00007h
	ld (hl),000h
	ldir
	ret
	ld hl,0e800h
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
	ld a,(0e203h)
	and 008h
	ld a,007h
	jr z,l8661h
	xor a
l8661h:
	ld hl,0d200h
	jp cc_fill
cont_esc:                         ; 0x8667  GRAPH/ESC or after place -> E25A=5 (cont_edit)
	ld a,(0e20ch)
	rla
	rla
	jr c,l8676h
	call io_menu
	ld a,(0e25bh)
	and a
	ret nz
l8676h:
	ld hl,00005h
	ld (0e25ah),hl
	ret
edit_legend:                      ; 0x867D  print_legend + 6x6 E788 map
	ld a,001h
	call draw_minimap
	call page_bank_d
	ld hl,0bc54h                  ; print_legend
	call print_stream
	call page_banks_123
	ld de,0a090h
	ld hl,0e788h
	ld bc,00606h
l8697h:
	push de
	push bc
	ld b,c
l869ah:
	ld a,(hl)
	and a
	ld c,0ffh
	jr z,l86a3h
	add a,0d0h
	ld c,a
l86a3h:
	ld a,c
	call 05207h
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz l869ah
	pop bc
	pop de
	ld a,e
	add a,008h
	ld e,a
	inc hl
	inc hl
	djnz l8697h
	ret
l86b9h:
	ld l,b
	dec bc
	ld c,h
	ld l,b
	ld a,(bc)
	ld b,a
	adc a,b
	ld a,(bc)
	ld b,a
	ret nz
	rlca
	ld c,c
l86c5h:
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ret po
	ld hl,0e21ch
	ld de,0e207h
	ld bc,0e208h
	ld a,(hl)
	cp 02dh
	jr nc,l86f6h
	ld a,(de)
	and 00fh
	jr nz,l8705h
	ld a,(bc)
	and a
	jr z,l8705h
	inc (hl)
	ret
l86f6h:
	ld a,(bc)
	and a
	jr z,l8705h
	inc hl
	inc (hl)
	ld a,(hl)
	cp 005h
	ret nz
	ld (hl),000h
	ld a,(bc)
	ld (de),a
	ret
l8705h:
	ld (hl),000h
	ret
edit_cursor2:                   ; 0x8708  cursor with 2x1 / 2x2 step
	exx
	ld a,(0e261h)
	ld bc,00201h
	cp 004h
	jr c,l871fh
	ld c,002h
	cp 006h
	jr z,l871fh
	jr l871ch
edit_cursor:                    ; 0x871B  stick moves E264/E265 in E27C box
	exx
l871ch:
	ld bc,00101h
l871fh:
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
	ld a,(0e207h)
	rra
	jr c,l8757h
	rra
	jr c,l8769h
	rra
	jr c,l8778h
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
l8757h:
	call sfx_32                   ; cursor
	ld a,(hl)
	exx
	sub c
	exx
	ld (hl),a
	rla
	jr c,l8766h
	exx
	cp e
	exx
	ret nc
l8766h:
	ld (hl),c
	dec (hl)
	ret
l8769h:
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
l8778h:
	call sfx_32                   ; cursor
	ex de,hl
	ld a,(hl)
	exx
	sub b
	exx
	ld (hl),a
	rla
	jr c,l8788h
	exx
	cp d
	exx
	ret nc
l8788h:
	ld (hl),b
	dec (hl)
	ret
secret_draw:                    ; 0x878B  each E7C0 rec -> secret_rect
	ld hl,0e7c0h
	ld b,010h
l8790h:
	push bc
	ld a,(hl)
	and a
	push hl
	call nz,secret_rect
	pop hl
	pop bc
	ld a,004h
	call ADD_HL_A
	djnz l8790h
	ret
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
	jp 063edh
	ld hl,0e788h
	ld bc,03001h
	xor a
	ld (0efc0h),a
	ld (0efc1h),a
l87c2h:
	ld a,(hl)
	cp c
	jr nz,l87d3h
	push hl
	push bc
	call link_scan
	pop bc
	pop hl
	inc c
	ld a,c
	cp 007h
	jr nc,l87d6h
l87d3h:
	inc hl
	djnz l87c2h
l87d6h:
	ld a,(0efc0h)
	ld hl,0ed80h
	ld de,0ed90h
	call link_ff
	ld a,(0efc1h)
	ld hl,0eda0h
	ld de,0edb0h
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
	jr nz,l8819h
	push hl
	push bc
	ld bc,0ed80h
	ld de,0ed91h
	call link_ud
	ld hl,0efc0h
	inc (hl)
	pop bc
	pop hl
l8819h:
	ld a,b
	and a
	ret nz
	ld bc,0eda0h
	ld de,0edb1h
	call link_lr
	ld hl,0efc1h
	inc (hl)
	ret
link_ud:                        ; 0x882A  fill up/down link words
	ld a,(0efc0h)
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
l8839h:
	ld a,l
	add a,008h
	ld l,a
	ld a,(hl)
	and a
	jr nz,l8839h
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
l885ch:
	inc hl
	ld a,(hl)
	and a
	jr nz,l885ch
	dec hl
	ld a,l
	sub 088h
	inc bc
	ld (bc),a
	dec de
	ld (de),a
	ret
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
	jr z,l8887h
	ld c,05eh
l8887h:
	push bc
	push hl
	ld a,(hl)
	ld b,008h
l888ch:
	rla
	push af
	ld a,c
	call c,tile_pset
	ld a,d
	add a,008h
	ld d,a
	jr nc,l889ch
	ld a,e
	add a,008h
	ld e,a
l889ch:
	pop af
	djnz l888ch
	pop hl
	inc hl
	pop bc
	djnz l8887h
	call page_banks_123
	call scr_on
	ret
io_menu:                        ; 0x88AB  DISPATCH_A on E25B (file submenu)
	ld a,(0e25bh)
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
	ld a,(0f0f9h)
	rra
	ld de,06060h
	push af
	jr nc,l88e9h
	ld hl,0be30h
	ld c,0ffh
	push de
	call print_at
	pop de
	ld a,e
	add a,010h
	ld e,a
l88e9h:
	pop af
	rra
	ld hl,0be3ah
	ld c,0ffh
	call c,print_at
	call page_banks_123
	xor a
	ld (0e26dh),a
	ld (0e26eh),a
	ld (0e27fh),a
	ld (0e21eh),a
io_step:                        ; 0x8903  inc E25B
	ld hl,0e25bh
	inc (hl)
	ret
pwd_spaces:                     ; 0x8908  0 in E270.. -> space
	ld hl,0e270h
	ld b,00bh
l890dh:
	ld a,(hl)
	and a
	jr nz,l8913h
	ld (hl),020h
l8913h:
	inc hl
	djnz l890dh
	ret
io_dev_keys:                      ; 0x8917  stick: pick tape/disk/sram
	call io_dev_sat
	ld hl,0e26dh
	ld a,(0e207h)
	rra
	jr c,l8973h
	rra
	jr c,l8960h
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
	ld a,(0f0f8h)
	ld hl,0be26h
	and a
	jr z,l894fh
	ld hl,0be30h
	dec a
	jr z,l894fh
	ld hl,0be3ah
l894fh:
	ld de,05848h
	ld c,0ffh
	call print_at
	ld hl,0be82h
	call print_stream
	jp page_banks_123
l8960h:
	ld a,(0f0f9h)
	and a
	ret z
	cp 003h
	ld b,002h
	jr z,l896ch
	dec b
l896ch:
	ld a,(hl)
	cp b
	ret nc
	inc (hl)
	jp sfx_32
l8973h:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
io_dev_sat:                       ; 0x897A  cursor SAT for tape/disk/sram
	ld hl,0e800h
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
sat_col:                          ; 0x898E  SAT CC=8; MSX2 0xD200 fill
	ld (hl),008h
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,0d200h
	ld de,0d201h
	ld bc,00010h
	ld (hl),007h
	ldir
	ret
l89a3h:
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
	ld (0f0e5h),a
	jp io_step
io_set_dev:                       ; 0x89CD  E26D → F0F8 (tape/disk/sram)
	ld a,(0e26dh)
	ld b,a
	ld a,(0f0f9h)
	and a
	jr z,l89e4h
	cp 003h
	jr z,l89e4h
	dec a
	jr z,l89e4h
	ld a,b
	and a
	jr z,l89e4h
	ld b,002h
l89e4h:
	ld a,b
	ld (0f0f8h),a
	ret
io_save_yn:                       ; 0x89E9  GRAPH/ESC then name or catalog
	call yn_keys
	and a
	ret z
	dec a
	jp nz,l8b50h
	ld a,0e0h
	ld a,(0edeeh)
	call scr_reset
	ld a,(0f0f8h)
	cp 002h
	jr z,l89a3h
	xor a
	call draw_minimap
	call io_step
	call page_bank_d
	ld hl,0bde9h
	call print_stream
	call page_banks_123
pwd_print8:                     ; 0x8A14  8 glyphs at E270 from 6058
	ld de,06058h
	ld hl,0e270h
print_name:                     ; 0x8A1A  B glyphs at HL; +0xA0 stamp
	ld b,008h
l8a1ch:
	push bc
	ld a,(hl)
	cp 020h
	ld b,000h
	jr z,l8a27h
	add a,0a0h
	ld b,a
l8a27h:
	ld a,b
	push hl
	push de
	call 0576ah
	pop de
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	pop bc
	djnz l8a1ch
	ret
yn_keys:                        ; 0x8A38  A=2 GRAPH, 1 ESC, 0 none
	ld a,004h
	call 00141h
	cpl
	and 008h
	jr nz,l8a4eh
	ld a,005h
	call 00141h
	cpl
	and 040h
	jr nz,l8a51h
	xor a
	ret
l8a4eh:
	ld a,002h
	ret
l8a51h:
	ld a,001h
	ret
io_enter:                         ; 0x8A54  type filename / password glyphs
	ld a,(0f0f8h)
	cp 002h
	jp z,l8ad1h
l8a5ch:
	call name_sat
	call keys_snap
	call pwd_decode
	ld a,(0ededh)
	and a
	jr z,l8a8dh
	cp 0e0h
	ld b,0a0h
	jr nz,l8a73h
	ld b,0c0h
l8a73h:
	sub b
	ld b,a
	ld hl,0e26eh
	ld a,(hl)
	cp 007h
	jr nc,l8a83h
	push af
	call sfx_32                   ; cursor
	pop af
	inc (hl)
l8a83h:
	ld hl,0e270h
	call ADD_HL_A
	ld (hl),b
	call pwd_print8
l8a8dh:
	ld a,(0e207h)
	rra
	rra
	rra
	jr c,l8ab1h
	rra
	jr c,l8aa6h
	ld a,(0e20ch)
	rla
	ret nc
	call sat_wipe
	call sfx_01                   ; stop
	jp io_step
l8aa6h:
	ld hl,0e26eh
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp sfx_32
l8ab1h:
	ld hl,0e26eh
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
name_sat:                       ; 0x8ABB  filename cursor SAT
	ld hl,0e800h
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
l8ad1h:
	call 08b07h
	ret nc
l8ad5h:
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	ld hl,file_name
	call ADD_HL_A
	ld de,0e270h
	ld bc,00008h
	ldir
	call sfx_01                   ; stop
	jp io_step
; BLOCK 'file_name' (start 0x8aef end 0x8b06)  8-byte slots; FILE3 7 bytes
file_name:
	defb "FILE1   "
	defb "FILE2   "
	defb "FILE3  "                ; 8th byte is the jr
	jr nz,l8ad5h
	inc l
	adc a,e
io_file_keys:                     ; 0x8B0A  stick left/right on E26E
	ld hl,0e26eh
	ld a,(0e207h)
	rra
	jr c,l8b1fh
	rra
	jr c,l8b24h
	rra
	rra
	rra
	ret c
	ld a,(0e20ch)
	rla
	ret
l8b1fh:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	ret
l8b24h:
	ld a,(0f0e5h)
	dec a
	cp (hl)
	ret z
	inc (hl)
	ret
	ld hl,0e800h
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
l8b46h:
	call sfx_11                   ; title cursor
	ld a,(0e27fh)
	cp 002h
	jr z,l8b57h
l8b50h:
	xor a
	ld (0e25bh),a
	jp scr_reset
l8b57h:
	ld a,(0f0f8h)
	dec a
	jr z,l8b6fh
	call sat_wipe
	call scr_reset
	call page_bank_d
	ld hl,0be6ah
	call print_stream
	call page_banks_123
l8b6fh:
	jp io_step
io_save:                          ; 0x8B72  save via tape/disk/sram
	ld a,(0f0f8h)
	or a
	jr z,l8b7fh
	dec a
	jp z,l9c20h
	jp 06c3dh
l8b7fh:
	call page_bank_c
	call 0bf2bh
	jp page_banks_123
io_go:                            ; wait any key, E25B=1
	ld a,(0e207h)
	and a
	ret z
	ld a,001h
	ld (0e25bh),a
	jp scr_reset
io_tick:                          ; 0x8B95  continue/file I/O: E25B-1 -> d_8b99
	ld a,(0e25bh)
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
	call 07969h
io_next:                          ; 0x8BC5  inc E25B
	ld hl,0e25bh
	inc (hl)
	ret
io_yn:                            ; 0x8BCA  E26D 0/1; fire yes -> io_mode, no -> E25B=0
	call io_yn_sat
	ld hl,0e26dh
	ld a,(0e207h)
	ld b,a
	and 003h
	jr z,l8bdfh
	ld a,(hl)
	xor 001h
	ld (hl),a
	jp sfx_32
l8bdfh:
	ld a,b
	and 010h
	ret z
	ld a,(hl)
	and a
	jr nz,l8c2eh
io_mode:                          ; 0x8BE7  "| load mode |" + tape/disk/sram
	call scr_reset
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0bdb9h                  ; "| load mode |" / "tape load"
	call print_stream
	call page_banks_123
	ld a,(0f0f9h)
	rra
	ld de,06060h
	push af
	jr nc,l8c18h
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
l8c18h:
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
l8c2eh:
	xor a
	ld (0e25bh),a
	ret
io_yn_sat:                        ; 0x8C33  yes/no cursor SAT
	ld hl,0e800h
	ld a,(0e26dh)
	and a
	ld a,058h
	jr z,l8c40h
	ld a,068h
l8c40h:
	ld (hl),a
	inc hl
	ld (hl),068h
	inc hl
	ld (hl),014h
	inc hl
	call sat_col
	ret
l8c4ch:
	ld a,001h
	ld (0e25bh),a
	ret
io_dev:                           ; 0x8C52  pick tape/disk/sram -> F0F8
	ld a,(0e20ch)
	rla
	rla
	jr c,l8c4ch
	call io_dev_sat
	ld hl,0e26dh
	ld a,(0e207h)
	rra
	jr c,l8c8eh
	rra
	jr c,l8c7bh
	rra
	rra
	rra
	ret nc
	call io_set_dev
	call sat_wipe
	call scr_reset
	call io_next
	jp sfx_01
l8c7bh:
	ld a,(0f0f9h)
	and a
	ret z
	cp 003h
	ld b,002h
	jr z,l8c87h
	dec b
l8c87h:
	ld a,(hl)
	cp b
	ret nc
	inc (hl)
	jp sfx_32
l8c8eh:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
io_name:                          ; 0x8C95  F0F8: tape name / disk catalog / sram files
	ld a,(0f0f8h)
	dec a
	jp z,l8d31h
	dec a
	jr z,l8cb5h
	xor a
	call draw_minimap
	call page_bank_d
	ld hl,0bde9h
	call print_stream
	call page_banks_123
	call sfx_11                   ; title cursor
	jp io_next
l8cb5h:
	call 06e2dh
	ld a,(0f0e5h)
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
l8cd6h:
	ld a,(hl)
	and a
	jr z,l8cedh
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
l8cedh:
	ld a,008h
	call ADD_HL_A
	djnz l8cd6h
	call io_next
	jp sfx_11
print_mode:                     ; 0x8CFA  tape/disk/sram stream from A-'1'
	sub 031h
	and a
	jr z,l8d0ah
	dec a
	jr z,l8d12h
	ld hl,0be56h
	ld c,0ffh
	jp print_at
l8d0ah:
	ld hl,0be46h
	ld c,0ffh
	jp print_at
l8d12h:
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
	ld (0e25bh),a
	jp sfx_11
l8d31h:
	call dos_dir
	ld a,(0f0e5h)
	and a
	jr z,io_nofile
	call io_next
	call sfx_11                   ; title cursor
file_list:                      ; 0x8D40  draw EE50 catalog names
	call scr_reset
	ld a,001h
	call draw_minimap
	call page_bank_d
	ld hl,0bd86h
	call print_stream
	call page_banks_123
	ld hl,0ee50h
	ld de,03020h
	ld b,008h
l8d5ch:
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
	djnz l8d5ch
	ret
io_pick:                          ; 0x8D87  cursor on EE50 files; M=next, RET=load
	ld a,(0e20ch)
	rla
	rla
	jp c,l8c4ch
	ld a,(0f0f8h)
	and a
	jp z,l8a5ch
	dec a
	jp nz,l8e5ah
	ld a,(0e207h)
	and 020h
	jr nz,l8defh
	call io_pick_sat
	ld a,(0f0e5h)
	ld b,a
	ld hl,0e26eh
	ld a,(0e207h)
	rra
	jr c,l8e11h
	rra
	jr c,l8e1ah
	rra
	jr c,l8e24h
	rra
	jr c,l8e2eh
	ld a,(0e20ch)
	rla
	ret nc
	ld a,(hl)
	and a
	jr z,l8dc9h
	ld b,a
	xor a
l8dc5h:
	add a,00bh
	djnz l8dc5h
l8dc9h:
	ld hl,0ee50h
	call ADD_HL_A
	ld de,0e270h
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
l8defh:
	call sfx_01                   ; stop
	ld a,008h
l8df4h:
	ld (0e25bh),a
	ret
io_list:                          ; 0x8DF8  catalog; continue -> io_pick, title -> edit_gfx
	call dos_dir
	call file_list
	xor a
	ld (0e26eh),a
	call sfx_11                   ; title cursor
	ld a,(0e200h)
	cp 00bh
	ld a,005h
	jr z,l8df4h
	dec a
	jr l8df4h
l8e11h:
	ld a,(hl)
	cp 002h
	ret c
	dec (hl)
	dec (hl)
	jp sfx_32
l8e1ah:
	ld a,(hl)
	inc a
	inc a
	cp b
	ret nc
	inc (hl)
	inc (hl)
	jp sfx_32
l8e24h:
	ld a,(hl)
	rra
	ret nc
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp sfx_32
l8e2eh:
	ld a,(hl)
	rra
	ret c
	ld a,(hl)
	inc a
	cp b
	ret nc
	inc (hl)
	jp sfx_32
io_pick_sat:                      ; 0x8E39  file-list cursor SAT
	ld de,0e26eh
	ld hl,0e800h
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
	jr nc,l8e51h
	ld a,088h
l8e51h:
	ld (hl),a
	inc hl
	ld (hl),014h
	inc hl
	call sat_col
	ret
l8e5ah:
	call 08b07h
	ret nc
	ld hl,0e270h
	ld de,0e271h
	ld bc,00007h
	ld (hl),020h
	ldir
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	ld hl,0ee50h
	call ADD_HL_A
	ld de,0e270h
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
	ld a,(0e27fh)
	cp 002h
	jp z,io_next
	call scr_reset
	xor a
	ld (0e25bh),a
	ret
io_do_load:                       ; 0x8EA3  F0F8 → tape/disk/sram load
	ld a,(0f0f8h)
	or a
	jr z,l8eb0h
	dec a
	jp z,l9b98h
	jp 06c55h
l8eb0h:
	call page_bank_c
	call 0be7eh
	jp page_banks_123
io_done:                          ; 0x8EB9  wait key; E27E=2, E25B=0
	ld a,(0e207h)
	and a
	ret z
	ld a,002h
	ld (0e27eh),a
	call scr_reset
	xor a
	ld (0e25bh),a
	ret
disk_init:                        ; 0x8ECB  file_blit + E25B=1 (disk/editor)
	call file_blit
	call sat_wipe
	xor a
	ld (0e24ah),a
	inc a
	ld (0e25bh),a
	ret
disk_tick:                        ; 0x8EDA  E25B-1 -> d_8ede
	ld a,(0e25bh)
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
	ld (0e241h),a
	call load_world_gfx
	ld a,(0f0f4h)
	and a
	call nz,pal_15
	call rle_minimap
	call ram_wipe
	call 07969h
	jp io_mode
ram_wipe:                       ; 0x8F0C  clear E226 and E280 work RAM
	xor a
	ld hl,0e226h
	ld de,0e227h
	ld bc,00032h
	ld (hl),a
	ldir
	ld hl,0e280h
	ld de,0e281h
	ld bc,00d7fh
	ld (hl),a
	ldir
	ld (0e26dh),a
	ld (0e26eh),a
	ld (0e27fh),a
	ld (0e26fh),a
	ld (0e27eh),a
	jp sat_wipe
edit_gfx:                         ; 0x8F37  reload world gfx
	call edit_reset
	jp io_next
edit_play:                        ; 0x8F3D  enter play (E24A=1, E254=1)
	call io_do_load
	ld a,(0e27fh)
	and a
	jp nz,io_next
	call screen_idx
	call vic_reset
	call e300_list
	call secret_draw
	ld a,001h
	ld (0e24ah),a
	ld (0e254h),a
	ld a,(0e282h)
	or a
	ret nz
	ld (0e294h),a
	ret
edit_key:                         ; 0x8F64  wait key, E24A=2
	ld a,(0e207h)
	and a
	ret z
	call scr_reset
	ld a,002h
	ld (0e24ah),a
	ret
edit_reset:                     ; 0x8F72  reload pats; clear E2C0; world 1
	call pat_15
	call col_15
	call vic_pat_far
	xor a
	ld hl,0e2c0h
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),a
	ldir
	ld (0e287h),a
	ld (0edcdh),a
	inc a
	ld (0e241h),a
	call sat_wipe
	ret
load_exit:                        ; 0x8F96  b8f8_tbl[level] -> E2F1 exit door
	call page_bank_d
	ld a,(0e242h)
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
probe_exit:                       ; 0x8FBE  all gems + Vic at door -> E257=0, mode_clear
	ld hl,0e2f3h
	ld a,(0e243h)
	cp (hl)
	ret nz
	ld a,(0e2f5h)
	and a
	ret nz
	ld a,(0e282h)
	ld b,a
	ld a,(0e284h)
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
	ld hl,0e257h
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
	call 05687h
	xor a
	ld (0e21bh),a
	call 0723dh
	ld bc,00007h
	jp WRTVDP
draw_exit:                        ; 0x9010  exit-door metatile if this is its screen
	ld a,(0e2f3h)
	ld b,a
	ld a,(0e243h)
	cp b
	ret nz
	ld hl,l9340h
	ld a,(0e2f6h)
	add a,a
	add a,a
	add a,a
	add a,a
	call ADD_HL_A
	ld bc,00404h
	ld de,(0e2f1h)
l902dh:
	push bc
	push de
	ld b,c
l9030h:
	ld a,(hl)
	push hl
	call tile_pset
	pop hl
	inc hl
	ld a,d
	add a,008h
	ld d,a
	djnz l9030h
	pop de
	pop bc
	ld a,e
	add a,008h
	ld e,a
	djnz l902dh
	ld de,(0e2f4h)
	ld a,d
	and a
	ret z
	call page_bank_d
	ld a,e
	ld hl,0b9adh                  ; exit-door metatile by shape
	call tbl_word
	ld b,d
l9057h:
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
	jr z,l9073h
	ld a,0aeh
l9073h:
	push hl
	call tile_pset
	pop hl
	inc hl
	djnz l9057h
	call page_banks_123
	ret
wipe_tools:                     ; 0x907F  zero E500 and E300; sat_wipe
	ld hl,0e500h
	ld de,0e501h
	ld bc,000ffh
	ld (hl),000h
	ldir
	ld hl,0e300h
	ld de,0e301h
	ld bc,001ffh
	ld (hl),000h
	ldir
	call sat_wipe
	jp spr_clear
tools_redraw:                   ; 0x909F  scan EE50 then pack + draw_maptools
	push ix
	call tools_scan
	pop ix
	call tools_pack
	jr draw_maptools
tools_scan:                     ; 0x90AB  each occupied E300: undraw / draw if on-screen
	ld hl,0ee50h
	ld b,040h
l90b0h:
	ld a,(hl)
	or a
	ret z
	call e300_ix
	ld a,(ix+000h)
	or a
	jr z,l90d6h
	and 0f0h
	jr z,l90c7h
	cp 0f0h
	jr nz,l90d6h
	call tool_id
l90c7h:
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,l90d6h
	push hl
	push bc
	call tool_undraw
	pop bc
	pop hl
l90d6h:
	inc hl
	djnz l90b0h
	ret
tool_id:                        ; 0x90DA  ix+0 &= 0x1F (drop in-use nibble)
	ld a,(ix+000h)
	and 01fh
	ld (ix+000h),a
	ret
tool_undraw:                    ; 0x90E3  16x16 HMMM restore under a map tool
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+001h)
	ld d,(ix+002h)
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
draw_maptools:                    ; 0x90F7  E300 on this screen -> tiles
	ld hl,0ee8fh
	ld b,040h
l90fch:
	ld a,(hl)
	or a
	jr z,l9112h
	call e300_ix
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,l9112h
	push bc
	push hl
	call tool_stamp
	pop hl
	pop bc
l9112h:
	dec hl
	djnz l90fch
	ret
tool_stamp:                     ; 0x9116  2x2 tool tiles at ix+1/2
	ld a,(ix+000h)
	or a
	ret z
	and 0f0h
	ret nz
	call tool_save
	ld hl,l9328h
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
tool_save:                      ; 0x913A  16x16 HMMM backup under a map tool
	call tool_vram
	ld (ix+004h),e
	ld (ix+005h),d
	ld l,(ix+001h)
	ld h,(ix+002h)
	ld bc,01010h
	ld a,004h
	jp vdp_hmmm
tool_vram:                      ; 0x9151  E300 slot -> VRAM backup dest DE
	push ix
	pop hl
	ld de,0e300h
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
tools_sat:                        ; 0x916D  E300 in-use -> SAT at E810
	call tools_sat_off
	ld hl,0e300h
	ld de,0e810h
	ld b,040h
l9178h:
	push bc
	push hl
	ld a,(hl)
	and 00fh
	cp 003h
	jr nc,l918dh
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	cp 002h
	call nc,tool_sat2
l918dh:
	pop hl
	ld bc,00008h
	add hl,bc
	pop bc
	djnz l9178h
	ret
tools_sat_off:                  ; 0x9196  park 12 SAT slots at E810 (Y=0xE0)
	ld b,00ch
	ld hl,0e810h
l919bh:
	ld (hl),0e0h
	ld de,00004h
	add hl,de
	djnz l919bh
	ret
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
tool_sat1:                      ; 0x91B2  one E300 slot -> SAT + colour
	ld a,(hl)
	ex af,af'
	ld a,(0e243h)
	inc l
	ldi
	ldi
	cp (hl)
	jr nz,l9214h
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
	ld hl,0d200h
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
l9214h:
	dec de
	dec de
	ld a,0e0h
	ld (de),a
	ret
e300_list:                        ; 0x921A  occupied E300 slots -> 0-term ids at EE50
	ld ix,0e300h
	ld hl,0ee50h
	ld bc,04001h
	ld de,00008h
l9227h:
	ld a,(ix+000h)
	or a
	jr z,l922fh
	ld (hl),c
	inc hl
l922fh:
	inc c
	add ix,de
	djnz l9227h
	ld (hl),000h
	ret
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
	ld hl,0ee50h
	ld (hl),a
	ret
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
l9255h:
	ldi
	ld a,(hl)
	or a
	jr nz,l9255h
	pop af
	ld (de),a
	ret
e300_index:                     ; 0x925E  IX-E300 -> slot index A
	push ix
	pop hl
	ld de,0e300h
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
	ld hl,0ee50h
l9277h:
	cp (hl)
	ret z
	inc hl
	inc c
	jr l9277h
e300_ix:                        ; 0x927D  A = slot id at (HL) -> IX = E300+n*8
	push hl
	call e300_ix_a
	pop hl
	ret
e300_ix_a:                      ; 0x9283  A = 1-based slot -> IX = E300+(A-1)*8
	dec a
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,0e300h
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
load_vic:                         ; 0x929D  clear E280, spawn from 0xB844 + level*3
	ld hl,0e280h
	ld de,0e281h
	ld (hl),000h
	ld bc,00040h
	ldir
	call page_bank_d
	ld a,(0e242h)
l92b0h:
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
l92c2h:
	inc hl
	ld a,(hl)
	ld (0e243h),a
	call page_banks_123
vic_reset:                        ; 0x92CA  pose bytes, walk or hold (E202 bit 6)
	ld hl,vic_pose
	ld de,0e28ah
	ld bc,00008h
	ldir
	ld a,004h
	ld (0e296h),a
	ld a,001h
	ld (0e285h),a
	ld a,(0e202h)
	and 040h
	ld a,00eh                     ; 14 hold if e202 bit 6, else walk
	jr nz,l92e9h
	xor a
l92e9h:
	ld (0e280h),a
	ld a,020h
	ld (0e2a8h),a
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
	ld a,(0e280h)
	cp 004h                       ; vic_die
	jr nz,l9312h
	ld a,004h
	ld (0e285h),a
l9312h:
	ld a,001h
	ld (0e298h),a                 ; die / hit SAT
	ld hl,0e215h
	ld (hl),000h
	ld a,003h
	ld (0e296h),a
	jp vic_die_rle
l9324h:
	xor a
	or b
	or c
	add a,b
l9328h:
	add a,c
	add a,d
	cp h
	cp l
	nop
	nop
	adc a,c
	adc a,d
	add a,(hl)
	add a,a
	cp b
	adc a,b
	cp c
	cp e
	cp d
	add a,e
	or h
	or l
	or (hl)
	add a,h
	or d
	or e
	or a
	add a,l
l9340h:
	ld h,e
	ld h,h
	ld h,l
	ld h,(hl)
	ld h,a
	ld l,b
	ld l,c
	ld l,d
	ld l,e
	ld l,h
	ld l,l
	ld l,(hl)
	ld l,a
	ld (hl),b
	ld (hl),c
	ld (hl),d
	ld h,h
	ld e,b
	ld e,c
	ld h,l
	ld l,b
	ld e,d
	ld e,e
	ld l,c
	ld l,h
	ld e,h
	ld e,l
	ld l,l
	ld (hl),b
	ld a,b
	ld a,b
	ld (hl),c
	ld (hl),e
	ld e,b
	ld e,c
	ld (hl),h
	ld (hl),l
	ld e,d
	ld e,e
	halt
	ld (hl),l
	ld e,h
	ld e,l
	halt
	ld (hl),a
	ld a,b
	ld a,b
	ld a,c
l9370h:
	ld e,a
	ld h,b
	ld h,c
	ld h,d
l9374h:
	adc a,e
	adc a,h
	adc a,l
	adc a,(hl)
	sub d
	sub c
	sub b
	adc a,a
l937ch:
	cp (hl)
	nop
	sub l
	pop bc
	ld a,d
	ld a,e
	sub l
	pop bc
l9384h:
	cp a
	nop
	sub (hl)
	pop bc
	ld a,h
	ld a,l
	sub (hl)
	pop bc
l938ch:
	ret nz
	nop
	sub a
	jp 07f7eh
	sub a
	jp 0c400h
	rst 0
	sbc a,b
	ld a,d
	ld a,e
	rst 0
	sbc a,b
l939ch:
	nop
	push bc
	ret z
	sbc a,c
	ld a,h
	ld a,l
	ret z
	sbc a,c
l93a4h:
	nop
	add a,0c9h
	sbc a,d
	ld a,(hl)
	ld a,a
	ret
	sbc a,d
	sbc a,e
	sbc a,h
	sbc a,l
	sbc a,(hl)
	sbc a,a
	and b
	and c
	and d
	and e
	and h
	and l
	and (hl)
	and a
	xor b
	xor c
	xor d
	xor e
	xor h
nudge_stones:                     ; 0x93BE  if entered from U/D, bump type-5 stones
	ld a,(0e2f9h)
	cp 003h
	ret c
	ld ix,0e600h
	ld b,010h
l93cah:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_clamp
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l93cah
	ret
stone_clamp:                    ; 0x93DC  clamp stone X to 0x10..0xE0
	ld a,(ix+003h)
	cp 010h
	jr nc,l93e9h
	ld (ix+003h),010h
	jr l93f0h
l93e9h:
	cp 0e8h
	ret c
	ld (ix+003h),0e0h
l93f0h:
	jp l95a1h
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
	jr nc,l940eh
	ld a,002h
	ld (ix+001h),a
	dec a
	ld (ix+006h),a
	ret
l940eh:
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(0e280h)
	and a
	ret nz
	ld a,(0e282h)
	add a,00fh
	sub (ix+002h)
	cp 010h
	jr nc,l9464h
	ld a,(0e294h)
	and a
	ld a,(0e284h)
	ld b,(ix+003h)
	jr z,l944ch
	add a,014h
	sub b
	cp 008h
	jr nc,l9464h
	ld a,(0e208h)
	and 008h
	jr z,l9464h
	dec (ix+006h)
	ret nz
	res 1,(ix+007h)
l9448h:
	inc (ix+001h)
	ret
l944ch:
	sub 00ch
	sub b
	cp 008h
	jr nc,l9464h
	ld a,(0e208h)
	and 004h
	jr z,l9464h
	dec (ix+006h)
	ret nz
	set 1,(ix+007h)
	jr l9448h
l9464h:
	ld (ix+006h),00ah
	ret
stone_push:                       ; 0x9469  slide on facing until wall
	bit 1,(ix+007h)
	ld bc,00002h
	jr nz,l9475h
	ld bc,0f003h
l9475h:
	ld a,(ix+003h)
	cp b
	jr z,l94b3h
	call stone_step
	jr nc,l94adh
	bit 1,(ix+007h)
	ld a,(ix+003h)
	ld (ix+00bh),a
	jr nz,l9490h
	add a,008h
	jr l9492h
l9490h:
	sub 008h
l9492h:
	ld (ix+003h),a
	set 0,(ix+007h)
	call sfx_24                   ; stone
	ld l,(ix+002h)
	ld (ix+00ah),l
	call stone_probe
	jr nc,l94adh
	ld (ix+006h),001h
	jr l9448h
l94adh:
	xor a
	ld (ix+001h),a
	jr l9464h
l94b3h:
	set 0,(ix+007h)
	bit 1,(ix+007h)
	ld bc,01004h
	jr z,l94c3h
	ld bc,0e003h
l94c3h:
	push bc
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld (ix+003h),b
	call stone_under
	call stone_write
	pop bc
	call stone_room
	jp l94adh
stone_room:                     ; 0x94DA  move stone onto neighbour screen
	push bc
	call stone_restore
	call stone_slot
	pop bc
	ld b,a
	ld a,c
	call 05e38h
	ld (ix+004h),l
	ret
stone_slot:                     ; 0x94EB  E788 index of stone screen -> A
	ld a,(ix+004h)
	ld hl,0e788h
	ld bc,03000h
l94f4h:
	cp (hl)
	jr z,l94fdh
	inc c
	inc hl
	djnz l94f4h
	ld c,000h
l94fdh:
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
	jr nc,l952eh
	cp 0b0h
	ret nc
	call stone_probe
	ret c
	call sfx_25                   ; thud
	jp l94adh
l952eh:
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld (ix+002h),000h
	call stone_under
	call stone_write
	ld c,002h
	jp stone_room
stone_step:                     ; 0x9543  probe_step_de from stone XY
	call stone_xy
	jp probe_step_de
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
stone_xy:                       ; 0x9564  HL = stone pixel XY; DE = screen map
	ld a,(ix+004h)
	call screen_base
	ld h,(ix+003h)
	ld l,(ix+002h)
	ret
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
	ld de,0e900h
	add hl,de
	ex de,hl
	ret
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
	jp 063edh
l95a1h:
	ld h,(ix+003h)
	ld l,(ix+002h)
	call stone_under
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
	ld h,(ix+003h)
	ld l,(ix+002h)
	call stone_under
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
stone_write1:                   ; 0x9615  two stamp_rect 1x1 from backup
	push hl
	push de
	ld a,(de)
	ld d,(ix+004h)
	ld bc,00101h
	call 063edh
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
	call 063edh
	pop de
	inc de
	ret
draw_stone:                       ; 0x9636  restore underfoot, then 2×2 at l9370h
	call stone_restore
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld d,(ix+003h)
	ld e,(ix+002h)
	call stone_stamp
	ld a,(0e243h)
	cp (ix+009h)
	ret nz
	call stone_save
stamp_stone:                      ; 0x9652  type 5 stone: 2×2 tiles at l9370h
	ld hl,l9370h
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld bc,00202h
	jp draw_tilemap
	call stone_save
	jr stamp_stone
stone_save:                     ; 0x9666  stash XY; copy 16x16 under stone
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld (ix+00bh),h
	ld (ix+00ah),l
	ld a,(0f0f4h)
	and a
	jr nz,l9686h
	call scr5_addr
	push ix
	pop de
	ld a,00ch
	call ADD_DE_A
	jp 05722h
l9686h:
	push ix
	pop de
	ld a,e
	add a,a
	ld d,a
	ld e,040h
	jr nc,l9692h
	ld e,050h
l9692h:
	ld bc,01010h
	ld a,004h
	jp vdp_hmmm
stone_restore:                  ; 0x969A  put 16x16 back at stashed XY
	ld d,(ix+00bh)
	ld e,(ix+00ah)
l96a0h:
	ld a,(0e243h)
	cp (ix+009h)
	ret nz
	push ix
	pop hl
	ld a,(0f0f4h)
	and a
	jr nz,l96bbh
	ld a,00ch
	call ADD_HL_A
	ld bc,00202h
	jp draw_tilemap
l96bbh:
	push ix
	pop hl
	ld a,l
	add a,a
	ld h,a
	ld l,040h
	jr nc,l96c7h
	ld l,050h
l96c7h:
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
stones_redraw:                  ; 0x96CF  each E600 type-5 on this screen
	ld ix,0e600h
	ld b,010h
l96d5h:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_redraw1
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l96d5h
	ret
stone_redraw1:                  ; 0x96E7  one stone: under + save + draw
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	call stone_under
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop hl
	call stone_save
	jp stamp_stone
stones_undraw:                  ; 0x96FF  each E600 type-5: restore tiles
	ld ix,0e600h
	ld b,010h
l9705h:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,stone_undraw1
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l9705h
	ret
stone_undraw1:                  ; 0x9717  one stone restore if this screen
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	call stone_under
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop de
	jp l96a0h
disk_err:                         ; 0x972C  DISKERR (F323); C → disk_err_tbl
	ld l,097h
	push bc
	call dos_leave
	ld a,001h
	ld (0f0e6h),a
	ld a,(0f0e9h)
	ld h,040h
	call 00024h
	pop bc
	ld a,c
	and 00eh
	rrca
	cp 002h
	jr c,l974eh
	cp 006h
	jr c,l9757h
	jr l9753h
l974eh:
	ld c,004h
	rrca
	jr nc,l9759h
l9753h:
	ld c,003h
	jr l9759h
l9757h:
	ld c,000h
l9759h:
	jp disk_print
	ld c,006h
l975eh:
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
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ld a,002h
	ld (0e27fh),a
	ld sp,(0f0e2h)
	ret
l9797h:
	sbc a,c
	sub a
	call dos_leave
	ld a,(0f0e9h)
	ld h,040h
	call 00024h
	call hook_wait
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ld sp,(0f0e2h)
	ret
load_map_tools_far:               ; 0x97B2  page 13, load_map_tools
	call page_bank_d
	call load_map_tools
	jp page_banks_123
load_map_tools:                   ; 0x97BB  afb1_tbl[level-1] -> 0xE300 (64 x 8)
	ld ix,0e300h
	ld hl,0afb1h
	ld a,(0e242h)
	dec a
	call tbl_word
l97c9h:
	call load_tool
	ret z
	ld de,00008h
	add ix,de
	jr l97c9h
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
l9860h:
	ret c
	dec a
	ld (0e2b2h),a
	ret
; Vic cells into software SAT E800.
vic_sat:                          ; 0x9866
	ld a,(0e280h)
	cp 00eh
	jr nz,vic_sat_put
	ld a,(0e2a8h)
	rra
	jr c,vic_sat_put
	ld hl,0e800h
	ld de,0e801h
	ld (hl),0e0h
	ld bc,0000fh
	ldir
	ret
vic_sat_put:                      ; 0x9881  2x2 SAT at Vic Y/X (pause_tick also)
	ld b,000h
	ld hl,0e800h
	ld a,(0e282h)                 ; SAT Y = E282-9
	sub 009h
	ld d,a
	ld a,(0e284h)                 ; SAT X = E284
	ld e,a
	ld a,(0e280h)
	cp 002h
	jr z,l989fh
	ld a,(0e294h)
	or a
	jr z,l989fh
	inc e
	inc e
l989fh:
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
	jr z,l98b9h
	cp 008h
	jr nz,l989fh
	ld a,d
	add a,010h
	ld d,a
	jr l989fh
l98b9h:
	ld hl,0d200h
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
fill_4e:                        ; 0x98D2  15 bytes of 0x4E after inc HL/DE
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),04eh
	ldir
	ret
map_tile_xy:                      ; 0x98DC  2-bit map type at HL (Y=L, X=H); keeps HL
	push hl
	call map_tile
	pop hl
	ret
map_tile:                         ; 0x98E2  type in A; base (0xE250)
	ld de,(0e250h)
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
	jr z,l990ch
l9908h:
	rra
	rra
	djnz l9908h
l990ch:
	pop bc
	and 003h
	ret
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
	jr z,l9970h                   ; 1 down: Y+16
	dec a
	jr z,l997eh                   ; 2 left: X-1
	dec a
	jr z,l9986h                   ; 3 right: X+16
	ld a,h                        ; 0 up: X+2, Y-1
	add a,002h
	ld h,a
	ld a,l
	sub 001h
	ld l,a
	ret nc
	ld l,000h
	ret
l9970h:
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
l997eh:
	ld a,h
	sub 001h
	ld h,a
	ret nc
	ld h,000h
	ret
l9986h:
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
	jr nc,l9998h
	ld a,h
	add a,006h
	ld h,a
	ret
l9998h:
	ld a,l
	add a,006h
	ld l,a
	ret
touch_gems:                       ; 0x999D  Vic overlap E700 -> collect, last gem opens door
	call vic_xy
	ld a,(0e243h)
	ld c,a
	ld b,010h
	ld hl,0e700h
l99a9h:
	ld a,(hl)
	and a
	jr z,l99c4h
	inc l
	ld a,(hl)
	cp c
	jr nz,l99c4h
	inc l
	ld a,(hl)
	sub e
	add a,00ch
	cp 018h
	jr nc,l99c4h
	inc l
	ld a,(hl)
	sub d
	add a,00ch
	cp 018h
	jr c,l99cdh
l99c4h:
	ld a,008h
	add a,l
	and 0f8h
	ld l,a
	djnz l99a9h
	ret
l99cdh:
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
	ld hl,0e2f5h
	dec (hl)
	jr nz,l99f8h
	call sfx_0b                   ; last gem / door open
	xor a
	ld (0e216h),a
	dec a
	ld (0e215h),a
	ld a,010h
	ld (0e21bh),a
l99f8h:
	call sfx_1a                   ; gem
	call draw_exit
	call draw_maptools
	call stones_redraw
	ld de,00500h
	call 04c20h
	ret
vic_xy:                         ; 0x9A0B  Vic pixel Y,X -> DE
	ld a,(0e282h)
	ld e,a
	ld a,(0e284h)
	ld d,a
	ret
probe_pickup:                     ; 0x9A14  walk onto E300 tool -> pickup_tool
	ld a,(0e248h)
	or a
	ret nz
	ld a,(0e287h)
	or a
	ret nz
	ld hl,0ee50h
l9a21h:
	ld a,(hl)
	or a
	ret z
	call e300_ix
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,l9a42h
	ld a,(ix+000h)
	and a
	jr z,l9a42h
	and 0f0h
	jr nz,l9a42h
	push hl
	push bc
	call pickup_box
	pop bc
	pop hl
	jr c,pickup_tool
l9a42h:
	inc hl
	djnz l9a21h
	ret
pickup_box:                     ; 0x9A46  CY if Vic AABB overlaps this E300
	ld a,(0e282h)
	sub (ix+001h)
	jr nc,l9a53h
	neg
	cp 008h
	ret nc
l9a53h:
	cp 00dh
	ret nc
	ld b,000h
	ld a,(0e284h)
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
	ld a,(0e284h)
	sub (ix+002h)
	jr nc,l9a7ch
	neg
l9a7ch:
	cp 00eh
	ret
pickup_left:                      ; 0x9A7F  item left of Vic, dx < 14
	ld a,(0e284h)
	ld b,a
	ld a,(ix+002h)
	sub b
	cp 00eh
	ret
pickup_right:                     ; 0x9A8A  Vic left of item, dx < 14
	ld a,(0e284h)
	sub (ix+002h)
	cp 00eh
	ret
pickup_tool:                      ; 0x9A93  E287 = type, slot |= 0xF0
	push ix
	call stones_undraw
	pop ix
	ld a,(ix+000h)
	and 00fh
	ld (0e287h),a
	or 0f0h
	ld (ix+000h),a
	call sfx_19                   ; pickup
	call tools_redraw
	call stones_redraw
	ret
vic_e500_overlap:                 ; 0x9AB1  active E500 (ix+13 bit 0) -> vic_hit
	ld a,(0e255h)
	and a
	ret nz
	ld a,(0e298h)
	or a
	ret nz
	ld ix,0e500h
	ld b,008h
l9ac1h:
	ld a,(0e243h)
	cp (ix+010h)
	jr nz,l9aebh
	bit 0,(ix+013h)
	jr z,l9aebh
	ld a,(0e282h)
	add a,008h
	sub (ix+003h)
	cp 010h
	jr nc,l9aebh
	ld a,(0e284h)
	add a,00ah
	jr c,l9aebh
	sub (ix+005h)
	jr c,l9aebh
	cp 014h
	jr c,l9af3h
l9aebh:
	ld de,00020h
	add ix,de
	djnz l9ac1h
	ret
l9af3h:
	ld a,005h
	ld (0e280h),a                 ; vic_hit
	call vic_hurt
	jp sfx_28
e300_e500_hit:                    ; 0x9AFE  thrown E500 vs map E300
	ld ix,0e300h
	ld b,040h
l9b04h:
	exx
	ld a,(ix+000h)
	ld c,a
	and 00fh
	dec a
	cp 003h
	jr nc,l9b5bh
	ld a,c
	rrca
	rrca
	rrca
	rrca
	and 00fh
	cp 002h
	jr c,l9b5bh
	ld l,(ix+001h)
	ld h,(ix+002h)
	ld c,(ix+003h)
	ld iy,0e500h
	ld b,008h
l9b2ah:
	ld a,(iy+000h)
	and a
	jr z,l9b54h
	bit 1,(iy+013h)
	jr z,l9b54h
	ld a,c
	cp (iy+010h)
	jr nz,l9b54h
	ld a,l
	add a,00ch
	sub (iy+003h)
	cp 018h
	jr nc,l9b54h
	ld a,(iy+005h)
	sub h
	jr nc,l9b4eh
	neg
l9b4eh:
	cp 00ch
	jr c,l9b64h
	jr l9b54h
l9b54h:
	ld de,00020h
	add iy,de
	djnz l9b2ah
l9b5bh:
	exx
	ld de,00008h
	add ix,de
	djnz l9b04h
	ret
l9b64h:
	push ix
	pop hl
	ld (0e2e8h),hl
	push iy
	pop ix
	ld a,001h
	ld (0edcdh),a
	call clash_clear
	ld de,00100h
	call 04c20h
	call sfx_26                   ; clash
	ret
clash_clear:                    ; 0x9B80  undraw thrown knife/boom on clash
	ld a,(ix+000h)
	cp 004h
	jp z,0b8c5h
	ld hl,06611h
	push hl
	cp 003h
	ret nc
	ld a,(ix+001h)
	cp 002h
	ret nc
	jp e500_undraw
l9b98h:
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
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
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
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
l9c20h:
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
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
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
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
dos_dir:                        ; 0x9CAB  hook DOS; scan directory into D0E5
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	ld (0f0e2h),sp
	call dos_enter
	ld hl,l9797h
	ld (0f323h),hl
	call dos_fcb
	call dir_clear
	xor a
	ld (0d0e5h),a
	call dos_scan
	di
	ld hl,(0d0e7h)
	ld (0f323h),hl
	call dos_leave
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
dos_open:                       ; 0x9CE3  BDOS FOPEN (C=0x0F)
	ld de,(0d0e0h)
	ld c,00fh
	call 0f37dh
	ld c,001h
	inc a
	jp z,l975eh
	ret
dos_create:                     ; 0x9CF3  BDOS FMAKE (C=0x16)
	ld de,(0d0e0h)
	di
	ld c,016h
	call 0f37dh
	ei
	ld c,003h
	inc a
	jp z,l975eh
	ret
dos_close:                      ; 0x9D05  BDOS FCLOSE (C=0x10)
	ld de,(0d0e0h)
	ld c,010h
	call 0f37dh
	ld c,002h
	inc a
	jp z,l975eh
	ret
fcb_clear:                      ; 0x9D15  zero 37 bytes at CE00
	ld hl,0ce00h
	ld de,0ce01h
	ld (hl),000h
	ld bc,00024h
	ldir
	ret
	ld (0d0e0h),hl
fcb_init:                       ; 0x9D26  extent/record fields at D0E0 FCB
	ld hl,(0d0e0h)
	ld bc,0000ch
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
l9d3eh:
	ld (hl),a
	inc hl
	djnz l9d3eh
	ret
dir_clear:                      ; 0x9D43  zero CE50 directory buffer
	ld hl,0ce50h
	ld de,0ce51h
	ld (hl),000h
	ld bc,000afh
	ldir
	ret
fcb_copy:                       ; 0x9D51  HL name -> DE FCB (11+pad)
	ld (0d0e0h),de
	xor a
	ld (de),a
	inc de
	ld bc,0000bh
	ldir
	xor a
	ld b,019h
l9d60h:
	ld (de),a
	inc de
	djnz l9d60h
	ret
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
l9d7ch:
	ld a,(hl)
	or a
	jr nz,l9d83h
	inc hl
	djnz l9d7ch
l9d83h:
	ld c,b
	ld b,000h
	ldir
	ld de,0ce0ch
	xor a
	ld b,019h
	ld (de),a
	inc de
	djnz l9d60h
	ret
dos_write:                      ; 0x9D93  BDOS WRND (C=0x26)
	ld de,(0d0e0h)
	ld c,026h
	call 0f37dh
	ld c,004h
	or a
	jp nz,l975eh
	ret
dos_read:                       ; 0x9DA3  BDOS RDND (C=0x27)
	ld de,(0d0e0h)
	ld c,027h
	call 0f37dh
	ld c,000h
	or a
	jp nz,l975eh
	ret
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
l9dcbh:
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
	jr nz,l9dcbh
	ld hl,00000h
	ld (0f1c0h),hl
	ld hl,disk_err
	ld (0f323h),hl
	ret
dos_leave:                      ; 0x9DE7  restore work RAM + F100 from stash
	call dos_wait
	ld de,0e000h
	ld hl,0c000h
	exx
	ld de,0e280h
	ld bc,01100h
l9df7h:
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
	jr nz,l9df7h
	ld de,0f100h
	ld hl,0d780h
	ld bc,00280h
	ldir
	ret
dos_wait:                       ; 0x9E13  256x call D0EA
	ld b,000h
l9e15h:
	push bc
	call 0d0eah
	pop bc
	djnz l9e15h
	ret
hook_wait:                      ; 0x9E1D  256x call F0EA
	ld b,000h
l9e1fh:
	push bc
	call 0f0eah
	pop bc
	djnz l9e1fh
	ret
fcb_ext:                        ; 0x9E27  FCB ext = ELG
	ld hl,0ce09h
	ld (hl),045h
	inc hl
	ld (hl),04ch
	inc hl
	ld (hl),047h
	ret
dos_scan:                       ; 0x9E33  BDOS FFIRST/FNEXT into catalog
	ld de,0ce25h
	ld c,01ah
	call 0f37dh
	ld hl,0c26fh
	ld a,(hl)
	and a
	ld de,0ce00h
	jr nz,l9e4fh
	inc (hl)
	ld c,011h
	call 0f37dh
	inc a
	ret z
	jr l9e5dh
l9e4fh:
	ld c,012h
	call 0f37dh
	inc a
	jr nz,l9e5dh
	xor a
	ld (0c26fh),a
	jr dos_scan
l9e5dh:
	ld hl,0d0e5h
	inc (hl)
	push hl
	call dos_copyent
	pop hl
	ld a,(hl)
	cp 010h
	jr z,l9e76h
	ld de,0ce00h
	ld c,012h
	call 0f37dh
	inc a
	jr nz,l9e5dh
l9e76h:
	ld a,(0d0e5h)
	or a
	ret
dos_copyent:                    ; 0x9E7B  dir ent D0E5-1 -> CE26
	ld de,0ce26h
	ld a,(0d0e5h)
	dec a
	call dos_ent
	ex de,hl
	ld bc,0000bh
	ldir
	ret
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
dos_fcb:                        ; 0x9EA8  wild FCB + fcb_clear
	ld hl,0ce25h
	ld de,0ce26h
	ld (hl),000h
	ld bc,00024h
	ldir
	call fcb_clear
	ld hl,dos_wild
	ld de,0ce01h
	ld bc,0000bh
	ldir
	ret
vic_tick:                         ; 0x9EC4  per-frame; d_9ecd[(0xE280)]
	call vic_dispatch
	jp probe_edge

vic_dispatch:                     ; 0x9ECA
	ld a,(0e280h)
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
	jr nz,l9f02h
	call probe_ladder
	jp nz,vic_off_floor
l9f02h:
	call use_tool
	ld a,(0e280h)
	or a
	ret nz
	call vic_walk_move
	ld a,(0e280h)
	or a
	ret nz
	ld a,(0e288h)
	and 00ch
	jr z,l9f3fh
vic_walk_anim:                    ; 0x9F19  E296 timer -> E285 from vic_walk_l/r
	ld hl,0e296h
	dec (hl)
	ret nz
	ld (hl),004h
vic_walk_frame:                   ; 0x9F20
	ld a,(0e295h)
	inc a
	and 003h
	ld b,a
	ld (0e295h),a
	ld a,(0e294h)
	or a
	ld hl,vic_walk_l
	jr z,l9f36h
	ld hl,vic_walk_r
l9f36h:
	ld a,b
	call ADD_HL_A
	ld a,(hl)
	ld (0e285h),a
	ret
l9f3fh:
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
	ld a,(0e282h)
	add a,010h
	ld l,a
	ld a,(0e294h)
	or a
	ld a,(0e284h)
	jr z,l9f63h
	add a,00fh
l9f63h:
	ld h,a
	call map_tile
	sub 002h
	ret c
	ld a,(0e282h)
	and 0f8h
	ld (0e282h),a
	xor a
	ld (0e2a6h),a
	ret
; Fire -> jump; up/down -> ladder; else E288 L/R + E28E/E290 delta.
vic_walk_move:                    ; 0x9F77
	call vic_busy
	jr c,l9f95h
	ld a,(0e207h)
	bit 4,a
	jp nz,vic_begin_jump          ; fire, not holding: 0 -> 1
	ld a,(0e208h)
	rra
	jr nc,l9f8fh
	call vic_grab_up
	jr l9f95h
l9f8fh:
	rra
	jr nc,l9f9ah
	call vic_grab_dn
l9f95h:
	ld a,(0e280h)
	or a
	ret nz
l9f9ah:
	ld a,(0e288h)
	ld de,(0e28eh)
	ld c,002h
	bit 2,a
	jr nz,l9fb0h
	ld de,(0e290h)
	ld c,003h
	bit 3,a
	ret z
l9fb0h:
	push bc
	ld hl,(0e283h)
	add hl,de
	push hl
	ld a,(0e282h)
	ld l,a
	call probe_step
	pop hl
	pop bc
	jr c,vic_set_x
vic_snap_x:                       ; 0x9FC1  blocked: snap X to 8px from facing
	ld a,(0e294h)
	or a
	ld a,007h
	jr z,l9fcah
	xor a
l9fcah:
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
	ld (0e2a7h),a
	ld a,(0e280h)
	or a
	jr nz,l9fe9h
	ld a,(0e2a6h)
	or a
	jr nz,l9fe9h
	xor a
	ld (0e2a7h),a
l9fe9h:
	xor a
	ld (0e295h),a
	ld a,007h
	ld (0e296h),a
	ld b,001h
	ld a,(0e294h)
	or a
	jr z,l9ffch
	ld b,004h
l9ffch:
	ld a,b
	ld (0e285h),a

; ---------------------------------------------------------------------------
;  bank 03 @ 0xA000
; ---------------------------------------------------------------------------
vic_enter_fall:                   ; 0xA000  E280=3; boot jp and walk-off both land here
	ld a,003h
	ld (0e280h),a
	jp sfx_3c
vic_begin_jump:                   ; 0xA008  from walk + fire; inc E280 0->1
	ld a,(0e2a6h)
	or a
	ret nz
	ld a,(0e287h)
	or a
	ret nz
	ld a,(0e282h)
	cp 0f8h
	ret nc
	ld l,a
	ld a,(0e284h)
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
	ld (0e285h),a
	xor a
	ld (0e2a5h),a
	ld hl,0fc00h
	ld (0e292h),hl
	call sfx_13                   ; jump
	ld hl,0e280h
	inc (hl)
	ret
use_tool:                         ; 0xA045  fire + E287 -> E300 (high nibble 1), then d_a072
	ld a,(0e2a6h)
	or a
	ret nz
	ld a,(0e287h)
	and a
	ret z
	ld a,(0e207h)
	bit 4,a
	ret z
	ld hl,0e300h
	ld b,040h
la05ah:
	ld a,(hl)
	rra
	rra
	rra
	rra
	and 00fh
	dec a
	jr z,la06bh
	ld de,00008h
	add hl,de
	djnz la05ah
	ret
la06bh:
	ld (0e2a0h),hl
	ld a,(0e287h)
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
	jr z,la093h
	ld a,00ch
la093h:
	ld (0e285h),a
	ld a,008h
	ld (0e286h),a
la09bh:
	ld a,(0e287h)
	and 00fh
	add a,007h
	ld (0e280h),a
	ret
use_floor:                        ; 0xA0A6  shovel / pick: two floor tiles type 2
	ld a,(0e294h)
	or a
	ld bc,0f80ah
	jr z,la0b2h
	ld bc,0080ch
la0b2h:
	ld a,c
	exx
	ld c,a
	exx
	ld a,(0e284h)
	add a,004h
	and 0f8h
	add a,b
	ld h,a
	ld a,(0e282h)
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
	ld (0e285h),a
	exx
	ld hl,(0e2a0h)
	ld a,010h
	add a,(hl)
	ld (hl),a
	ld a,020h
	ld (0e286h),a
	jr la09bh
use_wall:                         ; 0xA0F0  hammer / drill: two wall tiles type 2
	ld a,(0e294h)
	or a
	ld b,0feh
	ld a,00ah
	jr z,la0feh
	ld b,012h
	ld a,00ch
la0feh:
	exx
	ld c,a
	exx
	ld a,(0e284h)
	add a,b
	and 0f8h
	ld h,a
	ld a,(0e282h)
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
	ld (0e285h),a
	exx
	ld hl,(0e2a0h)
	ld a,010h
	add a,(hl)
	ld (hl),a
	ld a,020h
	ld (0e286h),a
	jp la09bh
; Air L/R from A = E289 & 0x0C. DE = ±0x140, C = 2/3.
vic_jump_x:                       ; 0xA136
	ld de,0fec0h
	ld c,002h
	bit 2,a
	jp nz,la14bh
	ld de,00140h
	ld c,003h
	bit 3,a
	jp nz,la14bh
	ret
la14bh:
	ld hl,(0e283h)
	add hl,de
	ld a,h
	cp 0f0h
	jp nc,vic_set_x
	push bc
	push hl
	ld a,(0e2a5h)
	or a
	ld a,(0e282h)
	jr z,la162h
	add a,006h
la162h:
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
	jr z,la179h
	ld h,010h
la179h:
	ld a,(0e284h)
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
	ld a,(0efc0h)
	or a
	ret z
	call vic_snap_y
	xor a
	ld (0e280h),a
	ld (0e2a6h),a
	ld (0e2a5h),a
	ld (0e295h),a
	inc a
	ld (0e296h),a
	call vic_walk_frame
	jp sfx_38
; E292 += 0x80 (cap 4.00) → E281 Y. CY from probe_air_y = blocked.
vic_gravity:                      ; 0xA1C1
	ld hl,(0e292h)
	ld a,h
	cp 004h
	jr z,la1e1h
	ld de,00080h
	add hl,de
	ld (0e292h),hl
	ex de,hl
la1d1h:
	ld hl,(0e281h)
	add hl,de
	ld (0e281h),hl
	call probe_air_y
	ret c
	ld hl,0e2a5h
	inc (hl)
	ret
la1e1h:
	ld de,00400h
	jr la1d1h
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
probe_solid:                      ; 0xA1F9  type >= 2 at (Y=L, X+2) and (Y=L, X+14)
	ld a,(0e284h)
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
	ld a,(0e208h)
	and 00ch
	jr z,la290h
	rra
	rra
	rra
	ld c,002h
	jr c,la221h
	inc c
la221h:
	ld a,(0e282h)
	ld l,a
	ld a,(0e284h)
	ld h,a
	push hl
	push bc
	call probe_step
	pop bc
	pop hl
	jr nc,la290h
	ld a,l
	add a,004h
	ld l,a
	ld a,c
	cp 002h
	ld a,0fch
	jr z,la23fh
	ld a,014h
la23fh:
	add a,h
	ld h,a
	call map_tile_xy
	or a
	jr nz,la270h
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr nz,la270h
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr z,la270h
	ld a,l
	sub 010h
la25eh:
	and 0f8h
	ld h,a
	xor a
	ld (0e280h),a
	ld (0e2a4h),a
	ld (0e2a6h),a
	ld l,a
	ld (0e281h),hl
	ret
la270h:
	ld a,(0e282h)
	add a,004h
	ld l,a
	ld a,(0e284h)
	ld h,a
	ld c,001h
	push hl
	call probe_step
	pop hl
	ld a,l
	jr nc,la25eh
	xor a
	ld (0e280h),a
	ld (0e2a4h),a
	inc a
	ld (0e2a6h),a
	ret
la290h:
	call vic_climb_exit
	ld a,(0e280h)
	cp 002h
	ret nz
	call vic_climb_stay
	ld a,(0e280h)
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
	ld a,(0e285h)
	xor 001h
	ld (0e285h),a
	ret
; E288 up/down → E28A/E28C delta; C=0/1 for probe_step.
vic_climb_move:                   ; 0xA2BB
	ld de,(0e28ah)
	ld c,000h
	ld a,(0e288h)
	rra
	jr c,la2d6h
	ld de,(0e28ch)
	ld c,001h
	rra
	jr c,la2d6h
	ld hl,0e296h
	ld (hl),001h
	ret
la2d6h:
	ld hl,(0e281h)
	add hl,de
	ld a,h
	cp 0e8h
	jr nc,la2ech
	push bc
	push hl
	ld l,h
	ld a,(0e284h)
	ld h,a
	call probe_step
	pop hl
	pop bc
	ret nc
la2ech:
	ld (0e281h),hl
	ret
vic_fall:                         ; 0xA2F0  Y+=4 until 0xAD or floor, then walk
	ld a,(0e284h)
	ld h,a
	ld a,(0e282h)
	add a,004h
	ld l,a
	ld (0e282h),a
	cp 0adh
	ret nc
	call probe_floor
	ret z
	call vic_snap_y
	xor a
	ld (0e280h),a
	ld (0e2a6h),a
	inc a
	ld (0e296h),a
	jp sfx_38
vic_die:                          ; 0xA315  D=10, sprite 4..6; shared la321h
	ld de,00a06h
	ld c,004h
	jr la321h
vic_hit:                          ; 0xA31C  D=5, sprite 0..4 (E500 overlap)
	ld de,00504h
	ld c,000h
la321h:
	ld hl,0e296h
	dec (hl)
	ret nz
	ld a,(0e295h)
	cp d
	jr z,la34bh
	ld (hl),003h
	ld hl,0e285h
	inc (hl)
	ld a,(hl)
	cp e
	ret nz
	ld a,(0e295h)
	inc a
	ld (0e295h),a
	cp d
	jr z,la341h
	ld (hl),c
	ret
la341h:
	ld (hl),006h
	ld hl,0e296h
	ld (hl),028h
	jp sfx_29
la34bh:
	xor a
	ld (0e246h),a
	ret
vic_pull_l:                       ; 0xA350  coffin / Pyoncy pull left
	ld hl,0e299h
	inc (hl)
	ld a,(hl)
	sub 012h
	jr z,la368h
	xor a
	ld (0e283h),a
	ld a,(0e284h)
	dec a
	dec a
	ld (0e284h),a
	jp vic_walk_anim
la368h:
	ld (0e280h),a
	ret
vic_pull_r:                       ; 0xA36C  coffin / Pyoncy pull right
	ld hl,0e299h
	inc (hl)
	ld a,(hl)
	sub 012h
	jr z,la368h
	xor a
	ld (0e283h),a
	ld a,(0e284h)
	inc a
	inc a
	ld (0e284h),a
	jp vic_walk_anim
vic_throw:                        ; 0xA384  knife / boomerang windup
	ld hl,0e286h
	dec (hl)
	jr z,la393h
	ld a,(hl)
	cp 004h
	ret nz
	ld hl,0e285h
	inc (hl)
	ret
la393h:
	xor a
	ld (0e287h),a
	ld (0e280h),a
	ld a,(0e294h)
	or a
	ld a,003h
	jr nz,la3a3h
	xor a
la3a3h:
	ld (0e285h),a
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
	ld a,(0e282h)
	and 0f8h
	ld (hl),a
	ld l,a
	ld a,(0e284h)
	ld h,a
	ld b,000h
	ld a,(0e294h)
	or a
	ld c,003h
	jr z,la3ceh
	cp 0e8h
	jr nc,la3ddh
	jr la3d4h
la3ceh:
	dec c
	ld a,h
	cp 010h
	jr c,la3ddh
la3d4h:
	call probe_step
	ld b,000h
	jr nc,la3ddh
	ld b,010h
la3ddh:
	pop hl
	inc l
	ld c,004h
	ld a,(0e294h)
	or a
	ld a,(0e284h)
	jr nz,la3efh
	ld c,003h
	sub b
	jr la3f0h
la3efh:
	add a,b
la3f0h:
	ld (hl),a
	ret nc
	inc l
	push hl
	ld a,(0e243h)
	push bc
	call 05df0h
	pop bc
	ld b,a
	ld a,c
	call 05e38h
	ld a,l
	pop hl
	ld (hl),a
	ret
vic_shovel:                       ; 0xA405
	ld a,(0e286h)
	and 003h
	call z,sfx_15
	jr la42bh
vic_pick:                         ; 0xA40F
	ld a,(0e286h)
	and 003h
	call z,sfx_17
	jr la42bh
vic_hammer:                       ; 0xA419  wall, 1 deep
	ld a,(0e286h)
	and 003h
	call z,sfx_18
	jr la42bh
vic_drill:                        ; 0xA423  wall, 2 deep
	ld a,(0e286h)
	and 003h
	call z,sfx_16
la42bh:
	ld hl,0e286h
	dec (hl)
	ld a,(hl)
	rra
	rra
	ret c
	ld a,(0e285h)
	xor 001h
	ld (0e285h),a
	ret
vic_hold:                         ; 0xA43C  until e2a8 hits 0
	ld hl,0e2a8h
	dec (hl)
	ret nz
	xor a
	ld (0e280h),a
	ret
vic_snap_y:                       ; 0xA446  E281/E282: subpixel 0, Y &= ~7
	ld a,(0e282h)
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
	ld a,(0e284h)
	add a,002h
	ld h,a
	ld a,(0e282h)
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
	ld a,(0e284h)
	ld h,a
	ld a,(0e282h)
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
	ld a,(0e284h)
	ld h,a
	ld a,(0e282h)
	add a,012h
	ld l,a
	ld a,(0e288h)
	rra
	jr c,la4d0h
	rra
	ret nc
	call map_tile_xy
	cp 002h
	jr nc,la4b2h
	ld a,h
	add a,008h
	ld h,a
	call map_tile_xy
	cp 002h
	ret c
la4b2h:
	ld a,l
	cp 0c0h
	ret nc
	sub 00bh
la4b8h:
	and 0f8h
	ld h,a
	xor a
	ld l,a
	ld (0e281h),hl
	ld (0e280h),a
	ld (0e2a6h),a
	inc a
	ld (0e2a7h),a
	ld (0e296h),a
	jp vic_walk_anim
la4d0h:
	ld a,(0e282h)
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
	jr la4b8h
; E288 bits 2–3 → E294 facing (0 left / 1 right); reset walk frame on change.
vic_face:                         ; 0xA4EF
	ld b,000h
	ld a,(0e288h)
	rra
	rra
	and 003h
	ret z
	rra
	jr c,la4ffh
	inc b
	rra
	ret nc
la4ffh:
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
	ld a,(0e282h)
	add a,010h
	ld l,a
	ld a,(0e284h)
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
probe_land:                       ; 0xA535  jump: EFC0=1 if floor (not ladder)
	xor a
	ld (0efc0h),a
	call probe_floor
	ret z
	dec a
	jr nz,la55fh
	ld a,l
	sub 00ch
	and 0f8h
	ld l,a
	call map_tile_xy
	or a
	jr nz,la565h
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	jr nz,la565h
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	or a
	ret z
la55fh:
	ld a,001h
	ld (0efc0h),a
	ret
la565h:
	ld a,(0e282h)
	add a,010h
	ld l,a
	call probe_under
	ret c
	jr la55fh
probe_under:                      ; 0xA571  three tiles at L, X+3/+8/+13; CY if all type < 2
	ld a,(0e284h)
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
vic_grab_dn:                      ; 0xA591  down onto ladder (Y+16)
	call vic_grab_y2
	ld a,(0e280h)
	cp 002h
	ret z
	ld a,(0e282h)
	add a,010h
	ld l,a
	jr la5b1h
vic_grab_up:                      ; 0xA5A2  up onto ladder (Y+10)
	call vic_grab_y2
	ld a,(0e280h)
	cp 002h
	ret z
	ld a,(0e282h)
	add a,00ah
	ld l,a
la5b1h:
	ld a,(0e284h)
	ld h,a
	call map_tile_xy
	dec a
	ld bc,00c0ch
	jr z,la5cch
	ld bc,0f400h
	ld a,h
	add a,010h
	ld h,a
	push bc
	call map_tile_xy
	pop bc
	dec a
	ret nz
la5cch:
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
	ld (0e285h),a
	ret
vic_grab_y2:                      ; 0xA5FB  Y+2, then shared grab
	ld a,(0e282h)
	add a,002h
	ld l,a
	jr la5b1h
; Count type-1 tiles left of H; CY if odd (ladder not centered).
probe_ladder_span:                ; 0xA603
	ld a,(0e208h)
	rra
	ld a,(0e282h)
	jr c,la60eh
	add a,010h
la60eh:
	ld l,a
	ld c,0ffh
la611h:
	inc c
	ld a,h
	or a
	jr z,la621h
	sub 008h
	ld h,a
	push bc
	call map_tile_xy
	pop bc
	dec a
	jr z,la611h
la621h:
	ld a,c
	rra
	ret
; E208/E207 bits 2–3 → E288 (4 left / 8 right). Both bits together: ignore.
vic_keys_lr:                      ; 0xA624
	ld a,(0e208h)
	and 00ch
	ld b,a
	ld c,000h
	jr z,la64eh
	ld a,(0e207h)
	and 00ch
	cp 00ch
	ret z
	bit 2,a
	ld c,004h
	jr nz,la64eh
	bit 3,a
	ld c,008h
	jr nz,la64eh
	ld a,b
	cp 00ch
	ret z
	bit 2,a
	ld c,004h
	jr nz,la64eh
	ld c,008h
la64eh:
	ld a,c
	ld (0e288h),a
	ret
; Same for bits 0–1 → E288 (1 up / 2 down).
vic_keys_ud:                      ; 0xA653
	ld a,(0e208h)
	and 003h
	ld b,a
	ld c,000h
	jr z,la64eh
	ld a,(0e207h)
	and 003h
	cp 003h
	ret z
	rra
	ld c,001h
	jr c,la64eh
	rra
	ld c,002h
	jr c,la64eh
	ld a,b
	cp 003h
	ret z
	rra
	ld c,001h
	jr c,la64eh
	ld c,002h
	jr la64eh
probe_edge:                       ; 0xA67C  E248 = 1 up / 2 down / 3 left / 4 right
	ld a,(0e282h)                 ; Y
	add a,008h
	cp 002h
	jr c,la6a8h                   ; top + climb -> 1 up
	sub 008h
	cp 0aeh
	jr nc,la6b4h                  ; bottom -> 2 down
	ld a,(0e294h)
	or a
	ld a,(0e284h)                 ; X
	jr z,la69dh
	cp 0f1h
	ret c
	ld a,004h                     ; facing right, X >= 0xF1 -> 4 right
	ld (0e248h),a
	ret
la69dh:
	add a,008h
	cp 00ah
	ret nc
	ld a,003h                     ; facing left, X small -> 3 left
	ld (0e248h),a
	ret
la6a8h:
	ld a,(0e280h)
	sub 002h
	ret nz
	ld a,001h                     ; climb off top -> 1 up
	ld (0e248h),a
	ret
la6b4h:
	cp 0f0h
	ret nc
	ld a,002h                     ; Y >= 0xAE -> 2 down
	ld (0e248h),a
	ret
tick_map_tools:                   ; 0xA6BD  0xE300 64 x 8 (afb1_tbl); skip if (0xE248)
	ld a,(0e248h)
	or a
	ret nz
	ld ix,0e300h
	ld b,040h
la6c8h:
	push bc
	call tick_map_tool
	pop bc
	ld de,00008h
	add ix,de
	djnz la6c8h
	ret
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
	ld a,(0e243h)
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
	jr nc,la724h
	ld a,(ix+007h)
	jr la729h
la724h:
	call tool_step_x
	ret c
	ld a,c
la729h:
	rra
	ld a,004h
	jr nc,la72fh
	xor a
la72fh:
	add a,(ix+002h)
	and 0f8h
	cp 0f1h
	jr c,la73ah
	ld a,0f0h
la73ah:
	ld (ix+002h),a
	call tool_next
	jp la814h
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
	ld a,(0e243h)
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
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	jp sfx_36
tool_lock:                      ; 0xA787  CY if IX is E2E8; clear EDCD
	ld a,(0edcdh)
	and a
	ret z
	push ix
	pop de
	ld hl,(0e2e8h)
	and a
	sbc hl,de
	jr nz,la79dh
	xor a
	ld (0edcdh),a
	scf
	ret
la79dh:
	and a
	ret
knife_probe:                    ; 0xA79F  wall/X probe; B = 8 or 16 step
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	ld a,008h
	add a,(ix+002h)
	cp 0eeh
	jr c,la7b3h
	ld a,0e8h
	jr la7b9h
la7b3h:
	cp 008h
	jr nc,la7b9h
	ld a,008h
la7b9h:
	ld h,a
	ld l,(ix+001h)
	call map_tile_xy
	sub 002h
	ld b,010h
	jr nc,la7f9h
	ld a,l
	add a,008h
	ld l,a
	call map_tile_xy
	sub 002h
	ld b,010h
	jr nc,la7f9h
	ld a,l
	sub 008h
	ld l,a
	ld a,(0e294h)
	or a
	ld a,h
	jr nz,la7e2h
	sub 008h
	jr la7e4h
la7e2h:
	add a,008h
la7e4h:
	ld h,a
	ret c
	call map_tile_xy
	sub 002h
	jr nc,la7f7h
	ld a,l
	add a,009h
	ld l,a
	call map_tile_xy
	sub 002h
	ret c
la7f7h:
	ld b,008h
la7f9h:
	ld a,(0e294h)
	or a
	ld a,b
	jr z,la804h
	sub 008h
	neg
la804h:
	add a,(ix+002h)
	and 0f8h
	ld (ix+002h),a
	call la814h
	call tool_next
	and a
	ret
la814h:
	ld (ix+006h),018h
	ret
tool_add_x:                     ; 0xA819  signed X step from B; C dir 2/3
	ld a,b
	bit 7,a
	ld c,003h
	jr z,la830h
	neg
	ld b,a
	dec c
	jr la836h
tool_step_x:                    ; 0xA826  X step from ix+7 facing
	ld a,(ix+007h)
	or a
	ld bc,00402h
	jr z,la836h
	inc c
la830h:
	ld a,(ix+002h)
	add a,b
	jr la83ah
la836h:
	ld a,(ix+002h)
	sub b
la83ah:
	ld (ix+002h),a
	jr c,la853h
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,la866h
	ld h,(ix+002h)
	ld l,(ix+001h)
	push bc
	call probe_step
	pop bc
	ret
la853h:
	ld a,(ix+003h)
	push bc
	call 05df0h
	pop bc
	ld b,a
	push bc
	ld a,c
	inc a
	call 05e38h
	pop bc
	ld (ix+003h),l
la866h:
	ld b,(ix+003h)
	ld hl,0e840h
	ld de,000c0h
la86fh:
	add hl,de
	djnz la86fh
	ex de,hl
	ld h,(ix+002h)
	ld l,(ix+001h)
	push bc
	call probe_step_de
	pop bc
	ret
knife_anim:                     ; 0xA87F  ix+4 mod 3; sfx_1c on wrap
	ld a,(0e203h)
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 003h
	jr c,la897h
	ld a,(0e243h)
	cp (ix+003h)
	call z,sfx_1c
	xor a
la897h:
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
	jr nc,la8d4h
	ld a,(ix+007h)
	jr la90ah
la8d4h:
	dec (ix+006h)
	jr nz,la8f1h
	ld a,(ix+005h)
	inc a
	cp 009h
	jr c,la8e3h
	ld a,009h
la8e3h:
	ld (ix+005h),a
	ld e,a
	ld d,000h
	ld hl,boom_dt
	add hl,de
	ld a,(hl)
	ld (ix+006h),a
la8f1h:
	ld e,(ix+005h)
	ld d,000h
	ld hl,boom_dx
	add hl,de
	ld a,(ix+007h)
	or a
	ld a,(hl)
	jr nz,la903h
	neg
la903h:
	ld b,a
	call tool_add_x
	jr c,la92ah
	ld a,c
la90ah:
	rra
	ld a,004h
	jr nc,la910h
	xor a
la910h:
	add a,(ix+002h)
	and 0f8h
	cp 0f1h
	jr c,la91bh
	ld a,0f0h
la91bh:
	ld (ix+002h),a
	call la814h
tool_next:                        ; 0xA921  ix+0 += 0x10 (next in-use state)
	ld a,(ix+000h)
	add a,010h
	ld (ix+000h),a
	ret
la92ah:
	ld a,(0e287h)
	or a
	ret nz
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	ld a,(0e282h)
	sub (ix+001h)
	jr nc,la940h
	neg
la940h:
	cp 00dh
	ret nc
	ld a,(0e284h)
	sub (ix+002h)
	jr nc,la94dh
	neg
la94dh:
	cp 00dh
	ret nc
	ld hl,0e2a9h
	dec (hl)
	call sfx_35                   ; boom
	ld (ix+000h),012h
	ld a,002h
	ld (0e287h),a
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
boom_anim:                      ; 0xA99D  ix+4 mod 6; sfx_1b on wrap
	ld a,(0e203h)
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 006h
	jr c,la9b6h
	ld a,(0e243h)
	cp (ix+003h)
	call z,sfx_1b
	ld a,003h
la9b6h:
	ld (ix+004h),a
	ret
tool_fall:                      ; 0xA9BA  gravity Y for a map tool
	dec (ix+006h)
	ld a,(ix+005h)
	jr nz,la9d6h
	cp 005h
	jr nc,la9cah
	inc a
	ld (ix+005h),a
la9cah:
	ld e,a
	ld d,000h
	ld hl,fall_dt
	add hl,de
	ld a,(hl)
	ld (ix+006h),a
	ld a,e
la9d6h:
	inc a
	add a,(ix+001h)
	ld (ix+001h),a
	cp 0b8h
	jr nc,laa03h
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,tool_sat
	ld a,(ix+001h)
	add a,010h
	cp 0b8h
	jr c,la9f4h
	ld a,0b8h
la9f4h:
	ld l,a
	ld a,(ix+002h)
	add a,008h
	ld h,a
	call map_tile
	cp 002h
	jr nc,laa30h
	ret
laa03h:
	ld a,008h
	ld (ix+001h),a
	ld a,(ix+003h)
	call 05df0h
	ld b,a
	ld a,002h
	call 05e38h
	ld (ix+003h),l
tool_sat:                       ; 0xAA17  map-tool SAT at E840 + screen*0xC0
	ld b,(ix+003h)
	ld hl,0e840h
	ld de,000c0h
laa20h:
	add hl,de
	djnz laa20h
	ex de,hl
	ld h,(ix+002h)
	ld l,(ix+001h)
	ld c,001h
	call probe_step_de
	ret c
laa30h:
	ld hl,0e2a9h
	dec (hl)
	ld a,(ix+001h)
	and 0f8h
	ld (ix+001h),a
	ld a,(ix+000h)
	and 00fh
	ld (ix+000h),a
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	call 09237h
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
laa8ch:
	ld a,(0e294h)
	or a
	ld a,003h
	jr nz,laa95h
	xor a
laa95h:
	ld (0e285h),a
	xor a
	ld (ix+000h),a
	ld (0e287h),a
	ld a,(0e298h)
	or a
	ret nz
	xor a
	ld (0e280h),a
	ret
shovel_anim:                    ; 0xAAA9  dig frames; stamp from AB03
	dec (ix+006h)
	ret nz
	ld (ix+006h),008h
	ld a,(ix+005h)
	inc a
	cp 003h
	jr z,laae7h
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
laae7h:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00102h
	call stamp_wtiles
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)
	ld d,a
	ld bc,00102h
	xor a
	jp 063edh
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
	jp nz,laa8ch
	ld a,h
	add a,008h
	ld h,a
	call map_tile
	cp 002h
	jp nz,laa8ch
	call pick_go
pick_dig2:                        ; 0xAB52
	call shovel_anim
	ld a,(ix+007h)
	or a
	ret z
	jp laa8ch
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
	jp laa8ch
wall_anim:                      ; 0xAB86  hammer/drill wall frames from ABE9
	dec (ix+006h)
	ret nz
	ld (ix+006h),008h
	ld a,(ix+005h)
	inc a
	cp 003h
	jr z,labcdh
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
	jr z,labb6h
	ld hl,hammer_r
labb6h:
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
labcdh:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00201h
	call stamp_wtiles
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)
	ld d,a
	ld bc,00201h
	xor a
	jp 063edh
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
	jr z,lac2ah
	ld b,008h
lac2ah:
	ld a,h
	add a,b
	ld h,a
	ld (0e2a2h),hl
	call map_tile_xy
	cp 002h
	jp nz,laa8ch
	ld a,l
	add a,008h
	ld l,a
	call map_tile
	cp 002h
	jp nz,laa8ch
	ld a,(0e294h)
	or a
	ld b,008h
	jr nz,lac4eh
	ld b,0f8h
lac4eh:
	ld a,(0e284h)
	add a,b
	ld (0e284h),a
	jp drill_go
drill_dig2:                       ; 0xAC58
	call wall_anim
	ld a,(ix+007h)
	or a
	ret z
	jp laa8ch
tool_phase:                       ; 0xAC63  ix+0 high nibble (in-use state)
	ld a,(ix+000h)
	rra
	rra
	rra
	rra
	and 00fh
	ret
spawn_tool:                       ; 0xAC6D  C = E500 id; reject C >= 5
	ld (0e252h),a
	ld a,c
	cp 005h
	ret nc
	exx
	ld hl,0e500h
	ld b,008h
	ld de,00020h
	xor a
lac7eh:
	cp (hl)
	jr z,lac86h
	add hl,de
	djnz lac7eh
	scf
	ret
lac86h:
	push hl
	push hl
	pop ix
	exx
	pop hl
	call spawn_fill
	xor a
	ret
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
d_acd9_jp_end:
	ld a,(0f0f4h)
	and a
	ld a,(ix+000h)
	jr z,lacfeh
	add a,a
	ld de,lad0bh
	call ADD_DE_A
	ld a,(de)
	ld (ix+01eh),a
	inc de
	ld a,(de)
	ld (ix+01fh),a
	ret
lacfeh:
	ld de,lad08h
	call ADD_DE_A
	ld a,(de)
	ld (ix+01eh),a
lad08h:
	ret
	rrca
	ld a,(bc)
lad0bh:
	ld a,(bc)
	add hl,bc
	dec bc
	ld c,h
	ld a,(bc)
	ld b,a
	dec bc
	ld c,h
	dec bc
	ld c,h
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
	ld de,0e900h
	add hl,de
	ex de,hl
	ret
spawn_kb:                         ; 0xAD2C  knife / boomerang E500 init
	ld (ix+018h),000h
	ld (ix+011h),0ffh
	ld hl,093b2h
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
	jp lb294h
e500_stamp:                     ; 0xAD53  3x2 draw_tilemap under a thrown tool
	ld a,(0e243h)
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
	jp c,laf2ch
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	ld de,00180h
	call thrown_xy_d
	call e500_flip
	call thrown_step
	jp c,lae51h
	call e500_flip
	call thrown_step
	jp nc,06608h
	jp lae51h
knife_seek:                       ; 0xADBB
	ld (ix+006h),001h
	call thrown_dir
	call thrown_drop
	jr nc,ladcfh
	call thrown_snap
	ld a,004h
	jp laf2ch
ladcfh:
	call thrown_step
	jr nc,laddfh
	call thrown_edge
	dec a
	cp (ix+00bh)
	ret nz
	jp lb0a6h
laddfh:
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,06608h
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
	ld hl,093b8h
	call e500_stamp
	ld hl,sfx_41
	call lb294h
	ld (ix+013h),002h
	ld (ix+011h),000h
	ld (ix+014h),020h
lae51h:
	inc (ix+001h)
	ret
thrown_hide:                      ; 0xAE55  shared: undraw then next state
	dec (ix+014h)
	ret nz
	call e500_undraw
	ld (ix+013h),003h
	ld (ix+014h),020h
	ld a,(0e243h)
	cp (ix+010h)
	call z,sfx_25
	jr lae51h
e500_undraw:                    ; 0xAE6F  restore 3x2 world tiles under throw
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	ld d,(ix+005h)
	ld a,(ix+003h)
	sub 008h
	ld e,a
	ld bc,00302h
	call stamp_wtiles
	ld hl,093ach
	jp e500_stamp
boom_toss:                        ; 0xAE8B
	call thrown_drop
	jp c,laf2ah
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	call thrown_reset
	call thrown_face
	ld de,00180h
	call thrown_xy_d
	call thrown_step
	jr c,lae51h
	call e500_flip
	call thrown_step
	jp nc,06608h
	jr lae51h
boom_seek:                        ; 0xAEB5
	ld (ix+006h),001h
	call thrown_dir
	call thrown_drop
	jr nc,laec6h
	call thrown_snap
	jr laf2ah
laec6h:
	call thrown_edge
	dec a
	cp (ix+00bh)
	jp z,lb0a6h
	call thrown_step
	jr c,laee6h
	call thrown_snap
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,06608h
	jp laf7dh
laee6h:
	call vic_side_y
	dec c
	ret m
	jr z,laef5h
	call floor_down
	ret nz
	ld a,001h
	jr laefah
laef5h:
	call floor_here
	ret nz
	xor a
laefah:
	ld (ix+00bh),a
	ld de,00280h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld a,(ix+005h)
	and 0f8h
	ld (ix+005h),a
	jp lae51h
thrown_dir:                     ; 0xAF14  ix+11 from facing + E203 bit 2
	ld c,001h
	bit 0,(ix+00bh)
	jr z,laf1eh
	ld c,003h
laf1eh:
	ld a,(0e203h)
	and 004h
	jr z,laf26h
	inc c
laf26h:
	ld (ix+011h),c
	ret
laf2ah:
	ld a,005h
laf2ch:
	ld (ix+001h),a
	xor a
	ld (ix+009h),a
	ld (ix+00ah),a
	ld a,(ix+00bh)
	ld (ix+019h),a
	ld (ix+00bh),001h
	ld (ix+007h),000h
	ld (ix+008h),005h
laf48h:
	ld hl,sfx_2c
	jp lb294h
boom_turn:                        ; 0xAF4E  reverse when blocked
	ld (ix+006h),001h
	ld c,005h
	call laf1eh
	call thrown_block
	jp c,laf73h
	call thrown_edge
	dec a
	cp (ix+00bh)
	jr z,laf6ah
	call thrown_step
	ret c
laf6ah:
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
laf73h:
	call thrown_snap
	xor a
	ld (ix+002h),a
	ld (ix+018h),a
laf7dh:
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
	call laf7dh
	ld a,(ix+019h)
	xor 001h
	or 003h
	ld (ix+00bh),a
	ld (ix+006h),000h
	ret
thrown_face:                    ; 0xAFAA  ix+11 = vic_side_x | 2
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
e500_room:                        ; 0xAFB4  E500 vs Vic on room change (pick type 4)
	ld ix,0e500h
	call vic_xy
	ld b,008h
lafbdh:
	ld a,(ix+000h)
	and a
	jr z,lafech
	bit 0,(ix+013h)
	jr z,lafech
	ld a,(0e243h)
	cp (ix+010h)
	jr nz,lafech
	ld a,(ix+003h)
	sub e
	add a,018h
	cp 030h
	jr nc,lafech
	ld a,(ix+005h)
	sub d
	add a,018h
	cp 030h
	jr nc,lafech
	push de
	push bc
	call thrown_hit
	pop bc
	pop de
lafech:
	ex de,hl
	ld de,00020h
	add ix,de
	ex de,hl
	djnz lafbdh
	ret
thrown_hit:                     ; 0xAFF6  room-change overlap: pick vs kill
	ld a,(ix+000h)
	cp 004h
	jp nz,06706h
	ld a,(ix+001h)
	cp 004h
	jr z,lb009h
	dec a
	jp nz,06706h
lb009h:
	call map_restore
	jp 06706h
thrown_edge:                    ; 0xB00F  Vic near screen edge vs this E500
	ld a,(0e243h)
	cp (ix+010h)
	jp z,lb0a4h
	call vic_xy
	ld l,(ix+003h)
	ld h,(ix+005h)
	ld a,(ix+00bh)
	ret z
	dec a
	jr z,lb048h
	dec a
	jr z,lb062h
	dec a
	jr z,lb07ch
	ld a,l
	cp 018h
	jr nc,lb0a4h
	ld a,e
	cp 098h
	jr c,lb0a4h
	ld a,h
	sub d
	add a,018h
	cp 030h
	jr nc,lb0a4h
	ld a,001h
	call thrown_link
	jr nz,lb0a4h
	ret
lb048h:
	ld a,l
	cp 098h
	jr c,lb0a4h
	ld a,e
	cp 010h
	jr nc,lb0a4h
	ld a,h
	sub d
	add a,018h
	cp 030h
	jr nc,lb0a4h
	ld a,002h
	call thrown_link
	jr nz,lb0a4h
	ret
lb062h:
	ld a,h
	cp 018h
	jr nc,lb0a4h
	ld a,d
	cp 0d8h
	jr c,lb0a4h
	ld a,l
	sub e
	add a,018h
	cp 030h
	jr nc,lb0a4h
	ld a,003h
	call thrown_link
	jr nz,lb0a4h
	ret
lb07ch:
	ld a,h
	cp 0d8h
	jr c,lb0a4h
	ld a,d
	cp 018h
	jr nc,lb0a4h
	ld a,l
	sub e
	add a,018h
	cp 030h
	jr nc,lb0a4h
	ld a,004h
	call thrown_link
	jr nz,lb0a4h
	ret
thrown_link:                    ; 0xB096  room_link ix+16; Z if H==E244
	push af
	ld b,(ix+016h)
	call 05e38h
	ld a,(0e244h)
	cp h
	pop bc
	ld a,b
	ret
lb0a4h:
	xor a
	ret
lb0a6h:
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
thrown_block:                   ; 0xB0F9  CY if next 2x2 is blocked
	ld a,(ix+00bh)
	dec a
	jr z,lb128h
lb0ffh:
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
lb128h:
	call thrown_step
	ccf
	ret c
	jr lb0ffh
tile_at:                        ; 0xB12F  map_tile_de at HL vs ix+C/D base
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	push hl
	call map_tile_de
	pop hl
	and a
	dec a
	ret
	call floor_here
	ld c,000h
	ret z
floor_down:                     ; 0xB143  probe 2 tiles 16px below
	call thrown_xy
	ld a,010h
	add a,l
	ld l,a
	call floor_span
	ld c,001h
	ret
floor_here:                     ; 0xB150  probe 2 tiles at thrown XY
	call thrown_xy
floor_span:                     ; 0xB153  two tile_at, H += 8
	call tile_at
	ret nz
	ld a,h
	add a,008h
	ld h,a
	jp tile_at
thrown_drop:                    ; 0xB15E  down probe via step_origin
	call thrown_xy
	ld c,001h
	jr lb181h
thrown_step:                    ; 0xB165  probe_step_de in ix+11 dir
	ld c,(ix+00bh)
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
thrown_origin:                  ; 0xB17A  step_origin then two tile_air
	ld c,(ix+00bh)
	call thrown_ahead
	ret c
lb181h:
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	call 0995ah
	call tile_air
	ret nc
	call step_shift
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
step_shift:                     ; 0xB19D  HL += 8 on the travel axis
	ld a,c
	cp 002h
	jr c,lb1a7h
	ld a,l
	add a,008h
	ld l,a
	ret
lb1a7h:
	ld a,h
	add a,008h
	ld h,a
	ret
thrown_ahead:                   ; 0xB1AC  next pixel XY from velocity
	ld a,(ix+006h)
	and a
	jp z,thrown_xy
	ld a,c
	dec a
	jr z,lb1c0h
	dec a
	jr z,lb1dch
	dec a
	jr z,lb1dfh
	xor a
	jr lb1c2h
lb1c0h:
	ld a,001h
lb1c2h:
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
lb1dch:
	xor a
	jr lb1e1h
lb1dfh:
	ld a,001h
lb1e1h:
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
	jr nc,lb1fch
	neg
lb1fch:
	cp 080h
	ccf
	ret
neg_de:                         ; 0xB200  DE = -DE
	ld a,e
	cpl
	ld e,a
	ld a,d
	cpl
	ld d,a
	inc de
	ret
	ld a,004h
thrown_hold:                    ; 0xB20A  inc ix+14; CY if == A
	inc (ix+00eh)
	cp (ix+00eh)
	ret
thrown_reset:                   ; 0xB211  ix+14 = 0
	xor a
	ld (ix+00eh),a
	ret
thrown_map:                     ; 0xB216  DE = map ptr; HL = thrown XY
	ld e,(ix+00ch)
	ld d,(ix+00dh)
thrown_xy:                      ; 0xB21C  HL = ix+3 Y, ix+5 X
	ld l,(ix+003h)
	ld h,(ix+005h)
	ret
vic_side_x:                     ; 0xB223  C = 0/1 Vic vs thrown on X
	ld a,(ix+016h)
	and 007h
	ld c,a
	ld a,(0e244h)
	and 007h
	cp c
	ld c,000h
	jr z,lb236h
	ret c
	inc c
	ret
lb236h:
	ld a,(0e284h)
	cp (ix+005h)
	ret c
	inc c
	ret
vic_side_y:                     ; 0xB23F  C = row/Y side vs Vic
	ld a,(ix+016h)
	and 038h
	ld c,a
	ld a,(0e244h)
	and 038h
	cp c
	ld c,000h
	jr z,lb253h
	inc c
	ret c
	inc c
	ret
lb253h:
	ld a,(0e282h)
	sub (ix+003h)
	jr c,lb261h
	cp 010h
	ret c
	ld c,002h
	ret
lb261h:
	add a,010h
	ret c
	inc c
	ret
screen_of:                      ; 0xB266  A = E788 index of ix+16
	ld hl,0e788h
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
lb294h:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp (hl)
thrown_xy_d:                    ; 0xB29C  ix+9/10 = DE
	ld (ix+009h),e
	ld (ix+00ah),d
	ret
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
	jr z,lb2e8h
	cp 007h
	jr nz,lb2e4h
	bit 0,(ix+00bh)
	jr z,lb2d3h
	inc a
lb2d3h:
	ld (ix+011h),a
	ld a,(0f0f4h)
	and a
	ret z
	ld (ix+01eh),00ah
	ld (ix+01fh),047h
	ret
lb2e4h:
	ld (ix+011h),a
	ret
lb2e8h:
	ld (ix+014h),008h
	ld (ix+013h),003h
lb2f0h:
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
	jp z,lb50bh
	ld c,009h
lb30fh:
	call shovel_pat
	dec (ix+014h)
	ret nz
	ld a,(ix+01dh)
lb319h:
	cp 002h
lb31bh:
	jr nc,lb329h
lb31dh:
	ld a,(ix+018h)
	sub (ix+005h)
	add a,00ch
	cp 019h
	jr c,lb33ch
lb329h:
	call vic_side_y
	dec c
	jp z,lb417h
	dec c
	jp z,lb452h
	ld a,(ix+01ch)
	cp 002h
	jp nc,lb3f5h
lb33ch:
	call boom_home
	call shovel_ceil
	jr c,lb35fh
	ld a,(ix+00bh)
	xor 001h
	or 002h
	ld (ix+00bh),a
	call shovel_ceil
	jp nc,06608h
	ld a,(ix+01ch)
	cp 010h
	jp nc,06608h
	inc (ix+01ch)
lb35fh:
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
	call lb294h
	jp lb2f0h
shovel_ceil:                    ; 0xB385  CY if 3 tiles above are floor
	call thrown_map
	ld a,l
	sub 008h
	ld l,a
	jr c,lb3d0h
	call shovel_wall
	jr c,lb39ah
	call thrown_map
	call shovel_wall
	ret nc
lb39ah:
	call thrown_map
	ld a,l
	sub 008h
	ld l,a
	bit 0,(ix+00bh)
	jr z,lb3afh
	ld a,h
	add a,008h
	jr c,lb3b5h
	ld h,a
	jr lb3b5h
lb3afh:
	ld a,h
	sub 008h
	jr c,lb3b5h
	ld h,a
lb3b5h:
	ld b,003h
lb3b7h:
	push bc
	push hl
	push de
	call map_tile_de
	pop de
	pop hl
	pop bc
	cp 002h
	jr nc,lb3d0h
	ld a,h
	add a,008h
	ld h,a
	djnz lb3b7h
	ld (ix+01ah),000h
	scf
	ret
lb3d0h:
	ld (ix+01ah),001h
	scf
	ret
shovel_wall:                    ; 0xB3D6  NC if side tile is solid (>=2)
	bit 0,(ix+00bh)
	jr nz,lb3e7h
	ld a,h
	add a,007h
	sub 008h
	jr nc,lb3e5h
	xor a
	ld h,a
lb3e5h:
	jr lb3eeh
lb3e7h:
	ld a,h
	add a,011h
	jr nc,lb3eeh
	ld a,0f8h
lb3eeh:
	ld h,a
	call map_tile_de
	sub 002h
	ret
lb3f5h:
	bit 0,(ix+01ch)
	jr z,lb40bh
	call thrown_xy
	ld a,l
	add a,010h
	ld l,a
	call shovel_gap
	ld a,001h
	jr nc,lb42fh
	jr lb417h
lb40bh:
	call thrown_xy
	call shovel_gap
	ld a,000h
	jr nc,lb42fh
	jr lb452h
lb417h:
	ld a,(ix+01bh)
	and a
	jr z,lb425h
	ld a,(ix+01dh)
	cp 002h
	jp c,lb33ch
lb425h:
	call thrown_xy
	call shovel_gap
	jp c,lb33ch
	xor a
lb42fh:
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
lb452h:
	ld a,(ix+01bh)
	dec a
	jr z,lb460h
	ld a,(ix+01dh)
	cp 002h
	jp c,lb33ch
lb460h:
	call thrown_xy
	ld a,l
	add a,010h
	ld l,a
	call shovel_gap
	jp c,lb33ch
	ld a,001h
	jr lb42fh
shovel_gap:                     ; 0xB471  nudge X when 1 of 2 floor cells
	call tile_at
	ld c,000h
	jr z,lb479h
	inc c
lb479h:
	ld a,h
	add a,008h
	ld h,a
	push bc
	call tile_at
	pop bc
	jr z,lb486h
	set 1,c
lb486h:
	ld a,c
	and a
	jr z,lb4a4h
	cp 003h
	scf
	ret z
	dec a
	jr z,lb49ch
	ld a,h
	and 007h
	cp 007h
	ccf
	ret c
	ld c,0f8h
	jr lb4a4h
lb49ch:
	ld a,h
	and 007h
	cp 001h
	ret c
	ld c,008h
lb4a4h:
	ld a,(ix+005h)
	add a,c
	and 0f8h
	ld (ix+005h),a
	xor a
	ret
shovel_pat:                     ; 0xB4AF  ix+11 = C (+2 if facing)
	bit 0,(ix+00bh)
	jr z,lb4b7h
	inc c
	inc c
lb4b7h:
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
	jr z,lb50bh
	dec (ix+014h)
	ld de,000f0h
	call thrown_xy_d
	call shovel_land
	call nc,thrown_still
	ld a,(ix+014h)
	cp 008h
	jr nc,lb4f1h
	call floor_dy
	jr nz,lb52fh
lb4f1h:
	ld a,(ix+014h)
	bit 0,(ix+01ah)
	ld hl,ix14_da_start
	jr z,lb500h
	ld hl,ix14_da_end
lb500h:
	call ADD_HL_A
	ld a,(hl)
	add a,(ix+003h)
	ld (ix+003h),a
	ret
lb50bh:
	ld (ix+014h),000h
	ld (ix+006h),001h
	call floor_dy
	jr nz,lb52fh
	ld de,00500h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld (ix+00bh),001h
	ld (ix+001h),004h
	jp laf48h
lb52fh:
	call thrown_still
	ld (ix+006h),000h
	ld (ix+014h),008h
	ld a,(ix+003h)
	add a,007h
	and 0f8h
	ld (ix+003h),a
	ld (ix+001h),001h
shovel_sfx:                     ; 0xB548  sfx_14 if this screen
	ld a,(0e243h)
	cp (ix+010h)
	jp z,sfx_14
	ret
floor_zero:                     ; 0xB552  floor_ok with A=0 extra Y
	xor a
	jr lb558h
floor_dy:                       ; 0xB555  floor_ok with ix14_val extra Y
	call ix14_val
lb558h:
	call thrown_map
	add a,l
	add a,010h
	cp 0b8h
	jr c,lb564h
	ld a,0b8h
lb564h:
	ld l,a
	ld a,h
	add a,004h
	ld h,a
	call floor_ok
	ret nz
	ld a,h
	add a,008h
	ld h,a
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
	jr nz,lb58ch
	xor a
	ret
lb58ch:
	or 0ffh
	ret
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
	call laf1eh
	call thrown_block
	jr c,lb5deh
	call thrown_step
	ret c
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
lb5deh:
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
	jp lb52fh
boom_home:                      ; 0xB60E  turn when X matches home / Vic
	set 1,(ix+00bh)
	ld a,(ix+018h)
	cp 0ffh
	jr z,lb62ah
	cp (ix+005h)
	ret nz
	ld a,(ix+00bh)
	xor 001h
	or 002h
	ld (ix+00bh),a
	jp thrown_reset
lb62ah:
	ld a,(0e284h)
	sub (ix+005h)
	add a,002h
	cp 004h
	jr nc,lb644h
	ld a,(0e203h)
	ld c,002h
	and 080h
	jr z,lb640h
	inc c
lb640h:
	ld (ix+00bh),c
	ret
lb644h:
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
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
	jr z,lb66dh
	ld a,010h
	add a,h
	ld h,a
	ret c
lb66dh:
	call map_tile_de
	sub 002h
	ret
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
	jp lb294h
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
	jr z,lb6bdh
	ld (ix+011h),a
	ret
; BLOCK 'pick_pat' (start 0xb6af end 0xb6b6)
pick_pat:
	defb 01bh, 01bh, 01ch, 01ch, 01dh, 01dh, 0ffh
; BLOCK 'pick_pat2' (start 0xb6b6 end 0xb6bd)
pick_pat2:
	defb 018h, 019h, 018h, 019h, 018h, 019h, 0ffh
lb6bdh:
	ld (ix+013h),003h
	ld (ix+014h),03ch
	ld a,(0f0f4h)
	and a
	jr z,lb6dch
	ld (ix+01eh),007h
	ld (ix+01fh),049h
lb6d3h:
	call map_mark
	call map_hit
	jp c,lba7fh
lb6dch:
	inc (ix+001h)
	ret
pick_frame:                     ; 0xB6E0  A = table[ix+14>>3]; FF = end
	ld a,(0f0f4h)
	and a
	jr z,lb6e7h
	ex de,hl
lb6e7h:
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
	jr nc,lb706h
	call map_restore
	jp lb856h
lb706h:
	call map_stash
	dec (ix+014h)
	jr z,lb721h
	ld (ix+013h),003h
	ld a,(ix+014h)
	and 010h
	ld c,00fh
	jr z,lb71dh
	ld c,010h
lb71dh:
	ld (ix+011h),c
	ret
lb721h:
	call map_restore
	ld a,003h
	call thrown_hold
	jp c,06608h
	call vic_side_x
	ld a,c
	or 002h
	ld (ix+00bh),a
	call thrown_step
	jr c,lb748h
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	call thrown_step
	jp nc,06608h
lb748h:
	ld de,00200h
	call thrown_xy_d
	ld (ix+006h),001h
	jr lb6dch
pick_cut:                         ; 0xB754
	call thrown_edge
	dec a
	cp (ix+00bh)
	jp z,lb0a6h
	dec (ix+014h)
	call pick_anim
	ld a,(ix+005h)
	and 007h
	cp 003h
	jr nc,lb778h
	call thrown_map
	ld c,001h
	call probe_step_de
	jp c,lb856h
lb778h:
	call thrown_step
	jr nc,lb7b1h
	call pick_clash
	ret nc
	ld a,(ix+00bh)
	cp 002h
	ld a,(ix+005h)
	jr nz,lb78dh
	add a,007h
lb78dh:
	and 0f8h
	ld (ix+005h),a
	ld a,(iy+006h)
	and a
	jr z,lb7abh
	ld a,(iy+00bh)
	cp 002h
	jr c,lb7abh
	ld a,(iy+005h)
	jr nz,lb7a6h
	add a,007h
lb7a6h:
	and 0f8h
	ld (iy+005h),a
lb7abh:
	call ix14_dc_end
	jp lb7bfh
lb7b1h:
	call thrown_snap
	ld c,001h
	call probe_step_de
	jp c,lb856h
	call ix14_dc_end
lb7bfh:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp sfx_24
	ld (ix+006h),000h
	ld de,00000h
	call thrown_xy_d
	call thrown_dxy
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
pick_clash:                     ; 0xB7DF  CY if another pick overlaps
	ld l,(ix+003h)
	ld h,(ix+005h)
	call thrown_ahead
	ccf
	ret nc
	ld iy,0e500h
	ld b,008h
	ld de,00020h
lb7f3h:
	ld a,(iy+000h)
	cp 004h
	jr nz,lb81eh
	ld a,(ix+015h)
	cp (iy+015h)
	jr z,lb81eh
	ld a,(ix+010h)
	cp (iy+010h)
	jr nz,lb81eh
	ld a,l
	sub (iy+003h)
	add a,00fh
	cp 01eh
	jr nc,lb81eh
	ld a,h
	sub (iy+005h)
	add a,00fh
	cp 01eh
	jr c,lb824h
lb81eh:
	add iy,de
	djnz lb7f3h
	xor a
	ret
lb824h:
	ld a,(iy+006h)
	and a
	jr z,lb831h
	ld a,(ix+00bh)
	cp (iy+00bh)
	ret z
lb831h:
	scf
	ret
thrown_snap:                    ; 0xB833  snap X or Y to 8px from ix+11
	ld a,(ix+00bh)
	cp 002h
	jr c,lb847h
	ld a,(ix+005h)
	jr z,lb841h
	add a,007h
lb841h:
	and 0f8h
	ld (ix+005h),a
	ret
lb847h:
	and a
	ld b,a
	ld a,(ix+003h)
	jr z,lb850h
	add a,007h
lb850h:
	and 0f8h
	ld (ix+003h),a
	ret
lb856h:
	call thrown_reset
	ld (ix+00bh),001h
	ld de,00500h
	call thrown_dxy
	ld de,00000h
	call thrown_xy_d
	ld (ix+01ch),000h
	ld (ix+001h),003h
	jp laf48h
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
	jr nz,lb889h
	dec (ix+01ch)
lb889h:
	ld (ix+006h),001h
	call pick_anim
	call thrown_step
	jr nc,lb8a8h
	call pick_clash
	ret nc
	call thrown_snap
	call ix14_dc_end
	ld a,(ix+01ch)
	cp 003h
	ret c
	jp lb7bfh
lb8a8h:
	call thrown_snap
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+014h),000h
	ld (ix+001h),005h
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp sfx_25
	ld (ix+013h),001h
	ld a,(ix+001h)
	dec a
	jr z,lb8d6h
	dec a
	ret nz
	call thrown_align
	jr ix14_dc_end
lb8d6h:
	call thrown_align
	jr lb941h
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
	jr c,lb908h
	ld a,(0e203h)
	and 003h
	dec (ix+014h)
	ret nz
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
lb908h:
	call map_restore
	jp lb856h
pick_tick:                        ; 0xB90E
	ld a,(ix+014h)
	cp 012h
	jr z,ix14_dc_end
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
	call map_mark
	call map_hit
	jp c,lba7fh
lb941h:
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+013h),001h
	ld (ix+014h),0b4h
	ld (ix+001h),004h
	ret
map_stash:                      ; 0xB956  OR 2x2 bits into ix+18..1B
	call thrown_map
	call map_index
	call map_or
	ld a,e
	and a
	jr z,lb966h
	jp pe,lb969h
lb966h:
	ld (ix+018h),e
lb969h:
	ld a,d
	and a
	jr z,lb970h
	jp pe,lb973h
lb970h:
	ld (ix+019h),d
lb973h:
	call thrown_map
	ld a,h
	add a,008h
	ld h,a
	call map_index
	call map_or
	ld a,e
	and a
	jr z,lb987h
	jp pe,lb98ah
lb987h:
	ld (ix+01ah),e
lb98ah:
	ld a,d
	jr z,lb98eh
	ret pe
lb98eh:
	ld (ix+01bh),d
	ret
map_if_pick:                    ; 0xB992  map_mark if pick state 1/4
	ld a,(ix+001h)
	cp 004h
	jr z,lb99bh
	dec a
	ret nz
lb99bh:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
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
map_or:                         ; 0xB9C5  OR bitmask into two map bytes
	ld b,c
	ld a,003h
lb9c8h:
	rrca
	rrca
	djnz lb9c8h
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
map_if_pick2:                   ; 0xB9E0  map_restore if pick state 1/4
	ld a,(ix+001h)
	cp 004h
	jr z,lb9e9h
	dec a
	ret nz
lb9e9h:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
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
map_put:                        ; 0xBA0F  AND/OR two map bytes from DE
	ld a,0fch
	ld b,c
lba12h:
	rrca
	rrca
	djnz lba12h
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
	ld ix,0e500h
	ld b,008h
lba42h:
	push bc
	ld a,(ix+000h)
	cp 004h
	call z,map_if_pick2
	ld de,00020h
	add ix,de
	pop bc
	djnz lba42h
	ret
	ld ix,0e500h
	ld b,008h
lba5ah:
	push bc
	ld a,(ix+000h)
	cp 004h
	jr nz,lba65h
	call map_if_pick
lba65h:
	ld de,00020h
	add ix,de
	pop bc
	djnz lba5ah
	ret
map_hit:                        ; 0xBA6E  CY if stashed 2x2 has bit 0xAA
	ld a,(ix+018h)
	or (ix+019h)
	or (ix+01ah)
	or (ix+01bh)
	and 0aah
	ret z
	scf
	ret
lba7fh:
	call map_restore
	jp 06608h
tick_coffin:                      ; 0xBA85  E600 type 1: Vic push opens lid (states 6/7); no walk
	ld a,(ix+001h)
	cp 001h
	jp z,lbb0eh                   ; opening
	jp nc,lbb2bh                  ; closing
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(0e280h)
	and a
	jr nz,lbae5h
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld b,a
	ld a,(0e282h)
	add a,00fh
	sub (ix+002h)
	sub b
	jr nc,lbae5h
	ld a,(ix+007h)
	rra
	rra
	ld a,(0e284h)
	ld b,(ix+003h)
	jr c,lbaeah
	cp b
	jr nc,lbae5h
	add a,014h
	sub b
	jr c,lbae5h
	ld a,(0e208h)
	and 008h
	jr z,lbae5h
	dec (ix+006h)
	ret nz
	inc (ix+005h)
	ld a,007h
	ld (0e280h),a
	call sfx_21                   ; coffin
coffin_open:                    ; 0xBADA  Vic grab: E299=0, lid bit, next state
	xor a
	ld (0e299h),a
	set 0,(ix+007h)
	inc (ix+001h)
lbae5h:
	ld (ix+006h),00ah
	ret
lbaeah:
	cp b
	jr c,lbae5h
	sub 014h
	sub b
	jr nc,lbae5h
	ld a,(0e208h)
	and 004h
	jr z,lbae5h
	dec (ix+006h)
	ret nz
	dec (ix+005h)
	ld a,006h
	ld (0e280h),a
	call coffin_open
	inc (ix+001h)
	jp sfx_21
lbb0eh:
	dec (ix+006h)
	ret nz
	call lbae5h
	set 0,(ix+007h)
	inc (ix+005h)
	ld a,(ix+005h)
	cp 003h
	ret nz
	ld (ix+001h),000h
	set 1,(ix+007h)
	ret
lbb2bh:
	dec (ix+006h)
	ret nz
	call lbae5h
	set 0,(ix+007h)
	dec (ix+005h)
	ret nz
	xor a
	ld (ix+001h),a
	res 1,(ix+007h)
	ret
draw_coffin:                      ; 0xBB43  stamp via lbb53h (facing picks 9374 / 9394)
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld hl,09374h
	ld de,09374h
	ld bc,09374h
lbb53h:
	exx
	ld b,(ix+008h)
	ld c,002h
	ld d,(ix+003h)
	ld e,(ix+002h)
	call stamp_wtiles
	exx
	ld (0efc0h),hl
	ld (0efc2h),de
	ld (0efc4h),bc
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld hl,(0efc0h)
	call actor_row
	ld a,(ix+008h)
	cp 003h
	jr c,lbb90h
	ld b,a
	dec b
	dec b
lbb84h:
	ld hl,(0efc2h)
	push hl
	push bc
	call actor_row
	pop bc
	pop hl
	djnz lbb84h
lbb90h:
	ld hl,(0efc4h)
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
	jr nz,lbc2fh                  ; ix+1: 0 idle, else anim
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(0e280h)
	and a
	jr nz,lbc10h                  ; Vic must be walking
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld b,a                        ; height in pixels
	ld a,(0e282h)
	add a,00fh
	sub (ix+002h)
	sub b
	jr nc,lbc10h
	ld a,(ix+007h)
	rra
	rra                           ; bit 1 = facing
	ld a,(0e284h)
	ld b,(ix+003h)
	jr c,lbc15h                   ; face right: Vic from the left
	cp b
	jr nc,lbc10h
	add a,014h
	sub b
	jr c,lbc10h
	ld a,(0e208h)
	and 008h                      ; Vic holding right
	jr z,lbc10h
	dec (ix+006h)
	ret nz
	ld a,007h
	ld (0e280h),a                 ; coffin-pull right
lbbfah:
	xor a
	ld (0e299h),a
	set 0,(ix+007h)
	inc (ix+005h)
	inc (ix+001h)
	ld (ix+006h),008h
	call sfx_22                   ; pyoncy
	ret
lbc10h:
	ld (ix+006h),01eh
	ret
lbc15h:
	cp b
	jr c,lbc10h
	sub 014h
	sub b
	jr nc,lbc10h
	ld a,(0e208h)
	and 004h                      ; Vic holding left
	jr z,lbc10h
	dec (ix+006h)
	ret nz
	ld a,006h
	ld (0e280h),a                 ; coffin-pull left
	jr lbbfah
lbc2fh:
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
	jr lbc10h
draw_pyoncy:                      ; 0xBC50  same stamp path as coffin; facing picks 937C / 9394
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(ix+007h)
	rra
	rra
	ld hl,0937ch
	ld de,09384h
	ld bc,0938ch
	jp nc,lbb53h
	ld hl,09394h
	ld de,0939ch
	ld bc,093a4h
	jp lbb53h
start_rockroll:                   ; 0xBC74  post-pass: idle type 3 + Vic overlap -> fall
	ld ix,0e600h
	ld b,010h
lbc7ah:
	ld a,(ix+000h)
	cp 003h
	jr z,lbc89h
lbc81h:
	ld de,00010h
	add ix,de
	djnz lbc7ah
	ret
lbc89h:
	ld a,(ix+001h)
	and a
	jr nz,lbc81h                  ; already falling
	call rock_under
	jr nc,lbc81h
	inc (ix+001h)
	ld (ix+006h),01eh
	ret
rock_under:                     ; 0xBC9C  CY if Vic is under the column (same screen)
	ld a,(0e243h)
	cp (ix+004h)
	jr nz,lbcbeh
	ld a,(0e284h)
	add a,008h
	sub (ix+003h)
	cp 008h
	ret nc
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld c,a                        ; height in pixels
	ld a,(0e282h)
	sub (ix+002h)
	cp c
	ret
lbcbeh:
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
	jr nc,lbcddh
	inc (ix+005h)
	ret
lbcddh:
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
	call 063edh
	pop de
	ld a,(0e243h)
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
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(ix+00ah)
	ld (ix+00bh),a
	ld a,(0e282h)
	add a,014h
	sub (ix+002h)
	cp 008h
	jr nc,lbd46h
	ld a,(0e284h)
	add a,008h
	sub (ix+003h)
	cp 020h
	jr c,lbd75h
lbd46h:
	ld (ix+00ah),000h
	ld a,(ix+00bh)
	and a
	ret z
	ld a,(0e280h)
	and a
	ret nz
	inc (ix+006h)
	ld a,(ix+006h)
	cp 002h
	ret c
	ld (ix+000h),000h
	call trap_punch
	xor a
trap_erase:                     ; 0xBD65  stamp_rect 1x4 at trap XY
	ld bc,00104h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld d,(ix+004h)
	call 063edh
	ret
lbd75h:
	ld (ix+00ah),001h
	ret
trap_punch:                     ; 0xBD7A  sfx_27 + punch tiles / HMMM
	call sfx_27                   ; trap
	ld d,(ix+003h)
	ld e,(ix+002h)
	push ix
	pop hl
	ld a,(0f0f4h)
	and a
	jr nz,lbd98h
	ld a,00ch
	call ADD_HL_A
	ld bc,00104h
	call draw_tilemap
	ret
lbd98h:
	ld a,l
	add a,a
	ld h,a
	ld l,040h
	jr nc,lbda1h
	ld l,050h
lbda1h:
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
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
stamp_trap:                       ; 0xBDC0  4× tile 0x61 (editor + draw_trap tail)
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld b,004h
lbdc8h:
	push de
	ld a,(0f0f4h)
	and a
	ld a,061h
	jr z,lbdd3h
	ld a,0adh
lbdd3h:
	call tile_pset
	pop de
	ld a,d
	add a,008h
	ld d,a
	djnz lbdc8h
	ret
trap_save:                      ; 0xBDDE  stash trap tiles before punch
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld a,(0f0f4h)
	and a
	jr nz,lbe00h
	call scr5_addr
	push ix
	pop de
	ld a,00ch
	call ADD_DE_A
	ld b,004h
lbdf7h:
	call 00174h
	ld (de),a
	inc hl
	inc de
	djnz lbdf7h
	ret
lbe00h:
	push ix
	pop de
	ld a,e
	add a,a
	ld d,a
	ld e,040h
	jr nc,lbe0ch
	ld e,050h
lbe0ch:
	ld bc,02008h
	ld a,004h
	call vdp_hmmm
	ret
secret_hit:                       ; 0xBE15  jump/land on obj2 (0xE7C0) to reveal
	ld hl,0e7c0h
	ld b,010h
lbe1ah:
	ld a,(0e243h)
	cp (hl)
	push bc
	push hl
	call z,secret_reveal
	pop hl
	ld a,004h
	call ADD_HL_A
	pop bc
	djnz lbe1ah
	ret
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
	ld a,(0e282h)
	sub c
	cp b
	ret nc
	ld a,(0e284h)
	sub d
	cp 010h
	ret nc
	ld a,(0e2a7h)
	and a
	jr z,lbe6dh
	xor a
	ld (0e2a7h),a
	ld a,(hl)
	and 020h                      ; armed by vic_climb (E280==2)
	ret z
	res 5,(hl)                    ; reveal
	ld a,(hl)
	and 0c0h
	rlca
	rlca
	dec a
	jr z,lbe76h                   ; punch tiles / spawn door
	rrca
	rrca
	ld c,a
	ld a,(hl)
	and 03fh
	or c
	ld (hl),a
	ret
lbe6dh:
	ld a,(0e280h)
	cp 002h                       ; vic_climb arms bit 5
	ret nz
	set 5,(hl)
	ret
lbe76h:
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
	ld (0eff0h),a
	ld b,a
	push bc
	call nz,056dch
	pop bc
	pop de
	pop hl
	dec hl
	dec hl
	dec hl
	ld (hl),000h
	ex de,hl
	ld a,(0e243h)
	ld d,a
	ld c,002h
	push hl
	push de
	push bc
	ld a,002h
	ld b,001h
	call 063edh
	pop bc
	pop de
	pop hl
	ld a,l
	add a,008h
	ld l,a
	ld a,(0eff0h)
	and a
	ld a,000h
	call nz,063edh
	call stones_redraw
	call draw_maptools
	ld hl,0e282h
	ld a,(hl)
	add a,003h
	and 0f8h
	ld (hl),a
	jp sfx_40
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
