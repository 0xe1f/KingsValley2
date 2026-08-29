; ===========================================================================
;  banks 1–3 — boot triplet via page_banks_123, CPU 0x6000–0xBFFF (one PHASE).
;  24 KiB window file. Bank 0 @ 0x4000 stays separate (never remapped).
;  ld hl,0E2F3h @ 0x7FFE is a real instruction (was split across 8 KiB files).
;  Regen per 8 KiB: regen-bank.sh {1,2,3} with banks/bank0N.blocks
; ===========================================================================

; (org set by PHASE 0x6000 in master; 24 KiB through 0xBFFF)
	call print_stream
	call print_stream
	call 05d41h
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
	call 0583bh
	ld a,001h
	ld (0e2c2h),a
	ld b,0b4h
	ret

; BLOCK 'e800_copy' (start 0x6039 end 0x6059)
e800_copy_start:
	defb 014h
	defb 048h
	defb 000h
	defb 000h
	defb 014h
	defb 058h
	defb 008h
l6040h:
	defb 000h
	defb 014h
	defb 068h
	defb 010h
	defb 000h
	defb 014h
	defb 078h
	defb 018h
	defb 000h
	defb 014h
	defb 048h
	defb 004h
	defb 000h
	defb 014h
	defb 058h
	defb 00ch
	defb 000h
	defb 014h
	defb 068h
	defb 014h
	defb 000h
	defb 014h
	defb 078h
	defb 01ch
	defb 000h
e800_copy_end:
	ld a,(0edc0h)
	call DISPATCH_A

; BLOCK 'edc0_jp' (start 0x605f end 0x6067)
edc0_jp_start:
	defw 06067h
	defw 0609fh
	defw 060c2h
	defw 06077h
edc0_jp_end:
	ld a,(0e20ch)
	rra
	rra
	ret nc
	call 04e98h
	call sub_6078h
l6073h:
	ld hl,0edc0h
	inc (hl)
	ret
sub_6078h:
	call page_bank_13
	ld hl,0bf36h
	ld de,00838h
	ld bc,0128bh
	call copy_tiles
	ld hl,0bfc6h
	ld de,09838h
	ld bc,00607h
	call copy_tiles
	ld de,0bf29h
	ld hl,0f800h
	call 04e54h
	jp page_banks_123
	call 062d8h
	call sub_60e1h
	call sub_6263h
	call 05d41h
	call sub_622fh
	call sub_61e3h
	call 0583bh
	ld de,0c000h
	ld hl,0f400h
	ld bc,00280h
	call 04dfbh
	jr l6073h
	ld a,(0e20ch)
	rra
	rra
	ret nc
	call 04e98h
	call 05bebh
	call 05cf5h
	call 05859h
	call 09866h
	call sub_6645h
	xor a
	ld (0edc0h),a
	jp 057d8h
sub_60e1h:
	call sub_60edh
	call sub_6128h
	call sub_6163h
	jp l619eh
sub_60edh:
	ld de,0ed80h
	ld b,008h
l60f2h:
	ld a,(de)
	inc a
	ret z
	dec a
	call sub_60feh
	inc de
	inc de
	djnz l60f2h
	ret
sub_60feh:
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
	ld hl,l61d9h
	ld c,0ffh
	call 051dah
	pop de
	pop bc
	ret
sub_6128h:
	ld de,0ed90h
	ld b,008h
l612dh:
	ld a,(de)
	inc a
	ret z
	dec a
	call sub_6139h
	inc de
	inc de
	djnz l612dh
	ret
sub_6139h:
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
	ld hl,061dch
	ld c,0ffh
	call 051dah
	pop de
	pop bc
	ret
sub_6163h:
	ld de,0eda0h
	ld b,008h
l6168h:
	ld a,(de)
	inc a
	ret z
	dec a
	call sub_6174h
	inc de
	inc de
	djnz l6168h
	ret
sub_6174h:
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
	ld hl,l61dfh
	ld c,0ffh
	call 051dah
	pop de
	pop bc
	ret
l619eh:
	ld de,0edb0h
	ld b,008h
l61a3h:
	ld a,(de)
	inc a
	ret z
	dec a
	call sub_61afh
	inc de
	inc de
	djnz l61a3h
	ret
sub_61afh:
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
	ld hl,l61e1h
	ld c,0ffh
	call 051dah
	pop de
	pop bc
	ret
l61d9h:
	di
	call p,0f5ffh
	or 0ffh
l61dfh:
	rst 30h
	rst 38h
l61e1h:
	ret m
	rst 38h
sub_61e3h:
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
	call sub_6301h
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
	call sub_6315h
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
sub_622fh:
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
	call sub_62b5h
	call sub_6315h
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
sub_6263h:
	ld hl,0e700h
	ld b,010h
l6268h:
	ld a,(hl)
	or a
	call nz,sub_6274h
	ld de,00008h
	add hl,de
	djnz l6268h
	ret
sub_6274h:
	push hl
	push bc
	call sub_627ch
	pop bc
	pop hl
	ret
sub_627ch:
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
	call sub_62b5h
	call sub_6315h
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
	ld hl,l62cch
	call ADD_HL_A
	ld a,(hl)
	jp 05767h
sub_62b5h:
	call sub_6301h
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
l62cch:
	jp pe,0ebebh
	call pe,0eeedh
	xor 0efh
	ret p
	pop af
	pop af
	jp p,08821h
	rst 20h
	ld c,007h
l62ddh:
	ld b,008h
l62dfh:
	ld a,(hl)
	or a
	call nz,sub_62ebh
	inc hl
	djnz l62dfh
	dec c
	jr nz,l62ddh
	ret
sub_62ebh:
	push af
	push bc
	push hl
	call sub_62f5h
	pop hl
	pop bc
	pop af
	ret
sub_62f5h:
	call sub_6301h
	call sub_6315h
	ld hl,l631eh
	jp 051fah
sub_6301h:
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
sub_6315h:
	ld a,d
	add a,020h
	ld d,a
	ld a,e
	add a,018h
	ld e,a
	ret
l631eh:
	pop hl
	jp po,0e3e2h
	cp 0e4h
	push hl
	push hl
	and 0feh
	rst 20h
	ret pe
	ret pe
	jp (hl)
	rst 38h
	call page_bank_13
	call load_actors
	jp page_banks_123
load_actors:                      ; 0x6336  aae0_tbl[level] -> 0xE600 (16 x 16)
	ld a,(0e242h)
	ld hl,0aae0h
	call 04d4ch
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
	ld c,003h
	jr l639eh
	ld c,000h
l639eh:
	ld b,010h
	ld ix,0e600h
l63a4h:
	push bc
	ld a,(ix+000h)
	and a
	call nz,sub_63b5h
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l63a4h
	ret
sub_63b5h:
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
sub_63edh:
	ld (0efc0h),a
	ld a,d
	ld (0efc1h),a
	call 04d7bh
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
	call 05d32h
	call ADD_HL_A
	push bc
	ld a,0fch
	call sub_6439h
	and (hl)
	ld (hl),a
	ld a,(0efc0h)
	and a
	jr z,l642ah
	call sub_6439h
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
sub_6439h:
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
	ld ix,0e600h
	ld b,010h
l6450h:
	push bc
	ld a,(ix+000h)
	and a
	call nz,sub_64bch
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l6450h
	ret
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
	ld ix,0e600h
	ld b,010h
l6489h:
	push bc
	call sub_649bh
	call sub_64aeh
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l6489h
	jp start_rockroll
sub_649bh:
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
	defw 093f3h                   ; type 5 stone (pushable)
d_64a1_jp_end:
sub_64aeh:
	ld a,(ix+007h)
	rra
	ret nc
	res 0,(ix+007h)
	ld hl,l64cfh
	jr l64c6h
sub_64bch:
	ld hl,l64d9h
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
l64c6h:
	ld a,(ix+000h)
	and a
	ret z
	dec a
	jp 0409ah
l64cfh:                           ; 0x64CF  dirty redraw (ix+7 bit 0)
	defw 0bb43h                   ; 1 coffin
	defw 0bc50h                   ; 2 Pyoncy
	defw 0bce2h                   ; 3 Rock Roll (falling tiles)
	defw 06460h                   ; 4 trap (ret)
	defw 09636h                   ; 5 stone
l64d9h:                           ; 0x64D9  on-screen draw
	defw 0bb43h                   ; 1 coffin
	defw 0bc50h                   ; 2 Pyoncy
	defw 06460h                   ; 3 (ret)
	defw 0bdaah                   ; 4 trap tiles
	defw 06460h                   ; 5 (ret)
	ld hl,0e700h
	ld b,080h
	xor a
l64e9h:
	ld (hl),a
	inc hl
	djnz l64e9h
	call page_bank_13
	call load_gems
	jp page_banks_123
load_gems:                        ; 0x64F6  a75d_tbl[level] -> 0xE700 soul stones (16 x 8)
	ld a,(0e242h)
	ld hl,0a75dh
	call 04d4ch
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
	call nz,sub_6536h
	ld de,00008h
	add ix,de
	pop bc
	inc c
	djnz l6524h
	ret
sub_6536h:
	ld a,(0e243h)
	cp (ix+001h)
	ret nz
sub_653dh:
	ld hl,09324h
	ld e,(ix+002h)
	ld d,(ix+003h)
	ld bc,00202h
	jp draw_tilemap
	ld ix,0e500h
	ld b,008h
l6552h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l6563h
	call sub_65f6h
	bit 0,(ix+006h)
	call nz,sub_656ch
l6563h:
	ld de,00020h
	add ix,de
	pop bc
	djnz l6552h
	ret
sub_656ch:
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
	call sub_65dfh
	ld hl,0f000h
	jr l6587h
l65c1h:
	ld a,004h
	call sub_65dfh
	ld hl,00000h
	jr l6587h
l65cbh:
	ld a,001h
	call sub_65dfh
	ld hl,0b000h
	jr l65b0h
l65d5h:
	ld a,002h
	call sub_65dfh
	ld hl,00000h
	jr l65b0h
sub_65dfh:
	ld b,(ix+016h)
	call 05e38h
	ld (ix+016h),h
	ld (ix+010h),l
	ld a,l
	call 0ad15h
	ld (ix+00ch),e
	ld (ix+00dh),d
	ret
sub_65f6h:
	ld a,(ix+000h)
	dec a
	ret m
	call DISPATCH_A

; BLOCK 'd_65fb_jp' (start 0x65fe end 0x6608)
d_65fb_jp_start:
	defw 0ad80h                   ; tool 1 knife (thrown; 5 states)
	defw 0ae23h                   ; tool 2 boomerang (returns; 6 states)
	defw 0b2aah                   ; tool 3 shovel (HUD "scoop"; floor, 1 deep)
	defw 0b68eh                   ; tool 4 pick (floor, 2 deep)
	defw 0662dh                   ; tool 5 hammer (wall, 1 deep; not in stock pickups)
d_65fb_jp_end:
	ld a,(0e243h)
	cp (ix+010h)
	call z,042b7h
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
	ld hl,l663dh
	ld de,l6641h
	call 0b6e0h
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
sub_6645h:
	call sub_6664h
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
sub_6664h:
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
	call page_bank_13
	ld bc,0beedh
	add hl,bc
	ld c,(ix+01eh)
	call sub_66f3h
	ld c,(ix+01fh)
	call sub_66f3h
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
	call page_bank_13
	ld bc,0becfh                  ; E500 SAT patterns (ix+11)
	add hl,bc
	ld c,(ix+01eh)
	call sub_66f3h
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
sub_66f3h:
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
	call page_bank_13
	ld hl,0e2c0h
	ld b,028h
	xor a
l6758h:
	ld (hl),a
	inc hl
	djnz l6758h
	ld hl,0b7cdh                  ; delayed pickups -> 0xE2C0
	ld a,(0e242h)
	call 04d4ch
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
	call 04e98h
	call page_bank_12
	ld hl,0b185h
	call print_stream
	call page_banks_123
	xor a
	ld (0e24bh),a
	jp l67ech
	call 0583bh
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
	call 042cbh
	dec (hl)
	ld a,(hl)
	rla
	jr nc,l67c5h
	ld (hl),002h
	jr l67c5h
l67bah:
	call 042cbh
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
l67ech:
	call page_bank_12
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
	call 04e98h
	ld bc,0a201h
	call 00047h
	call 05970h
	call 05b52h
	call 05ad8h
	call 05d41h
	ld a,004h
	call 059dch
	ld bc,0e201h
	call 00047h
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
	ld a,(0e257h)
	cp 009h
	jr nc,l684dh
	ld a,(0e207h)
	and 010h
	jp nz,l6945h
l684dh:
	call sub_685bh
	ld a,(0e257h)
	cp 009h
	call c,sub_7786h
	jp 0583bh
sub_685bh:
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)
	call DISPATCH_A

; BLOCK 'e257_jp' (start 0x6865 end 0x687b)
e257_jp_start:
	defw 0687bh
	defw 06889h
	defw 06895h
	defw 068b1h
	defw 068fbh
	defw 06914h
	defw 06923h
	defw 06926h
	defw 06933h
	defw 06940h
	defw 06971h
e257_jp_end:
	call 05d41h
	ld a,010h
l6880h:
	ld hl,0e204h
	ld (hl),a
l6884h:
	ld hl,0e257h
	inc (hl)
	ret
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,0a8h
	ld (0edcbh),a
	jr l6884h
	call sub_776ah
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
	jr l6884h
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
	jr l6884h

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
	call sub_776ah
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
	jp l6880h
	ld a,006h
l6916h:
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (0edd8h),a
	ld a,010h
	jp l6880h
	xor a
	jr l6916h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,008h
	call sub_77d7h
	jp l6884h
	call sub_781ch
	ld a,(0e880h)
	or a
	ret nz
	ld a,020h
	jp l6880h
	ld hl,0e204h
	dec (hl)
	ret nz
l6945h:
	call 04e98h
	call 04ecbh
	call 05d41h
	ld bc,0a201h
	call 00047h
	ld de,05040h
	call 059afh
	ld bc,0e201h
	call 00047h
	ld hl,0ac01h
	call sub_771ch
	ld a,080h
	ld (0e204h),a
	ld a,00ah
	ld (0e257h),a
	ret
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,001h
	ld (0e24ah),a
	ret
sub_697ch:
	call sub_6994h
	ld a,0ffh
	ld (0ede1h),a
	ld hl,l69ffh
	call print_stream
	ld de,05ca0h
	ld hl,0edd9h
	call 051dah
	ret
sub_6994h:
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
	call sub_69e0h
	ld h,l
	ld a,h
	ld (0ede6h),a
	call sub_69e0h
	ld h,c
	ld a,h
	ld (0ede7h),a
	call sub_69e0h
	ld hl,0ede5h
	ld a,(hl)
	inc hl
	add a,(hl)
	inc hl
	add a,(hl)
	inc hl
	ld (hl),a
	ld h,a
	call sub_69e0h
	ret
sub_69e0h:
	ld a,h
	rrca
	rrca
	rrca
	rrca
	and 00fh
	call sub_69f5h
	ld (de),a
	inc de
	ld a,h
	and 00fh
	call sub_69f5h
	ld (de),a
	inc de
	ret
sub_69f5h:
	ld b,0e1h
	cp 019h
	jr c,l69fdh
	ld b,0d1h
l69fdh:
	add a,b
	ret
l69ffh:
	ld e,b
	sub b
	ret p
	pop hl
	di
	di
	nop
	rst 30h
	rst 28h
	jp p,0ffe4h
	call 04e98h
	call sub_7aa6h
	ld hl,0edd9h
	ld de,0eddah
	ld bc,00025h
	ld (hl),a
	ldir
	ld a,020h
	ld (0edeeh),a
	xor a
	ld (0e207h),a
	call page_bank_13
	ld hl,0be91h
	call print_stream
	jp page_banks_123
	call 0583bh
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
	call sub_6b67h
	ld hl,0edefh
	ld a,(0e207h)
	rra
	rra
	rra
	jp c,l6b7fh
	rra
	jp c,l6b86h
	call sub_6c2eh
	call sub_6b8eh
	ld a,(0ededh)
	or a
	jr z,l6a6ch
	call sub_6c01h
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
	call sub_6b24h
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
	call page_bank_13
	call print_stream
	call page_banks_123
	call 05d41h
	ld hl,0edebh
	inc (hl)
	inc hl
	ld (hl),080h
	ret
sub_6b24h:
	ld de,l6b57h
	call sub_6b47h
	jr z,l6b3dh
	ld de,l6b5fh
	call sub_6b47h
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
sub_6b47h:
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
l6b57h:
	ld b,(hl)
	ld b,l
	ld d,e
	ld d,h
	ld c,c
	ld d,(hl)
	ld b,c
	ld c,h
