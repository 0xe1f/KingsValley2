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
	ld hl,0e1ebh            ; SCC dirty
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld de,0e1eeh
	ld (hl),001h
	ld bc,0000eh
	ldir
	call scc_put
	ld a,03fh               ; SCC enable
	ld (09000h),a           ; mapper 8000
	xor a
	ld (0988fh),a           ; SCC on/off
	ld a,002h
	ld (09000h),a           ; mapper 8000
	ld a,0bfh
	ld (0e1e3h),a           ; AY mixer
	ld e,a
	ld a,007h
	jp WRTPSG
; packed-PSG id in A; 0x80-84 special
sound_play:
	ld c,a
	cp 082h
	jp z,id_82
	cp 083h
	jp z,id_83
	cp 084h
	jp z,id_84
	cp 080h
	jp z,id_80
	cp 081h
	call z,id_81
	ld hl,0e1cch            ; last sound id
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
	ld de,0e1cdh            ; packed flags
	ld bc,00012h            ; 18-byte window; packed headers may be shorter
	ldir
	ld ix,0e1cfh            ; header ch ptrs
	ld hl,0e1cdh            ; packed flags
	bit 7,(hl)
	jr z,play_b6
	push ix
	ld ix,0e000h            ; slot 0 AY A
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e001h            ; slot 0 priority
	call ch_load
	inc ix
	inc ix
play_b6:
	ld hl,0e1cdh            ; packed flags
	bit 6,(hl)
	jr z,play_b5
	push ix
	ld ix,0e033h            ; slot 1 AY B
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e034h            ; slot 1 priority
	call ch_load
	inc ix
	inc ix
play_b5:
	ld hl,0e1cdh            ; packed flags
	bit 5,(hl)
	jr z,play_b4
	push ix
	ld ix,0e066h            ; slot 2 AY C
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e067h            ; slot 2 priority
	call ch_load
	inc ix
	inc ix
play_b4:
	ld hl,0e1cdh            ; packed flags
	bit 4,(hl)
	jr z,play_b3
	push ix
	ld ix,0e099h            ; slot 3 SCC 0
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e09ah            ; slot 3 priority
	call ch_load
	inc ix
	inc ix
play_b3:
	ld hl,0e1cdh            ; packed flags
	bit 3,(hl)
	jr z,play_b2
	push ix
	ld ix,0e0cch            ; slot 4 SCC 1
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e0cdh            ; slot 4 priority
	call ch_load
	inc ix
	inc ix
play_b2:
	ld hl,0e1cdh            ; packed flags
	bit 2,(hl)
	jr z,play_b1
	push ix
	ld ix,0e0ffh            ; slot 5 SCC 2
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e100h            ; slot 5 priority
	call ch_load
	inc ix
	inc ix
play_b1:
	ld hl,0e1cdh            ; packed flags
	bit 1,(hl)
	jr z,play_b0
	push ix
	ld ix,0e132h            ; slot 6 SCC 3
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e133h            ; slot 6 priority
	call ch_load
	inc ix
	inc ix
play_b0:
	ld hl,0e1cdh            ; packed flags
	bit 0,(hl)
	ret z
	push ix
	ld ix,0e165h            ; slot 7 SCC 4
	call slot_clr
	pop ix
	inc hl
	ld a,(hl)
	ld hl,0e166h            ; slot 7 priority
; copy 46-byte template into the slot if id >= current
ch_load:
	ld b,(hl)
	cp b
	ret c
	ex de,hl
	ld (de),a
	dec de
	ld hl,0e1cch            ; last sound id
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
	ld hl,ch_init
	ld bc,0002eh
	ldir
	ret
ch_init:
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
	ld hl,0e1cbh            ; sound flags
	set 4,(hl)
	res 0,(hl)
	ld hl,0e1e1h            ; fade vol
	ld (hl),000h
	inc hl
	ld (hl),009h
	ret
id_82:
	ld hl,0e1cbh            ; sound flags
	res 0,(hl)
	jr id_vol0
id_83:
	ld hl,0e1dfh            ; fade timer
	ld (hl),025h
	inc hl
	ld (hl),00ah
	jp id_fade
id_84:
	ld hl,0e1dfh            ; fade timer
	ld (hl),025h
	inc hl
	ld (hl),00ah
id_fade:
	ld hl,0e1cbh            ; sound flags
	set 0,(hl)
	res 4,(hl)
id_vol0:
	ld hl,0e1e1h            ; fade vol
	xor a
	ld (hl),a
	inc hl
	ld (hl),a
	ret
id_80:
	ld hl,0e1cbh            ; sound flags
	bit 1,(hl)
	ld b,000h
	jr nz,id80_b
	ld b,001h
id80_b:
	res 1,(hl)
	bit 3,(hl)
	jr z,id80_go
	res 3,(hl)
	set 0,(hl)
