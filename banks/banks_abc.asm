; ===========================================================================
;  banks a-c — map triplet via page_banks_abc, CPU 0x6000–0xBFFF (one PHASE).
;  Also paged A000-only by page_bank_c (6000/8000 keep the previous triplet).
;  map_ptr / obj_ptr / obj2_ptr; unpack_map streams; overlays; world-map font;
;  print_stream; tiles_afdd / file_pat / ef10_spr; code from 0xB400.
;  Regen one 8K bank at a time:
;    tools/workbench/msx/regen-bank.sh 10 0x6000 banks/banks_abc.blocks
;    tools/workbench/msx/regen-bank.sh 11 0x8000 banks/banks_abc.blocks
;    tools/workbench/msx/regen-bank.sh 12 0xA000 banks/banks_abc.blocks
; ===========================================================================

map_ptr:
	defw map_01, map_02, map_03, map_04, map_05, map_06, map_07, map_08
	defw map_09, map_10, map_11, map_12, map_13, map_14, map_15, map_16
	defw map_17, map_18, map_19, map_20, map_21, map_22, map_23, map_24
	defw map_25, map_26, map_27, map_28, map_29, map_30, map_31, map_32
	defw map_33, map_34, map_35, map_36, map_37, map_38, map_39, map_40
	defw map_41, map_42, map_43, map_44, map_45, map_46, map_47, map_48
	defw map_49, map_50, map_51, map_52, map_53, map_54, map_55, map_56
	defw map_57, map_58, map_59, map_60
obj_ptr:
	defw obj_a363, obj_a36a, obj_a36b, obj_a377, obj_a395, obj_a39d, obj_a3a3, obj_a3b7
	defw obj_a3da, obj_a3dd, obj_a3e6, obj_a3f3, obj_a3f4, obj_a40d, obj_a440, obj_a459
	defw obj_a465, obj_a46a, obj_a48b, obj_a492, obj_a4d8, obj_a4e7, obj_a506, obj_a546
	defw obj_a574, obj_a597, obj_a5ac, obj_a5d5, obj_a5f6, obj_a5fb, obj_a62d, obj_a64c
	defw obj_a66d, obj_a688, obj_a6cc, obj_a6d4, obj_a702, obj_a71a, obj_a734, obj_a739
	defw obj_a7a8, obj_a7b5, obj_a7bf, obj_a7db, obj_a815, obj_a826, obj_a868, obj_a87b
	defw obj_a88c, obj_a8b1, obj_a8f7, obj_a8fa, obj_a8fd, obj_a90e, obj_a916, obj_a932
	defw obj_a922, obj_a92a, obj_a933, obj_a9a0
obj2_ptr:
	defw obj2_a3de, obj2_a3de, obj2_a3de, obj2_a3de, obj2_a3de, obj2_a3de, obj2_a3de, obj2_a3de
	defw obj2_a3df, obj2_a3e2, obj2_a4b2, obj2_a4b0, obj2_a4b2, obj2_a4b2, obj2_a4b2, obj2_a4b3
	defw obj2_a4bc, obj2_a4d5, obj2_a4d7, obj2_a4d7, obj2_a613, obj2_a614, obj2_a617, obj2_a618
	defw obj2_a61d, obj2_a61d, obj2_a61e, obj2_a625, obj2_a62a, obj2_a62c, obj2_a779, obj2_a77a
	defw obj2_a77b, obj2_a77c, obj2_a77d, obj2_a795, obj2_a796, obj2_a797, obj2_a798, obj2_a7a7
	defw obj2_a8c1, obj2_a8c4, obj2_a8f6, obj2_a8f6, obj2_a8c7, obj2_a8e9, obj2_a8f6, obj2_a8ef
	defw obj2_a8f6, obj2_a8f6, obj2_a9d4, obj2_a9d9, obj2_a9e9, obj2_a9ee, obj2_a9f1, obj2_a9f7
	defw obj2_aa06, obj2_aa14, obj2_a97d, obj2_aa1e
	INCLUDE "banks/data/maps0A.asm"
; --- bank 0B @ 0x8000 ---
	INCLUDE "banks/data/maps0B.asm"
; --- bank 0C @ 0xA000 ---
	INCLUDE "banks/data/maps0C.asm"
	INCLUDE "banks/data/overlays.asm"
	INCLUDE "banks/data/wmap.asm"
; 0xAC01–0xAF37 print_stream (password / per-world / ending+credits).
; Ending / world-map font is TEXT4 (displayed ASCII, stored ch-4).
; world_txt has five defw. Completing world 6 still does print_world with
; index 5: that word is str_w1's D,E 20h,90h (= ptr 0x9020), inside
; bank 0B map stream 0x8EA8 — not a TEXT island (ends at 0xFF @ 0x905E).
str_pwd_best:                     ; 0xAC01  password card (normal font)
	defb 048h, 020h         ; D,E
	TEXT "do your best ;;"
	defb 0ffh               ; end
world_txt:                        ; 0xAC13  E241-1 → print_stream (print_world)
	defw str_w1, str_w2, str_w3, str_w4, str_w5
str_w1:                           ; 0xAC1D  world 1; AT is world_txt[5]
	defb 020h, 090h         ; D,E
	TEXT4 "hold out??"
	defb 0ffh               ; end
str_w2:                           ; 0xAC2A  world 2
	defb 020h, 088h         ; D,E
	TEXT4 "try to tAke"
	defb 0feh, 020h, 098h   ; next D,E
	TEXT4 "A new step"
	defb 0feh, 020h, 0a8h   ; next D,E
	TEXT4 "forwArd"
	defb 0ffh               ; end
str_w3:                           ; 0xAC4F  world 3
	defb 018h, 080h         ; D,E
	TEXT4 "heAven knows"
	defb 0feh, 030h, 090h   ; next D,E
	TEXT4 "when"
	defb 0feh, 020h, 0a0h   ; next D,E
	TEXT4 "this gAme"
	defb 0feh, 030h, 0b0h   ; next D,E
	TEXT4 "will end"
	defb 0ffh               ; end
str_w4:                           ; 0xAC7C  world 4
	defb 012h, 088h         ; D,E
	TEXT4 "oh? my god?"
	defb 0feh, 020h, 098h   ; next D,E
	TEXT4 "i Believe"
	defb 0feh, 040h, 0a8h   ; next D,E
	TEXT4 "in god"
	defb 0ffh               ; end
str_w5:                           ; 0xAC9F  world 5
	defb 018h, 088h         ; D,E
	TEXT4 "At long lAst"
	defb 0feh, 030h, 098h   ; next D,E
	TEXT4 "finAl"
	defb 0feh, 020h, 0a8h   ; next D,E
	TEXT4 "Count down"
	defb 0ffh               ; end
str_end_boot:                     ; 0xACC3  end_boot
	defb 048h, 048h         ; D,E
	TEXT4 "CongrAtulAtions"
	defb 0feh, 040h, 058h   ; next D,E
	TEXT4 "to viCk x~| ?"
	defb 0feh, 048h, 068h   ; next D,E
	TEXT4 "you heroiCAlly"
	defb 0feh, 040h, 078h   ; next D,E
	TEXT4 "unseAled All the"
	defb 0feh, 040h, 088h   ; next D,E
	TEXT4 "loCks."
	defb 0ffh               ; end