l6b5fh:
	ld d,h
	ld d,d
	ld e,c
	ld b,c
	ld b,a
	ld b,c
	ld c,c
	ld c,(hl)
sub_6b67h:
	ld hl,0e800h
	ld (hl),06fh
	inc hl
	ld a,(0edefh)
	ld de,l6c26h
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
	jp 042cbh
l6b86h:
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp 042cbh
sub_6b8eh:
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
sub_6c01h:
	ld a,(0edefh)
	ld hl,l6c26h
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
l6c26h:
	ld h,b
	ld l,b
	ld (hl),b
	ld a,b
	add a,b
	adc a,b
	sub b
	sbc a,b
sub_6c2eh:
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
	call sub_6c85h
	call sub_6ca7h
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ret
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	call sub_6c85h
	call sub_6d57h
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ret
l6c6dh:
	ld b,e
	jp po,00001h
	ld e,h
	jp po,00023h
	add a,d
	jp po,00003h
	ret nz
	jp po,00240h
	nop
	and 000h
	ld (bc),a
	nop
	jp (hl)
	ret nz
	inc b
sub_6c85h:
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
sub_6ca7h:
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
	ld hl,l6c6dh
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
sub_6d57h:
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
	ld hl,l6c6dh
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
	call sub_6f06h
	pop bc
	ld a,(0f0f7h)
	inc a
	jr z,l6f01h
	set 1,b
l6f01h:
	ld a,b
	ld (0f0f9h),a
	ret
sub_6f06h:
	ld bc,00400h
	ld hl,0fcc1h
l6f0ch:
	push bc
	push hl
	ld a,(hl)
	bit 7,a
	jr nz,l6f19h
	ld a,c
	call sub_6f39h
	jr l6f1ch
l6f19h:
	call sub_6f29h
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
sub_6f29h:
	and 080h
	or c
	ld b,004h
l6f2eh:
	push bc
	call sub_6f39h
	pop bc
	ret c
	add a,004h
	djnz l6f2eh
	ret
sub_6f39h:
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
	call sub_6f63h
	jp 0583bh
sub_6f63h:
	ld hl,0edc9h
	inc (hl)
	ld a,(0e257h)
	dec a
	call DISPATCH_A

; BLOCK 'd_6f6b_jp' (start 0x6f6e end 0x6f84)
d_6f6b_jp_start:
	defw 06f84h
	defw 06fe5h
	defw 06ffdh
	defw 07047h
	defw 07062h
	defw 07078h
	defw 0708dh
	defw 0709ah
	defw 070bdh
	defw 070cdh
	defw 070f3h
d_6f6b_jp_end:
	call 05fa6h
	ld bc,00007h
	call 04e19h
	call page_banks_14_15
	ld hl,0a870h
	call palette_list
	call page_banks_123
	call 05961h
	call 05b16h
	call 05d41h
	call 05a5ch
	ld hl,l71cah
	call sub_6fd5h
	xor a
	ld (0edc8h),a
	call 04e98h
	ld bc,0a201h
	call 00047h
	call 059ach
	call 05a8ch
	call sub_71c1h
	ld bc,0e201h
	call 00047h
	call 0421ch
	ld a,03ch
l6fcch:
	ld hl,0e204h
	ld (hl),a
l6fd0h:
	ld hl,0e257h
	inc (hl)
	ret
sub_6fd5h:
	ld a,(0e241h)
	dec a
	add a,a
	call ADD_HL_A
	ld de,0edcbh
	ldi
	ldi
	ret
	call sub_71c1h
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	ld (0edd8h),a
	inc a
	ld (0edceh),a
	call sub_71a5h
	ld a,008h
	jp l6fcch
	ld a,(0e207h)
l7000h:
	and 030h
	jr z,l7015h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,l71d4h
	call sub_6fd5h
	call sub_7042h
	jp l71b8h
l7015h:
	call sub_701bh
	jp l71b8h
sub_701bh:
	ld b,007h
	call sub_7159h
	ld a,(0edceh)
	cp 007h
	ld a,(0edd8h)
	call z,sub_7108h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),008h
	call sub_717ch
	call sub_7168h
	jr z,sub_7042h
	call sub_7140h
	ld hl,0edc8h
	inc (hl)
	ret
sub_7042h:
	ld a,008h
	jp l6fcch
	ld b,007h
	call sub_7159h
	ld hl,0e204h
	dec (hl)
	jp nz,l71b8h
	xor a
	call sub_7108h
	call 05a17h
l705ah:
	ld a,008h
	call l6fcch
	jp l71b8h
	ld b,007h
	call sub_7159h
	ld hl,0e204h
	dec (hl)
	jp nz,l71b8h
	ld a,001h
	call sub_7108h
	call 05a29h
	jr l705ah
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	call sub_7108h
	call 05a3bh
	call 05fa6h
	call 05a74h
	jp l6fd0h
	ld a,006h
	ld (0edc8h),a
	call sub_711bh
	ld a,010h
	jp l6fcch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),010h
	ld hl,0edc8h
	dec (hl)
	ld a,(hl)
	cp 005h
	push hl
	call z,042fbh
	pop hl
	ld a,(hl)
	cp 0ffh
	jp nz,sub_711bh
	ld (hl),000h
	ld a,004h
	call sub_77d7h
	jp l6fd0h
	call sub_781ch
	ld a,(0e880h)
	or a
	ret nz
	call 05d41h
	ld a,010h
	jp l6fcch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld (hl),010h
	ld hl,0edc8h
	inc (hl)
	ld a,(hl)
	dec a
	push hl
	call z,042fbh
	pop hl
	ld a,(hl)
	cp 006h
	call z,04294h
	ld a,(hl)
	cp 007h
	jp nz,sub_711bh
	call 0431bh
	ld a,0c0h
	jp l6fcch
	ld hl,0e204h
	dec (hl)
	ret nz
	call 04313h
	call 041e0h
	xor a
	ld (0e257h),a
	call 04e98h
	jp 05bebh
sub_7108h:
	ld hl,00040h
	or a
	jr z,l7110h
	ld h,060h
l7110h:
	ld de,08828h
	ld bc,06080h
	ld a,001h
	jp 05029h
sub_711bh:
	push af
	ld hl,l6040h
	ld de,0a030h
	ld bc,03070h
	ld a,001h
	call 05029h
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
	jp 05029h
sub_7140h:
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
sub_7159h:
	ld hl,0edceh
	dec (hl)
	ret nz
	ld (hl),b
	ld a,(0edd8h)
	xor 003h
	ld (0edd8h),a
	ret
sub_7168h:
	ld a,(0e241h)
	dec a
	ld hl,l7177h
	call ADD_HL_A
	ld a,(0edc8h)
	cp (hl)
	ret
l7177h:
	ld e,b
	cp b
	adc a,b
	adc a,(hl)
	sub l
sub_717ch:
	call page_bank_13
	call sub_7185h
	jp page_banks_123
sub_7185h:
	ld hl,0ba57h
	ld a,(0e241h)
	dec a
	call 04d4ch
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
sub_71a5h:
	call page_bank_12
	ld hl,0ac13h
	ld a,(0e241h)
	dec a
	call 04d4ch
	call print_stream
	jp page_banks_123
l71b8h:
	call page_bank_12
	call 0bdd7h
	jp page_banks_123
sub_71c1h:
	call page_bank_12
	call 0bddah
	jp page_banks_123
l71cah:
	dec hl
	ld c,(hl)
	dec sp
	ld l,063h
	jr nc,$+104
	ld d,e
	ld d,e
	ld e,(hl)
l71d4h:
	dec sp
	jr c,l7235h
	dec hl
	ld l,e
	ld c,(hl)
	ld c,(hl)
	ld h,e
	ld c,b
	ld b,(hl)
	ld de,0e257h
	ld a,(de)
	dec a
	call DISPATCH_A

; BLOCK 'd_71e3_jp' (start 0x71e6 end 0x71f6)
d_71e3_jp_start:
	defw 071f6h
	defw 0721fh
	defw 07296h
	defw 072e1h
	defw 07313h
	defw 07331h
	defw 0733bh
	defw 07342h
d_71e3_jp_end:
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
	jp 09010h
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
	ld hl,l7280h
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
l7280h:
	ret m
	dec c
	ret m
	ld c,(hl)
	ex af,af'
	dec c
	ex af,af'
	ld c,(hl)
l7288h:
	call 05d41h
	ld hl,0e257h
	inc (hl)
	inc hl
	ld (hl),000h
	inc hl
	ld (hl),004h
	ret
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
	call sub_72d2h
	pop bc
	ld a,017h
	sub c
	add a,a
	add a,a
	add a,a
	ld e,a
	call sub_72d2h
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
sub_72d2h:
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
	ld hl,0e242h
	inc (hl)
	xor a
	ld (0e249h),a
	call 04e98h
	call page_bank_12
	ld hl,0b256h
	call print_stream
	call page_banks_123
	ld c,0ffh
	ld hl,l5f0eh
	ld de,edc0_jp_end+1
	call 051dah
	ld de,08868h
	call 04d1fh
	ld a,03ch
l730bh:
	ld (0e204h),a
	ld hl,0e257h
	inc (hl)
	ret
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
	jr l730bh
	ld hl,0e204h
	dec (hl)
	ret nz
	call sub_697ch
	jr l730bh
	ld a,(0e207h)
	and a
	ret z
	jr l730bh
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0e257h
	ld (hl),000h
	ret
	call sub_7353h
	jp 0583bh
sub_7353h:
	ld hl,0edc9h
	inc (hl)
	call sub_781ch
	ld de,0e257h
	ld a,(de)
	dec a
	call DISPATCH_A

; BLOCK 'd_735f_jp' (start 0x7362 end 0x73e4)
d_735f_jp_start:
	defw 073e4h
	defw 073fdh
	defw 07406h
	defw 07412h
	defw 07445h
	defw 07457h
	defw 07462h
	defw 0746fh
	defw 07496h
	defw 074b7h
	defw 074c3h
	defw 074e1h
	defw 07514h
	defw 07521h
	defw 0755bh
	defw 0756fh
	defw 075a7h
	defw 075c9h
	defw 075dch
	defw 075e4h
	defw 075f1h
	defw 07609h
	defw 07613h
	defw 07634h
	defw 07641h
	defw 0765ch
	defw 07669h
	defw 07679h
	defw 07697h
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076ebh
	defw 076bdh
	defw 076d1h
	defw 076d9h
	defw 076f8h
d_735f_jp_end:
	call 04e98h
	call sub_775dh
	call 05d41h
	call 05b16h
	ld a,00ah
	call sub_77d7h
	ld hl,0acc3h
	call sub_771ch
	jr l7440h
	ld a,(0e880h)
	or a
	ret nz
	ld a,0f0h
	jr l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sub_77d7h
	jr l7440h
	ld a,(0e880h)
	or a
	ret nz
	call 04e98h
	call sub_775dh
	call 05970h
	call 05aa5h
	call 05d41h
	ld bc,0a201h
	call 00047h
	ld de,05010h
	call 059afh
	ld a,009h
	call sub_77d7h
	ld bc,0e201h
	call 00047h
	call 04235h
l7440h:
	ld hl,0e257h
	inc (hl)
	ret
	ld a,(0e880h)
	or a
	ret nz
	ld hl,0ad12h
	call sub_771ch
	ld a,00ah
	call sub_77d7h
	jr l7440h
	ld a,(0e880h)
	and a
	ret nz
l745ch:
	ld hl,0e204h
	ld (hl),a
	jr l7440h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	call 04e98h
	call 04e98h
	call 0597fh
	ld de,07707h
	ld a,005h
	call palette_set
	call page_bank_12
	call 0bc6eh
	call page_banks_123
	call sub_7703h
	ld a,060h
	jp l745ch
	call sub_7703h
	ld hl,0e204h
	dec (hl)
	ret nz
	xor a
	call sub_77d7h
	ld bc,0a201h
	call 00047h
	ld de,05020h
	call 059beh
	ld bc,0e201h
	call 00047h
	jp l7440h
	call sub_7703h
	ld a,(0e880h)
	or a
	ret nz
	ld a,0a0h
	jr l745ch
	ld hl,0e204h
	dec (hl)
	jr z,l74d8h
	ld a,(hl)
	cp 030h
	call z,sub_74d2h
	jp sub_7703h
sub_74d2h:
	ld a,001h
	ld (0e902h),a
	ret
l74d8h:
	xor a
	ld (0edceh),a
	ld a,050h
	jp l745ch
	call sub_7703h
	ld hl,0e204h
	dec (hl)
	jr z,l750fh
	ld a,(hl)
	and 007h
	ret nz
	call page_bank_12
	ld hl,0af37h
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
	call 05767h
	ld hl,0edceh
	inc (hl)
	call page_banks_123
	jp 042f7h
l750fh:
	ld a,090h
	jp l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,001h
	call sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	call 04e98h
	call 04e98h
	call 04ecbh
	call 05b5eh
	call 0598eh
	call 05d41h
	ld bc,0a201h
	call 00047h
	ld de,05020h
	call 059cdh
	call 05a4dh
	ld bc,0e201h
	call 00047h
	ld hl,0ad69h
	call sub_771ch
	ld a,080h
	call l745ch
	jp 042dfh
	call sub_7737h
	call sub_774bh
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0ad58h
	call sub_771ch
	jp l7440h
	call sub_7737h
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
	call 05029h
	ld hl,048b0h
	ld de,008a0h
	xor a
	call 050beh
	xor a
	call l745ch
	jp 042e7h
	ld hl,0e204h
	dec (hl)
	ld a,(hl)
	or a
	jr z,l75b8h
	cp 080h
	jp c,l770ch
	jp z,042ebh
	ret
l75b8h:
	ld bc,00007h
	call 00047h
	call 04e98h
	call sub_775dh
	ld a,078h
	jp l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld hl,0aeddh
	call sub_771ch
	ld a,00ah
	call sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	jp l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,003h
	call sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	call 04e98h
	ld a,002h
	call sub_77d7h
	ld a,00fh
	call 059dch
	call 04221h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	ld a,020h
	jp l745ch
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
	call sub_7786h
	ld a,006h
	call sub_77d7h
	jp l7440h
	call sub_7786h
	ld a,(0e880h)
	or a
	ret nz
	ld a,030h
	jp l745ch
	call sub_7786h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,004h
	ld (0edd8h),a
	ld hl,0af21h
	call sub_771ch
	ld a,00bh
	call sub_77d7h
	jp l7440h
	call sub_7786h
	ld a,(0e880h)
	or a
	ret nz
	ld a,0b4h
	jp l745ch
	call sub_7786h
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,002h
	ld (0edd8h),a
	jp l7440h
	call sub_776ah
	ld hl,0edc9h
	ld a,(hl)
	and 003h
	jp nz,sub_7786h
	ld hl,0edcch
	dec (hl)
	ld a,(hl)
	cp 030h
	jp nc,sub_7786h
	ld a,007h
	call sub_77d7h
	jp l7440h
	call sub_776ah
	ld hl,0edc9h
	ld a,(hl)
	and 003h
	jp nz,l76a7h
	ld hl,0edcch
	dec (hl)
l76a7h:
	ld a,(0e880h)
	or a
	jp nz,sub_7786h
	call 04e98h
	call 05d41h
	xor a
	ld (0edcfh),a
	ld a,008h
	jp l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	call sub_7725h
	ld hl,0edcfh
	inc (hl)
	ld a,00ah
	call sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	jp l745ch
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,(0edcfh)
	cp 009h
	ld a,003h
	call c,sub_77d7h
	jp l7440h
	ld a,(0e880h)
	or a
	ret nz
	call 04e98h
	ld a,020h
	jp l745ch
	ld a,(0e208h)
	and 030h
	ret z
	sub a
	ld (0e257h),a
	ret
sub_7703h:
	call page_bank_12
	call 0bcd2h
	jp page_banks_123
l770ch:
	ld a,(0edc9h)
	rra
	rra
	ld bc,00007h
	jp c,00047h
	ld b,00bh
	jp 00047h
sub_771ch:
	call page_bank_12
	call print_stream
	jp page_banks_123
sub_7725h:
	call page_bank_12
	ld a,(0edcfh)
	ld hl,0ad76h
	call 04d4ch
	call print_stream
	jp page_banks_123
sub_7737h:
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
sub_774bh:
	ld a,(0e204h)
	rra
	rra
	ld de,l7000h
	jr c,l7758h
	ld de,00007h
l7758h:
	ld a,00ch
	jp palette_set
sub_775dh:
	ld b,010h
l775fh:
	ld a,b
	inc a
	ld de,00000h
	call palette_set
	djnz l775fh
	ret
sub_776ah:
	ld a,(0edc9h)
	and 00fh
	ret nz
	ld hl,0edceh
	inc (hl)
	ld a,(hl)
	and 003h
	ld hl,l7782h
	call ADD_HL_A
	ld a,(hl)
	ld (0edd8h),a
	ret
