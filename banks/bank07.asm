; ===========================================================================
;  bank 07 — tables / packed lists, assembled at CPU 0x6000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. Consumers in bank 0 after
;  paging this triplet (l54a0h packed-list loader; tile src is always
;  0x8000 = bank 8):
;
;    idx6 @ 0x6000 — 6 words, [0] == 0x600C (palette bytes that follow).
;    palettes 0x600C–0x602A.
;    blit list @ 0x602A — 12 × 5-byte records; 0xFF terminator at 0x6066
;      overlaps e241_tbl[0] (ld hl,06065h / sub_4d4ch from (0xE241)).
;    e241_tbl @ 0x6065 — 36 words; [0] = 0xFF69 sentinel; [1..35] in-bank.
;    0x6177 — mixed (color word then pointers); different grammar, do not
;      reuse the 0x602A decoder.
;
;  .blocks map: banks/bank07.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank07.tbl.bin"