str_end_txt2:                     ; 0xAD12  end_txt2
	defb 028h, 080h         ; D,E
	TEXT4 "All you hAve to do now"
	defb 0feh, 028h, 090h   ; next D,E
	TEXT4 "is turn off the swiCh"
	defb 0feh, 028h, 0a0h   ; next D,E
	TEXT4 "to sAve the world."
	defb 0ffh               ; end
str_end_key:                      ; 0xAD58  end_txt3
	defb 048h, 0a0h         ; D,E
	TEXT4 "push spACe key"
	defb 0ffh               ; end
str_end_danger:                   ; 0xAD69
	defb 060h, 0a0h         ; D,E
	TEXT4 "dAnger ???"
	defb 0ffh               ; end
ad76_tbl:                         ; 0xAD76  end_print_i / EDCF → credit page
	defw str_staff, str_program, str_sound, str_graphic, str_title
	defw str_gamedes, str_thanks, str_presented, str_the_end
str_the_end:                      ; 0xAD88  credit[8]
	defb 060h, 048h         ; D,E
	TEXT4 "the end"
	defb 0ffh               ; end
str_staff:                        ; 0xAD92  credit[0]
	defb 068h, 048h         ; D,E
	TEXT4 "stAff"
	defb 0ffh               ; end
str_program:                      ; 0xAD9A  credit[1]
	defb 040h, 030h         ; D,E
	TEXT4 "progrAm"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "i.AkAdA"
	defb 0feh, 070h, 060h   ; next D,E
	TEXT4 "k.nAgAe"
	defb 0feh, 070h, 070h   ; next D,E
	TEXT4 "t.okA"
	defb 0feh, 070h, 080h   ; next D,E
	TEXT4 "t.otsukA"
	defb 0ffh               ; end
str_graphic:                      ; 0xADCB  credit[3]
	defb 040h, 030h         ; D,E
	TEXT4 "grAphiC"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "h.mAkitAni"
	defb 0feh, 070h, 060h   ; next D,E
	TEXT4 "m.tABAtA"
	defb 0feh, 070h, 070h   ; next D,E
	TEXT4 "s.ueno"
	defb 0feh, 070h, 080h   ; next D,E
	TEXT4 "s.iwAmoto"
	defb 0ffh               ; end
str_sound:                        ; 0xAE02  credit[2]
	defb 040h, 030h         ; D,E
	TEXT4 "sound"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "k.uehArA"
	defb 0feh, 070h, 060h   ; next D,E
	TEXT4 "m.ikAriko"
	defb 0feh, 070h, 070h   ; next D,E
	TEXT4 "y.mAnno"
	defb 0feh, 070h, 080h   ; next D,E
	TEXT4 "t.furukAwA"
	defb 0feh, 070h, 090h   ; next D,E
	TEXT4 "k.yAmAshitA"
	defb 0ffh               ; end
str_title:                        ; 0xAE46  credit[4]
	defb 040h, 030h         ; D,E
	TEXT4 "title design"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "n.sAto"
	defb 0ffh               ; end
str_gamedes:                      ; 0xAE5E  credit[5]
	defb 040h, 030h         ; D,E
	TEXT4 "gAme design"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "s.iwAmoto"
	defb 0ffh               ; end
str_thanks:                       ; 0xAE78  credit[6]
	defb 040h, 030h         ; D,E
	TEXT4 "speCiAl thAnks"
	defb 0feh, 070h, 050h   ; next D,E
	TEXT4 "hAl"
	defb 0feh, 070h, 060h   ; next D,E
	TEXT4 "iku"
	defb 0feh, 070h, 070h   ; next D,E
	TEXT4 "sAlt"
	defb 0feh, 070h, 080h   ; next D,E
	TEXT4 "terA"
	defb 0feh, 070h, 090h   ; next D,E
	TEXT4 "room  1008"
	defb 0feh, 070h, 0a0h   ; next D,E
	TEXT4 "room  1013"
	defb 0feh, 070h, 0b0h   ; next D,E
	TEXT4 "rC727"
	defb 0ffh               ; end
str_presented:                    ; 0xAEC5  credit[7]
	defb 050h, 040h         ; D,E
	TEXT4 "presented By"
	defb 0feh, 068h, 050h   ; next D,E
	TEXT4 "konAmi"
	defb 0ffh               ; end
str_end_txt5:                     ; 0xAEDD  end walk text
	defb 030h, 030h         ; D,E
	TEXT4 "thAnks to your CourAge"
	defb 0feh, 010h, 050h   ; next D,E
	TEXT4 "the world hAs Been sAved ??"
	defb 0feh, 058h, 070h   ; next D,E
	TEXT4 "well done."
	defb 0ffh               ; end
str_end_congrats:                 ; 0xAF21  end_page header
	defb 038h, 010h         ; D,E
	TEXT4 "CongrAtulAtions ???"
	defb 0ffh               ; end
end_stamp_tbl:                    ; 0xAF37  end_stamp: 9 × X,Y,pat (EDCE)
	defb 058h, 0a0h, 0e1h
	defb 060h, 0a0h, 0e8h
	defb 068h, 0a0h, 0e3h
	defb 070h, 0a0h, 0e5h
	defb 078h, 0a0h, 0f6h
	defb 080h, 0a0h, 0ddh
	defb 088h, 0a0h, 0f8h
	defb 090h, 0a0h, 0f8h
	defb 098h, 0a0h, 0f8h
disk_err_tbl:                     ; 0xAF52  C=0..6 → print_stream; then str_disk_err
	defw str_disk_io, str_nofile, str_disk_full, str_not_ready
	defw str_wr_prot, str_too_manny, str_datatype
str_disk_err:                     ; 0xAF60  header under the specific error
	defb 050h, 08ch         ; D,E
	TEXT "disk error"
	defb 0ffh               ; end
str_disk_io:                      ; 0xAF6D
	defb 048h, 09ch         ; D,E
	TEXT "disk io error"
	defb 0ffh               ; end
str_nofile:                       ; 0xAF7D  io_nofile
	defb 048h, 09ch         ; D,E
	TEXT "file not found"
	defb 0ffh               ; end
str_disk_full:                    ; 0xAF8E
	defb 058h, 09ch         ; D,E
	TEXT "disk full"
	defb 0ffh               ; end
str_not_ready:                    ; 0xAF9A
	defb 040h, 09ch         ; D,E
	TEXT "disk not ready"
	defb 0ffh               ; end
str_wr_prot:                      ; 0xAFAB
	defb 048h, 09ch         ; D,E
	TEXT "write protect"
	defb 0ffh               ; end
str_too_manny:                    ; 0xAFBB  ROM spelling
	defb 048h, 09ch         ; D,E
	TEXT "too manny files"
	defb 0ffh               ; end
str_datatype:                     ; 0xAFCD
	defb 048h, 09ch         ; D,E
	TEXT "datatypeerror"
	defb 0ffh               ; end
	INCLUDE "banks/data/tiles0C.asm"
str_start_sel:                    ; 0xB185  file_menu (E24B 0..2)
	defb 040h, 040h         ; D,E
	TEXT "start  select"
	defb 0feh, 080h, 050h   ; next D,E
	TEXT "normal"
	defb 0feh, 080h, 060h   ; next D,E
	TEXT "password"
	defb 0feh, 080h, 070h   ; next D,E
	TEXT "stage load"
	defb 0ffh               ; end
	INCLUDE "banks/data/file_pat.asm"
	INCLUDE "banks/data/ef10_spr.asm"
