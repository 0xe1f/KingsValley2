; ===========================================================================
;  bank 07 — tables / packed lists, assembled at CPU 0x6000 (PHASE in master).
;  Triplet 7/8/9 via page_banks_789. Not code. Consumers in bank 0 after
;  paging this triplet (blit_list packed-list loader; tile src is always
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
idx6:
	defw 0600ch, 0600eh, 06012h, 06016h, 0601ah, 06022h
pal_list:
	defb 00ch, 00fh, 008h, 00bh, 00ch, 00fh, 007h, 009h
	defb 00ah, 00fh, 000h, 007h, 009h, 00fh, 000h, 007h
	defb 008h, 009h, 00ah, 00bh, 00ch, 00fh, 006h, 008h
	defb 00ch, 00fh, 000h, 000h, 000h, 000h
blit_recs:
	defb 000h, 058h, 006h, 01ch, 062h, 00ah, 05eh, 01ch
	defb 04ch, 062h, 012h, 07ah, 006h, 00ch, 064h, 01ah
	defb 080h, 00bh, 06ch, 064h, 024h, 08bh, 004h, 074h
	defb 069h, 012h, 095h, 003h, 06ch, 065h, 013h, 098h
	defb 003h, 06ch, 065h, 024h, 09bh, 023h, 09ch, 065h
	defb 024h, 0beh, 006h, 0e4h, 068h, 025h, 0c4h, 006h
	defb 0e4h, 068h, 025h, 08fh, 004h, 074h, 069h, 024h
	defb 0cah, 004h, 0d4h
e241_tbl:
	defw 0ff69h, 06073h, 0607fh, 06089h, 06091h, 0609fh, 060a7h, 060adh
	defw 060b5h, 060b9h, 060c1h, 060c5h, 060cdh, 060d5h, 060ddh, 060e1h
	defw 060e9h, 060f1h, 060f9h, 06101h, 06109h, 0610dh, 06115h, 0611dh
	defw 06125h, 06129h, 0612dh, 06135h, 0613dh, 06145h, 0614dh, 06151h
	defw 06159h, 06161h, 06169h, 06171h
	INCBIN "banks/bank07.tbl.bin", 0xAD, 0xCA   ; e241_tbl payload records 0x60AD-0x6177
blit_ptr:
	; blit_world (bank 0): HL = blit_ptr[world] -> blit_list; DE = e241_tbl[world].
	; world = (0xE241) = ceil(level/10), 1..6 (set_world @ 0x5C80).
	; [0] 0x0F0C sentinel (world 0 unused); [1] 0x6185 == table end.
	defw 00f0ch, 06185h, 061a4h, 061beh, 061d3h, 061f7h, 0620ch
	INCBIN "banks/bank07.tbl.bin", 0x185
