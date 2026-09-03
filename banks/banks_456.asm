; ===========================================================================
;  banks 4-6 — sound triplet via page_banks_456, CPU 0x6000–0xBFFF (one PHASE).
;  Packed-PSG headers / waves / env in bank 4; channel streams continue
;  through 5/6. Jump table banks_456_init / sound_entry / tick_entry.
;  Regen one 8K bank at a time:
;    tools/workbench/msx/regen-bank.sh 4 0x6000 banks/banks_456.blocks
;    tools/workbench/msx/regen-bank.sh 5 0x8000 banks/banks_456.blocks
;    tools/workbench/msx/regen-bank.sh 6 0xA000 banks/banks_456.blocks
; ===========================================================================

banks_456_init:                  ; 0x6000  far call from scr_boot
	jp sound_init
sound_entry:                    ; 0x6003  far call from sound_far
	jp sound_play
tick_entry:                     ; 0x6006  far call from htimi_isr
	jp sound_tick
sound_init:
	ld a,001h
	call sound_play
	ld a,0ffh
	ld hl,0e1ebh
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld de,0e1eeh
	ld (hl),001h
	ld bc,0000eh
	ldir
	call sub_6df4h
	ld a,03fh
	ld (09000h),a
	xor a
	ld (0988fh),a
	ld a,002h
	ld (09000h),a
	ld a,0bfh
	ld (0e1e3h),a
	ld e,a
	ld a,007h
	jp WRTPSG
sound_play:
	ld c,a
	cp 082h
	jp z,l61bbh
	cp 083h
	jp z,l61c2h
	cp 084h
	jp z,l61cdh
	cp 080h
	jp z,l61e4h
	cp 081h
	call z,sub_6248h
	ld hl,0e1cch
	ld (hl),c
	ld hl,sound_ptr_start-2
	ld a,c
	add a,c
	ld e,a
	ld d,000h
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,0e1cdh
	ld bc,00012h            ; 18-byte window; packed headers may be shorter
	ldir
	ld ix,0e1cfh
	ld hl,0e1cdh
	bit 7,(hl)
	jr z,l6092h
	push ix
	ld ix,0e000h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e001h
	call sub_615ch
	inc ix
	inc ix
l6092h:
	ld hl,0e1cdh
	bit 6,(hl)
	jr z,l60b0h
	push ix
	ld ix,0e033h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e034h
	call sub_615ch
	inc ix
	inc ix
l60b0h:
	ld hl,0e1cdh
	bit 5,(hl)
	jr z,l60ceh
	push ix
	ld ix,0e066h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e067h
	call sub_615ch
	inc ix
	inc ix
l60ceh:
	ld hl,0e1cdh
	bit 4,(hl)
	jr z,l60ech
	push ix
	ld ix,0e099h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e09ah
	call sub_615ch
	inc ix
	inc ix
l60ech:
	ld hl,0e1cdh
	bit 3,(hl)
	jr z,l610ah
	push ix
	ld ix,0e0cch
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e0cdh
	call sub_615ch
	inc ix
	inc ix
l610ah:
	ld hl,0e1cdh
	bit 2,(hl)
	jr z,l6128h
	push ix
	ld ix,0e0ffh
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e100h
	call sub_615ch
	inc ix
	inc ix
l6128h:
	ld hl,0e1cdh
	bit 1,(hl)
	jr z,l6146h
	push ix
	ld ix,0e132h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e133h
	call sub_615ch
	inc ix
	inc ix
l6146h:
	ld hl,0e1cdh
	bit 0,(hl)
	ret z
	push ix
	ld ix,0e165h
	call sub_62dfh
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e166h
sub_615ch:
	ld b,(hl)
	cp b
	ret c
	ex de,hl
	ld (de),a
	dec de
	ld hl,0e1cch
	ld a,(hl)
	ld (de),a
	inc de
	inc de
	ld a,(ix+000h)
	ld (de),a
	inc de
	ld a,(ix+001h)
	ld (de),a
	inc de
	ld hl,l617ch
	ld bc,0002eh
	ldir
	ret
l617ch:
	ld bc,00000h
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ld hl,0e1cbh
	set 4,(hl)
	res 0,(hl)
	ld hl,0e1e1h
	ld (hl),000h
	inc hl
	ld (hl),009h
	ret
l61bbh:
	ld hl,0e1cbh
	res 0,(hl)
	jr l61dch
l61c2h:
	ld hl,0e1dfh
	ld (hl),025h
	inc hl
	ld (hl),00ah
	jp l61d5h
l61cdh:
	ld hl,0e1dfh
	ld (hl),025h
	inc hl
	ld (hl),00ah
l61d5h:
	ld hl,0e1cbh
	set 0,(hl)
	res 4,(hl)
l61dch:
	ld hl,0e1e1h
	xor a
	ld (hl),a
	inc hl
	ld (hl),a
	ret
l61e4h:
	ld hl,0e1cbh
	bit 1,(hl)
	ld b,000h
	jr nz,l61efh
	ld b,001h
l61efh:
	res 1,(hl)
	bit 3,(hl)
	jr z,l61f9h
	res 3,(hl)
	set 0,(hl)
l61f9h:
	ld hl,0e198h
	ld de,0e099h
	call sub_62d9h
	ld a,(0e00dh)
	ld e,a
	ld a,(0e1feh)
	and 00fh
	or e
	ld (0e00dh),a
	ld a,(0e040h)
	ld e,a
	ld a,(0e1feh)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	or e
	ld (0e040h),a
	ld a,(0e073h)
	ld e,a
	ld a,(0e1ffh)
	and 00fh
	or e
	ld (0e073h),a
	ld a,03fh
	ld (09000h),a
	ld a,(0e1fch)
	ld (0988fh),a
	ld a,002h
	ld (09000h),a
	ld a,0ffh
	ld hl,0e1ebh
	ld (hl),a
	inc hl
	ld (hl),a
	jp sub_6df4h
