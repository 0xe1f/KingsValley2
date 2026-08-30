; ===========================================================================
;  bank 0 — 8 KiB mapper bank, assembled at CPU 0x4000 (PHASE in master).
;  Konami SCC: page 4000-5FFF is switchable in hardware; this dump has no
;  ld (5000h),a, so this bank is likely left mapped. Not a multi-bank window.
;  Regen: tools/workbench/msx/regen-bank.sh 0 0x4000 banks/banks_0.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)

; --- 16-byte MSX cartridge header (ROM offset 0) ---------------------------
rom_header:
	defb 041h, 042h         ; "AB"
	defb 0a3h, 040h         ; init = 0x40A3
	defb 000h, 000h         ; STATEMENT
	defb 000h, 000h         ; DEVICE
	defb 000h, 000h         ; TEXT
	defb 000h, 000h, 000h, 000h, 000h, 000h

; Game Master relative option table. Not executed; H.TIMI is JP 0x402E.
; BLOCK 'gm_opt' (start 0x4010 end 0x402e)
gm_opt_start:
	defb 043h, 044h         ; "CD"
	defb 007h, 061h         ; RC761 BCD
	defb 0e0h, 000h         ; option flags
	defb 0e2h, 004h, 042h
	defb 0e2h, 03ch, 040h
	defb 0e2h, 023h, 0e2h
	defb 026h, 0e2h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h
	defb 081h, 001h, 001h, 000h, 080h
	defb 0f6h
gm_opt_end:
htimi_isr:
	di                      ; H.TIMI -> 0x402E
	ld hl,0e215h
	ld a,(hl)
	cp 002h
	jr c,l403eh
	inc hl
	ld a,(hl)
	and a
	jr nz,l403eh
l403ch:
	dec hl
	dec (hl)
l403eh:
	ld hl,0e21ah
	ld a,(hl)
	and a
	jr z,l4049h
	dec a
	jr z,l4049h
	dec (hl)
l4049h:
	ld hl,0e206h
	ld a,(hl)
	and a
	ld (hl),001h
	jp nz,l408dh
	ld a,004h
	ld (07000h),a
	inc a
	ld (09000h),a
	inc a
	ld (0b000h),a
	call 06006h             ; tick_entry (bank 04)
	xor a
	ld (0e206h),a
	di
	ld a,(0f0f1h)
	ld (07000h),a
	ld a,(0f0f2h)
	ld (09000h),a
	ld a,(0f0f3h)
	ld (0b000h),a
	ld hl,0e205h
	ld a,(hl)
	and a
	jr nz,l408dh
	inc (hl)
	ei
	call poll_keys
	call mode_frame
	xor a
	ld (0e205h),a
l408dh:
	ei
	ret
ADD_HL_A:                       ; 0x408F
	add a,l
	ld l,a
	ret nc
	inc h
	ret
ADD_DE_A:                       ; 0x4094
	add a,e
	ld e,a
	ret nc
	inc d
	ret
DISPATCH_A:                     ; 0x4099  inline word table follows each call
	pop hl
	add a,a
	call ADD_HL_A
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
cart_init:                      ; AB header init @ 0x40A3
	di
	call sub_4146h          ; slot id -> A
	di
	ld h,a
	ld l,0f7h               ; RST 30h
	ld (0fedah),hl          ; H.STKE: RST 30 / slot
	ld hl,cart_boot
	ld (0fedch),hl          ; H.STKE+2: continue here after BIOS returns
	ret
cart_boot:                      ; was l40b5h
	di
	im 1
	ld sp,0e000h
	ld a,(0ffa7h)           ; H.PHYD
	cp 0c9h
	call nz,sub_4162h       ; disk ROM present
	ld a,0c9h               ; RET
	ld (0fd9ah),a           ; H.KEYI disabled
	call sub_4126h
	call sub_4146h
	ld a,001h
	ld (0f0f4h),a
	ld (0f0f5h),a
	xor a
	ld hl,0e000h
	ld de,0e001h
	ld bc,00fffh
	ld (hl),a
	ldir
	ld hl,0d200h
	ld de,0d201h
	ld bc,001ffh
	ld (hl),a
	ldir
	ld a,001h
	ld (0e219h),a
	xor a
	ld (0f3eah),a
	ld (0f3ebh),a
	ld hl,0f0f1h
	ld a,001h
	ld (07000h),a           ; page_triplet A=1 → banks 01/2/3
	ld (hl),a
	inc a
	ld (09000h),a
	inc hl
	ld (hl),a
	inc a
	ld (0b000h),a
	inc hl
	ld (hl),a
	call sub_53b6h
	di
	ld a,0c3h               ; JP
	ld (0fd9fh),a           ; H.TIMI
	ld hl,htimi_isr         ; 0x402E
	ld (0fda0h),hl
	xor a
	ld (0f3dbh),a
	ei
l4124h:
	jr l4124h
sub_4126h:
	call 00138h
	rrca
	rrca
	and 003h
	ld c,a
	ld b,000h
	ld hl,0fcc1h
	add hl,bc
	ld a,(hl)
	and 080h
	or c
	ld c,a
	inc hl
	inc hl
	inc hl
	inc hl
	ld a,(hl)
	and 00ch
	or c
	ld h,080h
	jp 00024h
sub_4146h:
	call 00138h
	rrca
	rrca
	and 003h
	ld c,a
	ld b,000h
	ld hl,0fcc1h
	add hl,bc
	or (hl)
	ld c,a
	inc hl
	inc hl
	inc hl
	inc hl
	ld a,(hl)
	and 00ch
	or c
	ld (0f0e9h),a
	ret
sub_4162h:
	ld hl,0972ch
	ld (0f323h),hl
	ld hl,0e280h
	ld bc,01100h
	ld de,0c000h
	ldir
	ld hl,0f100h
	ld de,0d780h
	ld bc,00280h
	ldir
	ld hl,0fd9fh
	ld de,0f0eah
	ld bc,00005h
	ldir
	ret
; Page consecutive banks A, A+1, A+2 into 6000/8000/A000 (SCC 7000/9000/B000)
; and mirror them at mapper_bank_6000/8000/A000 (0xF0F1-F0F3).
page_banks_123:                 ; 0x418A
	push af
	ld a,001h
page_triplet:                   ; 0x418D
	di
	push hl
	ld hl,0f0f1h
	ld (hl),a
	ld (07000h),a
	inc a
	inc hl
	ld (hl),a
	ld (09000h),a
	inc a
	inc hl
	ld (hl),a
	ld (0b000h),a
	pop hl
	pop af
	ei
	ret
page_banks_456:                 ; 0x41A6
	push af
	ld a,004h
	jr page_triplet
page_banks_789:                 ; 0x41AB
	push af
	ld a,007h
	jr page_triplet
page_banks_abc:            ; 0x41B0
	push af
	ld a,00ah
	jr page_triplet
page_bank_c:                   ; 0x41B5  A000 only
	push af
	ld a,00ch
	jr page_a000
page_bank_f:                   ; 0x41BA
	push af
	ld a,00fh
	jr page_a000
page_bank_d:                   ; 0x41BF
	push af
	ld a,00dh
page_a000:                      ; 0x41C2
	di
	ld (0f0f3h),a
	ld (0b000h),a
	pop af
	ei
	ret
page_banks_ef:               ; 0x41CC  8000+A000
	push af
	ld a,00eh
	di
	ld (0f0f2h),a
	ld (09000h),a
	inc a
	ld (0f0f3h),a
	ld (0b000h),a
	pop af
	ei
	ret
l41e0h:
sfx_01:                         ; 0x41E0
	SFX 1
sfx_02:                         ; 0x41E5
	SFX 2
sub_41eah:
sfx_03:                         ; 0x41EA
	SFX 3
sfx_04:                         ; 0x41EF
	SFX 4
sfx_05:                         ; 0x41F4
	SFX 5
sfx_06:                         ; 0x41F9
	SFX 6
sfx_07:                         ; 0x41FE
	SFX 7
sfx_08:                         ; 0x4203
	SFX 8
sfx_09:                         ; 0x4208
	SFX 9
sfx_0a:                         ; 0x420D
	SFX 10
sfx_0b:                         ; 0x4212
	SFX 11
sfx_0c:                         ; 0x4217
	SFX 12
sfx_0d:                         ; 0x421C
	SFX 13
sfx_0e:                         ; 0x4221
	SFX 14
sub_4226h:
sfx_0f:                         ; 0x4226
	SFX 15
sub_422bh:
sfx_10:                         ; 0x422B
	SFX 16
sub_4230h:
sfx_11:                         ; 0x4230
	SFX 17
sfx_12:                         ; 0x4235
	SFX 18
sfx_13:                         ; 0x423A
	SFX 19
sfx_14:                         ; 0x423F
	SFX 20
sfx_15:                         ; 0x4244
	SFX 21
sfx_16:                         ; 0x4249
	SFX 22
sfx_17:                         ; 0x424E
	SFX 23
sfx_18:                         ; 0x4253
	SFX 24
sfx_19:                         ; 0x4258
	SFX 25
sfx_1a:                         ; 0x425D
	SFX 26
sfx_1b:                         ; 0x4262
	SFX 27
sfx_1c:                         ; 0x4267
	SFX 28
sfx_1d:                         ; 0x426C
	SFX 29
sfx_1e:                         ; 0x4271
	SFX 30
sfx_1f:                         ; 0x4276
	SFX 31
sub_427bh:
sfx_20:                         ; 0x427B
	SFX 32
sfx_21:                         ; 0x4280
	SFX 33
sfx_22:                         ; 0x4285
	SFX 34
sfx_23:                         ; 0x428A
	SFX 35
sfx_24:                         ; 0x428F
	SFX 36
sfx_25:                         ; 0x4294
	SFX 37
sfx_26:                         ; 0x4299
	SFX 38
sfx_27:                         ; 0x429E
	SFX 39
l42a3h:
sfx_28:                         ; 0x42A3  jr; last jp was sfx_27
	SFXR 40
sfx_29:                         ; 0x42A7
	SFXR 41
sub_42abh:
sfx_2a:                         ; 0x42AB
	SFXR 42
sfx_2b:                         ; 0x42AF
	SFXR 43
sfx_2c:                         ; 0x42B3
	SFXR 44
sfx_2d:                         ; 0x42B7
	SFXR 45
sfx_2e:                         ; 0x42BB
	SFXR 46
sfx_2f:                         ; 0x42BF
	SFXR 47
sfx_30:                         ; 0x42C3
	SFXR 48
sfx_31:                         ; 0x42C7
	SFXR 49
sfx_32:                         ; 0x42CB
	SFXR 50
sfx_33:                         ; 0x42CF
	SFXR 51
sfx_34:                         ; 0x42D3
	SFXR 52
sfx_35:                         ; 0x42D7
	SFXR 53
sfx_36:                         ; 0x42DB
	SFXR 54
sfx_37:                         ; 0x42DF
	SFXR 55
sfx_38:                         ; 0x42E3
	SFXR 56
sfx_39:                         ; 0x42E7
	SFXR 57
sfx_3a:                         ; 0x42EB
	SFXR 58
sfx_3b:                         ; 0x42EF
	SFXR 59
sfx_3c:                         ; 0x42F3  boot vic_fall lands here
	SFXR 60
sfx_3d:                         ; 0x42F7
	SFXR 61
sfx_3e:                         ; 0x42FB
	SFXR 62
sfx_3f:                         ; 0x42FF
	SFXR 63
sfx_40:                         ; 0x4303
	SFXR 64
sfx_41:                         ; 0x4307
	SFXR 65
sub_430bh:
sfx_80:                         ; 0x430B
	SFXR 080h
l430fh:
sfx_81:                         ; 0x430F
	SFXR 081h
sub_4313h:
sfx_82:                         ; 0x4313
	xor a
	ld (0e21ah),a
	SFXR 082h
sub_431bh:
sfx_83:                         ; 0x431B
	ld a,0ffh
	ld (0e21ah),a
	SFXR 083h
sfx_84:                         ; 0x4324  ld a,84h; falls into sound_far
	ld a,084h
sound_far:                      ; 0x4326  page 4/5/6, call sound_entry, restore
	di
	push hl
	push de
	push bc
	push ix
	push af
	ld a,004h
	ld (07000h),a
	inc a
	ld (09000h),a
	inc a
	ld (0b000h),a
	pop af
	push af
	call 06003h             ; sound_entry (bank 04)
	ld hl,0f0f1h
	ld a,(hl)
	ld (07000h),a
	inc hl
	ld a,(hl)
	ld (09000h),a
	inc hl
	ld a,(hl)
	ld (0b000h),a
	pop af
	pop ix
	pop bc
	pop de
	pop hl
	ei
	ret
	call page_banks_123
	call play_frame
	jr l4366h
	call page_banks_123
	call set_world
