; ===========================================================================
;  bank 12 — mixed gfx + code, assembled at CPU 0xA000 (PHASE in master).
;  Triplet 10/11/12 via page_banks_10_11_12; also paged A000-only by
;  page_bank_12 (6000/8000 keep the previous triplet).
;  0xA000–0xB3FF: map-stream tail, object lists, tiles (not code).
;  Code from 0xB400 (far-called from bank 0). Trailing 0xFF from 0xBFB3.
;  Regen: tools/workbench/msx/regen-bank.sh 12 0xA000 banks/bank12.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank12.gfx.bin"
	ld hl,data_b548_start                 ; 0xB400  far call from bank 0
lb403h:
	ld a,(hl)
	and a
	ret z
	ld a,(0e242h)
	cp (hl)
	jr z,lb413h
	ld a,005h
	call ADD_HL_A
	jr lb403h
lb413h:
	inc hl
	ld de,0ef10h
	ldi
	xor a
	ld (de),a
	inc de
	ld bc,00003h
	ldir
	ret
	ld hl,0ef10h
	ld a,(hl)
	or a
	ret z
	inc l
	ld a,(hl)
	inc l
	exx
	call DISPATCH_A

; BLOCK 'disp_b42f' (start 0xb42f end 0xb437)
disp_b42f_start:
	defw 0b437h
	defw 0b462h
	defw 0b46ch
	defw 0b48fh
disp_b42f_end:
	exx
	ld a,(0e243h)
	cp (hl)
	ret nz
	ld a,(0e280h)
	dec a
	ret nz
	call sub_b4ach
	ret nc
	ld hl,0ef11h
	inc (hl)
	inc l
	inc l
	inc l
	inc l
	ld (hl),040h
	call 096ffh
	call 090abh
	call sub_b4e3h
	call 090f7h
	call 096cfh
	jp 042efh
	ld hl,0ef15h
	dec (hl)
	ret nz
	ld hl,0ef11h
	inc (hl)
	ret
	exx
	ld a,(0e243h)
	cp (hl)
	ret nz
	call sub_b4c9h
	ret nc
	call 042bbh
	ld hl,0ef11h
	inc (hl)
	call 096ffh
	call 090abh
	call sub_b50bh
	call 056c5h
	call 090f7h
	jp 096cfh
	exx
	ld a,(0e243h)
	cp (hl)
	ret nz
	call sub_b4c9h
	ret nc
	ld a,(0e208h)
	rra
	rra
	ret nc
	xor a
	ld hl,0000ch
	ld (0e200h),hl
	ld (0ef11h),a
	jp 042c3h
sub_b4ach:
	inc l
	ld a,(hl)
	sub 010h
	ld b,a
	ld a,(0e282h)
	sub b
	jr nc,lb4b9h
	neg
lb4b9h:
	cp 004h
	ret nc
	inc l
	ld b,(hl)
	ld a,(0e284h)
	sub b
	jr nc,lb4c6h
	neg
lb4c6h:
	cp 004h
	ret
sub_b4c9h:
	inc l
	ld b,(hl)
	ld a,(0e282h)
	sub b
	jr nc,lb4d3h
	neg
lb4d3h:
	cp 004h
	ret nc
	inc l
	ld b,(hl)
	ld a,(0e284h)
	sub b
	jr nc,lb4e0h
	neg
lb4e0h:
	cp 008h
	ret
sub_b4e3h:
	ld hl,0ef13h
	call pat_b4f8_end
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,pat_b4f8_start
	ld bc,00202h
	jp 0573bh

; BLOCK 'pat_b4f8' (start 0xb4f8 end 0xb4fc)
pat_b4f8_start:
	defb 0cah
	defb 0cbh
	defb 0cch
	defb 0cdh
pat_b4f8_end:
	ld a,(hl)
	inc l
	ld h,(hl)
	ld l,a
	ld de,000b0h
	ld bc,01010h
	ld a,004h
	jp 05029h
sub_b50bh:
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,000b0h
	ld bc,01010h
	ld a,001h
	jp 05029h
	ld hl,0ef10h
	ld a,(hl)
	or a
	ret z
	inc l
	inc l
	ld a,(0e243h)
	cp (hl)
	ret nz
	dec l
	ld a,(hl)
	or a
	ret z
	cp 003h
	jp z,056c5h
	jr sub_b4e3h
	call sub_b53ah
	jp 0583bh
sub_b53ah:
	ld ix,0ef10h
	ld a,(ix+000h)
	dec a
	jp z,lb917h
	jp data_b548_end

; BLOCK 'data_b548' (start 0xb548 end 0xb6b0)
data_b548_start:
	defb 007h
	defb 001h
	defb 002h
	defb 008h
	defb 008h
	defb 014h
	defb 002h
	defb 002h
	defb 088h
	defb 030h
	defb 018h
	defb 001h
	defb 004h
	defb 028h
	defb 0e0h
	defb 01dh
	defb 002h
	defb 001h
	defb 0a8h
	defb 0e0h
	defb 020h
	defb 001h
	defb 003h
	defb 080h
	defb 030h
	defb 023h
	defb 002h
	defb 003h
	defb 018h
	defb 0d8h
	defb 028h
	defb 001h
	defb 001h
	defb 080h
	defb 070h
	defb 02bh
	defb 002h
	defb 001h
	defb 0a0h
	defb 098h
	defb 032h
	defb 001h
	defb 002h
	defb 0a8h
	defb 018h
	defb 034h
	defb 002h
	defb 001h
	defb 0a8h
	defb 0e0h
	defb 035h
	defb 001h
	defb 003h
	defb 038h
	defb 0b0h
	defb 037h
	defb 002h
	defb 002h
	defb 078h
	defb 0c0h
	defb 000h