sub_6248h:
	ld hl,0e1cbh
	bit 1,(hl)
	ld b,000h
	jr z,l6253h
	ld b,001h
l6253h:
	set 1,(hl)
	bit 0,(hl)
	jr z,l625dh
	res 0,(hl)
	set 3,(hl)
l625dh:
	ld hl,0e099h
	ld de,0e198h
	call sub_62d9h
	ld a,(0e00dh)
	ld d,a
	and 00fh
	ld (0e1feh),a
	ld a,d
	and 0f0h
	ld (0e00dh),a
	ld a,(0e040h)
	ld d,a
	and 00fh
	rlca
	rlca
	rlca
	rlca
	ld e,a
	ld a,(0e1feh)
	and e
	ld (0e1feh),a
	ld a,d
	and 0f0h
	ld (0e040h),a
	ld a,(0e073h)
	ld d,a
	and 00fh
	ld (0e1ffh),a
	ld a,d
	and 0f0h
	ld (0e073h),a
	ld a,(0e00ch)
	res 4,a
	ld (0e00ch),a
	ld a,(0e03fh)
	res 4,a
	ld (0e03fh),a
	ld a,(0e072h)
	res 4,a
	ld (0e072h),a
	ld a,03fh
	ld (09000h),a
	ld a,(0e1fch)
	and 0feh
	ld (0988fh),a
	xor a
	ld (0988bh),a
	ld (0988ch),a
	ld (0988dh),a
	ld (0988eh),a
	ld a,002h
	ld (09000h),a
	ld a,b
	or a
	ret nz
	ld c,002h
	ret
sub_62d9h:
	ld bc,00033h
	ldir
	ret
sub_62dfh:
	ld (ix+01ah),000h
	ld (ix+01bh),000h
	ld (ix+01ch),000h
	ld (ix+01dh),000h
	ld (ix+01eh),000h
	ld (ix+026h),000h
	ret
sound_tick:
	ld a,(0e1e3h)
	call sub_6c73h
	ld a,(0fda2h)
	ld hl,0e1fdh
	cp (hl)
	jr z,l632bh
	ld ix,0e099h
	set 7,(ix+00fh)
	ld ix,0e0cch
	set 7,(ix+00fh)
	ld ix,0e0ffh
	set 7,(ix+00fh)
	ld ix,0e132h
	set 7,(ix+00fh)
	ld a,(0fda2h)
	ld (hl),a
l632bh:
	inc (hl)
	ld a,(hl)
	ld (0fda2h),a
	ld hl,0e1cbh
	bit 1,(hl)
	jp nz,l63b4h
	ld a,(0e1cbh)
	bit 0,a
	call nz,sub_67b1h
	ld a,(0e1cbh)
	bit 4,a
	call nz,sub_6835h
	ld a,001h
	ld (0e1e4h),a
	ld ix,0e000h
	call sub_63ach
	ld a,002h
	ld (0e1e4h),a
	ld ix,0e033h
	call sub_63ach
	ld a,004h
	ld (0e1e4h),a
	ld ix,0e066h
	call sub_63ach
	ld a,008h
	ld (0e1e4h),a
	ld ix,0e099h
	call sub_63ach
	ld a,010h
	ld (0e1e4h),a
	ld ix,0e0cch
	call sub_63ach
	ld a,020h
	ld (0e1e4h),a
	ld ix,0e0ffh
	call sub_63ach
	ld a,040h
	ld (0e1e4h),a
	ld ix,0e132h
	call sub_63ach
	ld a,080h
	ld (0e1e4h),a
	ld ix,0e165h
	call sub_63ach
	call sub_6b98h
	ret
sub_63ach:
	ld a,(ix+000h)
	or a
	call nz,sub_63cch
	ret
l63b4h:
	ld a,008h
	ld (0e1e4h),a
	ld ix,0e099h
	call sub_63ach
	ld a,0bfh
	ld (0e1e3h),a
	call sub_6975h
	call sub_6b98h
	ret
sub_63cch:
	dec (ix+004h)
	jp nz,l65e2h
	bit 6,(ix+00dh)
	jr z,l63dch
	set 5,(ix+00dh)
l63dch:
	ld l,(ix+002h)
	ld h,(ix+003h)
l63e2h:
	ld a,(hl)
	cp 0ffh
	jp z,l684dh
	cp 0d0h
	jr c,l63f3h
	call sub_688eh
	inc hl
	jp l63e2h
l63f3h:
	bit 0,(ix+009h)
	jp nz,l640ah
	bit 1,(ix+009h)
	jp nz,l648dh
	ld a,(ix+009h)
	and 01ch
	jp nz,l6506h
	ret
l640ah:
	ld a,(hl)
	and 00fh
	ld b,a
	ld a,(ix+014h)
	jr z,l6417h
	ld e,a
l6414h:
	add a,e
	djnz l6414h
l6417h:
	ld (ix+004h),a
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	call sub_67a9h
	bit 7,(ix+009h)
	ret nz
	cp 00ch
	jr nc,l6477h
	ld hl,l6480h
	ld e,a
	ld d,000h
	add hl,de
	ld l,(hl)
	ld h,000h
	ld a,(ix+016h)
	or a
	jr z,l6453h
	bit 7,(ix+00dh)
	jr z,l644fh
	ld a,(ix+02fh)
	ld b,a
	ld a,(ix+016h)
	sub b
	jr z,l6453h
	jr c,l6453h
l644fh:
	ld b,a
l6450h:
	add hl,hl
	djnz l6450h