l4366h:
	jp page_bank_c
	call page_banks_123
	call room_draw
	jr l4366h
bgm_toggle:                       ; 0x4371  E20C bit 3 toggles E253 / BGM
	ld a,(0e215h)
	and a
	ret nz
	ld a,(0e20ch)
	and 008h
	ret z
	ld hl,0e253h
	ld a,(hl)
	xor 001h
	ld (hl),a
	jp nz,sfx_01
	jr l438dh
bgm_stage:                        ; 0x4388  sfx_05..09 from level nibble
	ld a,(0e253h)
	and a
	ret nz
l438dh:
	call sfx_82
	ld a,(0e242h)
	call sub_4cfdh
	dec a
	and 00fh
	cp 00fh
	jr nz,l439fh
	ld a,009h
l439fh:
	srl a
	call DISPATCH_A

; BLOCK 'd_43a1_jp' (start 0x43a4 end 0x43ae)
d_43a1_jp_start:
	defw sfx_05
	defw sfx_06
	defw sfx_07
	defw sfx_08
	defw sfx_09
d_43a1_jp_end:
sub_43aeh:
	ld a,(0e203h)
	call sub_4cfdh
	and 00fh
	inc a
	ld (0e242h),a
	ret
load_pyramid:                     ; 0x43BB  unpack_map + load_map_obj
	call unpack_map
	call load_map_obj
	ret
unpack_map:                       ; 0x43C2  bank 0A map_ptr[(level)-1] -> 0xE900
	call page_banks_abc
	call unpack_map_body
	jp page_banks_123
unpack_map_body:
	ld a,(0e242h)
	dec a
	ld hl,06000h                  ; map_ptr
	call tbl_word
	ex de,hl
	ld hl,0e900h
	exx
	ld b,004h
	exx
l43ddh:
	ld a,(de)
	and a
	ret z
	and 03fh
	ld b,a
	ld a,(de)
	rlca
	rlca
	and 003h
	inc de
	ld c,a
l43eah:
	call sub_43f1h
	djnz l43eah
	jr l43ddh
sub_43f1h:
	ld a,(hl)
	add a,a
	add a,a
	or c
	ld (hl),a
	exx
	dec b
	exx
	ret nz
	exx
	ld b,004h
	exx
	inc hl
	ret
load_map_obj:                     ; 0x4400  obj_ptr overlay + obj2_ptr -> 0xE7C0
	call page_banks_abc
	call load_obj
	call load_obj2
	jp page_banks_123
load_obj2:                        ; 0x440C  secret-entrance records (editor tool 7)
	ld a,001h
	ld (0efc3h),a
	ld hl,060f0h                  ; obj2_ptr
	jr l441dh
load_obj:                         ; 0x4416  packed map-bit overlay from obj_ptr
	ld hl,06078h
	xor a
	ld (0efc3h),a
l441dh:
	ld a,001h
	ld (0efc2h),a
	ld de,0e900h
	ld (0efc0h),de
	ld ix,0e7c0h
	ld a,(0e242h)
	dec a
	call tbl_word
l4434h:
	ld e,(hl)
	inc hl
	ld a,e
	cp 0ffh
	jr z,l444ah
	ld d,(hl)
	ld a,e
	and a
	ret z
	inc hl
	push hl
	call sub_4460h
	call sub_446ch
	pop hl
l4448h:
	jr l4434h
l444ah:
	push hl
	call sub_4451h
	pop hl
	jr l4448h
sub_4451h:
	ld hl,0efc2h
	inc (hl)
	ld hl,(0efc0h)
	ld bc,000c0h
	add hl,bc
	ld (0efc0h),hl
	ret
sub_4460h:
	ld l,e
	ld h,d
	add hl,hl
	ld l,h
	ld h,000h
	ld bc,(0efc0h)
	add hl,bc
	ret
sub_446ch:
	ld a,(0efc3h)
	and a
	call nz,sub_44ach
	ld a,e
	and 01fh
	ld b,a
	ld a,e
	rlca
	rlca
	rlca
	and 003h
	ld e,a
l447eh:
	push bc
	call sub_449ah
	inc e
	ld a,e
	and 003h
	ld e,a
	jr nz,l448ah
	inc hl
l448ah:
	call sub_449ah
	ld bc,00008h
	dec e
	jp p,l4495h
	dec c
l4495h:
	add hl,bc
	pop bc
	djnz l447eh
	ret
sub_449ah:
	ld a,e
	and a
	ld a,040h
	jr z,l44a5h
	ld b,e
l44a1h:
	rra
	rra
	djnz l44a1h
l44a5h:
	ld b,a
	rlca
	cpl
	and (hl)
	or b
	ld (hl),a
	ret
sub_44ach:
	ld a,(0efc2h)
	ld (ix+000h),a
	ld a,d
	add a,a
	and 0f8h
	ld (ix+001h),a
	ld c,d
	ld a,e
	rr c
	rra
	rr c
	rra
	and 0f8h
	ld (ix+002h),a
	ld a,e
	and 01fh
	or 080h
	ld (ix+003h),a
	ld bc,00004h
	add ix,bc
	ret
sub_44d4h:
	call 0ba3ch
	call page_banks_ef
	call sub_44f2h
	call sub_4606h
	call page_banks_abc
	call sub_4535h
	call page_banks_123
	call sub_46a4h
	call 0651dh
	jp 0ba54h
sub_44f2h:
	ld a,(0e241h)
	ld hl,07ffeh
	call tbl_word
	ld a,(0e242h)
	rra
	ld a,020h
	jr c,l4504h
	xor a
l4504h:
	call ADD_HL_A
	ld de,00000h
	ld c,006h
l450ch:
	push hl
	ld b,004h
l450fh:
	push bc
	ld c,004h
l4512h:
	ld b,008h
	push hl
l4515h:
	ld a,(hl)
	call sub_5207h
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz l4515h
	pop hl
	dec c
	jr nz,l4512h
	ld a,008h
	call ADD_HL_A
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz l450fh
	pop hl
	dec c
	jr nz,l450ch
	ret
sub_4535h:
	xor a
	ld (0efc0h),a
	ld hl,(0e242h)
	dec h
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
	push hl
	pop ix
	ld de,00000h
	ld b,0c0h
l4558h:
	push bc
	ld a,(ix+000h)
	ld b,004h
l455eh:
	rlca
	rlca
	push af
	and 003h
	dec a
	jr z,$+103
	dec a
	jp m,l4576h
	ld a,005h
	jr z,l4570h
	ld a,05eh
l4570h:
	ld (0efc0h),a
	call sub_5767h
l4576h:
	call sub_524bh
	pop af
	djnz l455eh
	inc ix
	pop bc
	djnz l4558h
	ld a,(0e200h)
	cp 00bh
	ret z
	ld ix,0e7c0h
	ld b,010h
	ld a,(0e243h)
	ld c,a
l4591h:
	push bc
	ld a,(ix+000h)
	and a
	jr z,l459eh
	cp c
	jr nz,l459eh
	call sub_45a7h
l459eh:
	ld bc,00004h
	add ix,bc
	pop bc
	djnz l4591h
	ret
sub_45a7h:
	ld c,002h
	ld a,(ix+003h)
	and 01fh
	ld b,a
	ld e,(ix+001h)
	ld d,(ix+002h)
	push bc
	push de
	call sub_56deh
	pop de
	pop bc
l45bch:
	ld hl,l45c9h
	call sub_4690h
	ld a,e
	add a,008h
	ld e,a
	djnz l45bch
	ret
l45c9h:
	ld bc,03a02h
	ret nz
	rst 28h
	cp 003h
	jr z,l45f1h
	cp 003h
	jr z,l45f9h
	ld a,e
	and a
	jr z,l45f5h
	ld a,b
	sub 005h
	neg
	ld c,a
	ld a,(ix-008h)
l45e3h:
	rlca
	rlca
	dec c
	jr nz,l45e3h
	and 003h
	dec a
	jr z,l45f5h
	ld a,003h
	jr l45fdh
l45f1h:
	ld a,004h
	jr l45fdh
l45f5h:
	ld a,003h
	jr l45fdh
l45f9h:
	ld a,004h
	jr l45fdh
l45fdh:
	ld (0efc0h),a
	call sub_5767h
	jp l4576h
sub_4606h:
	ld a,(0e254h)
	and a
	ret nz
	ld a,(0e242h)
	ld hl,0806ah
	call tbl_word
l4614h:
	ld a,(hl)
	cp 0ffh
	ret z
	ld b,a
	and 0f8h
	ld e,a
	inc hl
	ld a,(hl)
	and 007h
	ld d,a
	ld a,(0e243h)
	dec a
	cp d
	jr nz,l4634h
	ld a,(hl)
	and 0f8h
	ld d,a
	inc hl
	ld c,(hl)
	dec hl
	push hl
	call sub_4638h
	pop hl
l4634h:
	inc hl
	inc hl
	jr l4614h
sub_4638h:
	ld a,b
	and 007h
	ld b,a
	ld a,(0e241h)
	dec a
	add a,a
	add a,a
	add a,a
	add a,b
	ld hl,0800ch
	call tbl_word
	ld a,b
	srl a
	cp 003h
	jr z,l4679h
	ld bc,00404h
	and a
	jr z,l4660h
	ld bc,00402h
	dec a
	jr z,l4660h
	ld bc,00204h
l4660h:
	push bc
	ld b,c
	push de
l4663h:
	ld a,(hl)
	inc hl
	push hl
	call sub_5767h
	pop hl
	ld a,d
	add a,008h
	ld d,a
	djnz l4663h
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz l4660h
	ret
l4679h:
	call sub_4690h
	inc hl
	ld a,e
	add a,008h
	ld e,a
	ld b,c
	dec b
	dec b
l4684h:
	call sub_4690h
	dec hl
	ld a,e
	add a,008h
	ld e,a
	djnz l4684h
	inc hl
	inc hl
sub_4690h:
	push de
	ld a,(hl)
	push hl
	call sub_5767h
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	ld a,(hl)
	push hl
	call sub_5767h
	pop hl
	pop de
	ret
sub_46a4h:
	ld hl,0e2c0h
	ld b,008h
l46a9h:
	push bc
	push hl
	ld a,(hl)
	and 07fh
	dec a
	sub 002h
	call c,sub_46bdh
	pop hl
	ld de,00005h
	add hl,de
	pop bc
	djnz l46a9h
	ret
sub_46bdh:
	inc l
	inc l
	ld a,(0e243h)
	cp (hl)
	ret nz
	inc l
	ld a,(hl)
	sub 008h
	ld e,a
	inc l
	ld d,(hl)
	ld bc,00302h
	ld hl,093ach
	jp draw_tilemap
mode_frame:                       ; 0x46D4  H.TIMI: mode_tick then input
	call mode_tick
	jp l4bbah
mode_tick:                        ; 0x46DA  DISPATCH_A on E200 -> d_46ea
	ld a,(0e21ah)
	dec a
	call z,sfx_82
	ld hl,0e203h
	inc (hl)
	ld bc,(0e200h)
	ld a,c
	call DISPATCH_A

; BLOCK 'd_46ea_jp' (start 0x46ed end 0x4709)
d_46ea_jp_start:
	defw mode_boot                ; 0 boot (nested d_470a)
	defw mode_hold                ; 1 wait
	defw mode_attract             ; 2 attract (demo_init / demo_tick)
	defw mode_title               ; 3 title (game / edit)
	defw mode_stage               ; 4 stage / file card
	defw mode_play                ; 5 play
	defw mode_life                ; 6 life check -> stage or game over
	defw mode_over                ; 7 game over
	defw mode_room                ; 8 room change (E248)
	defw mode_clear               ; 9 stage-clear wait (E257)
	defw mode_world               ; 10 world-complete
	defw mode_cont                ; 11 continue (F5 / E25A)
	defw mode_end                 ; 12 ending (bank 0C end_menu / snd_sel / puzzle)
	defw mode_endtxt              ; 13 ending text
d_46ea_jp_end:
mode_boot:                        ; 0x4709  nested DISPATCH_A on E201
	ld a,b
	call DISPATCH_A

; BLOCK 'd_470a_jp' (start 0x470d end 0x4717)
d_470a_jp_start:
	defw boot_init
	defw boot_skip
	defw boot_wait
	defw boot_clear
	defw boot_done