lb585h:
	defb 050h
	defb 018h
	defb 0f3h
	defb 0efh
	defb 0f5h
	defb 0eeh
	defb 0e4h
	defb 000h
	defb 0f3h
	defb 0e5h
	defb 0ech
	defb 0e5h
	defb 0e3h
	defb 0f4h
	defb 0feh
	defb 040h
	defb 0a8h
	defb 0f3h
	defb 0e5h
	defb 0ech
	defb 0e5h
	defb 0e3h
	defb 0f4h
	defb 000h
	defb 0fch
	defb 0fch
	defb 0fch
	defb 000h
	defb 0f3h
	defb 0f0h
	defb 0e1h
	defb 0e3h
	defb 0e5h
	defb 0feh
	defb 058h
	defb 0b8h
	defb 0e5h
	defb 0eeh
	defb 0e4h
	defb 000h
	defb 0fch
	defb 0fch
	defb 0fch
	defb 000h
	defb 0f2h
	defb 0e5h
	defb 0f4h
	defb 0f5h
	defb 0f2h
	defb 0eeh
	defb 0ffh
lb5b8h:
	defb 050h
	defb 018h
	defb 0f0h
	defb 0f5h
	defb 0fah
	defb 0fah
	defb 0ech
	defb 0e5h
	defb 000h
	defb 000h
	defb 0e7h
	defb 0e1h
	defb 0edh
	defb 0e5h
	defb 0ffh
lb5c7h:
	defb 060h
	defb 090h
	defb 0e1h
	defb 0ech
	defb 0ech
	defb 000h
	defb 0f2h
	defb 0e9h
	defb 0e7h
	defb 0e8h
	defb 0f4h
	defb 0feh
	defb 060h
	defb 0a0h
	defb 0f2h
	defb 0e5h
	defb 0f3h
	defb 0f4h
	defb 000h
	defb 000h
	defb 0d3h
	defb 000h
	defb 0f5h
	defb 0f0h
	defb 0ffh
lb5e0h:
	defb 0e8h
	defb 0b5h
	defb 001h
	defb 0b6h
	defb 01ah
	defb 0b6h
	defb 033h
	defb 0b6h
	defb 00bh
	defb 011h
	defb 017h
	defb 004h
	defb 012h
	defb 00ah
	defb 001h
	defb 00ch
	defb 00dh
	defb 013h
	defb 007h
	defb 016h
	defb 009h
	defb 018h
	defb 00eh
	defb 015h
	defb 008h
	defb 014h
	defb 003h
	defb 000h
	defb 006h
	defb 002h
	defb 010h
	defb 005h
	defb 00fh
	defb 004h
	defb 012h
	defb 00fh
	defb 00bh
	defb 003h
	defb 008h
	defb 018h
	defb 017h
	defb 007h
	defb 013h
	defb 010h
	defb 005h
	defb 00ch
	defb 000h
	defb 00eh
	defb 015h
	defb 016h
	defb 011h
	defb 006h
	defb 00ah
	defb 001h
	defb 009h
	defb 00dh
	defb 014h
	defb 002h
	defb 007h
	defb 014h
	defb 00bh
	defb 010h
	defb 018h
	defb 012h
	defb 001h
	defb 006h
	defb 00ch
	defb 005h
	defb 008h
	defb 015h
	defb 00ah
	defb 011h
	defb 00dh
	defb 00eh
	defb 016h
	defb 002h
	defb 009h
	defb 000h
	defb 013h
	defb 00fh
	defb 017h
	defb 003h
	defb 004h
	defb 00fh
	defb 004h
	defb 008h
	defb 002h
	defb 00bh
	defb 000h
	defb 00dh
	defb 016h
	defb 00eh
	defb 013h
	defb 006h
	defb 00ch
	defb 007h
	defb 012h
	defb 015h
	defb 014h
	defb 017h
	defb 011h
	defb 018h
	defb 00ah
	defb 005h
	defb 010h
	defb 003h
	defb 009h
	defb 001h
