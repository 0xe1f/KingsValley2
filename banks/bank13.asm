; ===========================================================================
;  bank 13 — tables / text streams / tiles, CPU 0xA000 (PHASE in master).
;  A000-only via page_bank_13 (6000/8000 keep the previous triplet). Not code.
;  Consumers after paging: 04d4ch tables at 0xA75D / 0xAAE0 / 0xADCF.. /
;  0xAFB1 / 0xBA57 / 0xBB38 / 0xB9AD / 0xBCBB; 8-byte flags @ 0xAB5A;
;  l51d0h streams (e.g. 0xBC54); l514ch tiles @ 0xBF36 / 0xBFC6.
;  Trailing 0xFF pad from 0xBFF6.
;  .blocks map: banks/bank13.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank13.tbl.bin"
	ds 10, 0ffh