l7782h:
	ld bc,00302h
	ld (bc),a
sub_7786h:
	ld hl,0e800h
	exx
	ld de,l77bbh
	ld a,(0edd8h)
	add a,a
	add a,a
	call ADD_DE_A
	exx
	ld a,(0edcbh)
	ld e,a
	ld a,(0edcch)
	ld d,a
	call sub_77abh
	ld a,e
	add a,010h
	ld e,a
	call sub_77abh
	jp 098b9h
sub_77abh:
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
l77bbh:
	nop
	inc b
	ex af,af'
	inc c
	djnz l77d5h
	jr z,l77efh
	jr $+30
	jr nc,l77fbh
	jr nz,l77edh
	jr c,l7807h
	ld h,b
	ld h,h
	ld l,b
	ld l,h
	ld b,b
	ld b,h
	ld c,b
	ld c,h
	ld d,b
	ld d,h
l77d5h:
	ld e,b
	ld e,h
sub_77d7h:
	call page_banks_14_15
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
l77edh:
	add hl,hl
	add hl,de
l77efh:
	ld de,0a792h
	add hl,de
	push hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld de,0e887h
l77fbh:
	ld bc,00020h
	ldir
	pop hl
	inc hl
	inc hl
	push hl
	ld a,(hl)
	inc hl
	ld h,(hl)
l7807h:
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
sub_781ch:
	call page_banks_14_15
	call sub_7825h
	jp page_banks_123
sub_7825h:
	ld a,(0e880h)
	or a
	ret z
	call sub_7903h
	ld a,(0e880h)
	or a
	ret z
	ld a,(0e881h)
	call DISPATCH_A

; BLOCK 'd_7835_jp' (start 0x7838 end 0x783e)
d_7835_jp_start:
	defw 0783eh
	defw 07863h
	defw 07885h
d_7835_jp_end:
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sub_7918h
	ld b,010h
l784ch:
	push bc
	push hl
	push de
	call sub_78adh
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz l784ch
	call sub_78eeh
l785eh:
	ld hl,0e881h
	inc (hl)
	ret
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sub_7918h
	ld b,010h
l7871h:
	push bc
	push hl
	push de
	call sub_78c8h
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz l7871h
	call sub_78eeh
	jr l785eh
	ld hl,0e882h
	dec (hl)
	ret nz
	ld a,(0e883h)
	ld (hl),a
	call sub_7918h
	inc hl
	inc de
	ld b,010h
l7895h:
	push bc
	push hl
	push de
	call sub_78dbh
	pop de
	pop hl
	pop bc
	inc hl
	inc hl
	inc de
	inc de
	djnz l7895h
	call sub_78eeh
	ld hl,0e881h
	ld (hl),000h
	ret
sub_78adh:
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
sub_78c8h:
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
sub_78dbh:
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
sub_78eeh:
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
sub_7903h:
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
sub_7918h:
	ld hl,(0e884h)
	ld de,0e887h
	ex de,hl
	ret
	ld a,(0e25ah)
	dec a
	call DISPATCH_A

; BLOCK 'd_7924_jp' (start 0x7927 end 0x7933)
d_7924_jp_start:
	defw 07933h
	defw 07977h
	defw 07996h
	defw 079a4h
	defw 07b08h
	defw 08667h
d_7924_jp_end:
	call 04e98h
	ld a,001h
	ld (0e241h),a
	call 05634h
	call 0565eh
	call sub_7a96h
	call sub_799ch
	ld a,001h
	ld (0e25bh),a
	ld hl,0e2c0h
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),000h
	ldir
	call 05d41h
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
	call 08b95h
	ld a,(0e25bh)
	and a
	ret nz
	call sub_799ch
	ld a,(0e27eh)
	and a
	ret z
	dec a
	jr nz,l7990h
	call sub_799ch
	jp l7a5ch
l7990h:
	ld a,001h
	ld (0e25ah),a
	ret
	call 04e98h
	call sub_7ae1h
sub_799ch:
	ld hl,0e25ah
	inc (hl)
	inc hl
	ld (hl),000h
	ret
	call sub_79aah
	jp l7a69h
sub_79aah:
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
	call sub_7adbh
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
	call sub_7ab5h
	pop hl
	ret z
l79ebh:
	ld a,(hl)
	cp 006h
	ret nc
	inc (hl)
	ld b,001h
l79f2h:
	call sub_7a23h
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
	call 04fedh
	pop hl
	ld bc,0170bh
	jp 04f8ah
sub_7a23h:
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
	jp 042cbh
l7a39h:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp 042cbh
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
	call 07cffh
l7a5ch:
	xor a
	ld hl,0e260h
	ld (hl),a
	inc hl
	ld (hl),a
	call sub_7b33h
	jp sub_799ch
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
sub_7a96h:
	call 05696h
	xor a
	ld (0e285h),a
	ld (0e298h),a
	ld (0e287h),a
	call 05859h
sub_7aa6h:
	call page_bank_13
	ld de,0bbfch
	ld hl,0f880h
	call 04e54h
	jp page_banks_123
sub_7ab5h:
	call sub_7a23h
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
sub_7adbh:
	call sub_7a23h
	ld a,(hl)
	and a
	ret
sub_7ae1h:
	ld hl,02022h
	ld d,h
	ld e,l
	ld b,007h
l7ae8h:
	push bc
	ld bc,0900bh
	push hl
	push de
	call 04f8ah
	pop de
	ex de,hl
	ld bc,0c00bh
	push hl
	call 04f54h
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
	ld a,(0e25bh)
	call DISPATCH_A

; BLOCK 'd_7b0b_jp' (start 0x7b0e end 0x7b1a)
d_7b0b_jp_start:
	defw 07b1ah
	defw 07b45h
	defw 07c3ah
	defw 07c82h
	defw 07e5bh
	defw 07e49h
d_7b0b_jp_end:
	call 04e98h
	call 05d41h
	call 0867dh
	call sub_7d43h
	ld a,007h
	ld hl,0d220h
	call sub_7c04h
l7b2eh:
	ld hl,0e25bh
	inc (hl)
	ret
sub_7b33h:
	call page_bank_13
	ld hl,0bc44h
	ld de,0f038h
	ld bc,0020dh
	call copy_tiles
	jp page_banks_123
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
	call sub_7c27h
	ld a,007h
	ld hl,0d200h
	call sub_7c04h
	jr l7b9ah
l7b6ah:
	call sub_7bdah
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
	call sub_7c27h
	ld a,007h
	ld hl,0d200h
	call sub_7c04h
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
	call sub_7c0eh
	jp l7b2eh
l7ba4h:
	ld hl,0e25bh
	inc (hl)
	inc (hl)
	ret
l7baah:
	ld a,005h
	ld (0e25bh),a
	call 05d41h
	call 04e98h
	xor a
	call 0886ah
	call page_bank_13
	ld hl,0be77h
	call print_stream
	jp page_banks_123
l7bc5h:
	call 042cbh
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld (hl),00ah
	ret
l7bcfh:
	call 042cbh
	inc (hl)
	ld a,(hl)
	cp 00bh
	ret c
	ld (hl),000h
	ret
sub_7bdah:
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
	jr z,sub_7c04h
	xor a
sub_7c04h:
	ld d,h
	ld e,l
	inc de
	ld (hl),a
	ld bc,0000fh
	ldir
	ret
sub_7c0eh:
	call page_bank_13
	ld a,(0e260h)
	sub 004h
	ld hl,0bcbbh
	call 04d4ch
	ld a,(hl)
	ld (0e263h),a
	inc hl
	call print_stream
	jp page_banks_123
sub_7c27h:
	ld hl,0a010h
	ld bc,05078h
	ld a,0ffh
	ld d,000h
	call 04fedh
	ld a,0e0h
	ld (0e804h),a
	ret
	ld a,(0e20ch)
	rla
	jp c,l7cb3h
	call sub_7c77h
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
	call sub_7c04h
	jp l7b2eh
l7c5fh:
	call 042cbh
	dec (hl)
	ld a,(hl)
	rla
	ret nc
	ld a,(0e263h)
	ld (hl),a
	ret
l7c6bh:
	call 042cbh
	inc (hl)
	ld a,(0e263h)
	cp (hl)
	ret nc
	ld (hl),000h
	ret
sub_7c77h:
	ld b,088h
	ld a,(0e261h)
	ld hl,0e804h
	jp l7be2h
	ld a,(0e20ch)
	rla
	jp c,l7cb3h
	call sub_7d43h
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
	call sub_7c04h
	ld a,001h
	ld (0e25bh),a
	ret
l7cb3h:
	call 04e98h
	ld hl,0e264h
	ld (hl),00bh
	inc hl
	ld (hl),00fh
	call 05d41h
	call sub_7da0h
	ld a,004h
	ld (0e25bh),a
	ld a,(0e260h)
	ld b,a
	add a,a
	add a,b
	ld hl,l7ce4h
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
l7ce4h:
	jr l7d06h
	nop
	jr l7d09h
	nop
	jr l7d0ah
	ld bc,01e16h
	ld de,01e16h
	ld de,01e16h
	ld de,01e16h
	ld de,01e16h
	ld de,01c14h
	ld de,08821h
	rst 20h
	ld c,000h
l7d04h:
	ld a,(hl)
	dec a
l7d06h:
	jr z,l7d0ch
	inc hl
l7d09h:
	inc c
l7d0ah:
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
	jp 042cbh
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
sub_7d43h:
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
	jp sub_7c04h
l7d6dh:
	ld hl,0e26ah
	ld a,(hl)
	inc hl
	and (hl)
	ret z
	call sub_7d86h
	call 04e98h
	call 05d41h
	call sub_799ch
	ld a,001h
	ld (0e25bh),a
	ret
sub_7d86h:
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
sub_7da0h:
	call sub_7e35h
	ld a,(0e26ch)
	and a
	call nz,083e3h
	call sub_7f39h
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
	call sub_653dh
l7dc4h:
	ld bc,00008h
	add ix,bc
	pop bc
	djnz l7db4h
	call sub_7f39h
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
	call sub_7f39h
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
	call 08537h
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
	call sub_7f39h
	cp b
	call z,08046h
	ret
sub_7e35h:
	call sub_7f39h
	dec a
	ld h,000h
	ld l,a
	call 05d32h
	push hl
	pop ix
	xor a
	ld (0efc0h),a
	jp 04553h
	call 08a38h
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

; BLOCK 'd_7e6c_jp' (start 0x7e6f end 0x7e81)
d_7e6c_jp_start:
	defw 07e81h
	defw 07f44h
	defw 07f4ah
	defw 08018h
	defw 080a7h
	defw 081b7h
	defw 08477h
	defw 0853fh
	defw 085d4h
d_7e6c_jp_end:
	ld hl,00502h
l7e84h:
	ld (0efd0h),hl
	call 0871bh
	call sub_7ff0h
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
	call sub_7f39h
	ld h,a
	call sub_7f2ah
	ex de,hl
	push hl
	ld a,d
	exx
	call 09571h
	pop hl
	call 098e6h
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
	call sub_63edh
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
	call sub_7f10h
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
	call sub_7ef4h
	pop hl
l7ef0h:
	dec c
	ret nz
	ld h,000h
sub_7ef4h:
	push bc
	push de
	ld bc,00101h
	ld a,(0efd0h)
	push hl
	push de
	call sub_63edh
	call sub_7f39h
	pop bc
	pop de
	cp b
	ld a,(0efd1h)
	call z,0576ah
	pop de
	pop bc
	ret
sub_7f10h:
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
sub_7f2ah:
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
sub_7f39h:
	ld de,0e788h
	ld a,(0e262h)
	call ADD_DE_A
	ld a,(de)
	ret
	ld hl,05e03h
	jp l7e84h
	call 0871bh
	call sub_7ff5h
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
	call sub_7f39h
	ld h,a
	exx
	call 09571h
	ld (0e250h),de
	exx
	call sub_7f2ah
	ex de,hl
	ld a,b
	and a
	jr nz,l7f8fh
	push hl
	exx
	pop hl
	ld de,(0e250h)
	push hl
	call 098e6h
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
	call sub_63edh
	pop de
	call sub_7fb5h
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
sub_7fb5h:
	push de
	call sub_7fe1h
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
	call sub_63edh
	call sub_7f39h
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
sub_7fe1h:
	ld c,001h
	ld a,e
	and a
	jp z,l7f1eh
	inc c
	cp 0b8h
	jp z,l7f1eh
	xor a
	ret
sub_7ff0h:
	ld bc,02000h
	jr l7ff8h
sub_7ff5h:
	ld bc,02808h
l7ff8h:
	ld a,(0e26ah)
	and a
	jr z,l8016h
	ld hl,0e2f3h                 ; was split: 021h,0f3h | bank2 0e2h

; ---------------------------------------------------------------------------
;  bank 2 continues at 0x8001 (ld hl high byte was 0x8000)
; ---------------------------------------------------------------------------
	call 07f39h
	cp (hl)
	jr nz,l8016h
	dec hl
	call 07f2ah
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
	call sub_871bh
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	ld hl,0e282h
	jr z,l8039h
	call 07f39h
	ld (0e243h),a
	call 07f2ah
	ld (hl),e
	inc hl
	inc hl
	ld (hl),d
	ld a,001h
	jr l8043h
l8039h:
	ld a,(0e243h)
	ld b,a
	call 07f39h
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
	call 07c04h
	ld a,04eh
	ld hl,0d230h
	call 07c04h
	ld a,00dh
	ld hl,0d240h
	call 07c04h
	ld a,04eh
	ld hl,0d250h
	jp 07c04h
	call sub_871bh
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
	call sub_80e8h
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
	call 07f39h
	ld (hl),a
	inc hl
	call 07f2ah
	ld (hl),e
	inc hl
	ld (hl),d
	jr l811fh
sub_80e8h:
	ld hl,0e2c0h
	ld b,008h
l80edh:
	ld a,(hl)
	and a
	jr z,l80f7h
	push hl
	call sub_819eh
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
	call sub_819eh
	pop hl
	push hl
	call z,sub_81b0h
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
	call 07f39h
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
	call 07c04h
	pop bc
	ld a,c
	exx
	pop hl
	ld bc,00010h
	add hl,bc
	call 07c04h
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
sub_819eh:
	call 07f39h
	inc hl
	inc hl
	cp (hl)
	ret nz
	call 07f2ah
	inc hl
	ld a,(hl)
	cp e
	ret nz
	inc hl
	ld a,(hl)
	cp d
	ret
sub_81b0h:
	ld (hl),000h
	ld hl,0e266h
	dec (hl)
	ret
	call sub_8708h
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
	jr z,l81e9h
	ld a,010h
	call ADD_HL_A
	jr l81deh
l81e9h:
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
	call 07f2ah
	ld (ix+002h),e
	ld (ix+003h),d
	call 07f39h
	ld (ix+004h),a
	ld (ix+009h),a
	call sub_830ch
	call 07f39h
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
	call nz,sub_823dh
l8234h:
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l8226h
	ret
sub_823dh:
	dec a
	call DISPATCH_A

; BLOCK 'd823e_jp' (start 0x8241 end 0x824b)
d823e_jp_start:
	defw 08266h                   ; type 1 Slouman / Flouman (coffin)
	defw 0827fh                   ; type 2 Pyoncy
	defw 0829ch                   ; type 3 Rock Roll
	defw 0bdc0h                   ; type 4 trap (1×4 tile column)
	defw 09652h                   ; type 5 stone (2×2, pushable)
d823e_jp_end:
	ld ix,0e600h
	ld b,010h
l8251h:
	ld a,(ix+000h)
	and a
	jr z,l825bh
	call sub_82f8h
	ret z
l825bh:
	ld de,00010h
	add ix,de
	djnz l8251h
	ld a,001h
	and a
	ret
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
	call sub_82f8h
	call z,sub_82d8h
	pop hl
l82d0h:
	ld de,00010h
	add ix,de
	djnz l82c2h
	ret
sub_82d8h:
	ld a,(ix+000h)
	ld (ix+000h),000h
	dec (hl)
	ld hl,082f2h
	call ADD_HL_A
	ld c,(hl)
	ld b,(ix+008h)
	call 07f2ah
	ld hl,l86c5h
	jp 05737h
	ld (bc),a
	ld (bc),a
	ld bc,00204h
sub_82f8h:
	call 07f39h
	cp (ix+004h)
	ret nz
	call 07f2ah
	ld a,(ix+002h)
	cp e
	ret nz
	ld a,(ix+003h)
	cp d
	ret
sub_830ch:
	ld a,(0e261h)
	call DISPATCH_A

