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
	ld hl,0e215h            ; H.TIMI debounce
	ld a,(hl)
	cp 002h
	jr c,htimi_gate
	inc hl
	ld a,(hl)
	and a
	jr nz,htimi_gate
htimi_dec:
	dec hl
	dec (hl)
htimi_gate:
	ld hl,0e21ah            ; sfx debounce
	ld a,(hl)
	and a
	jr z,htimi_ready
	dec a
	jr z,htimi_ready
	dec (hl)
htimi_ready:
	ld hl,0e206h            ; tick lock
	ld a,(hl)
	and a
	ld (hl),001h
	jp nz,htimi_done
	ld a,004h               ; banks 04/5/6
	ld (07000h),a           ; mapper 6000
	inc a
	ld (09000h),a           ; mapper 8000
	inc a
	ld (0b000h),a           ; mapper A000
	call 06006h             ; tick_entry (bank 04)
	xor a
	ld (0e206h),a           ; tick lock
	di
	ld a,(0f0f1h)           ; mapper 6000 copy
	ld (07000h),a           ; mapper 6000
	ld a,(0f0f2h)           ; mapper 8000 copy
	ld (09000h),a           ; mapper 8000
	ld a,(0f0f3h)           ; mapper A000 copy
	ld (0b000h),a           ; mapper A000
	ld hl,0e205h            ; frame done
	ld a,(hl)
	and a
	jr nz,htimi_done
	inc (hl)
	ei
	call poll_keys          ; stick + keyrow
	call mode_frame         ; mode_tick then input
	xor a
	ld (0e205h),a           ; frame done
htimi_done:                     ; 0x408D  ISR tail (skip tick / nested frame)
	ei
	ret
; HL += A
ADD_HL_A:                       ; 0x408F
	add a,l
	ld l,a
	ret nc
	inc h
	ret
; DE += A
ADD_DE_A:                       ; 0x4094
	add a,e
	ld e,a
	ret nc
	inc d
	ret
; inline word table follows each call
DISPATCH_A:                     ; 0x4099  inline word table follows each call
	pop hl
dispatch_hl:                    ; 0x409A  HL already the table (draw_actor)
	add a,a
	call ADD_HL_A
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
cart_init:                      ; AB header init @ 0x40A3
	di
	call slot_id          ; slot id -> A
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
	ld sp,0e000h            ; work RAM / stack
	ld a,(0ffa7h)           ; H.PHYD
	cp 0c9h
	call nz,boot_stash       ; disk ROM present
	ld a,0c9h               ; RET
	ld (0fd9ah),a           ; H.KEYI disabled
	call rdslt_8000
	call slot_id
	ld a,001h
	ld (0f0f4h),a
	ld (0f0f5h),a
	xor a
	ld hl,0e000h            ; work RAM / stack
	ld de,0e001h
	ld bc,00fffh
	ld (hl),a
	ldir
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,001ffh
	ld (hl),a
	ldir
	ld a,001h
	ld (0e219h),a           ; attract slot
	xor a
	ld (0f3eah),a           ; FORCLR
	ld (0f3ebh),a           ; BAKCLR
	ld hl,0f0f1h            ; mapper 6000 copy
	ld a,001h
	ld (07000h),a           ; page_triplet A=1 → banks 01/2/3
	ld (hl),a
	inc a
	ld (09000h),a           ; mapper 8000
	inc hl
	ld (hl),a
	inc a
	ld (0b000h),a           ; mapper A000
	inc hl
	ld (hl),a
	call scr_boot
	di
	ld a,0c3h               ; JP
	ld (0fd9fh),a           ; H.TIMI
	ld hl,htimi_isr         ; 0x402E
	ld (0fda0h),hl          ; H.TIMI+1
	xor a
	ld (0f3dbh),a
	ei
boot_halt:                      ; 0x4124  wait for H.TIMI
	jr boot_halt
; RDSLT page 8000 of the cart slot
rdslt_8000:                     ; 0x4126  RDSLT page 8000 of the cart slot
	call 00138h             ; RSLREG
	rrca
	rrca
	and 003h
	ld c,a
	ld b,000h
	ld hl,0fcc1h            ; EXPTBL
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
	jp 00024h               ; ENASLT
; primary+expanded slot id -> F0E9
slot_id:                        ; 0x4146  primary+expanded slot id -> F0E9
	call 00138h             ; RSLREG
	rrca
	rrca
	and 003h
	ld c,a
	ld b,000h
	ld hl,0fcc1h            ; EXPTBL
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
	ld (0f0e9h),a           ; cart slot
	ret
; DISKERR + copy work RAM / hook bytes aside
boot_stash:                     ; 0x4162  DISKERR + copy work RAM / hook bytes aside
	ld hl,0972ch
	ld (0f323h),hl          ; DISKERR
	ld hl,0e280h            ; Vic state
	ld bc,01100h
	ld de,0c000h
	ldir
	ld hl,0f100h
	ld de,0d780h
	ld bc,00280h
	ldir
	ld hl,0fd9fh            ; H.TIMI
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
	ld hl,0f0f1h            ; mapper 6000 copy
	ld (hl),a
	ld (07000h),a           ; mapper 6000
	inc a
	inc hl
	ld (hl),a
	ld (09000h),a           ; mapper 8000
	inc a
	inc hl
	ld (hl),a
	ld (0b000h),a           ; mapper A000
	pop hl
	pop af
	ei
	ret
; banks 04/5/6 via page_triplet
page_banks_456:                 ; 0x41A6
	push af
	ld a,004h
	jr page_triplet
; banks 07/8/9 via page_triplet
page_banks_789:                 ; 0x41AB
	push af
	ld a,007h
	jr page_triplet
; banks 0A/B/C via page_triplet
page_banks_abc:            ; 0x41B0
	push af
	ld a,00ah
	jr page_triplet
; A000-only bank 0C
page_bank_c:                   ; 0x41B5  A000 only
	push af
	ld a,00ch
	jr page_a000
page_bank_f:                   ; 0x41BA
	push af
	ld a,00fh
	jr page_a000
; A000-only bank 0D
page_bank_d:                   ; 0x41BF
	push af
	ld a,00dh
page_a000:                      ; 0x41C2
	di
	ld (0f0f3h),a           ; mapper A000 copy
	ld (0b000h),a           ; mapper A000
	pop af
	ei
	ret
; banks 0E/F at 8000+A000
page_banks_ef:               ; 0x41CC  8000+A000
	push af
	ld a,00eh
	di
	ld (0f0f2h),a           ; mapper 8000 copy
	ld (09000h),a           ; mapper 8000
	inc a
	ld (0f0f3h),a           ; mapper A000 copy
	ld (0b000h),a           ; mapper A000
	pop af
	ei
	ret
; sound_far thunks. Ids 1–0x27 are ld a / jp (5 bytes); 0x28–0x41 are
; ld a / jr (4 bytes; last jr is +127 onto sound_far). Ids 1–0x41 index
; psg_01..psg_41 in bank 04. 0x80–0x84 are special-cased in the driver;
; 0x82/0x83 also poke (0xE21A).
sfx_01:                         ; 0x41E0  stop
	ld a,001h               ; stop
	jp sound_far
sfx_02:                         ; 0x41E5  unused
	ld a,002h               ; unused
	jp sound_far
; packed-PSG id 0x03 boot
sfx_03:                         ; 0x41EA  boot
	ld a,003h               ; boot
	jp sound_far
sfx_04:                         ; 0x41EF  unused
	ld a,004h               ; unused
	jp sound_far
sfx_05:                         ; 0x41F4  bgm_stage
	ld a,005h               ; bgm_stage
	jp sound_far
sfx_06:                         ; 0x41F9  bgm_stage
	ld a,006h               ; bgm_stage
	jp sound_far
sfx_07:                         ; 0x41FE  bgm_stage
	ld a,007h               ; bgm_stage
	jp sound_far
sfx_08:                         ; 0x4203  bgm_stage
	ld a,008h               ; bgm_stage
	jp sound_far
sfx_09:                         ; 0x4208  bgm_stage
	ld a,009h               ; bgm_stage
	jp sound_far
sfx_0a:                         ; 0x420D  puzzle
	ld a,00ah               ; puzzle
	jp sound_far
; packed-PSG id 0x0b last gem / door open
sfx_0b:                         ; 0x4212  last gem / door open
	ld a,00bh               ; last gem / door open
	jp sound_far
sfx_0c:                         ; 0x4217  unused
	ld a,00ch               ; unused
	jp sound_far
; packed-PSG id 0x0d world-map BGM
sfx_0d:                         ; 0x421C  world-map BGM
	ld a,00dh               ; world-map BGM
	jp sound_far
; packed-PSG id 0x0e ending
sfx_0e:                         ; 0x4221  ending
	ld a,00eh               ; ending
	jp sound_far
; packed-PSG id 0x0f extra life
sfx_0f:                         ; 0x4226  extra life
	ld a,00fh               ; extra life
	jp sound_far
; packed-PSG id 0x10 title
sfx_10:                         ; 0x422B  title
	ld a,010h               ; title
	jp sound_far
; packed-PSG id 0x11 title cursor
sfx_11:                         ; 0x4230  title cursor
	ld a,011h               ; title cursor
	jp sound_far
; packed-PSG id 0x12 ending
sfx_12:                         ; 0x4235  ending
	ld a,012h               ; ending
	jp sound_far
; packed-PSG id 0x13 jump
sfx_13:                         ; 0x423A  jump
	ld a,013h               ; jump
	jp sound_far
sfx_14:                         ; 0x423F  E500 same-screen (slouman_land / flouman_land)
	ld a,014h               ; E500 same-screen
	jp sound_far
; packed-PSG id 0x15 Vic shovel
sfx_15:                         ; 0x4244  Vic shovel swing
	ld a,015h               ; Vic shovel
	jp sound_far
; packed-PSG id 0x16 drill
sfx_16:                         ; 0x4249  drill
	ld a,016h               ; drill
	jp sound_far
; packed-PSG id 0x17 pick
sfx_17:                         ; 0x424E  pick
	ld a,017h               ; pick
	jp sound_far
; packed-PSG id 0x18 hammer
sfx_18:                         ; 0x4253  hammer
	ld a,018h               ; hammer
	jp sound_far
; packed-PSG id 0x19 pickup
sfx_19:                         ; 0x4258  pickup
	ld a,019h               ; pickup
	jp sound_far
; packed-PSG id 0x1a gem
sfx_1a:                         ; 0x425D  gem
	ld a,01ah               ; gem
	jp sound_far
; packed-PSG id 0x1b boom spin
sfx_1b:                         ; 0x4262  boomerang spin wrap
	ld a,01bh               ; boom spin
	jp sound_far
; packed-PSG id 0x1c knife spin
sfx_1c:                         ; 0x4267  knife anim wrap
	ld a,01ch               ; knife spin
	jp sound_far
sfx_1d:                         ; 0x426C  Pyoncy / Rock Roll spawn
	ld a,01dh               ; Pyoncy / Rock Roll spawn
	jp sound_far
sfx_1e:                         ; 0x4271  Slouman / Flouman spawn
	ld a,01eh               ; Slouman / Flouman spawn
	jp sound_far
sfx_1f:                         ; 0x4276  Pyoncy drop
	ld a,01fh               ; Pyoncy drop
	jp sound_far
; packed-PSG id 0x20 play
sfx_20:                         ; 0x427B  play start (E20C bit 1 → hud_hide)
	ld a,020h               ; play start
	jp sound_far
; packed-PSG id 0x21 coffin
sfx_21:                         ; 0x4280  coffin
	ld a,021h               ; coffin
	jp sound_far
; packed-PSG id 0x22 pyoncy
sfx_22:                         ; 0x4285  pyoncy
	ld a,022h               ; pyoncy
	jp sound_far
; packed-PSG id 0x23 walk-in clear
sfx_23:                         ; 0x428A  walk-in clear
	ld a,023h               ; walk-in clear
	jp sound_far
; packed-PSG id 0x24 stone
sfx_24:                         ; 0x428F  stone
	ld a,024h               ; stone
	jp sound_far
; packed-PSG id 0x25 thud
sfx_25:                         ; 0x4294  thud
	ld a,025h               ; thud
	jp sound_far
; packed-PSG id 0x26 clash
sfx_26:                         ; 0x4299  clash
	ld a,026h               ; clash
	jp sound_far
; packed-PSG id 0x27 trap
sfx_27:                         ; 0x429E  trap
	ld a,027h               ; trap
	jp sound_far
sfx_28:                         ; 0x42A3  die; last jp was sfx_27
	ld a,028h               ; die; last jp was sfx_27
	jr sound_far
sfx_29:                         ; 0x42A7  hit
	ld a,029h               ; hit
	jr sound_far
; packed-PSG id 0x2a card
sfx_2a:                         ; 0x42AB  card
	ld a,02ah               ; card
	jr sound_far
sfx_2b:                         ; 0x42AF  unused
	ld a,02bh               ; unused
	jr sound_far
sfx_2c:                         ; 0x42B3  enemy fall
	ld a,02ch               ; enemy fall
	jr sound_far
; packed-PSG id 0x2d stuck self-destruct
sfx_2d:                         ; 0x42B7  enemy_stuck / tick_self_destruct
	ld a,02dh               ; stuck puff
	jr sound_far
