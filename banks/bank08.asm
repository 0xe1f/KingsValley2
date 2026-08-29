; ===========================================================================
;  bank 08 — tileset + list tables, assembled at CPU 0x8000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. blit_list reads 8x tiles from
;  0x8000 + ((B&0xE0)<<5) + ((B&0x1F)*4). pal_idx @ 0x8FFC (5 words,
;  [0] == 0x9006); packed blit lists at 0x902E / 0x9043 / 0x9063 /
;  0x9069 / 0x9074 (DE=0x8FFC). gfxview --bpp 1 is tile-like.
;  .blocks map: banks/bank08.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank08.gfx.bin", 0, 0xFFC
pal_idx:
	defw 09006h, 0900eh, 09016h, 0901eh, 09026h
pal_list:
	defb 009h, 00bh, 008h, 00fh, 00ch, 000h, 000h, 000h
	defb 001h, 002h, 00fh, 003h, 006h, 005h, 00bh, 000h
	defb 006h, 001h, 00fh, 004h, 003h, 002h, 007h, 005h
	defb 008h, 00bh, 006h, 003h, 002h, 005h, 00fh, 00ah
	defb 000h, 002h, 003h, 004h, 001h, 00bh, 000h, 000h
blit_902e:
	defb 004h, 001h, 03fh, 027h, 09dh, 004h, 040h, 011h
	defb 00fh, 0a3h, 00ch, 051h, 03eh, 0a7h, 0a4h, 00ch
	defb 08fh, 040h, 077h, 0aah, 0ffh, 004h, 001h, 03fh
	defb 027h, 09dh, 004h, 040h, 011h, 00fh, 0a3h, 014h
	defb 058h, 03fh, 07fh, 090h, 014h, 097h, 019h, 067h
	defb 096h, 0ffh, 014h, 058h, 03fh, 07fh, 090h, 014h
	defb 097h, 019h, 067h, 096h, 0ffh, 024h, 001h, 035h
	defb 02fh, 098h, 0ffh, 01ch, 001h, 03fh, 077h, 0b0h
	defb 01ch, 040h, 00fh, 05fh, 0b6h, 0ffh, 014h, 058h
	defb 03fh, 07fh, 090h, 014h, 097h, 019h, 067h, 096h
	defb 0ffh
	INCBIN "banks/bank08.gfx.bin", 0x107F
