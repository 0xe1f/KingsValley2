; ===========================================================================
;  bank 03 — 8 KiB mapper bank, assembled at CPU 0xA000 (PHASE in master).
;  Boot triplet with banks 1/2 via page_banks_123. Trailing 0xFF pad @ 0xBEE5.
;  Regen: tools/workbench/msx/regen-bank.sh 3 0xA000 banks/bank03.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	ld a,003h
	ld (0e280h),a
	jp 042f3h
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
	defw 0a081h
	defw 0a081h
	defw 0a0a6h
	defw 0a0a6h
	defw 0a0f0h
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
	ld de,00a06h
	ld c,004h
	jr la321h
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
	jp 09f19h
la368h:
	ld (0e280h),a
	ret
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
	jp 09f19h
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
	ld a,(0e286h)
	and 003h
	call z,04244h
	jr la42bh
	ld a,(0e286h)
	and 003h
	call z,0424eh
	jr la42bh
	ld a,(0e286h)
	and 003h
	call z,04253h
	jr la42bh
	ld a,(0e286h)
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
	ld hl,0e2a8h
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
	ld (0e280h),a
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
	defw 0a6ech
	defw 0a89bh
	defw 0aa66h
	defw 0ab09h
	defw 0ab5dh
	defw 0abf5h
d_a6dd_jp_end:
	call sub_ac63h
	sub 001h
	ret c
	call DISPATCH_A

; BLOCK 'd_a6f2_jp' (start 0xa6f5 end 0xa6ff)
d_a6f2_jp_start:
	defw 0a6ffh
	defw 0a706h
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
	defw 0a6ffh
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
	defw 0a6ffh
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
	defw 0a6ffh
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
	defw 0a6ffh
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
	defw 0a6ffh
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
	call 0573bh
	push ix
	call 090f7h
	call 096cfh
	pop ix
	ret
	ld a,(ix+001h)
	call DISPATCH_A

; BLOCK 'd_ad83_jp' (start 0xad86 end 0xad90)
d_ad83_jp_start:
	defw 0ae35h
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
	defw 0ae35h
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
	defw 0b2bah
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
	defw 0b6a0h
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
	ld a,(ix+001h)
	cp 001h
	jp z,lbb0eh
	jp nc,lbb2bh
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
	ld a,(ix+001h)
	and a
	jr nz,lbc2fh
	ld a,(0e243h)
	cp (ix+004h)
	ret nz
	ld a,(0e280h)
	and a
	jr nz,lbc10h
	ld a,(ix+008h)
	add a,a
	add a,a
	add a,a
	ld b,a
	ld a,(0e282h)
	add a,00fh
	sub (ix+002h)
	sub b
	jr nc,lbc10h
	ld a,(ix+007h)
	rra
	rra
	ld a,(0e284h)
	ld b,(ix+003h)
	jr c,lbc15h
	cp b
	jr nc,lbc10h
	add a,014h
	sub b
	jr c,lbc10h
	ld a,(0e208h)
	and 008h
	jr z,lbc10h
	dec (ix+006h)
	ret nz
	ld a,007h
	ld (0e280h),a
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
	and 004h
	jr z,lbc10h
	dec (ix+006h)
	ret nz
	ld a,006h
	ld (0e280h),a
	jr lbbfah
lbc2fh:
	dec (ix+006h)
	ret nz
	set 0,(ix+007h)
	inc (ix+005h)
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
	jr nz,lbc81h
	call sub_bc9ch
	jr nc,lbc81h
	inc (ix+001h)
	ld (ix+006h),01eh
	ret
sub_bc9ch:
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
	ld c,a
	ld a,(0e282h)
	sub (ix+002h)
	cp c
	ret
lbcbeh:
	or a
	ret
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
	ld (ix+000h),000h
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
	call 0573bh
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
	xor a
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
	ld hl,0e7c0h
	ld b,010h
lbe1ah:
	ld a,(0e243h)
	cp (hl)
	push bc
	push hl
	call z,sub_be2dh
	pop hl
	ld a,004h
	call ADD_HL_A
	pop bc
	djnz lbe1ah
	ret
sub_be2dh:
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
	and 020h
	ret z
	res 5,(hl)
	ld a,(hl)
	and 0c0h
	rlca
	rlca
	dec a
	jr z,lbe76h
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
	cp 002h
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