str_clear_card:                   ; 0xB256  clear_card (stage-clear)
	defb 068h, 020h         ; D,E
	TEXT "nice ;"
	defb 0feh, 038h, 030h   ; next D,E
	TEXT "lets go next stage"
	defb 0feh, 048h, 050h   ; next D,E
	TEXT "special bonus"
	defb 0ffh               ; end
str_secret_cmd:                   ; 0xB284  title GAME + SNSMAT bit 5
	defb 048h, 040h         ; D,E
	TEXT "secret command"
	defb 0feh, 060h, 058h   ; next D,E
	TEXT "f}}t}}}l"               ; `{` underline
	defb 0feh, 060h, 068h   ; next D,E
	TEXT "}}y}}}}}"
	defb 0ffh               ; end
	ds 341, 0ffh                  ; 0xB2AB–0xB400 pad
; Copy ef10_tbl row for this level into EF10.
load_ef10:                        ; 0xB400  ef10_tbl[level] -> EF10 (type, 0, screen/X/Y)
	ld hl,ef10_tbl
ef10_scan:
	ld a,(hl)
	and a
	ret z
	ld a,(0e242h)           ; level
	cp (hl)
	jr z,ef10_found
	ld a,005h
	call ADD_HL_A
	jr ef10_scan
ef10_found:
	inc hl
	ld de,0ef10h            ; pyramid FX
	ldi
	xor a
	ld (de),a
	inc de
	ld bc,00003h
	ldir
	ret
; Per-frame pyramid FX; DISPATCH_A on EF11.
tick_ef10:                        ; 0xB422  per-pyramid FX (EF10); disp_b42f on EF11
	ld hl,0ef10h            ; pyramid FX
	ld a,(hl)
	or a
	ret z
	inc l
	ld a,(hl)
	inc l
	exx
	call DISPATCH_A

; disp_b42f: DISPATCH_A on state (0xEF11), 4 states (0-based).
disp_b42f_start:
	defw ef10_land                ; 0 jump onto spot (Vic state 1)
	defw ef10_hold                ; 1 wait EF15
	defw ef10_clear               ; 2 Vic near → restore tiles
	defw ef10_enter               ; 3 Vic near + down → mode_end
disp_b42f_end:
ef10_land:                        ; 0xB437  jump onto spot (Vic state 1)
	exx
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	ld a,(0e280h)           ; Vic state
	dec a                         ; must be vic_jump
	ret nz
	call ef10_jump_hit
	ret nc
	ld hl,0ef11h            ; fx state
	inc (hl)
	inc l
	inc l
	inc l
	inc l
	ld (hl),040h                  ; EF15 hold timer
	call stones_undraw
	call tools_scan
	call ef10_stamp
	call draw_maptools
	call stones_redraw
	jp sfx_3b
ef10_hold:                        ; 0xB462
	ld hl,0ef15h
	dec (hl)
	ret nz
	ld hl,0ef11h            ; fx state
	inc (hl)
	ret
ef10_clear:                       ; 0xB46C
	exx
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	call ef10_stand_hit
	ret nc
	call sfx_2e                   ; clear
	ld hl,0ef11h            ; fx state
	inc (hl)
	call stones_undraw
	call tools_scan
	call ef10_unstamp
	call ef10_restore
	call draw_maptools
	jp stones_redraw
ef10_enter:                       ; 0xB48F  E208 bit 1 (down) → E200=12
	exx
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	call ef10_stand_hit
	ret nc
	ld a,(0e208h)           ; keys held
	rra
	rra
	ret nc
	xor a
	ld hl,0000ch            ; RDSLT
	ld (0e200h),hl          ; game mode
	ld (0ef11h),a           ; fx state
	jp sfx_30
; Vic AABB vs the 16x16 spot (HL at EF12 = screen). Y uses stored-16.
ef10_jump_hit:                    ; 0xB4AC  CY if |Y-(spotY-16)|<4 and |X-spotX|<4
	inc l
	ld a,(hl)                     ; spot Y
	sub 010h
	ld b,a
	ld a,(0e282h)           ; Vic Y
	sub b
	jr nc,ef10_jabsy
	neg
ef10_jabsy:
	cp 004h
	ret nc
	inc l
	ld b,(hl)                     ; spot X
	ld a,(0e284h)           ; Vic X
	sub b
	jr nc,ef10_jabsx
	neg
ef10_jabsx:
	cp 004h
	ret
; Standing on the restored hole (no Y-16); X window is wider.
ef10_stand_hit:                   ; 0xB4C9  CY if |Y-spotY|<4 and |X-spotX|<8
	inc l
	ld b,(hl)
	ld a,(0e282h)           ; Vic Y
	sub b
	jr nc,ef10_sabsy
	neg
ef10_sabsy:
	cp 004h
	ret nc
	inc l
	ld b,(hl)
	ld a,(0e284h)           ; Vic X
	sub b
	jr nc,ef10_sabsx
	neg
ef10_sabsx:
	cp 008h
	ret
; Backup dest 16x16 to 00B0, then stamp tiles CA-CD.
ef10_stamp:                       ; 0xB4E3  backup 16x16 to 00B0, stamp 2x2 CA-CD
	ld hl,0ef13h
	call ef10_backup
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,ef10_tiles
	ld bc,00202h
	jp draw_tilemap

; BLOCK 'pat_b4f8' (start 0xb4f8 end 0xb4fc)
ef10_tiles:                       ; 0xB4F8  2x2 tile ids for the pyramid FX
	defb 0cah, 0cbh, 0cch, 0cdh
; HMMM the 16x16 at (HL) into 00B0.
ef10_backup:                      ; 0xB4FC  HMMM dest EF13/14 -> 00B0, 16x16
	ld a,(hl)
	inc l
	ld h,(hl)
	ld l,a
	ld de,000b0h
	ld bc,01010h
	ld a,004h
	jp vdp_hmmm
; HMMM 00B0 back onto the dest (undo stamp).
ef10_unstamp:                     ; 0xB50B  HMMM 00B0 -> dest (undo stamp)
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,000b0h
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
; Stamp or restore the 16x16 if it is on this screen.
draw_ef10:                        ; 0xB51C  if EF10 live on this screen, stamp (state 3 = restore)
	ld hl,0ef10h            ; pyramid FX
	ld a,(hl)
	or a
	ret z
	inc l
	inc l
	ld a,(0e243h)           ; screen
	cp (hl)
	ret nz
	dec l
	ld a,(hl)
	or a
	ret z
	cp 003h
	jp z,ef10_restore
	jr ef10_stamp
; mode_end E201=2: sound select or sliding puzzle.
end_menu:                         ; 0xB534  mode_end E201=2; type 1 sound select, else puzzle
	call end_pick
	jp spr_vram
; EF10 type 1 → snd_sel, else puzzle_ui.
end_pick:                         ; 0xB53A
	ld ix,0ef10h            ; pyramid FX
	ld a,(ix+000h)
	dec a
	jp z,snd_sel
	jp puzzle_ui