id80_go:
	ld hl,0e198h            ; SCC stash
	ld de,0e099h            ; slot 3 SCC 0
	call slot_copy
	ld a,(0e00dh)           ; AY A flags
	ld e,a
	ld a,(0e1feh)           ; stashed mixer
	and 00fh
	or e
	ld (0e00dh),a           ; AY A flags
	ld a,(0e040h)           ; AY B flags
	ld e,a
	ld a,(0e1feh)           ; stashed mixer
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	or e
	ld (0e040h),a           ; AY B flags
	ld a,(0e073h)           ; AY C flags
	ld e,a
	ld a,(0e1ffh)           ; stashed mixer C
	and 00fh
	or e
	ld (0e073h),a           ; AY C flags
	ld a,03fh               ; SCC enable
	ld (09000h),a           ; mapper 8000
	ld a,(0e1fch)           ; SCC enable
	ld (0988fh),a           ; SCC on/off
	ld a,002h
	ld (09000h),a           ; mapper 8000
	ld a,0ffh
	ld hl,0e1ebh            ; SCC dirty
	ld (hl),a
	inc hl
	ld (hl),a
	jp scc_put
; stash SCC slots and mute
id_81:
	ld hl,0e1cbh            ; sound flags
	bit 1,(hl)
	ld b,000h
	jr z,id81_b
	ld b,001h
id81_b:
	set 1,(hl)
	bit 0,(hl)
	jr z,id81_go
	res 0,(hl)
	set 3,(hl)
id81_go:
	ld hl,0e099h            ; slot 3 SCC 0
	ld de,0e198h            ; SCC stash
	call slot_copy
	ld a,(0e00dh)           ; AY A flags
	ld d,a
	and 00fh
	ld (0e1feh),a           ; stashed mixer
	ld a,d
	and 0f0h
	ld (0e00dh),a           ; AY A flags
	ld a,(0e040h)           ; AY B flags
	ld d,a
	and 00fh
	rlca
	rlca
	rlca
	rlca
	ld e,a
	ld a,(0e1feh)           ; stashed mixer
	and e
	ld (0e1feh),a           ; stashed mixer
	ld a,d
	and 0f0h
	ld (0e040h),a           ; AY B flags
	ld a,(0e073h)           ; AY C flags
	ld d,a
	and 00fh
	ld (0e1ffh),a           ; stashed mixer C
	ld a,d
	and 0f0h
	ld (0e073h),a           ; AY C flags
	ld a,(0e00ch)           ; AY A vol
	res 4,a
	ld (0e00ch),a           ; AY A vol
	ld a,(0e03fh)           ; AY B vol
	res 4,a
	ld (0e03fh),a           ; AY B vol
	ld a,(0e072h)           ; AY C vol
	res 4,a
	ld (0e072h),a           ; AY C vol
	ld a,03fh               ; SCC enable
	ld (09000h),a           ; mapper 8000
	ld a,(0e1fch)           ; SCC enable
	and 0feh
	ld (0988fh),a           ; SCC on/off
	xor a
	ld (0988bh),a           ; SCC vol
	ld (0988ch),a           ; SCC vol
	ld (0988dh),a           ; SCC vol
	ld (0988eh),a           ; SCC vol
	ld a,002h
	ld (09000h),a           ; mapper 8000
	ld a,b
	or a
	ret nz
	ld c,002h
	ret
; copy one channel slot (0x33 bytes)
slot_copy:
	ld bc,00033h
	ldir
	ret
; clear vibrato / env temps
slot_clr:
	ld (ix+01ah),000h
	ld (ix+01bh),000h
	ld (ix+01ch),000h
	ld (ix+01dh),000h
	ld (ix+01eh),000h
	ld (ix+026h),000h
	ret
sound_tick:
	ld a,(0e1e3h)           ; AY mixer
	call mix_wr
	ld a,(0fda2h)           ; JIFFY
	ld hl,0e1fdh            ; tick sync
	cp (hl)
	jr z,tick_sync
	ld ix,0e099h            ; slot 3 SCC 0
	set 7,(ix+00fh)
	ld ix,0e0cch            ; slot 4 SCC 1
	set 7,(ix+00fh)
	ld ix,0e0ffh            ; slot 5 SCC 2
	set 7,(ix+00fh)
	ld ix,0e132h            ; slot 6 SCC 3
	set 7,(ix+00fh)
	ld a,(0fda2h)           ; JIFFY
	ld (hl),a
tick_sync:
	inc (hl)
	ld a,(hl)
	ld (0fda2h),a           ; JIFFY
	ld hl,0e1cbh            ; sound flags
	bit 1,(hl)
	jp nz,tick_paused
	ld a,(0e1cbh)           ; sound flags
	bit 0,a
	call nz,fade_tick
	ld a,(0e1cbh)           ; sound flags
	bit 4,a
	call nz,fade4_tick
	ld a,001h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e000h            ; slot 0 AY A
	call ch_tick
	ld a,002h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e033h            ; slot 1 AY B
	call ch_tick
	ld a,004h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e066h            ; slot 2 AY C
	call ch_tick
	ld a,008h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e099h            ; slot 3 SCC 0
	call ch_tick
	ld a,010h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e0cch            ; slot 4 SCC 1
	call ch_tick
	ld a,020h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e0ffh            ; slot 5 SCC 2
	call ch_tick
	ld a,040h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e132h            ; slot 6 SCC 3
	call ch_tick
	ld a,080h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e165h            ; slot 7 SCC 4
	call ch_tick
	call hw_out
	ret
; tick one 0x33-byte channel slot if live
ch_tick:
	ld a,(ix+000h)
	or a
	call nz,ch_byte
	ret