; packed-PSG id 0x2e clear
sfx_2e:                         ; 0x42BB  clear
	ld a,02eh               ; clear
	jr sound_far
sfx_2f:                         ; 0x42BF  unused
	ld a,02fh               ; unused
	jr sound_far
sfx_30:                         ; 0x42C3  enter
	ld a,030h               ; enter
	jr sound_far
sfx_31:                         ; 0x42C7  rock
	ld a,031h               ; rock
	jr sound_far
; packed-PSG id 0x32 cursor
sfx_32:                         ; 0x42CB  cursor
	ld a,032h               ; cursor
	jr sound_far
sfx_33:                         ; 0x42CF  unused
	ld a,033h               ; unused
	jr sound_far
sfx_34:                         ; 0x42D3  unused
	ld a,034h               ; unused
	jr sound_far
; packed-PSG id 0x35 boom catch
sfx_35:                         ; 0x42D7  catch boomerang
	ld a,035h               ; boom catch
	jr sound_far
sfx_36:                         ; 0x42DB  E300 knife (this screen)
	ld a,036h               ; knife map
	jr sound_far
sfx_37:                         ; 0x42DF  ending
	ld a,037h               ; ending
	jr sound_far
sfx_38:                         ; 0x42E3  land
	ld a,038h               ; land
	jr sound_far
sfx_39:                         ; 0x42E7  key
	ld a,039h               ; key
	jr sound_far
sfx_3a:                         ; 0x42EB  end_flash
	ld a,03ah               ; end_flash
	jr sound_far
sfx_3b:                         ; 0x42EF  pyramid FX land
	ld a,03bh               ; FX land
	jr sound_far
sfx_3c:                         ; 0x42F3  fall; boot vic_fall lands here
	ld a,03ch               ; fall; boot vic_fall lands here
	jr sound_far
sfx_3d:                         ; 0x42F7  stamp
	ld a,03dh               ; stamp
	jr sound_far
; packed-PSG id 0x3e count
sfx_3e:                         ; 0x42FB  count
	ld a,03eh               ; count
	jr sound_far
sfx_3f:                         ; 0x42FF  unused
	ld a,03fh               ; unused
	jr sound_far
sfx_40:                         ; 0x4303  secret
	ld a,040h               ; secret
	jr sound_far
sfx_41:                         ; 0x4307  boomerang throw
	ld a,041h               ; boom throw
	jr sound_far
; packed-PSG id 0x80 restore BGM (unpause)
sfx_80:                         ; 0x430B  restore BGM (unpause)
	ld a,080h               ; restore BGM (unpause)
	jr sound_far
sfx_81:                         ; 0x430F  mute BGM (pause)
	ld a,081h               ; mute BGM (pause)
	jr sound_far
; mute (id 82)
sfx_82:                         ; 0x4313  mute (id 82)
	xor a
	ld (0e21ah),a           ; sfx debounce
	ld a,082h
	jr sound_far
; fade (id 83)
sfx_83:                         ; 0x431B  fade (id 83)
	ld a,0ffh
	ld (0e21ah),a           ; sfx debounce
	ld a,083h
	jr sound_far
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
	ld (07000h),a           ; mapper 6000
	inc a
	ld (09000h),a           ; mapper 8000
	inc a
	ld (0b000h),a           ; mapper A000
	pop af
	push af
	call 06003h             ; sound_entry (bank 04)
	ld hl,0f0f1h            ; mapper 6000 copy
	ld a,(hl)
	ld (07000h),a           ; mapper 6000
	inc hl
	ld a,(hl)
	ld (09000h),a           ; mapper 8000
	inc hl
	ld a,(hl)
	ld (0b000h),a           ; mapper A000
	pop af
	pop ix
	pop bc
	pop de
	pop hl
	ei
	ret
; page 123 play_frame, back to bank C
play_frame_far:                   ; 0x4358  page 123 play_frame, back to bank C
	call page_banks_123
	call play_frame
	jr far_done
; page 123 set_world, back to bank C
set_world_far:                    ; 0x4360  page 123 set_world, back to bank C
	call page_banks_123
	call set_world
far_done:                       ; 0x4366  restore bank C after a 123 far call
	jp page_bank_c
room_draw_far:                    ; 0x4369  page 123 room_draw, back to bank C
	call page_banks_123
	call room_draw
	jr far_done
; E20C bit 3 toggles E253 / BGM
bgm_toggle:                       ; 0x4371  E20C bit 3 toggles E253 / BGM
	ld a,(0e215h)           ; H.TIMI debounce
	and a
	ret nz
	ld a,(0e20ch)           ; vic_die flag
	and 008h
	ret z
	ld hl,0e253h
	ld a,(hl)
	xor 001h
	ld (hl),a
	jp nz,sfx_01
	jr bgm_play
; sfx_05..09 from level nibble
bgm_stage:                        ; 0x4388  sfx_05..09 from level nibble
	ld a,(0e253h)
	and a
	ret nz
bgm_play:
	call sfx_82
	ld a,(0e242h)           ; level
	call to_bcd
	dec a
	and 00fh
	cp 00fh
	jr nz,bgm_cap
	ld a,009h
bgm_cap:
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
; E203 BCD low nibble + 1 -> E242
set_level:                      ; 0x43AE  E203 BCD low nibble + 1 -> E242
	ld a,(0e203h)           ; puzzle board
	call to_bcd
	and 00fh
	inc a
	ld (0e242h),a           ; level
	ret
; unpack_map + load_map_obj
load_pyramid:                     ; 0x43BB  unpack_map + load_map_obj
	call unpack_map
	call load_map_obj
	ret
; bank 0A map_ptr[(level)-1] -> 0xE900
unpack_map:                       ; 0x43C2  bank 0A map_ptr[(level)-1] -> 0xE900
	call page_banks_abc
	call unpack_map_body
	jp page_banks_123
; decode map_ptr[level-1] into E900
unpack_map_body:
	ld a,(0e242h)           ; level
	dec a
	ld hl,06000h                  ; map_ptr
	call tbl_word
	ex de,hl
	ld hl,0e900h            ; unpacked map
	exx
	ld b,004h
	exx
unpack_loop:
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
unpack_run:
	call pack_nibble
	djnz unpack_run
	jr unpack_loop
; write 2-bit C into next E900 cell
pack_nibble:                    ; 0x43F1  write 2-bit C into next E900 cell
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
; obj_ptr overlay + obj2_ptr -> 0xE7C0
load_map_obj:                     ; 0x4400  obj_ptr overlay + obj2_ptr -> 0xE7C0
	call page_banks_abc
	call load_obj
	call load_obj2
	jp page_banks_123
; secret-entrance records (editor tool 7)
load_obj2:                        ; 0x440C  secret-entrance records (editor tool 7)
	ld a,001h
	ld (0efc3h),a
	ld hl,060f0h                  ; obj2_ptr
	jr obj_begin
; packed map-bit overlay from obj_ptr
load_obj:                         ; 0x4416  packed map-bit overlay from obj_ptr
	ld hl,06078h
	xor a
	ld (0efc3h),a
obj_begin:
	ld a,001h
	ld (0efc2h),a           ; stamp row
	ld de,0e900h            ; unpacked map
	ld (0efc0h),de          ; stamp row
	ld ix,0e7c0h            ; secrets
	ld a,(0e242h)           ; level
	dec a
	call tbl_word
obj_rec:
	ld e,(hl)
	inc hl
	ld a,e
	cp 0ffh
	jr z,obj_ff
	ld d,(hl)
	ld a,e
	and a
	ret z
	inc hl
	push hl
	call overlay_cell
	call overlay_run
	pop hl
obj_next:
	jr obj_rec
obj_ff:
	push hl
	call overlay_next
	pop hl
	jr obj_next
; EFC2++; EFC0 += 0xC0 (next screen overlay)
overlay_next:                   ; 0x4451  EFC2++; EFC0 += 0xC0 (next screen overlay)
	ld hl,0efc2h            ; stamp row
	inc (hl)
	ld hl,(0efc0h)          ; stamp row
	ld bc,000c0h
	add hl,bc
	ld (0efc0h),hl          ; stamp row
	ret
; packed overlay XY -> map cell HL
overlay_cell:                   ; 0x4460  packed overlay XY -> map cell HL
	ld l,e
	ld h,d
	add hl,hl
	ld l,h
	ld h,000h
	ld bc,(0efc0h)          ; stamp row
	add hl,bc
	ret
; OR overlay bits; secret rec if EFC3
overlay_run:                    ; 0x446C  OR overlay bits; secret rec if EFC3
	ld a,(0efc3h)
	and a
	call nz,secret_store
	ld a,e
	and 01fh
	ld b,a
	ld a,e
	rlca
	rlca
	rlca
	and 003h
	ld e,a
overlay_loop:
	push bc
	call overlay_bits
	inc e
	ld a,e
	and 003h
	ld e,a
	jr nz,overlay_inc
	inc hl
overlay_inc:
	call overlay_bits
	ld bc,00008h
	dec e
	jp p,overlay_add
	dec c
overlay_add:
	add hl,bc
	pop bc
	djnz overlay_loop
	ret
; OR 2-bit run into packed map cell
overlay_bits:                   ; 0x449A  OR 2-bit run into packed map cell
	ld a,e
	and a
	ld a,040h
	jr z,bits_or
	ld b,e
bits_shift:
	rra
	rra
	djnz bits_shift
bits_or:
	ld b,a
	rlca
	cpl
	and (hl)
	or b
	ld (hl),a
	ret
; append secret-entrance rec at IX
secret_store:                   ; 0x44AC  append secret-entrance rec at IX
	ld a,(0efc2h)           ; stamp row
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
; world tileset + stamp_level + stamp_map
load_stage:                     ; 0x44D4  world tileset + stamp_level + stamp_map
	call rockroll_restore
	call page_banks_ef
	call stamp_wpat
	call stamp_level
	call page_banks_abc
	call stamp_map
	call page_banks_123
	call stamp_delayed
	call 0651dh
	jp rockroll_mark_all
; world tileset HMMM (bank EF)
stamp_wpat:                     ; 0x44F2  world tileset HMMM (bank EF)
	ld a,(0e241h)           ; world
	ld hl,07ffeh
	call tbl_word
	ld a,(0e242h)           ; level
	rra
	ld a,020h
	jr c,wpat_lo
	xor a
wpat_lo:
	call ADD_HL_A
	ld de,00000h
	ld c,006h
wpat_row:
	push hl
	ld b,004h
wpat_col:
	push bc
	ld c,004h
wpat_tile:
	ld b,008h
	push hl
wpat_byte:
	ld a,(hl)
	call tile_hmmm
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz wpat_byte
	pop hl
	dec c
	jr nz,wpat_tile
	ld a,008h
	call ADD_HL_A
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz wpat_col
	pop hl
	dec c
	jr nz,wpat_row
	ret
; unpack E900 2-bit map onto SCREEN 5
stamp_map:                      ; 0x4535  unpack E900 2-bit map onto SCREEN 5
	xor a
	ld (0efc0h),a           ; stamp row
	ld hl,(0e242h)          ; level
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
	ld de,0e900h            ; unpacked map
	add hl,de
	push hl
	pop ix
; DE=origin; IX already the screen map.
stamp_map_at:                     ; 0x4553
	ld de,00000h
	ld b,0c0h
map_byte:
	push bc
	ld a,(ix+000h)
	ld b,004h
map_nibble:
	rlca
	rlca
	push af
	and 003h
	dec a
	jr z,map_ladder
	dec a
	jp m,map_right
	ld a,005h
	jr z,map_pat
	ld a,05eh
map_pat:
	ld (0efc0h),a           ; stamp row
	call tile_pset
map_right:
	call tile_right
	pop af
	djnz map_nibble
	inc ix
	pop bc
	djnz map_byte
	ld a,(0e200h)           ; game mode
	cp 00bh
	ret z
	ld ix,0e7c0h            ; secrets
	ld b,010h
	ld a,(0e243h)           ; screen
	ld c,a
sec_loop:
	push bc
	ld a,(ix+000h)
	and a
	jr z,sec_next
	cp c
	jr nz,sec_next
	call stamp_overlay
sec_next:
	ld bc,00004h
	add ix,bc
	pop bc
	djnz sec_loop
	ret
; B x 2 world tiles at overlay XY
stamp_overlay:                  ; 0x45A7  B x 2 world tiles at overlay XY
	ld c,002h
	ld a,(ix+003h)
	and 01fh
	ld b,a
	ld e,(ix+001h)
	ld d,(ix+002h)
	push bc
	push de
	call stamp_wtiles
	pop de
	pop bc
ovl_rows:
	ld hl,ovl_pair
	call stamp_pair
	ld a,e
	add a,008h
	ld e,a
	djnz ovl_rows
	ret
; BLOCK 'ovl_pair' (start 0x45c9 end 0x45cb)
ovl_pair:
	defb 001h, 002h
ovl_pair_end:
; nibble 1 from stamp_map_at: ladder / overlay tile via EFC0
map_ladder:                     ; 0x45CB
	ld a,(0efc0h)           ; stamp row
	cp 003h
	jr z,ladder_a
	cp 003h
	jr z,ladder_c
	ld a,e
	and a
	jr z,ladder_b
	ld a,b
	sub 005h
	neg
	ld c,a
	ld a,(ix-008h)
