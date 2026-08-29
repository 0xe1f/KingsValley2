; ===========================================================================
;  bank 11 — packed map streams + tiles, assembled at CPU 0x8000.
;  Triplet 10/11/12 via page_banks_10_11_12. Not code. Continuation of bank
;  10 map_ptr (first in-window stream 0x80B0). l514ch also copies tiles from
;  0x8030 after this triplet is paged.
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank11.tbl.bin"