l6453h:
	ld (ix+010h),l
	ld (ix+011h),h
	ld e,(ix+015h)
	ld a,(0e1cbh)
	and 011h
	call nz,sub_6811h
	ld (ix+012h),e
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	set 1,(ix+00dh)
	call sub_6591h
	ret
l6477h:
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	ret
l6480h:
	ld l,d
	ld h,h
	ld e,(hl)
	ld e,c
	ld d,h
	ld c,a
	ld c,d
	ld b,(hl)
	ld b,d
	ccf
	dec sp
	jr c,l64c2h
l648dh:
	ld a,(ix+00dh)
	and 003h
	jr z,l64f7h
	cp 001h
	jr z,l64ceh
	ld a,(hl)
	bit 6,(ix+00eh)
	jr nz,l64bah
	bit 5,(ix+00eh)
	jr nz,l64bfh
	and 0f0h
	ld b,a
	xor (hl)
	ld d,a
	inc hl
	ld a,(hl)
	ld (ix+010h),a
	ld (ix+011h),d
	ld a,b
	rrca
	rrca
	rrca
	rrca
	ld b,a
	jr l64d2h
l64bah:
	ld (ix+010h),a
	jr l64e6h
l64bfh:
	and 0f0h
	rrca
l64c2h:
	rrca
	rrca
	rrca
	ld b,a
	ld a,(hl)
	and 00fh
	ld (ix+011h),a
	jr l64d2h
l64ceh:
	ld a,(hl)
	and 00fh
	ld b,a
l64d2h:
	ld a,(0e1e4h)
	cp 008h
	jr nc,l64e1h
	bit 2,(ix+00dh)
	jr z,l64e1h
	ld b,010h
l64e1h:
	inc b
	inc b
	ld (ix+012h),b
l64e6h:
	ld e,(ix+012h)
	ld a,(0e1cbh)
	and 011h
	call nz,sub_6811h
	ld (ix+012h),e
	call sub_6591h
l64f7h:
	bit 7,(ix+009h)
	ret nz
	call sub_67a9h
	ld a,(ix+013h)
	ld (ix+004h),a
	ret
l6506h:
	set 7,(ix+009h)
	call l640ah
	ld b,a
	call sub_653dh
	ld a,b
	add a,a
	ld e,a
	ld d,000h
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld a,(hl)
sub_651ch:
	set 1,(ix+009h)
	call l63e2h
	res 1,(ix+009h)
	res 7,(ix+009h)
	ld a,(ix+013h)
	ld (ix+019h),a
	inc hl
	ld (ix+017h),l
	ld (ix+018h),h
	set 0,(ix+00eh)
	ret
sub_653dh:
	bit 2,(ix+009h)
	jp nz,l6552h
	bit 3,(ix+009h)
	jp nz,l6567h
	bit 4,(ix+009h)
	jp nz,l657ch
l6552h:
	ld a,(ix+02ch)
	cp 000h
	jp z,l655fh
	cp 001h
	jp z,l6563h
l655fh:
	ld hl,env_0
	ret
l6563h:
	ld hl,env_1
	ret
l6567h:
	ld a,(ix+02ch)
	cp 000h
	jp z,l6574h
	cp 001h
	jp z,l6578h
l6574h:
	ld hl,env_2
	ret
l6578h:
	ld hl,env_3
	ret
l657ch:
	ld a,(ix+02ch)
	cp 000h
	jp z,l6589h
	cp 001h
	jp z,l658dh
l6589h:
	ld hl,env_4
	ret
l658dh:
	ld hl,env_5
	ret
sub_6591h:
	call sub_6627h
	res 4,(ix+00eh)
	ld a,(ix+00fh)
	and 0d7h
	ld (ix+00fh),a
	xor a
	ld (ix+01dh),a
	ld (ix+01eh),a
	ld (ix+01fh),a
	ld (ix+020h),a
	set 2,(ix+00fh)
	ld a,(ix+012h)
	bit 7,(ix+00eh)
	jr z,l65c1h
	ld e,(ix+029h)
	sub e
	call m,sub_65e0h
l65c1h:
	ld (ix+00ch),a
	ld a,(0e1e4h)
	cp 008h
	jr nc,l65d0h
	bit 2,(ix+00dh)
	ret nz
l65d0h:
	bit 1,(ix+00fh)
	ret z
	ld a,(ix+025h)
	ld (ix+00ch),a
	res 2,(ix+00fh)
	ret
sub_65e0h:
	xor a
	ret
l65e2h:
	bit 0,(ix+00eh)
	jp nz,l65ffh
	bit 6,(ix+00dh)
	call nz,sub_6738h
	bit 2,(ix+00eh)
	call nz,sub_6642h
	bit 0,(ix+00fh)
	call nz,sub_6690h
	ret
l65ffh:
	dec (ix+019h)
	ret nz
	ld l,(ix+017h)
	ld h,(ix+018h)
	ld a,(hl)
	cp 0ffh
	jr z,l6616h
	set 7,(ix+009h)
	call sub_651ch
	ret
l6616h:
	res 0,(ix+00eh)
	xor a
	ld (ix+00ch),a
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	ret
sub_6627h:
	ld e,(ix+010h)
	ld d,(ix+011h)
	bit 1,(ix+00eh)
	jr z,l663bh
	ld a,(ix+026h)
	add a,e
	ld e,a
	jr nc,l663bh
	inc d
l663bh:
	ld (ix+00ah),e
	ld (ix+00bh),d
	ret
sub_6642h:
	inc (ix+01eh)
	ld a,(ix+01eh)
	ld b,(ix+00eh)
	bit 4,b
	jr nz,l6661h
	bit 3,b
	jr z,l6661h
	cp (ix+01ah)
	ret nz
	ld (ix+01eh),000h
	set 4,(ix+00eh)
	jr l6665h
l6661h:
	cp (ix+01bh)
	ret nz