ladder_sh:
	rlca
	rlca
	dec c
	jr nz,ladder_sh
	and 003h
	dec a
	jr z,ladder_b
	ld a,003h
	jr ladder_put
ladder_a:
	ld a,004h
	jr ladder_put
ladder_b:
	ld a,003h
	jr ladder_put
ladder_c:
	ld a,004h
	jr ladder_put
ladder_put:
	ld (0efc0h),a           ; stamp row
	call tile_pset
	jp map_right
; Per-level glyph records at 0x806A (page_banks_ef); current screen only.
stamp_level:                      ; 0x4606
	ld a,(0e254h)
	and a
	ret nz
	ld a,(0e242h)           ; level
	ld hl,0806ah
	call tbl_word
glyph_loop:
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
	ld a,(0e243h)           ; screen
	dec a
	cp d
	jr nz,glyph_skip
	ld a,(hl)
	and 0f8h
	ld d,a
	inc hl
	ld c,(hl)
	dec hl
	push hl
	call stamp_glyph
	pop hl
glyph_skip:
	inc hl
	inc hl
	jr glyph_loop
; World*8 + (B&7) -> 0x800C tile-id list; tile_pset at DE.
stamp_glyph:                      ; 0x4638
	ld a,b
	and 007h
	ld b,a
	ld a,(0e241h)           ; world
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
	jr z,glyph_mid
	ld bc,00404h
	and a
	jr z,glyph_row
	ld bc,00402h
	dec a
	jr z,glyph_row
	ld bc,00204h
glyph_row:
	push bc
	ld b,c
	push de
glyph_col:
	ld a,(hl)
	inc hl
	push hl
	call tile_pset
	pop hl
	ld a,d
	add a,008h
	ld d,a
	djnz glyph_col
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz glyph_row
	ret
glyph_mid:
	call stamp_pair
	inc hl
	ld a,e
	add a,008h
	ld e,a
	ld b,c
	dec b
	dec b
glyph_rest:
	call stamp_pair
	dec hl
	ld a,e
	add a,008h
	ld e,a
	djnz glyph_rest
	inc hl
	inc hl
; two tile_pset, 8px apart in X
stamp_pair:                     ; 0x4690  two tile_pset, 8px apart in X
	push de
	ld a,(hl)
	push hl
	call tile_pset
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	ld a,(hl)
	push hl
	call tile_pset
	pop hl
	pop de
	ret
; E2C0 types 1–2: 3×2 case_under sarcophagus
stamp_delayed:                  ; 0x46A4
	ld hl,0e2c0h            ; delayed pickups
	ld b,008h
delay_loop:
	push bc
	push hl
	ld a,(hl)
	and 07fh
	dec a
	sub 002h                      ; types 1–2 only (CY)
	call c,stamp_delay1
	pop hl
	ld de,00005h
	add hl,de
	pop bc
	djnz delay_loop
	ret
; one delayed 3x2 if same screen
stamp_delay1:                   ; 0x46BD  one delayed 3x2 if same screen
	inc l                         ; skip type
	inc l                         ; skip timer
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	inc l
	ld a,(hl)
	sub 008h                      ; packed Y → dest Y-8
	ld e,a
	inc l
	ld d,(hl)                     ; packed X
	ld bc,00302h
	ld hl,case_under
	jp draw_tilemap
; H.TIMI: mode_tick then input
mode_frame:                       ; 0x46D4  H.TIMI: mode_tick then input
	call mode_tick
	jp mode_input
; DISPATCH_A on E200 -> d_46ea
mode_tick:                        ; 0x46DA  DISPATCH_A on E200 -> d_46ea
	ld a,(0e21ah)           ; sfx debounce
	dec a
	call z,sfx_82
	ld hl,0e203h            ; puzzle board
	inc (hl)
	ld bc,(0e200h)          ; game mode
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
	call sfx_01                   ; stop
	call scr_reset
	call title_load
boot_skip:                        ; 0x4723  one frame then sub_next
	jr sub_next
boot_wait:                        ; 0x4725
	ld a,(0f0f4h)
	and a
	jr nz,boot_msx2
	ld a,(0e203h)           ; puzzle board
	rra
	ret nc
	call wmap_slide
	ret nz
	xor a
	jr sub_delay
boot_msx2:
	call wmap_slide
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
	call wmap_font
	call title_jp
	call sfx_03                   ; boot
	xor a
	ld (0e2c2h),a
	jr sub_delay
boot_done:                        ; 0x475C
	call hud_meter
	ld a,(0e2c2h)
	or a
	ret z
	ld a,b
	jp mode_next_a
mode_hold:                        ; 0x4768
	ld a,(0e201h)           ; substate
	or a
	jr nz,hold_wait
	ld hl,0e204h
	dec (hl)
	jr z,hold_next
	jp title_ptr
hold_next:
	xor a
	jr sub_delay
hold_wait:
	ld hl,0e204h
	dec (hl)
	jr z,hold_go
	call nz,title_ptr
	ret
hold_go:
	jp mode_next
mode_attract:                     ; 0x4787
	ld a,b
	and a
	jr nz,attract_tick
	call scr_reset
	call page_bank_c
	call 0ba11h                   ; demo_init
	call page_banks_123
	ld a,020h
; wait A frames (E204), then sub_next
sub_delay:                        ; 0x4799  wait A frames (E204), then sub_next
	ld (0e204h),a
sub_next:                         ; 0x479C  inc E201
	ld hl,0e201h            ; substate
	inc (hl)
	ret
attract_tick:
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
	ld (0e200h),hl          ; game mode
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
	call sfx_10                   ; title
	ld a,070h
	jr sub_delay
title_blink:                      ; 0x47E4
	ld hl,0e204h
	dec (hl)
	jr z,blink_done
	ld a,(0e222h)
	and a
	ld hl,txt_game
	jr z,blink_hl
	ld hl,txt_edit
blink_hl:
	ld a,(0e204h)
	and 004h
	jp z,print_stream
	jp print_stream_blank
blink_done:
	call sfx_11                   ; title cursor
	ld a,(0e222h)
	and a
	jr z,blink_game
	ld a,001h
	ld (0e25ah),a           ; continue script
	ld a,00bh
	jr mode_goto
blink_game:
	ld a,(0f0f7h)
	inc a
	jr z,blink_skip
	ld a,001h
	call SNSMAT
	cpl
	and 020h
	jr z,blink_skip
	call scr_reset
	call page_bank_c
	ld hl,0b284h                  ; str_secret_cmd
	call print_stream
	call page_banks_123
	jp sub_next
blink_skip:
	ld hl,0e201h            ; substate
	inc (hl)
	inc (hl)
	ret
title_fire:                       ; 0x483B
	ld a,(0e207h)           ; key edges
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
	jp title_reset
title_go:                         ; 0x48A8
	call play_clear
	jp mode_next
mode_stage:                       ; 0x48AE
	ld a,b
	and a
	jr nz,stage_go
	call scr_reset
	ld a,(0e254h)
	and a
	jr nz,stage_edit
	ld hl,0e240h            ; lives
	ld a,(hl)
	sub 001h
	daa
	ld (hl),a
	ld hl,txt_stage
	call print_stream
	ld de,09048h
	call print_level
	call page_bank_d
	ld a,(0e242h)           ; level
	ld b,a
	add a,a
	add a,b
	add a,002h
	ld hl,0b8f8h                  ; exit door packed byte (lo5 = shape)
	call ADD_HL_A
	ld a,(hl)
	and 01fh
	call to_bcd
	call page_banks_123
	ld hl,0efc0h            ; stamp row
	ld (hl),a
	ld b,001h
	ld de,0a868h
	call print_bcd
	jr stage_wait
stage_edit:
	xor a
	ld (0e240h),a           ; lives
	dec a
	ld (0e245h),a
	call set_level
	ld a,001h
	ld (0e241h),a           ; world
	ld hl,txt_file
	call print_stream
	ld de,06058h
	call print_e270
stage_wait:
	ld a,078h
	ld (0e204h),a
	jp sub_next
stage_go:
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
	ld hl,0e200h            ; game mode
	inc (hl)
sub_zero:                         ; 0x493D
	xor a
sub_set:                          ; 0x493E  A -> E201
	ld (0e201h),a           ; substate
	ret
mode_play:                        ; 0x4942
	ld a,(0e24ch)           ; pause
	and a
	jp nz,pause_tick
	ld hl,0e215h            ; H.TIMI debounce
	ld a,(hl)
	and a
	jr z,play_go
	dec a
	jr nz,play_go
	ld (hl),000h
	call bgm_stage
play_go:
	ld a,(0e24eh)
	and a
	jp nz,play_unhide
	ld a,(0e20ch)           ; vic_die flag
	and 010h
	jr nz,play_die                  ; bit 4 -> vic_die
	call play_frame
	ld a,(0e248h)           ; exit dir
	and a
	ld a,008h
	jp nz,mode_goto
	ld a,(0e249h)
	and a
	jr nz,play_done
	ld a,(0e246h)
	or a
	jr z,mode_next
	ld a,(0e20ch)           ; vic_die flag
	rra
	jr c,pause_enter
	rra
	ret nc
	ld a,(0f0f4h)
	and a
	ret nz
	ld a,001h
	ld (0e24eh),a
	ld hl,03b00h
	call NRDVRM
	ld (0e24fh),a
	ld a,0d0h
	call NWRVRM
	call sfx_20                   ; play start
	jp hud_hide
; Die: E20C bit 4 → vic_die overlay + sfx_28.
play_die:                         ; 0x49A4
	ld a,(0e298h)                 ; already dying / hit
	or a
	ret nz
	ld a,004h
	ld (0e280h),a                 ; vic_die
	call vic_hurt
	jp sfx_28                     ; die
play_done:
	xor a
	ld (0e249h),a
	inc a
	ld (0e257h),a           ; script index
	ld a,009h
	jp mode_goto
; Pause in: skip if vic_die / vic_hit; load pushup SAT.
pause_enter:                      ; 0x49C1
	ld a,(0e280h)           ; Vic state
	sub 004h
	cp 002h                       ; vic_die / vic_hit: skip pause
	ret c
	ld a,001h
	ld (0e24ch),a                 ; paused
	ld (0e216h),a
	call vic_pat_far
	xor a
	ld (0e2b0h),a
	ld (0e2b3h),a
	call vic_blit
	jp sfx_81                     ; mute BGM
; Paused loop: map overlay, then push-up SAT until F1 up.
pause_tick:                       ; 0x49E1
	call pause_overlay
	ld a,(0edc0h)           ; pause overlay
	or a
	ret nz                        ; overlay busy
	call pause_anim
	call vic_blit
	call vic_sat_put
	call spr_vram
	ld a,(0e20ch)           ; vic_die flag
	rra
	ret nc                        ; still held
	xor a
	ld (0e24ch),a                 ; unpause
	ld (0e216h),a
	call vic_pat_far
	call sfx_80                   ; restore BGM
play_unhide:
	ld a,(0e20ch)           ; vic_die flag
	rra
	rra
	ret nc
	xor a
	ld (0e24eh),a
	ld hl,03b00h
	ld a,(0e24fh)
	call NWRVRM
	jp hud_show
mode_life:                        ; 0x4A1D
	xor a
	ld (0e215h),a           ; H.TIMI debounce
	ld (0e255h),a
	ld a,(0e254h)
	and a
	jr nz,life_over
	ld a,(0e240h)           ; lives
	or a
	jr z,life_over
; E200 = stage card
goto_stage:                     ; 0x4A30
	ld a,004h
	jp mode_goto
life_over:
	call sfx_0f                   ; extra life
goto_over:
	ld a,007h
	jp mode_goto
mode_over:                        ; 0x4A3D
	ld a,b
	and a
	jr nz,over_wait
	call scr_reset
	ld hl,txt_over
	call print_stream
	ld a,(0e254h)
	ld b,a
	ld a,(0e217h)
	or b
	ld (0e218h),a
	ld hl,txt_cont
	call nz,print_stream
	call over_hud
	xor a
	ld (0e247h),a
	ld a,(0e254h)
	and a
	ld a,078h
	jr z,over_delay
	ld a,0b4h
over_delay:
	jp sub_delay
over_wait:
	ld a,(0e218h)
	and a
	call nz,over_skip
	ld a,(0e203h)           ; puzzle board
	rra
	ret c
	ld hl,0e204h
	dec (hl)
	ret nz
	ld a,(0e247h)
	and a
	jr z,over_cont
	ld hl,0e226h            ; score
	xor a
	ld (hl),a
	inc l
	ld (hl),a
	inc l
	ld (hl),a
	inc a
	ld (0e240h),a           ; lives
	ld a,(0e254h)
	and a
	jr z,over_cont
	ld a,(0f0f8h)           ; load device
	and a
	jr z,over_disk
	call ram_wipe
	call sfx_01                   ; stop
	ld hl,0e278h
	ld (hl),045h
	inc hl
	ld (hl),04ch
	inc hl
	ld (hl),047h
	ld a,005h
	ld (0e25bh),a           ; file I/O
	ld hl,00a03h
	ld (0e200h),hl          ; game mode
	ret
over_disk:
	ld hl,00903h
	ld (0e200h),hl          ; game mode
	ret
over_cont:
	ld a,(0e247h)
	and a
	jp nz,goto_stage
over_reset:
	xor a
	ld (0e217h),a
	ld (0e254h),a
	ld hl,0e202h            ; vic flags
	ld a,(hl)
	and 0bfh
	ld (hl),a
	jp mode_reset