lb64ch:
	defb 035h
	defb 035h
	defb 035h
	defb 035h
	defb 001h
	defb 002h
	defb 003h
	defb 004h
	defb 005h
	defb 006h
	defb 007h
	defb 008h
	defb 009h
	defb 00ah
	defb 00bh
	defb 00ch
	defb 00dh
	defb 00eh
	defb 00fh
	defb 010h
	defb 011h
	defb 012h
	defb 013h
	defb 00ch
	defb 014h
	defb 015h
	defb 016h
	defb 00ch
	defb 017h
	defb 018h
	defb 019h
	defb 01ah
	defb 01bh
	defb 00ah
	defb 016h
	defb 00ch
	defb 01ch
	defb 01dh
	defb 01eh
	defb 01fh
	defb 020h
	defb 024h
	defb 021h
	defb 025h
	defb 020h
	defb 026h
	defb 021h
	defb 027h
	defb 020h
	defb 028h
	defb 021h
	defb 029h
	defb 020h
	defb 02ah
	defb 021h
	defb 02bh
	defb 020h
	defb 02ch
	defb 021h
	defb 02dh
	defb 020h
	defb 02eh
	defb 021h
	defb 02fh
	defb 020h
	defb 030h
	defb 021h
	defb 025h
	defb 020h
	defb 031h
	defb 021h
	defb 032h
	defb 020h
	defb 033h
	defb 021h
	defb 025h
	defb 020h
	defb 024h
	defb 021h
	defb 034h
	defb 022h
	defb 024h
	defb 023h
	defb 025h
	defb 022h
	defb 026h
	defb 023h
	defb 027h
	defb 022h
	defb 028h
	defb 023h
	defb 029h
	defb 022h
	defb 02ah
	defb 023h
	defb 02bh
	defb 022h
	defb 02ch
	defb 023h
	defb 02dh
data_b548_end:
	ld a,(0e20ch)
	rla
	rla
	jp c,lb8a3h
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'disp_b6be' (start 0xb6be end 0xb6ca)
disp_b6be_start:
	defw 0b6cah
	defw 0b6f2h
	defw 0b701h
	defw 0b749h
	defw 0b85eh
	defw 0b89dh
disp_b6be_end:
	call 04e98h
	call 05d41h
	call 056aah
	call 057cah
	ld hl,0ef38h
	ld (hl),000h
	dec hl
	ld b,018h
lb6deh:
	ld a,b
	ld (hl),b
	dec hl
	djnz lb6deh
	call sub_b71eh
	ld hl,lb8afh
	call 051d0h
	inc (ix+001h)
	jp 0420dh
	ld a,(0e207h)
	and 010h
	ret z
	inc (ix+001h)
	ld hl,0b8beh
	jp 051d4h
	ld hl,lb5e0h
	ld a,(0e203h)
	and 003h
	call 04d4ch
	ld de,0ef20h
	ld bc,00019h
	ldir
	inc (ix+001h)
	xor a
	ld (ix+002h),a
	ld (ix+003h),a
sub_b71eh:
	ld hl,0ef20h
	ld bc,00505h
	ld de,05830h
lb727h:
	push bc
	ld b,c
	push de
lb72ah:
	push bc
	push de
	push hl
	ld a,(hl)
	call sub_b7ech
	pop hl
	inc hl
	pop de
	ld a,d
	add a,010h
	ld d,a
	pop bc
	djnz lb72ah
	pop de
	ld a,e
	add a,010h
	ld e,a
	pop bc
	djnz lb727h
	ld hl,lb5b8h
	jp 051d0h
	call sub_b8cfh
	ld a,(0e207h)
	rra
	jr c,lb76bh
	rra
	jr c,lb775h
	rra
	jr c,lb780h
	rra
	jr c,lb75fh
	rra
	jr c,lb78ah
	ret
lb75fh:
	ld a,(ix+003h)
	cp 004h
	ret nc
	inc (ix+003h)
lb768h:
	jp 042cbh
lb76bh:
	ld a,(ix+002h)
	and a
	ret z
	dec (ix+002h)
	jr lb768h
lb775h:
	ld a,(ix+002h)
	cp 004h
	ret nc
	inc (ix+002h)
	jr lb768h
lb780h:
	ld a,(ix+003h)
	and a
	ret z
	dec (ix+003h)
	jr lb768h
lb78ah:
	call sub_b7fah
	ret z
	push hl
	push bc
	call sub_b824h
	ld a,c
	pop bc
	pop de
	ld c,a
	and a
	ret z
	inc (ix+001h)
	xor a
	call sub_b7c5h
	ld a,c
	dec a
	call DISPATCH_A

; BLOCK 'disp_b7a5' (start 0xb7a5 end 0xb7ad)
disp_b7a5_start:
	defw 0b7b8h
	defw 0b7d2h
	defw 0b7e1h
	defw 0b7adh
disp_b7a5_end:
	ex de,hl
	ld (hl),000h
	inc hl
	ld (hl),b
	inc (ix+003h)
	ld a,b
	jr sub_b7c5h
	ex de,hl
	ld (hl),000h
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld (hl),b
	dec (ix+002h)
	ld a,b
sub_b7c5h:
	push de
	push bc
	push af
	call sub_b80fh
	pop af
	call sub_b7ech
	pop bc
	pop de
	ret
	ex de,hl
	ld (hl),000h
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld (hl),b
	inc (ix+002h)
	ld a,b
	jr sub_b7c5h
	ex de,hl
	ld (hl),000h
	dec hl
	ld (hl),b
	dec (ix+003h)
	ld a,b
	jr sub_b7c5h
sub_b7ech:
	add a,a
	add a,a
	ld hl,lb64ch
	call ADD_HL_A
	ld bc,00202h
	jp 05737h
sub_b7fah:
	ld d,(ix+002h)
	ld e,(ix+003h)