l6665h:
	ld e,(ix+00ah)
	ld d,(ix+00bh)
	ld b,(ix+01ch)
	ld a,(ix+01dh)
	cpl
	ld (ix+01dh),a
	and a
	ld a,e
	jr nz,l6680h
	add a,b
	ld e,a
	jr nc,l6685h
	inc d
	jr l6685h
l6680h:
	sub b
	ld e,a
	jr nc,l6685h
	dec d
l6685h:
	ld (ix+00ah),e
	ld (ix+00bh),d
	ld (ix+01eh),000h
	ret
sub_6690h:
	ld a,(0e1e4h)
	cp 008h
	jr nc,l669ch
	bit 2,(ix+00dh)
	ret nz
l669ch:
	call sub_66a3h
	ld (ix+00ch),e
	ret
sub_66a3h:
	ld e,(ix+00ch)
	inc (ix+01fh)
	ld b,(ix+01fh)
	ld a,(ix+024h)
	cp (ix+004h)
	call nc,sub_6733h
	bit 5,(ix+00fh)
	jr nz,l6727h
	bit 3,(ix+00fh)
	jr nz,l66eeh
	bit 2,(ix+00fh)
	jr nz,l66dah
	ld a,e
	inc a
	ld e,a
	cp (ix+012h)
	ret c
	set 2,(ix+00fh)
	ld e,(ix+012h)
	ld (ix+01fh),000h
	ret
l66dah:
	ld a,e
	dec a
	jp m,l66e0h
	ld e,a
l66e0h:
	ld a,b
	cp (ix+021h)
	ret c
	ld (ix+01fh),000h
	set 3,(ix+00fh)
	ret
l66eeh:
	bit 4,(ix+00fh)
	jp nz,l6711h
	ld a,b
	cp (ix+022h)
	ret nz
	ld a,e
	dec a
	ret m
	ld e,a
	inc (ix+020h)
	ld a,(ix+020h)
	cp (ix+023h)
	ld (ix+01fh),000h
	ret nz
	set 5,(ix+00fh)
	ret
l6711h:
	ld a,(ix+022h)
	ld d,a
	ld a,e
	sub d
	ld e,000h
	jp m,l671dh
	ld e,a
l671dh:
	ld a,b
	cp (ix+023h)
	ret nz
	set 5,(ix+00fh)
	ret
l6727h:
	ld a,(ix+004h)
	cp (ix+024h)
	ret nc
	ld a,e
	dec a
	ret m
	ld e,a
	ret
sub_6733h:
	set 5,(ix+00fh)
	ret
sub_6738h:
	nop
	bit 5,(ix+00dh)
	ret z
	bit 3,(ix+031h)
	jr z,l6768h
	dec (ix+030h)
	bit 3,(ix+030h)
	jr z,l6792h
	ld a,(ix+030h)
	sub 008h
	ld b,a
	dec b
	ld a,(ix+032h)
	ld e,a
l6758h:
	add a,e
	djnz l6758h
	ld e,a
	ld d,000h
	ld l,(ix+010h)
	ld h,(ix+011h)
	sbc hl,de
	jr l678bh
l6768h:
	ld a,(ix+030h)
	or a
	jr z,l6792h
	dec (ix+030h)
	ld a,(ix+030h)
	or a
	jr z,l6792h
	ld b,a
	ld a,(ix+032h)
	ld hl,00000h
	ld d,000h
l6780h:
	ld e,a
	add hl,de
	djnz l6780h
	ld e,(ix+010h)
	ld d,(ix+011h)
	add hl,de
l678bh:
	ld (ix+00ah),l
	ld (ix+00bh),h
	ret
l6792h:
	res 5,(ix+00dh)
	ld e,(ix+010h)
	ld d,(ix+011h)
	ld (ix+00ah),e
	ld (ix+00bh),d
	ld a,(ix+031h)
	ld (ix+030h),a
	ret
sub_67a9h:
	inc hl
	ld (ix+002h),l
	ld (ix+003h),h
	ret
sub_67b1h:
	ld de,0e1dfh
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	ld hl,0e1e1h
	inc (hl)
	ld a,(hl)
	cp b
	ret nz
	ld (hl),000h
	inc hl
	inc (hl)
	ld a,(hl)
	cp c
	ret nz
	ld hl,0e1cbh
	res 0,(hl)
	xor a
	ld hl,0e1e1h
	ld (hl),a
	inc hl
	ld (hl),a
	ld a,(0e033h)
	ld e,a
	ld a,(0e066h)
	cp e
	jr nz,l67ebh
	ld ix,0e066h
	call l684dh
	ld ix,0e099h
	call l684dh
l67ebh:
	ld de,00033h
	ld ix,0e000h
	call l684dh
	add ix,de
	call l684dh
	ld ix,0e0cch
	call l684dh
	add ix,de
	call l684dh
	add ix,de
	call l684dh
	add ix,de
	call l684dh
	ret
sub_6811h:
	ld a,(0e033h)
	ld b,a
	ld a,(0e066h)
	cp b
	jr z,l6821h
	ld a,(0e1e4h)
	and 0f3h
	ret z
l6821h:
	bit 2,(ix+00dh)
	jr nz,l6832h
	ld a,(0e1e2h)
	ld b,a
	ld a,e
	sub b
	ld e,000h
	ret m
	ld e,a
	ret
l6832h:
	ld e,000h
	ret
sub_6835h:
	ld hl,0e1e1h
	inc (hl)
	ld a,(hl)
	cp 025h
	ret nz
	ld (hl),000h
	inc hl
	dec (hl)
	ret nz
	ld hl,0e1cbh
	res 4,(hl)
	ld hl,0e1e1h
	ld (hl),000h
	ret