; BLOCK 'd830f_jp' (start 0x8312 end 0x8320)
d830f_jp_start:
	defw 08320h                   ; E261 0 Slouman  ix+8=0 (height)
	defw 0834dh                   ; E261 1 Flouman  ix+8=1 (editor only)
	defw 08320h                   ; E261 2 Pyoncy   same init as Slouman
	defw 08351h                   ; E261 3 Rock Roll ix+8=2
	defw 08346h                   ; E261 4
	defw 0833ch                   ; E261 5
	defw 08341h                   ; E261 6
d830f_jp_end:
	ld c,000h
	xor a
	ld b,003h
l8325h:
	ld (ix+005h),c
	ld (ix+007h),a
	call sub_8359h
	ld (ix+008h),c
	dec c
	ret nz
	ld (ix+000h),000h
	ld hl,0e267h
	dec (hl)
	ret
	ld (ix+008h),001h
	ret
	ld (ix+008h),002h
	ret
	xor a
	ld c,a
	ld b,01eh
	jp l8325h
	ld c,003h
	jr l8353h
	ld c,000h
l8353h:
	ld a,002h
	ld b,003h
	jr l8325h
sub_8359h:
	ld c,001h
	call 07f2ah
l835eh:
	ld a,e
	add a,008h
	ld e,a
	cp 0b8h
	ret nc
	push bc
	push de
	call sub_8371h
	pop de
	pop bc
	ret nc
	inc c
	djnz l835eh
	ret
sub_8371h:
	push de
	call 07f39h
	dec a
	ld l,a
	ld h,000h
	call 05d32h
	pop de
	push hl
	ex de,hl
	call 04d7bh
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
	call sub_841ah
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
	call 07f39h
	ld (hl),a
	inc hl
	call 07f2ah
	ld (hl),e
	inc hl
	ld (hl),d
	ld b,01eh
	push hl
	call sub_8359h
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
	call 07f39h
	cp (ix+000h)
	call z,sub_83feh
	ld bc,00004h
	add ix,bc
	pop bc
	djnz l83ebh
	ret
sub_83feh:
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
sub_841ah:
	ld ix,0e7c0h
	ld b,010h
l8420h:
	ld a,(ix+000h)
	and a
	jr z,l842ah
	call sub_8456h
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
	call sub_8456h
	call z,sub_846ah
l844dh:
	ld bc,00004h
	add ix,bc
	pop bc
	djnz l8440h
	ret
sub_8456h:
	call 07f39h
	cp (ix+000h)
	ret nz
	call 07f2ah
	ld a,(ix+001h)
	cp e
	ret nz
	ld a,(ix+002h)
	cp d
	ret
sub_846ah:
	ld hl,0e26ch
	dec (hl)
	ld (ix+000h),000h
	ld c,000h
	jp sub_83feh
	call sub_871bh
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
	call sub_8501h
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
	call 07f2ah
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	call 07f39h
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
	call sub_851bh
	pop hl
	push hl
	call z,sub_852eh
	pop hl
l84d4h:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz l84c5h
	ret
l84ddh:
	call 07f2ah
	ld a,(0e261h)
	call sub_8537h
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
	call 07f39h
	ld d,a
	xor a
	jp 063edh
sub_8501h:
	ld hl,0e300h
	ld b,040h
l8506h:
	ld a,(hl)
	and a
	jr z,l8510h
	push hl
	call sub_851bh
	pop hl
	ret z
l8510h:
	ld a,008h
	call ADD_HL_A
	djnz l8506h
	ld a,001h
	and a
	ret
sub_851bh:
	call 07f39h
	inc hl
	inc hl
	inc hl
	cp (hl)
	ret nz
	call 07f2ah
	dec hl
	ld a,(hl)
	cp d
	ret nz
	dec hl
	ld a,(hl)
	cp e
	ret
sub_852eh:
	ld (hl),000h
	ld hl,0e268h
	dec (hl)
	jp l84ddh
sub_8537h:
	ld hl,l9328h
	add a,a
	add a,a
	jp ADD_HL_A
	call sub_871bh
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
	call 07f39h
	ld (hl),a
	inc hl
	call 07f2ah
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
	call sub_859ch
	pop hl
	push hl
	call z,sub_85adh
	pop hl
l8593h:
	ld a,008h
	call ADD_HL_A
	pop bc
	djnz l8584h
	ret
sub_859ch:
	call 07f39h
	inc hl
	cp (hl)
	ret nz
	call 07f2ah
	inc hl
	ld a,(hl)
	cp e
	ret nz
	inc hl
	ld a,(hl)
	cp d
	ret
sub_85adh:
	ld (hl),000h
	ld hl,0e269h
	dec (hl)
l85b3h:
	call 07f2ah
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
	call 07f39h
	ld d,a
	xor a
	jp 063edh
	call sub_871bh
	ld a,(0e207h)
	and 030h
	ret z
	and 010h
	jr z,l8616h
	ld a,(0e26ah)
	and a
	call nz,sub_8621h
	call sub_8633h
	ld hl,0e2f1h
	call 07f2ah
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	call 07f39h
	ld (hl),a
	ld a,001h
	ld (0e26ah),a
	call 07f2ah
	ld hl,l9340h
l8604h:
	ld bc,00404h
	push de
	push bc
	call 05737h
	pop bc
	pop hl
	call 07f39h
	ld d,a
	xor a
	jp 063edh
l8616h:
	call sub_8621h
	call sub_8633h
	xor a
	ld (0e26ah),a
	ret
sub_8621h:
	ld hl,0e2f3h
	call 07f39h
	cp (hl)
	ret nz
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)
	ld hl,l86c5h
	jp l8604h
sub_8633h:
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
	jp 07c04h
	ld a,(0e20ch)
	rla
	rla
	jr c,l8676h
	call sub_88abh
	ld a,(0e25bh)
	and a
	ret nz
l8676h:
	ld hl,00005h
	ld (0e25ah),hl
	ret
	ld a,001h
	call sub_886ah
	call page_bank_13
	ld hl,0bc54h
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
sub_8708h:
	exx
	ld a,(0e261h)
	ld bc,00201h
	cp 004h
	jr c,l871fh
	ld c,002h
	cp 006h
	jr z,l871fh
	jr l871ch
sub_871bh:
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
	call 042cbh
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
	call 042cbh
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
	call 042cbh
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
	call 042cbh
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
sub_878bh:
	ld hl,0e7c0h
	ld b,010h
l8790h:
	push bc
	ld a,(hl)
	and a
	push hl
	call nz,sub_87a1h
	pop hl
	pop bc
	ld a,004h
	call ADD_HL_A
	djnz l8790h
	ret
sub_87a1h:
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
	call sub_87fah
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
	call sub_87ebh
	ld a,(0efc1h)
	ld hl,0eda0h
	ld de,0edb0h
sub_87ebh:
	add a,a
	ld b,a
	call ADD_HL_A
	ld (hl),0ffh
	ld a,b
	call ADD_DE_A
	ld a,0ffh
	ld (de),a
	ret
sub_87fah:
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
	call sub_882ah
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
	call sub_884dh
	ld hl,0efc1h
	inc (hl)
	ret
sub_882ah:
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
sub_884dh:
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
sub_886ah:
	push af
	call 04ebeh
	pop af
	call page_bank_13
	ld hl,0bb38h
	call 04d4ch
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
	call c,05767h
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
	call 04eb1h
	ret
sub_88abh:
	ld a,(0e25bh)
	dec a
	call DISPATCH_A

; BLOCK 'd88af_jp' (start 0x88b2 end 0x88be)
d88af_jp_start:
	defw 088beh
	defw 08917h
	defw 089e9h
	defw 08a54h
	defw 08b43h
	defw 08b88h
d88af_jp_end:
	call sub_8908h
	call 05bebh
	xor a
	call sub_886ah
	call page_bank_13
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
	call 051dah
	pop de
	ld a,e
	add a,010h
	ld e,a
l88e9h:
	pop af
	rra
	ld hl,0be3ah
	ld c,0ffh
	call c,051dah
	call page_banks_123
	xor a
	ld (0e26dh),a
	ld (0e26eh),a
	ld (0e27fh),a
	ld (0e21eh),a
sub_8903h:
	ld hl,0e25bh
	inc (hl)
	ret
sub_8908h:
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
	call sub_897ah
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
	call 05d41h
	call sub_8903h
	call sub_89cdh
	call 04e98h
	xor a
	call sub_886ah
	call page_bank_13
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
	call 051dah
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
	jp 042cbh
l8973h:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp 042cbh
sub_897ah:
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
l898eh:
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
	call sub_886ah
	call page_bank_13
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
	jp sub_8903h
sub_89cdh:
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
	call sub_8a38h
	and a
	ret z
	dec a
	jp nz,l8b50h
	ld a,0e0h
	ld a,(0edeeh)
	call 04e98h
	ld a,(0f0f8h)
	cp 002h
	jr z,l89a3h
	xor a
	call sub_886ah
	call sub_8903h
	call page_bank_13
	ld hl,0bde9h
	call print_stream
	call page_banks_123
sub_8a14h:
	ld de,06058h
	ld hl,0e270h
sub_8a1ah:
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
sub_8a38h:
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
	ld a,(0f0f8h)
	cp 002h
	jp z,l8ad1h
l8a5ch:
	call sub_8abbh
	call 06c2eh
	call 06b8eh
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
	call 042cbh
	pop af
	inc (hl)
l8a83h:
	ld hl,0e270h
	call ADD_HL_A
	ld (hl),b
	call sub_8a14h
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
	call 05d41h
	call 041e0h
	jp sub_8903h
l8aa6h:
	ld hl,0e26eh
	ld a,(hl)
	cp 007h
	ret nc
	inc (hl)
	jp 042cbh
l8ab1h:
	ld hl,0e26eh
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp 042cbh
sub_8abbh:
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
	jp l898eh
l8ad1h:
	call 08b07h
	ret nc
l8ad5h:
	ld a,(0e26eh)
	add a,a
	add a,a
	add a,a
	ld hl,l8aefh
	call ADD_HL_A
	ld de,0e270h
	ld bc,00008h
	ldir
	call 041e0h
	jp sub_8903h
l8aefh:
	ld b,(hl)
	ld c,c
	ld c,h
	ld b,l
	ld sp,02020h
	jr nz,$+72
	ld c,c
	ld c,h
	ld b,l
	ld (02020h),a
	jr nz,l8b46h
	ld c,c
	ld c,h
	ld b,l
	inc sp
	jr nz,$+34
	jr nz,l8ad5h
	inc l
	adc a,e
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
	jp l898eh
	call sub_8b72h
l8b46h:
	call 04230h
	ld a,(0e27fh)
	cp 002h
	jr z,l8b57h
l8b50h:
	xor a
	ld (0e25bh),a
	jp 04e98h
l8b57h:
	ld a,(0f0f8h)
	dec a
	jr z,l8b6fh
	call 05d41h
	call 04e98h
	call page_bank_13
	ld hl,0be6ah
	call print_stream
	call page_banks_123
l8b6fh:
	jp sub_8903h
sub_8b72h:
	ld a,(0f0f8h)
	or a
	jr z,l8b7fh
	dec a
	jp z,l9c20h
	jp 06c3dh
l8b7fh:
	call page_bank_12
	call 0bf2bh
	jp page_banks_123
	ld a,(0e207h)
	and a
	ret z
	ld a,001h
	ld (0e25bh),a
	jp 04e98h
	ld a,(0e25bh)
	dec a
	call DISPATCH_A

; BLOCK 'd_8b99_jp' (start 0x8b9c end 0x8bac)
d_8b99_jp_start:
	defw 08bach
	defw 08bcah
	defw 08c52h
	defw 08c95h
	defw 08d87h
	defw 08e88h
	defw 08eb9h
	defw 08df8h
d_8b99_jp_end:
	call 04e98h
	xor a
	call sub_886ah
	call page_bank_13
	ld hl,0bd6dh
	call print_stream
	call page_banks_123
	call sub_8f0ch
	call 07969h
l8bc5h:
	ld hl,0e25bh
	inc (hl)
	ret
	call sub_8c33h
	ld hl,0e26dh
	ld a,(0e207h)
	ld b,a
	and 003h
	jr z,l8bdfh
	ld a,(hl)
	xor 001h
	ld (hl),a
	jp 042cbh
l8bdfh:
	ld a,b
	and 010h
	ret z
	ld a,(hl)
	and a
	jr nz,l8c2eh
l8be7h:
	call 04e98h
	xor a
	call sub_886ah
	call page_bank_13
	ld hl,0bdb9h
	call print_stream
	call page_banks_123
	ld a,(0f0f9h)
	rra
	ld de,06060h
	push af
	jr nc,l8c18h
	call page_bank_13
	ld hl,0bdd5h
	ld c,0ffh
	push de
	call 051dah
	pop de
	ld a,e
	add a,010h
	ld e,a
	call page_banks_123
l8c18h:
	pop af
	rra
	call page_bank_13
	ld hl,0bddfh
	ld c,0ffh
	call c,051dah
	call page_banks_123
	xor a
	ld (0e26dh),a
	jr l8bc5h
l8c2eh:
	xor a
	ld (0e25bh),a
	ret
sub_8c33h:
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
	call l898eh
	ret
l8c4ch:
	ld a,001h
	ld (0e25bh),a
	ret
	ld a,(0e20ch)
	rla
	rla
	jr c,l8c4ch
	call sub_897ah
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
	call sub_89cdh
	call 05d41h
	call 04e98h
	call l8bc5h
	jp 041e0h
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
	jp 042cbh
l8c8eh:
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp 042cbh
	ld a,(0f0f8h)
	dec a
	jp z,l8d31h
	dec a
	jr z,l8cb5h
	xor a
	call sub_886ah
	call page_bank_13
	ld hl,0bde9h
	call print_stream
	call page_banks_123
	call 04230h
	jp l8bc5h
l8cb5h:
	call 06e2dh
	ld a,(0f0e5h)
	and a
	jr z,l8d1ah
	xor a
	call sub_886ah
	call page_bank_13
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
	call page_bank_13
	call sub_8cfah
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
	call l8bc5h
	jp 04230h
sub_8cfah:
	sub 031h
	and a
	jr z,l8d0ah
	dec a
	jr z,l8d12h
	ld hl,0be56h
	ld c,0ffh
	jp 051dah
l8d0ah:
	ld hl,0be46h
	ld c,0ffh
	jp 051dah
l8d12h:
	ld hl,0be4eh
	ld c,0ffh
	jp 051dah
l8d1ah:
	call 04e98h
	call page_bank_12
	ld hl,0af7dh
	call print_stream
	call page_banks_123
	ld a,007h
	ld (0e25bh),a
	jp 04230h
l8d31h:
	call sub_9cabh
	ld a,(0f0e5h)
	and a
	jr z,l8d1ah
	call l8bc5h
	call 04230h
sub_8d40h:
	call 04e98h
	ld a,001h
	call sub_886ah
	call page_bank_13
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
	call sub_8a1ah
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
	call sub_8a1ah
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
	call sub_8e39h
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
	call 04e98h
	call 05d41h
	call page_bank_13
	ld hl,0be06h
	call print_stream
	call page_banks_123
	call 041e0h
	jp l8bc5h
l8defh:
	call 041e0h
	ld a,008h
l8df4h:
	ld (0e25bh),a
	ret
	call sub_9cabh
	call sub_8d40h
	xor a
	ld (0e26eh),a
	call 04230h
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
	jp 042cbh
l8e1ah:
	ld a,(hl)
	inc a
	inc a
	cp b
	ret nc
	inc (hl)
	inc (hl)
	jp 042cbh
l8e24h:
	ld a,(hl)
	rra
	ret nc
	ld a,(hl)
	and a
	ret z
	dec (hl)
	jp 042cbh
l8e2eh:
	ld a,(hl)
	rra
	ret c
	ld a,(hl)
	inc a
	cp b
	ret nc
	inc (hl)
	jp 042cbh
sub_8e39h:
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
	call l898eh
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
	call 05d41h
	call 041e0h
	jp l8bc5h
	call sub_8ea3h
	ld a,001h
	ld (0e27eh),a
	call 04230h
	ld a,(0e27fh)
	cp 002h
	jp z,l8bc5h
	call 04e98h
	xor a
	ld (0e25bh),a
	ret
sub_8ea3h:
	ld a,(0f0f8h)
	or a
	jr z,l8eb0h
	dec a
	jp z,l9b98h
	jp 06c55h
l8eb0h:
	call page_bank_12
	call 0be7eh
	jp page_banks_123
	ld a,(0e207h)
	and a
	ret z
	ld a,002h
	ld (0e27eh),a
	call 04e98h
	xor a
	ld (0e25bh),a
	ret
	call 067ech
	call 05d41h
	xor a
	ld (0e24ah),a
	inc a
	ld (0e25bh),a
	ret
	ld a,(0e25bh)
	dec a
	call DISPATCH_A

