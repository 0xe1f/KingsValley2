; ===========================================================================
;  bank 15 — gfx / packed lists / UI tiles, CPU 0xA000 (PHASE in master).
;  Pair 14/15 via page_banks_14_15. Not code. l54a0h: DE=0xB116 ([0]==0xB118)
;  / HL=0xB120; l4f1ch @ 0xA7CE; l573bh tiles @ 0xA2C8 / 0xA358 / 0xA702.
;  Trailing 0xFF pad from 0xBDCB.
;  .blocks map: banks/bank15.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank15.gfx.bin"
	ds 565, 0ffh