l684dh:
	xor a
	ld (ix+000h),a
	ld (ix+001h),a
	ld (ix+005h),a
	ld (ix+006h),a
	ld (ix+00ah),a
	ld (ix+00bh),a
	ld (ix+00ch),a
	ld (ix+00dh),a
	ld (ix+00eh),a
	ld (ix+00fh),a
	ld a,(0e1e4h)
	cp 008h
	ret nc
	nop
	cp 004h
	ld hl,0e1e7h
	jr nz,l6889h
	res 0,(hl)
	res 1,(hl)
	bit 3,(hl)
	ret z
	bit 2,(hl)
	ret z
	set 2,(hl)
	res 3,(hl)
	ret
l6889h:
	res 2,(hl)
	res 3,(hl)
	ret
sub_688eh:
	cp 0e0h
	jp c,l6af8h
	and 01fh
	push hl
	ld hl,l68a3h
	add a,a
	ld e,a
	ld d,000h
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jp (hl)
l68a3h:
	pop hl
	ld l,b
	rst 30h
	ld l,b
	pop hl
	ld l,b
	rst 30h
	ld l,b
	inc d
	ld l,c
	ld a,069h
	ld d,d
	ld l,c
	ld h,d
	ld l,c
	ld (hl),h
	ld l,c
	add a,l
	ld l,c
	adc a,h
	ld l,c
	sub e
	ld l,c
	and 069h
	ret p
	ld l,c
	rst 30h
	ld l,c
	ld (bc),a
	ld l,d
	ex af,af'
	ld l,d
	ld (de),a
	ld l,d
	dec l
	ld l,d
	inc a
	ld l,d
	ld b,d
	ld l,d
	ld c,b
	ld l,d
	ld c,(hl)
	ld l,d
	ld e,b
	ld l,d
	ld h,e
	ld l,d
	ld a,l
	ld l,d
	adc a,b
	ld l,d
	sub b
	ld l,d
	xor d
	ld l,d
	cp a
	ld l,d
	jp nz,0e16ah
l68e2h:
	res 6,(ix+00eh)
	ld a,(hl)
	and 003h
	ld (ix+00dh),a
	ld b,a
	inc hl
	ld a,(hl)
	ld (ix+013h),a
	ld a,b
	or a
	ret nz
	dec hl
	ret
	pop hl
	ld a,(0e1e4h)
	cp 004h
	ld a,(0e1e7h)
	jr nz,l690bh
	set 0,a
	res 1,a
	ld (0e1e7h),a
	jr l68e2h
l690bh:
	set 2,a
	res 3,a
	ld (0e1e7h),a
	jr l68e2h
	pop hl
	inc hl
	ld a,(hl)
	and 01fh
	ld b,a
	ld a,(0e1e4h)
	cp 004h
	ld a,b
	jr nz,l6930h
	ld (0e1e5h),a
	ld a,(0e1e7h)
	set 0,a
	res 1,a
	ld (0e1e7h),a
	ret
l6930h:
	ld (0e1e6h),a
	ld a,(0e1e7h)
	set 2,a
	res 3,a
	ld (0e1e7h),a
	ret
	pop hl
	inc hl
	res 3,(ix+00dh)
	ld a,(hl)
	ld (0e1e8h),a
	ld de,0e1e7h
	ld a,(de)
	set 5,a
	ld (de),a
	jp l6953h
	pop hl
l6953h:
	inc hl
	ld a,(hl)
	ld (0e1eah),a
	ld de,0e1e7h
	ld a,(de)
	set 6,a
	ld (de),a
	jp l6963h
	pop hl
l6963h:
	inc hl
	ld a,(hl)
	ld (0e1e9h),a
	ld de,0e1e7h
	ld a,(de)
	set 7,a
	ld (de),a
	set 2,(ix+00dh)
	ret
	pop hl
sub_6975h:
	ld de,0e1e7h
	ld a,(de)
	and 01fh
	ld (de),a
	ld a,(ix+00dh)
	and 0f3h
	ld (ix+00dh),a
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+014h),a
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+015h),a
	ret
	pop hl
	inc hl
	ld a,(ix+00fh)
	and 080h
	ld (ix+00fh),a
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	cp 008h
	jp nc,l69adh
	set 2,(ix+00fh)
l69adh:
	res 3,a
	inc a
	bit 2,(ix+00fh)
	jp nz,l69bbh
	set 1,(ix+00fh)
l69bbh:
	ld (ix+021h),a
	ld a,(hl)
	and 00fh
	cp 008h
	jp c,l69cah
	set 4,(ix+00fh)
l69cah:
	res 3,a
	inc a
	ld (ix+022h),a
	inc hl
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	ld (ix+023h),a
	ld a,(hl)
	and 00fh
	ld (ix+024h),a
	set 0,(ix+00fh)
	ret
	pop hl
	res 0,(ix+00fh)
	res 1,(ix+00fh)
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+025h),a
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+026h),a
	set 1,(ix+00eh)
	ret
	pop hl
	res 1,(ix+00eh)
	ret
	pop hl
	ld a,(ix+00eh)
	and 0e2h
	ld (ix+00eh),a
	ret
	pop hl
	inc hl
	ld a,(ix+00eh)
	or 014h
	ld (ix+00eh),a
	ld a,(hl)
	and 00fh
	ld (ix+01ch),a
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	ld (ix+01bh),a
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+01ah),a
	ld a,(ix+00eh)
	or 00ch
	ld (ix+00eh),a
	ret
	pop hl
	res 3,(ix+00eh)
	ret
	pop hl
	set 6,(ix+00eh)
	ret
	pop hl
	set 5,(ix+00eh)
	ret
	pop hl
	ld a,(ix+00eh)
	and 09fh
	ld (ix+00eh),a
	ret
	pop hl
	set 7,(ix+00eh)
	inc hl
	ld a,(hl)
	ld (ix+029h),a
	ret
	pop hl
	inc hl
	ld a,(hl)
	ld de,wave_ptr
	add a,a
	add a,e
	ld e,a
	jr nc,l6a6fh
	inc d