; BLOCK 'd_8ede_jp' (start 0x8ee1 end 0x8ef1)
d_8ede_jp_start:
	defw 08ef1h
	defw 08c52h
	defw 08c95h
	defw 08d87h
	defw 08f37h
	defw 08f3dh
	defw 08f64h
	defw 08df8h
d_8ede_jp_end:
	ld a,001h
	ld (0e241h),a
	call 05634h
	ld a,(0f0f4h)
	and a
	call nz,0565eh
	call 07aa6h
	call sub_8f0ch
	call 07969h
	jp l8be7h
sub_8f0ch:
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
	jp 05d41h
	call sub_8f72h
	jp l8bc5h
	call sub_8ea3h
	ld a,(0e27fh)
	and a
	jp nz,l8bc5h
	call 05de6h
	call sub_92cah
	call sub_921ah
	call sub_878bh
	ld a,001h
	ld (0e24ah),a
	ld (0e254h),a
	ld a,(0e282h)
	or a
	ret nz
	ld (0e294h),a
	ret
	ld a,(0e207h)
	and a
	ret z
	call 04e98h
	ld a,002h
	ld (0e24ah),a
	ret
sub_8f72h:
	call 05696h
	call 0594fh
	call 058d2h
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
	call 05d41h
	ret
	call page_bank_13
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
	jp 07d86h
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
	call sub_907fh
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
	call 0428ah
	call 05687h
	xor a
	ld (0e21bh),a
	call 0723dh
	ld bc,00007h
	jp 00047h
sub_9010h:
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
	call 05767h
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
	call page_bank_13
	ld a,e
	ld hl,0b9adh                  ; exit-door metatile by shape
	call 04d4ch
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
	call 05767h
	pop hl
	inc hl
	djnz l9057h
	call page_banks_123
	ret
sub_907fh:
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
	call 05d41h
	jp 04ecbh
sub_909fh:
	push ix
	call sub_90abh
	pop ix
	call sub_924ah
	jr l90f7h
sub_90abh:
	ld hl,0ee50h
	ld b,040h
l90b0h:
	ld a,(hl)
	or a
	ret z
	call sub_927dh
	ld a,(ix+000h)
	or a
	jr z,l90d6h
	and 0f0h
	jr z,l90c7h
	cp 0f0h
	jr nz,l90d6h
	call sub_90dah
l90c7h:
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,l90d6h
	push hl
	push bc
	call sub_90e3h
	pop bc
	pop hl
l90d6h:
	inc hl
	djnz l90b0h
	ret
sub_90dah:
	ld a,(ix+000h)
	and 01fh
	ld (ix+000h),a
	ret
sub_90e3h:
	ld l,(ix+004h)
	ld h,(ix+005h)
	ld e,(ix+001h)
	ld d,(ix+002h)
	ld bc,01010h
	ld a,001h
	jp 05029h
l90f7h:
	ld hl,0ee8fh
	ld b,040h
l90fch:
	ld a,(hl)
	or a
	jr z,l9112h
	call sub_927dh
	ld a,(0e243h)
	cp (ix+003h)
	jr nz,l9112h
	push bc
	push hl
	call sub_9116h
	pop hl
	pop bc
l9112h:
	dec hl
	djnz l90fch
	ret
sub_9116h:
	ld a,(ix+000h)
	or a
	ret z
	and 0f0h
	ret nz
	call sub_913ah
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
sub_913ah:
	call sub_9151h
	ld (ix+004h),e
	ld (ix+005h),d
	ld l,(ix+001h)
	ld h,(ix+002h)
	ld bc,01010h
	ld a,004h
	jp 05029h
sub_9151h:
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
	call sub_9196h
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
	call nc,sub_91a4h
l918dh:
	pop hl
	ld bc,00008h
	add hl,bc
	pop bc
	djnz l9178h
	ret
sub_9196h:
	ld b,00ch
	ld hl,0e810h
l919bh:
	ld (hl),0e0h
	ld de,00004h
	add hl,de
	djnz l919bh
	ret
sub_91a4h:
	push de
	call sub_91b2h
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
sub_91b2h:
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
	ld hl,l9296h
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
	ld hl,l9292h
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
sub_921ah:
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
	call sub_925eh
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
sub_924ah:
	call sub_925eh
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
sub_925eh:
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
sub_927dh:
	push hl
	call sub_9283h
	pop hl
	ret
sub_9283h:
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
l9292h:
	dec bc
	ld b,a
	rlca
	ld c,d
l9296h:
	djnz l92b0h
	jr nz,l92c2h
	jr nc,$+58
	ld b,b
	ld hl,0e280h
	ld de,0e281h
	ld (hl),000h
	ld bc,00040h
	ldir
	call page_bank_13
	ld a,(0e242h)
l92b0h:
	ld b,a
	add a,a
	add a,b
	ld hl,0b844h                  ; Vic spawn X/Y/screen; e242*3
	call ADD_HL_A
	ld a,(hl)
	ld (0e282h),a
	inc hl
	ld a,(hl)
	ld (0e284h),a
l92c2h:
	inc hl
	ld a,(hl)
	ld (0e243h),a
	call page_banks_123
sub_92cah:
	ld hl,l92f7h
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
l92f7h:
	nop
	cp 000h
	ld (bc),a
	nop
	cp 000h
	ld (bc),a
sub_92ffh:
	xor a
	ld (0e295h),a
	ld (0e285h),a
	ld a,(0e280h)
	cp 004h
	jr nz,l9312h
	ld a,004h
	ld (0e285h),a
l9312h:
	ld a,001h
	ld (0e298h),a
	ld hl,0e215h
	ld (hl),000h
	ld a,003h
	ld (0e296h),a
	jp 05928h
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
	ld a,(0e2f9h)
	cp 003h
	ret c
	ld ix,0e600h
	ld b,010h
l93cah:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,sub_93dch
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l93cah
	ret
sub_93dch:
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
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd93f6_jp' (start 0x93f9 end 0x93ff)
d93f6_jp_start:
	defw 093ffh
	defw 09469h
	defw 094ffh
d93f6_jp_end:
	call sub_9549h
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
	bit 1,(ix+007h)
	ld bc,00002h
	jr nz,l9475h
	ld bc,0f003h
l9475h:
	ld a,(ix+003h)
	cp b
	jr z,l94b3h
	call sub_9543h
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
	call 0428fh
	ld l,(ix+002h)
	ld (ix+00ah),l
	call sub_9549h
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
	call sub_95dah
	call sub_9601h
	pop bc
	call sub_94dah
	jp l94adh
sub_94dah:
	push bc
	call sub_969ah
	call sub_94ebh
	pop bc
	ld b,a
	ld a,c
	call 05e38h
	ld (ix+004h),l
	ret
sub_94ebh:
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
	call sub_9549h
	ret c
	call 04294h
	jp l94adh
l952eh:
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld (ix+002h),000h
	call sub_95dah
	call sub_9601h
	ld c,002h
	jp sub_94dah
sub_9543h:
	call sub_9564h
	jp l9933h
sub_9549h:
	call sub_9564h
	ld bc,00410h
	add hl,bc
	push hl
	push de
	call sub_98e6h
	pop de
	pop hl
	cp 001h
	ret nc
	ld a,h
	add a,008h
	ld h,a
	call sub_98e6h
	cp 001h
	ret
sub_9564h:
	ld a,(ix+004h)
	call sub_9571h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ret
sub_9571h:
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
sub_9585h:
	call sub_95dah
	push de
	call sub_9601h
	pop hl
	call sub_95aah
	ld a,003h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld d,(ix+004h)
	ld bc,00202h
	jp 063edh
l95a1h:
	ld h,(ix+003h)
	ld l,(ix+002h)
	call sub_95dah
sub_95aah:
	ld a,(ix+004h)
	ld (ix+009h),a
	ld bc,(0e2feh)
	ld de,(0e2fch)
	push hl
	call sub_95c1h
	pop hl
	ld a,l
	add a,008h
	ld l,a
sub_95c1h:
	push hl
	push de
	push bc
	call sub_98e6h
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
	call sub_98e6h
	pop bc
	pop de
	ld (bc),a
	inc bc
	ret
sub_95dah:
	exx
	ld a,(ix+004h)
	call sub_9571h
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
	call sub_95dah
sub_9601h:
	ld a,(ix+004h)
	cp (ix+009h)
	ret nz
	ld de,(0e2feh)
	push hl
	call sub_9615h
	pop hl
	ld a,l
	add a,008h
	ld l,a
sub_9615h:
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
	call sub_969ah
	ld h,(ix+00bh)
	ld l,(ix+00ah)
	ld d,(ix+003h)
	ld e,(ix+002h)
	call sub_9585h
	ld a,(0e243h)
	cp (ix+009h)
	ret nz
	call sub_9666h
l9652h:                           ; type 5 stone: 2×2 tiles at l9370h
	ld hl,l9370h
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld bc,00202h
	jp draw_tilemap
	call sub_9666h
	jr l9652h
sub_9666h:
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld (ix+00bh),h
	ld (ix+00ah),l
	ld a,(0f0f4h)
	and a
	jr nz,l9686h
	call 04d7bh
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
	jp 05029h
sub_969ah:
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
	jp 05029h
sub_96cfh:
	ld ix,0e600h
	ld b,010h
l96d5h:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,sub_96e7h
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l96d5h
	ret
sub_96e7h:
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	call sub_95dah
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop hl
	call sub_9666h
	jp l9652h
sub_96ffh:
	ld ix,0e600h
	ld b,010h
l9705h:
	push bc
	ld a,(ix+000h)
	cp 005h
	call z,sub_9717h
	ld bc,00010h
	add ix,bc
	pop bc
	djnz l9705h
	ret
sub_9717h:
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	call sub_95dah
	ld h,(ix+003h)
	ld l,(ix+002h)
	push hl
	pop de
	jp l96a0h
l972ch:
	ld l,097h
	push bc
	call sub_9de7h
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
	jp l9763h
	ld c,006h
l975eh:
	push bc
	call sub_9de7h
	pop bc
l9763h:
	ld b,000h
	ld a,c
	add a,a
	ld c,a
	call page_bank_12
	ld hl,0af52h
	add hl,bc
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	push hl
	call 04e98h
	pop hl
	call print_stream
	ld hl,0af60h
	call print_stream
	call page_banks_123
	call sub_9e1dh
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ld a,002h
	ld (0e27fh),a
	ld sp,(0f0e2h)
	ret
l9797h:
	sbc a,c
	sub a
	call sub_9de7h
	ld a,(0f0e9h)
	ld h,040h
	call 00024h
	call sub_9e1dh
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ld sp,(0f0e2h)
	ret
	call page_bank_13
	call load_map_tools
	jp page_banks_123
load_map_tools:                   ; 0x97BB  afb1_tbl[level-1] -> 0xE300 (64 x 8)
	ld ix,0e300h
	ld hl,0afb1h
	ld a,(0e242h)
	dec a
	call 04d4ch
l97c9h:
	call sub_97d4h
	ret z
	ld de,00008h
	add ix,de
	jr l97c9h
sub_97d4h:                        ; one afb1 rec: type=lo4 -> ix+0, screen=hi4 -> ix+3, Y, X
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
	ld a,(0e2b0h)
	call DISPATCH_A

; BLOCK 'd9804_jp' (start 0x9807 end 0x980f)
d9804_jp_start:
	defw 0980fh
	defw 0981ch
	defw 09831h
	defw 09846h
d9804_jp_end:
	ld hl,0e2b0h
	ld (hl),001h
	inc hl
	ld (hl),020h
	inc hl
	inc hl
	ld (hl),000h
	ret
	ld hl,0e2b1h
	dec (hl)
	ret nz
	ld hl,l982dh
	ld de,0e2b0h
	ld bc,00004h
	ldir
	ret
l982dh:
	ld (bc),a
	jr nc,l9860h
	ld bc,0030eh
	call sub_984bh
	ld a,(0e2b2h)
	cp 010h
	ret nz
	ld a,003h
	ld (0e2b3h),a
	ld hl,0e2b0h
	inc (hl)
	ret
	ld c,007h
	jp sub_984bh
sub_984bh:
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
	ld a,(0e280h)
	cp 00eh
	jr nz,l9881h
	ld a,(0e2a8h)
	rra
	jr c,l9881h
	ld hl,0e800h
	ld de,0e801h
	ld (hl),0e0h
	ld bc,0000fh
	ldir
	ret
l9881h:
	ld b,000h
	ld hl,0e800h
	ld a,(0e282h)
	sub 009h
	ld d,a
	ld a,(0e284h)
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
	call sub_98d2h
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),00dh
	ldir
sub_98d2h:
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),04eh
	ldir
	ret
	push hl
	call sub_98e2h
	pop hl
	ret
sub_98e2h:
	ld de,(0e250h)
sub_98e6h:
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
sub_9910h:
	push bc
	call sub_995ah
	push hl
	call sub_98e2h
	pop hl
	pop bc
	sub 002h
	ret nc
	push bc
	call sub_998eh
	push hl
	call sub_98e2h
	pop hl
	pop bc
	sub 002h
	ret nc
	call sub_998eh
	call sub_98e2h
	sub 002h
	ret
l9933h:
	push bc
	call sub_995ah
	push hl
	push de
	call sub_98e6h
	pop de
	pop hl
	pop bc
	sub 002h
	ret nc
	push bc
	call sub_998eh
	push hl
	push de
	call sub_98e6h
	pop de
	pop hl
	pop bc
	sub 002h
	ret nc
	call sub_998eh
	call sub_98e6h
	sub 002h
	ret
sub_995ah:
	ld a,c
	dec a
	jr z,l9970h
	dec a
	jr z,l997eh
	dec a
	jr z,l9986h
	ld a,h
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
sub_998eh:
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
	call sub_9a0bh
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
	call sub_96ffh
	call sub_90abh
	pop hl
	ld d,(hl)
	dec l
	ld e,(hl)
	dec l
	dec l
	ld (hl),000h
	ld bc,00202h
	call 056deh
	ld hl,0e2f5h
	dec (hl)
	jr nz,l99f8h
	call 04212h
	xor a
	ld (0e216h),a
	dec a
	ld (0e215h),a
	ld a,010h
	ld (0e21bh),a
l99f8h:
	call 0425dh
	call sub_9010h
	call l90f7h
	call sub_96cfh
	ld de,00500h
	call 04c20h
	ret
sub_9a0bh:
	ld a,(0e282h)
	ld e,a
	ld a,(0e284h)
	ld d,a
	ret
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
	call sub_927dh
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
	call sub_9a46h
	pop bc
	pop hl
	jr c,l9a93h
l9a42h:
	inc hl
	djnz l9a21h
	ret
sub_9a46h:
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
	defw 09a72h
	defw 09a7fh
	defw 09a8ah
	defw 09a72h
d9a67_jp_end:
	ld a,(0e284h)
	sub (ix+002h)
	jr nc,l9a7ch
	neg
l9a7ch:
	cp 00eh
	ret
	ld a,(0e284h)
	ld b,a
	ld a,(ix+002h)
	sub b
	cp 00eh
	ret
	ld a,(0e284h)
	sub (ix+002h)
	cp 00eh
	ret
l9a93h:                           ; pick up E300 tool: E287 = type, slot |= 0xF0
	push ix
	call sub_96ffh
	pop ix
	ld a,(ix+000h)
	and 00fh
	ld (0e287h),a
	or 0f0h
	ld (ix+000h),a
	call 04258h
	call sub_909fh
	call sub_96cfh
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
	call sub_92ffh
	jp 042a3h
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
	call sub_9b80h
	ld de,00100h
	call 04c20h
	call 04299h
	ret
sub_9b80h:
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
	jp 0ae6fh
l9b98h:
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	ld (0f0e2h),sp
	call sub_9db3h
	ld hl,0c270h
	ld de,0ce00h
	call sub_9d51h
	call sub_9ce3h
	call sub_9d26h
	call sub_9bcch
	call sub_9d05h
	di
	call sub_9de7h
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
sub_9bcch:
	ld de,0c243h
	ld c,01ah
	call 0f37dh
	ld hl,00001h
	call sub_9da3h
	ld de,0c25ch
	ld c,01ah
	call 0f37dh
	ld hl,00023h
	call sub_9da3h
	ld de,0c282h
	ld c,01ah
	call 0f37dh
	ld hl,00003h
	call sub_9da3h
	ld de,0c2c0h
	ld c,01ah
	call 0f37dh
	ld hl,00240h
	call sub_9da3h
	ld de,0c600h
	ld c,01ah
	call 0f37dh
	ld hl,00200h
	call sub_9da3h
	ld de,0c900h
	ld c,01ah
	call 0f37dh
	ld hl,004c0h
	jp sub_9da3h
