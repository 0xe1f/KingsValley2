; ===========================================================================
;  bank 15 — gfx / packed lists / UI tiles, CPU 0xA000 (PHASE in master).
;  Pair 14/15 via page_banks_14_15. Not code. blit_list: DE=0xB116 ([0]==0xB118)
;  / HL=0xB120; palette_list @ 0xA7CE; draw_tilemap tiles @ 0xA2C8 / 0xA358 / 0xA702.
;  Trailing 0xFF pad from 0xBDCB.
;  .blocks map: banks/bank15.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank15.gfx.bin", 0, 0x7CE
pal_a7ce:
	defb 000h, 000h, 000h, 001h, 030h, 002h, 002h, 041h
	defb 003h, 003h, 051h, 004h, 004h, 065h, 007h, 005h
	defb 000h, 000h, 006h, 000h, 000h, 007h, 070h, 000h
	defb 008h, 041h, 003h, 009h, 051h, 004h, 00ah, 060h
	defb 000h, 00bh, 077h, 007h, 00ch, 050h, 000h, 00dh
	defb 070h, 007h, 00eh, 050h, 004h, 00fh, 000h, 000h
	defb 0ffh
pal_a7ff:
	defb 000h, 000h, 000h, 001h, 033h, 003h, 002h, 044h
	defb 004h, 003h, 055h, 005h, 004h, 066h, 006h, 005h
	defb 000h, 000h, 006h, 000h, 000h, 007h, 070h, 000h
	defb 008h, 030h, 002h, 009h, 050h, 005h, 00ah, 030h
	defb 000h, 00bh, 077h, 007h, 00ch, 000h, 003h, 00dh
	defb 017h, 001h, 00eh, 075h, 006h, 00fh, 000h, 000h
	defb 0ffh
	INCBIN "banks/bank15.gfx.bin", 0x830, 0x8B
pal_a8bb:
	defb 000h, 000h, 000h, 001h, 040h, 002h, 002h, 041h
	defb 003h, 003h, 051h, 004h, 004h, 075h, 007h, 005h
	defb 030h, 003h, 006h, 000h, 003h, 007h, 070h, 000h
	defb 008h, 055h, 005h, 009h, 070h, 004h, 00ah, 070h
	defb 000h, 00bh, 077h, 007h, 00ch, 050h, 000h, 00fh
	defb 000h, 000h, 0ffh
	INCBIN "banks/bank15.gfx.bin", 0x8E6, 0x1116-0x8E6
idx2:
	defw 0b118h
pal_list:
	defb 007h, 008h, 00ah, 00bh, 00ch, 00fh, 000h, 000h
blit_recs:
	defb 004h, 001h, 040h, 02bh, 0b1h, 004h, 041h, 012h
	defb 02bh, 0b7h, 0ffh
	INCBIN "banks/bank15.gfx.bin", 0x112B
	ds 565, 0ffh
