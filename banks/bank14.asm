; ===========================================================================
;  bank 14 — font / tileset, assembled at CPU 0x8000 (PHASE in master).
;  Pair 14/15 via page_banks_14_15 (8000=14, A000=15). Not code.
;  114-word glyph index @ 0x8000, [0] == 0x80E4. Printable runs are glyph
;  bitmaps, not a string table (sub_4e54h / sub_5029h / l5508h after paging).
;  page_bank_15 exists but is never called; 15 is only reached with 14.
;  .blocks map: banks/bank14.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank14.gfx.bin"