d_470a_jp_end:
boot_init:                        ; 0x4717
	call poll_skip                ; ret: no stick on boot substate 0
	call sfx_01
	call scr_reset
	call title_load
boot_skip:                        ; 0x4723  one frame then sub_next
	jr sub_next
boot_wait:                        ; 0x4725
	ld a,(0f0f4h)
	and a
	jr nz,l4737h
	ld a,(0e203h)
	rra
	ret nc
	call sub_5bc8h
	ret nz
	xor a
	jr sub_delay
l4737h:
	call sub_5bc8h
	ld a,(0e2c2h)
	or a
	ret z
	xor a
	jr sub_delay
boot_clear:                       ; 0x4742
	ld hl,0e204h
	dec (hl)
	ret nz
	call sat_wipe
	call spr_clear
	call sub_5bebh
	call sub_5f8dh
	call sfx_03
	xor a
	ld (0e2c2h),a
	jr sub_delay
boot_done:                        ; 0x475C
	call sub_5fc6h
	ld a,(0e2c2h)
	or a
	ret z
	ld a,b
	jp mode_next_a
mode_hold:                        ; 0x4768
	ld a,(0e201h)
	or a
	jr nz,l477ah
	ld hl,0e204h
	dec (hl)
	jr z,l4777h
	jp title_ptr
l4777h:
	xor a
	jr sub_delay
l477ah:
	ld hl,0e204h
	dec (hl)
	jr z,l4784h
	call nz,title_ptr
	ret
l4784h:
	jp mode_next
mode_attract:                     ; 0x4787
	ld a,b
	and a
	jr nz,l47a1h
	call scr_reset
	call page_bank_c
	call 0ba11h                   ; demo_init
	call page_banks_123
	ld a,020h
sub_delay:                        ; 0x4799  A -> E204, then sub_next
	ld (0e204h),a
sub_next:                         ; 0x479C  inc E201
	ld hl,0e201h
	inc (hl)
	ret
l47a1h:
	call page_bank_c
	call 0ba66h                   ; demo_tick
	call 0ba41h                   ; demo_wait
	call page_banks_123
	ld a,(0e246h)
	or a
	ret nz
mode_reset:                       ; 0x47B2  mode_goto 0
	xor a
mode_goto:                        ; 0x47B3  E200=A, E201=0, E204=0x20
	ld l,a
	ld h,000h
	ld (0e200h),hl
	ld a,020h
	ld (0e204h),a
	jp sub_zero
mode_title:                       ; 0x47C1  nested d_47c2 on E201
	ld a,b
	call DISPATCH_A

; BLOCK 'd_47c2_jp' (start 0x47c5 end 0x47dd)
d_47c2_jp_start:
	defw title_jingle             ; 0 sfx_10, delay
	defw title_blink              ; 1 game/edit flash (E222)
	defw title_fire               ; 2 wait fire
	defw title_files              ; 3 file_menu (E24B 0..2: normal / password / stage load)
	defw title_files_w            ; 4 E24B*2+5 -> pwd / pwent / disk
	defw title_pwd                ; 5 pwd_init
	defw title_pwd_w              ; 6 pwd_tick
	defw title_pwent              ; 7 pwd_enter
	defw title_pwent_w            ; 8 pwd_enter_w
	defw title_disk               ; 9 disk_init
	defw title_disk_w             ; 10 disk_tick
	defw title_go                 ; 11 play_clear, mode_next (stage card)
d_47c2_jp_end:
title_jingle:                     ; 0x47DD
	call sfx_10
	ld a,070h
	jr sub_delay
title_blink:                      ; 0x47E4
	ld hl,0e204h
	dec (hl)
	jr z,l4801h
	ld a,(0e222h)
	and a
	ld hl,l5f3eh
	jr z,l47f6h
	ld hl,l5f45h
l47f6h:
	ld a,(0e204h)
	and 004h
	jp z,print_stream
	jp print_stream_blank
l4801h:
	call sfx_11
	ld a,(0e222h)
	and a
	jr z,l4813h
	ld a,001h
	ld (0e25ah),a
	ld a,00bh
	jr mode_goto
l4813h:
	ld a,(0f0f7h)
	inc a
	jr z,l4835h
	ld a,001h
	call 00141h
	cpl
	and 020h
	jr z,l4835h
	call scr_reset
	call page_bank_c
	ld hl,0b284h                  ; str_secret_cmd
	call print_stream
	call page_banks_123
	jp sub_next
l4835h:
	ld hl,0e201h
	inc (hl)
	inc (hl)
	ret
title_fire:                       ; 0x483B
	ld a,(0e207h)
	and 010h
	ret z
	jp sub_next
title_files:                      ; 0x4844
	xor a
	ld (0e24ah),a
	ld (0e254h),a
	call sat_wipe
	call file_menu
	jp sub_next
title_files_w:                    ; 0x4854
	call file_menu_w
	ld hl,0e24ah
	ld a,(hl)
	and a
	ret z
	ld (hl),000h
	ld a,(0e24bh)
	add a,a
	add a,005h
	jp sub_set
title_pwd:                        ; 0x4868
	call pwd_init
	jp sub_next
title_pwd_w:                        ; 0x486E
	call pwd_tick
	ld a,(0e24ah)
	and a
	ret z
	ld a,00bh
	jp sub_set
title_pwent:                        ; 0x487B
	call pwd_enter
	jp sub_next
title_pwent_w:                        ; 0x4881
	call pwd_enter_w
	ld a,(0e24ah)
	and a
	ret z
	dec a
	jp nz,mode_reset
	jp mode_next
title_disk:                        ; 0x4890
	call disk_init
	jp sub_next
title_disk_w:                      ; 0x4896
	call disk_tick
	call spr_vram
	ld a,(0e24ah)
	and a
	ret z
	dec a
	jp z,mode_next
	jp l4beah
title_go:                         ; 0x48A8
	call play_clear
	jp mode_next
mode_stage:                       ; 0x48AE
	ld a,b
	and a
	jr nz,l491bh
	call scr_reset
	ld a,(0e254h)
	and a
	jr nz,l48f7h
	ld hl,0e240h
	ld a,(hl)
	sub 001h
	daa
	ld (hl),a
	ld hl,l5f13h
	call print_stream
	ld de,09048h
	call sub_4cefh
	call page_bank_d
	ld a,(0e242h)
	ld b,a
	add a,a
	add a,b
	add a,002h
	ld hl,0b8f8h                  ; exit door packed byte (lo5 = shape)
	call ADD_HL_A
	ld a,(hl)
	and 01fh
	call sub_4cfdh
	call page_banks_123
	ld hl,0efc0h
	ld (hl),a
	ld b,001h
	ld de,0a868h
	call sub_4d26h
	jr l4913h
l48f7h:
	xor a
	ld (0e240h),a
	dec a
	ld (0e245h),a
	call sub_43aeh
	ld a,001h
	ld (0e241h),a
	ld hl,l5f28h
	call print_stream
	ld de,06058h
	call 08a17h
l4913h:
	ld a,078h
	ld (0e204h),a
	jp sub_next
l491bh:
	ld hl,0e204h
	dec (hl)
	ret nz
	call scr_reset
	call sfx_83
	call set_world
	call sfx_82
	call bgm_stage
	ld hl,0e246h
	ld (hl),001h
mode_next:                        ; 0x4934  inc E200, E204=0x20, E201=0
	ld a,020h
mode_next_a:                      ; 0x4936  A -> E204, then inc E200
	ld (0e204h),a
	ld hl,0e200h
	inc (hl)
sub_zero:                         ; 0x493D
	xor a
sub_set:                          ; 0x493E  A -> E201
	ld (0e201h),a
	ret
mode_play:                        ; 0x4942
	ld a,(0e24ch)
	and a
	jp nz,l49e1h
	ld hl,0e215h
	ld a,(hl)
	and a
	jr z,l4958h
	dec a
	jr nz,l4958h
	ld (hl),000h
	call bgm_stage
l4958h:
	ld a,(0e24eh)
	and a
	jp nz,l4a07h
	ld a,(0e20ch)
	and 010h
	jr nz,l49a4h                  ; bit 4 -> vic_die
	call play_frame
	ld a,(0e248h)
	and a
	ld a,008h
	jp nz,mode_goto
	ld a,(0e249h)
	and a
	jr nz,l49b4h
	ld a,(0e246h)
	or a
	jr z,mode_next
	ld a,(0e20ch)
	rra
	jr c,l49c1h
	rra
	ret nc
	ld a,(0f0f4h)
	and a
	ret nz
	ld a,001h
	ld (0e24eh),a
	ld hl,03b00h
	call 00174h
	ld (0e24fh),a
	ld a,0d0h
	call 00177h
	call sfx_20
	jp l4d8fh
l49a4h:
	ld a,(0e298h)
	or a
	ret nz
	ld a,004h
	ld (0e280h),a                 ; vic_die
	call 092ffh
	jp sfx_28
l49b4h:
	xor a
	ld (0e249h),a
	inc a
	ld (0e257h),a
	ld a,009h
	jp mode_goto
l49c1h:
	ld a,(0e280h)
	sub 004h
	cp 002h                       ; vic_die / vic_hit: skip pause
	ret c
	ld a,001h
	ld (0e24ch),a
	ld (0e216h),a
	call sub_58d2h
	xor a
	ld (0e2b0h),a
	ld (0e2b3h),a
	call vic_blit
	jp sfx_81
l49e1h:
	call 06059h
	ld a,(0edc0h)
	or a
	ret nz
	call 09801h
	call vic_blit
	call 09881h
	call spr_vram
	ld a,(0e20ch)
	rra
	ret nc
	xor a
	ld (0e24ch),a
	ld (0e216h),a
	call sub_58d2h
	call sfx_80
l4a07h:
	ld a,(0e20ch)
	rra
	rra
	ret nc
	xor a
	ld (0e24eh),a
	ld hl,03b00h
	ld a,(0e24fh)
	call 00177h
	jp l4dceh
mode_life:                        ; 0x4A1D
	xor a
	ld (0e215h),a
	ld (0e255h),a
	ld a,(0e254h)
	and a
	jr nz,l4a35h
	ld a,(0e240h)
	or a
	jr z,l4a35h
l4a30h:
	ld a,004h
	jp mode_goto
l4a35h:
	call sfx_0f
l4a38h:
	ld a,007h
	jp mode_goto
mode_over:                        ; 0x4A3D
	ld a,b
	and a
	jr nz,l4a6fh
	call scr_reset
	ld hl,l5f4ch
	call print_stream
	ld a,(0e254h)
	ld b,a
	ld a,(0e217h)
	or b
	ld (0e218h),a
	ld hl,l5f59h
	call nz,print_stream
	call sub_4c8ah
	xor a
	ld (0e247h),a
	ld a,(0e254h)
	and a
	ld a,078h
	jr z,l4a6ch
	ld a,0b4h
l4a6ch:
	jp sub_delay
l4a6fh:
	ld a,(0e218h)
	and a
	call nz,sub_4adbh
	ld a,(0e203h)
	rra
	ret c
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,(0e247h)
	and a
	jr z,l4ac3h
	ld hl,0e226h
	xor a
	ld (hl),a
	inc l
	ld (hl),a
	inc l
	ld (hl),a
	inc a
	ld (0e240h),a
	ld a,(0e254h)
	and a
	jr z,l4ac3h
	ld a,(0f0f8h)
	and a
	jr z,l4abch
	call 08f0ch
	call sfx_01
	ld hl,0e278h
	ld (hl),045h
	inc hl
	ld (hl),04ch
	inc hl
	ld (hl),047h
	ld a,005h
	ld (0e25bh),a
	ld hl,00a03h
	ld (0e200h),hl
	ret
l4abch:
	ld hl,00903h
	ld (0e200h),hl
	ret
l4ac3h:
	ld a,(0e247h)
	and a
	jp nz,l4a30h
l4acah:
	xor a
	ld (0e217h),a
	ld (0e254h),a
	ld hl,0e202h
	ld a,(hl)
	and 0bfh
	ld (hl),a
	jp mode_reset
sub_4adbh:
	ld a,007h
	call 00141h
	bit 1,a
	ret nz
	ld a,001h
	ld (0e247h),a
	ld hl,l5f59h
	jp print_stream_blank
mode_room:                        ; 0x4AEE
	xor a
	ld (0e24dh),a
	call room_exit
	ld a,(0e24dh)
	and a
	jr nz,l4b01h
	call e500_room
	call room_draw
