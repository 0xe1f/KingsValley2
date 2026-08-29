; ===========================================================================
;  bank 06 — packed-PSG payload, assembled at CPU 0xA000 (PHASE in master).
;  Triplet 4/5/6 via page_banks_456. Streams continue here (e.g. 0xA0CF);
;  trailing 0xFF pad from 0xBDB1. Not code.
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank06.psg.bin"
	ds 591, 0ffh