l9c20h:
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	ld (0f0e2h),sp
	call sub_9db3h
	ld hl,0c270h
	ld de,0ce00h
	call sub_9d65h
	call sub_9e27h
	call sub_9cf3h
	call sub_9d26h
	call sub_9c57h
	call sub_9d05h
	di
	call sub_9de7h
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
sub_9c57h:
	ld de,0c243h
	ld c,01ah
	call 0f37dh
	ld hl,00001h
	call sub_9d93h
	ld de,0c25ch
	ld c,01ah
	call 0f37dh
	ld hl,00023h
	call sub_9d93h
	ld de,0c282h
	ld c,01ah
	call 0f37dh
	ld hl,00003h
	call sub_9d93h
	ld de,0c2c0h
	ld c,01ah
	call 0f37dh
	ld hl,00240h
	call sub_9d93h
	ld de,0c600h
	ld c,01ah
	call 0f37dh
	ld hl,00200h
	call sub_9d93h
	ld de,0c900h
	ld c,01ah
	call 0f37dh
	ld hl,004c0h
	jp sub_9d93h
sub_9cabh:
	di
	ld a,(0fd9fh)
	ld (0f0e4h),a
	ld a,0c9h
	ld (0fd9fh),a
	ld (0f0e2h),sp
	call sub_9db3h
	ld hl,l9797h
	ld (0f323h),hl
	call sub_9ea8h
	call sub_9d43h
	xor a
	ld (0d0e5h),a
	call sub_9e33h
	di
	ld hl,(0d0e7h)
	ld (0f323h),hl
	call sub_9de7h
	ld a,(0f0e4h)
	ld (0fd9fh),a
	ei
	ret
sub_9ce3h:
	ld de,(0d0e0h)
	ld c,00fh
	call 0f37dh
	ld c,001h
	inc a
	jp z,l975eh
	ret
sub_9cf3h:
	ld de,(0d0e0h)
	di
	ld c,016h
	call 0f37dh
	ei
	ld c,003h
	inc a
	jp z,l975eh
	ret
sub_9d05h:
	ld de,(0d0e0h)
	ld c,010h
	call 0f37dh
	ld c,002h
	inc a
	jp z,l975eh
	ret
sub_9d15h:
	ld hl,0ce00h
	ld de,0ce01h
	ld (hl),000h
	ld bc,00024h
	ldir
	ret
	ld (0d0e0h),hl
sub_9d26h:
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
sub_9d43h:
	ld hl,0ce50h
	ld de,0ce51h
	ld (hl),000h
	ld bc,000afh
	ldir
	ret
sub_9d51h:
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
sub_9d65h:
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
sub_9d93h:
	ld de,(0d0e0h)
	ld c,026h
	call 0f37dh
	ld c,004h
	or a
	jp nz,l975eh
	ret
sub_9da3h:
	ld de,(0d0e0h)
	ld c,027h
	call 0f37dh
	ld c,000h
	or a
	jp nz,l975eh
	ret
sub_9db3h:
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
	ld hl,l972ch
	ld (0f323h),hl
	ret
sub_9de7h:
	call sub_9e13h
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
sub_9e13h:
	ld b,000h
l9e15h:
	push bc
	call 0d0eah
	pop bc
	djnz l9e15h
	ret
sub_9e1dh:
	ld b,000h
l9e1fh:
	push bc
	call 0f0eah
	pop bc
	djnz l9e1fh
	ret
sub_9e27h:
	ld hl,0ce09h
	ld (hl),045h
	inc hl
	ld (hl),04ch
	inc hl
	ld (hl),047h
	ret
sub_9e33h:
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
	jr sub_9e33h
l9e5dh:
	ld hl,0d0e5h
	inc (hl)
	push hl
	call sub_9e7bh
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
sub_9e7bh:
	ld de,0ce26h
	ld a,(0d0e5h)
	dec a
	call sub_9e8ch
	ex de,hl
	ld bc,0000bh
	ldir
	ret
sub_9e8ch:
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
l9e9dh:
	ccf
	ccf
	ccf
	ccf
	ccf
	ccf
	ccf
	ccf
	ld b,l
	ld c,h
	ld b,a
sub_9ea8h:
	ld hl,0ce25h
	ld de,0ce26h
	ld (hl),000h
	ld bc,00024h
	ldir
	call sub_9d15h
	ld hl,l9e9dh
	ld de,0ce01h
	ld bc,0000bh
	ldir
	ret
vic_tick:                         ; 0x9EC4  per-frame; d_9ecd[(0xE280)]
	call vic_dispatch
	jp 0a67ch
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
	defw 0a350h                   ; 6 coffin pull left
	defw 0a36ch                   ; 7 coffin pull right
	defw 0a384h                   ; 8 knife
	defw 0a384h                   ; 9 boomerang (same windup)
	defw 0a405h                   ; 10 shovel
	defw 0a40fh                   ; 11 pick
	defw 0a419h                   ; 12 hammer
	defw 0a423h                   ; 13 drill
	defw 0a43ch                   ; 14 hold (e2a8; sub_92cah if e202 bit 6)
d_9ecd_jp_end:
vic_walk:                         ; 0x9EEE  ground: floor, use_tool, jump/walk
	call 0a624h
	call 0a4efh
	call sub_9f4dh
	call 0a512h
	jr nz,l9f02h
	call 0a45eh
	jp nz,l9fd4h
l9f02h:
	call use_tool
	ld a,(0e280h)
	or a
	ret nz
	call sub_9f77h
	ld a,(0e280h)
	or a
	ret nz
	ld a,(0e288h)
	and 00ch
	jr z,l9f3fh
	ld hl,0e296h
	dec (hl)
	ret nz
	ld (hl),004h
	ld a,(0e295h)
	inc a
	and 003h
	ld b,a
	ld (0e295h),a
	ld a,(0e294h)
	or a
	ld hl,l9f45h
	jr z,l9f36h
	ld hl,l9f49h
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
l9f45h:
	nop
	ld bc,00102h
l9f49h:
	inc bc
	inc b
	dec b
	inc b
sub_9f4dh:
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
	call sub_98e2h
	sub 002h
	ret c
	ld a,(0e282h)
	and 0f8h
	ld (0e282h),a
	xor a
	ld (0e2a6h),a
	ret
sub_9f77h:
	call 0a452h
	jr c,l9f95h
	ld a,(0e207h)
	bit 4,a
	jp nz,vic_begin_jump          ; fire, not holding: 0 -> 1
	ld a,(0e208h)
	rra
	jr nc,l9f8fh
	call 0a5a2h
	jr l9f95h
l9f8fh:
	rra
	jr nc,l9f9ah
	call 0a591h
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
	call sub_9910h
	pop hl
	pop bc
	jr c,l9fd0h
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
l9fd0h:
	ld (0e283h),hl
	ret
l9fd4h:
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
;  bank 3 @ 0xA000
; ---------------------------------------------------------------------------
	ld a,003h                     ; boot: vic_fall, then 0x42F3
	ld (0e280h),a
	jp 042f3h
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
	call 09910h
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
	call 0423ah
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
	defw 0a081h                   ; 1 knife / 2 boomerang (no map check; Vic 8/9)
	defw 0a081h
	defw 0a0a6h                   ; 3 shovel / 4 pick (two floor tiles type 2; Vic 10/11)
	defw 0a0a6h
	defw 0a0f0h                   ; 5 hammer / 6 drill (two wall tiles type 2; Vic 12/13)
	defw 0a0f0h
d_a072_jp_end:
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
	call 098e2h
	pop hl
	cp 002h
	ret nz
	ld a,h
	add a,008h
	ld h,a
	call 098e2h
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
	call 098dch
	cp 002h
	ret nz
	ld a,l
	add a,008h
	ld l,a
	call 098e2h
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
sub_a136h:
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
	jp nc,09fd0h
	push bc
	push hl
	ld a,(0e2a5h)
	or a
	ld a,(0e282h)
	jr z,la162h
	add a,006h
la162h:
	call sub_a16dh
	pop hl
	pop bc
	jp c,09fd0h
	jp 09fc1h
sub_a16dh:
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
	call 098dch
	sub 002h
	ret nc
	ld a,l
	and 0f8h
	add a,006h
	ld a,a
	call 098e2h
	sub 002h
	ret
vic_jump:                         ; 0xA190  air: e292 += 0x80 -> Y; land -> 0
	xor a
	ld (0e2a5h),a
	call sub_a1c1h
	ld a,(0e289h)
	and 00ch
	call nz,sub_a136h
	call sub_a535h
	ld a,(0efc0h)
	or a
	ret z
	call sub_a446h
	xor a
	ld (0e280h),a
	ld (0e2a6h),a
	ld (0e2a5h),a
	ld (0e295h),a
	inc a
	ld (0e296h),a
	call 09f20h
	jp 042e3h
sub_a1c1h:
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
	call sub_a1e6h
	ret c
	ld hl,0e2a5h
	inc (hl)
	ret
la1e1h:
	ld de,00400h
	jr la1d1h
sub_a1e6h:
	ld l,h
	dec l
	call sub_a1f9h
	ret nc
	ld a,l
	inc a
	and 0f8h
	add a,008h
	ld l,a
	call sub_a1f9h
	ret nc
	inc l
	inc l
sub_a1f9h:
	ld a,(0e284h)
	add a,002h
	ld h,a
	call 098dch
	sub 002h
	ret nc
	ld a,h
	add a,00ch
	ld h,a
	call 098dch
	sub 002h
	ret
vic_climb:                        ; 0xA20F  ladder (tile type 1); L/R probe / U-D
	call sub_a653h
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
	call 09910h
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
	call 098dch
	or a
	jr nz,la270h
	ld a,l
	add a,008h
	ld l,a
	call 098dch
	or a
	jr nz,la270h
	ld a,l
	add a,008h
	ld l,a
	call 098dch
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
	call 09910h
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
	call sub_a48fh
	ld a,(0e280h)
	cp 002h
	ret nz
	call sub_a476h
	ld a,(0e280h)
	cp 002h
	ret nz
	call sub_a2bbh
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
sub_a2bbh:
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
	call 09910h
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
	call sub_a512h
	ret z
	call sub_a446h
	xor a
	ld (0e280h),a
	ld (0e2a6h),a
	inc a
	ld (0e296h),a
	jp 042e3h
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
	jp 042a7h
la34bh:
	xor a
	ld (0e246h),a
	ret
	ld hl,0e299h                  ; Vic 6: coffin pull (left)
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
	jp 09f19h
la368h:
	ld (0e280h),a
	ret
	ld hl,0e299h                  ; Vic 7: coffin pull (right)
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
	jp 09f19h
	ld hl,0e286h                  ; Vic 8/9: knife / boomerang windup
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
	call 09910h
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
	ld a,(0e286h)                 ; Vic 10 shovel
	and 003h
	call z,04244h
	jr la42bh
	ld a,(0e286h)                 ; Vic 11 pick
	and 003h
	call z,0424eh
	jr la42bh
	ld a,(0e286h)                 ; Vic 12 hammer (wall, 1 deep)
	and 003h
	call z,04253h
	jr la42bh
	ld a,(0e286h)                 ; Vic 13 drill (wall, 2 deep)
	and 003h
	call z,04249h
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
	ld hl,0e2a8h                  ; Vic 14: hold until e2a8 hits 0
	dec (hl)
	ret nz
	xor a
	ld (0e280h),a
	ret
sub_a446h:
	ld a,(0e282h)
	and 0f8h
	ld h,a
	ld l,000h
	ld (0e281h),hl
	ret
	ld a,(0e2a4h)
	cp 006h
	ret nc
	inc a
	ld (0e2a4h),a
	scf
	ret
	ld a,(0e284h)
	add a,002h
	ld h,a
	ld a,(0e282h)
	ld l,a
	call 098dch
	dec a
	ret z
	ld a,h
	add a,00ch
	ld h,a
	call 098e2h
	dec a
	ret
sub_a476h:
	ld a,(0e284h)
	ld h,a
	ld a,(0e282h)
	ld l,a
	call 098dch
	dec a
	ret z
	ld a,l
	add a,010h
	ld l,a
	call 098e2h
	dec a
	ret z
	jp 09fd4h
sub_a48fh:
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
	call 098dch
	cp 002h
	jr nc,la4b2h
	ld a,h
	add a,008h
	ld h,a
	call 098dch
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
	jp 09f19h
la4d0h:
	ld a,(0e282h)
	sub 008h
	cp 008h
	ret c
	ld a,l
	sub 010h
	ld l,a
	call 098dch
	or a
	ret nz
	ld a,l
	add a,009h
	ld l,a
	call 098dch
	or a
	ret nz
	ld a,l
	sub 009h
	jr la4b8h
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
sub_a512h:
	ld a,(0e282h)
	add a,010h
	ld l,a
	ld a,(0e284h)
	add a,003h
	ld h,a
	call 098dch
	or a
	ret nz
	ld a,h
	add a,005h
	ld h,a
	call 098dch
	or a
	ret nz
	ld a,h
	add a,005h
	ld h,a
	call 098dch
	or a
	ret
sub_a535h:
	xor a
	ld (0efc0h),a
	call sub_a512h
	ret z
	dec a
	jr nz,la55fh
	ld a,l
	sub 00ch
	and 0f8h
	ld l,a
	call 098dch
	or a
	jr nz,la565h
	ld a,l
	add a,008h
	ld l,a
	call 098dch
	or a
	jr nz,la565h
	ld a,l
	add a,008h
	ld l,a
	call 098dch
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
	call sub_a571h
	ret c
	jr la55fh
sub_a571h:
	ld a,(0e284h)
	add a,003h
	ld h,a
	call 098dch
	sub 002h
	ret nc
	ld a,h
	add a,005h
	ld h,a
	call 098dch
	sub 002h
	ret nc
	ld a,h
	add a,005h
	ld h,a
	call 098dch
	sub 002h
	ret
	call sub_a5fbh
	ld a,(0e280h)
	cp 002h
	ret z
	ld a,(0e282h)
	add a,010h
	ld l,a
	jr la5b1h
	call sub_a5fbh
	ld a,(0e280h)
	cp 002h
	ret z
	ld a,(0e282h)
	add a,00ah
	ld l,a
la5b1h:
	ld a,(0e284h)
	ld h,a
	call 098dch
	dec a
	ld bc,00c0ch
	jr z,la5cch
	ld bc,0f400h
	ld a,h
	add a,010h
	ld h,a
	push bc
	call 098dch
	pop bc
	dec a
	ret nz
la5cch:
	ld a,h
	add a,b
	ld h,a
	push bc
	call 098dch
	pop bc
	dec a
	ret nz
	ld a,h
	sub c
	and 0f8h
	ld h,a
	ld l,000h
	push hl
	call sub_a603h
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
sub_a5fbh:
	ld a,(0e282h)
	add a,002h
	ld l,a
	jr la5b1h
sub_a603h:
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
	call 098dch
	pop bc
	dec a
	jr z,la611h
la621h:
	ld a,c
	rra
	ret
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
sub_a653h:
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
	ld a,(0e282h)
	add a,008h
	cp 002h
	jr c,la6a8h
	sub 008h
	cp 0aeh
	jr nc,la6b4h
	ld a,(0e294h)
	or a
	ld a,(0e284h)
	jr z,la69dh
	cp 0f1h
	ret c
	ld a,004h
	ld (0e248h),a
	ret
la69dh:
	add a,008h
	cp 00ah
	ret nc
	ld a,003h
	ld (0e248h),a
	ret
la6a8h:
	ld a,(0e280h)
	sub 002h
	ret nz
	ld a,001h
	ld (0e248h),a
	ret
la6b4h:
	cp 0f0h
	ret nc
	ld a,002h
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
	call sub_a6d5h
	pop bc
	ld de,00008h
	add ix,de
	djnz la6c8h
	ret
sub_a6d5h:
	ld a,(ix+000h)
	or a
	ret z
	dec a
	and 00fh
	call DISPATCH_A

; BLOCK 'd_a6dd_jp' (start 0xa6e0 end 0xa6ec)
d_a6dd_jp_start:
	defw 0a6ech                   ; type 1 knife
	defw 0a89bh                   ; type 2 boomerang
	defw 0aa66h                   ; type 3 shovel (floor, 1 deep)
	defw 0ab09h                   ; type 4 pick (floor, 2 deep)
	defw 0ab5dh                   ; type 5 hammer (wall, 1 deep)
	defw 0abf5h                   ; type 6 drill (wall, 2 deep)
d_a6dd_jp_end:
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_a6f2_jp' (start 0xa6f5 end 0xa6ff)
d_a6f2_jp_start:
	defw 0a6ffh                   ; knife: snap screen
	defw 0a706h                   ; fly
	defw 0a717h
	defw 0a743h
	defw 0a76eh
d_a6f2_jp_end:
	ld a,(0e243h)
	ld (ix+003h),a
	ret
	ld (ix+004h),000h
	ld a,(0e294h)
	ld (ix+007h),a
	call sub_a921h
	call sub_a79fh
	ret nc
	call sub_a87fh
	call sub_a787h
	jr nc,la724h
	ld a,(ix+007h)
	jr la729h
