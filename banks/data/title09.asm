; bank 09 title stamp (stamp) at 0xBB9B; copy_tiles 1bpp in title_tiles.asm.

stamp_bb9b:                            ; 0xBB9B  Konami logo (stamp_logo_konami / title_load)
	defb 001h
	defb 002h
	defb 003h
	defb 0feh, 0f8h         ; next row
	defb 004h
	defb 005h
	defb 006h
	defb 007h
	defb 0feh, 0f0h         ; next row
	defb 008h
	defb 009h
	defb 00ah
	defb 00bh
	defb 00eh
	defb 00fh
	defb 010h
	defb 011h
	defb 01bh
	defb 01ch
	defb 01dh
	defb 01eh
	defb 01fh
	defb 020h
	defb 021h
	defb 022h
	defb 023h
	defb 024h
	defb 025h
	defb 026h
	defb 0feh, 000h         ; next row
	defb 00ch
	defb 002h
	defb 00dh
	defb 012h
	defb 013h
	defb 014h
	defb 015h
	defb 027h
	defb 028h
	defb 029h
	defb 02ah
	defb 02bh
	defb 02ch
	defb 02dh
	defb 02eh
	defb 02fh
	defb 030h
	defb 031h
	defb 032h
	defb 033h
	defb 034h
	defb 0feh, 010h         ; next row
	defb 016h
	defb 019h
	defb 017h
	defb 0feh, 0f8h         ; next row
	defb 018h
	defb 019h
	defb 01ah
	defb 0ffh               ; end