l6a6fh:
	ld a,(de)
	ld (ix+027h),a
	inc de
	ld a,(de)
	ld (ix+028h),a
	set 7,(ix+00fh)
	ret
	pop hl
	call sub_6a9ch
	ld (ix+007h),e
	ld (ix+008h),d
	ret
	pop hl
	ld l,(ix+007h)
	ld h,(ix+008h)
	ret
	pop hl
	inc hl
	ld a,(ix+005h)
	inc a
	cp (hl)
	jr z,l6aa3h
	ld (ix+005h),a
sub_6a9ch:
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	dec hl
	ret
l6aa3h:
	inc hl
	inc hl
	ld (ix+005h),000h
	ret
	pop hl
	inc hl
	ld a,(ix+006h)
	inc a
	cp (hl)
	jr z,l6ab8h
	ld (ix+006h),a
	jr sub_6a9ch
l6ab8h:
	inc hl
	inc hl
	ld (ix+006h),000h
	ret
	pop hl
	jr sub_6a9ch
	pop hl
	inc hl
	ld b,(ix+009h)
	ld a,(hl)
	ld (ix+009h),a
	cp 001h
	ld a,b
	jp z,l6ae8h
	cp 001h
	ret nz
	ld a,(ix+00eh)
	ld (ix+02ah),a
	ld a,(ix+00fh)
	ld (ix+02bh),a
	xor a
	ld (ix+00eh),a
	ld (ix+00fh),a
	ret
l6ae8h:
	cp 001h
	ret z
	ld a,(ix+02ah)
	ld (ix+00eh),a
	ld a,(ix+02bh)
	ld (ix+00fh),a
	ret
l6af8h:
	ld a,(hl)
	and 00fh
	cp 006h
	jr nc,l6b06h
	ld (ix+016h),a
	ld (ix+02ch),a
	ret
l6b06h:
	cp 007h
	jr z,l6b28h
	cp 008h
	jr z,l6b31h
	cp 009h
	jr z,l6b51h
	cp 00ah
	jr z,l6b5bh
	cp 00bh
	jr z,l6b62h
	cp 00ch
	jr z,l6b7eh
	cp 00dh
	jr z,l6b88h
	cp 00eh
	jr z,l6b8dh
	jr l6b93h
l6b28h:
	res 6,(ix+00dh)
	res 5,(ix+00dh)
	ret
l6b31h:
	set 6,(ix+00dh)
	set 5,(ix+00dh)
	inc hl
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	ld (ix+030h),a
	ld a,(ix+030h)
	ld (ix+031h),a
	ld a,(hl)
	and 00fh
	ld (ix+032h),a
	ret
l6b51h:
	call sub_6a9ch
	ld (ix+02dh),e
	ld (ix+02eh),d
	ret
l6b5bh:
	ld l,(ix+02dh)
	ld h,(ix+02eh)
	ret
l6b62h:
	inc hl
	ld a,(ix+005h)
	inc a
	cp (hl)
	jr z,l6b78h
	ld (ix+005h),a
	inc hl
	ld a,(hl)
	ld e,a
	ld a,l
	sub e
	ld l,a
	jr nc,l6b76h
	dec h
l6b76h:
	dec hl
	ret
l6b78h:
	inc hl
	ld (ix+005h),000h
	ret
l6b7eh:
	set 7,(ix+00dh)
	inc hl
	ld a,(hl)
	ld (ix+02fh),a
	ret
l6b88h:
	res 7,(ix+00dh)
	ret
l6b8dh:
	inc hl
	ld a,(hl)
	ld (ix+001h),a
	ret
l6b93h:
	res 7,(ix+00eh)
	ret
sub_6b98h:
	call sub_6b9fh
	call sub_6c90h
	ret
sub_6b9fh:
	call sub_6bafh
	call sub_6bc6h
	call sub_6bfbh
	call sub_6c22h
	call sub_6c50h
	ret
sub_6bafh:
	ld hl,0e00dh
	ld a,(hl)
	and 001h
	jr z,l6bc5h
	ld hl,0e073h
	ld a,(hl)
	and 001h
	jr z,l6bc5h
	ld hl,0e00dh
	ld a,002h
	ld (hl),a
l6bc5h:
	ret
sub_6bc6h:
	ld b,000h
	ld c,008h
	ld hl,0e00ah
	call sub_6bddh
	ld hl,0e03dh
	call sub_6bddh
	ld hl,0e070h
	call sub_6bddh
	ret
sub_6bddh:
	ld e,(hl)
	ld a,b
	call WRTPSG
	inc hl
	inc b
	ld e,(hl)
	ld a,b
	call WRTPSG
	inc hl
	ld e,(hl)
	ld a,c
	inc b
	inc c
	inc hl
	bit 3,(hl)
	ret nz
	call WRTPSG
	bit 2,(hl)
	ret z
	set 3,(hl)
	ret
sub_6bfbh:
	ld hl,0e1e7h
	bit 0,(hl)
	jr z,l6c0eh
	res 0,(hl)
	set 1,(hl)
	ld a,(0e1e5h)
	ld e,a
	ld a,006h
	jr l6c1eh
l6c0eh:
	bit 1,(hl)
	ret nz
	bit 2,(hl)
	ret z
	res 2,(hl)
	set 3,(hl)
	ld a,(0e1e6h)
	ld e,a
	ld a,006h
l6c1eh:
	call WRTPSG
	ret