; BLOCK 'data_b548' (start 0xb548 end 0xb6b0)
ef10_tbl:                         ; 0xB548  level, type, screen, X, Y; 0 end
data_b548_start:
	defb 007h, 001h, 002h, 008h, 008h  ; 7  type 1 sound
	defb 014h, 002h, 002h, 088h, 030h  ; 20 type 2 puzzle
	defb 018h, 001h, 004h, 028h, 0e0h  ; 24
	defb 01dh, 002h, 001h, 0a8h, 0e0h  ; 29
	defb 020h, 001h, 003h, 080h, 030h  ; 32
	defb 023h, 002h, 003h, 018h, 0d8h  ; 35
	defb 028h, 001h, 001h, 080h, 070h  ; 40
	defb 02bh, 002h, 001h, 0a0h, 098h  ; 43
	defb 032h, 001h, 002h, 0a8h, 018h  ; 50
	defb 034h, 002h, 001h, 0a8h, 0e0h  ; 52
	defb 035h, 001h, 003h, 038h, 0b0h  ; 53
	defb 037h, 002h, 002h, 078h, 0c0h  ; 55
	defb 000h
str_snd_sel:                      ; 0xB585
	defb 050h, 018h         ; D,E
	TEXT "sound select"
	defb 0feh, 040h, 0a8h   ; next D,E
	TEXT "select ||| space"
	defb 0feh, 058h, 0b8h   ; next D,E
	TEXT "end ||| return"
	defb 0ffh               ; end
str_puz_game:                     ; 0xB5B8
	defb 050h, 018h         ; D,E
	TEXT "puzzle  game"
	defb 0ffh               ; end
str_all_right:                    ; 0xB5C7
	defb 060h, 090h         ; D,E
	TEXT "all right"
	defb 0feh, 060h, 0a0h   ; next D,E
	TEXT "rest  3 up"
	defb 0ffh               ; end
puz_ptr:                          ; 0xB5E0  E203&3 -> 5x5 board
	defw puz_b0, puz_b1, puz_b2, puz_b3
puz_b0:                           ; 0xB5E8
	defb 00bh, 011h, 017h, 004h, 012h
	defb 00ah, 001h, 00ch, 00dh, 013h
	defb 007h, 016h, 009h, 018h, 00eh
	defb 015h, 008h, 014h, 003h, 000h
	defb 006h, 002h, 010h, 005h, 00fh
puz_b1:                           ; 0xB601
	defb 004h, 012h, 00fh, 00bh, 003h
	defb 008h, 018h, 017h, 007h, 013h
	defb 010h, 005h, 00ch, 000h, 00eh
	defb 015h, 016h, 011h, 006h, 00ah
	defb 001h, 009h, 00dh, 014h, 002h
puz_b2:                           ; 0xB61A
	defb 007h, 014h, 00bh, 010h, 018h
	defb 012h, 001h, 006h, 00ch, 005h
	defb 008h, 015h, 00ah, 011h, 00dh
	defb 00eh, 016h, 002h, 009h, 000h
	defb 013h, 00fh, 017h, 003h, 004h
puz_b3:                           ; 0xB633
	defb 00fh, 004h, 008h, 002h, 00bh
	defb 000h, 00dh, 016h, 00eh, 013h
	defb 006h, 00ch, 007h, 012h, 015h
	defb 014h, 017h, 011h, 018h, 00ah
	defb 005h, 010h, 003h, 009h, 001h
puz_pat:                          ; 0xB64C  4 tile ids per cell (0 = empty)
	defb 035h, 035h, 035h, 035h
	defb 001h, 002h, 003h, 004h
	defb 005h, 006h, 007h, 008h
	defb 009h, 00ah, 00bh, 00ch
	defb 00dh, 00eh, 00fh, 010h
	defb 011h, 012h, 013h, 00ch
	defb 014h, 015h, 016h, 00ch
	defb 017h, 018h, 019h, 01ah
	defb 01bh, 00ah, 016h, 00ch
	defb 01ch, 01dh, 01eh, 01fh
	defb 020h, 024h, 021h, 025h
	defb 020h, 026h, 021h, 027h
	defb 020h, 028h, 021h, 029h
	defb 020h, 02ah, 021h, 02bh
	defb 020h, 02ch, 021h, 02dh
	defb 020h, 02eh, 021h, 02fh
	defb 020h, 030h, 021h, 025h
	defb 020h, 031h, 021h, 032h
	defb 020h, 033h, 021h, 025h
	defb 020h, 024h, 021h, 034h
	defb 022h, 024h, 023h, 025h
	defb 022h, 026h, 023h, 027h
	defb 022h, 028h, 023h, 029h
	defb 022h, 02ah, 023h, 02bh
	defb 022h, 02ch, 023h, 02dh
; 5x5 sliding puzzle; ix+1 state, ESC bit 6 closes.
puzzle_ui:                        ; 0xB6B0  EF10 type 2 → disp_b6be
data_b548_end:
	ld a,(0e20ch)           ; vic_die flag
	rla
	rla                           ; E20C bit 6 = ESC → close
	jp c,puz_close
	ld a,(ix+001h)
	call DISPATCH_A

; disp_b6be: password / 5x5 sliding-puzzle UI. DISPATCH_A on (ix+1), 6 states.
disp_b6be_start:
	defw puz_init                 ; 0 draw "esc key", wait
	defw puz_wait                 ; 1 wait space, blank prompt
	defw puz_load                 ; 2 load 5x5 from (0xE203)
	defw puz_play                 ; 3 cursor + slide (disp_b7a5)
	defw puz_check                ; 4 solved? "all right" / bump (0xE240)
	defw puz_exit                 ; 5 wait space, exit
disp_b6be_end:
; Load UI tiles, fill EF20, print esc prompt.
puz_init:                         ; 0xB6CA
	call scr_reset
	call sat_wipe
	call copy_afdd
	call copy_pointer
	ld hl,0ef38h
	ld (hl),000h
	dec hl
	ld b,018h
puz_fill:
	ld a,b
	ld (hl),b
	dec hl
	djnz puz_fill
	call puz_draw
	ld hl,str_esc_key
	call print_stream
	inc (ix+001h)
	jp sfx_0a
; Fire blanks the "push space key" line.
puz_wait:                         ; 0xB6F2  fire → blank "push space key"
	ld a,(0e207h)           ; key edges
	and 010h
	ret z
	inc (ix+001h)
	ld hl,str_push_key
	jp print_stream_blank
; Copy puz_ptr[E203&3] into EF20.
puz_load:                         ; 0xB701  board E203&3 → EF20; cursor 0,0
	ld hl,puz_ptr
	ld a,(0e203h)           ; puzzle board
	and 003h
	call tbl_word
	ld de,0ef20h            ; puzzle board
	ld bc,00019h
	ldir
	inc (ix+001h)
	xor a
	ld (ix+002h),a                ; row
	ld (ix+003h),a                ; col
; Draw the 5x5 at EF20, 16px cells from 5830.
puz_draw:                         ; 0xB71E  5x5 at EF20, 16px cells from 5830
	ld hl,0ef20h            ; puzzle board
	ld bc,00505h
	ld de,05830h
puz_row:
	push bc
	ld b,c
	push de
puz_col:
	push bc
	push de
	push hl
	ld a,(hl)
	call puz_stamp
	pop hl
	inc hl
	pop de
	ld a,d
	add a,010h
	ld d,a
	pop bc
	djnz puz_col
	pop de
	ld a,e
	add a,010h
	ld e,a
	pop bc
	djnz puz_row
	ld hl,str_puz_game
	jp print_stream
; Stick moves cursor; fire tries a slide.
puz_play:                         ; 0xB749  stick → cursor; fire → slide
	call puz_pointer
	ld a,(0e207h)           ; key edges
	rra
	jr c,puz_up
	rra
	jr c,puz_down
	rra
	jr c,puz_left
	rra
	jr c,puz_right
	rra
	jr c,puz_fire
	ret
