; ===========================================================================
;  bank 14 — font / tileset, assembled at CPU 0x8000 (PHASE in master).
;  Pair 14/15 via page_banks_14_15 (8000=14, A000=15). Not code.
;  114-word glyph index @ 0x8000, [0] == 0x80E4. Printable runs are glyph
;  bitmaps, not a string table (sub_4e54h / sub_5029h / l5508h after paging).
;  page_bank_15 exists but is never called; 15 is only reached with 14.
;  .blocks map: banks/bank14.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
glyph_ptr:
	defw 080e4h, 08124h, 08164h, 081a4h, 081e4h, 08224h, 08264h, 08274h
	defw 08284h, 08284h, 08284h, 08284h, 08284h, 08284h, 08284h, 08294h
	defw 08294h, 08294h, 08294h, 08294h, 08294h, 0829ah, 082a0h, 082a0h
	defw 082a0h, 082a0h, 082a0h, 082a8h, 082a8h, 082a8h, 082a8h, 082b8h
	defw 082b8h, 082c0h, 082c0h, 082c0h, 082c0h, 082c6h, 082c6h, 082d6h
	defw 082d6h, 082d6h, 082d6h, 082d6h, 082d6h, 082d6h, 082d6h, 082e6h
	defw 082e6h, 082eeh, 082eeh, 082eeh, 082eeh, 082eeh, 082eeh, 082f5h
	defw 082fch, 08309h, 08313h, 08320h, 0832dh, 08334h, 0833bh, 0833ch
	defw 08349h, 0834ah, 08354h, 08364h, 0836eh, 08384h, 08385h, 083a1h
	defw 083b1h, 083b8h, 083cbh, 083cfh, 083d9h, 083dah, 083f3h, 083f7h
	defw 08401h, 0840bh, 08412h, 08419h, 0841ah, 08427h, 08437h, 08453h
	defw 08463h, 0848eh, 08495h, 084aeh, 084afh, 084b9h, 084cch, 084cdh
	defw 084d1h, 084e4h, 084eeh, 084efh, 084f6h, 084f7h, 084feh, 0850bh
	defw 0850ch, 08516h, 08517h, 08539h, 0853ah, 0854dh, 0854eh, 08567h
	defw 08568h, 0858ah
	INCBIN "banks/bank14.gfx.bin", 0xE4