sub_6c22h:
	ld hl,0e1e7h
	bit 7,(hl)
	ret z
	res 7,(hl)
	ld a,(0e1e9h)
	ld e,a
	ld a,00bh
	call WRTPSG
	bit 6,(hl)
	ret z
	res 6,(hl)
	ld a,(0e1eah)
	ld e,a
	ld a,00ch
	call WRTPSG
	bit 5,(hl)
	ret z
	res 5,(hl)
	ld a,(0e1e8h)
	ld e,a
	ld a,00dh
	call WRTPSG
	ret
sub_6c50h:
	ld hl,0e00dh
	ld a,(hl)
	ld hl,l6c84h
	call sub_6c7dh
	ld b,(hl)
	ld hl,0e040h
	ld a,(hl)
	ld hl,l6c88h
	call sub_6c7dh
	ld c,(hl)
	ld hl,0e073h
	ld a,(hl)
	ld hl,l6c8ch
	call sub_6c7dh
	ld a,(hl)
	or b
	or c
sub_6c73h:
	ld e,a
	ld (0e1e3h),a
	ld a,007h
	call WRTPSG
	ret
sub_6c7dh:
	and 003h
	ld e,a
	ld d,000h
	add hl,de
	ret
l6c84h:
	adc a,c
	add a,c
	adc a,b
	add a,b
l6c88h:
	sub d
	add a,d
	sub b
	add a,b
l6c8ch:
	and h
	add a,h
	and b
	add a,b
sub_6c90h:
	call sub_6c9dh
	call sub_6da2h
	call sub_6df4h
	call sub_6ebbh
	ret
sub_6c9dh:
	ld ix,0e1ebh
	ld bc,0e1f7h
	ld de,0e1edh
	ld hl,0e0a3h
	ld a,(de)
	res 0,(ix+000h)
	cp (hl)
	jr z,l6cb8h
	set 0,(ix+000h)
	ld a,(hl)
	ld (de),a
l6cb8h:
	inc de
	inc hl
	ld a,(de)
	res 1,(ix+000h)
	cp (hl)
	jr z,l6cc8h
	set 1,(ix+000h)
	ld a,(hl)
	ld (de),a
l6cc8h:
	inc de
	inc hl
	res 2,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,l6cd8h
	set 2,(ix+001h)
	ld a,(hl)
	ld (bc),a
l6cd8h:
	inc bc
	ld hl,0e0d6h
	ld a,(de)
	res 2,(ix+000h)
	cp (hl)
	jr z,l6ceah
	set 2,(ix+000h)
	ld a,(hl)
	ld (de),a
l6ceah:
	inc de
	inc hl
	ld a,(de)
	res 3,(ix+000h)
	cp (hl)
	jr z,l6cfah
	set 3,(ix+000h)
	ld a,(hl)
	ld (de),a
l6cfah:
	inc de
	inc hl
	res 3,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,l6d0ah
	set 3,(ix+001h)
	ld a,(hl)
	ld (bc),a
l6d0ah:
	inc bc
	ld hl,0e109h
	ld a,(de)
	res 4,(ix+000h)
	cp (hl)
	jr z,l6d1ch
	set 4,(ix+000h)
	ld a,(hl)
	ld (de),a
l6d1ch:
	inc de
	inc hl
	ld a,(de)
	res 5,(ix+000h)
	cp (hl)
	jr z,l6d2ch
	set 5,(ix+000h)
	ld a,(hl)
	ld (de),a
l6d2ch:
	inc de
	inc hl
	res 4,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,l6d3ch
	set 4,(ix+001h)
	ld a,(hl)
	ld (bc),a
l6d3ch:
	inc bc
	ld hl,0e13ch
	ld a,(de)
	res 6,(ix+000h)
	cp (hl)
	jr z,l6d4eh
	set 6,(ix+000h)
	ld a,(hl)
	ld (de),a
l6d4eh:
	inc de
	inc hl
	ld a,(de)
	res 7,(ix+000h)
	cp (hl)
	jr z,l6d5eh
	set 7,(ix+000h)
	ld a,(hl)
	ld (de),a
l6d5eh:
	inc de
	inc hl
	res 5,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,l6d6eh
	set 5,(ix+001h)
	ld a,(hl)
	ld (bc),a
l6d6eh:
	inc bc
	ld hl,0e16fh
	ld a,(de)
	res 0,(ix+001h)
	cp (hl)
	jr z,l6d80h
	set 0,(ix+001h)
	ld a,(hl)
	ld (de),a
l6d80h:
	inc de
	inc hl
	ld a,(de)
	res 1,(ix+001h)
	cp (hl)
	jr z,l6d90h
	set 1,(ix+001h)
	ld a,(hl)
	ld (de),a
l6d90h:
	inc de
	inc hl
	res 6,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,l6da0h
	set 6,(ix+001h)
	ld a,(hl)
	ld (bc),a
l6da0h:
	inc bc
	ret
sub_6da2h:
	ld e,000h
	ld hl,0e0a6h
	ld c,001h
	ld a,(hl)
	or a
	jr z,l6daeh
	ld a,c
l6daeh:
	or e
	ld e,a
	ld hl,0e0d9h
	sla c
	ld a,(hl)
	or a
	jr z,l6dbah
	ld a,c
l6dbah:
	or e
	ld e,a
	ld hl,0e10ch
	sla c
	ld a,(hl)
	or a
	jr z,l6dc6h
	ld a,c
l6dc6h:
	or e
	ld e,a
	ld hl,0e13fh
	sla c
	ld a,(hl)
	or a
	jr z,l6dd2h
	ld a,c
l6dd2h:
	or e
	ld e,a
	ld hl,0e172h
	sla c
	ld a,(hl)
	or a
	jr z,l6ddeh
	ld a,c
l6ddeh:
	or e
	ld e,a
	ld hl,0e1fch
	ld a,(hl)
	cp e
	jr z,l6deeh
	ld (hl),e
	ld hl,0e1ech
	set 7,(hl)
	ret