l4b01h:
	ld a,005h
	jp mode_goto
mode_clear:                       ; 0x4B06
	xor a
	ld (0e215h),a
	call clear_tick
	call spr_vram
	ld a,(0e257h)
	ld b,a
	cp 004h
	jr nz,l4b26h
	ld a,(0e254h)
	and a
	jp nz,l4a38h
	ld a,(0e242h)
	cp 03ch
	jr nc,l4b3fh
l4b26h:
	ld a,b
	and a
	ret nz
	ld a,(0e242h)
	call sub_4cfdh
	and 00fh
	dec a
	jp nz,l4a30h
	ld a,001h
	ld (0e257h),a
	ld a,00ah
	jp mode_goto
l4b3fh:
	ld a,001h
	ld (0e257h),a
	call scr_reset
	ld a,00dh
	jp mode_goto
mode_world:                       ; 0x4B4C
	call world_tick
	ld a,(0e257h)
	and a
	ret nz
	ld bc,0e201h
	call WRTVDP
	jp l4a30h
mode_cont:                        ; 0x4B5D
	call sat_flip
	call cont_tick
	call sat_blit
	ld a,(0e25ah)
	and a
	ret nz
	jp l4beah
mode_end:                         ; 0x4B6E  djnz on E201: 1 delay, 2 end_menu, 3+ text
	djnz l4b78h
	ld hl,0e204h
	dec (hl)
	ret nz
	jp sub_next
l4b78h:
	djnz l4b8fh
	call page_bank_c
	call 0b534h                   ; end_menu (bank 0C MODULE)
	call page_banks_123
	ld a,(0ef10h)
	or a
	ret nz
	ld hl,0e240h
	inc (hl)
	jp l4a30h
l4b8fh:
	call scr_reset
	ld a,078h
	call sub_delay
	call page_banks_ef
	ld hl,09d37h
	ld a,(0ef10h)
	dec a
	add a,a
	call ADD_HL_A
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	call print_stream
	jp page_banks_123
mode_endtxt:                      ; 0x4BAF
	call end_tick
	ld a,(0e257h)
	and a
	ret nz
	jp l4acah
l4bbah:
	ld a,(0e200h)
	cp 003h
	ret nc
	call read_stick
	ld hl,0e221h
	call keys_apply_at
	or a
	ret z
	ld hl,0e204h
	ld (hl),000h
	ld l,(hl)
	ld de,0e222h
	ld b,(hl)
	djnz l4beah
	and 030h
	jr z,l4bfch
	ld a,040h
	ld (0e202h),a
	ld (hl),003h
	inc hl
	ld c,000h
	ld (hl),c
	dec c
	jp l4d61h
l4beah:
	ld hl,00001h
	ld (0e200h),hl
	call sfx_01
	call sub_5bebh
	call sub_5f8dh
	jp l5fb2h
l4bfch:
	ld a,(de)
	xor 001h
	ld (de),a
	ret
play_clear:                       ; 0x4C01  zero E226, copy 6 bytes into E240
	ld hl,0e226h
	ld bc,00ddah
	ld d,h
	ld e,l
	inc e
	ld (hl),000h
	ldir
	ld hl,l4c1ah
	ld de,0e240h
	ld bc,00006h
	ldir
	ret
l4c1ah:
	ld bc,00101h
	nop
	nop
	inc bc
	ld c,000h
	ld a,(0e202h)
	add a,a
	ret p
	ld hl,0e226h
	ld a,(hl)
	add a,e
	daa
	ld (hl),a
	inc l
	ld a,(hl)
	adc a,d
	daa
	ld (hl),a
	inc hl
	ld a,(hl)
	adc a,c
	daa
	ld (hl),a
	jr nc,l4c47h
	ld bc,09999h
	ld (0e223h),bc
	ld (0e224h),bc
	jr l4cc0h
l4c47h:
	ex de,hl
	ld hl,0e245h
	cp (hl)
	jr c,l4c6fh
	ld a,(hl)
	add a,003h
	daa
	jr nc,l4c56h
	ld a,0ffh
l4c56h:
	ld (hl),a
	push de
	ld hl,0e240h
	ld a,(hl)
	cp 099h
	jr nc,l4c64h
	add a,001h
	daa
	ld (hl),a
l4c64h:
	call sfx_2a
	ld a,(0f0f4h)
	and a
	call nz,sub_4d17h
	pop de
l4c6fh:
	ex de,hl
	ld b,003h
	ld de,0e225h
l4c75h:
	ld a,(de)
	sub (hl)
	jr c,l4c7fh
	jr nz,l4cc0h
	dec l
	dec e
	djnz l4c75h
l4c7fh:
	ld bc,00003h
	ld e,025h
	ld l,028h
	lddr
	jr l4cc0h
sub_4c8ah:
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,000c0h
	ld c,00ch
	ld de,0ff13h
	call vdp_box
	ld hl,l5ef2h
	call print_stream
	call l4cc0h
	call sub_4d17h
	ld a,(0e254h)
	and a
	jr z,l4cb5h
	ld hl,0e270h
	ld de,090cah
	jp 08a1ah
l4cb5h:
	jp l4cech
l4cb8h:
	ld de,08848h
	ld hl,08858h
	jr l4cc6h
l4cc0h:
	ld de,018cah
	ld hl,l58cah
l4cc6h:
	push hl
	ld hl,0e225h
	call sub_4cd2h
	pop hl
	ex de,hl
	ld hl,0e228h
sub_4cd2h:
	ld b,003h
	jr sub_4d26h
sub_4cd6h:
	ld a,(0e254h)
	and a
	jr z,l4ce7h
	ld hl,0e270h
	ld de,05068h
	ld b,005h
	jp 08a1ch
l4ce7h:
	ld de,06868h
	jr sub_4cefh
l4cech:
	ld de,0b0cah
sub_4cefh:
	ld a,(0e242h)
	call sub_4cfdh
	ld hl,0efc0h
	ld (hl),a
	ld b,001h
	jr sub_4d26h
sub_4cfdh:
	ld b,000h
l4cffh:
	ld c,a
	sub 00ah
	jr c,l4d07h
	inc b
	jr l4cffh
l4d07h:
	rlc b
	rlc b
	rlc b
	rlc b
	ld a,b
	or c
	ret
sub_4d12h:
	ld de,0a868h
	jr l4d1fh
sub_4d17h:
	ld a,(0f0f4h)
	and a
	ret z
	ld de,0e0cah
l4d1fh:
	ld hl,0e240h
	ld b,001h
	jr sub_4d26h
sub_4d26h:
	ld a,(0f0f4h)
	and a
	ex de,hl
	call z,sub_4d7bh
	ex de,hl
l4d2fh:
	dec b
	jr nz,l4d34h
	ld c,0ffh
l4d34h:
	inc b
	ld a,(hl)
	rra
	rra
	rra
	rra
	call sub_4d45h
	ld a,(hl)
	call sub_4d45h
	dec hl
	djnz l4d2fh
	ret
sub_4d45h:
	and 00fh
	add a,0d0h
	jp l51e8h
tbl_word:                         ; 0x4D4C  HL = word[A] at HL
	add a,a
	add a,l
	ld l,a
	jr nc,l4d52h
	inc h
l4d52h:
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ret
title_ptr:                        ; 0x4D57  blink `<` `=` on game / edit (E222)
	ld hl,0e204h
	bit 3,(hl)
	ld c,0ffh
	jr nz,l4d61h
	inc c
l4d61h:
	ld hl,0388ch
	ld de,0389ch
	ld a,(0e222h)
	or a
	jr nz,l4d6eh
	ex de,hl
l4d6eh:
	push hl
	call print_ptr
	pop de
	ld c,000h
print_ptr:                        ; 0x4D75  l5f68h `"<="`
	ld hl,l5f68h
	jp print_at
sub_4d7bh:
	ld a,l
	rra
	rra
	rra
	rra
	rr h
	rra
	rr h
	rra
	rr h
	ld l,h
	and 003h
	add a,038h
	ld h,a
	ret
l4d8fh:
	ld hl,03908h
	ld de,0e880h
	ld bc,00710h
l4d98h:
	push bc
	ld b,000h
	call sub_4dfbh
	ld a,010h
	call ADD_DE_A
	ld a,020h
	call ADD_HL_A
	pop bc
	djnz l4d98h
	ld hl,03908h
	ld bc,00710h
l4db1h:
	push bc
	xor a
	ld b,a
	call sub_4e0fh
	ld a,020h
	call ADD_HL_A
	pop bc
	djnz l4db1h
	ld hl,l5f6bh
	call print_stream
	call sub_4d12h
	call sub_4cd6h
	jp l4cb8h
l4dceh:
	ld de,03908h
	ld hl,0e880h
	ld bc,00710h
l4dd7h:
	push bc
	ld b,000h
	call sub_4e05h
	ld a,010h
	call ADD_HL_A
	ld a,020h
	call ADD_DE_A
	pop bc
	djnz l4dd7h
	ret
	ld a,d
	cpl
	ld d,a
	ld a,e
	cpl
	ld e,a
	inc de
	ret
	ld a,h
	cpl
	ld h,a
	ld a,l
	cpl
	ld l,a
	inc hl
	ret
sub_4dfbh:
	push hl
	push de
	push bc
	call 00059h
	pop bc
	pop de
	pop hl
	ret
sub_4e05h:
	push hl
	push de
	push bc
	call 0005ch
	pop bc
	pop de
	pop hl
	ret
sub_4e0fh:
	push de
	push af
	push bc
	call 0016bh
	pop bc
	pop af
	pop de
	ret
vdp_wr:                           ; 0x4E19  WRTVDP, preserve BC
	push bc
	call WRTVDP
	pop bc
	ret
l4e1fh:
	ld c,000h
l4e21h:
	ex de,hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ex de,hl
l4e27h:
	call 00171h
	exx
	ld a,(00007h)
	ld c,a
	exx
l4e30h:
	ld a,(de)
	and a
	ret z
	inc de
	ld b,a
	and 07fh
	cp b
	jr z,l4e49h
	and a
	jr z,l4e1fh
	ld b,a
l4e3eh:
	call sub_4e88h
	exx
	out (c),a
	exx
	djnz l4e3eh
	jr l4e30h
l4e49h:
	call sub_4e88h
l4e4ch:
	exx
	out (c),a
	exx
	djnz l4e4ch
	jr l4e30h
sub_4e54h:
	ld c,000h
	jr l4e27h
	ld c,001h
	jr l4e21h
	ld c,001h
	jr l4e27h
l4e60h:
	call sub_4e6ch
	ld a,020h
	call ADD_DE_A
	dec c
	jr nz,l4e60h
	ret
sub_4e6ch:
	push de
l4e6dh:
	ld b,010h
l4e6fh:
	call 00174h
	call sub_4e8dh
	ex de,hl
	call 00177h
	ex de,hl
	inc e
	inc hl
	djnz l4e6fh
	ld a,e
	sub 020h
	ld e,a
	bit 4,e
	jr z,l4e6dh
	pop de
	ret
sub_4e88h:
	ld a,(de)
	inc de
	bit 0,c
	ret z
sub_4e8dh:
	push bc
	ld c,a
	ld b,008h
l4e91h:
	rr c
	rla
	djnz l4e91h
	pop bc
	ret
scr_reset:                        ; 0x4E98  hide sprites, blank, fill, display on
	call spr_clear
	call scr_off
	ld hl,00000h
	ld bc,00000h
	xor a
	ld d,000h
	call vdp_lmmv
	ld b,000h
	ld c,017h
	call WRTVDP
scr_on:                           ; 0x4EB1  VDP R#1 display enable
	ld a,(0f3e0h)
	or 040h
	ld b,a
	ld c,001h
	call WRTVDP
	jr vdp_spr_on
scr_off:                          ; 0x4EBE  VDP R#1 display disable
	ld a,(0f3e0h)
	and 0bfh
	ld b,a
	ld c,001h
	call WRTVDP
	jr vdp_spr_off
spr_clear:                        ; 0x4ECB  128-byte SAT copies at F600/F200 = Y 0xE0
	ld hl,0f600h
	call sub_4ed4h
	ld hl,0f200h
sub_4ed4h:
	ld bc,00080h
	ld a,0e0h
	jp sub_4e0fh
vdp_spr_off:                      ; 0x4EDC  VDP R#8 SPD
	ld a,(0ffe7h)
	or 002h
	ld b,a
	ld c,008h
	jp WRTVDP