; key blanks continue prompt; set E247
over_skip:                      ; 0x4ADB  key blanks continue prompt; set E247
	ld a,007h
	call SNSMAT
	bit 1,a
	ret nz
	ld a,001h
	ld (0e247h),a
	ld hl,txt_cont
	jp print_stream_blank
mode_room:                        ; 0x4AEE
	xor a
	ld (0e24dh),a
	call room_exit
	ld a,(0e24dh)
	and a
	jr nz,room_play
	call enemy_room
	call room_draw
room_play:
	ld a,005h
	jp mode_goto
mode_clear:                       ; 0x4B06
	xor a
	ld (0e215h),a           ; H.TIMI debounce
	call clear_tick
	call spr_vram
	ld a,(0e257h)           ; script index
	ld b,a
	cp 004h
	jr nz,clear_next
	ld a,(0e254h)
	and a
	jp nz,goto_over
	ld a,(0e242h)           ; level
	cp 03ch
	jr nc,clear_end
clear_next:
	ld a,b
	and a
	ret nz
	ld a,(0e242h)           ; level
	call to_bcd
	and 00fh
	dec a
	jp nz,goto_stage
	ld a,001h
	ld (0e257h),a           ; script index
	ld a,00ah
	jp mode_goto
clear_end:
	ld a,001h
	ld (0e257h),a           ; script index
	call scr_reset
	ld a,00dh
	jp mode_goto
mode_world:                       ; 0x4B4C
	call world_tick
	ld a,(0e257h)           ; script index
	and a
	ret nz
	ld bc,0e201h            ; substate
	call WRTVDP
	jp goto_stage
mode_cont:                        ; 0x4B5D
	call sat_flip
	call cont_tick
	call sat_blit
	ld a,(0e25ah)           ; continue script
	and a
	ret nz
	jp title_reset
mode_end:                         ; 0x4B6E  djnz on E201: 1 delay, 2 end_menu, 3+ text
	djnz end_menu_w
	ld hl,0e204h
	dec (hl)
	ret nz
	jp sub_next
end_menu_w:
	djnz end_text
	call page_bank_c
	call 0b534h                   ; end_menu (bank 0C MODULE)
	call page_banks_123
	ld a,(0ef10h)           ; pyramid FX
	or a
	ret nz
	ld hl,0e240h            ; lives
	inc (hl)
	jp goto_stage
end_text:
	call scr_reset
	ld a,078h
	call sub_delay
	call page_banks_ef
	ld hl,09d37h
	ld a,(0ef10h)           ; pyramid FX
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
	ld a,(0e257h)           ; script index
	and a
	ret nz
	jp over_reset
; title/boot stick -> E221; fire skips delay
mode_input:                     ; 0x4BBA  mode_frame tail
	ld a,(0e200h)           ; game mode
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
	djnz title_reset
	and 030h
	jr z,title_toggle
	ld a,040h
	ld (0e202h),a           ; vic flags
	ld (hl),003h
	inc hl
	ld c,000h
	ld (hl),c
	dec c
	jp ptr_on
; back to mode_hold (title wait)
title_reset:                    ; 0x4BEA
	ld hl,00001h
	ld (0e200h),hl          ; game mode
	call sfx_01                   ; stop
	call wmap_font
	call title_jp
	jp title_meter
title_toggle:
	ld a,(de)
	xor 001h
	ld (de),a
	ret
; zero E226, copy 6 bytes into E240
play_clear:                       ; 0x4C01  zero E226, copy 6 bytes into E240
	ld hl,0e226h            ; score
	ld bc,00ddah
	ld d,h
	ld e,l
	inc e
	ld (hl),000h
	ldir
	ld hl,play_init
	ld de,0e240h            ; lives
	ld bc,00006h
	ldir
	ret
play_init:                        ; 0x4C1A  6 bytes -> E240
	defb 001h, 001h, 001h, 000h, 000h, 003h
; Add DE as packed BCD into E226 (lives/score).
add_score:                        ; 0x4C20
	ld c,000h
	ld a,(0e202h)           ; vic flags
	add a,a
	ret p
	ld hl,0e226h            ; score
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
	jr nc,score_ext
	ld bc,09999h
	ld (0e223h),bc
	ld (0e224h),bc
	jr score_xy
score_ext:
	ex de,hl
	ld hl,0e245h
	cp (hl)
	jr c,score_cmp
	ld a,(hl)
	add a,003h
	daa
	jr nc,score_cap
	ld a,0ffh
score_cap:
	ld (hl),a
	push de
	ld hl,0e240h            ; lives
	ld a,(hl)
	cp 099h
	jr nc,score_life
	add a,001h
	daa
	ld (hl),a
score_life:
	call sfx_2a                   ; card
	ld a,(0f0f4h)
	and a
	call nz,print_lives
	pop de
score_cmp:
	ex de,hl
	ld b,003h
	ld de,0e225h
score_byte:
	ld a,(de)
	sub (hl)
	jr c,score_copy
	jr nz,score_xy
	dec l
	dec e
	djnz score_byte
score_copy:
	ld bc,00003h
	ld e,025h
	ld l,028h
	lddr
	jr score_xy
; MSX2 game-over box + scores
over_hud:                       ; 0x4C8A  MSX2 game-over box + scores
	ld a,(0f0f4h)
	and a
	ret z
	ld hl,000c0h
	ld c,00ch
	ld de,0ff13h
	call vdp_box
	ld hl,txt_hud
	call print_stream
	call score_xy
	call print_lives
	ld a,(0e254h)
	and a
	jr z,over_hiscore
	ld hl,0e270h            ; tape name
	ld de,090cah
	jp print_name
over_hiscore:
	jp over_level
hud_score:
	ld de,08848h
	ld hl,08858h
	jr score_print
; print E225/E228 at DE/HL (over_hud / extra life)
score_xy:                       ; 0x4CC0
	ld de,018cah
	ld hl,058cah
score_print:
	push hl
	ld hl,0e225h
	call print_bcd3
	pop hl
	ex de,hl
	ld hl,0e228h
; 3 packed-BCD bytes at HL -> DE
print_bcd3:                     ; 0x4CD2  3 packed-BCD bytes at HL -> DE
	ld b,003h
	jr print_bcd
; password (MSX2) or fall through to level
print_pwd:                      ; 0x4CD6  password (MSX2) or fall through to level
	ld a,(0e254h)
	and a
	jr z,pwd_level
	ld hl,0e270h            ; tape name
	ld de,05068h
	ld b,005h
	jp name_glyph
pwd_level:
	ld de,06868h
	jr print_level
over_level:
	ld de,0b0cah
; E242 as 1 packed-BCD byte
print_level:                    ; 0x4CEF  E242 as 1 packed-BCD byte
	ld a,(0e242h)           ; level
	call to_bcd
	ld hl,0efc0h            ; stamp row
	ld (hl),a
	ld b,001h
	jr print_bcd
; binary A -> packed BCD (tens:ones)
to_bcd:                         ; 0x4CFD  binary A -> packed BCD (tens:ones)
	ld b,000h
bcd_loop:
	ld c,a
	sub 00ah
	jr c,bcd_pack
	inc b
	jr bcd_loop
bcd_pack:
	rlc b
	rlc b
	rlc b
	rlc b
	ld a,b
	or c
	ret
; lives digit at SCREEN 1 dest
print_lives1:                   ; 0x4D12  lives digit at SCREEN 1 dest
	ld de,0a868h
	jr print_lives_at
; lives digit (MSX2 dest E0CA)
print_lives:                    ; 0x4D17  lives digit (MSX2 dest E0CA)
	ld a,(0f0f4h)
	and a
	ret z
	ld de,0e0cah
; 1 BCD byte at E240 -> DE
print_lives_at:                   ; 0x4D1F  1 BCD byte at E240 -> DE
	ld hl,0e240h            ; lives
	ld b,001h
	jr print_bcd
; B packed-BCD bytes at HL -> DE
print_bcd:                      ; 0x4D26  B packed-BCD bytes at HL -> DE
	ld a,(0f0f4h)
	and a
	ex de,hl
	call z,scr5_addr
	ex de,hl
bcd_bytes:
	dec b
	jr nz,bcd_one
	ld c,0ffh
bcd_one:
	inc b
	ld a,(hl)
	rra
	rra
	rra
	rra
	call print_digit
	ld a,(hl)
	call print_digit
	dec hl
	djnz bcd_bytes
	ret
; low nibble + 0xD0 -> print_glyph
print_digit:                    ; 0x4D45  low nibble + 0xD0 -> print_glyph
	and 00fh
	add a,0d0h
	jp print_glyph
; HL = word[A] at HL
tbl_word:                         ; 0x4D4C  HL = word[A] at HL
	add a,a
	add a,l
	ld l,a
	jr nc,tbl_nc
	inc h
tbl_nc:
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ret
; blink `<` `=` on game / edit (E222)
title_ptr:                        ; 0x4D57  blink `<` `=` on game / edit (E222)
	ld hl,0e204h
	bit 3,(hl)
	ld c,0ffh
	jr nz,ptr_on
	inc c
ptr_on:
	ld hl,0388ch
	ld de,0389ch
	ld a,(0e222h)
	or a
	jr nz,ptr_swap
	ex de,hl
ptr_swap:
	push hl
	call print_ptr
	pop de
	ld c,000h
; txt_ptr `"<="`
print_ptr:                        ; 0x4D75  txt_ptr `"<="`
	ld hl,txt_ptr
	jp print_at
; SCREEN 5: pixel HL → VRAM in page 0x38 (HUD digits).
scr5_addr:                        ; 0x4D7B
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
hud_hide:
	ld hl,03908h
	ld de,0e880h            ; sat_fx
	ld bc,00710h
hud_copy:
	push bc
	ld b,000h
	call ldirvm
	ld a,010h
	call ADD_DE_A
	ld a,020h
	call ADD_HL_A
	pop bc
	djnz hud_copy
	ld hl,03908h
	ld bc,00710h
hud_fill:
	push bc
	xor a
	ld b,a
	call filvrm
	ld a,020h
	call ADD_HL_A
	pop bc
	djnz hud_fill
	ld hl,txt_play
	call print_stream
	call print_lives1
	call print_pwd
	jp hud_score
hud_show:
	ld de,03908h
	ld hl,0e880h            ; sat_fx
	ld bc,00710h
hud_back:
	push bc
	ld b,000h
	call ldirmv
	ld a,010h
	call ADD_HL_A
	ld a,020h
	call ADD_DE_A
	pop bc
	djnz hud_back
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
; BIOS LDIRVM (0059h): HL=memory, DE=VRAM, BC=count.
ldirvm:                           ; 0x4DFB
	push hl
	push de
	push bc
	call 00059h             ; LDIRMV
	pop bc
	pop de
	pop hl
	ret
; BIOS LDIRMV (005Ch): HL=VRAM, DE=memory, BC=count.
ldirmv:                           ; 0x4E05
	push hl
	push de
	push bc
	call 0005ch             ; LDIRVM
	pop bc
	pop de
	pop hl
	ret
; BIOS FILVRM (016Bh): A=fill, HL=VRAM, BC=count.
filvrm:                           ; 0x4E0F
	push de
	push af
	push bc
	call 0016bh
	pop bc
	pop af
	pop de
	ret
; WRTVDP, preserve BC
vdp_wr:                           ; 0x4E19  WRTVDP, preserve BC
	push bc
	call WRTVDP
	pop bc
	ret
; 0x80: VRAM write ptr from stream (also clears reverse).
rle_setptr:                       ; 0x4E1F
	ld c,000h                     ; no bit-reverse
rle_ptr_rd:                       ; 0x4E21
	ex de,hl
	ld e,(hl)                     ; dest lo
	inc hl
	ld d,(hl)                     ; dest hi
	inc hl
	ex de,hl
rle_setwrt:                       ; 0x4E27
	call 00171h                   ; SETWRT HL
	exx
	ld a,(00007h)                 ; VDP data port
	ld c,a
	exx
; 00 end; 01-7F run; 80 set ptr; 81-FF literal.
rle_next:                         ; 0x4E30
	ld a,(de)                     ; control
	and a
	ret z                         ; 00 = end
	inc de
	ld b,a
	and 07fh
	cp b
	jr z,rle_run                  ; 01-7F: repeat next byte B times
	and a
	jr z,rle_setptr               ; 80: new dest
	ld b,a                        ; 81-FF: literal (A&7F) bytes
rle_lit:                          ; 0x4E3E
	call rle_byte
	exx
	out (c),a
	exx
	djnz rle_lit
	jr rle_next
rle_run:                          ; 0x4E49
	call rle_byte
rle_run_out:                      ; 0x4E4C
	exx
	out (c),a
	exx
	djnz rle_run_out
	jr rle_next
; Konami RLE: DE packed src, HL VRAM dest. C bit 0 = bit-reverse (live callers 0).
rle_vram:                         ; 0x4E54
	ld c,000h                     ; no reverse
	jr rle_setwrt
	ld c,001h                     ; unused: reverse, dest from stream
	jr rle_ptr_rd
	ld c,001h                     ; unused: reverse, dest already in HL
	jr rle_setwrt