tick_paused:
	ld a,008h
	ld (0e1e4h),a           ; ch mask
	ld ix,0e099h            ; slot 3 SCC 0
	call ch_tick
	ld a,0bfh
	ld (0e1e3h),a           ; AY mixer
	call mixer_clr
	call hw_out
	ret
; wait counter then op_next
ch_byte:
	dec (ix+004h)
	jp nz,wait_tick
	bit 6,(ix+00dh)
	jr z,wait_bit
	set 5,(ix+00dh)
wait_bit:
	ld l,(ix+002h)
	ld h,(ix+003h)
; next stream byte; 0xFF stop, 0xD0+ opcode
op_next:
	ld a,(hl)
	cp 0ffh
	jp z,ch_stop
	cp 0d0h
	jr c,op_kind
	call op_exec
	inc hl
	jp op_next
op_kind:
	bit 0,(ix+009h)
	jp nz,op_note
	bit 1,(ix+009h)
	jp nz,op_tone
	ld a,(ix+009h)
	and 01ch
	jp nz,op_tbl
	ret
; note nibble to period / duration
op_note:
	ld a,(hl)
	and 00fh
	ld b,a
	ld a,(ix+014h)
	jr z,dur_put
	ld e,a
dur_add:
	add a,e
	djnz dur_add
dur_put:
	ld (ix+004h),a
	ld a,(hl)
	and 0f0h
	rrca
	rrca
	rrca
	rrca
	call ptr_adv
	bit 7,(ix+009h)
	ret nz
	cp 00ch
	jr nc,note_skip
	ld hl,note_oct
	ld e,a
	ld d,000h
	add hl,de
	ld l,(hl)
	ld h,000h
	ld a,(ix+016h)
	or a
	jr z,pitch_put
	bit 7,(ix+00dh)
	jr z,oct_do
	ld a,(ix+02fh)
	ld b,a
	ld a,(ix+016h)
	sub b
	jr z,pitch_put
	jr c,pitch_put
oct_do:
	ld b,a
oct_shl:
	add hl,hl
	djnz oct_shl
pitch_put:
	ld (ix+010h),l
	ld (ix+011h),h
	ld e,(ix+015h)
	ld a,(0e1cbh)           ; sound flags
	and 011h
	call nz,fade_vol
	ld (ix+012h),e
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	set 1,(ix+00dh)
	call note_on
	ret
note_skip:
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	ret
note_oct:
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
	jr c,nibble_hi
op_tone:
	ld a,(ix+00dh)
	and 003h
	jr z,dur_hold
	cp 001h
	jr z,tone_n
	ld a,(hl)
	bit 6,(ix+00eh)
	jr nz,tone_lo
	bit 5,(ix+00eh)
	jr nz,tone_mid
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
	jr vol_put
tone_lo:
	ld (ix+010h),a
	jr vol_go
tone_mid:
	and 0f0h
	rrca
nibble_hi:
	rrca
	rrca
	rrca
	ld b,a
	ld a,(hl)
	and 00fh
	ld (ix+011h),a
	jr vol_put
tone_n:
	ld a,(hl)
	and 00fh
	ld b,a
vol_put:
	ld a,(0e1e4h)           ; ch mask
	cp 008h
	jr nc,vol_scc
	bit 2,(ix+00dh)
	jr z,vol_scc
	ld b,010h
vol_scc:
	inc b
	inc b
	ld (ix+012h),b
vol_go:
	ld e,(ix+012h)
	ld a,(0e1cbh)           ; sound flags
	and 011h
	call nz,fade_vol
	ld (ix+012h),e
	call note_on
dur_hold:
	bit 7,(ix+009h)
	ret nz
	call ptr_adv
	ld a,(ix+013h)
	ld (ix+004h),a
	ret
op_tbl:
	set 7,(ix+009h)
	call op_note
	ld b,a
	call env_pick
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
; phrase table as nested stream
tbl_run:
	set 1,(ix+009h)
	call op_next
	res 1,(ix+009h)
	res 7,(ix+009h)
	ld a,(ix+013h)
	ld (ix+019h),a
	inc hl
	ld (ix+017h),l
	ld (ix+018h),h
	set 0,(ix+00eh)
	ret
; env_0..env_5 from ix+2C
env_pick:
	bit 2,(ix+009h)
	jp nz,pick_01
	bit 3,(ix+009h)
	jp nz,pick_23
	bit 4,(ix+009h)
	jp nz,pick_45
pick_01:
	ld a,(ix+02ch)
	cp 000h
	jp z,use_env0
	cp 001h
	jp z,use_env1
use_env0:
	ld hl,env_0
	ret
use_env1:
	ld hl,env_1
	ret
pick_23:
	ld a,(ix+02ch)
	cp 000h
	jp z,use_env2
	cp 001h
	jp z,use_env3
use_env2:
	ld hl,env_2
	ret
use_env3:
	ld hl,env_3
	ret
pick_45:
	ld a,(ix+02ch)
	cp 000h
	jp z,use_env4
	cp 001h
	jp z,use_env5
use_env4:
	ld hl,env_4
	ret
use_env5:
	ld hl,env_5
	ret
; pitch and volume into the slot
note_on:
	call pitch_out
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
	jr z,vol_base
	ld e,(ix+029h)
	sub e
	call m,vol_clamp
vol_base:
	ld (ix+00ch),a
	ld a,(0e1e4h)           ; ch mask
	cp 008h
	jr nc,vol_alt
	bit 2,(ix+00dh)
	ret nz