vdp_spr_on:                       ; 0x4EE7  VDP R#8 sprites on
	ld a,(0ffe7h)
	and 0fdh
	ld b,a
	ld c,008h
	jp WRTVDP
palette_set:                      ; 0x4EF2  A=index, DE=MSX2 palette word
	push bc
	push hl
	ld b,a
	ld a,(00007h)
	inc a
	ld c,a
	di
	out (c),b
	ld a,090h
	out (c),a
	inc c
	out (c),d
	push af
	pop af
	out (c),e
	dec c
	ld hl,0f680h
	ld a,b
	add a,a
	add a,l
	ld l,a
	call 00171h
	dec c
	out (c),d
	out (c),e
	pop hl
	pop bc
	ei
	ret
palette_list:                     ; 0x4F1C  [index, pal_lo, pal_hi]... 0xFF
	ld a,(hl)
	inc hl
	inc a
	ret z
	dec a
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
	call palette_set
	jr palette_list
vdp_ce_wait:                      ; 0x4F2A  wait CE (S#2 bit 0)
	ld a,002h
	call vdp_status
	rra
	jp c,vdp_ce_wait
	ret
vdp_status:                       ; 0x4F34  read VDP status A (R#15)
	push bc
	push hl
	ld hl,(00006h)
	inc h
	inc l
	ld c,h
	di
	out (c),a
	ld a,08fh
	out (c),a
	ld c,l
	in a,(c)
	push af
	xor a
	ld c,h
	out (c),a
	ld a,08fh
	out (c),a
	pop af
	pop hl
	pop bc
	ei
	ret
vdp_hmmv:                         ; 0x4F54  CMD 70h fill (HL=XY, BC=NXNY)
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,024h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),h
	xor a
	out (c),a
	out (c),l
	out (c),a
	pop hl
	out (c),h
	xor a
	cp h
	jr nz,l4f79h
	inc a
l4f79h:
	out (c),a
	xor a
	out (c),a
	out (c),a
	out (c),l
	out (c),a
	ld a,070h
	out (c),a
	ei
	ret
vdp_hmmv_hi:                      ; 0x4F8A  HMMV, NY high=1
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,024h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),h
	xor a
	out (c),a
	out (c),l
	out (c),a
	pop hl
	out (c),h
	xor a
	cp h
	jr nz,l4fafh
	inc a
l4fafh:
	out (c),a
	xor a
	out (c),a
	out (c),a
	out (c),l
	inc a
	out (c),a
	ld a,070h
	out (c),a
	ei
	ret
vdp_box:                          ; 0x4FC1  rectangle outline (DE=size)
	ld b,e
	call vdp_hmmv_hi_s
	ld b,d
	call vdp_hmmv_s
	push hl
	ld a,l
	add a,e
	ld l,a
	ld b,d
	call vdp_hmmv_s
	pop hl
	ld a,h
	add a,d
	ld h,a
	ld b,e
	jp vdp_hmmv_hi_s
vdp_hmmv_hi_s:
	push hl
	push de
	push bc
	call vdp_hmmv_hi
	pop bc
	pop de
	pop hl
	ret
vdp_hmmv_s:
	push hl
	push de
	push bc
	call vdp_hmmv
	pop bc
	pop de
	pop hl
	ret
vdp_lmmv:                         ; 0x4FED  CMD C0h logical fill (A'=color)
	ex af,af'
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,024h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),h
	xor a
	out (c),a
	out (c),l
	out (c),d
	pop hl
	out (c),h
	cp h
	jr nz,l5012h
	inc a
l5012h:
	out (c),a
	xor a
	out (c),l
	cp l
	jr nz,l501bh
	inc a
l501bh:
	out (c),a
	ex af,af'
	out (c),a
	xor a
	out (c),a
	ld a,0c0h
	out (c),a
	ei
	ret
vdp_hmmm:                         ; 0x5029  CMD D0h VRAM copy
	ex af,af'
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,020h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),h
	xor a
	out (c),a
	out (c),l
	ex af,af'
	ld l,a
	and 003h
	out (c),a
	out (c),d
	xor a
	out (c),a
	out (c),e
	ld a,l
	rra
	rra
	and 003h
	out (c),a
	pop hl
	out (c),h
	xor a
	out (c),a
	out (c),l
	out (c),a
	out (c),a
	out (c),a
	ld a,0d0h
	out (c),a
	ei
	ret
vdp_hmmc:                         ; 0x506D  CMD F0h CPU→VRAM
	ex af,af'
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,024h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),d
	xor a
	out (c),a
	out (c),e
	ex af,af'
	out (c),a
	pop de
	out (c),d
	xor a
	out (c),a
	out (c),e
	out (c),a
	ld a,(hl)
	inc hl
	out (c),a
	xor a
	out (c),a
	ld a,0f0h
	out (c),a
	dec c
	dec c
	ld a,0ach
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
l50adh:
	ld a,002h
	call vdp_status
	rra
	ret nc
	add a,a
	add a,a
	jr nc,l50adh
	ld a,(hl)
	inc hl
	out (c),a
	jr l50adh
	ex af,af'
	call vdp_ce_wait
	ld a,(00007h)
	inc a
	ld c,a
	ld a,022h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),l
	ex af,af'
	ld l,a
	and 003h
	out (c),a
	out (c),h
	xor a
	out (c),a
	out (c),e
	ld a,l
	rra
	rra
	and 003h
	out (c),a
	xor a
	out (c),a
	out (c),a
	out (c),d
	cp d
	jr nz,l50f3h
	inc a
l50f3h:
	out (c),a
	xor a
	out (c),a
	out (c),a
	ld a,0e0h
	out (c),a
	ei
l50ffh:
	ret
sub_5100h:
	ex af,af'
	call vdp_ce_wait
	push bc
	ld a,(00007h)
	inc a
	ld c,a
	ld a,020h
	di
	out (c),a
	ld a,091h
	out (c),a
	inc c
	inc c
	out (c),h
	xor a
	out (c),a
	out (c),l
	ex af,af'
	rlca
	rlca
	ld l,a
	and 003h
	out (c),a
	out (c),d
	xor a
	out (c),a
	out (c),e
	ld a,l
	ld e,a
	rlca
	rlca
	and 003h
	out (c),a
	pop hl
	out (c),h
	xor a
	out (c),a
	out (c),l
	out (c),a
	out (c),a
	out (c),a
	ld a,e
	rra
	rra
	and 00fh
	or 090h
	out (c),a
	ei
	ret
copy_tiles:                       ; 0x514C  B tiles from HL → VRAM DE; C=colour
	call sub_5181h
	call sub_524bh
	djnz copy_tiles
	ret
sub_5155h:
	ld b,008h
	ld de,0ef80h
l515ah:
	push bc
	push hl
	ex de,hl
	ld a,(de)
	ld d,a
	ld b,004h
l5161h:
	ld a,c
	rl d
	jr c,l516ah
	rrca
	rrca
	rrca
	rrca
l516ah:
	rld
	ld a,c
	rl d
	jr c,l5175h
	rrca
	rrca
	rrca
	rrca
l5175h:
	rld
	inc hl
	djnz l5161h
	ex de,hl
	pop hl
	inc hl
	pop bc
	djnz l515ah
	ret
sub_5181h:
	push bc
	push de
	push hl
	push de
	call sub_5155h
	pop de
	ld b,d
	ld d,e
	ld e,b
	srl d
	rr e
	ld a,d
	add a,080h
	ld d,a
	ld hl,0ef80h
	call sub_51a2h
	pop hl
	ld bc,00008h
	add hl,bc
	pop de
	pop bc
	ret
sub_51a2h:
	push de
	ld b,008h
l51a5h:
	push bc
	ld bc,00004h
	call sub_4e05h
	ld bc,00004h
	add hl,bc
	ex de,hl
	ld bc,00080h
	add hl,bc
	ex de,hl
	pop bc
	djnz l51a5h
	pop de
	ret
l51bbh:
	push bc
	call sub_51a2h
	ld a,004h
	add a,e
	cp 080h
	jr nz,l51cbh
	ld a,004h
	add a,d
	ld d,a
	xor a
l51cbh:
	ld e,a
	pop bc
	djnz l51bbh
	ret
print_stream:                     ; 0x51D0  TEXT/CHAR (text.inc); 0xFE next pos, 0xFF end
	ld c,0ffh
	jr l51d6h
print_stream_blank:               ; 0x51D4  same stream, glyphs masked to 0
	ld c,000h
l51d6h:
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
print_at:                         ; 0x51DA  same loop; DE already set
	ld a,(hl)
	inc hl
	ld b,a
	inc b
	ret z
	inc b
	jr z,l51d6h
	and c
	call l51e8h
	jr print_at
l51e8h:
	call sub_5207h
	ld a,d
	add a,008h
	ld d,a
	ret
l51f0h:
	ld a,d
	sub 020h
	ld d,a
	ld a,e
	add a,008h
	ld e,a
	jr l51fah
l51fah:
	ld a,(hl)
	inc hl
	ld b,a
	inc b
	ret z
	inc b
	jr z,l51f0h
	call l51e8h
	jr l51fah
sub_5207h:
	push bc
	push hl
	push de
	call sub_523dh
	ld bc,00808h
	ld a,001h
	call vdp_hmmm
	pop de
	pop hl
	pop bc
	ret
l5219h:
	push bc
	push hl
	push de
	call sub_523dh
	ld bc,00808h
	ld a,048h
	call sub_5100h
	pop de
	pop hl
	pop bc
	ret
sub_522bh:
	push bc
	push hl
	push de
	call sub_523dh
	ld bc,00808h
	ld a,058h
	call sub_5100h
	pop de
	pop hl
	pop bc
	ret
sub_523dh:
	ld b,a
	and 01fh
	add a,a
	add a,a
	add a,a
	ld h,a
	ld a,b
	and 0e0h
	rrca
	rrca
	ld l,a
	ret
sub_524bh:
	ld a,d
	add a,008h
	ld d,a
	ret nz
	ld a,e
	add a,008h
	ld e,a
	ret
l5255h:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l525ch:
	push bc
	call sub_5281h
	pop bc
	djnz l525ch
	pop de
	pop bc
	ld hl,0e800h
	jp l51bbh
l526bh:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l5272h:
	push bc
	call sub_5281h
	pop bc
	djnz l5272h
	pop de
	pop bc
	ld hl,0e800h
	jp l539eh
sub_5281h:
	ld b,008h
l5283h:
	ld e,(hl)
	inc hl
	push bc
	call sub_528dh
	pop bc
	djnz l5283h
	ret
sub_528dh:
	ld b,004h
l528fh:
	xor a
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	add a,a
	add a,a
	add a,a
	add a,a
	ld c,a
	exx
	xor a
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	or c
	ld (hl),a
	inc hl
	exx
	djnz l528fh
	ret
l52aeh:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l52b5h:
	push bc
	call sub_52dah
	pop bc
	djnz l52b5h
	pop de
	pop bc
	ld hl,0e800h
	jp l51bbh
l52c4h:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l52cbh:
	push bc
	call sub_52dah
	pop bc
	djnz l52cbh
	pop de
	pop bc
	ld hl,0e800h
	jp l539eh
sub_52dah:
	ld b,008h
l52dch:
	push bc
	call sub_52e4h
	pop bc
	djnz l52dch
	ret
sub_52e4h:
	ld b,004h
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
l52eah:
	xor a
	rl d
	rla
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	add a,a
	add a,a
	add a,a
	add a,a
	ld c,a
	exx
	xor a
	rl d
	rla
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	or c
	ld (hl),a
	inc hl
	exx
	djnz l52eah
	ret
l530fh:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l5316h:
	push bc
	call sub_533bh
	pop bc
	djnz l5316h
	pop de
	pop bc
	ld hl,0e800h
	jp l51bbh
l5325h:
	push bc
	push de
	exx
	ld hl,0e800h
	exx
l532ch:
	push bc
	call sub_533bh
	pop bc
	djnz l532ch
	pop de
	pop bc
	ld hl,0e800h
	jp l539eh
sub_533bh:
	ld b,008h
l533dh:
	push bc
	call sub_5345h
	pop bc
	djnz l533dh
	ret
sub_5345h:
	ld b,004h
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
l534dh:
	xor a
	rl c
	rla
	rl d
	rla
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	add a,a
	add a,a
	add a,a
	add a,a
	ld c,a
	exx
	xor a
	rl c
	rla
	rl d
	rla
	rl e
	rla
	exx
	ld e,a
	ld d,0e7h
	ld a,(de)
	or c
	ld (hl),a
	inc hl
	exx
	djnz l534dh
	ret