puz_right:
	ld a,(ix+003h)
	cp 004h
	ret nc
	inc (ix+003h)
puz_tick:
	jp sfx_32
puz_up:
	ld a,(ix+002h)
	and a
	ret z
	dec (ix+002h)
	jr puz_tick
puz_down:
	ld a,(ix+002h)
	cp 004h
	ret nc
	inc (ix+002h)
	jr puz_tick
puz_left:
	ld a,(ix+003h)
	and a
	ret z
	dec (ix+003h)
	jr puz_tick
puz_fire:
	call puz_cell
	ret z
	push hl
	push bc
	call puz_gap
	ld a,c
	pop bc
	pop de
	ld c,a
	and a
	ret z
	inc (ix+001h)
	xor a
	call puz_redraw
	ld a,c
	dec a
	call DISPATCH_A

; disp_b7a5: slide current tile into the adjacent empty cell (5x5, stride 5).
; DISPATCH_A on (C-1) from puz_gap: C=1..4 = empty up / down / left / right.
; [3] overlaps puz_slide_right (first instruction after the table).
disp_b7a5_start:
	defw puz_slide_up             ; empty at row-1: -5, dec (ix+2)
	defw puz_slide_down           ; empty at row+1: +5, inc (ix+2)
	defw puz_slide_left           ; empty at col-1: -1, dec (ix+3)
	defw puz_slide_right          ; empty at col+1: +1, inc (ix+3)
disp_b7a5_end:
puz_slide_right:                  ; 0xB7AD  [3] of the table
	ex de,hl
	ld (hl),000h
	inc hl
	ld (hl),b
	inc (ix+003h)
	ld a,b
	jr puz_redraw
puz_slide_up:                     ; 0xB7B8
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
; Stamp tile A at the cursor pixel position.
puz_redraw:                       ; 0xB7C5  stamp tile A at cursor pixel pos
	push de
	push bc
	push af
	call puz_xy
	pop af
	call puz_stamp
	pop bc
	pop de
	ret
puz_slide_down:                   ; 0xB7D2
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
	jr puz_redraw
puz_slide_left:                   ; 0xB7E1
	ex de,hl
	ld (hl),000h
	dec hl
	ld (hl),b
	dec (ix+003h)
	ld a,b
	jr puz_redraw
; 2x2 from puz_pat[A] via tilemap_hmmm.
puz_stamp:                        ; 0xB7EC  2x2 from puz_pat[A] via tile_hmmm
	add a,a
	add a,a
	ld hl,puz_pat
	call ADD_HL_A
	ld bc,00202h
	jp tilemap_hmmm
; A,B = board[row,col]; Z if that cell is empty.
puz_cell:                         ; 0xB7FA  A,B = EF20[row,col]; Z if empty
	ld d,(ix+002h)
	ld e,(ix+003h)
; A,B = board[D,E]; Z if empty.
puz_at:                           ; 0xB800  A,B = EF20[D,E]; Z if empty
	ld a,d
	add a,a
	add a,a
	add a,d                       ; D*5
	add a,e
	ld hl,0ef20h            ; puzzle board
	call ADD_HL_A
	ld a,(hl)
	ld b,a
	and a
	ret
