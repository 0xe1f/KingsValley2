; ===========================================================================
;  bank 09 — gfx / packed lists, assembled at CPU 0xA000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. Head looks SCREEN 2
;  pattern/color (95 7F 00 …). blit_list @ 0xB7C7 (DE) / 0xB7DF (HL);
;  palette_list @ 0xBB8B. Trailing 0xFF pad from 0xBD7C.
;  .blocks map: banks/bank09.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank09.gfx.bin", 0, 0x17C7
b7c7_idx:
	defw 0b7d1h, 0b7d3h, 0b7d5h, 0b7d9h, 0b7dbh
b7d1_pal:
	defb 001h, 009h, 001h, 008h, 001h, 008h, 009h, 00ah
	defb 001h, 007h, 001h, 007h, 002h, 004h
b7df_blit:
	defb 000h, 001h, 001h, 02bh, 0b8h, 000h, 002h, 001h
	defb 033h, 0b8h, 001h, 003h, 001h, 033h, 0b8h, 008h
	defb 004h, 001h, 03bh, 0b8h, 008h, 005h, 001h, 043h
	defb 0b8h, 009h, 006h, 001h, 043h, 0b8h, 012h, 007h
	defb 007h, 04bh, 0b8h, 012h, 00eh, 005h, 0bbh, 0b8h
	defb 013h, 013h, 005h, 0bbh, 0b8h, 018h, 018h, 002h
	defb 00bh, 0b9h, 018h, 01ah, 002h, 01bh, 0b9h, 019h
	defb 01ch, 002h, 01bh, 0b9h, 022h, 01eh, 025h, 02bh
	defb 0b9h, 022h, 043h, 001h, 07bh, 0bbh, 023h, 044h
	defb 001h, 07bh, 0bbh, 0ffh
	INCBIN "banks/bank09.gfx.bin", 0x182B, 0x360
bb8b_pal:
	defb 000h, 000h, 000h, 001h, 070h, 003h, 002h, 060h
	defb 001h, 003h, 044h, 004h, 00fh, 077h, 007h, 0ffh
	INCBIN "banks/bank09.gfx.bin", 0x1B9B
	ds 644, 0ffh