sub_5378h:
	push de
	ld a,(00007h)
	ld c,a
	ld b,008h
l537fh:
	push bc
	ex de,hl
	call 00171h
	ex de,hl
	ld b,004h
l5387h:
	ld a,(hl)
	dec hl
	rrca
	rrca
	rrca
	rrca
	out (c),a
	djnz l5387h
	ld c,008h
	add hl,bc
	ex de,hl
	ld c,080h
	add hl,bc
	ex de,hl
	pop bc
	djnz l537fh
	pop de
	ret
l539eh:
	inc hl
	inc hl
	inc hl
l53a1h:
	push bc
	call sub_5378h
	ld a,004h
	add a,e
	cp 080h
	jr nz,l53b1h
	ld a,004h
	add a,d
	ld d,a
	xor a
l53b1h:
	ld e,a
	pop bc
	djnz l53a1h
	ret
sub_53b6h:
	ld a,004h
	ld (07000h),a
	inc a
	ld (09000h),a
	inc a
	ld (0b000h),a
	call 06000h             ; banks_456_init
	ld a,(0f0f1h)
	ld (07000h),a
	ld a,(0f0f2h)
	ld (09000h),a
	ld a,(0f0f3h)
	ld (0b000h),a
	call 06eeah
	ld a,005h
	call 0005fh
	ld a,00fh
	ld (0f3ebh),a
	call 00062h
	xor a
	ld h,a
	ld l,a
	ld b,a
	ld c,a
	ld d,a
	call vdp_lmmv
	xor a
	ld h,a
	ld l,a
	ld b,a
	ld c,a
	ld d,001h
	call vdp_lmmv
	call vdp_ce_wait
	ld b,004h
	ld hl,vdp_spr_start
l5403h:
	push bc
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	push hl
	call WRTVDP
	pop hl
	pop bc
	djnz l5403h
	jp vdp_spr_off

; BLOCK 'vdp_spr' (start 0x5413 end 0x541b)
vdp_spr_start:
	defb 001h, 062h               ; R#1
	defb 005h, 0efh               ; R#5 SAT
	defb 006h, 01fh               ; R#6 sprite generator
	defb 00bh, 001h               ; R#11
vdp_spr_end:
poll_skip:                        ; 0x541B  d_470a[0]
	ret
poll_keys:                        ; 0x541C  stick -> E208/E207; keyrow -> E20D/E20C
	call read_stick
	call keys_apply
	call read_keyrow
	ld hl,0e20dh
	call keys_apply_at
	ld a,(0e200h)
	cp 00bh
	jp z,086ddh
	ret
keys_apply:                       ; 0x5434  A -> E208 held; rising bits -> E207
	ld hl,0e208h
keys_apply_at:                    ; 0x5437  same at HL (title uses E20D/E20C)
	ld c,(hl)
	ld (hl),a
	xor c
	and (hl)
	dec hl
	ld (hl),a
	ret
read_stick:                       ; 0x543E  PSG R#15/14 joystick + SNSMAT 4/8
	ld e,08fh
	ld a,00fh
	call WRTPSG
	ld a,00eh
	di
	call RDPSG
	ei
	cpl
	and 03fh
	push af
	ld a,004h
	call SNSMAT
	cpl
	rlca
	rlca
	rlca
	and 020h
	ld e,a
	ld a,008h
	call SNSMAT
	cpl
	rrca
	rrca
	ld b,a
	and 004h
	or e
	ld c,a
	ld a,b
	rrca
	rrca
	ld b,a
	and 018h
	or c
	ld c,a
	ld a,b
	rrca
	and 003h
	or c
	pop bc
	or b
	ret
read_keyrow:                      ; 0x5479  SNSMAT 6/7 -> A (OR into poll_keys)
	ld a,006h
	call SNSMAT
	cpl
	and 0e0h
	ld e,a
	ld a,007h
	call SNSMAT
	cpl
	ld b,a
	and 003h
	or e
	rlca
	rlca
	rlca
	and 01fh
	ld e,a
	ld a,b
	and 080h
	or e
	ld e,a
	ld a,b
	rlca
	rlca
	rlca
	rlca
	and 040h
	or e
	ret
blit_list:                        ; 0x54A0  5-byte records, 0xFF end; tiles @ 0x8000
	ld a,(hl)
	inc a
	ret z
	push de
	ld a,(hl)
	ld c,a
	ex de,hl
	and 0f8h
	rrca
	rrca
	rrca
	call tbl_word
	push de
	push bc
	ld a,c
	and 006h
	add a,a
	jr nz,l54b9h
	ld a,002h
l54b9h:
	ld c,a
	ld b,000h
	ld de,0e700h
	ldir
	pop bc
	pop hl
	inc hl
	push hl
	ld a,(hl)
	ld b,a
	and 0e0h
	ld h,000h
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,08000h
	add hl,de
	ld a,b
	and 01fh
	add a,a
	add a,a
	call ADD_HL_A
	ex de,hl
	pop hl
	inc hl
	ld b,(hl)
	inc hl
	ld a,(hl)
	inc hl
	push hl
	ld h,(hl)
	ld l,a
	call sub_54efh
	pop hl
	pop de
	inc hl
	jr blit_list
sub_54efh:
	ld a,c
	and 007h
	jp z,l5255h
	dec a
	jp z,l526bh
	dec a
	jp z,l52aeh
	dec a
	jp z,l52c4h
	dec a
	jp z,l530fh
	jp l5325h
l5508h:
	ld a,(ix+000h)
	and a
	ret z
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld c,l
	ld b,h
	ld l,(ix+001h)
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,0f800h
	ld a,(0f0f4h)
	and a
	jr nz,l552bh
	ld de,01800h
l552bh:
	add hl,de
	ex de,hl
	ld l,(ix+002h)
	ld h,(ix+003h)
	call sub_4e05h
	ld de,00004h
	add ix,de
	jr l5508h
l553dh:
	ld a,(ix+000h)
	dec a
	ret m
	push af
	ld a,(0f0f4h)
	and a
	ld bc,0f800h
	jr nz,l554fh
	ld bc,01800h
l554fh:
	pop af
	push af
	push bc
	call z,sub_5561h
	pop bc
	pop af
	call nz,sub_55cdh
	ld bc,00004h
	add ix,bc
	jr l553dh
sub_5561h:
	ld a,(ix+001h)
	or a
	ret z
	ld (0efd0h),a
	ld l,(ix+002h)
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,bc
	ld (0efd2h),hl
	ld l,(ix+003h)
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,bc
	ld (0efd4h),hl
l5581h:
	ld hl,(0efd2h)
	ld de,0ef80h
	ld bc,00020h
	call sub_4dfbh
	call sub_55b5h
	ld de,(0efd4h)
	ld hl,0efa0h
	ld bc,00020h
	call sub_4e05h
	ld bc,00020h
	ld hl,(0efd2h)
	add hl,bc
	ld (0efd2h),hl
	ld hl,(0efd4h)
	add hl,bc
	ld (0efd4h),hl
	ld hl,0efd0h
	dec (hl)
	jr nz,l5581h
	ret
sub_55b5h:
	ld hl,0ef80h
	ld de,0efafh
	call sub_55c4h
	ld hl,0ef90h
	ld de,0efbfh
sub_55c4h:
	ld b,010h
l55c6h:
	ld a,(hl)
	ld (de),a
	inc hl
	dec de
	djnz l55c6h
	ret
sub_55cdh:
	ld a,(ix+001h)
	or a
	ret z
	ld l,(ix+003h)
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,bc
	ld a,010h
	call ADD_HL_A
	ex de,hl
	ld l,(ix+002h)
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,bc
	ld c,(ix+001h)
	jp l4e60h
sub_55f0h:
	call blit_9074
	call page_banks_ef
	ld de,0b116h
	ld hl,0b120h
	call blit_list
	ld hl,0bb05h
	ld de,0f800h
	ld bc,00100h
	call sub_4e05h
	ld hl,0a7ceh
	call palette_list
	call page_banks_123
	xor a
	call draw_cols
	ld hl,01050h
	ld bc,0a838h
	ld a,0ffh
	ld d,001h
	call vdp_lmmv
	call page_banks_ef
	ld hl,0b8dbh
	ld de,01050h
	call sub_576dh
	jp page_banks_123
load_world_gfx:                   ; 0x5634  page triplet 7/8/9, blit world + common gfx
	call page_banks_789
	call blit_world
	call blit_common
	jp page_banks_123
blit_world:                       ; 0x5640  per-world palette+tiles for world (0xE241)=1..6
	ld a,(0e241h)                 ; world index (see set_world: ceil(level/10))
	ld b,a
	ld hl,06065h                  ; e241_tbl[world] -> palette-index source (DE)
	call tbl_word
	ex de,hl
	ld a,b
	ld hl,06177h                  ; blit_ptr[world] -> blit list (HL)
	call tbl_word
	jp blit_list
blit_common:                      ; 0x5655  shared blit list at 0x602A (all worlds)
	ld hl,0602ah
	ld de,06000h
	jp blit_list
pal_15:                           ; 0x565E  bank 0F palettes by world / level bit 1
	call page_banks_ef
	ld a,(0e242h)
	dec a
	and 002h
	ld hl,0b97ah
	jr z,l566fh
	ld hl,0b9f8h
l566fh:
	ld a,(0e241h)
	call tbl_word
	call palette_list
	call page_banks_123
	call page_banks_ef
	ld hl,0b95dh
	call palette_list
	jp page_banks_123
	call page_banks_ef
	ld hl,0f800h
	ld de,0abb9h
	call sub_4e54h
	jp page_banks_123
pat_15:                           ; 0x5696  two bank-15 pattern lists (98C9 / 98EA)
	call page_banks_ef
	ld ix,098c9h
	call l5508h
	ld ix,098eah
	call l553dh
	jp page_banks_123
	call page_banks_abc
	ld bc,00307h
	call WRTVDP
	ld hl,0afddh
	ld de,00800h
	ld bc,035fbh
	call copy_tiles
	call page_banks_123
	jp l57bbh
ef10_restore:                     ; 0x56C5  stamp 16x16 from bank 0C 0xB1D6 at EF13/14
	call page_bank_c
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,0b1d6h
	ld bc,01010h
	ld a,000h
	call vdp_hmmc
	jp l57c4h
	ld c,002h
sub_56deh:
	call page_banks_ef
l56e1h:
	push bc
	push de
	ld b,c
l56e4h:
	call sub_56f8h
	ld a,d
	add a,008h
	ld d,a
	djnz l56e4h
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz l56e1h
	jp page_banks_123
sub_56f8h:
	ld a,(0e241h)
	ld hl,07ffeh
	call tbl_word
	ld a,(0e242h)
	rra
	ld a,020h
	jr c,l570ah
	xor a
l570ah:
	call ADD_HL_A
	ld a,e
	and 018h
	ld c,a
	ld a,d
	srl a
	srl a
	srl a
	and 007h
	add a,c
	call ADD_HL_A
	ld a,(hl)
	jp sub_5767h
	ld b,002h
l5724h:
	call 00174h
	ld (de),a
	inc hl
	inc de
	call 00174h
	ld (de),a
	ld a,01fh
	call ADD_HL_A
	inc de
	djnz l5724h
	ret
	ld a,001h
	jr l573ch
draw_tilemap:                     ; 0x573B  B×C tile-id grid at HL → DE
	xor a
l573ch:
	ld (0efc0h),a
l573fh:
	push bc
	push de
	ld b,c
l5742h:
	ld a,(hl)
	push hl
	call sub_5758h
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz l5742h
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz l573fh
	ret
sub_5758h:
	push af
	ld a,(0efc0h)
	and a
	jr nz,l5764h
	pop af
	call sub_5767h
	ret
l5764h:
	pop af
	jr l576ah
sub_5767h:
	jp l5219h
l576ah:
	jp sub_5207h
sub_576dh:
	push de
l576eh:
	ld a,(hl)
	inc hl
	ld c,a
	inc a
	jr z,l578bh
	inc a
	jr nz,l5782h
	pop de
	ld a,(hl)
	inc hl
	add a,d
	ld d,a
	ld a,008h
	add a,e
	ld e,a
	jr sub_576dh
l5782h:
	ld a,c
	call sub_522bh
	call sub_524bh
	jr l576eh