; DE = pixel position of cursor row/col.
puz_xy:                           ; 0xB80F  DE = pixel pos of cursor (row,col)
	ld a,(ix+002h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,030h                    ; Y = row*16+0x30
	ld e,a
	ld a,(ix+003h)
	add a,a
	add a,a
	add a,a
	add a,a
	add a,058h                    ; X = col*16+0x58
	ld d,a
	ret
; C = 1..4 empty neighbor (up/down/left/right), or 0.
puz_gap:                          ; 0xB824  C=1..4 empty neighbor, or 0
	ld d,(ix+002h)
	ld e,(ix+003h)
	ld c,001h
	ld a,d
	and a
	jr z,puz_gap_down
	push de
	dec d
	call puz_at
	pop de
	ret z
puz_gap_down:
	inc c
	ld a,d
	cp 004h
	jr nc,puz_gap_left
	push de
	inc d
	call puz_at
	pop de
	ret z
puz_gap_left:
	inc c
	ld a,e
	and a
	jr z,puz_gap_right
	push de
	dec e
	call puz_at
	pop de
	ret z
puz_gap_right:
	inc c
	ld a,e
	cp 004h
	jr nc,puz_gap_none
	inc e
	call puz_at
	ret z
puz_gap_none:
	ld c,000h
	ret
; Win if EF20 is 1..24 in order.
puz_check:                        ; 0xB85E  EF20 == 1..24 in order
	ld de,0ef20h            ; puzzle board
	ld hl,0ef21h
	ld a,(de)
	cp 001h
	jr nz,puz_wrong
puz_seq:
	ld a,(de)
	inc a
	cp (hl)
	jr nz,puz_wrong
	cp 018h
	jr z,puz_win
	inc de
	inc hl
	jr puz_seq
puz_wrong:
	dec (ix+001h)
	ret
puz_win:                          ; 0xB87A  +3 lives BCD at E240, cap 99
	call sat_wipe
	inc (ix+001h)
	ld a,(0e240h)           ; lives
	add a,003h
	cp 099h
	jr nc,puz_lives_cap
	daa
	jr puz_lives
puz_lives_cap:
	ld a,099h
puz_lives:
	ld (0e240h),a           ; lives
	ld hl,str_esc_key
	call print_stream_blank
	ld hl,str_all_right
	jp print_stream
; Fire closes the puzzle.
puz_exit:                         ; 0xB89D  fire → close
	ld a,(0e207h)           ; key edges
	and 010h
	ret z
puz_close:                        ; 0xB8A3  sprites off, sfx_01, clear EF10
	ld bc,00007h
	ld (ix+000h),b
	call WRTVDP
	jp sfx_01
str_esc_key:                      ; 0xB8AF  "end  esc key" / "push space key"
	defb 050h, 0a0h         ; D,E
	TEXT "end  esc key"
	defb 0feh
str_push_key:                     ; 0xB8BE  D,E of "push space key" (blank target)
	defb 048h, 090h         ; next D,E
	TEXT "push space key"
	defb 0ffh               ; end
; Four pointer sprites at the cursor cell.
puz_pointer:                      ; 0xB8CF  4-sprite cursor at row/col
	ld hl,0e800h            ; SAT
	ld de,puz_cc
	ld bc,00400h
	exx
	ld hl,0d200h            ; boot spare
	exx
puz_spr:
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
	jr nc,puz_spr_y
	ld a,c
	add a,010h
	ld c,a
puz_spr_y:
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
puz_cc_fill:
	ld (hl),a
	inc hl
	djnz puz_cc_fill
	exx
	djnz puz_spr
	ret
puz_cc:                           ; 0xB913  SAT colour 0x0D / 0x4E × 2
	defb 00dh, 04eh, 00dh, 04eh
; Sound-select UI; ix+1 state, ix+2 = 0..18.
snd_sel:                          ; 0xB917  EF10 type 1 "sound select"
	ld a,(ix+001h)
	cp 001h
	jr z,snd_wait
	jr nc,snd_play
; Load tiles, pointer, board, print "sound select".
snd_init:                         ; 0xB921
	call scr_reset
	call snd_blit
	call copy_pointer
	call snd_board
	call sat_wipe
	inc (ix+001h)
	ld hl,str_snd_sel
	jp print_stream
; Move cursor / play / ESC.
snd_wait:                         ; 0xB938
	call snd_pointer
	ld a,(0e207h)           ; key edges
	rra
	rra
	rra
	jr c,snd_left
	rra
	jr c,snd_right
	rra
	jr c,snd_fire
	ld a,(0e20ch)           ; vic_die flag
	rla
	ret nc
	ld bc,00007h
	ld (ix+000h),b
	call WRTVDP
	jp sfx_01
snd_left:                         ; 0xB95A  wrap 0 → 18
	call sfx_32                   ; cursor
	dec (ix+002h)
	ld a,(ix+002h)
	rla
	ret nc
	ld (ix+002h),012h
	ret
snd_right:                        ; 0xB96A  wrap 19 → 0
	call sfx_32                   ; cursor
	inc (ix+002h)
	ld a,(ix+002h)
	cp 013h
	ret c
	ld (ix+002h),000h
	ret
snd_fire:
	inc (ix+001h)
	jp sfx_01
snd_play:                         ; 0xB981  ix+2 → disp_b98a sfx thunks
	dec (ix+001h)
	ld a,(ix+002h)
	call DISPATCH_A

; disp_b98a: DISPATCH_A on (ix+2), 19 states; every target is a bank-0
; sfx_* thunk (sfx_03..sfx_28) via paged-in bank 00.
disp_b98a_start:
	defw sfx_03
	defw sfx_05
	defw sfx_06
	defw sfx_07
	defw sfx_08
	defw sfx_09
	defw sfx_0a
	defw sfx_0b
	defw sfx_0c
	defw sfx_0d
	defw sfx_0e
	defw sfx_0f
	defw sfx_10
	defw sfx_11
	defw sfx_12
	defw sfx_16
	defw sfx_27
	defw sfx_28
	defw sfx_1d
disp_b98a_end:
; Pointer SAT for the selected sfx icon.
snd_pointer:                      ; 0xB9B0  cursor SAT for selected sfx
	ld hl,0e800h            ; SAT
	ld de,snd_cc
	ld bc,00400h
	exx
	ld hl,0d200h            ; boot spare
	exx
snd_spr:
	push bc
	ld a,(ix+002h)
	exx
	ld de,pat_b9fa_start
	add a,e
	ld e,a
	jr nc,snd_x
	inc d
snd_x:
	ld a,(de)
	exx
	push af
	rra
	ld c,078h
	jr nc,snd_y
	ld c,060h
snd_y:
	ld a,b
	cp 003h
	jr nc,snd_put
	ld a,c
	add a,010h
	ld c,a
snd_put:
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
snd_cc_fill:
	ld (hl),a
	inc hl
	djnz snd_cc_fill
	exx
	djnz snd_spr
	ret

; BLOCK 'pat_b9fa' (start 0xb9fa end 0xba11)
pat_b9fa_start:                   ; 0xB9FA  X of 19 sfx icons; bit 0 = row
	defb 02ch, 033h, 03ch, 045h, 04ch, 055h, 05ch, 06ch
	defb 073h, 07ch, 085h, 08ch, 09ch, 0a3h, 0ach, 0b5h
	defb 0bch, 0c5h, 0cch
snd_cc:                           ; 0xBA0D  SAT colour 0x0D / 0x4E × 2
	defb 00dh, 04eh, 00dh, 04eh
pat_b9fa_end:

demo_init:                        ; 0xBA11  attract: next pyramid in demo_lvls
	ld hl,001ffh                  ; E209=0xFF so first tick wraps to step 0
	ld (0e209h),hl          ; attract step
	ld hl,0e219h            ; attract slot
	ld a,(hl)
	ld de,demo_lvls
	call ADD_DE_A
	ld a,(de)
	ld (0e242h),a           ; level
	inc (hl)
	ld a,(hl)
	cp 007h
	jr c,demo_init_wrap
	ld (hl),001h
demo_init_wrap:
	xor a
	ld (0e203h),a           ; puzzle board
	inc a
	ld (0e246h),a
	call set_world_far
	jp bgm_stage                  ; 0xBA38  C3 88 43 overlaps demo_lvls[0]
demo_lvls equ $-1                 ; 0xBA3A  [0]=43 overlap; [1..6] pyramids
	defb 002h, 012h, 01ah, 028h, 030h, 035h
demo_wait:                        ; 0xBA41  E200=2: wait vic_hit, or take E248 door
	ld a,(0e248h)           ; exit dir
	and a
	jr nz,demo_door
	call play_frame_far
	ld a,(0e280h)           ; Vic state
	cp 005h                       ; wait vic_hit
	ret nz
demo_end:
	xor a
	ld (0e246h),a
	jp sfx_01
demo_door:
	xor a
	ld (0e24dh),a
	call room_exit
	ld a,(0e24dh)
	and a
	ret nz
	jp room_draw_far
demo_tick:                        ; 0xBA66  countdown E20A; next word -> keys_apply
	ld hl,0e20ah            ; attract duration
	dec (hl)
	jr nz,demo_hold
	dec hl
	inc (hl)
	inc hl
	call demo_word
	cp 0ffh
	jr z,demo_end
	ld hl,0e20ah            ; attract duration
	ld (hl),c
demo_hold:
	call demo_word
	jp keys_apply
; A = key mask, C = duration from ba_wN[E209].
demo_word:                        ; 0xBA80  A = E208 mask, C = duration (E209 index)
	dec hl
	ld c,(hl)
	ld a,(0e241h)           ; world
	ld hl,ba92_tbl_start
	call tbl_word
	ld a,c
	add a,a
	call ADD_HL_A
	ld c,(hl)
	inc hl

; BLOCK 'ba92_tbl' (start 0xba92 end 0xbaa0)
; ba92_tbl[world] -> per-world attract script (demo_word, world 1..6).
; [0] 0xC97E is the world-0 sentinel; its bytes 7E C9 double as the preceding
; routine's tail (ld a,(hl) / ret) so demo_word returns A:C = ba_lists word.
ba92_tbl_start:
	defw 0c97eh                   ; world 0 (unused) / ld a,(hl)+ret overlap
	defw ba_w1_start              ; world 1
	defw ba_w2_start              ; world 2
	defw ba_w3_start              ; world 3
	defw ba_w4_start              ; world 4
	defw ba_w5_start              ; world 5
	defw ba_w6_start              ; world 6
ba92_tbl_end:

; Attract joypad scripts (0xBAA0-0xBC6E): 6 per-world word tables
; (ba_w1..ba_w6). demo_tick stores lo in E20A (duration) and hi in E208
; (held keys; keys_apply rising-edges E207). Bit 4 = fire, bits 2-3 =
; walk. Terminator 0xFF00 (A=0xFF). World 1 is pyramid 2: L/R + one jump.
ba_w1_start:
	defw 0002eh
	defw 0080fh
	defw 00010h
	defw 0040dh
	defw 00011h
	defw 00837h
	defw 0001bh
	defw 00819h
	defw 00011h
	defw 00810h
	defw 0000dh
	defw 00843h
	defw 0000ch
	defw 00458h
	defw 00013h
	defw 00803h
	defw 00008h
	defw 01009h
	defw 00012h
	defw 00839h
	defw 00015h
	defw 0041fh
	defw 00047h
	defw 00410h
	defw 0000eh
	defw 00809h
	defw 0ff00h
ba_w1_end:

ba_w2_start:
	defw 00029h
	defw 00490h
	defw 0001bh
	defw 008adh
	defw 0001ah
	defw 00803h
	defw 0000bh
	defw 00118h
	defw 0000ah
	defw 00819h
	defw 00008h
	defw 00123h
	defw 00006h
	defw 00404h
	defw 0000dh
	defw 0100dh
	defw 00033h
	defw 0080eh
	defw 0000ah
	defw 0041eh
	defw 00008h
	defw 00117h
	defw 00004h
	defw 0040dh
	defw 0000dh
	defw 0101eh
	defw 0002fh
	defw 0046ch
	defw 00042h
	defw 00430h
	defw 0ff00h
ba_w2_end:

ba_w3_start:
	defw 00036h
	defw 0042dh
	defw 01408h
	defw 0041ah
	defw 00010h
	defw 0082dh
	defw 00902h
	defw 00133h
	defw 00901h
	defw 00872h
	defw 00014h
	defw 00232h
	defw 00011h
	defw 0081ah
	defw 0180ah
	defw 0081eh
	defw 00006h
	defw 00432h
	defw 00007h
	defw 00808h
	defw 0000dh
	defw 01008h
	defw 00037h
	defw 00851h
	defw 00902h
	defw 00124h
	defw 00008h
	defw 00812h
	defw 01802h
	defw 00816h
	defw 00901h
	defw 00128h
	defw 00501h
	defw 004a0h
	defw 0ff00h
ba_w3_end:

ba_w4_start:
	defw 00041h
	defw 00440h
	defw 00001h
	defw 008a4h
	defw 00a02h
	defw 00215h
	defw 00006h
	defw 0041eh
	defw 00601h
	defw 0020bh
	defw 00601h
	defw 0040fh
	defw 00601h
	defw 0020ch
	defw 00601h
	defw 0040fh
	defw 00601h
	defw 0020ch
	defw 00602h
	defw 0040eh
	defw 00601h
	defw 0020bh
	defw 00602h
	defw 00415h
	defw 00601h
	defw 0020eh
	defw 00601h
	defw 00416h
	defw 0000fh
	defw 00413h
	defw 00007h
	defw 00401h
	defw 00003h
	defw 00402h
	defw 0001fh
	defw 0041eh
	defw 0001dh
	defw 00405h
	defw 01409h
	defw 00401h
	defw 0000eh
	defw 01406h
	defw 0045eh
	defw 00013h
	defw 00837h
	defw 01802h
	defw 01012h
	defw 0ff00h
ba_w4_end:

ba_w5_start:
	defw 00036h
	defw 00451h
	defw 00033h
	defw 01006h
	defw 0002eh
	defw 00484h
	defw 0000dh
	defw 01007h
	defw 00012h
	defw 0080eh
	defw 00009h
	defw 00119h
	defw 0080ch
	defw 00118h
	defw 00005h
	defw 00408h
	defw 00501h
	defw 00114h
	defw 00002h
	defw 00808h
	defw 00001h
	defw 00115h
	defw 00432h
	defw 0000ah
	defw 00419h
	defw 00007h
	defw 0100dh
	defw 00022h
	defw 00412h
	defw 0000eh
	defw 00412h
	defw 01404h
	defw 0040dh
	defw 01404h
	defw 00407h
	defw 0000fh
	defw 0080fh
	defw 01807h
	defw 0080dh
	defw 0001dh
	defw 00815h
	defw 00043h
	defw 0040fh
	defw 00001h
	defw 00825h
	defw 0ff00h
ba_w5_end:

ba_w6_start:
	defw 00040h
	defw 00832h
	defw 00004h
	defw 00413h
	defw 0000ah
	defw 0024dh
	defw 00003h
	defw 00409h
	defw 0000bh
	defw 00426h
	defw 0140bh
	defw 0041bh
	defw 01406h
	defw 00410h
	defw 01405h
	defw 0040dh
	defw 0001dh
	defw 00408h
	defw 01404h
	defw 00428h
	defw 01407h
	defw 00413h
	defw 00028h
	defw 00445h
	defw 0000eh
	defw 00404h
	defw 0000eh
	defw 0041dh
	defw 0000bh
	defw 01014h
	defw 0001ch
	defw 00429h
	defw 01405h
	defw 0040bh
	defw 01405h
	defw 00419h
	defw 01403h
	defw 00422h
	defw 01406h
	defw 00405h
	defw 00033h
	defw 0180bh
	defw 00808h
	defw 0ff00h
ba_w6_end:
; Clear E910 sparks; E900=1.
spark_init:                       ; 0xBC6E  clear E910 sparks; E900=1
	xor a
	ld hl,0e910h
	ld de,0e911h
	ld (hl),a
	ld bc,001ffh
	ldir
	ld (0e901h),a
	ld (0e902h),a
	inc a
	ld (0e900h),a           ; unpacked map
	ret
; Every other tick, occupy an empty E910 slot.
spark_spawn:                      ; 0xBC86  skip if E902; fill empty E910 slot
	ld a,(0e902h)
	or a
	ret nz
	ld hl,0e900h            ; unpacked map
	dec (hl)
	ret nz
	ld (hl),002h
	ld ix,0e910h
	ld b,020h
spark_scan:
	ld a,(ix+000h)
	or a
	jr z,spark_fill
	ld de,00010h
	add ix,de
	djnz spark_scan
	ret
spark_fill:                       ; 0xBCA6  slot: Y=0x70 X=0x80, vel from E901
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
	call spark_vel
	ld (ix+005h),l
	ld (ix+006h),h
	ld (ix+007h),e
	ld (ix+008h),d
	ret
; Spawn, wipe SAT, integrate, stamp.
spark_tick:                       ; 0xBCD2  spawn, wipe SAT, move, stamp
	call spark_spawn
	call spark_wipe
	call spark_move
	jr spark_sat
; Step every live spark.
spark_move:                       ; 0xBCDD
	ld ix,0e910h
	ld b,020h
spark_each:
	ld a,(ix+000h)
	or a
	push bc
	call nz,spark_step
	pop bc
	ld de,00010h
	add ix,de
	djnz spark_each
	ret
; Add 8.8 velocity; die if Y or X leaves 0xF0..0x0F.
spark_step:                       ; 0xBCF4  add 8.8 vel; die if Y or X hi-byte out of 0xF0..0x0F
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
	jr c,spark_die
	ld a,(ix+004h)
	add a,010h
	cp 020h
	ret nc
spark_die:
	ld (ix+000h),000h
	ret
; SAT Y=E0; D200 colour 5.
spark_wipe:                       ; 0xBD30  SAT Y=E0, D200 colour 5
	ld hl,0e800h            ; SAT
	ld de,0e801h
	ld (hl),0e0h
	ld bc,0007fh
	ldir
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld (hl),005h
	ld bc,00400h
	ldir
	ret
; Live sparks → software SAT.
spark_sat:                        ; 0xBD4B  live sparks → SAT
	ld ix,0e910h
	ld hl,0e800h            ; SAT
	ld b,020h
spark_loop:
	ld a,(ix+000h)
	or a
	push bc
	call nz,spark_put
	pop bc
	ld de,00010h
	add ix,de
	djnz spark_loop
	ret
; Write SAT Y, X, pat 0xD0.
spark_put:                        ; 0xBD65  SAT Y,X,pat 0xD0
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
; HL = vy*B, DE = vx*B for dir A (0..15).
spark_vel:                        ; 0xBD74  HL=vy*B, DE=vx*B; A = dir 0..15
	push af
	ld hl,spark_vx_start
	call tbl_word
	ld e,l
	ld d,h
	ld hl,00000h
	push bc
spark_vx_mul:
	add hl,de
	djnz spark_vx_mul
	pop bc
	pop af
	push hl
	ld hl,spark_vy_start
	call tbl_word
	ld e,l
	ld d,h
	ld hl,00000h
spark_vy_mul:
	add hl,de
	djnz spark_vy_mul
	pop de
	ret

; BLOCK 'bd97_tbl' (start 0xbd97 end 0xbdb7)
spark_vy_start:                   ; 0xBD97  Y velocity 8.8, 16 dirs
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
spark_vy_end:

; BLOCK 'bdb7_tbl' (start 0xbdb7 end 0xbdd7)
spark_vx_start:                   ; 0xBDB7  X velocity 8.8, 16 dirs
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
spark_vx_end:
; Hallway Vic-back plus map Vic at EDCB.
tour_sat:                         ; 0xBDD7  hallway Vic-back + map Vic (tour_far)
	call tour_marks
; Map-mark SAT only (world_far).
tour_vic:                         ; 0xBDDA  map Vic SAT at EDCB/EDCC (world_far)
	ld hl,0e830h
	ld a,(0edcbh)           ; ceremony X
	ld (hl),a
	inc hl
	ld a,(0edcch)           ; ceremony Y
	ld (hl),a
	inc hl
	ld (hl),0d0h
	ld hl,0d2c0h
	ld de,0d2c1h
	ld bc,0000fh
	ld (hl),007h
	ldir
	ret
; 32×48 Vic from behind at X=A8; EDD8 0 → pat 4 else 0x34.
tour_marks:                       ; 0xBDF7  32×48 Vic-back; 2 walk poses (vic_back)
	ld a,(0edd8h)           ; walk pose
	or a
	ld a,004h
	jr z,tour_pat
	ld a,034h
tour_pat:
	ld hl,0e800h            ; SAT
	ld de,0a868h
	call tour_quad
	ld de,0a878h
	call tour_quad
	ld de,0a888h
	call tour_quad
	jr tour_col
; 2x2 sprites at DE (Y,X), pattern A.
tour_quad:                        ; 0xBE18  2x2 sprites at DE (Y,X), pat A
	ld b,002h
tour_pair:
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
	djnz tour_pair
	ret
tour_col:                         ; 0xBE35  SAT colour 0x0D / 0x4E stripes
	ld hl,0d200h            ; boot spare
	ld de,0d201h
	ld bc,0000fh
	ld (hl),00dh
	ldir
	call fill_4e
	call fill_0d
	call fill_0d
	call fill_0d
	call fill_0d
	call fill_0d
; 15 x 0x0D then fall into fill_4e.
fill_0d:                          ; 0xBE54  15× 0x0D then fall into fill_4e
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),00dh
	ldir