; VIC_COPY: C 16×16 planes, HL src, DE dest (SAT / work RAM).
spr_copy:                         ; 0x4E60
	call spr_plane
	ld a,020h                     ; next plane (+32)
	call ADD_DE_A
	dec c
	jr nz,spr_copy
	ret
; One 16×16 plane: 16 rows, two 8px tiles (bit-reverse each byte).
spr_plane:                        ; 0x4E6C
	push de
plane_tile:
	ld b,010h                     ; 16 rows
plane_row:
	call NRDVRM                   ; RDVRM dest
	call bit_rev
	ex de,hl
	call NWRVRM                   ; WRTVRM
	ex de,hl
	inc e
	inc hl
	djnz plane_row
	ld a,e
	sub 020h                      ; back 32, then right tile
	ld e,a
	bit 4,e
	jr z,plane_tile
	pop de
	ret
; next packed byte; reverse if C bit 0
rle_byte:                         ; 0x4E88  next packed byte; reverse if C bit 0
	ld a,(de)
	inc de
	bit 0,c
	ret z
; reverse bits of A (X-flip)
bit_rev:                          ; 0x4E8D
	push bc
	ld c,a
	ld b,008h
rev_bit:
	rr c
	rla
	djnz rev_bit
	pop bc
	ret
; hide sprites, blank, fill, display on
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
; VDP R#1 display enable
scr_on:                           ; 0x4EB1  VDP R#1 display enable
	ld a,(0f3e0h)
	or 040h
	ld b,a
	ld c,001h
	call WRTVDP
	jr vdp_spr_on
; VDP R#1 display disable
scr_off:                          ; 0x4EBE  VDP R#1 display disable
	ld a,(0f3e0h)
	and 0bfh
	ld b,a
	ld c,001h
	call WRTVDP
	jr vdp_spr_off
; 128-byte SAT copies at F600/F200 = Y 0xE0
spr_clear:                        ; 0x4ECB  128-byte SAT copies at F600/F200 = Y 0xE0
	ld hl,0f600h
	call sat_fill
	ld hl,0f200h
; 128-byte SAT = Y 0xE0 (off-screen)
sat_fill:                       ; 0x4ED4  128-byte SAT = Y 0xE0 (off-screen)
	ld bc,00080h
	ld a,0e0h
	jp filvrm
vdp_spr_off:                      ; 0x4EDC  VDP R#8 SPD
	ld a,(0ffe7h)
	or 002h
	ld b,a
	ld c,008h
	jp WRTVDP
; VDP R#8 sprites on
vdp_spr_on:                       ; 0x4EE7  VDP R#8 sprites on
	ld a,(0ffe7h)
	and 0fdh
	ld b,a
	ld c,008h
	jp WRTVDP