vol_alt:
	bit 1,(ix+00fh)
	ret z
	ld a,(ix+025h)
	ld (ix+00ch),a
	res 2,(ix+00fh)
	ret
; floor volume at 0
vol_clamp:
	xor a
	ret
wait_tick:
	bit 0,(ix+00eh)
	jp nz,phrase
	bit 6,(ix+00dh)
	call nz,slide
	bit 2,(ix+00eh)
	call nz,vib_tick
	bit 0,(ix+00fh)
	call nz,env_tick
	ret
phrase:
	dec (ix+019h)
	ret nz
	ld l,(ix+017h)
	ld h,(ix+018h)
	ld a,(hl)
	cp 0ffh
	jr z,phrase_end
	set 7,(ix+009h)
	call tbl_run
	ret
phrase_end:
	res 0,(ix+00eh)
	xor a
	ld (ix+00ch),a
	ld a,(ix+00dh)
	and 0f0h
	ld (ix+00dh),a
	ret
; ix+10/11 to period bytes
pitch_out:
	ld e,(ix+010h)
	ld d,(ix+011h)
	bit 1,(ix+00eh)
	jr z,pitch_st
	ld a,(ix+026h)
	add a,e
	ld e,a
	jr nc,pitch_st
	inc d
pitch_st:
	ld (ix+00ah),e
	ld (ix+00bh),d
	ret
; vibrato
vib_tick:
	inc (ix+01eh)
	ld a,(ix+01eh)
	ld b,(ix+00eh)
	bit 4,b
	jr nz,vib_b
	bit 3,b
	jr z,vib_b
	cp (ix+01ah)
	ret nz
	ld (ix+01eh),000h
	set 4,(ix+00eh)
	jr vib_apply
vib_b:
	cp (ix+01bh)
	ret nz
vib_apply:
	ld e,(ix+00ah)
	ld d,(ix+00bh)
	ld b,(ix+01ch)
	ld a,(ix+01dh)
	cpl
	ld (ix+01dh),a
	and a
	ld a,e
	jr nz,vib_sub
	add a,b
	ld e,a
	jr nc,vib_put
	inc d
	jr vib_put
vib_sub:
	sub b
	ld e,a
	jr nc,vib_put
	dec d
vib_put:
	ld (ix+00ah),e
	ld (ix+00bh),d
	ld (ix+01eh),000h
	ret
; volume envelope
env_tick:
	ld a,(0e1e4h)           ; ch mask
	cp 008h
	jr nc,env_go
	bit 2,(ix+00dh)
	ret nz
env_go:
	call env_step
	ld (ix+00ch),e
	ret
; advance envelope pointer
env_step:
	ld e,(ix+00ch)
	inc (ix+01fh)
	ld b,(ix+01fh)
	ld a,(ix+024h)
	cp (ix+004h)
	call nc,env_kill
	bit 5,(ix+00fh)
	jr nz,env_idle
	bit 3,(ix+00fh)
	jr nz,env_sus
	bit 2,(ix+00fh)
	jr nz,env_down
	ld a,e
	inc a
	ld e,a
	cp (ix+012h)
	ret c
	set 2,(ix+00fh)
	ld e,(ix+012h)
	ld (ix+01fh),000h
	ret
env_down:
	ld a,e
	dec a
	jp m,env_d2
	ld e,a
env_d2:
	ld a,b
	cp (ix+021h)
	ret c
	ld (ix+01fh),000h
	set 3,(ix+00fh)
	ret
env_sus:
	bit 4,(ix+00fh)
	jp nz,env_rel
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
env_rel:
	ld a,(ix+022h)
	ld d,a
	ld a,e
	sub d
	ld e,000h
	jp m,env_r2
	ld e,a
env_r2:
	ld a,b
	cp (ix+023h)
	ret nz
	set 5,(ix+00fh)
	ret
env_idle:
	ld a,(ix+004h)
	cp (ix+024h)
	ret nc
	ld a,e
	dec a
	ret m
	ld e,a
	ret
; end envelope
env_kill:
	set 5,(ix+00fh)
	ret
; portamento
slide:
	nop
	bit 5,(ix+00dh)
	ret z
	bit 3,(ix+031h)
	jr z,slide_up
	dec (ix+030h)
	bit 3,(ix+030h)
	jr z,slide_end
	ld a,(ix+030h)
	sub 008h
	ld b,a
	dec b
	ld a,(ix+032h)
	ld e,a
slide_mul:
	add a,e
	djnz slide_mul
	ld e,a
	ld d,000h
	ld l,(ix+010h)
	ld h,(ix+011h)
	sbc hl,de
	jr slide_put
slide_up:
	ld a,(ix+030h)
	or a
	jr z,slide_end
	dec (ix+030h)
	ld a,(ix+030h)
	or a
	jr z,slide_end
	ld b,a
	ld a,(ix+032h)
	ld hl,00000h
	ld d,000h
slide_add:
	ld e,a
	add hl,de
	djnz slide_add
	ld e,(ix+010h)
	ld d,(ix+011h)
	add hl,de
slide_put:
	ld (ix+00ah),l
	ld (ix+00bh),h
	ret
slide_end:
	res 5,(ix+00dh)
	ld e,(ix+010h)
	ld d,(ix+011h)
	ld (ix+00ah),e
	ld (ix+00bh),d
	ld a,(ix+031h)
	ld (ix+030h),a
	ret