; 15 x 0x4E.
fill_4e:                          ; 0xBE5D  15× 0x4E
	inc hl
	inc de
	ld bc,0000fh
	ld (hl),04eh
	ldir
	ret
str_skip:                         ; 0xBE67
	defb 048h, 070h         ; D,E
	TEXT "skip"
	defb 0ffh               ; end
str_find:                         ; 0xBE6E
	defb 048h, 070h         ; D,E
	TEXT "find"
	defb 0ffh               ; end
; Retry: print skip, show name, TAPION.
tape_skip:                        ; 0xBE75  retry: print "skip", show name
	ld hl,str_skip
	call print_stream
	call tape_name
; TAPION entry from io_do_load.
tape_load:                        ; 0xBE7E  TAPION entry (io_do_load)
	call TAPION
	jp c,tape_fail
tape_leadin:
	ld c,010h
tape_aa:
	exx
	call TAPIN
	exx
	jp c,tape_fail
	cp 0aah
	jr nz,tape_leadin
	dec c
	jr nz,tape_aa
	ld hl,0ee50h            ; E300 list / tape
	ld bc,00008h
	call tape_read
	jr c,tape_fail
	call TAPOOF
	ld hl,0ee50h            ; E300 list / tape
	ld de,0e270h            ; tape name
	ld b,008h