; A=index, DE=MSX2 palette word
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
; [index, pal_lo, pal_hi]... 0xFF
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
; wait CE (S#2 bit 0)
vdp_ce_wait:                      ; 0x4F2A  wait CE (S#2 bit 0)
	ld a,002h
	call vdp_status
	rra
	jp c,vdp_ce_wait
	ret
; read VDP status A (R#15)
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
; CMD 70h fill (HL=XY, BC=NXNY)
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
	jr nz,hmmv_nx
	inc a
hmmv_nx:
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
; HMMV, NY high=1
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
	jr nz,hmmv_hi_nx
	inc a
hmmv_hi_nx:
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
; rectangle outline (DE=size)
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
; HMMV NY high=1, save regs
vdp_hmmv_hi_s:
	push hl
	push de
	push bc
	call vdp_hmmv_hi
	pop bc
	pop de
	pop hl
	ret
; HMMV fill, save regs
vdp_hmmv_s:
	push hl
	push de
	push bc
	call vdp_hmmv
	pop bc
	pop de
	pop hl
	ret
; CMD C0h logical fill (A'=color)
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
	jr nz,lmmv_nx
	inc a
lmmv_nx:
	out (c),a
	xor a
	out (c),l
	cp l
	jr nz,lmmv_ny
	inc a
lmmv_ny:
	out (c),a
	ex af,af'
	out (c),a
	xor a
	out (c),a
	ld a,0c0h
	out (c),a
	ei
	ret
; CMD D0h VRAM copy
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
; CMD F0h CPU→VRAM
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
hmmc_ce:
	ld a,002h
	call vdp_status
	rra
	ret nc
	add a,a
	add a,a
	jr nc,hmmc_ce
	ld a,(hl)
	inc hl
	out (c),a
	jr hmmc_ce
; CMD E0h YMMM (VRAM→VRAM).
vdp_ymmm:                         ; 0x50BE
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
	jr nz,ymmm_ny
	inc a
ymmm_ny:
	out (c),a
	xor a
	out (c),a
	out (c),a
	ld a,0e0h
	out (c),a
	ei
ymmm_done:
	ret
; VDP command from A (48h PSET-style, 58h LINE-style after munging).
vdp_cmd:                          ; 0x5100
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
; Copy B 1bpp tiles from HL to VRAM DE (C = on/off nibbles).
copy_tiles:                       ; 0x514C  B tiles from HL → VRAM DE; C on=low nibble, off=high
	call copy_tile
	call tile_right
	djnz copy_tiles
	ret
; copy_tiles: 1bpp at HL → 4bpp scratch EF80; C on=low nibble, off=high.
tiles_1bpp:                       ; 0x5155
	ld b,008h                     ; 8 pixel rows
	ld de,0ef80h                  ; 4bpp scratch
bpp_row:
	push bc
	push hl
	ex de,hl
	ld a,(de)                     ; 1bpp row
	ld d,a
	ld b,004h                     ; 8 pixels → 4 bytes
bpp_pair:
	ld a,c                        ; on colour
	rl d
	jr c,bpp_on0
	rrca                          ; off = high nibble of C
	rrca
	rrca
	rrca
bpp_on0:
	rld                           ; nybble 0
	ld a,c
	rl d
	jr c,bpp_on1
	rrca
	rrca
	rrca
	rrca
bpp_on1:
	rld                           ; nybble 1
	inc hl
	djnz bpp_pair
	ex de,hl
	pop hl
	inc hl
	pop bc
	djnz bpp_row
	ret
; One 1bpp tile at HL → VRAM DE, then advance HL.
copy_tile:                        ; 0x5181
	push bc
	push de
	push hl
	push de
	call tiles_1bpp
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
	call copy_tile_4bpp
	pop hl
	ld bc,00008h
	add hl,bc
	pop de
	pop bc
	ret
; 8 rows of SCREEN 5 tile
copy_tile_4bpp:
	push de
	ld b,008h
copy4_row:
	push bc
	ld bc,00004h
	call ldirmv
	ld bc,00004h
	add hl,bc
	ex de,hl
	ld bc,00080h
	add hl,bc
	ex de,hl
	pop bc
	djnz copy4_row
	pop de
	ret
; B tiles of 4bpp from HL → VRAM DE.
copy_4bpp:                        ; 0x51BB
	push bc
	call copy_tile_4bpp
	ld a,004h
	add a,e
	cp 080h
	jr nz,copy4_wrap
	ld a,004h
	add a,d
	ld d,a
	xor a
copy4_wrap:
	ld e,a
	pop bc
	djnz copy_4bpp
	ret
; TEXT/TEXT4 stream at HL; 0xFE next pos, 0xFF end.
print_stream:                     ; 0x51D0
	ld c,0ffh
	jr stream_xy
; same stream, glyphs masked to 0
print_stream_blank:               ; 0x51D4  same stream, glyphs masked to 0
	ld c,000h
stream_xy:
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
; Same as print_stream; DE already set.
print_at:                         ; 0x51DA
	ld a,(hl)
	inc hl
	ld b,a
	inc b
	ret z
	inc b
	jr z,stream_xy
	and c
	call print_glyph
	jr print_at
; One glyph at DE, then DE.x += 8.
print_glyph:                      ; 0x51E8
	call tile_hmmm
	ld a,d
	add a,008h
	ld d,a
	ret
stamp_nl:
	ld a,d
	sub 020h
	ld d,a
	ld a,e
	add a,008h
	ld e,a
	jr stamp_at
; 4-wide stamp stream at HL (FE = next row, FF = end). Pause map cells.
stamp_at:                         ; 0x51FA
	ld a,(hl)
	inc hl
	ld b,a
	inc b
	ret z
	inc b
	jr z,stamp_nl
	call print_glyph
	jr stamp_at
; VDP copy one 8x8 tile
tile_hmmm:
	push bc
	push hl
	push de
	call tile_src
	ld bc,00808h
	ld a,001h
	call vdp_hmmm
	pop de
	pop hl
	pop bc
	ret
tile_cmd:
	push bc
	push hl
	push de
	call tile_src
	ld bc,00808h
	ld a,048h
	call vdp_cmd
	pop de
	pop hl
	pop bc
	ret
; one tile scanline
tile_line:
	push bc
	push hl
	push de
	call tile_src
	ld bc,00808h
	ld a,058h
	call vdp_cmd
	pop de
	pop hl
	pop bc
	ret
; tile id A -> VRAM source
tile_src:
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
; D += 8 (next tile to the right)
tile_right:
	ld a,d
	add a,008h
	ld d,a
	ret nz
	ld a,e
	add a,008h
	ld e,a
	ret
exp1_copy:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp1_rows:
	push bc
	call expand_1row
	pop bc
	djnz exp1_rows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_4bpp
exp1_vram:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp1_vrows:
	push bc
	call expand_1row
	pop bc
	djnz exp1_vrows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_vexp
; 8 rows of 1bpp -> SCREEN 5 nibbles
expand_1row:                    ; 0x5281  8 rows of 1bpp -> SCREEN 5 nibbles
	ld b,008h
exp1_loop:
	ld e,(hl)
	inc hl
	push bc
	call expand_1nib
	pop bc
	djnz exp1_loop
	ret
; one 1bpp byte -> 4 SCREEN 5 pixels
expand_1nib:                    ; 0x528D  one 1bpp byte -> 4 SCREEN 5 pixels
	ld b,004h
exp1_nib:
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
	djnz exp1_nib
	ret
exp2_copy:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp2_rows:
	push bc
	call expand_2row
	pop bc
	djnz exp2_rows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_4bpp
exp2_vram:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp2_vrows:
	push bc
	call expand_2row
	pop bc
	djnz exp2_vrows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_vexp
; 8 rows of 2-plane 1bpp
expand_2row:                    ; 0x52DA  8 rows of 2-plane 1bpp
	ld b,008h
exp2_loop:
	push bc
	call expand_2nib
	pop bc
	djnz exp2_loop
	ret
; one 2-plane pair -> SCREEN 5
expand_2nib:                    ; 0x52E4  one 2-plane pair -> SCREEN 5
	ld b,004h
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
exp2_nib:
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
	djnz exp2_nib
	ret
exp3_copy:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp3_rows:
	push bc
	call expand_3row
	pop bc
	djnz exp3_rows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_4bpp
exp3_vram:
	push bc
	push de
	exx
	ld hl,0e800h            ; SAT
	exx
exp3_vrows:
	push bc
	call expand_3row
	pop bc
	djnz exp3_vrows
	pop de
	pop bc
	ld hl,0e800h            ; SAT
	jp copy_vexp
; 8 rows of 3-plane 1bpp
expand_3row:                    ; 0x533B  8 rows of 3-plane 1bpp
	ld b,008h
exp3_loop:
	push bc
	call expand_3nib
	pop bc
	djnz exp3_loop
	ret
; one 3-plane triple -> SCREEN 5
expand_3nib:                    ; 0x5345  one 3-plane triple -> SCREEN 5
	ld b,004h
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
exp3_nib:
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
	djnz exp3_nib
	ret
; SETWRT 8 rows, bit-reversed out
expand_vram:                    ; 0x5378  SETWRT 8 rows, bit-reversed out
	push de
	ld a,(00007h)
	ld c,a
	ld b,008h
vexp_row:
	push bc
	ex de,hl
	call 00171h
	ex de,hl
	ld b,004h
vexp_nib:
	ld a,(hl)
	dec hl
	rrca
	rrca
	rrca
	rrca
	out (c),a
	djnz vexp_nib
	ld c,008h
	add hl,bc
	ex de,hl
	ld c,080h
	add hl,bc
	ex de,hl
	pop bc
	djnz vexp_row
	pop de
	ret
copy_vexp:
	inc hl
	inc hl
	inc hl
vexp_loop:
	push bc
	call expand_vram
	ld a,004h
	add a,e
	cp 080h
	jr nz,vexp_wrap
	ld a,004h
	add a,d
	ld d,a
	xor a
vexp_wrap:
	ld e,a
	pop bc
	djnz vexp_loop
	ret
; sound_init, probe I/O, CHGCLR, wipe VRAM
scr_boot:                         ; 0x53B6  sound_init, probe I/O, CHGCLR, wipe VRAM
	ld a,004h
	ld (07000h),a           ; mapper 6000
	inc a
	ld (09000h),a           ; mapper 8000
	inc a
	ld (0b000h),a           ; mapper A000
	call 06000h             ; banks_456_init
	ld a,(0f0f1h)           ; mapper 6000 copy
	ld (07000h),a           ; mapper 6000
	ld a,(0f0f2h)           ; mapper 8000 copy
	ld (09000h),a           ; mapper 8000
	ld a,(0f0f3h)           ; mapper A000 copy
	ld (0b000h),a           ; mapper A000
	call io_probe                 ; I/O device bits -> F0F9
	ld a,005h
	call 0005fh             ; CHGMOD
	ld a,00fh
	ld (0f3ebh),a           ; BAKCLR
	call 00062h             ; CHGCLR
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
boot_vdp:
	push bc
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	push hl
	call WRTVDP
	pop hl
	pop bc
	djnz boot_vdp
	jp vdp_spr_off

; BLOCK 'vdp_spr' (start 0x5413 end 0x541b)
vdp_spr_start:
	defb 001h, 062h               ; R#1
	defb 005h, 0efh               ; R#5 SAT
	defb 006h, 01fh               ; R#6 sprite generator
	defb 00bh, 001h               ; R#11
vdp_spr_end:
; d_470a[0]
poll_skip:                        ; 0x541B  d_470a[0]
	ret
; stick -> E208/E207; keyrow -> E20D/E20C
poll_keys:                        ; 0x541C  stick -> E208/E207; keyrow -> E20D/E20C
	call read_stick
	call keys_apply
	call read_keyrow
	ld hl,0e20dh            ; title keys
	call keys_apply_at
	ld a,(0e200h)           ; game mode
	cp 00bh
	jp z,keys_repeat
	ret
; A -> E208 held; rising bits -> E207
keys_apply:                       ; 0x5434  A -> E208 held; rising bits -> E207
	ld hl,0e208h            ; keys held
; same at HL (title uses E20D/E20C)
keys_apply_at:                    ; 0x5437  same at HL (title uses E20D/E20C)
	ld c,(hl)
	ld (hl),a
	xor c
	and (hl)
	dec hl
	ld (hl),a
	ret
; PSG R#15/14 joystick + SNSMAT 4/8
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
; SNSMAT 6/7 -> A (OR into poll_keys)
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
; 5-byte records, 0xFF end; tiles @ 0x8000
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
	jr nz,blit_n
	ld a,002h
blit_n:
	ld c,a
	ld b,000h
	ld de,0e700h            ; gems
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
	call blit_kind
	pop hl
	pop de
	inc hl
	jr blit_list
; C&7 -> SCREEN 5 expander
blit_kind:                      ; 0x54EF  C&7 -> SCREEN 5 expander
	ld a,c
	and 007h
	jp z,exp1_copy
	dec a
	jp z,exp1_vram
	dec a
	jp z,exp2_copy
	dec a
	jp z,exp2_vram
	dec a
	jp z,exp3_copy
	jp exp3_vram
; pat_copy list at IX: n, y, src → sprite patterns (SAT library).
copy_pat:                         ; 0x5508
	ld a,(ix+000h)                ; n (0 = end)
	and a
	ret z
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl                     ; n × 32
	ld c,l
	ld b,h
	ld l,(ix+001h)                ; y
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl                     ; y × 8
	ld de,0f800h                  ; MSX2 sprite gen
	ld a,(0f0f4h)
	and a
	jr nz,pat_msx1
	ld de,01800h                  ; MSX1 sprite gen
pat_msx1:
	add hl,de
	ex de,hl
	ld l,(ix+002h)                ; src
	ld h,(ix+003h)
	call ldirmv                   ; BIOS 005Ch
	ld de,00004h
	add ix,de
	jr copy_pat
; pat_flip list at IX: X-mirror n rows in sprite VRAM.
flip_pat:                         ; 0x553D
	ld a,(ix+000h)
	dec a
	ret m                         ; 0 = end
	push af
	ld a,(0f0f4h)
	and a
	ld bc,0f800h                  ; MSX2 sprite gen
	jr nz,flip_msx1
	ld bc,01800h                  ; MSX1
flip_msx1:
	pop af
	push af
	push bc
	call z,flip_pat1              ; n was 1
	pop bc
	pop af
	call nz,flip_pat2             ; n > 1
	ld bc,00004h
	add ix,bc
	jr flip_pat
; one SAT pattern pair
flip_pat1:                      ; 0x5561  one SAT pattern pair
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
flip_loop:
	ld hl,(0efd2h)
	ld de,0ef80h
	ld bc,00020h
	call ldirvm
	call flip_copy
	ld de,(0efd4h)
	ld hl,0efa0h
	ld bc,00020h
	call ldirmv
	ld bc,00020h
	ld hl,(0efd2h)
	add hl,bc
	ld (0efd2h),hl
	ld hl,(0efd4h)
	add hl,bc
	ld (0efd4h),hl
	ld hl,0efd0h
	dec (hl)
	jr nz,flip_loop
	ret
; mirror 16 bytes EFD2 -> EF80
flip_copy:                      ; 0x55B5  mirror 16 bytes EFD2 -> EF80
	ld hl,0ef80h
	ld de,0efafh
	call flip_rev
	ld hl,0ef90h
	ld de,0efbfh
; copy HL.. 16 bytes reversed into DE
flip_rev:                       ; 0x55C4  copy HL.. 16 bytes reversed into DE
	ld b,010h
rev_loop:
	ld a,(hl)
	ld (de),a
	inc hl
	dec de
	djnz rev_loop
	ret
; second pattern plane of flip_pat
flip_pat2:                      ; 0x55CD  second pattern plane of flip_pat
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
	jp spr_copy
; Japanese title dests + stamp_logo_jp
title_jp_gfx:                     ; 0x55F0  Japanese title dests + stamp_logo_jp
	call blit_9074
	call page_banks_ef
	ld de,0b116h
	ld hl,0b120h
	call blit_list
	ld hl,0bb05h
	ld de,0f800h
	ld bc,00100h
	call ldirmv
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
	ld hl,0b8dbh                  ; stamp_logo_jp
	ld de,01050h
	call stamp
	jp page_banks_123
; page triplet 7/8/9, blit world + common gfx
load_world_gfx:                   ; 0x5634  page triplet 7/8/9, blit world + common gfx
	call page_banks_789
	call blit_world
	call blit_common
	jp page_banks_123
; per-world palette+tiles for world (0xE241)=1..6
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
; shared blit list at 0x602A (all worlds)
blit_common:                      ; 0x5655  shared blit list at 0x602A (all worlds)
	ld hl,0602ah
	ld de,06000h
	jp blit_list
; bank 0F palettes by world / level bit 1
pal_15:                           ; 0x565E  bank 0F palettes by world / level bit 1
	call page_banks_ef
	ld a,(0e242h)           ; level
	dec a
	and 002h
	ld hl,0b97ah
	jr z,pal15_hl
	ld hl,0b9f8h
pal15_hl:
	ld a,(0e241h)           ; world
	call tbl_word
	call palette_list
	call page_banks_123
	call page_banks_ef
	ld hl,0b95dh
	call palette_list
	jp page_banks_123
; Unpack rle_abb9 → F800 (pause Vic planes).
copy_abb9:                        ; 0x5687
	call page_banks_ef
	ld hl,0f800h
	ld de,0abb9h
	call rle_vram
	jp page_banks_123
; SAT library (copy_pat / flip_pat, bank 0E)
pat_15:                           ; 0x5696  SAT library (copy_pat / flip_pat, bank 0E)
	call page_banks_ef
	ld ix,098c9h                  ; pat_copy
	call copy_pat
	ld ix,098eah                  ; pat_flip
	call flip_pat
	jp page_banks_123
; tiles_afdd 53 tiles → VRAM 0800h
copy_afdd:                        ; 0x56AA  tiles_afdd 53 tiles → VRAM 0800h
	call page_banks_abc
	ld bc,00307h
	call WRTVDP
	ld hl,0afddh
	ld de,00800h
	ld bc,035fbh
	call copy_tiles
	call page_banks_123
	jp pal_ba78
; stamp 16x16 from bank 0C 0xB1D6 at EF13/14
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
	jp page_123_c
; stamp_wtiles with C=2 (secret punch / 2-tile-wide actor)
stamp_w2:                       ; 0x56DC
	ld c,002h
; B x C world tiles at DE
stamp_wtiles:                   ; 0x56DE  B x C world tiles at DE
	call page_banks_ef
wtiles_row:
	push bc
	push de
	ld b,c
wtiles_col:
	call stamp_wtile
	ld a,d
	add a,008h
	ld d,a
	djnz wtiles_col
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz wtiles_row
	jp page_banks_123
; one world-tileset tile at DE
stamp_wtile:                    ; 0x56F8  one world-tileset tile at DE
	ld a,(0e241h)           ; world
	ld hl,07ffeh
	call tbl_word
	ld a,(0e242h)           ; level
	rra
	ld a,020h
	jr c,wtile_lo
	xor a
wtile_lo:
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
	jp tile_pset
; two RDVRM bytes/row (stone_save MSX1)
vram_pair:                      ; 0x5722
	ld b,002h
vram_rows:
	call NRDVRM
	ld (de),a
	inc hl
	inc de
	call NRDVRM
	ld (de),a
	ld a,01fh
	call ADD_HL_A
	inc de
	djnz vram_rows
	ret
; draw_tilemap via tile_hmmm (EFC0=1)
tilemap_hmmm:                     ; 0x5737  draw_tilemap via tile_hmmm (EFC0=1)
	ld a,001h
	jr tmap_flag
; B×C tile-id grid at HL → DE
draw_tilemap:                     ; 0x573B  B×C tile-id grid at HL → DE
	xor a
tmap_flag:
	ld (0efc0h),a           ; stamp row
tmap_row:
	push bc
	push de
	ld b,c
tmap_col:
	ld a,(hl)
	push hl
	call tile_draw
	pop hl
	ld a,d
	add a,008h
	ld d,a
	inc hl
	djnz tmap_col
	pop de
	ld a,e
	add a,008h
	ld e,a
	pop bc
	djnz tmap_row
	ret
; stamp from EFC0 row ptrs
tile_draw:
	push af
	ld a,(0efc0h)           ; stamp row
	and a
	jr nz,tmap_hmmm
	pop af
	call tile_pset
	ret
tmap_hmmm:
	pop af
	jr tile_hmmm_at
; 8×8 PSET of tile A at DE.
tile_pset:                        ; 0x5767
	jp tile_cmd
; HMMM 8×8 of tile A at DE
tile_hmmm_at:                     ; 0x576A  HMMM 8×8 of tile A at DE
	jp tile_hmmm
; STAMP stream at HL onto VRAM DE: tile id; FE,dy = next row; FF = end.
stamp:                            ; 0x576D
	push de                       ; dest
stamp_byte:
	ld a,(hl)
	inc hl
	ld c,a
	inc a
	jr z,stamp_end                   ; FF = end
	inc a
	jr nz,stamp_tile                  ; not FE
	pop de
	ld a,(hl)                     ; row delta (dy)
	inc hl
	add a,d
	ld d,a
	ld a,008h                     ; +8 X
	add a,e
	ld e,a
	jr stamp
stamp_tile:
	ld a,c                        ; tile id
	call tile_line
	call tile_right
	jr stamp_byte
stamp_end:
	pop de
	ret
; pic_bc05 13×26 at 1830 (sound-select)
snd_board:                        ; 0x578D  pic_bc05 13×26 at 1830 (sound-select)
	call scr_off
	ld b,003h
	ld c,007h
	call WRTVDP
	call page_banks_ef
	ld bc,00d1ah
	ld hl,0bc05h
	ld de,01830h
	call draw_tilemap
	call page_123_c
	jp scr_on
; blit_list b7df then palettes, stay on C
snd_blit:                         ; 0x57AC  blit_list b7df then palettes, stay on C
	call page_banks_789
	ld de,0b7c7h
	ld hl,0b7dfh
	call blit_list
	call page_banks_123
pal_ba78:
	call page_banks_ef
	ld hl,0ba78h
	call palette_list
; restore triplet 123 then bank C
page_123_c:                     ; 0x57C4
	call page_banks_123
	jp page_bank_c
; Finger-pointer SAT (rle_ba9a → F800). Puzzle UI / sound-select.
copy_pointer:                     ; 0x57CA
	call page_banks_ef
	ld hl,0f800h
	ld de,0ba9ah                  ; pointer.png
	call rle_vram
	jr page_123_c
; swap SAT buffers, WRTVDP R#5
sat_flip:                         ; 0x57D8  swap SAT buffers, WRTVDP R#5
	ld hl,(0e210h)
	bit 2,h
	ld hl,0f600h
	ld de,0f400h
	ld bc,0e705h
	jr z,sat_alt
	ld hl,0f200h
	ld de,0f000h
	ld bc,0ef05h
sat_alt:
	ld (0e212h),hl
	ld (0e210h),de
	jp WRTVDP
; OTIR software SAT -> VRAM
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
blit_pat:
	ld h,069h
	ld l,a
	add hl,hl
	ld b,020h
	otir
	add a,090h
	dec d
	jr nz,blit_pat
	ld hl,(0e212h)
	call 00171h
	ld a,(0e20bh)
	ld d,010h
	ld h,0e8h
blit_sat:
	ld b,008h
	ld l,a
	otir
	add a,048h
	and 078h
	dec d
	jr nz,blit_sat
	ret
; D200→F400 (512) + SAT E800→F600
spr_vram:                         ; 0x583B  D200→F400 (512) + SAT E800→F600
	ld bc,0ef05h
	call WRTVDP
	ld hl,0d200h            ; boot spare
	ld de,0f400h
	ld bc,00200h
	call ldirmv
	ld hl,0e800h            ; SAT
	ld de,0f600h
	ld bc,00080h
	jp ldirmv
; Tool patterns + vic_blit tiles from banks 0E/0F.
vic_reload:                       ; 0x5859
	call vic_reload_go
	jp page_banks_123
; tool patterns then vic_go
vic_reload_go:
	call vic_pat_far
	jr vic_go
; Vic tiles from banks 0E/0F.
vic_blit:                         ; 0x5864
	call vic_go
	jp page_banks_123
; Vic tiles from 0E/0F (pause / die / held)
vic_go:                         ; 0x586A
	call page_banks_ef
	ld a,(0e24ch)                 ; pause
	or a
	jr nz,vic_blit_pause
	ld a,(0e298h)                 ; die / hit SAT
	or a
	jp nz,vic_blit_die
	ld a,(0e287h)                 ; held tool
	and 00fh
	ld hl,0e297h
	cp (hl)
	call nz,vic_pat_sync          ; tool changed
	ld a,(0e285h)                 ; vic_hmm frame
	add a,a
	ld e,a
	ld d,000h
	ld hl,0869ch                  ; vic_hmm dests
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,000f0h                  ; pattern src
	ex de,hl
	ld bc,08001h
	ld a,005h
	call vdp_hmmm
	ld a,(0e285h)           ; vic frame
	add a,a
	ld e,a
	ld d,000h
	ld hl,086b8h                  ; vic_hmm2 colour dests
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,080f0h                  ; colour src
	ex de,hl
	ld bc,08001h
	ld a,005h
	jp vdp_hmmm
; Die/hit HMMM from 00C0 (E285).
vic_blit_die:                     ; 0x58BA
	ld a,(0e285h)           ; vic frame
vic_src:
	ld de,000f0h
	ld hl,000c0h
	add a,l
	ld l,a
	ld bc,0ff01h
	ld a,005h
vic_hmmm:
	jp vdp_hmmm
; Pause HMMM (E2B3).
vic_blit_pause:                   ; 0x58CD
	ld a,(0e2b3h)
	jr vic_src
; Page 0E/0F, load Vic SAT for held / die / pause.
vic_pat_far:                      ; 0x58D2
	call page_banks_ef
	call vic_pat
	jp page_banks_123
; Vic sprite planes: held_ptr, else vic_die_rle / vic_pause_rle.
vic_pat:                          ; 0x58DB
	ld a,(0e24ch)                 ; pause
	or a
	jr nz,vic_pause_rle
	ld a,(0e298h)                 ; die / hit
	or a
	jr nz,vic_die_rle
	ld a,(0e287h)                 ; held 0–6
	add a,a
	ld e,a
	ld d,000h
	ld hl,0858bh                  ; held_ptr
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
pat_op:
	ld a,(hl)
	cp 0ffh                       ; VIC_END
	ret z
	and 00fh
	jr nz,vic_planes                  ; VIC_COPY
	ld e,(hl)                     ; VIC_RLE dest, src
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
	call rle_vram
	pop hl
	jr pat_op
vic_planes:
	ld c,a                        ; plane count
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
	call spr_copy
	pop hl
	jr pat_op
; E297 ← held; reload SAT
vic_pat_sync:                     ; 0x5925  E297 ← held; reload SAT
	ld (hl),a
	jr vic_pat
; vic_die / vic_hit overlay (rle_953d / vic_die.png).
vic_die_rle:                      ; 0x5928
	call page_banks_ef
	ld hl,0e000h            ; work RAM / stack
	ld de,0953dh                  ; rle_953d
	call rle_vram
	jp page_banks_123
; Pause SAT: rle_ab59 → E000, rle_aa00 pushups → E080 (vic_pushup.png).
vic_pause_rle:                    ; 0x5937
	call page_banks_ef
	ld hl,0e000h            ; work RAM / stack
	ld de,0ab59h                  ; rle_ab59
	call rle_vram
	ld hl,0e080h
	ld de,0aa00h                  ; vic_pushup
	call rle_vram
	jp page_banks_123
; Thrown knife + boomerang spin (rle_97a1 / knife.png).
col_15:                           ; 0x594F
	call page_banks_ef
	call knife_rle
	jp page_banks_123
; held-knife RLE to VRAM
knife_rle:                        ; 0x5958
	ld hl,0f880h
	ld de,097a1h                  ; rle_97a1
	jp rle_vram
; bank 08 blit list 0x902E → 8FFC
blit_902e:                        ; 0x5961  bank 08 blit list 0x902E → 8FFC
	call page_banks_789
	ld hl,0902eh
	ld de,08ffch
	call blit_list
	jp page_banks_123
; blit_list at 9043
blit_9043:                        ; 0x5970
	call page_banks_789
	ld hl,09043h
	ld de,08ffch
	call blit_list
	jp page_banks_123
; blit_list at 9063
blit_9063:                        ; 0x597F
	call page_banks_789
	ld hl,09063h
	ld de,08ffch
	call blit_list
	jp page_banks_123
; blit_list at 9069
blit_9069:                        ; 0x598E
	call page_banks_789
	ld hl,09069h
	ld de,08ffch
	call blit_list
	jp page_banks_123
; blit_list at 9074
blit_9074:                        ; 0x599D
	call page_banks_789
	ld hl,09074h
	ld de,08ffch
	call blit_list
	jp page_banks_123
; 12x12 at DE=1818h
pic_a358_at:                      ; 0x59AC  12x12 at DE=1818h
	ld de,01818h
; 12x12 from A358; DE set by caller
pic_a358:                         ; 0x59AF  12x12 from A358; DE set by caller
	call page_banks_ef
	ld hl,0a358h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
; 12x12 tilemap at a2c8
pic_a2c8:                         ; 0x59BE
	call page_banks_ef
	ld hl,0a2c8h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
; 12x12 tilemap at a702
pic_a702:                         ; 0x59CD
	call page_banks_ef
	ld hl,0a702h
	ld bc,00c0ch
	call draw_tilemap
	jp page_banks_123
; A = start idx; 32× 1-wide tilemap from 9D58
draw_cols:                        ; 0x59DC  A = start idx; 32× 1-wide tilemap from 9D58
	push af
	ld bc,0a201h
	call WRTVDP
	pop af
	call draw_cols_body
	ld bc,0e201h            ; substate
	jp WRTVDP
; 32x 1-wide tilemaps from 9D58
draw_cols_body:                 ; 0x59ED  32x 1-wide tilemaps from 9D58
	call page_banks_ef
	ld de,00000h
	ld b,020h
cols_loop:
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
	djnz cols_loop
	jp page_banks_123
; 12x2 tiles at B038 (world-complete)
wpic0:                            ; 0x5A17  12x2 tiles at B038 (world-complete)
	call page_banks_ef
	ld hl,0a5a6h
	ld de,0b038h
	ld bc,00c02h
	call draw_tilemap
	jp page_banks_123
; 12x4 tiles at A838
wpic1:                            ; 0x5A29  12x4 tiles at A838
	call page_banks_ef
	ld hl,0a5beh
	ld de,0a838h
	ld bc,00c04h
	call draw_tilemap
	jp page_banks_123
; 14x6 tiles at A030
wpic2:                            ; 0x5A3B  14x6 tiles at A030
	call page_banks_ef
	ld hl,0a5eeh
	ld de,0a030h
	ld bc,00e06h
	call draw_tilemap
	jp page_banks_123
; bank 0F stream at 8848
strm_a6e0:                        ; 0x5A4D  bank 0F stream at 8848
	call page_banks_ef
	ld hl,0a6e0h                  ; stamp_a6e0
	ld de,08848h
	call stamp
	jp page_banks_123
; hallway pair offscreen (world_blit / Vic from behind)
strm_hallway:                     ; 0x5A5C  hallway pair offscreen (world_blit)
	call page_banks_ef
	ld hl,0a3e8h                  ; stamp_hallway0
	ld de,00040h
	call stamp
	ld hl,0a4c7h                  ; stamp_hallway1
	ld de,06040h
	call stamp
	jp page_banks_123
; stamp stream at a642
strm_a642:                        ; 0x5A74
	call page_banks_ef
	ld hl,0a642h                  ; stamp_a642
	ld de,06040h
	call stamp
	ld hl,0a6b1h                  ; stamp_a6b1
	ld de,09040h
	call stamp
	jp page_banks_123
; Vic-back SAT (2 poses) + map-mark SAT
copy_af21:                        ; 0x5A8C  Vic-back SAT + map-mark SAT
	call page_banks_ef
	ld de,0af21h                  ; vic_back → F820 (pat 4 / 0x34)
	ld hl,0f820h
	call rle_vram
	ld de,0a9fbh                  ; rle_a9fb map Vic mark → FE80
	ld hl,0fe80h
	call rle_vram
	jp page_banks_123
	ret
; ending 14/15 → VRAM
copy_ab59:                        ; 0x5AA5  ending 14/15 → VRAM
	call page_banks_ef
	ld de,0ab59h                  ; rle_ab59
	ld hl,0f800h
	call rle_vram
	ld de,086d4h                  ; rle_86d4
	ld hl,0f880h
	call rle_vram
	ld de,08fd9h                  ; rle_8fd9
	ld hl,0f940h
	call rle_vram
	ld de,0ae08h                  ; rle_ae08
	ld hl,0fa00h
	call rle_vram
	ld de,0a9f6h                  ; rle_a9f6
	ld hl,0fe80h
	call rle_vram
	jp page_banks_123
; password/continue 14/15 → VRAM
copy_pwd:                         ; 0x5AD8  password/continue 14/15 → VRAM
	call page_banks_ef
	ld de,0ab59h                  ; rle_ab59
	ld hl,0f800h
	call rle_vram
	ld de,086d4h                  ; rle_86d4
	ld hl,0fc80h
	call rle_vram
	ld de,08fd9h                  ; rle_8fd9
	ld hl,0fd40h
	call rle_vram
	ld de,0ae08h                  ; rle_ae08
	ld hl,0fa00h
	call rle_vram
	ld de,0a9fbh                  ; rle_a9fb
	ld hl,0fe80h
	call rle_vram
	ld hl,0fc80h
	ld de,0f890h
	ld c,00ch
	call spr_copy
	jp page_banks_123
; bank 0C wmap font → VRAM 8030 / B838
tiles_wmap:                       ; 0x5B16  bank 0C wmap font → VRAM 8030 / B838
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h                  ; wmap_aa29 font
	ld bc,0290ah
	call copy_tiles
	ld de,0b838h
	ld hl,0ab79h                  ; wmap_ab79 font
	ld bc,0050ah
	call copy_tiles
	jp page_banks_123
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h                  ; wmap_aa29 font
	ld bc,02a0ch
	call copy_tiles
	ld de,0b838h
	ld hl,0ab79h                  ; wmap_ab79 font
	ld bc,0050ch
	call copy_tiles
	jp page_banks_123
; password palette
pal_a7ff:                         ; 0x5B52  password palette
	call page_banks_ef
	ld hl,0a7ffh
	call palette_list
	jp page_banks_123
; ending palette
pal_a8bb:                         ; 0x5B5E  ending palette
	call page_banks_ef
	ld hl,0a8bbh
	call palette_list
	jp page_banks_123
; banks 07–9 palette + tiles, E2C0 countdown
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
	ld de,07000h            ; mapper 6000
	ld bc,00d02h
	call copy_tiles
	ld hl,0bcach
	ld de,0d800h
	ld bc,01a03h
	call copy_tiles
	ld de,htimi_gate+2
	ld hl,0bb9bh                  ; stamp_logo_konami
	call stamp
	call scr_on
	ld hl,0e2c0h            ; delayed pickups
	ld (hl),03ch
	inc hl
	ld (hl),031h
	inc hl
	ld (hl),000h
	call page_banks_123
	ret
; world-map stamp HMMM on E2C0 timer
wmap_slide:                     ; 0x5BC8  world-map stamp HMMM on E2C0 timer
	ld hl,0e2c0h            ; delayed pickups
	dec (hl)
	ld a,(hl)
	and 001h
	ret nz
	inc hl
	dec (hl)
	jr nz,slide_go
	ld a,001h
	ld (0e2c2h),a
	ret
slide_go:
	ld a,031h
	sub (hl)
	ld c,a
	ld b,0a8h
	ld hl,02840h
	ld de,02840h
	ld a,001h
	jp vdp_hmmm
; World-map font from bank 0C (aa29 / aa89 / abc1).
wmap_font:                        ; 0x5BEB
	call page_banks_abc
	ld de,08030h
	ld hl,0aa29h                  ; wmap_aa29 font
	ld bc,00c0bh
	call copy_tiles
	ld de,00038h            ; KEYINT
	ld hl,0aa89h
	ld bc,01e0bh
	call copy_tiles
	ld hl,0abc1h
	ld de,09870h
	ld b,002h
	call copy_4bpp
	jp page_banks_123
hud_world:                        ; 0x5C14  per-world HUD from bank 0F bd52
	call page_banks_ef
	ld a,(0e241h)           ; world
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
	call hud_anim
	ld a,(0e241h)           ; world
	cp 004h
	jp nz,page_banks_123
	exx
	ld b,005h
	exx
	ld bc,00602h
	ld de,0bdafh
	ld hl,0ef04h
	call hud_anim
	jp page_banks_123
; HUD frame timer at HL
hud_anim:
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
	jr nz,anim_dec
	inc (hl)
	ld a,(hl)
	dec c
	cp c
	jr c,anim_pal
	jr anim_flip
anim_dec:
	dec (hl)
	ld a,(hl)
	and a
	jr nz,anim_pal
anim_flip:
	dec hl
	ld a,(hl)
	xor 001h
	ld (hl),a
anim_pal:
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
; world (0xE241) = ceil(level (0xE242)/10), 1..6
set_world:                        ; 0x5C80  world (0xE241) = ceil(level (0xE242)/10), 1..6
	ld a,(0e254h)
	and a
	jp nz,room_draw
	ld a,(0e242h)                 ; level number (1-based)
	dec a
	ld b,001h
world_div:
	sub 00ah                      ; divide (level-1) by 10, B = quotient+1 = world
	jr c,world_set
	inc b
	jr world_div
world_set:
	ld a,b
	ld (0e241h),a           ; world
	call load_world_gfx
	call pat_15
	call col_15
	call pal_15
	ld hl,0e2c0h            ; delayed pickups
	ld de,0e2c1h
	ld bc,00d3fh
	ld (hl),000h
	ldir
	call sat_wipe
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,001ffh
	ld (hl),000h
	ldir
	call load_vic
	call load_delayed
	call load_gems_far
	call load_exit
	call load_screens
	call load_links
	call screen_idx
	call load_pyramid
	call load_actors_far
	call load_map_tools_far
	call e300_list
	call page_bank_c
	call 0b400h                   ; load_ef10 (bank 0C MODULE)
	call page_banks_123
	xor a
	ld (0e287h),a           ; held tool
	ld (0edcdh),a
	call vic_pat_far
; Redraw current screen (E243) and set E250 map base.
room_draw:                        ; 0x5CF5
	call scr_reset
	call spr_clear
	call scr_off
	call stamp_actors
	call load_stage
	call page_bank_c
	call 0b51ch                   ; draw_ef10 (bank 0C MODULE)
	call page_banks_123
	call draw_exit
	call nudge_stones
	call draw_actors
	call draw_maptools
	call draw_stones
	call stamp_actors_c3
	call over_hud
	call scr_on
	ld hl,(0e243h)          ; screen
	dec l
	ld h,000h
	call map_base
	ld (0e250h),hl          ; map base
	ret
; Screen index HL → unpacked-map pointer in E900 (192 bytes/screen).
map_base:                         ; 0x5D32
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
	ret
; Fill software SAT at E800 with Y=0xE0 (offscreen).
sat_wipe:                         ; 0x5D41
	ld hl,0e800h            ; SAT
	ld de,0e801h
	ld bc,0007fh
	ld (hl),0e0h
	ldir
	ret
; E21B countdown blinks VDP R#7
border_flash:                     ; 0x5D4F  E21B countdown blinks VDP R#7
	ld hl,0e21bh
	ld a,(hl)
	and a
	ret z
	dec (hl)
	ld a,(hl)
	rra
	ld b,000h
	jr nc,flash_off
	ld b,00bh
flash_off:
	ld c,007h
	jp WRTVDP
; vblank wrap around play_tick
play_frame:                       ; 0x5D63  vblank wrap around play_tick
	call sat_flip
	call play_tick
	call sat_blit
	ret
; Vic, tools, gems, actors, exit, secrets, EF10.
play_tick:                        ; 0x5D6D
	call border_flash
	call vic_tick
	call vic_blit
	call vic_sat
	call tick_map_tools
	call tools_sat
	call probe_pickup
	call touch_gems
	call tick_delayed
	call tick_enemies
	call enemy_sat
	call probe_exit
	call tick_actors
	call secret_hit                 ; bank 03: jump-reveal obj2
	call page_bank_c
	call 0b422h                   ; tick_ef10 (bank 0C MODULE)
	call page_banks_123
	call vic_enemy_overlap
	call e300_enemy_hit
	call bgm_toggle
	jp hud_world
; Pyramid screen-present bits (ab5a_flags) → E788.
load_screens:                     ; 0x5DAC
	call page_bank_d
	ld hl,0e780h
	ld de,0e781h
	ld bc,0003fh
	ld (hl),000h
	ldir
	ld de,0ab5ah
	ld a,(0e242h)           ; level
	dec a
	ld l,a
	ld h,000h
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,de
	ex de,hl
	ld hl,0e788h            ; screen ids
	ld bc,00801h
scr_byte:
	push bc
	ld a,(de)
	ld b,008h
scr_bit:
	rla
	jr nc,scr_gap
	ld (hl),c
	inc c
scr_gap:
	inc hl
	djnz scr_bit
	inc de
	ld a,c
	pop bc
	ld c,a
	djnz scr_byte
	jp page_banks_123
; E243 -> slot in E788 -> E244
screen_idx:                       ; 0x5DE6  E243 -> slot in E788 -> E244
	ld a,(0e243h)           ; screen
	call screen_slot
	ld (0e244h),a
	ret
; Find screen id A in E788; return slot index.
screen_slot:                      ; 0x5DF0
	ld hl,0e788h            ; screen ids
	ld c,000h
slot_scan:
	cp (hl)
	jr z,slot_hit
	inc hl
	inc c
	jr slot_scan
slot_hit:
	ld a,c
	ret
; E248 dir -> wrap Vic, next screen E243
room_exit:                        ; 0x5DFE  E248 dir -> wrap Vic, next screen E243
	ld a,(0e244h)
	ld b,a
	ld hl,0e248h            ; exit dir
	ld a,(hl)
	ld (0e2f9h),a
	ld (hl),000h
	ld c,a
	call room_wrap
	ld a,c
	call room_link
	ld (0e243h),hl          ; screen
	ret
; dir 1..4 -> Vic Y/X on the new screen
room_wrap:                        ; 0x5E17  dir 1..4 -> Vic Y/X on the new screen
	dec a
	jr z,wrap_up                   ; 1 up: Y=0xAD (bottom)
	dec a
	jr z,wrap_down                   ; 2 down: Y=3 (top)
	dec a
	jr z,wrap_left                   ; 3 left: X=0xF2 (right)
	ld a,003h                     ; 4 right: X=3 (left)
	ld (0e284h),a           ; Vic X
	ret
wrap_left:
	ld a,0f2h
	ld (0e284h),a           ; Vic X
	ret
wrap_up:
	ld a,0adh
	ld (0e282h),a           ; Vic Y
	ret
wrap_down:
	ld a,003h
	ld (0e282h),a           ; Vic Y
	ret
; Door tables ED80 up / ED90 down / EDA0 left / EDB0 right.
room_link:                        ; 0x5E38
	call link_disp
	ld hl,(0efc0h)          ; stamp row
	ret
; DISPATCH_A on dir 1..4 → ED80/90/A0/B0.
link_disp:                        ; 0x5E3F
	dec a
	call DISPATCH_A

; BLOCK 'd_5e40_jp' (start 0x5e43 end 0x5e4b)
d_5e40_jp_start:
	defw link_up                  ; 1 ED80 (screen-8)
	defw link_down                ; 2 ED90 (screen+8)
	defw link_left                ; 3 EDA0 (screen-1 in row)
	defw link_right               ; 4 EDB0 (screen+1 in row)
d_5e40_jp_end:
link_up:
	ld a,b
	sub 008h
	jr nc,link_up_a
	add a,030h
link_up_a:
	ld hl,0ed80h            ; link up
	jr link_got
link_down:
	ld a,b
	add a,008h
	cp 030h
	jr c,link_dn_a
	sub 030h
link_dn_a:
	ld hl,0ed90h            ; link down
	jr link_got
link_left:
	ld a,b
	dec a
	and 007h
	ld c,a
	ld a,b
	and 0f8h
	or c
	ld hl,0eda0h            ; link left
	jr link_got
link_right:
	ld a,b
	inc a
	and 007h
	ld c,a
	ld a,b
	and 0f8h
	or c
	ld hl,0edb0h            ; link right
link_got:
	ld (0efc1h),a
	ld de,0e788h            ; screen ids
	call ADD_DE_A
	ld a,(de)
	and a
	jr z,door_scan
	ld (0efc0h),a           ; stamp row
	ret
door_scan:
	ld a,(hl)
	cp 0ffh
	jr z,link_dead
	cp b
	inc hl
	jr z,link_hit
	inc hl
	jr door_scan
link_hit:
	ld a,(hl)
	cp b
	call z,link_dead
	ld (0efc1h),a
	ld hl,0e788h            ; screen ids
	call ADD_HL_A
	ld a,(hl)
	ld (0efc0h),a           ; stamp row
	ret
; no dest screen: E24D=1 (room_exit abort)
link_dead:                      ; 0x5EAF
	ld hl,0e24dh
	ld (hl),001h
	ret
; door links (adcf/ae47/aebf/af37) -> ED80..EDB0
load_links:                        ; 0x5EB5  door links (adcf/ae47/aebf/af37) -> ED80..EDB0
	call page_bank_d
	ld hl,0adcfh
	ld de,0ed80h            ; link up
	call copy_link
	ld hl,0ae47h
	ld de,0ed90h            ; link down
	call copy_link
	ld hl,0aebfh
	ld de,0eda0h            ; link left
	call copy_link
	ld hl,0af37h
	ld de,0edb0h            ; link right
	call copy_link
	jp page_banks_123
; Copy one door-link list (level word table at HL → DE, 0xFF end).
copy_link:                        ; 0x5EDF
	ld a,(0e242h)           ; level
	call tbl_word
link_bytes:
	ld a,(hl)
	inc a
	jr z,link_term
	ldi
	ldi
	jr link_bytes
link_term:
	ldi
	ret
; BLOCK 'print_txt' (start 0x5ef2 end 0x5f8d)
print_txt_start:
txt_hud:                         ; 0x5EF2  hiscore / score / stage / rest
	defb 010h, 0c2h         ; D,E
	TEXT "hiscore"
	defb 0feh, 060h, 0c2h   ; next D,E
	TEXT "score"
	defb 0feh, 098h, 0c2h   ; next D,E
	TEXT "stage"
	defb 0feh, 0d0h, 0c2h   ; next D,E
txt_rest:                         ; 0x5F0E  glyphs only; DE preloaded
	TEXT "rest"
	defb 0ffh               ; end
txt_stage:                         ; 0x5F13  stage / soul stone
	defb 060h, 048h         ; D,E
	TEXT "stage"
	defb 0feh, 048h, 068h   ; next D,E
	TEXT "soul stone"
	defb 0ffh               ; end
txt_file:                         ; 0x5F28  file; then Konami / 1988 (':' = ©)
	defb 060h, 048h         ; D,E
	TEXT "file"
	defb 0ffh               ; end
	defb 038h, 050h         ; D,E
	TEXT ":konami 1988"
	db 0feh                   ; next D,E is txt_game if the stream is walked
txt_game:                         ; 0x5F3E  game
	defb 050h, 08ch         ; D,E
	TEXT "game"
	defb 0ffh               ; end
txt_edit:                         ; 0x5F45  edit
	defb 050h, 09ch         ; D,E
	TEXT "edit"
	defb 0ffh               ; end
txt_over:                         ; 0x5F4C  game  over
	defb 058h, 058h         ; D,E
	TEXT "game  over"
	defb 0ffh               ; end
txt_cont:                         ; 0x5F59  continue
	defb 050h, 068h         ; D,E
	TEXT "f5  continue"
	defb 0ffh               ; end
txt_ptr:                         ; 0x5F68  glyphs only; DE preloaded
	TEXT "<="
	defb 0ffh               ; end
txt_play:                         ; 0x5F6B  hiscore / st / rest / score
	defb 048h, 048h         ; D,E
	TEXT "hiscore "
	defb 0feh, 050h, 068h   ; next D,E
	TEXT "st "
	defb 0feh, 080h, 068h   ; next D,E
	TEXT "rest "
	defb 0feh, 058h, 058h   ; next D,E
	TEXT "score "
	defb 0ffh               ; end
print_txt_end:

; Japanese title screen (boot / return)
title_jp:                         ; 0x5F8D  Japanese title screen (boot / return)
	call scr_reset
	call vdp_fill
	ld bc,00007h
	call WRTVDP
	call title_jp_gfx
	call vdp_spr_on
	ld hl,00039h
	ld (0e214h),hl
	ret
; HMMV-style fill (HL=0040, BC=0080)
vdp_fill:                         ; 0x5FA6  HMMV-style fill (HL=0040, BC=0080)
	xor a
	ld h,a
	ld l,040h
	ld b,a
	ld c,080h
	ld d,001h
	jp vdp_lmmv
; wipe world-map meter then hud_meter_end (title_reset)
title_meter:                    ; 0x5FB2
	ld hl,01050h
	ld de,01820h
	ld bc,0a838h
	ld a,048h
	call vdp_cmd
	call hud_meter_end
	jp scr_on
; world HUD meter slide (E203 even)
hud_meter:                      ; 0x5FC6  world HUD meter slide (E203 even)
	ld a,(0e203h)           ; puzzle board
	rra
	ret c
	ld hl,0e214h
	dec (hl)
	jr z,hud_meter_end
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
; final HUD meter blit
hud_meter_end:                  ; 0x5FE7  final HUD meter blit
	ld hl,03084h
	ld bc,04828h
	xor a
	ld d,a
	call vdp_lmmv
	ld hl,03084h
	ld de,04828h
	ld c,00dh
	call vdp_box
	ld hl,txt_game
