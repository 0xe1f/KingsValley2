; per-world blit_list records (bank 07). blit_world: HL = blit_ptr[world].
; 5-byte: flags, tile, count, dest. 0xFF end. Tiles from bank 08 @ 0x8000.

blit_w1:                           ; 0x6185 world 1
	defb 004h, 001h, 002h
	defw pat_6a64
	defb 00ah, 003h, 002h
	defw pat_6a94
	defb 014h, 005h, 013h
	defw pat_6ab4
	defb 01ah, 018h, 024h
	defw pat_6c7c
	defb 024h, 03ch, 017h
	defw pat_6ebc
	defb 02ch, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

blit_w2:                           ; 0x61A4 world 2
	defb 004h, 003h, 015h
	defw pat_70e4
	defb 00ah, 018h, 00ah
	defw pat_72dc
	defb 014h, 022h, 010h
	defw pat_737c
	defb 01ch, 032h, 021h
	defw pat_74fc
	defb 024h, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

blit_w3:                           ; 0x61BE world 3
	defb 004h, 001h, 004h
	defw pat_77fc
	defb 00ch, 005h, 01bh
	defw pat_785c
	defb 012h, 020h, 02eh
	defw pat_7ae4
	defb 01ch, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

blit_w4:                           ; 0x61D3 world 4
	defb 004h, 003h, 002h
	defw pat_7dc4
	defb 00ch, 005h, 013h
	defw pat_7df4
	defb 012h, 018h, 020h
	defw pat_7fbc
	defb 01ah, 038h, 005h
	defw pat_81bc
	defb 024h, 03dh, 00dh
	defw pat_820c
	defb 02ch, 04ah, 002h
	defw pat_8344
	defb 034h, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

blit_w5:                           ; 0x61F7 world 5
	defb 004h, 001h, 017h
	defw pat_8374
	defb 00ah, 018h, 02bh
	defw pat_859c
	defb 014h, 043h, 014h
	defw pat_884c
	defb 01ch, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

blit_w6:                           ; 0x620C world 6
	defb 004h, 003h, 015h
	defw pat_70e4
	defb 00ch, 018h, 03eh
	defw pat_8a2c
	defb 014h, 001h, 002h
	defw pat_6a34
	defb 0ffh               ; end

