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
; Ending font reads stored letters as +4 (`=`→A, `?`→C, `{`→`.`).
; world_txt has five defw. Completing world 6 still does print_world with
; index 5: that word is str_w1's TEXT_AT 20h,90h (= ptr 0x9020), inside
; bank 0B map stream 0x8EA8 — not a TEXT island (ends at 0xFF @ 0x905E).
str_pwd_best:                     ; 0xAC01  password card (normal font)
	TEXT_AT 048h, 020h
	TEXT "do your best ;;"
	TEXT_END
world_txt:                        ; 0xAC13  E241-1 → print_stream (print_world)
	defw str_w1, str_w2, str_w3, str_w4, str_w5
str_w1:                           ; 0xAC1D  world 1; AT is world_txt[5]
	TEXT_AT 020h, 090h
	TEXT "dkh` kqp;;"             ; hold out??
	TEXT_END
str_w2:                           ; 0xAC2A  world 2
	TEXT_AT 020h, 088h
	TEXT "pnu pk p=ga"            ; try to tAke
	TEXT_NEXT 020h, 098h
	TEXT "= jas opal"             ; A new step
	TEXT_NEXT 020h, 0a8h
	TEXT "bkns=n`"                ; forwArd
	TEXT_END
str_w3:                           ; 0xAC4F  world 3
	TEXT_AT 018h, 080h
	TEXT "da=raj gjkso"           ; heAven knows
	TEXT_NEXT 030h, 090h
	TEXT "sdaj"                   ; when
	TEXT_NEXT 020h, 0a0h
	TEXT "pdeo c=ia"              ; this gAme
	TEXT_NEXT 030h, 0b0h
	TEXT "sehh aj`"               ; will end
	TEXT_END
str_w4:                           ; 0xAC7C  world 4
	TEXT_AT 012h, 088h
	TEXT "kd; iu ck`;"            ; oh? my god?
	TEXT_NEXT 020h, 098h
	TEXT "e >aheara"              ; i Believe
	TEXT_NEXT 040h, 0a8h
	TEXT "ej ck`"                 ; in god
	TEXT_END
str_w5:                           ; 0xAC9F  world 5
	TEXT_AT 018h, 088h
	TEXT "=p hkjc h=op"           ; At long lAst
	TEXT_NEXT 030h, 098h
	TEXT "bej=h"                  ; finAl
	TEXT_NEXT 020h, 0a8h
	TEXT "?kqjp `ksj"             ; Count down
	TEXT_END
str_end_boot:                     ; 0xACC3  end_boot
	TEXT_AT 048h, 048h
	TEXT "?kjcn=pqh=pekjo"        ; CongrAtulAtions
	TEXT_NEXT 040h, 058h
	TEXT "pk re?g tz{ ;"          ; to viCk …
	TEXT_NEXT 048h, 068h
	TEXT "ukq danke?=hhu"         ; you heroiCAlly
	TEXT_NEXT 040h, 078h
	TEXT "qjoa=ha` =hh pda"       ; unseAled All the
	TEXT_NEXT 040h, 088h
	TEXT "hk?gow"                 ; loCks.
	TEXT_END
str_end_txt2:                     ; 0xAD12  end_txt2
	TEXT_AT 028h, 080h
	TEXT "=hh ukq d=ra pk `k jks" ; All you hAve to do now
	TEXT_NEXT 028h, 090h
	TEXT "eo pqnj kbb pda ose?d"  ; is turn off the swiCh
	TEXT_NEXT 028h, 0a0h
	TEXT "pk o=ra pda sknh`w"     ; to sAve the world.
	TEXT_END
str_end_key:                      ; 0xAD58  end_txt3
	TEXT_AT 048h, 0a0h
	TEXT "lqod ol=?a gau"         ; push spACe key
	TEXT_END
str_end_danger:                   ; 0xAD69
	TEXT_AT 060h, 0a0h
	TEXT "`=jcan ;;;"             ; dAnger ???
	TEXT_END
ad76_tbl:                         ; 0xAD76  end_print_i / EDCF → credit page
	defw str_staff, str_program, str_sound, str_graphic, str_title
	defw str_gamedes, str_thanks, str_presented, str_the_end