la724h:
	call sub_a826h
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
	call sub_a921h
	jp la814h
	call sub_a787h
	call sub_a87fh
	dec (ix+006h)
	ret nz
	xor a
	ld (ix+006h),004h
	ld (ix+005h),a
	ld (ix+007h),a
	call sub_a921h
	call sub_aa17h
	ld a,(ix+000h)
	and 0f0h
	ret nz
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	jp 042dbh
	call sub_a787h
	call sub_a87fh
	call sub_a9bah
	ld a,(ix+000h)
	and 0f0h
	ret nz
	ld a,(0e243h)
	cp (ix+003h)
	ret nz
	jp 042dbh
sub_a787h:
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
sub_a79fh:
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
	call 098dch
	sub 002h
	ld b,010h
	jr nc,la7f9h
	ld a,l
	add a,008h
	ld l,a
	call 098dch
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
	call 098dch
	sub 002h
	jr nc,la7f7h
	ld a,l
	add a,009h
	ld l,a
	call 098dch
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
	call sub_a921h
	and a
	ret
la814h:
	ld (ix+006h),018h
	ret
sub_a819h:
	ld a,b
	bit 7,a
	ld c,003h
	jr z,la830h
	neg
	ld b,a
	dec c
	jr la836h
sub_a826h:
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
	call 09910h
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
	call 09933h
	pop bc
	ret
sub_a87fh:
	ld a,(0e203h)
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 003h
	jr c,la897h
	ld a,(0e243h)
	cp (ix+003h)
	call z,04267h
	xor a
la897h:
	ld (ix+004h),a
	ret
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_a8a1_jp' (start 0xa8a4 end 0xa8ae)
d_a8a1_jp_start:
	defw 0a6ffh                   ; boomerang: snap screen
	defw 0a8aeh
	defw 0a8c7h
	defw 0a975h
	defw 0a994h
d_a8a1_jp_end:
	ld (ix+004h),003h
	ld (ix+005h),000h
	ld (ix+006h),008h
	ld a,(0e294h)
	ld (ix+007h),a
	call sub_a921h
	call sub_a79fh
	ret nc
	call sub_a99dh
	call sub_a787h
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
	ld hl,0a96bh
	add hl,de
	ld a,(hl)
	ld (ix+006h),a
la8f1h:
	ld e,(ix+005h)
	ld d,000h
	ld hl,la961h
	add hl,de
	ld a,(ix+007h)
	or a
	ld a,(hl)
	jr nz,la903h
	neg
la903h:
	ld b,a
	call sub_a819h
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
sub_a921h:
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
	call 042d7h
	ld (ix+000h),012h
	ld a,002h
	ld (0e287h),a
	ret
la961h:
	inc b
	inc bc
	ld (bc),a
	ld bc,0ff00h
	cp 0fdh
	call m,008fbh
	ld b,004h
	inc bc
	ld (bc),a
	inc bc
	inc b
	ld b,008h
	rst 38h
	call sub_a787h
	call sub_a99dh
	dec (ix+006h)
	ret nz
	xor a
	ld (ix+004h),003h
	ld (ix+005h),a
	ld (ix+006h),004h
	ld (ix+007h),a
	call sub_a921h
	jp sub_aa17h
	call sub_a787h
	call sub_a99dh
	jp sub_a9bah
sub_a99dh:
	ld a,(0e203h)
	and 001h
	ret nz
	ld a,(ix+004h)
	inc a
	cp 006h
	jr c,la9b6h
	ld a,(0e243h)
	cp (ix+003h)
	call z,04262h
	ld a,003h
la9b6h:
	ld (ix+004h),a
	ret
sub_a9bah:
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
	ld hl,laa60h
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
	jr nz,sub_aa17h
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
	call 098e2h
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
sub_aa17h:
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
	call 09933h
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
	call 096ffh
	pop ix
	call 09116h
	push ix
	call 096cfh
	pop ix
	ret
laa60h:
	inc bc
	inc bc
	inc bc
	inc bc
	inc bc
	rst 38h
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_aa6c_jp' (start 0xaa6f end 0xaa75)
d_aa6c_jp_start:
	defw 0a6ffh                   ; shovel: snap screen
	defw 0aa75h
	defw 0aa84h
d_aa6c_jp_end:
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp sub_a921h
	call sub_aaa9h
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
sub_aaa9h:
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
	call 056deh
	pop af
	ld (ix+005h),a
	add a,a
	ld e,a
	ld d,000h
	ld hl,lab03h
	add hl,de
	ex de,hl
	ld hl,(0e2a2h)
	ld a,(de)
	ex de,hl
	inc hl
	push hl
	push de
	call 05767h
	pop de
	pop hl
	ld a,d
	add a,008h
	ld d,a
	ld a,(hl)
	jp 05767h
laae7h:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00102h
	call 056deh
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)
	ld d,a
	ld bc,00102h
	xor a
	jp 063edh
lab03h:
	ld b,007h
	ex af,af'
	add hl,bc
	ld a,(bc)
	dec bc
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_ab0f_jp' (start 0xab12 end 0xab1a)
d_ab0f_jp_start:
	defw 0a6ffh                   ; pick: snap screen
	defw 0ab1ah
	defw 0ab29h
	defw 0ab52h
d_ab0f_jp_end:
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp sub_a921h
	call sub_aaa9h
	ld a,(ix+007h)
	or a
	ret z
	ld hl,(0e2a2h)
	ld a,l
	add a,008h
	ld l,a
	ld (0e2a2h),hl
	call 098dch
	cp 002h
	jp nz,laa8ch
	ld a,h
	add a,008h
	ld h,a
	call 098e2h
	cp 002h
	jp nz,laa8ch
	call d_ab0f_jp_end
	call sub_aaa9h
	ld a,(ix+007h)
	or a
	ret z
	jp laa8ch
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_ab63_jp' (start 0xab66 end 0xab6c)
d_ab63_jp_start:
	defw 0a6ffh                   ; hammer: snap screen
	defw 0ab6ch
	defw 0ab7bh
d_ab63_jp_end:
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp sub_a921h
	call sub_ab86h
	ld a,(ix+007h)
	or a
	ret z
	jp laa8ch
sub_ab86h:
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
	call 056deh
	pop af
	ld (ix+005h),a
	add a,a
	ld e,a
	ld d,000h
	ld hl,labe9h
	ld a,(0e294h)
	or a
	jr z,labb6h
	ld hl,labefh
labb6h:
	add hl,de
	ex de,hl
	ld hl,(0e2a2h)
	ld a,(de)
	ex de,hl
	inc hl
	push hl
	push de
	call 05767h
	pop de
	pop hl
	ld a,e
	add a,008h
	ld e,a
	ld a,(hl)
	jp 05767h
labcdh:
	ld hl,(0e2a2h)
	ld d,h
	ld e,l
	ld bc,00201h
	call 056deh
	inc (ix+007h)
	ld hl,(0e2a2h)
	ld a,(0e243h)
	ld d,a
	ld bc,00201h
	xor a
	jp 063edh
labe9h:
	inc c
	dec c
	ld c,00fh
	djnz lac00h
labefh:
	ld (de),a
	inc de
	inc d
	dec d
	ld d,017h
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_abfb_jp' (start 0xabfe end 0xac06)
d_abfb_jp_start:
	defw 0a6ffh                   ; drill: snap screen
lac00h:
	defw 0ac06h
	defw 0ac15h
	defw 0ac58h
d_abfb_jp_end:
	ld (ix+006h),008h
	ld (ix+005h),0ffh
	ld (ix+007h),000h
	jp sub_a921h
	call sub_ab86h
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
	call 098dch
	cp 002h
	jp nz,laa8ch
	ld a,l
	add a,008h
	ld l,a
	call 098e2h
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
	jp d_abfb_jp_end
	call sub_ab86h
	ld a,(ix+007h)
	or a
	ret z
	jp laa8ch
sub_ac63h:
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
	call sub_ac91h
	xor a
	ret
sub_ac91h:
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
	call sub_ad15h
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
	call sub_b266h
	pop hl
	ld (hl),a
	ld de,0ffeah
	add hl,de
	ld a,(hl)
	dec a
	call DISPATCH_A

; BLOCK 'd_acd9_jp' (start 0xacdc end 0xace4)
d_acd9_jp_start:
	defw 0ad2ch
	defw 0ad2ch
	defw 0b274h
	defw 0b67eh
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
sub_ad15h:
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
	ld (ix+018h),000h
	ld (ix+011h),0ffh
	ld hl,093b2h
	call sub_ad53h
	call sub_b223h
	inc c
	inc c
	ld (ix+00bh),c
	ld a,(ix+000h)
	dec a
	call z,sub_ae1ah
	ld (ix+014h),020h
	ld hl,04271h
	jp lb294h
sub_ad53h:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	push ix
	push hl
	call 096ffh
	call 090abh
	pop hl
	pop ix
	ld a,(ix+003h)
	sub 008h
	ld e,a
	ld d,(ix+005h)
	ld bc,00302h
	call draw_tilemap
	push ix
	call 090f7h
	call 096cfh
	pop ix
	ret
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_ad83_jp' (start 0xad86 end 0xad90)
d_ad83_jp_start:
	defw 0ae35h                   ; knife: throw / fall / land (5 states)
	defw 0ae55h
	defw 0ad90h
	defw 0adbbh
	defw 0adfah
d_ad83_jp_end:
	call 0b15eh
	ld a,004h
	jp c,laf2ch
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	ld de,00180h
	call sub_b29ch
	call sub_ae1ah
	call sub_b165h
	jp c,lae51h
	call sub_ae1ah
	call sub_b165h
	jp nc,06608h
	jp lae51h
	ld (ix+006h),001h
	call sub_af14h
	call sub_b15eh
	jr nc,ladcfh
	call sub_b833h
	ld a,004h
	jp laf2ch
ladcfh:
	call sub_b165h
	jr nc,laddfh
	call sub_b00fh
	dec a
	cp (ix+00bh)
	ret nz
	jp lb0a6h
laddfh:
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,06608h
sub_adeah:
	call sub_b833h
	ld (ix+014h),010h
	ld (ix+006h),000h
	ld (ix+001h),002h
	ret
	ld (ix+006h),001h
	call sub_b17ah
	ret c
	call sub_b833h
	call sub_b548h
	call sub_adeah
	ld (ix+006h),000h
	ld a,(ix+019h)
	xor 001h
	or 002h
	ld (ix+00bh),a
	ret
sub_ae1ah:
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_ae26_jp' (start 0xae29 end 0xae35)
d_ae26_jp_start:
	defw 0ae35h                   ; boomerang: throw / fly / return (6 states)
	defw 0ae55h
	defw 0ae8bh
	defw 0aeb5h
	defw 0af4eh
	defw 0af8ah
d_ae26_jp_end:
	dec (ix+014h)
	ret nz
	ld hl,093b8h
	call sub_ad53h
	ld hl,04307h
	call lb294h
	ld (ix+013h),002h
	ld (ix+011h),000h
	ld (ix+014h),020h
lae51h:
	inc (ix+001h)
	ret
	dec (ix+014h)
	ret nz
	call sub_ae6fh
	ld (ix+013h),003h
	ld (ix+014h),020h
	ld a,(0e243h)
	cp (ix+010h)
	call z,04294h
	jr lae51h
sub_ae6fh:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	ld d,(ix+005h)
	ld a,(ix+003h)
	sub 008h
	ld e,a
	ld bc,00302h
	call 056deh
	ld hl,093ach
	jp sub_ad53h
	call sub_b15eh
	jp c,laf2ah
	ld (ix+011h),000h
	dec (ix+014h)
	ret nz
	call sub_b211h
	call sub_afaah
	ld de,00180h
	call sub_b29ch
	call sub_b165h
	jr c,lae51h
	call sub_ae1ah
	call sub_b165h
	jp nc,06608h
	jr lae51h
	ld (ix+006h),001h
	call sub_af14h
	call sub_b15eh
	jr nc,laec6h
	call sub_b833h
	jr laf2ah
laec6h:
	call sub_b00fh
	dec a
	cp (ix+00bh)
	jp z,lb0a6h
	call sub_b165h
	jr c,laee6h
	call sub_b833h
	inc (ix+018h)
	ld a,(ix+018h)
	cp 010h
	jp nc,06608h
	jp laf7dh
laee6h:
	call sub_b23fh
	dec c
	ret m
	jr z,laef5h
	call sub_b143h
	ret nz
	ld a,001h
	jr laefah
laef5h:
	call sub_b150h
	ret nz
	xor a
laefah:
	ld (ix+00bh),a
	ld de,00280h
	call sub_b2a3h
	ld de,00000h
	call sub_b29ch
	ld a,(ix+005h)
	and 0f8h
	ld (ix+005h),a
	jp lae51h
sub_af14h:
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
	ld hl,042b3h
	jp lb294h
	ld (ix+006h),001h
	ld c,005h
	call laf1eh
	call sub_b0f9h
	jp c,laf73h
	call sub_b00fh
	dec a
	cp (ix+00bh)
	jr z,laf6ah
	call sub_b165h
	ret c
laf6ah:
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
laf73h:
	call sub_b833h
	xor a
	ld (ix+002h),a
	ld (ix+018h),a
laf7dh:
	ld (ix+014h),010h
	ld (ix+006h),000h
	ld (ix+001h),002h
	ret
	ld (ix+006h),001h
	call sub_b17ah
	ret c
	call sub_b833h
	call sub_b548h
	call laf7dh
	ld a,(ix+019h)
	xor 001h
	or 003h
	ld (ix+00bh),a
	ld (ix+006h),000h
	ret
sub_afaah:
	call sub_b223h
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
	ld ix,0e500h
	call 09a0bh
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
	call sub_aff6h
	pop bc
	pop de
lafech:
	ex de,hl
	ld de,00020h
	add ix,de
	ex de,hl
	djnz lafbdh
	ret
sub_aff6h:
	ld a,(ix+000h)
	cp 004h
	jp nz,06706h
	ld a,(ix+001h)
	cp 004h
	jr z,lb009h
	dec a
	jp nz,06706h
lb009h:
	call sub_b9f0h
	jp 06706h
sub_b00fh:
	ld a,(0e243h)
	cp (ix+010h)
	jp z,lb0a4h
	call 09a0bh
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
	call sub_b096h
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
	call sub_b096h
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
	call sub_b096h
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
	call sub_b096h
	jr nz,lb0a4h
	ret
sub_b096h:
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
	ld hl,lb0f1h
	call ADD_HL_A
	ld c,(hl)
	inc hl
	ld b,(hl)
	call sub_b216h
	ld a,c
	add a,l
	ld l,a
	ld a,b
	add a,h
	ld h,a
	call sub_b0e5h
	ret nc
	ld a,008h
	add a,h
	ld h,a
	call sub_b0e5h
	ret nc
	ld a,008h
	add a,l
	ld l,a
	call sub_b0e5h
	ld a,0f8h
	add a,h
	ld h,a
	call sub_b0e5h
	ret nc
	call sub_b21ch
	ld a,c
	add a,l
	ld (ix+003h),a
	ld a,b
	add a,h
	ld (ix+005h),a
	ret
sub_b0e5h:
	push de
	push hl
	push bc
	call 098e6h
	pop bc
	pop hl
	pop de
	sub 001h
	ret
lb0f1h:
	djnz lb0f3h
lb0f3h:
	ret p
	nop
	nop
	djnz lb0f8h
lb0f8h:
	ret p
sub_b0f9h:
	ld a,(ix+00bh)
	dec a
	jr z,lb128h
lb0ffh:
	call sub_b1ach
	ccf
	ret nc
	ld a,l
	add a,007h
	and 0f8h
	ld l,a
	call sub_b12fh
	ret z
	ld a,008h
	add a,l
	ld l,a
	call sub_b12fh
	ret z
	ld a,008h
	add a,h
	ld h,a
	call sub_b12fh
	ret z
	ld a,l
	sub 008h
	ld l,a
	call sub_b12fh
	ret z
	scf
	ret
lb128h:
	call sub_b165h
	ccf
	ret c
	jr lb0ffh
sub_b12fh:
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	push hl
	call 098e6h
	pop hl
	and a
	dec a
	ret
	call sub_b150h
	ld c,000h
	ret z
sub_b143h:
	call sub_b21ch
	ld a,010h
	add a,l
	ld l,a
	call sub_b153h
	ld c,001h
	ret
sub_b150h:
	call sub_b21ch
sub_b153h:
	call sub_b12fh
	ret nz
	ld a,h
	add a,008h
	ld h,a
	jp sub_b12fh
sub_b15eh:
	call sub_b21ch
	ld c,001h
	jr lb181h
sub_b165h:
	ld c,(ix+00bh)
