; ===========================================================================
;  bank 09 — gfx / packed lists, assembled at CPU 0xA000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. Head looks SCREEN 2
;  pattern/color (95 7F 00 …). l54a0h list table @ 0xB7C7 (DE) / 0xB7DF
;  (HL); l4f1ch streams @ 0xBB8B. Trailing 0xFF pad from 0xBD7C.
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank09.gfx.bin"
	ds 644, 0ffh