sub_b800h:
	ld a,d
	add a,a
	add a,a
	add a,d
	add a,e
	ld hl,0ef20h
	call ADD_HL_A
	ld a,(hl)
	ld b,a
	and a
	ret
sub_b80fh:
	ld a,(ix+002h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,030h
	ld e,a
	ld a,(ix+003h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,058h
	ld d,a
	ret
sub_b824h:
	ld d,(ix+002h)
	ld e,(ix+003h)
	ld c,001h
	ld a,d
	and a
	jr z,lb837h
	push de
	dec d
	call sub_b800h
	pop de
	ret z
lb837h:
	inc c
	ld a,d
	cp 004h
	jr nc,lb844h
	push de
	inc d
	call sub_b800h
	pop de
	ret z
lb844h:
	inc c
	ld a,e
	and a
	jr z,lb850h
	push de
	dec e
	call sub_b800h
	pop de
	ret z
lb850h:
	inc c
	ld a,e
	cp 004h
	jr nc,lb85bh
	inc e
	call sub_b800h
	ret z
lb85bh:
	ld c,000h
	ret
	ld de,0ef20h
	ld hl,0ef21h
	ld a,(de)
	cp 001h
	jr nz,lb876h
lb869h:
	ld a,(de)
	inc a
	cp (hl)
	jr nz,lb876h
	cp 018h
	jr z,lb87ah
	inc de
	inc hl
	jr lb869h
lb876h:
	dec (ix+001h)
	ret
lb87ah:
	call 05d41h
	inc (ix+001h)
	ld a,(0e240h)
	add a,003h
	cp 099h
	jr nc,lb88ch
	daa
	jr lb88eh
lb88ch:
	ld a,099h
lb88eh:
	ld (0e240h),a
	ld hl,lb8afh
	call 051d4h
	ld hl,lb5c7h
	jp 051d0h
	ld a,(0e207h)
	and 010h
	ret z
lb8a3h:
	ld bc,00007h
	ld (ix+000h),b
	call 00047h
	jp 041e0h
lb8afh:
	ld d,b
	and b
	push hl
	xor 0e4h
	nop
	nop
	push hl
	di
	ex (sp),hl
	nop
	ex de,hl
	push hl
	ld sp,hl
	cp 048h
	sub b
	ret p
	push af
	di
	ret pe
	nop
	di
	ret p
	pop hl
	ex (sp),hl
	push hl
	nop
	ex de,hl
	push hl
	ld sp,hl
	rst 38h
sub_b8cfh:
	ld hl,0e800h
	ld de,lb913h
	ld bc,00400h
	exx
	ld hl,0d200h
	exx
lb8ddh:
	push bc
	ld a,(ix+002h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,034h
	ld c,a
	ld a,b
	cp 003h
	jr nc,lb8f1h
	ld a,c
	add a,010h
	ld c,a
lb8f1h:
	ld (hl),c
	inc hl
	ld a,(ix+003h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,05ch
	ld (hl),a
	pop bc
	inc hl
	ld (hl),c
	ld a,c
	add a,004h
	ld c,a
	inc hl
	inc hl
	ld a,(de)
	inc de
	exx
	ld b,010h
lb90bh:
	ld (hl),a
	inc hl
	djnz lb90bh
	exx
	djnz lb8ddh
	ret
lb913h:
	dec c
	ld c,(hl)
	dec c
	ld c,(hl)
lb917h:
	ld a,(ix+001h)
	cp 001h
	jr z,lb938h
	jr nc,lb981h
	call 04e98h
	call 057ach
	call 057cah
	call 0578dh
	call 05d41h
	inc (ix+001h)
	ld hl,lb585h
	jp 051d0h
lb938h:
	call disp_b98a_end
	ld a,(0e207h)
	rra
	rra
	rra
	jr c,lb95ah
	rra
	jr c,lb96ah
	rra
	jr c,lb97bh
	ld a,(0e20ch)
	rla
	ret nc
	ld bc,00007h
	ld (ix+000h),b
	call 00047h
	jp 041e0h
lb95ah:
	call 042cbh
	dec (ix+002h)
	ld a,(ix+002h)
	rla
	ret nc
	ld (ix+002h),012h
	ret
lb96ah:
	call 042cbh
	inc (ix+002h)
	ld a,(ix+002h)
	cp 013h
	ret c
	ld (ix+002h),000h
	ret
lb97bh:
	inc (ix+001h)
	jp 041e0h
lb981h:
	dec (ix+001h)
	ld a,(ix+002h)
	call DISPATCH_A

; BLOCK 'disp_b98a' (start 0xb98a end 0xb9b0)
disp_b98a_start:
	defw 041eah
	defw 041f4h
	defw 041f9h
	defw 041feh
	defw 04203h
	defw 04208h
	defw 0420dh
	defw 04212h
	defw 04217h
	defw 0421ch
	defw 04221h
	defw 04226h
	defw 0422bh
	defw 04230h
	defw 04235h
	defw 04249h
	defw 0429eh
	defw 042a3h
	defw 0426ch
disp_b98a_end:
	ld hl,0e800h
	ld de,0ba0dh
	ld bc,00400h
	exx
	ld hl,0d200h
	exx
lb9beh:
	push bc
	ld a,(ix+002h)
	exx
	ld de,lb9fah
	add a,e
	ld e,a
	jr nc,lb9cbh
	inc d
lb9cbh:
	ld a,(de)
	exx
	push af
	rra
	ld c,078h
	jr nc,lb9d5h
	ld c,060h
lb9d5h:
	ld a,b
	cp 003h
	jr nc,lb9deh
	ld a,c
	add a,010h
	ld c,a
lb9deh:
	ld (hl),c
	pop af
	inc hl
	and 0feh
	ld (hl),a
	pop bc
	inc hl
	ld (hl),c
	ld a,c
	add a,004h
	ld c,a
	inc hl
	inc hl
	ld a,(de)
	inc de
	exx
	ld b,010h
lb9f2h:
	ld (hl),a
	inc hl
	djnz lb9f2h
	exx
	djnz lb9beh
	ret
lb9fah:
	inc l
	inc sp
	inc a
	ld b,l
	ld c,h
	ld d,l
	ld e,h
	ld l,h
	ld (hl),e
	ld a,h
	add a,l
	adc a,h
	sbc a,h
	and e
	xor h
	or l
	cp h
	push bc
	call z,04e0dh
	dec c
	ld c,(hl)
	ld hl,001ffh
	ld (0e209h),hl
	ld hl,0e219h
	ld a,(hl)
	ld de,0ba3ah
	call ADD_DE_A
	ld a,(de)
	ld (0e242h),a
	inc (hl)
	ld a,(hl)
	cp 007h
	jr c,lba2dh
	ld (hl),001h
lba2dh:
	xor a
	ld (0e203h),a
	inc a
	ld (0e246h),a
	call 04360h
	jp 04388h
	ld (bc),a
	ld (de),a
	ld a,(de)
	jr z,$+50
	dec (hl)
	ld a,(0e248h)
	and a
	jr nz,lba57h
	call 04358h
	ld a,(0e280h)
	cp 005h
	ret nz
lba50h:
	xor a
	ld (0e246h),a
	jp 041e0h
lba57h:
	xor a
	ld (0e24dh),a
	call 05dfeh
	ld a,(0e24dh)
	and a
	ret nz
	jp 04369h
	ld hl,0e20ah
	dec (hl)
	jr nz,lba7ah
	dec hl
	inc (hl)
	inc hl
	call sub_ba80h
	cp 0ffh
	jr z,lba50h
	ld hl,0e20ah
	ld (hl),c
lba7ah:
	call sub_ba80h
	jp 05434h
sub_ba80h:
	dec hl
	ld c,(hl)
	ld a,(0e241h)
	ld hl,ba92_tbl_start
	call 04d4ch
	ld a,c
	add a,a
	call ADD_HL_A
	ld c,(hl)
	inc hl

; BLOCK 'ba92_tbl' (start 0xba92 end 0xbaa0)
ba92_tbl_start:
	defw 0c97eh
	defw 0baa0h
	defw 0bad6h
	defw 0bb14h
	defw 0bb5ah
	defw 0bbbah
	defw 0bc16h
ba92_tbl_end:

; BLOCK 'ba_lists' (start 0xbaa0 end 0xbc6e)
ba_lists_start:
	defb 02eh
	defb 000h
	defb 00fh
	defb 008h
	defb 010h
	defb 000h
	defb 00dh
	defb 004h
	defb 011h
	defb 000h
	defb 037h
	defb 008h
	defb 01bh
	defb 000h
	defb 019h
	defb 008h
	defb 011h
	defb 000h
	defb 010h
	defb 008h
	defb 00dh
	defb 000h
	defb 043h
	defb 008h
	defb 00ch
	defb 000h
	defb 058h
	defb 004h
	defb 013h
	defb 000h
	defb 003h
	defb 008h
	defb 008h
	defb 000h
	defb 009h
	defb 010h
	defb 012h
	defb 000h
	defb 039h
	defb 008h
	defb 015h
	defb 000h
	defb 01fh
	defb 004h
	defb 047h
	defb 000h
	defb 010h
	defb 004h
	defb 00eh
	defb 000h
	defb 009h
	defb 008h
	defb 000h
	defb 0ffh
	defb 029h
	defb 000h
	defb 090h
	defb 004h
	defb 01bh
	defb 000h
	defb 0adh
	defb 008h
	defb 01ah
	defb 000h
	defb 003h
	defb 008h
	defb 00bh
	defb 000h
	defb 018h
	defb 001h
	defb 00ah
	defb 000h
	defb 019h
	defb 008h
	defb 008h
	defb 000h
	defb 023h
	defb 001h
	defb 006h
	defb 000h
	defb 004h
	defb 004h
	defb 00dh
	defb 000h
	defb 00dh
	defb 010h
	defb 033h
	defb 000h
	defb 00eh
	defb 008h
	defb 00ah
	defb 000h
	defb 01eh
	defb 004h
	defb 008h
	defb 000h
	defb 017h
	defb 001h
	defb 004h
	defb 000h
	defb 00dh
	defb 004h
	defb 00dh
	defb 000h
	defb 01eh
	defb 010h
	defb 02fh
	defb 000h
	defb 06ch
	defb 004h
	defb 042h
	defb 000h
	defb 030h
	defb 004h
	defb 000h
	defb 0ffh
	defb 036h
	defb 000h
	defb 02dh
	defb 004h
	defb 008h
	defb 014h
	defb 01ah
	defb 004h
	defb 010h
	defb 000h
	defb 02dh
	defb 008h
	defb 002h
	defb 009h
	defb 033h
	defb 001h
	defb 001h
	defb 009h
	defb 072h
	defb 008h
	defb 014h
	defb 000h
	defb 032h
	defb 002h
	defb 011h
	defb 000h
	defb 01ah
	defb 008h
	defb 00ah
	defb 018h
	defb 01eh
	defb 008h
	defb 006h
	defb 000h
	defb 032h
	defb 004h
	defb 007h
	defb 000h
	defb 008h
	defb 008h
	defb 00dh
	defb 000h
	defb 008h
	defb 010h
	defb 037h
	defb 000h
	defb 051h
	defb 008h
	defb 002h
	defb 009h
	defb 024h
	defb 001h
	defb 008h
	defb 000h
	defb 012h
	defb 008h
	defb 002h
	defb 018h
	defb 016h
	defb 008h
	defb 001h
	defb 009h
	defb 028h
	defb 001h
	defb 001h
	defb 005h
	defb 0a0h
	defb 004h
	defb 000h
	defb 0ffh
	defb 041h
	defb 000h
	defb 040h
	defb 004h
	defb 001h
	defb 000h
	defb 0a4h
	defb 008h
	defb 002h
	defb 00ah
	defb 015h
	defb 002h
	defb 006h
	defb 000h
	defb 01eh
	defb 004h
	defb 001h
	defb 006h
	defb 00bh
	defb 002h
	defb 001h
	defb 006h
	defb 00fh
	defb 004h
	defb 001h
	defb 006h
	defb 00ch
	defb 002h
	defb 001h
	defb 006h
	defb 00fh
	defb 004h
	defb 001h
	defb 006h
	defb 00ch
	defb 002h
	defb 002h
	defb 006h
	defb 00eh
	defb 004h
	defb 001h
	defb 006h
	defb 00bh
	defb 002h
	defb 002h
	defb 006h
	defb 015h
	defb 004h
	defb 001h
	defb 006h
	defb 00eh
	defb 002h
	defb 001h
	defb 006h
	defb 016h
	defb 004h
	defb 00fh
	defb 000h
	defb 013h
	defb 004h
	defb 007h
	defb 000h
	defb 001h
	defb 004h
	defb 003h
	defb 000h
	defb 002h
	defb 004h
	defb 01fh
	defb 000h
	defb 01eh
	defb 004h
	defb 01dh
	defb 000h
	defb 005h
	defb 004h
	defb 009h
	defb 014h
	defb 001h
	defb 004h
	defb 00eh
	defb 000h
	defb 006h
	defb 014h
	defb 05eh
	defb 004h
	defb 013h
	defb 000h
	defb 037h
	defb 008h
	defb 002h
	defb 018h
	defb 012h
	defb 010h
	defb 000h
	defb 0ffh
	defb 036h
	defb 000h
	defb 051h
	defb 004h
	defb 033h
	defb 000h
	defb 006h
	defb 010h
	defb 02eh
	defb 000h
	defb 084h
	defb 004h
	defb 00dh
	defb 000h
	defb 007h
	defb 010h
	defb 012h
	defb 000h
	defb 00eh
	defb 008h
	defb 009h
	defb 000h
	defb 019h
	defb 001h
	defb 00ch
	defb 008h
	defb 018h
	defb 001h
	defb 005h
	defb 000h
	defb 008h
	defb 004h
	defb 001h
	defb 005h
	defb 014h
	defb 001h
	defb 002h
	defb 000h
	defb 008h
	defb 008h
	defb 001h
	defb 000h
	defb 015h
	defb 001h
	defb 032h
	defb 004h
	defb 00ah
	defb 000h
	defb 019h
	defb 004h
	defb 007h
	defb 000h
	defb 00dh
	defb 010h
	defb 022h
	defb 000h
	defb 012h
	defb 004h
	defb 00eh
	defb 000h
	defb 012h
	defb 004h
	defb 004h
	defb 014h
	defb 00dh
	defb 004h
	defb 004h
	defb 014h
	defb 007h
	defb 004h
	defb 00fh
	defb 000h
	defb 00fh
	defb 008h
	defb 007h
	defb 018h
	defb 00dh
	defb 008h
	defb 01dh
	defb 000h
	defb 015h
	defb 008h
	defb 043h
	defb 000h
	defb 00fh
	defb 004h
	defb 001h
	defb 000h
	defb 025h
	defb 008h
	defb 000h
	defb 0ffh
	defb 040h
	defb 000h
	defb 032h
	defb 008h
	defb 004h
	defb 000h
	defb 013h
	defb 004h
	defb 00ah
	defb 000h
	defb 04dh
	defb 002h
	defb 003h
	defb 000h
	defb 009h
	defb 004h
	defb 00bh
	defb 000h
	defb 026h
	defb 004h
	defb 00bh
	defb 014h
	defb 01bh
	defb 004h
	defb 006h
	defb 014h
	defb 010h
	defb 004h
	defb 005h
	defb 014h
	defb 00dh
	defb 004h
	defb 01dh
	defb 000h
	defb 008h
	defb 004h
	defb 004h
	defb 014h
	defb 028h
	defb 004h
	defb 007h
	defb 014h
	defb 013h
	defb 004h
	defb 028h
	defb 000h
	defb 045h
	defb 004h
	defb 00eh
	defb 000h
	defb 004h
	defb 004h
	defb 00eh
	defb 000h
	defb 01dh
	defb 004h
	defb 00bh
	defb 000h
	defb 014h
	defb 010h
	defb 01ch
	defb 000h
	defb 029h
	defb 004h
	defb 005h
	defb 014h
	defb 00bh
	defb 004h
	defb 005h
	defb 014h
	defb 019h
	defb 004h
	defb 003h
	defb 014h
	defb 022h
	defb 004h
	defb 006h
	defb 014h
	defb 005h
	defb 004h
	defb 033h
	defb 000h
	defb 00bh
	defb 018h
	defb 008h
	defb 008h
	defb 000h
	defb 0ffh
ba_lists_end:
	xor a
	ld hl,0e910h
	ld de,0e911h
	ld (hl),a
	ld bc,001ffh
	ldir
	ld (0e901h),a
	ld (0e902h),a
	inc a
	ld (0e900h),a
	ret
sub_bc86h:
	ld a,(0e902h)
	or a
	ret nz
	ld hl,0e900h
	dec (hl)
	ret nz
	ld (hl),002h
	ld ix,0e910h
	ld b,020h
lbc98h:
	ld a,(ix+000h)
	or a
	jr z,lbca6h
	ld de,00010h
	add ix,de
	djnz lbc98h
	ret
lbca6h:
	xor a
	ld (ix+000h),001h
	ld (ix+001h),a
	ld (ix+002h),070h
	ld (ix+003h),a
	ld (ix+004h),080h
	ld hl,0e901h
	inc (hl)
	ld a,(hl)
	and 00fh
	ld b,008h
	call sub_bd74h
	ld (ix+005h),l
	ld (ix+006h),h
	ld (ix+007h),e
	ld (ix+008h),d
	ret
	call sub_bc86h
	call sub_bd30h
	call sub_bcddh
	jr lbd4bh
sub_bcddh:
	ld ix,0e910h
	ld b,020h
lbce3h:
	ld a,(ix+000h)
	or a
	push bc
	call nz,sub_bcf4h
	pop bc
	ld de,00010h
	add ix,de
	djnz lbce3h
	ret
sub_bcf4h:
	ld e,(ix+001h)
	ld d,(ix+002h)
	ld l,(ix+005h)
	ld h,(ix+006h)
	add hl,de
	ld (ix+001h),l
	ld (ix+002h),h
	ld e,(ix+003h)
	ld d,(ix+004h)
	ld l,(ix+007h)
	ld h,(ix+008h)
	add hl,de
	ld (ix+003h),l
	ld (ix+004h),h
	ld a,(ix+002h)
	add a,010h
	cp 020h
	jr c,lbd2bh
	ld a,(ix+004h)
	add a,010h
	cp 020h
	ret nc
lbd2bh:
	ld (ix+000h),000h
	ret
sub_bd30h:
	ld hl,0e800h
	ld de,0e801h
	ld (hl),0e0h
	ld bc,0007fh
	ldir
	ld hl,0d200h
	ld de,0d201h
	ld (hl),005h
	ld bc,00400h
	ldir
	ret
lbd4bh:
	ld ix,0e910h
	ld hl,0e800h
	ld b,020h
lbd54h:
	ld a,(ix+000h)
	or a
	push bc
	call nz,sub_bd65h
	pop bc
	ld de,00010h
	add ix,de
	djnz lbd54h
	ret
sub_bd65h:
	ld a,(ix+002h)
	ld (hl),a
	inc hl
	ld a,(ix+004h)
	ld (hl),a
	inc hl
	ld (hl),0d0h
	inc hl
	inc hl
	ret
sub_bd74h:
	push af
	ld hl,bd97_tbl_end
	call 04d4ch
	ld e,l
	ld d,h
	ld hl,00000h
	push bc
lbd81h:
	add hl,de
	djnz lbd81h
	pop bc
	pop af
	push hl
	ld hl,bd97_tbl_start
	call 04d4ch
	ld e,l
	ld d,h
	ld hl,00000h
lbd92h:
	add hl,de
	djnz lbd92h
	pop de
	ret

; BLOCK 'bd97_tbl' (start 0xbd97 end 0xbdb7)
bd97_tbl_start:
	defw 00000h
	defw 0ff23h
	defw 00080h
	defw 0ff4bh
	defw 0ff80h
	defw 00100h
	defw 00080h
	defw 0ff23h
	defw 000ddh
	defw 0ff4bh
	defw 0ff80h
	defw 00000h
	defw 000b5h
	defw 0ff00h
	defw 000b5h
	defw 000ddh
bd97_tbl_end:

; BLOCK 'bdb7_tbl' (start 0xbdb7 end 0xbdd7)
bdb7_tbl_start:
	defw 00100h
	defw 0ff80h
	defw 0ff23h
	defw 000b5h
	defw 0ff23h
	defw 00000h
	defw 000ddh
	defw 00080h
	defw 0ff80h
	defw 0ff4bh
	defw 000ddh
	defw 0ff00h
	defw 000b5h
	defw 00000h
	defw 0ff4bh
	defw 00080h
bdb7_tbl_end:
	call sub_bdf7h
	ld hl,0e830h
	ld a,(0edcbh)
	ld (hl),a
	inc hl
	ld a,(0edcch)
	ld (hl),a
	inc hl
	ld (hl),0d0h
	ld hl,0d2c0h
	ld de,0d2c1h
	ld bc,0000fh
	ld (hl),007h
	ldir
	ret
sub_bdf7h:
	ld a,(0edd8h)
	or a
	ld a,004h
	jr z,lbe01h
	ld a,034h
lbe01h:
	ld hl,0e800h
	ld de,0a868h
	call sub_be18h
	ld de,0a878h
	call sub_be18h
	ld de,0a888h
	call sub_be18h
	jr lbe35h
sub_be18h:
	ld b,002h
lbe1ah:
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (hl),a
	inc hl
	inc hl
	add a,004h
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (hl),a
	inc hl
	inc hl
	push af
	ld a,d
	add a,010h
	ld d,a
	pop af
	add a,004h
	djnz lbe1ah
	ret
lbe35h:
	ld hl,0d200h
	ld de,0d201h
	ld bc,0000fh
	ld (hl),00dh
	ldir
	call sub_be5dh
	call sub_be54h
	call sub_be54h
	call sub_be54h
	call sub_be54h
	call sub_be54h
sub_be54h:
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),00dh
	ldir
sub_be5dh:
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),04eh
	ldir
	ret
lbe67h:
	ld c,b
	ld (hl),b
	di
	ex de,hl
	jp (hl)
	ret p
	rst 38h
lbe6eh:
	ld c,b
	ld (hl),b
	and 0e9h
	xor 0e4h
	rst 38h
lbe75h:
	ld hl,lbe67h
	call 051d0h
	call sub_bef3h
	call 000e1h
	jp c,lbefch
lbe84h:
	ld c,010h
lbe86h:
	exx
	call 000e4h
	exx
	jp c,lbefch
	cp 0aah
	jr nz,lbe84h
	dec c
	jr nz,lbe86h
	ld hl,0ee50h
	ld bc,00008h
	call 0bf1bh
	jr c,lbefch
	call 000f0h
	ld hl,0ee50h
	ld de,0e270h
	ld b,008h
lbeabh:
	ld a,(de)
	cp (hl)
	jr nz,lbe75h
	inc de
	inc hl
	djnz lbeabh
	ld hl,lbe6eh
	call 051d0h
	call sub_bef3h
	call 000e1h
	jr c,lbefch
	ld ix,06c6dh
	ld d,000h
	ld b,006h
lbec9h:
	push bc
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld c,(ix+002h)
	ld b,(ix+003h)
	call 0bf1bh
	pop bc
	jr c,lbefch
	inc ix
	inc ix
	inc ix
	inc ix
	djnz lbec9h
	exx
	call 000e4h
	exx
	jr c,lbefch
	cp d
	jr nz,lbefch
	jp 000f0h
sub_bef3h:
	ld hl,0ee50h
	ld de,07070h
	jp 08a1ah
lbefch:
	call 000f0h
	call 04e98h
	ld hl,lbf0eh
	call 051d0h
	ld a,002h
	ld (0e27fh),a
	ret
lbf0eh:
	ld d,b
	ld h,b
	call pe,0e1efh
	call po,0e500h
	jp p,0eff2h
	jp p,0d9ffh
	call 000e4h
	exx
	ret c
	ld (hl),a
	add a,d
	ld d,a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,$-13
	ret
	ld a,0ffh
	call 000eah
	jp c,lbf82h
	ld b,010h
lbf35h:
	ld a,0aah
	exx
	call 000edh
	exx
	jr c,lbf82h
	djnz lbf35h
	ld hl,0e270h
	ld bc,00008h
	call 0bfa1h
	jr c,lbf82h
	call 000f0h
	xor a
	call 000eah
	jr c,lbf82h
	ld ix,06c6dh
	ld d,000h
	ld b,006h
lbf5ch:
	push bc
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld c,(ix+002h)
	ld b,(ix+003h)
	call 0bfa1h
	pop bc
	jr c,lbf82h
	inc ix
	inc ix
	inc ix
	inc ix
	djnz lbf5ch
	ld a,d
	call 000edh
	jr c,lbf82h
	jp 000f0h
lbf82h:
	call 000f0h
	call 04e98h
	ld hl,lbf94h
	call 051d0h
	ld a,002h
	ld (0e27fh),a
	ret
lbf94h:
	ld d,b
	ld h,b
	di
	pop hl
	or 0e5h
	nop
	push hl
	jp p,0eff2h
	jp p,07effh
	ld e,a
	inc hl
	exx
	call 000edh
	exx
	ret c
	ld a,e
	add a,d
	ld d,a
	dec bc
	ld a,b
	or c
	jr nz,$-15
	ret

	ds 77, 0ffh