l578bh:
	pop de
	ret
	call scr_off
	ld b,003h
	ld c,007h
	call WRTVDP
	call page_banks_ef
	ld bc,00d1ah
	ld hl,0bc05h
	ld de,01830h
	call draw_tilemap
	call l57c4h
	jp scr_on
	call page_banks_789
	ld de,0b7c7h
	ld hl,0b7dfh
	call blit_list
	call page_banks_123
l57bbh:
	call page_banks_ef
	ld hl,0ba78h
	call palette_list
l57c4h:
	call page_banks_123
	jp page_bank_c
	call page_banks_ef
	ld hl,0f800h
	ld de,0ba9ah
	call sub_4e54h
	jr l57c4h
sat_flip:                         ; 0x57D8  swap SAT buffers, WRTVDP R#5
	ld hl,(0e210h)
	bit 2,h
	ld hl,0f600h
	ld de,0f400h
	ld bc,0e705h
	jr z,l57f1h
	ld hl,0f200h
	ld de,0f000h
	ld bc,0ef05h
l57f1h:
	ld (0e212h),hl
	ld (0e210h),de
	jp WRTVDP
sat_blit:                         ; 0x57FB  OTIR software SAT -> VRAM
	ld hl,0e20bh
	ld a,(hl)
	add a,068h
	and 078h
	ld (hl),a
	ld a,(00007h)
	ld c,a
	ld hl,(0e210h)
	call 00171h
	ld a,(0e20bh)
	ld d,010h
	add a,a
l5814h:
	ld h,069h
	ld l,a
	add hl,hl
	ld b,020h
	otir
	add a,090h
	dec d
	jr nz,l5814h
	ld hl,(0e212h)
	call 00171h
	ld a,(0e20bh)
	ld d,010h
	ld h,0e8h
l582eh:
	ld b,008h
	ld l,a
	otir
	add a,048h
	and 078h
	dec d
	jr nz,l582eh
	ret
spr_vram:                         ; 0x583B  D200→F400 (512) + SAT E800→F600
	ld bc,0ef05h
	call WRTVDP
	ld hl,0d200h
	ld de,0f400h
	ld bc,00200h
	call sub_4e05h
	ld hl,0e800h
	ld de,0f600h
	ld bc,00080h
	jp sub_4e05h
vic_reload:                       ; 0x5859  tool patterns + vic_blit tiles
	call sub_585fh
	jp page_banks_123
sub_585fh:
	call sub_58d2h
	jr l586ah
vic_blit:                         ; 0x5864  Vic tiles from banks 0E/0F
	call l586ah
	jp page_banks_123
l586ah:
	call page_banks_ef
	ld a,(0e24ch)
	or a
	jr nz,l58cdh
	ld a,(0e298h)
	or a
	jp nz,l58bah
	ld a,(0e287h)
	and 00fh
	ld hl,0e297h
	cp (hl)
	call nz,sub_5925h
	ld a,(0e285h)
	add a,a
	ld e,a
	ld d,000h
	ld hl,0869ch
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,000f0h
	ex de,hl
	ld bc,08001h
	ld a,005h
	call vdp_hmmm
	ld a,(0e285h)
	add a,a
	ld e,a
	ld d,000h
	ld hl,086b8h
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,080f0h
	ex de,hl
	ld bc,08001h
	ld a,005h
	jp vdp_hmmm
l58bah:
	ld a,(0e285h)
l58bdh:
	ld de,000f0h
	ld hl,000c0h
	add a,l
	ld l,a
	ld bc,0ff01h
	ld a,005h
l58cah:
	jp vdp_hmmm
l58cdh:
	ld a,(0e2b3h)
	jr l58bdh
sub_58d2h:
	call page_banks_ef
	call sub_58dbh
	jp page_banks_123
sub_58dbh:
	ld a,(0e24ch)
	or a
	jr nz,l5937h
	ld a,(0e298h)
	or a
	jr nz,l5928h
	ld a,(0e287h)
	add a,a
	ld e,a
	ld d,000h
	ld hl,0858bh
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
l58f6h:
	ld a,(hl)
	cp 0ffh
	ret z
	and 00fh
	jr nz,l5910h
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	push hl
	ld h,b
	ld l,c
	ex de,hl
	call sub_4e54h
	pop hl
	jr l58f6h
l5910h:
	ld c,a
	ld a,(hl)
	and 0f0h
	ld e,a
	inc hl
	ld d,(hl)
	inc hl
	ld a,(hl)
	inc hl
	ld b,(hl)
	inc hl
	push hl
	ld h,b
	ld l,a
	call l4e60h
	pop hl
	jr l58f6h
sub_5925h:
	ld (hl),a
	jr sub_58dbh
l5928h:
	call page_banks_ef
	ld hl,0e000h
	ld de,0953dh
	call sub_4e54h
	jp page_banks_123
l5937h:
	call page_banks_ef
	ld hl,0e000h
	ld de,0ab59h
	call sub_4e54h
	ld hl,0e080h
	ld de,0aa00h
	call sub_4e54h
	jp page_banks_123
col_15:                           ; 0x594F  bank 0F 0x97A1 → F880
	call page_banks_ef
	call sub_5958h
	jp page_banks_123
sub_5958h:
	ld hl,0f880h
	ld de,097a1h
	jp sub_4e54h
blit_902e:                        ; 0x5961  bank 08 blit list 0x902E → 8FFC
	call page_banks_789
	ld hl,0902eh
	ld de,08ffch
	call blit_list
	jp page_banks_123
blit_9043:                        ; 0x5970
	call page_banks_789
	ld hl,09043h
	ld de,08ffch
	call blit_list
	jp page_banks_123
blit_9063:                        ; 0x597F
	call page_banks_789
	ld hl,09063h
	ld de,08ffch
	call blit_list
	jp page_banks_123
blit_9069:                        ; 0x598E
	call page_banks_789
	ld hl,09069h
	ld de,08ffch
	call blit_list
	jp page_banks_123
blit_9074:                        ; 0x599D
	call page_banks_789
	ld hl,09074h
	ld de,08ffch
	call blit_list
	jp page_banks_123
pic_a358_at:                      ; 0x59AC  12x12 at DE=1818h
	ld de,01818h
pic_a358:                         ; 0x59AF  12x12 from A358; DE set by caller
	call page_banks_ef
	ld hl,0a358h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
pic_a2c8:                         ; 0x59BE
	call page_banks_ef
	ld hl,0a2c8h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
pic_a702:                         ; 0x59CD
	call page_banks_ef
	ld hl,0a702h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
draw_cols:                        ; 0x59DC  A = start idx; 32× 1-wide tilemap from 9D58
	push af
	ld bc,0a201h
	call WRTVDP
	pop af
	call sub_59edh
	ld bc,0e201h
	jp WRTVDP
sub_59edh:
	call page_banks_ef
	ld de,00000h
	ld b,020h
l59f5h:
	push bc
	push af
	ld hl,09d58h
	add a,a
	ld c,a
	ld b,000h
	add hl,bc
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	push de
	ld bc,01b01h
	call draw_tilemap
	pop de
	ld a,d
	add a,008h
	ld d,a
	pop af
	inc a
	pop bc
	djnz l59f5h
	jp page_banks_123
wpic0:                            ; 0x5A17  12x2 tiles at B038 (world-complete)
	call page_banks_ef
	ld hl,0a5a6h
	ld de,0b038h
	ld bc,00c02h
	call draw_tilemap
	jp page_banks_123
wpic1:                            ; 0x5A29  12x4 tiles at A838
	call page_banks_ef
	ld hl,0a5beh
	ld de,0a838h
	ld bc,00c04h
	call draw_tilemap
	jp page_banks_123
wpic2:                            ; 0x5A3B  14x6 tiles at A030
	call page_banks_ef
	ld hl,0a5eeh
	ld de,0a030h
	ld bc,00e06h
	call draw_tilemap
	jp page_banks_123
strm_a6e0:                        ; 0x5A4D  bank 0F stream at 8848
	call page_banks_ef
	ld hl,0a6e0h
	ld de,08848h
	call sub_576dh
	jp page_banks_123
strm_a3e8:                        ; 0x5A5C  two streams (world map)
	call page_banks_ef
	ld hl,0a3e8h
	ld de,00040h
	call sub_576dh
	ld hl,0a4c7h
	ld de,06040h
	call sub_576dh
	jp page_banks_123
strm_a642:                        ; 0x5A74
	call page_banks_ef
	ld hl,0a642h
	ld de,06040h
	call sub_576dh
	ld hl,0a6b1h
	ld de,09040h
	call sub_576dh
	jp page_banks_123
copy_af21:                        ; 0x5A8C  world-map 14/15 → VRAM
	call page_banks_ef
	ld de,0af21h
	ld hl,0f820h
	call sub_4e54h
	ld de,0a9fbh
	ld hl,0fe80h
	call sub_4e54h
	jp page_banks_123
	ret
copy_ab59:                        ; 0x5AA5  ending 14/15 → VRAM
	call page_banks_ef
	ld de,0ab59h
	ld hl,0f800h
	call sub_4e54h
	ld de,086d4h
	ld hl,0f880h
	call sub_4e54h
	ld de,08fd9h
	ld hl,0f940h
	call sub_4e54h
	ld de,0ae08h
	ld hl,0fa00h
	call sub_4e54h
	ld de,0a9f6h
	ld hl,0fe80h
	call sub_4e54h
	jp page_banks_123
copy_pwd:                         ; 0x5AD8  password/continue 14/15 → VRAM
	call page_banks_ef
	ld de,0ab59h
	ld hl,0f800h
	call sub_4e54h
	ld de,086d4h
	ld hl,0fc80h
	call sub_4e54h
	ld de,08fd9h
	ld hl,0fd40h
	call sub_4e54h
	ld de,0ae08h
	ld hl,0fa00h
	call sub_4e54h
	ld de,0a9fbh
	ld hl,0fe80h
	call sub_4e54h
	ld hl,0fc80h
	ld de,0f890h
	ld c,00ch
	call l4e60h
	jp page_banks_123
tiles_wmap:                       ; 0x5B16  bank 0C wmap font → VRAM 8030 / B838
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h
	ld bc,0290ah
	call copy_tiles
	ld de,0b838h
	ld hl,0ab79h
	ld bc,0050ah
	call copy_tiles
	jp page_banks_123
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h
	ld bc,02a0ch
	call copy_tiles
	ld de,0b838h
	ld hl,0ab79h
	ld bc,0050ch
	call copy_tiles
	jp page_banks_123
pal_a7ff:                         ; 0x5B52  password palette
	call page_banks_ef
	ld hl,0a7ffh
	call palette_list
	jp page_banks_123
pal_a8bb:                         ; 0x5B5E  ending palette
	call page_banks_ef
	ld hl,0a8bbh
	call palette_list
	jp page_banks_123
title_load:                       ; 0x5B6A  banks 07–9 palette + tiles, E2C0 countdown
	call page_banks_789
	call scr_off
	ld hl,0bb8bh
	call palette_list
	ld b,00fh
	ld c,007h
	call WRTVDP
	ld hl,02840h
	ld bc,0a848h
	xor a
	ld d,001h
	call vdp_lmmv
	ld hl,0bbdch
	ld de,00800h
	ld bc,00d01h
	call copy_tiles
	ld hl,0bc44h
	ld de,07000h
	ld bc,00d02h
	call copy_tiles
	ld hl,0bcach
	ld de,0d800h
	ld bc,01a03h
	call copy_tiles
	ld de,l403eh+2
	ld hl,0bb9bh
	call sub_576dh
	call scr_on
	ld hl,0e2c0h
	ld (hl),03ch
	inc hl
	ld (hl),031h
	inc hl
	ld (hl),000h
	call page_banks_123
	ret
sub_5bc8h:
	ld hl,0e2c0h
	dec (hl)
	ld a,(hl)
	and 001h
	ret nz
	inc hl
	dec (hl)
	jr nz,l5bdah
	ld a,001h
	ld (0e2c2h),a
	ret
l5bdah:
	ld a,031h
	sub (hl)
	ld c,a
	ld b,0a8h
	ld hl,02840h
	ld de,02840h
	ld a,001h
	jp vdp_hmmm
sub_5bebh:
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h
	ld bc,00c0bh
	call copy_tiles
	ld de,00038h
	ld hl,0aa89h
	ld bc,01e0bh
	call copy_tiles
	ld hl,0abc1h
	ld de,09870h
	ld b,002h
	call l51bbh
	jp page_banks_123
