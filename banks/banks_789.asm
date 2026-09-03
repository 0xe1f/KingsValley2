; ===========================================================================
;  banks 7-9 — gfx triplet via page_banks_789, CPU 0x6000–0xBFFF (one PHASE).
;  blit dests / palettes / title copy_tiles. Tile src 0x8000.
;  Regen one 8K bank at a time:
;    tools/workbench/msx/regen-bank.sh 7 0x6000 banks/banks_789.blocks
;    tools/workbench/msx/regen-bank.sh 8 0x8000 banks/banks_789.blocks
;    tools/workbench/msx/regen-bank.sh 9 0xA000 banks/banks_789.blocks
; ===========================================================================

idx6:
	defw pal_list, pal_list+2, pal_list+6, pal_list+10, pal_list+14, pal_list+22
pal_list:
	defb 00ch, 00fh, 008h, 00bh, 00ch, 00fh, 007h, 009h
	defb 00ah, 00fh, 000h, 007h, 009h, 00fh, 000h, 007h
	defb 008h, 009h, 00ah, 00bh, 00ch, 00fh, 006h, 008h
	defb 00ch, 00fh, 000h, 000h, 000h, 000h
blit_recs:                          ; 0x602A  blit_common; last dest-hi + 0xFF overlap e241_tbl[0]
	defb 000h, 058h, 006h
	defw pat_621c
	defb 00ah, 05eh, 01ch
	defw pat_624c
	defb 012h, 07ah, 006h
	defw pat_640c
	defb 01ah, 080h, 00bh
	defw pat_646c
	defb 024h, 08bh, 004h
	defw pat_6974
	defb 012h, 095h, 003h
	defw pat_656c
	defb 013h, 098h, 003h
	defw pat_656c
	defb 024h, 09bh, 023h
	defw pat_659c
	defb 024h, 0beh, 006h
	defw pat_68e4
	defb 025h, 0c4h, 006h
	defw pat_68e4
	defb 025h, 08fh, 004h
	defw pat_6974
	defb 024h, 0cah, 004h, 0d4h  ; dest pat_69d4; dest-hi + 0xFF overlap e241_tbl[0]
e241_tbl:
	defw 0ff69h, 06073h, 0607fh, 06089h, 06091h, 0609fh, 060a7h, pal_idx_60ad
	defw pal_idx_60b5, pal_idx_60b9, pal_idx_60c1, pal_idx_60c5, pal_idx_60cd, pal_idx_60d5, pal_idx_60dd, pal_idx_60e1
	defw pal_idx_60e9, pal_idx_60f1, pal_idx_60f9, pal_idx_6101, pal_idx_6109, pal_idx_610d, pal_idx_6115, pal_idx_611d
	defw pal_idx_6125, pal_idx_6129, pal_idx_612d, pal_idx_6135, pal_idx_613d, pal_idx_6145, pal_idx_614d, pal_idx_6151
	defw pal_idx_6159, pal_idx_6161, pal_idx_6169, pal_idx_6171
	INCLUDE "banks/data/pal_idx.asm"
blit_ptr:
	; blit_world (bank 00): HL = blit_ptr[world] -> blit_list; DE = e241_tbl[world].
	; world = (0xE241) = ceil(level/10), 1..6 (set_world @ 0x5C80).
	; [0] 0x0F0C sentinel (world 0 unused); [1] == blit_w1 == table end.
	defw 00f0ch, blit_w1, blit_w2, blit_w3, blit_w4, blit_w5, blit_w6
	INCLUDE "banks/data/blit_world.asm"
	INCLUDE "banks/data/dest07.asm"
; --- bank 08 @ 0x8000 ---
	INCLUDE "banks/data/dest08.asm"
pal_idx:
	defw pal_9006, pal_900e, pal_9016, pal_901e, pal_9026
pal_9006:
	defb 009h, 00bh, 008h, 00fh, 00ch, 000h, 000h, 000h
pal_900e:
	defb 001h, 002h, 00fh, 003h, 006h, 005h, 00bh, 000h
pal_9016:
	defb 006h, 001h, 00fh, 004h, 003h, 002h, 007h, 005h
pal_901e:
	defb 008h, 00bh, 006h, 003h, 002h, 005h, 00fh, 00ah
pal_9026:
	defb 000h, 002h, 003h, 004h, 001h, 00bh, 000h, 000h
blit_902e:                          ; 0x902E
	defb 004h, 001h, 03fh
	defw pat_9d27
	defb 004h, 040h, 011h
	defw pat_a30f
	defb 00ch, 051h, 03eh
	defw pat_a4a7
	defb 00ch, 08fh, 040h
	defw pat_aa77
	defb 0ffh               ; end
blit_9043:                          ; 0x9043
	defb 004h, 001h, 03fh
	defw pat_9d27
	defb 004h, 040h, 011h
	defw pat_a30f
	defb 014h, 058h, 03fh
	defw pat_907f
	defb 014h, 097h, 019h
	defw pat_9667
	defb 0ffh               ; end
blit_9058:                          ; 0x9058  unreferenced; same recs as blit_9074
	defb 014h, 058h, 03fh
	defw pat_907f
	defb 014h, 097h, 019h
	defw pat_9667
	defb 0ffh               ; end
blit_9063:                          ; 0x9063
	defb 024h, 001h, 035h
	defw pat_982f
	defb 0ffh               ; end
blit_9069:                          ; 0x9069
	defb 01ch, 001h, 03fh
	defw pat_b077
	defb 01ch, 040h, 00fh
	defw pat_b65f
	defb 0ffh               ; end
blit_9074:                          ; 0x9074
	defb 014h, 058h, 03fh
	defw pat_907f
	defb 014h, 097h, 019h
	defw pat_9667
	defb 0ffh               ; end
	INCLUDE "banks/data/dest08b.asm"
; --- bank 09 @ 0xA000 ---
	INCLUDE "banks/data/dest09.asm"
b7c7_idx:
	defw b7d1_pal, b7d1_pal+2, b7d1_pal+4, b7d1_pal+8, b7d1_pal+10
b7d1_pal:
	defb 001h, 009h, 001h, 008h, 001h, 008h, 009h, 00ah
	defb 001h, 007h, 001h, 007h, 002h, 004h
b7df_blit:                          ; 0xB7DF
	defb 000h, 001h, 001h
	defw pat_b82b
	defb 000h, 002h, 001h
	defw pat_b833
	defb 001h, 003h, 001h
	defw pat_b833
	defb 008h, 004h, 001h
	defw pat_b83b
	defb 008h, 005h, 001h
	defw pat_b843
	defb 009h, 006h, 001h
	defw pat_b843
	defb 012h, 007h, 007h
	defw pat_b84b
	defb 012h, 00eh, 005h
	defw pat_b8bb
	defb 013h, 013h, 005h
	defw pat_b8bb
	defb 018h, 018h, 002h
	defw pat_b90b
	defb 018h, 01ah, 002h
	defw pat_b91b
	defb 019h, 01ch, 002h
	defw pat_b91b
	defb 022h, 01eh, 025h
	defw pat_b92b
	defb 022h, 043h, 001h
	defw pat_bb7b
	defb 023h, 044h, 001h
	defw pat_bb7b
	defb 0ffh               ; end
	INCLUDE "banks/data/dest09b.asm"
bb8b_pal:
	defb 000h, 000h, 000h, 001h, 070h, 003h, 002h, 060h
	defb 001h, 003h, 044h, 004h, 00fh, 077h, 007h, 0ffh
	INCLUDE "banks/data/title09.asm"
	INCLUDE "banks/data/title_tiles.asm"
	ds 644, 0ffh