; advance stream by A
ptr_adv:
	inc hl
	ld (ix+002h),l
	ld (ix+003h),h
	ret
; id 83/84 fade
fade_tick:
	ld de,0e1dfh            ; fade timer
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	ld hl,0e1e1h            ; fade vol
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
	ld hl,0e1cbh            ; sound flags
	res 0,(hl)
	xor a
	ld hl,0e1e1h            ; fade vol
	ld (hl),a
	inc hl
	ld (hl),a
	ld a,(0e033h)           ; slot 1 AY B
	ld e,a
	ld a,(0e066h)           ; slot 2 AY C
	cp e
	jr nz,fade_psg
	ld ix,0e066h            ; slot 2 AY C
	call ch_stop
	ld ix,0e099h            ; slot 3 SCC 0
	call ch_stop
fade_psg:
	ld de,00033h
	ld ix,0e000h            ; slot 0 AY A
	call ch_stop
	add ix,de
	call ch_stop
	ld ix,0e0cch            ; slot 4 SCC 1
	call ch_stop
	add ix,de
	call ch_stop
	add ix,de
	call ch_stop
	add ix,de
	call ch_stop
	ret
; apply fade to volume
fade_vol:
	ld a,(0e033h)           ; slot 1 AY B
	ld b,a
	ld a,(0e066h)           ; slot 2 AY C
	cp b
	jr z,fade_sub
	ld a,(0e1e4h)           ; ch mask
	and 0f3h
	ret z
fade_sub:
	bit 2,(ix+00dh)
	jr nz,fade_zero
	ld a,(0e1e2h)
	ld b,a
	ld a,e
	sub b
	ld e,000h
	ret m
	ld e,a
	ret
fade_zero:
	ld e,000h
	ret
; fade-4 (E1CB bit 4)
fade4_tick:
	ld hl,0e1e1h            ; fade vol
	inc (hl)
	ld a,(hl)
	cp 025h
	ret nz
	ld (hl),000h
	inc hl
	dec (hl)
	ret nz
	ld hl,0e1cbh            ; sound flags
	res 4,(hl)
	ld hl,0e1e1h            ; fade vol
	ld (hl),000h
	ret
; stream 0xFF: clear the slot
ch_stop:
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
	ld a,(0e1e4h)           ; ch mask
	cp 008h
	ret nc
	nop
	cp 004h
	ld hl,0e1e7h            ; AY dirty
	jr nz,mixer_lo
	res 0,(hl)
	res 1,(hl)
	bit 3,(hl)
	ret z
	bit 2,(hl)
	ret z
	set 2,(hl)
	res 3,(hl)
	ret
mixer_lo:
	res 2,(hl)
	res 3,(hl)
	ret
; packed-PSG opcode >= 0xD0; 0xE0+ via op_jp
op_exec:
	cp 0e0h
	jp c,op_d0
	and 01fh
	push hl
	ld hl,op_jp
	add a,a
	ld e,a
	ld d,000h
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jp (hl)
op_jp:
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
op_e0:
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
	ld a,(0e1e4h)           ; ch mask
	cp 004h
	ld a,(0e1e7h)           ; AY dirty
	jr nz,mixer_hi
	set 0,a
	res 1,a
	ld (0e1e7h),a           ; AY dirty
	jr op_e0
mixer_hi:
	set 2,a
	res 3,a
	ld (0e1e7h),a           ; AY dirty
	jr op_e0
	pop hl
	inc hl
	ld a,(hl)
	and 01fh
	ld b,a
	ld a,(0e1e4h)           ; ch mask
	cp 004h
	ld a,b
	jr nz,noise_hi
	ld (0e1e5h),a           ; noise period
	ld a,(0e1e7h)           ; AY dirty
	set 0,a
	res 1,a
	ld (0e1e7h),a           ; AY dirty
	ret
noise_hi:
	ld (0e1e6h),a           ; noise period
	ld a,(0e1e7h)           ; AY dirty
	set 2,a
	res 3,a
	ld (0e1e7h),a           ; AY dirty
	ret
	pop hl
	inc hl
	res 3,(ix+00dh)
	ld a,(hl)
	ld (0e1e8h),a           ; env shape
	ld de,0e1e7h            ; AY dirty
	ld a,(de)
	set 5,a
	ld (de),a
	jp op_e8
	pop hl
op_e8:
	inc hl
	ld a,(hl)
	ld (0e1eah),a           ; env period hi
	ld de,0e1e7h            ; AY dirty
	ld a,(de)
	set 6,a
	ld (de),a
	jp op_e9
	pop hl
op_e9:
	inc hl
	ld a,(hl)
	ld (0e1e9h),a           ; env period lo
	ld de,0e1e7h            ; AY dirty
	ld a,(de)
	set 7,a
	ld (de),a
	set 2,(ix+00dh)
	ret
	pop hl
; clear AY envelope latch
mixer_clr:
	ld de,0e1e7h            ; AY dirty
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
	jp nc,env_atk
	set 2,(ix+00fh)
env_atk:
	res 3,a
	inc a
	bit 2,(ix+00fh)
	jp nz,env_a2
	set 1,(ix+00fh)