str_the_end:                      ; 0xAD88  credit[8]
	TEXT_AT 060h, 048h
	TEXT "pda aj`"                ; the end
	TEXT_END
str_staff:                        ; 0xAD92  credit[0]
	TEXT_AT 068h, 048h
	TEXT "op=bb"                  ; stAff
	TEXT_END
str_program:                      ; 0xAD9A  credit[1]
	TEXT_AT 040h, 030h
	TEXT "lnkcn=i"                ; progrAm
	TEXT_NEXT 070h, 050h
	TEXT "ew=g=`="                ; i.AkAdA
	TEXT_NEXT 070h, 060h
	TEXT "gwj=c=a"                ; k.nAgAe
	TEXT_NEXT 070h, 070h
	TEXT "pwkg="                  ; t.okA
	TEXT_NEXT 070h, 080h
	TEXT "pwkpoqg="               ; t.otsukA
	TEXT_END
str_graphic:                      ; 0xADCB  credit[3]
	TEXT_AT 040h, 030h
	TEXT "cn=lde?"                ; grAphiC
	TEXT_NEXT 070h, 050h
	TEXT "dwi=gep=je"             ; h.mAkitAni
	TEXT_NEXT 070h, 060h
	TEXT "iwp=>=p="               ; m.tABAtA
	TEXT_NEXT 070h, 070h
	TEXT "owqajk"                 ; s.ueno
	TEXT_NEXT 070h, 080h
	TEXT "owes=ikpk"              ; s.iwAmoto
	TEXT_END
str_sound:                        ; 0xAE02  credit[2]
	TEXT_AT 040h, 030h
	TEXT "okqj`"                  ; sound
	TEXT_NEXT 070h, 050h
	TEXT "gwqad=n="               ; k.uehArA
	TEXT_NEXT 070h, 060h
	TEXT "iweg=negk"              ; m.ikAriko
	TEXT_NEXT 070h, 070h
	TEXT "uwi=jjk"                ; y.mAnno
	TEXT_NEXT 070h, 080h
	TEXT "pwbqnqg=s="             ; t.furukAwA
	TEXT_NEXT 070h, 090h
	TEXT "gwu=i=odep="            ; k.yAmAshitA
	TEXT_END
str_title:                        ; 0xAE46  credit[4]
	TEXT_AT 040h, 030h
	TEXT "pepha `aoecj"           ; title design
	TEXT_NEXT 070h, 050h
	TEXT "jwo=pk"                 ; n.sAto
	TEXT_END
str_gamedes:                      ; 0xAE5E  credit[5]
	TEXT_AT 040h, 030h
	TEXT "c=ia `aoecj"            ; gAme design
	TEXT_NEXT 070h, 050h
	TEXT "owes=ikpk"              ; s.iwAmoto
	TEXT_END
str_thanks:                       ; 0xAE78  credit[6]
	TEXT_AT 040h, 030h
	TEXT "ola?e=h pd=jgo"         ; speCiAl thAnks
	TEXT_NEXT 070h, 050h
	TEXT "d=h"                    ; hAl
	TEXT_NEXT 070h, 060h
	TEXT "egq"                    ; iku
	TEXT_NEXT 070h, 070h
	TEXT "o=hp"                   ; sAlt
	TEXT_NEXT 070h, 080h
	TEXT "pan="                   ; terA
	TEXT_NEXT 070h, 090h
	TEXT "nkki  1008"             ; room  1008
	TEXT_NEXT 070h, 0a0h
	TEXT "nkki  1013"             ; room  1013
	TEXT_NEXT 070h, 0b0h
	TEXT "n?727"                  ; rC727
	TEXT_END
str_presented:                    ; 0xAEC5  credit[7]
	TEXT_AT 050h, 040h
	TEXT "lnaoajpa` >u"           ; presented By
	TEXT_NEXT 068h, 050h
	TEXT "gkj=ie"                 ; konAmi
	TEXT_END
str_end_txt5:                     ; 0xAEDD  end walk text
	TEXT_AT 030h, 030h
	TEXT "pd=jgo pk ukqn ?kqn=ca" ; thAnks to your CourAge
	TEXT_NEXT 010h, 050h
	TEXT "pda sknh` d=o >aaj o=ra` ;;" ; the world hAs Been sAved ??
	TEXT_NEXT 058h, 070h
	TEXT "sahh `kjaw"             ; well done.
	TEXT_END
