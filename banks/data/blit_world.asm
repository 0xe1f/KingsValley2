; per-world blit_list records (bank 07). blit_world: HL = blit_ptr[world].
; 5-byte: flags, tile, count, dest. 0xFF end. Tiles from bank 08 @ 0x8000.

blit_w1:                           ; 0x6185 world 1
	BLIT 004h, 001h, 002h, pat_6a64
	BLIT 00ah, 003h, 002h, pat_6a94
	BLIT 014h, 005h, 013h, pat_6ab4
	BLIT 01ah, 018h, 024h, pat_6c7c
	BLIT 024h, 03ch, 017h, pat_6ebc
	BLIT 02ch, 001h, 002h, pat_6a34
	BLIT_END

blit_w2:                           ; 0x61A4 world 2
	BLIT 004h, 003h, 015h, pat_70e4
	BLIT 00ah, 018h, 00ah, pat_72dc
	BLIT 014h, 022h, 010h, pat_737c
	BLIT 01ch, 032h, 021h, pat_74fc
	BLIT 024h, 001h, 002h, pat_6a34
	BLIT_END

blit_w3:                           ; 0x61BE world 3
	BLIT 004h, 001h, 004h, pat_77fc
	BLIT 00ch, 005h, 01bh, pat_785c
	BLIT 012h, 020h, 02eh, pat_7ae4
	BLIT 01ch, 001h, 002h, pat_6a34
	BLIT_END

blit_w4:                           ; 0x61D3 world 4
	BLIT 004h, 003h, 002h, pat_7dc4
	BLIT 00ch, 005h, 013h, pat_7df4
	BLIT 012h, 018h, 020h, pat_7fbc
	BLIT 01ah, 038h, 005h, pat_81bc
	BLIT 024h, 03dh, 00dh, pat_820c
	BLIT 02ch, 04ah, 002h, pat_8344
	BLIT 034h, 001h, 002h, pat_6a34
	BLIT_END

blit_w5:                           ; 0x61F7 world 5
	BLIT 004h, 001h, 017h, pat_8374
	BLIT 00ah, 018h, 02bh, pat_859c
	BLIT 014h, 043h, 014h, pat_884c
	BLIT 01ch, 001h, 002h, pat_6a34
	BLIT_END

blit_w6:                           ; 0x620C world 6
	BLIT 004h, 003h, 015h, pat_70e4
	BLIT 00ch, 018h, 03eh, pat_8a2c
	BLIT 014h, 001h, 002h, pat_6a34
	BLIT_END