env_a2:
	ld (ix+021h),a
	ld a,(hl)
	and 00fh
	cp 008h
	jp c,env_a3
	set 4,(ix+00fh)
env_a3:
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
	jr nc,wave_nc
	inc d
wave_nc:
	ld a,(de)
	ld (ix+027h),a
	inc de
	ld a,(de)
	ld (ix+028h),a
	set 7,(ix+00fh)
	ret
	pop hl
	call ptr_word
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
	jr z,loop1_end
	ld (ix+005h),a
; read little-endian word from stream
ptr_word:
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	dec hl
	ret
loop1_end:
	inc hl
	inc hl
	ld (ix+005h),000h
	ret
	pop hl
	inc hl
	ld a,(ix+006h)
	inc a
	cp (hl)
	jr z,loop2_end
	ld (ix+006h),a
	jr ptr_word
loop2_end:
	inc hl
	inc hl
	ld (ix+006h),000h
	ret
	pop hl
	jr ptr_word
	pop hl
	inc hl
	ld b,(ix+009h)
	ld a,(hl)
	ld (ix+009h),a
	cp 001h
	ld a,b
	jp z,flags_rst
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
flags_rst:
	cp 001h
	ret z
	ld a,(ix+02ah)
	ld (ix+00eh),a
	ld a,(ix+02bh)
	ld (ix+00fh),a
	ret
op_d0:
	ld a,(hl)
	and 00fh
	cp 006h
	jr nc,op_d_hi
	ld (ix+016h),a
	ld (ix+02ch),a
	ret
op_d_hi:
	cp 007h
	jr z,slide_off
	cp 008h
	jr z,slide_on
	cp 009h
	jr z,mark_set
	cp 00ah
	jr z,mark_go
	cp 00bh
	jr z,loop1
	cp 00ch
	jr z,oct_on
	cp 00dh
	jr z,oct_off
	cp 00eh
	jr z,pri_set
	jr dim_off
slide_off:
	res 6,(ix+00dh)
	res 5,(ix+00dh)
	ret
slide_on:
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
mark_set:
	call ptr_word
	ld (ix+02dh),e
	ld (ix+02eh),d
	ret
mark_go:
	ld l,(ix+02dh)
	ld h,(ix+02eh)
	ret
loop1:
	inc hl
	ld a,(ix+005h)
	inc a
	cp (hl)
	jr z,loop1_done
	ld (ix+005h),a
	inc hl
	ld a,(hl)
	ld e,a
	ld a,l
	sub e
	ld l,a
	jr nc,loop1_ok
	dec h
loop1_ok:
	dec hl
	ret
loop1_done:
	inc hl
	ld (ix+005h),000h
	ret
oct_on:
	set 7,(ix+00dh)
	inc hl
	ld a,(hl)
	ld (ix+02fh),a
	ret
oct_off:
	res 7,(ix+00dh)
	ret
; opcode 0xDE: next stream byte -> slot priority (ix+1)
pri_set:
	inc hl
	ld a,(hl)
	ld (ix+001h),a
	ret
; opcode 0xDF: clear volume-dim (ix+0E bit 7 / ix+29)
dim_off:
	res 7,(ix+00eh)
	ret
; AY R#0-13 then SCC 9880-988F + wavetables
hw_out:
	call psg_out
	call scc_out
	ret
; PSG: noise mutex, tone/noise/env, mixer
psg_out:
	call noise_one
	call psg_tone
	call psg_r6
	call psg_env
	call psg_mix
	ret
; if AY A and C both have noise, force A to tone-only
noise_one:
	ld hl,0e00dh            ; AY A flags
	ld a,(hl)
	and 001h
	jr z,noise_ok
	ld hl,0e073h            ; AY C flags
	ld a,(hl)
	and 001h
	jr z,noise_ok
	ld hl,0e00dh            ; AY A flags
	ld a,002h
	ld (hl),a
noise_ok:
	ret
; AY period + volume for A/B/C
psg_tone:
	ld b,000h
	ld c,008h
	ld hl,0e00ah            ; AY A period
	call psg_ch
	ld hl,0e03dh            ; AY B period
	call psg_ch
	ld hl,0e070h            ; AY C period
	call psg_ch
	ret