sub_b168h:
	call sub_b1ach
	ret c
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	push hl
	push de
	call 09933h
	pop de
	pop hl
	ret
sub_b17ah:
	ld c,(ix+00bh)
	call sub_b1ach
	ret c
lb181h:
	ld e,(ix+00ch)
	ld d,(ix+00dh)
	call 0995ah
	call sub_b191h
	ret nc
	call sub_b19dh
sub_b191h:
	push hl
	push de
	push bc
	call 098e6h
	pop bc
	pop de
	pop hl
	sub 001h
	ret
sub_b19dh:
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
sub_b1ach:
	ld a,(ix+006h)
	and a
	jp z,sub_b21ch
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
	call z,sub_b200h
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
	call z,sub_b200h
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
sub_b200h:
	ld a,e
	cpl
	ld e,a
	ld a,d
	cpl
	ld d,a
	inc de
	ret
	ld a,004h
sub_b20ah:
	inc (ix+00eh)
	cp (ix+00eh)
	ret
sub_b211h:
	xor a
	ld (ix+00eh),a
	ret
sub_b216h:
	ld e,(ix+00ch)
	ld d,(ix+00dh)
sub_b21ch:
	ld l,(ix+003h)
	ld h,(ix+005h)
	ret
sub_b223h:
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
sub_b23fh:
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
sub_b266h:
	ld hl,0e788h
	ld bc,00040h
	cpir
	ld a,c
	sub 03fh
	neg
	ret
	ld (ix+01bh),0ffh
	ld (ix+01dh),080h
	call sub_b223h
	ld a,c
	or 002h
	ld (ix+00bh),a
	ld (ix+011h),018h
	ld (ix+018h),0ffh
	ld (ix+01ch),000h
	ld hl,0426ch
lb294h:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp (hl)
sub_b29ch:
	ld (ix+009h),e
	ld (ix+00ah),d
	ret
sub_b2a3h:
	ld (ix+007h),e
	ld (ix+008h),d
	ret
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_b2ad_jp' (start 0xb2b0 end 0xb2ba)
d_b2ad_jp_start:
	defw 0b2bah                   ; shovel: floor hole 1 deep
	defw 0b307h
	defw 0b4bbh
	defw 0b5b7h
	defw 0b5fbh
d_b2ad_jp_end:
	ld a,(0f0f4h)
	ld hl,lb2f4h
	ld de,lb2feh
	call sub_b6e0h
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
lb2f4h:
	jr lb30fh
	jr $+27
	jr $+27
	ld a,(de)
	rlca
	rlca
	rst 38h
lb2feh:
	jr lb319h
	jr lb31bh
	jr lb31dh
	rlca
	rlca
	rst 38h
	call sub_b552h
	jp z,lb50bh
	ld c,009h
lb30fh:
	call sub_b4afh
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
	call sub_b23fh
	dec c
	jp z,lb417h
	dec c
	jp z,lb452h
	ld a,(ix+01ch)
	cp 002h
	jp nc,lb3f5h
lb33ch:
	call sub_b60eh
	call sub_b385h
	jr c,lb35fh
	ld a,(ix+00bh)
	xor 001h
	or 002h
	ld (ix+00bh),a
	call sub_b385h
	jp nc,06608h
	ld a,(ix+01ch)
	cp 010h
	jp nc,06608h
	inc (ix+01ch)
lb35fh:
	ld de,000f0h
	call sub_b29ch
	ld (ix+006h),000h
	ld (ix+014h),011h
	ld a,(ix+005h)
	ld (ix+018h),a
	ld a,(ix+00bh)
	ld (ix+019h),a
	inc (ix+01dh)
	ld hl,04276h
	call lb294h
	jp lb2f0h
sub_b385h:
	call sub_b216h
	ld a,l
	sub 008h
	ld l,a
	jr c,lb3d0h
	call sub_b3d6h
	jr c,lb39ah
	call sub_b216h
	call sub_b3d6h
	ret nc
lb39ah:
	call sub_b216h
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
	call 098e6h
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
sub_b3d6h:
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
	call 098e6h
	sub 002h
	ret
lb3f5h:
	bit 0,(ix+01ch)
	jr z,lb40bh
	call sub_b21ch
	ld a,l
	add a,010h
	ld l,a
	call sub_b471h
	ld a,001h
	jr nc,lb42fh
	jr lb417h
lb40bh:
	call sub_b21ch
	call sub_b471h
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
	call sub_b21ch
	call sub_b471h
	jp c,lb33ch
	xor a
lb42fh:
	ld (ix+00bh),a
	ld (ix+01bh),a
	ld (ix+01dh),000h
	ld (ix+006h),001h
	ld (ix+01ch),000h
	ld de,00000h
	call sub_b29ch
	ld de,00100h
	call sub_b2a3h
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
	call sub_b21ch
	ld a,l
	add a,010h
	ld l,a
	call sub_b471h
	jp c,lb33ch
	ld a,001h
	jr lb42fh
sub_b471h:
	call sub_b12fh
	ld c,000h
	jr z,lb479h
	inc c
lb479h:
	ld a,h
	add a,008h
	ld h,a
	push bc
	call sub_b12fh
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
sub_b4afh:
	bit 0,(ix+00bh)
	jr z,lb4b7h
	inc c
	inc c
lb4b7h:
	ld (ix+011h),c
	ret
	call sub_b00fh
	dec a
	cp (ix+00bh)
	ld (ix+006h),000h
	ret z
	ld (ix+006h),001h
	ld c,00ah
	call sub_b4afh
	ld a,(ix+014h)
	and a
	jr z,lb50bh
	dec (ix+014h)
	ld de,000f0h
	call sub_b29ch
	call sub_b64eh
	call nc,sub_b58fh
	ld a,(ix+014h)
	cp 008h
	jr nc,lb4f1h
	call sub_b555h
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
	call sub_b555h
	jr nz,lb52fh
	ld de,00500h
	call sub_b2a3h
	ld de,00000h
	call sub_b29ch
	ld (ix+00bh),001h
	ld (ix+001h),004h
	jp laf48h
lb52fh:
	call sub_b58fh
	ld (ix+006h),000h
	ld (ix+014h),008h
	ld a,(ix+003h)
	add a,007h
	and 0f8h
	ld (ix+003h),a
	ld (ix+001h),001h
sub_b548h:
	ld a,(0e243h)
	cp (ix+010h)
	jp z,0423fh
	ret
sub_b552h:
	xor a
	jr lb558h
sub_b555h:
	call sub_b673h
lb558h:
	call sub_b216h
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
	call sub_b571h
	ret nz
	ld a,h
	add a,008h
	ld h,a
sub_b571h:
	push hl
	push de
	call 098e6h
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
	call 098e6h
	pop de
	pop hl
	dec a
	jr nz,lb58ch
	xor a
	ret
lb58ch:
	or 0ffh
	ret
sub_b58fh:
	ld de,00000h
	jp sub_b29ch

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

; BLOCK 'ix14_db' (start 0xb5a6 end 0xb5b8)
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
	defb 0cdh
ix14_db_end:
	rrca
	or b
	dec a
	cp (ix+00bh)
	ld (ix+006h),000h
	ret z
	ld (ix+006h),001h
	ld c,00dh
	call laf1eh
	call sub_b0f9h
	jr c,lb5deh
	call sub_b165h
	ret c
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	ret
lb5deh:
	call sub_b833h
	ld de,00000h
	call sub_b2a3h
	call sub_b29ch
	ld (ix+006h),000h
	ld (ix+014h),008h
	ld (ix+018h),0ffh
	ld (ix+001h),001h
	ret
	call sub_b555h
	ret z
	ld de,00000h
	call sub_b2a3h
	ld a,(ix+019h)
	ld (ix+00bh),a
	jp lb52fh
sub_b60eh:
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
	jp sub_b211h
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
	call sub_b223h
	ld a,c
	or 002h
	ld (ix+00bh),a
	ret
sub_b64eh:
	ld c,(ix+00bh)
	call sub_b1ach
	ret c
	call sub_b673h
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
	call 098e6h
	sub 002h
	ret
sub_b673h:
	ld a,(ix+014h)
	ld de,ix14_da_start
	call ADD_DE_A
	ld a,(de)
	ret
	xor a
	ld (ix+014h),a
	ld (ix+01ch),a
	ld (ix+013h),a
	ld hl,0426ch
	jp lb294h
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_b691_jp' (start 0xb694 end 0xb6a0)
d_b691_jp_start:
	defw 0b6a0h                   ; pick: floor hole 2 deep
	defw 0b6f9h
	defw 0b754h
	defw 0b881h
	defw 0b8ech
	defw 0b90eh
d_b691_jp_end:
	ld hl,lb6afh
	ld de,lb6b6h
	call sub_b6e0h
	jr z,lb6bdh
	ld (ix+011h),a
	ret
lb6afh:
	dec de
	dec de
	inc e
	inc e
	dec e
	dec e
	rst 38h
lb6b6h:
	jr $+27
	jr lb6d3h
	jr $+27
	rst 38h
lb6bdh:
	ld (ix+013h),003h
	ld (ix+014h),03ch
	ld a,(0f0f4h)
	and a
	jr z,lb6dch
	ld (ix+01eh),007h
	ld (ix+01fh),049h
lb6d3h:
	call sub_b9a2h
	call sub_ba6eh
	jp c,lba7fh
lb6dch:
	inc (ix+001h)
	ret
sub_b6e0h:
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
	ld c,001h
	call sub_b168h
	jr nc,lb706h
	call sub_b9f0h
	jp lb856h
lb706h:
	call sub_b956h
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
	call sub_b9f0h
	ld a,003h
	call sub_b20ah
	jp c,06608h
	call sub_b223h
	ld a,c
	or 002h
	ld (ix+00bh),a
	call sub_b165h
	jr c,lb748h
	ld a,(ix+00bh)
	xor 001h
	ld (ix+00bh),a
	call sub_b165h
	jp nc,06608h
lb748h:
	ld de,00200h
	call sub_b29ch
	ld (ix+006h),001h
	jr lb6dch
	call sub_b00fh
	dec a
	cp (ix+00bh)
	jp z,lb0a6h
	dec (ix+014h)
	call sub_b874h
	ld a,(ix+005h)
	and 007h
	cp 003h
	jr nc,lb778h
	call sub_b216h
	ld c,001h
	call 09933h
	jp c,lb856h
lb778h:
	call sub_b165h
	jr nc,lb7b1h
	call sub_b7dfh
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
	call sub_b833h
	ld c,001h
	call 09933h
	jp c,lb856h
	call ix14_dc_end
lb7bfh:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp 0428fh
	ld (ix+006h),000h
	ld de,00000h
	call sub_b29ch
	call sub_b2a3h
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
sub_b7dfh:
	ld l,(ix+003h)
	ld h,(ix+005h)
	call sub_b1ach
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
sub_b833h:
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
	call sub_b211h
	ld (ix+00bh),001h
	ld de,00500h
	call sub_b2a3h
	ld de,00000h
	call sub_b29ch
	ld (ix+01ch),000h
	ld (ix+001h),003h
	jp laf48h
sub_b874h:
	ld a,(ix+014h)
	rra
	rra
	and 003h
	add a,011h
	ld (ix+011h),a
	ret
	inc (ix+01ch)
	jr nz,lb889h
	dec (ix+01ch)
lb889h:
	ld (ix+006h),001h
	call sub_b874h
	call sub_b165h
	jr nc,lb8a8h
	call sub_b7dfh
	ret nc
	call sub_b833h
	call ix14_dc_end
	ld a,(ix+01ch)
	cp 003h
	ret c
	jp lb7bfh
lb8a8h:
	call sub_b833h
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+014h),000h
	ld (ix+001h),005h
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
	jp 04294h
	ld (ix+013h),001h
	ld a,(ix+001h)
	dec a
	jr z,lb8d6h
	dec a
	ret nz
	call sub_b8dbh
	jr ix14_dc_end
lb8d6h:
	call sub_b8dbh
	jr lb941h
sub_b8dbh:
	ld a,(ix+005h)
	and 0f8h
	ld (ix+005h),a
	ld a,(ix+003h)
	and 0f8h
	ld (ix+003h),a
	ret
	call sub_b956h
	ld c,001h
	call sub_b168h
	jr c,lb908h
	ld a,(0e203h)
	and 003h
	dec (ix+014h)
	ret nz
	ld (ix+014h),03ch
	ld (ix+001h),001h
	ret
lb908h:
	call sub_b9f0h
	jp lb856h
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
	call sub_b9a2h
	call sub_ba6eh
	jp c,lba7fh
lb941h:
	ld (ix+006h),000h
	ld (ix+011h),011h
	ld (ix+013h),001h
	ld (ix+014h),0b4h
	ld (ix+001h),004h
	ret
sub_b956h:
	call sub_b216h
	call sub_ba24h
	call sub_b9c5h
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
	call sub_b216h
	ld a,h
	add a,008h
	ld h,a
	call sub_ba24h
	call sub_b9c5h
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
sub_b992h:
	ld a,(ix+001h)
	cp 004h
	jr z,lb99bh
	dec a
	ret nz
lb99bh:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
sub_b9a2h:
	call sub_b216h
	call sub_ba24h
	call sub_b9c5h
	ld (ix+018h),e
	ld (ix+019h),d
	call sub_b216h
	ld a,h
	add a,008h
	ld h,a
	call sub_ba24h
	call sub_b9c5h
	ld (ix+01ah),e
	ld (ix+01bh),d
	ret
sub_b9c5h:
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
sub_b9e0h:
	ld a,(ix+001h)
	cp 004h
	jr z,lb9e9h
	dec a
	ret nz
lb9e9h:
	ld a,(0e243h)
	cp (ix+010h)
	ret nz
sub_b9f0h:
	call sub_b216h
	ld a,h
	add a,008h
	ld h,a
	call sub_ba24h
	ld e,(ix+01ah)
	ld d,(ix+01bh)
	call sub_ba0fh
	call sub_b216h
	call sub_ba24h
	ld e,(ix+018h)
	ld d,(ix+019h)
sub_ba0fh:
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
sub_ba24h:
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
	call z,sub_b9e0h
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
	call sub_b992h
lba65h:
	ld de,00020h
	add ix,de
	pop bc
	djnz lba5ah
	ret
sub_ba6eh:
	ld a,(ix+018h)
	or (ix+019h)
	or (ix+01ah)
	or (ix+01bh)
	and 0aah
	ret z
	scf
	ret
lba7fh:
	call sub_b9f0h
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
	call 04280h
sub_badah:
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
	call sub_badah
	inc (ix+001h)
	jp 04280h
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
	call 056deh
	exx
	ld (0efc0h),hl
	ld (0efc2h),de
	ld (0efc4h),bc
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld hl,(0efc0h)
	call sub_bb93h
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
	call sub_bb93h
	pop bc
	pop hl
	djnz lbb84h
lbb90h:
	ld hl,(0efc4h)
sub_bb93h:
	push de
	ld a,(ix+005h)
	add a,a
	call ADD_HL_A
	ld a,(hl)
	push hl
	call 05767h
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	ld a,(hl)
	call 05767h
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
	call 04285h
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
	call 04285h
	xor a
	ld (ix+005h),a
	ld (ix+001h),a
	jr lbc10h
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
	call sub_bc9ch
	jr nc,lbc81h
	inc (ix+001h)
	ld (ix+006h),01eh
	ret
sub_bc9ch:                        ; Vic under the column (same screen)
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
	call 090abh
	pop de
	ld a,005h
	call 05767h
	call 090f7h
	pop ix
	jp 042c7h
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
	call sub_bd7ah
	xor a
sub_bd65h:
	ld bc,00104h
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld d,(ix+004h)
	call 063edh
	ret
lbd75h:
	ld (ix+00ah),001h
	ret
sub_bd7ah:
	call 0429eh
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
	call 05029h
	ret
	xor a                             ; 0xBDC0  type 4 trap: 4 × tile 0x61
	ld (ix+00ah),a
	ld (ix+00bh),a
	call sub_bddeh
	ld a,003h
	call sub_bd65h
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
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
	call 05767h
	pop de
	ld a,d
	add a,008h
	ld d,a
	djnz lbdc8h
	ret
sub_bddeh:
	ld h,(ix+003h)
	ld l,(ix+002h)
	ld a,(0f0f4h)
	and a
	jr nz,lbe00h
	call 04d7bh
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
	call 05029h
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
	call 096ffh
	call 090abh
	pop bc
	pop de
	pop hl
	push hl
	push de
	ld a,005h
	call sub_bed0h
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
	call 096cfh
	call 090f7h
	ld hl,0e282h
	ld a,(hl)
	add a,003h
	and 0f8h
	ld (hl),a
	jp 04303h
sub_bed0h:
	push hl
	push de
	push af
	call 05767h
	ld a,d
	add a,008h
	ld d,a
	pop af
	call 05767h
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
