; ===========================================================================
;  banks e-f — font + UI gfx via page_banks_ef, CPU 0x8000–0xBFFF (one PHASE).
;  glyph_ptr / held / RLE / draw_cols; UI maps / pal_15 / dests.
;  page_bank_f exists but is never called; f is only reached with e.
;  Regen one 8K bank at a time:
;    tools/workbench/msx/regen-bank.sh 14 0x8000 banks/banks_ef.blocks
;    tools/workbench/msx/regen-bank.sh 15 0xA000 banks/banks_ef.blocks
; ===========================================================================

glyph_ptr:
	defw glyphs, gly_8124, gly_8164, gly_81a4, gly_81e4, gly_8224, gly_8264, gly_8274
	defw gly_8284, gly_8284, gly_8284, gly_8284, gly_8284, gly_8284, gly_8284, gly_8294
	defw gly_8294, gly_8294, gly_8294, gly_8294, gly_8294, gly_829a, gly_82a0, gly_82a0
	defw gly_82a0, gly_82a0, gly_82a0, gly_82a8, gly_82a8, gly_82a8, gly_82a8, gly_82b8
	defw gly_82b8, gly_82c0, gly_82c0, gly_82c0, gly_82c0, gly_82c6, gly_82c6, gly_82d6
	defw gly_82d6, gly_82d6, gly_82d6, gly_82d6, gly_82d6, gly_82d6, gly_82d6, gly_82e6
	defw gly_82e6, gly_82ee, gly_82ee, gly_82ee, gly_82ee, gly_82ee, gly_82ee, gly_82f5
	defw gly_82fc, gly_8309, gly_8313, gly_8320, gly_832d, gly_8334, gly_833b, gly_833c
	defw gly_8349, gly_834a, gly_8354, gly_8364, gly_836e, gly_8384, gly_8385, gly_83a1
	defw gly_83b1, gly_83b8, gly_83cb, gly_83cf, gly_83d9, gly_83da, gly_83f3, gly_83f7
	defw gly_8401, gly_840b, gly_8412, gly_8419, gly_841a, gly_8427, gly_8437, gly_8453
	defw gly_8463, gly_848e, gly_8495, gly_84ae, gly_84af, gly_84b9, gly_84cc, gly_84cd
	defw gly_84d1, gly_84e4, gly_84ee, gly_84ef, gly_84f6, gly_84f7, gly_84fe, gly_850b
	defw gly_850c, gly_8516, gly_8517, gly_8539, gly_853a, gly_854d, gly_854e, gly_8567
	defw gly_8568, gly_858a
	INCLUDE "banks/data/glyphs0E.asm"
gly_858a:
	defb 0ffh                     ; 0x858A  last glyph_ptr (empty)
	INCLUDE "banks/data/held.asm"
	INCLUDE "banks/data/rle0E.asm"
	INCLUDE "banks/data/lists0E.asm"
	INCLUDE "banks/data/cols0E.asm"
; --- bank 0F @ 0xA000 ---
	INCLUDE "banks/data/cols0F.asm"
	INCLUDE "banks/data/ui_maps.asm"
	INCLUDE "banks/data/sat_fx.asm"
pal_a7ce:
	defb 000h, 000h, 000h, 001h, 030h, 002h, 002h, 041h
	defb 003h, 003h, 051h, 004h, 004h, 065h, 007h, 005h
	defb 000h, 000h, 006h, 000h, 000h, 007h, 070h, 000h
	defb 008h, 041h, 003h, 009h, 051h, 004h, 00ah, 060h
	defb 000h, 00bh, 077h, 007h, 00ch, 050h, 000h, 00dh
	defb 070h, 007h, 00eh, 050h, 004h, 00fh, 000h, 000h
	defb 0ffh
pal_a7ff:
	defb 000h, 000h, 000h, 001h, 033h, 003h, 002h, 044h
	defb 004h, 003h, 055h, 005h, 004h, 066h, 006h, 005h
	defb 000h, 000h, 006h, 000h, 000h, 007h, 070h, 000h
	defb 008h, 030h, 002h, 009h, 050h, 005h, 00ah, 030h
	defb 000h, 00bh, 077h, 007h, 00ch, 000h, 003h, 00dh
	defb 017h, 001h, 00eh, 075h, 006h, 00fh, 000h, 000h
	defb 0ffh
	INCLUDE "banks/data/sat_pals1.asm"
pal_a8bb:
	defb 000h, 000h, 000h, 001h, 040h, 002h, 002h, 041h
	defb 003h, 003h, 051h, 004h, 004h, 075h, 007h, 005h
	defb 030h, 003h, 006h, 000h, 003h, 007h, 070h, 000h
	defb 008h, 055h, 005h, 009h, 070h, 004h, 00ah, 070h
	defb 000h, 00bh, 077h, 007h, 00ch, 050h, 000h, 00fh
	defb 000h, 000h, 0ffh
	INCLUDE "banks/data/sat_pals2.asm"
	INCLUDE "banks/data/rle0F.asm"
idx2:                               ; 0xB116  blit_list DE; [0] == pal_list
	defw pal_list
pal_list:
	defb 007h, 008h, 00ah, 00bh, 00ch, 00fh, 000h, 000h
blit_recs:                          ; 0xB120  Japanese title dests (title_jp_gfx)
	BLIT 004h, 001h, 040h, pat_b12b
	BLIT 004h, 041h, 012h, pat_b72b
	BLIT_END
	INCLUDE "banks/data/dest0F.asm"
	INCLUDE "banks/data/ui_tail.asm"
	ds 565, 0ffh