; one AY channel: period lo/hi (R#B,B+1), vol (R#C) unless +0D bit 3
psg_ch:
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
; AY R#6 noise period from E1E5 / E1E6
psg_r6:
	ld hl,0e1e7h            ; AY dirty
	bit 0,(hl)
	jr z,r6_alt
	res 0,(hl)
	set 1,(hl)
	ld a,(0e1e5h)           ; noise period
	ld e,a
	ld a,006h
	jr r6_wr
r6_alt:
	bit 1,(hl)
	ret nz
	bit 2,(hl)
	ret z
	res 2,(hl)
	set 3,(hl)
	ld a,(0e1e6h)           ; noise period
	ld e,a
	ld a,006h
r6_wr:
	call WRTPSG
	ret
; AY envelope period/shape R#11-13
psg_env:
	ld hl,0e1e7h            ; AY dirty
	bit 7,(hl)
	ret z
	res 7,(hl)
	ld a,(0e1e9h)           ; env period lo
	ld e,a
	ld a,00bh
	call WRTPSG
	bit 6,(hl)
	ret z
	res 6,(hl)
	ld a,(0e1eah)           ; env period hi
	ld e,a
	ld a,00ch
	call WRTPSG
	bit 5,(hl)
	ret z
	res 5,(hl)
	ld a,(0e1e8h)           ; env shape
	ld e,a
	ld a,00dh
	call WRTPSG
	ret
; AY R#7 mixer from ch A/B/C flags&3
psg_mix:
	ld hl,0e00dh            ; AY A flags
	ld a,(hl)
	ld hl,mix_a
	call mix_idx
	ld b,(hl)
	ld hl,0e040h            ; AY B flags
	ld a,(hl)
	ld hl,mix_b
	call mix_idx
	ld c,(hl)
	ld hl,0e073h            ; AY C flags
	ld a,(hl)
	ld hl,mix_c
	call mix_idx
	ld a,(hl)
	or b
	or c
; AY R#7 mixer
mix_wr:
	ld e,a
	ld (0e1e3h),a           ; AY mixer
	ld a,007h
	call WRTPSG
	ret
; flags&3 into mixer LUT
mix_idx:
	and 003h
	ld e,a
	ld d,000h
	add hl,de
	ret
; AY R#7 per channel: index flags&3 → mute / noise / tone / both
mix_a:
	defb 089h,081h,088h,080h
mix_b:
	defb 092h,082h,090h,080h
mix_c:
	defb 0a4h,084h,0a0h,080h
; SCC period/vol dirty bits, enable mask, 9880+ poke, wavetables
scc_out:
	call scc_diff
	call scc_on
	call scc_put
	call wave_out
	ret
; compare SCC slot period/vol to E1ED shadow; dirty bits in E1EB
scc_diff:
	ld ix,0e1ebh            ; SCC dirty
	ld bc,0e1f7h            ; SCC vol shadow
	ld de,0e1edh            ; SCC shadow
	ld hl,0e0a3h            ; SCC 0 period
	ld a,(de)
	res 0,(ix+000h)
	cp (hl)
	jr z,ch3_lo
	set 0,(ix+000h)
	ld a,(hl)
	ld (de),a
ch3_lo:
	inc de
	inc hl
	ld a,(de)
	res 1,(ix+000h)
	cp (hl)
	jr z,ch3_hi
	set 1,(ix+000h)
	ld a,(hl)
	ld (de),a
ch3_hi:
	inc de
	inc hl
	res 2,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,ch3_vol
	set 2,(ix+001h)
	ld a,(hl)
	ld (bc),a
ch3_vol:
	inc bc
	ld hl,0e0d6h            ; SCC 1 period
	ld a,(de)
	res 2,(ix+000h)
	cp (hl)
	jr z,ch4_lo
	set 2,(ix+000h)
	ld a,(hl)
	ld (de),a
ch4_lo:
	inc de
	inc hl
	ld a,(de)
	res 3,(ix+000h)
	cp (hl)
	jr z,ch4_hi
	set 3,(ix+000h)
	ld a,(hl)
	ld (de),a
ch4_hi:
	inc de
	inc hl
	res 3,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,ch4_vol
	set 3,(ix+001h)
	ld a,(hl)
	ld (bc),a
ch4_vol:
	inc bc
	ld hl,0e109h            ; SCC 2 period
	ld a,(de)
	res 4,(ix+000h)
	cp (hl)
	jr z,ch5_lo
	set 4,(ix+000h)
	ld a,(hl)
	ld (de),a
ch5_lo:
	inc de
	inc hl
	ld a,(de)
	res 5,(ix+000h)
	cp (hl)
	jr z,ch5_hi
	set 5,(ix+000h)
	ld a,(hl)
	ld (de),a
ch5_hi:
	inc de
	inc hl
	res 4,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,ch5_vol
	set 4,(ix+001h)
	ld a,(hl)
	ld (bc),a
ch5_vol:
	inc bc
	ld hl,0e13ch            ; SCC 3 period
	ld a,(de)
	res 6,(ix+000h)
	cp (hl)
	jr z,ch6_lo
	set 6,(ix+000h)
	ld a,(hl)
	ld (de),a
ch6_lo:
	inc de
	inc hl
	ld a,(de)
	res 7,(ix+000h)
	cp (hl)
	jr z,ch6_hi
	set 7,(ix+000h)
	ld a,(hl)
	ld (de),a
ch6_hi:
	inc de
	inc hl
	res 5,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,ch6_vol
	set 5,(ix+001h)
	ld a,(hl)
	ld (bc),a
ch6_vol:
	inc bc
	ld hl,0e16fh            ; SCC 4 period
	ld a,(de)
	res 0,(ix+001h)
	cp (hl)
	jr z,ch7_lo
	set 0,(ix+001h)
	ld a,(hl)
	ld (de),a
ch7_lo:
	inc de
	inc hl
	ld a,(de)
	res 1,(ix+001h)
	cp (hl)
	jr z,ch7_hi
	set 1,(ix+001h)
	ld a,(hl)
	ld (de),a
ch7_hi:
	inc de
	inc hl
	res 6,(ix+001h)
	ld a,(bc)
	cp (hl)
	jr z,ch7_vol
	set 6,(ix+001h)
	ld a,(hl)
	ld (bc),a
ch7_vol:
	inc bc
	ret
; SCC 988F enable mask from SCC slot+0D
scc_on:
	ld e,000h
	ld hl,0e0a6h            ; SCC 0 flags
	ld c,001h
	ld a,(hl)
	or a
	jr z,mask_0
	ld a,c
mask_0:
	or e
	ld e,a
	ld hl,0e0d9h            ; SCC 1 flags
	sla c
	ld a,(hl)
	or a
	jr z,mask_1
	ld a,c
mask_1:
	or e
	ld e,a
	ld hl,0e10ch            ; SCC 2 flags
	sla c
	ld a,(hl)
	or a
	jr z,mask_2
	ld a,c
mask_2:
	or e
	ld e,a
	ld hl,0e13fh            ; SCC 3 flags
	sla c
	ld a,(hl)
	or a
	jr z,mask_3
	ld a,c
mask_3:
	or e
	ld e,a
	ld hl,0e172h            ; SCC 4 flags
	sla c
	ld a,(hl)
	or a
	jr z,mask_4
	ld a,c
mask_4:
	or e
	ld e,a
	ld hl,0e1fch            ; SCC enable
	ld a,(hl)
	cp e
	jr z,mask_eq
	ld (hl),e
	ld hl,0e1ech            ; SCC dirty hi
	set 7,(hl)
	ret
mask_eq:
	ld hl,0e1ech            ; SCC dirty hi
	res 7,(hl)
	ret
; poke dirty 9880-988F bytes
scc_put:
	ld ix,0e1ebh            ; SCC dirty
	ld hl,0e1edh            ; SCC shadow
	ld de,09880h            ; SCC freq
	bit 0,(ix+000h)
	jr z,scc_81
	call scc_wr
scc_81:
	inc hl
	inc de
	bit 1,(ix+000h)
	jr z,scc_82
	call scc_wr
scc_82:
	inc hl
	inc de
	bit 2,(ix+000h)
	jr z,scc_83
	call scc_wr
scc_83:
	inc hl
	inc de
	bit 3,(ix+000h)
	jr z,scc_84
	call scc_wr
scc_84:
	inc hl
	inc de
	bit 4,(ix+000h)
	jr z,scc_85
	call scc_wr
scc_85:
	inc hl
	inc de
	bit 5,(ix+000h)
	jr z,scc_86
	call scc_wr
scc_86:
	inc hl
	inc de
	bit 6,(ix+000h)
	jr z,scc_87
	call scc_wr
scc_87:
	inc hl
	inc de
	bit 7,(ix+000h)
	jr z,scc_88
	call scc_wr
scc_88:
	inc hl
	inc de
	bit 0,(ix+001h)
	jr z,scc_89
	call scc_wr
scc_89:
	inc hl
	inc de
	bit 1,(ix+001h)
	jr z,scc_8a
	call scc_wr
scc_8a:
	inc hl
	inc de
	bit 2,(ix+001h)
	jr z,scc_8b
	call scc_wr
scc_8b:
	inc hl
	inc de
	bit 3,(ix+001h)
	jr z,scc_8c
	call scc_wr
scc_8c:
	inc hl
	inc de
	bit 4,(ix+001h)
	jr z,scc_8d
	call scc_wr
scc_8d:
	inc hl
	inc de
	bit 5,(ix+001h)
	jr z,scc_8e
	call scc_wr
scc_8e:
	inc hl
	inc de
	bit 6,(ix+001h)
	jr z,scc_8f
	call scc_wr
scc_8f:
	inc hl
	inc de
	bit 7,(ix+001h)
	ret z
	call scc_wr
	ret
; page SCC (3F→9000), write (HL) to (DE), restore bank 5
scc_wr:
	ld a,(hl)
	ld c,a
	ld a,03fh               ; SCC enable
	ld (09000h),a           ; mapper 8000
	ld a,c
	ld (de),a
	ld a,005h
	ld (09000h),a           ; mapper 8000
	ret
; copy 32-byte wave if slot+0F bit 7; ch 5 shares ch 4
wave_out:
	ld hl,0e0a8h            ; SCC 0 wave dirty
	bit 7,(hl)
	jr z,wav_1
	res 7,(hl)
	ld hl,0e0c0h            ; SCC 0 wave ptr
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09800h            ; SCC wave 0
	call wav_copy
wav_1:
	ld hl,0e0dbh            ; SCC 1 wave dirty
	bit 7,(hl)
	jr z,wav_2
	res 7,(hl)
	ld hl,0e0f3h            ; SCC 1 wave ptr
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09820h            ; SCC wave 1
	call wav_copy
wav_2:
	ld hl,0e10eh            ; SCC 2 wave dirty
	bit 7,(hl)
	jr z,wav_3
	res 7,(hl)
	ld hl,0e126h            ; SCC 2 wave ptr
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09840h            ; SCC wave 2
	call wav_copy
wav_3:
	ld hl,0e141h            ; SCC 3 wave dirty
	bit 7,(hl)
	ret z
	res 7,(hl)
	ld hl,0e159h            ; SCC 3 wave ptr
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld de,09860h            ; SCC wave 3
; 32-byte wave to DE; 988F from E1FC
wav_copy:
	ld a,03fh               ; SCC enable
	ld (09000h),a           ; mapper 8000
	xor a
	ld (0988fh),a           ; SCC on/off
	ld b,020h
wav_loop:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz wav_loop
	ld hl,0988fh            ; SCC on/off
	ld de,0e1fch            ; SCC enable
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