l6deeh:
	ld hl,0e1ech
	res 7,(hl)
	ret
sub_6df4h:
	ld ix,0e1ebh
	ld hl,0e1edh
	ld de,09880h
	bit 0,(ix+000h)
	jr z,l6e07h
	call sub_6each
l6e07h:
	inc hl
	inc de
	bit 1,(ix+000h)
	jr z,l6e12h
	call sub_6each
l6e12h:
	inc hl
	inc de
	bit 2,(ix+000h)
	jr z,l6e1dh
	call sub_6each
l6e1dh:
	inc hl
	inc de
	bit 3,(ix+000h)
	jr z,l6e28h
	call sub_6each
l6e28h:
	inc hl
	inc de
	bit 4,(ix+000h)
	jr z,l6e33h
	call sub_6each
l6e33h:
	inc hl
	inc de
	bit 5,(ix+000h)
	jr z,l6e3eh
	call sub_6each
l6e3eh:
	inc hl
	inc de
	bit 6,(ix+000h)
	jr z,l6e49h
	call sub_6each
l6e49h:
	inc hl
	inc de
	bit 7,(ix+000h)
	jr z,l6e54h
	call sub_6each
l6e54h:
	inc hl
	inc de
	bit 0,(ix+001h)
	jr z,l6e5fh
	call sub_6each
l6e5fh:
	inc hl
	inc de
	bit 1,(ix+001h)
	jr z,l6e6ah
	call sub_6each
l6e6ah:
	inc hl
	inc de
	bit 2,(ix+001h)
	jr z,l6e75h
	call sub_6each
l6e75h:
	inc hl
	inc de
	bit 3,(ix+001h)
	jr z,l6e80h
	call sub_6each
l6e80h:
	inc hl
	inc de
	bit 4,(ix+001h)
	jr z,l6e8bh
	call sub_6each
l6e8bh:
	inc hl
	inc de
	bit 5,(ix+001h)
	jr z,l6e96h
	call sub_6each
l6e96h:
	inc hl
	inc de
	bit 6,(ix+001h)
	jr z,l6ea1h
	call sub_6each
l6ea1h:
	inc hl
	inc de
	bit 7,(ix+001h)
	ret z
	call sub_6each
	ret
sub_6each:
	ld a,(hl)
	ld c,a
	ld a,03fh
	ld (09000h),a
	ld a,c
	ld (de),a
	ld a,005h
	ld (09000h),a
	ret
sub_6ebbh:
	ld hl,0e0a8h
	bit 7,(hl)
	jr z,l6ed1h
	res 7,(hl)
	ld hl,0e0c0h
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09800h
	call sub_6f0fh
l6ed1h:
	ld hl,0e0dbh
	bit 7,(hl)
	jr z,l6ee7h
	res 7,(hl)
	ld hl,0e0f3h
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09820h
	call sub_6f0fh
l6ee7h:
	ld hl,0e10eh
	bit 7,(hl)
	jr z,l6efdh
	res 7,(hl)
	ld hl,0e126h
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09840h
	call sub_6f0fh
l6efdh:
	ld hl,0e141h
	bit 7,(hl)
	ret z
	res 7,(hl)
	ld hl,0e159h
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09860h
sub_6f0fh:
	ld a,03fh
	ld (09000h),a
	xor a
	ld (0988fh),a
	ld b,020h
l6f1ah:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz l6f1ah
	ld hl,0988fh
	ld de,0e1fch
	ld a,(de)
	ld (hl),a
	ld a,005h
	ld (09000h),a           ; 32 00 90 — 90 is sound_ptr id 0 low
	ret                     ; C9 is id 0 high (unused)

; BLOCK 'sound_ptr' (start 0x6f2e end 0x6fb0)
sound_ptr_start:
	defw psg_01
	defw psg_02
	defw psg_03
	defw psg_04
	defw psg_05
	defw psg_06
	defw psg_07
	defw psg_08
	defw psg_09
	defw psg_0a
	defw psg_0b
	defw psg_0c
	defw psg_0d
	defw psg_0e
	defw psg_0f
	defw psg_10
	defw psg_11
	defw psg_12
	defw psg_13
	defw psg_14
	defw psg_15
	defw psg_16
	defw psg_17
	defw psg_18
	defw psg_19
	defw psg_1a
	defw psg_1b
	defw psg_1c
	defw psg_1d
	defw psg_1e
	defw psg_1f
	defw psg_20
	defw psg_21
	defw psg_22
	defw psg_23
	defw psg_24
	defw psg_25
	defw psg_26
	defw psg_27
	defw psg_28
	defw psg_29
	defw psg_2a
	defw psg_2b
	defw psg_2c
	defw psg_2d
	defw psg_2e
	defw psg_2f
	defw psg_30
	defw psg_31
	defw psg_32
	defw psg_33
	defw psg_34
	defw psg_35
	defw psg_36
	defw psg_37
	defw psg_38
	defw psg_39
	defw psg_3a
	defw psg_3b
	defw psg_3c
	defw psg_3d
	defw psg_3e
	defw psg_3f
	defw psg_40
	defw psg_41

sound_ptr_end:

; BLOCK 'psg_payload' (start 0x6fb0 end 0x8000)
psg_payload_start:
	INCLUDE "banks/data/psg_hdr.asm"
	INCLUDE "banks/data/psg_wave.asm"
	INCLUDE "banks/data/psg_env.asm"
	INCLUDE "banks/data/psg04.asm"
psg_payload_end:
; --- bank 05 @ 0x8000 ---
	INCLUDE "banks/data/psg05.asm"
; --- bank 06 @ 0xA000 ---
	INCLUDE "banks/data/psg06.asm"
	ds 591, 0ffh