hud_world:                        ; 0x5C14  per-world HUD from bank 0F bd52
	call page_banks_ef
	ld a,(0e241h)
	ld b,a
	add a,a
	add a,a
	add a,b
	ld hl,0bd52h
	call ADD_HL_A
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld a,(hl)
	exx
	ld b,a
	exx
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,0ef00h
	call sub_5c51h
	ld a,(0e241h)
	cp 004h
	jp nz,page_banks_123
	exx
	ld b,005h
	exx
	ld bc,00602h
	ld de,0bdafh
	ld hl,0ef04h
	call sub_5c51h
	jp page_banks_123
sub_5c51h:
	inc (hl)
	ld a,(hl)
	exx
	cp b
	exx
	ret c
	ld (hl),000h
	inc hl
	ld a,(hl)
	inc hl
	and a
	push hl
	jr nz,l5c68h
	inc (hl)
	ld a,(hl)
	dec c
	cp c
	jr c,l5c72h
	jr l5c6dh
l5c68h:
	dec (hl)
	ld a,(hl)
	and a
	jr nz,l5c72h
l5c6dh:
	dec hl
	ld a,(hl)
	xor 001h
	ld (hl),a
l5c72h:
	pop hl
	ld a,(hl)
	ex de,hl
	add a,a
	call ADD_HL_A
	ld d,(hl)
	inc hl
	ld e,(hl)
	ld a,b
	jp palette_set
set_world:                        ; 0x5C80  world (0xE241) = ceil(level (0xE242)/10), 1..6
	ld a,(0e254h)
	and a
	jp nz,room_draw
	ld a,(0e242h)                 ; level number (1-based)
	dec a
	ld b,001h
l5c8dh:
	sub 00ah                      ; divide (level-1) by 10, B = quotient+1 = world
	jr c,l5c94h
	inc b
	jr l5c8dh
l5c94h:
	ld a,b
	ld (0e241h),a
	call load_world_gfx
	call pat_15
	call col_15
	call pal_15
	ld hl,0e2c0h
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),000h
	ldir
	call sat_wipe
	ld hl,0d200h
	ld de,0d201h
	ld bc,001ffh
	ld (hl),000h
	ldir
	call 0929dh                   ; load_vic (banks_123)
	call load_delayed
	call load_gems_far
	call load_exit
	call load_screens
	call load_links
	call screen_idx
	call load_pyramid
	call load_actors_far
	call load_map_tools_far
	call 0921ah                   ; e300_list
	call page_bank_c
	call 0b400h                   ; load_ef10 (bank 0C MODULE)
	call page_banks_123
	xor a
	ld (0e287h),a
	ld (0edcdh),a
	call sub_58d2h
room_draw:                        ; 0x5CF5  redraw current screen (E243), set E250
	call scr_reset
	call spr_clear
	call scr_off
	call stamp_actors
	call sub_44d4h
	call page_bank_c
	call 0b51ch                   ; draw_ef10 (bank 0C MODULE)
	call page_banks_123
	call draw_exit
	call nudge_stones
	call draw_actors
	call draw_maptools
	call draw_stones
	call stamp_actors_c3
	call sub_4c8ah
	call scr_on
	ld hl,(0e243h)
	dec l
	ld h,000h
	call sub_5d32h
	ld (0e250h),hl
	ret
sub_5d32h:
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
	ret
sat_wipe:                         ; 0x5D41  E800..E87F SAT Y=0xE0 (offscreen)
	ld hl,0e800h
	ld de,0e801h
	ld bc,0007fh
	ld (hl),0e0h
	ldir
	ret
border_flash:                     ; 0x5D4F  E21B countdown blinks VDP R#7
	ld hl,0e21bh
	ld a,(hl)
	and a
	ret z
	dec (hl)
	ld a,(hl)
	rra
	ld b,000h
	jr nc,l5d5eh
	ld b,00bh
l5d5eh:
	ld c,007h
	jp WRTVDP
play_frame:                       ; 0x5D63  vblank wrap around play_tick
	call sat_flip
	call play_tick
	call sat_blit
	ret
play_tick:                        ; 0x5D6D  Vic, tools, gems, actors, exit, secrets, EF10
	call border_flash
	call vic_tick
	call vic_blit
	call vic_sat
	call tick_map_tools
	call tools_sat
	call probe_pickup
	call touch_gems
	call tick_delayed
	call tick_e500
	call e500_sat
	call probe_exit
	call tick_actors
	call secret_hit                 ; bank 03: jump-reveal obj2
	call page_bank_c
	call 0b422h                   ; tick_ef10 (bank 0C MODULE)
	call page_banks_123
	call vic_e500_overlap
	call e300_e500_hit
	call bgm_toggle
	jp hud_world
load_screens:                        ; 0x5DAC  pyramid screen-present bits (ab5a_flags) -> 0xE788
	call page_bank_d
	ld hl,0e780h
	ld de,0e781h
	ld bc,0003fh
	ld (hl),000h
	ldir
	ld de,0ab5ah
	ld a,(0e242h)
	dec a
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,de
	ex de,hl
	ld hl,0e788h
	ld bc,00801h
l5dd1h:
	push bc
	ld a,(de)
	ld b,008h
l5dd5h:
	rla
	jr nc,l5ddah
	ld (hl),c
	inc c
l5ddah:
	inc hl
	djnz l5dd5h
	inc de
	ld a,c
	pop bc
	ld c,a
	djnz l5dd1h
	jp page_banks_123
screen_idx:                       ; 0x5DE6  E243 -> slot in E788 -> E244
	ld a,(0e243h)
	call sub_5df0h
	ld (0e244h),a
	ret
sub_5df0h:
	ld hl,0e788h
	ld c,000h
l5df5h:
	cp (hl)
	jr z,l5dfch
	inc hl
	inc c
	jr l5df5h
l5dfch:
	ld a,c
	ret
room_exit:                        ; 0x5DFE  E248 dir -> wrap Vic, next screen E243
	ld a,(0e244h)
	ld b,a
	ld hl,0e248h
	ld a,(hl)
	ld (0e2f9h),a
	ld (hl),000h
	ld c,a
	call room_wrap
	ld a,c
	call room_link
	ld (0e243h),hl
	ret
room_wrap:                        ; 0x5E17  dir 1..4 -> Vic X/Y on the new screen
	dec a
	jr z,l5e2ch
	dec a
	jr z,l5e32h
	dec a
	jr z,l5e26h
	ld a,003h
	ld (0e284h),a
	ret
l5e26h:
	ld a,0f2h
	ld (0e284h),a
	ret
l5e2ch:
	ld a,0adh
	ld (0e282h),a
	ret
l5e32h:
	ld a,003h
	ld (0e282h),a
	ret
room_link:                        ; 0x5E38  door tables ED80/90/A0/B0
	call sub_5e3fh
	ld hl,(0efc0h)
	ret
sub_5e3fh:
	dec a
	call DISPATCH_A

; BLOCK 'd_5e40_jp' (start 0x5e43 end 0x5e4b)
d_5e40_jp_start:
	defw link_left                ; 1 ED80
	defw link_right               ; 2 ED90
	defw link_up                  ; 3 EDA0
	defw link_down                ; 4 EDB0
d_5e40_jp_end:
link_left:
	ld a,b
	sub 008h
	jr nc,l5e52h
	add a,030h
l5e52h:
	ld hl,0ed80h
	jr l5e7fh
link_right:
	ld a,b
	add a,008h
	cp 030h
	jr c,l5e60h
	sub 030h
l5e60h:
	ld hl,0ed90h
	jr l5e7fh
link_up:
	ld a,b
	dec a
	and 007h
	ld c,a
	ld a,b
	and 0f8h
	or c
	ld hl,0eda0h
	jr l5e7fh
link_down:
	ld a,b
	inc a
	and 007h
	ld c,a
	ld a,b
	and 0f8h
	or c
	ld hl,0edb0h
l5e7fh:
	ld (0efc1h),a
	ld de,0e788h
	call ADD_DE_A
	ld a,(de)
	and a
	jr z,l5e90h
	ld (0efc0h),a
	ret
l5e90h:
	ld a,(hl)
	cp 0ffh
	jr z,l5eafh
	cp b
	inc hl
	jr z,l5e9ch
	inc hl
	jr l5e90h
l5e9ch:
	ld a,(hl)
	cp b
	call z,l5eafh
	ld (0efc1h),a
	ld hl,0e788h
	call ADD_HL_A
	ld a,(hl)
	ld (0efc0h),a
	ret
l5eafh:
	ld hl,0e24dh
	ld (hl),001h
	ret
load_links:                        ; 0x5EB5  door links (adcf/ae47/aebf/af37) -> ED80..EDB0
	call page_bank_d
	ld hl,0adcfh
	ld de,0ed80h
	call sub_5edfh
	ld hl,0ae47h
	ld de,0ed90h
	call sub_5edfh
	ld hl,0aebfh
	ld de,0eda0h
	call sub_5edfh
	ld hl,0af37h
	ld de,0edb0h
	call sub_5edfh
	jp page_banks_123
sub_5edfh:
	ld a,(0e242h)
	call tbl_word
l5ee5h:
	ld a,(hl)
	inc a
	jr z,l5eefh
	ldi
	ldi
	jr l5ee5h
l5eefh:
	ldi
	ret
; BLOCK 'print_txt' (start 0x5ef2 end 0x5f8d)
print_txt_start:
l5ef2h:                         ; 0x5EF2  hiscore / score / stage / rest
	TEXT_AT 010h, 0c2h
	TEXT "hiscore"
	TEXT_NEXT 060h, 0c2h
	TEXT "score"
	TEXT_NEXT 098h, 0c2h
	TEXT "stage"
	TEXT_NEXT 0d0h, 0c2h
l5f0eh:                         ; 0x5F0E  glyphs only; DE preloaded
	TEXT "rest"
	TEXT_END
l5f13h:                         ; 0x5F13  stage / soul stone
	TEXT_AT 060h, 048h
	TEXT "stage"
	TEXT_NEXT 048h, 068h
	TEXT "soul stone"
	TEXT_END
l5f28h:                         ; 0x5F28  file; then Konami / 1988 (':' = ©)
	TEXT_AT 060h, 048h
	TEXT "file"
	TEXT_END
	TEXT_AT 038h, 050h
	TEXT ":konami 1988"
	db 0feh                   ; next D,E is l5f3eh if the stream is walked
l5f3eh:                         ; 0x5F3E  game
	TEXT_AT 050h, 08ch
	TEXT "game"
	TEXT_END
l5f45h:                         ; 0x5F45  edit
	TEXT_AT 050h, 09ch
	TEXT "edit"
	TEXT_END
l5f4ch:                         ; 0x5F4C  game  over
	TEXT_AT 058h, 058h
	TEXT "game  over"
	TEXT_END
l5f59h:                         ; 0x5F59  continue
	TEXT_AT 050h, 068h
	TEXT "f5  continue"
	TEXT_END
l5f68h:                         ; 0x5F68  glyphs only; DE preloaded
	TEXT "<="
	TEXT_END
l5f6bh:                         ; 0x5F6B  hiscore / st / rest / score
	TEXT_AT 048h, 048h
	TEXT "hiscore "
	TEXT_NEXT 050h, 068h
	TEXT "st "
	TEXT_NEXT 080h, 068h
	TEXT "rest "
	TEXT_NEXT 058h, 058h
	TEXT "score "
	TEXT_END
print_txt_end:

sub_5f8dh:
	call scr_reset
	call vdp_fill
	ld bc,00007h
	call WRTVDP
	call sub_55f0h
	call vdp_spr_on
	ld hl,00039h
	ld (0e214h),hl
	ret
vdp_fill:                         ; 0x5FA6  HMMV-style fill (HL=0040, BC=0080)
	xor a
	ld h,a
	ld l,040h
	ld b,a
	ld c,080h
	ld d,001h
	jp vdp_lmmv
l5fb2h:
	ld hl,01050h
	ld de,01820h
	ld bc,0a838h
	ld a,048h
	call sub_5100h
	call sub_5fe7h
	jp scr_on
sub_5fc6h:
	ld a,(0e203h)
	rra
	ret c
	ld hl,0e214h
	dec (hl)
	jr z,sub_5fe7h
	ld a,(hl)
	ld c,a
	add a,01fh
	ld e,a
	ld d,018h
	ld hl,01050h
	ld a,039h
	sub c
	ld c,a
	ld b,0a8h
	ld a,001h
	call vdp_hmmm
	ret
sub_5fe7h:
	ld hl,03084h
	ld bc,04828h
	xor a
	ld d,a
	call vdp_lmmv
	ld hl,03084h
	ld de,04828h
	ld c,00dh
	call vdp_box
	ld hl,l5f3eh