str_end_congrats:                 ; 0xAF21  end_page header
	TEXT_AT 038h, 010h
	TEXT "?kjcn=pqh=pekjo ;;;"    ; CongrAtulAtions ???
	TEXT_END
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
	TEXT_AT 050h, 08ch
	TEXT "disk error"
	TEXT_END
str_disk_io:                      ; 0xAF6D
	TEXT_AT 048h, 09ch
	TEXT "disk io error"
	TEXT_END
str_nofile:                       ; 0xAF7D  io_nofile
	TEXT_AT 048h, 09ch
	TEXT "file not found"
	TEXT_END
str_disk_full:                    ; 0xAF8E
	TEXT_AT 058h, 09ch
	TEXT "disk full"
	TEXT_END
str_not_ready:                    ; 0xAF9A
	TEXT_AT 040h, 09ch
	TEXT "disk not ready"
	TEXT_END
str_wr_prot:                      ; 0xAFAB
	TEXT_AT 048h, 09ch
	TEXT "write protect"
	TEXT_END
str_too_manny:                    ; 0xAFBB  ROM spelling
	TEXT_AT 048h, 09ch
	TEXT "too manny files"
	TEXT_END
str_datatype:                     ; 0xAFCD
	TEXT_AT 048h, 09ch
	TEXT "datatypeerror"
	TEXT_END
	INCLUDE "banks/data/tiles0C.asm"
str_start_sel:                    ; 0xB185  file_menu (E24B 0..2)
	TEXT_AT 040h, 040h
	TEXT "start  select"
	TEXT_NEXT 080h, 050h
	TEXT "normal"
	TEXT_NEXT 080h, 060h
	TEXT "password"
	TEXT_NEXT 080h, 070h
	TEXT "stage load"
	TEXT_END
	INCLUDE "banks/data/file_pat.asm"
	INCLUDE "banks/data/ef10_spr.asm"
str_clear_card:                   ; 0xB256  clear_card (stage-clear)
	TEXT_AT 068h, 020h
	TEXT "nice ;"
	TEXT_NEXT 038h, 030h
	TEXT "lets go next stage"
	TEXT_NEXT 048h, 050h
	TEXT "special bonus"
	TEXT_END
str_secret_cmd:                   ; 0xB284  title GAME + SNSMAT bit 5
	TEXT_AT 048h, 040h
	TEXT "secret command"
	TEXT_NEXT 060h, 058h
	TEXT "f}}t}}}l"               ; `{` underline
	TEXT_NEXT 060h, 068h
	TEXT "}}y}}}}}"
	TEXT_END
	ds 341, 0ffh                  ; 0xB2AB–0xB400 pad
load_ef10:                        ; 0xB400  ef10_tbl[level] -> EF10 (type, 0, screen/X/Y)
	ld hl,ef10_tbl
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
tick_ef10:                        ; 0xB422  per-pyramid FX (EF10); disp_b42f on EF11
	ld hl,0ef10h
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
ef10_land:                        ; 0xB437
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
	call draw_maptools
	call 096cfh
	jp sfx_3b
ef10_hold:                        ; 0xB462
	ld hl,0ef15h
	dec (hl)
	ret nz
	ld hl,0ef11h
	inc (hl)
	ret
ef10_clear:                       ; 0xB46C
	exx
	ld a,(0e243h)
	cp (hl)
	ret nz
	call sub_b4c9h
	ret nc
	call sfx_2e
	ld hl,0ef11h
	inc (hl)
	call 096ffh
	call 090abh
	call sub_b50bh
	call ef10_restore
	call draw_maptools
	jp 096cfh
ef10_enter:                       ; 0xB48F  E208 bit 1 (down) → E200=12
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
	jp sfx_30
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
	jp draw_tilemap

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
	jp vdp_hmmm
sub_b50bh:
	ld hl,0ef13h
	ld e,(hl)
	inc l
	ld d,(hl)
	ld hl,000b0h
	ld bc,01010h
	ld a,001h
	jp vdp_hmmm
draw_ef10:                        ; 0xB51C  if EF10 live on this screen, stamp (state 3 = restore)
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
	jp z,ef10_restore
	jr sub_b4e3h
