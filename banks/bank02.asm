; ===========================================================================
;  bank 02 — 8 KiB mapper bank, assembled at CPU 0x8000 (PHASE in master).
;  Boot triplet with banks 1/3 via page_banks_123. Byte 0 continues
;  ld hl,0E2F3h from bank 1 @ 0x7FFE. l8016h is jr z from 0x7FFC.
;  Regen: tools/workbench/msx/regen-bank.sh 2 0x8000 banks/bank02.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
; BLOCK 'ldhl_tail' (start 0x8000 end 0x8001)
ldhl_tail_start:
	defb 0e2h                 ; high byte of ld hl,0E2F3h from 0x7FFE
ldhl_tail_end:
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
	cp 007h
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
	defw 08266h
	defw 0827fh
	defw 0829ch
	defw 0bdc0h
	defw 09652h
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
	cp 007h
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
	defw 08320h
	defw 0834dh
	defw 08320h
	defw 08351h
	defw 08346h
	defw 0833ch
	defw 08341h
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
	ld a,(0e261h)
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
	ld hl,0be44h
	call 051d0h
	ld hl,0be4ch
	call 051d0h
	ld hl,0be54h
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	call 051d0h
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
	ld hl,0b8f8h
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
	ld hl,0b9adh
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
	jp 0573bh
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
	ld hl,0b844h
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
	ld a,00eh
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
l9652h:
	ld hl,l9370h
	ld d,(ix+003h)
	ld e,(ix+002h)
	ld bc,00202h
	jp 0573bh
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
	jp 0573bh
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
	call 051d0h
	ld hl,0af60h
	call 051d0h
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
	call sub_97bbh
	jp page_banks_123
sub_97bbh:
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
sub_97d4h:
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
l9a93h:
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
	ld (0e280h),a
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
	call sub_9ecah
	jp 0a67ch
sub_9ecah:
	ld a,(0e280h)
	call DISPATCH_A

; BLOCK 'd_9ecd_jp' (start 0x9ed0 end 0x9eee)
d_9ecd_jp_start:
	defw 09eeeh
	defw 0a190h
	defw 0a20fh
	defw 0a2f0h
	defw 0a315h
	defw 0a31ch
	defw 0a350h
	defw 0a36ch
	defw 0a384h
	defw 0a384h
	defw 0a405h
	defw 0a40fh
	defw 0a419h
	defw 0a423h
	defw 0a43ch
d_9ecd_jp_end:
	call 0a624h
	call 0a4efh
	call sub_9f4dh
	call 0a512h
	jr nz,l9f02h
	call 0a45eh
	jp nz,l9fd4h
l9f02h:
	call 0a045h
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
	jp nz,0a008h
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
