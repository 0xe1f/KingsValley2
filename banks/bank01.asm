; ===========================================================================
;  bank 01 — 8 KiB mapper bank, assembled at CPU 0x6000 (PHASE in master).
;  Boot triplet with banks 2/3 via page_banks_123. Code-heavy.
;  Regen: tools/workbench/msx/regen-bank.sh 1 0x6000 banks/bank01.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	call 051d0h
	call 051d0h
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
	call 0514ch
	ld hl,0bfc6h
	ld de,09838h
	ld bc,00607h
	call 0514ch
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
	call sub_6336h
	jp page_banks_123
sub_6336h:
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
	ld (ix+008h),a
	ld a,(hl)
	and 007h
	jr z,l6378h
	set 1,(ix+007h)
	jr l637ch
l6378h:
	res 1,(ix+007h)
l637ch:
	ld b,a
	add a,a
	add a,b
	ld b,a
	ld a,(ix+000h)
	cp 001h
	jr z,l6389h
	ld b,000h
l6389h:
	ld (ix+005h),b
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
	ld (bc),a
	ld bc,00401h
	ld (bc),a
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
	jp 0bc74h
sub_649bh:
	ld a,(ix+000h)
	and a
	ret z
	dec a
	call DISPATCH_A

; BLOCK 'd_64a1_jp' (start 0x64a4 end 0x64ae)
d_64a1_jp_start:
	defw 0ba85h
	defw 0bbb0h
	defw 0bcc0h
	defw 0bd21h
	defw 093f3h
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
l64cfh:
	ld b,e
	cp e
	ld d,b
	cp h
	jp po,060bch
	ld h,h
	ld (hl),096h
l64d9h:
	ld b,e
	cp e
	ld d,b
	cp h
	ld h,b
	ld h,h
	xor d
	cp l
	ld h,b
	ld h,h
	ld hl,0e700h
	ld b,080h
	xor a
l64e9h:
	ld (hl),a
	inc hl
	djnz l64e9h
	call page_bank_13
	call sub_64f6h
	jp page_banks_123
sub_64f6h:
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
	jp 0573bh
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
	defw 0ad80h
	defw 0ae23h
	defw 0b2aah
	defw 0b68eh
	defw 0662dh
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
	ld bc,0becfh
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
	call 0ac6dh
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
	ld hl,0b7cdh
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 04f1ch
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
	call 051d0h
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
	call 051d0h
	call page_banks_123
	ld c,0ffh
	ld hl,05f0eh
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
	call 04ef2h
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
	call 04ef2h
	ld de,00406h
	ld a,006h
	call 04ef2h
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
	call 051d0h
	jp page_banks_123
sub_7725h:
	call page_bank_12
	ld a,(0edcfh)
	ld hl,0ad76h
	call 04d4ch
	call 051d0h
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
	jp 04ef2h
sub_774bh:
	ld a,(0e204h)
	rra
	rra
	ld de,l7000h
	jr c,l7758h
	ld de,00007h
l7758h:
	ld a,00ch
	jp 04ef2h
sub_775dh:
	ld b,010h
l775fh:
	ld a,b
	inc a
	ld de,00000h
	call 04ef2h
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
	call 04ef2h
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
	call 0514ch
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
	call 051d0h
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
	call 051d0h
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
	jr z,08016h              ; +0x18 -> bank 2 @ 0x8016
	defb 021h,0f3h            ; ld hl,0E2F3h straddles 0x8000