end_menu:                         ; 0xB534  mode_end E201=2; type 1 sound select, else puzzle
	call end_pick
	jp spr_vram
end_pick:                         ; 0xB53A
	ld ix,0ef10h
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
lb585h:
	TEXT_AT 050h, 018h
	TEXT "sound select"
	TEXT_NEXT 040h, 0a8h
	TEXT "select ||| space"
	TEXT_NEXT 058h, 0b8h
	TEXT "end ||| return"
	TEXT_END
lb5b8h:
	TEXT_AT 050h, 018h
	TEXT "puzzle  game"
	TEXT_END
lb5c7h:
	TEXT_AT 060h, 090h
	TEXT "all right"
	TEXT_NEXT 060h, 0a0h
	TEXT "rest  3 up"
	TEXT_END
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
puzzle_ui:                        ; 0xB6B0  EF10 type 2 → disp_b6be
data_b548_end:
	ld a,(0e20ch)
	rla
	rla
	jp c,lb8a3h
	ld a,(ix+001h)
	call DISPATCH_A

; disp_b6be: password / 5x5 sliding-puzzle UI. DISPATCH_A on (ix+1), 6 states.
disp_b6be_start:
	defw 0b6cah                   ; init: draw "esc key", wait
	defw 0b6f2h                   ; wait space, blank prompt
	defw 0b701h                   ; load 5x5 from (0xE203), "puzzle game"
	defw 0b749h                   ; cursor + slide (disp_b7a5)
	defw 0b85eh                   ; solved? "all right" / bump (0xE240)
	defw 0b89dh                   ; wait space, exit
disp_b6be_end:
	call 04e98h
	call sat_wipe
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
	call print_stream
	inc (ix+001h)
	jp sfx_0a
	ld a,(0e207h)
	and 010h
	ret z
	inc (ix+001h)
	ld hl,0b8beh
	jp print_stream_blank
	ld hl,lb5e0h
	ld a,(0e203h)
	and 003h
	call tbl_word
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
	jp print_stream
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
	jp sfx_32
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

; disp_b7a5: slide current tile into the adjacent empty cell (5x5, stride 5).
; DISPATCH_A on (C-1) from sub_b824h: C=1..4 = empty at D-1 / D+1 / E-1 / E+1.
; [3] overlaps the first instruction after the table (move +E), not a no-op.
disp_b7a5_start:
	defw 0b7b8h                   ; empty at D-1: -5, dec (ix+2)
	defw 0b7d2h                   ; empty at D+1: +5, inc (ix+2)
	defw 0b7e1h                   ; empty at E-1: -1, dec (ix+3)
	defw 0b7adh                   ; empty at E+1: +1, inc (ix+3)
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
	call sat_wipe
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
	call print_stream_blank
	ld hl,lb5c7h
	jp print_stream
	ld a,(0e207h)
	and 010h
	ret z
lb8a3h:
	ld bc,00007h
	ld (ix+000h),b
	call WRTVDP
	jp sfx_01
lb8afh:                           ; print_stream: "end  esc key" / "push space key"
	TEXT_AT 050h, 0a0h
	TEXT "end  esc key"
	TEXT_NEXT 048h, 090h
	TEXT "push space key"
	TEXT_END
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
snd_sel:                          ; 0xB917  EF10 type 1 "sound select"
	ld a,(ix+001h)
	cp 001h
	jr z,lb938h
	jr nc,lb981h
	call 04e98h
	call 057ach
	call 057cah
	call 0578dh
	call sat_wipe
	inc (ix+001h)
	ld hl,lb585h
	jp print_stream
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
	call WRTVDP
	jp sfx_01
lb95ah:
	call sfx_32
	dec (ix+002h)
	ld a,(ix+002h)
	rla
	ret nc
	ld (ix+002h),012h
	ret
lb96ah:
	call sfx_32
	inc (ix+002h)
	ld a,(ix+002h)
	cp 013h
	ret c
	ld (ix+002h),000h
	ret
lb97bh:
	inc (ix+001h)
	jp sfx_01
lb981h:
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
	ld de,pat_b9fa_start
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

