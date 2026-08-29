; ===========================================================================
;  bank 08 — tileset + list tables, assembled at CPU 0x8000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. l54a0h reads 8x tiles from
;  0x8000 + ((B&0xE0)<<5) + ((B&0x1F)*4). Palette index table at 0x8FFC
;  (5 words, [0] == 0x9006); packed lists at 0x902E / 0x9043 / 0x9063 /
;  0x9069 / 0x9074 (DE=0x8FFC). gfxview --bpp 1 is tile-like.
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank08.gfx.bin"