tape_cmp:
	ld a,(de)
	cp (hl)
	jr nz,tape_skip
	inc de
	inc hl
	djnz tape_cmp
	ld hl,str_find
	call print_stream
	call tape_name
	call TAPION
	jr c,tape_fail
	ld ix,save_map
	ld d,000h
	ld b,006h
tape_chunk:
	push bc
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld c,(ix+002h)
	ld b,(ix+003h)
	call tape_read
	pop bc
	jr c,tape_fail
	inc ix
	inc ix
	inc ix
	inc ix
	djnz tape_chunk
	exx
	call TAPIN
	exx
	jr c,tape_fail
	cp d
	jr nz,tape_fail
	jp TAPOOF
; Print 8 glyphs at EE50 to 7070.
tape_name:                        ; 0xBEF3  8 glyphs at EE50 → 7070
	ld hl,0ee50h            ; E300 list / tape
	ld de,07070h
	jp print_name
; TAPOOF, "load error", E27F=2.
tape_fail:                        ; 0xBEFC
	call TAPOOF
	call scr_reset
	ld hl,str_load_err
	call print_stream
	ld a,002h
	ld (0e27fh),a           ; I/O error
	ret
str_load_err:                     ; 0xBF0E
	defb 050h, 060h         ; D,E
	TEXT "load error"
	defb 0ffh               ; end
; BC bytes to HL via TAPIN; checksum D.
tape_read:                        ; 0xBF1B  BC bytes to HL, checksum D
	exx
	call TAPIN
	exx
	ret c
	ld (hl),a
	add a,d
	ld d,a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,tape_read
	ret
; TAPOON entry from io_save.
tape_save:                        ; 0xBF2B  TAPOON entry (io_save)
	ld a,0ffh
	call TAPOON
	jp c,tape_save_fail
	ld b,010h
tape_aa_out:
	ld a,0aah
	exx
	call TAPOUT
	exx
	jr c,tape_save_fail
	djnz tape_aa_out
	ld hl,0e270h            ; tape name
	ld bc,00008h
	call tape_write
	jr c,tape_save_fail
	call TAPOOF
	xor a
	call TAPOON
	jr c,tape_save_fail
	ld ix,save_map
	ld d,000h
	ld b,006h
tape_save_chunk:
	push bc
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld c,(ix+002h)
	ld b,(ix+003h)
	call tape_write
	pop bc
	jr c,tape_save_fail
	inc ix
	inc ix
	inc ix
	inc ix
	djnz tape_save_chunk
	ld a,d
	call TAPOUT
	jr c,tape_save_fail
	jp TAPOOF
; TAPOOF, "save error", E27F=2.
tape_save_fail:                   ; 0xBF82
	call TAPOOF
	call scr_reset
	ld hl,str_save_err
	call print_stream
	ld a,002h
	ld (0e27fh),a           ; I/O error
	ret
str_save_err:                     ; 0xBF94
	defb 050h, 060h         ; D,E
	TEXT "save error"
	defb 0ffh               ; end
; BC bytes from HL via TAPOUT; checksum D.
tape_write:                       ; 0xBFA1  BC bytes from HL, checksum D
	ld a,(hl)
	ld e,a
	inc hl
	exx
	call TAPOUT
	exx
	ret c
	ld a,e
	add a,d
	ld d,a
	dec bc
	ld a,b
	or c
	jr nz,tape_write
	ret

	ds 77, 0ffh