; BLOCK 'pat_b9fa' (start 0xb9fa end 0xba11)
pat_b9fa_start:
	defb 02ch, 033h, 03ch, 045h, 04ch, 055h, 05ch, 06ch
	defb 073h, 07ch, 085h, 08ch, 09ch, 0a3h, 0ach, 0b5h
	defb 0bch, 0c5h, 0cch, 00dh, 04eh, 00dh, 04eh
pat_b9fa_end:

demo_init:                        ; 0xBA11  attract: next pyramid in demo_lvls
	ld hl,001ffh                  ; E209=0xFF so first tick wraps to step 0
	ld (0e209h),hl
	ld hl,0e219h
	ld a,(hl)
	ld de,demo_lvls
	call ADD_DE_A
	ld a,(de)
	ld (0e242h),a
	inc (hl)
	ld a,(hl)
	cp 007h
	jr c,demo_init_wrap
	ld (hl),001h
demo_init_wrap:
	xor a
	ld (0e203h),a
	inc a
	ld (0e246h),a
	call 04360h
	jp 04388h                     ; 0xBA38  C3 88 43
demo_lvls equ $-1                 ; 0xBA3A  [0]=43 overlap; [1..6] pyramids
	defb 002h, 012h, 01ah, 028h, 030h, 035h
demo_wait:                        ; 0xBA41  E200=2: wait vic_hit, or take E248 door
	ld a,(0e248h)
	and a
	jr nz,demo_door
	call 04358h
	ld a,(0e280h)
	cp 005h                       ; wait vic_hit
	ret nz
demo_end:
	xor a
	ld (0e246h),a
	jp sfx_01
demo_door:
	xor a
	ld (0e24dh),a
	call 05dfeh
	ld a,(0e24dh)
	and a
	ret nz
	jp 04369h
demo_tick:                        ; 0xBA66  countdown E20A; next word -> keys_apply
	ld hl,0e20ah
	dec (hl)
	jr nz,demo_hold
	dec hl
	inc (hl)
	inc hl
	call demo_word
	cp 0ffh
	jr z,demo_end
	ld hl,0e20ah
	ld (hl),c
demo_hold:
	call demo_word
	jp keys_apply
demo_word:                        ; 0xBA80  A = E208 mask, C = duration (E209 index)
	dec hl
	ld c,(hl)
	ld a,(0e241h)
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
	defw 0baa0h                   ; world 1  (ba_lists+0x000, 27 words)
	defw 0bad6h                   ; world 2  (ba_lists+0x036, 31 words)
	defw 0bb14h                   ; world 3  (ba_lists+0x074, 35 words)
	defw 0bb5ah                   ; world 4  (ba_lists+0x0BA, 48 words)
	defw 0bbbah                   ; world 5  (ba_lists+0x11A, 46 words)
	defw 0bc16h                   ; world 6  (ba_lists+0x176, 44 words)
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
	ld (0e900h),a
	ret
spark_spawn:                      ; 0xBC86  skip if E902; fill empty E910 slot
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
spark_tick:                       ; 0xBCD2  spawn, wipe SAT, move, stamp
	call spark_spawn
	call spark_wipe
	call spark_move
	jr spark_sat
spark_move:                       ; 0xBCDD
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
spark_wipe:                       ; 0xBD30  SAT Y=E0, D200 colour 5
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
spark_sat:                        ; 0xBD4B  live sparks → SAT
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
	call tbl_word
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
	call tbl_word
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
lbe67h:                           ; print_stream: "skip"
	TEXT_AT 048h, 070h
	TEXT "skip"
	TEXT_END
lbe6eh:                           ; print_stream: "find"
	TEXT_AT 048h, 070h
	TEXT "find"
	TEXT_END
lbe75h:
	ld hl,lbe67h
	call print_stream
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
	call print_stream
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
	call print_stream
	ld a,002h
	ld (0e27fh),a
	ret
lbf0eh:                           ; print_stream: "load error"
	TEXT_AT 050h, 060h
	TEXT "load error"
	TEXT_END
	exx
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
	call print_stream
	ld a,002h
	ld (0e27fh),a
	ret
lbf94h:                           ; print_stream: "save error"
	TEXT_AT 050h, 060h
	TEXT "save error"
	TEXT_END
	ld a,(hl)
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
