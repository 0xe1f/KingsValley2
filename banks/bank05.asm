; ===========================================================================
;  bank 05 — packed-PSG payload, assembled at CPU 0x8000 (PHASE in master).
;  Triplet 4/5/6 via page_banks_456. Continuation of bank 4 streams past
;  0x7FFF (headers in sound_ptr point here, e.g. 0x80A0). Not code.
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank05.psg.bin"
