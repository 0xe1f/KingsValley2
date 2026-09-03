; bank 0E copy_pat / flip_pat lists, pattern payloads, mode_end titles.

pat_copy:                            ; 0x98C9  Flouman / Slouman (copy_pat, n*32 → y*8 + F800)
	defb 004h, 048h
	defw pat_98f7
	defb 006h, 068h
	defw pat_9977
	defb 006h, 080h
	defw pat_9a37
	defb 004h, 0b0h
	defw pat_9af7
	defb 002h, 0c0h
	defw pat_9b77
	defb 004h, 0d0h
	defw pat_9bb7
	defb 004h, 0e0h
	defw pat_9c37
	defb 004h, 0f0h
	defw pat_9cb7
	defb 000h

pat_flip:                            ; 0x98EA  flip_pat (mirror n rows in VRAM)
	defb 002h, 004h, 048h, 058h
	defb 002h, 006h, 080h, 098h
	defb 002h, 002h, 0c0h, 0c8h
	defb 000h

pat_98f7:                            ; 0x98F7  n=4 y=72 (128 bytes)
	defb 000h, 01fh, 03fh, 07fh, 07fh, 07dh, 0feh, 0ffh
	defb 079h, 07fh, 0cfh, 0bch, 0dbh, 01fh, 00dh, 00fh
	defb 000h, 080h, 0c0h, 0e0h, 0f0h, 050h, 0f0h, 0d0h
	defb 0b8h, 0b8h, 06ch, 09ch, 076h, 0ffh, 0b7h, 0beh
	defb 000h, 01fh, 024h, 042h, 079h, 066h, 0bfh, 08fh
	defb 047h, 07eh, 0b8h, 073h, 0d7h, 016h, 00eh, 008h
	defb 000h, 080h, 040h, 020h, 090h, 0f0h, 0b0h, 030h
	defb 068h, 068h, 0d4h, 0e4h, 08eh, 019h, 079h, 062h
	defb 01fh, 03fh, 07fh, 07fh, 07dh, 0ffh, 0ffh, 07fh
	defb 060h, 0dfh, 077h, 06bh, 071h, 021h, 000h, 001h
	defb 080h, 0c0h, 0e0h, 0f0h, 050h, 0f0h, 0d0h, 038h
	defb 0f8h, 0ech, 09ch, 07ch, 0f4h, 0f8h, 0e8h, 0f4h
	defb 01fh, 024h, 042h, 079h, 066h, 0bfh, 09eh, 060h
	defb 05fh, 0bfh, 06ch, 05ah, 051h, 021h, 000h, 001h
	defb 080h, 040h, 020h, 090h, 0f0h, 0b0h, 030h, 0e8h
	defb 0c8h, 014h, 064h, 0c4h, 08ch, 018h, 098h, 00ch

pat_9977:                            ; 0x9977  n=6 y=104 (192 bytes)
	defb 003h, 00fh, 018h, 017h, 03fh, 03fh, 05fh, 0b7h
	defb 0efh, 0ffh, 0ffh, 0feh, 0fdh, 03ah, 02eh, 07ah
	defb 0c0h, 0f0h, 008h, 0e8h, 0f4h, 0fch, 0fah, 0cdh
	defb 0b7h, 0ffh, 0ffh, 07fh, 0bfh, 05ch, 074h, 05eh
	defb 003h, 00ch, 017h, 018h, 02fh, 039h, 06fh, 0c8h
	defb 094h, 0b3h, 018h, 031h, 0e3h, 026h, 032h, 046h
	defb 0c0h, 030h, 0f8h, 018h, 0fch, 09ch, 0f6h, 033h
	defb 069h, 0cdh, 018h, 08ch, 0c7h, 064h, 04ch, 062h
	defb 007h, 00bh, 017h, 037h, 077h, 07bh, 05ch, 05bh
	defb 02eh, 02fh, 01fh, 00ch, 00fh, 01fh, 01eh, 03eh
	defb 0e0h, 0d0h, 0e8h, 0e8h, 0e8h, 0deh, 03fh, 0dfh
	defb 07bh, 0feh, 0fch, 01ch, 0fch, 0feh, 01ch, 000h
	defb 007h, 00ch, 018h, 038h, 058h, 054h, 06bh, 06ch
	defb 037h, 030h, 018h, 00bh, 00ch, 011h, 012h, 022h
	defb 0e0h, 030h, 018h, 018h, 018h, 02eh, 0d9h, 03dh
	defb 0e5h, 002h, 01ch, 0e4h, 014h, 0e2h, 01ch, 000h
	defb 007h, 00bh, 017h, 017h, 017h, 07bh, 0fch, 0fbh
	defb 0deh, 07fh, 03fh, 038h, 03fh, 07fh, 038h, 000h
	defb 0e0h, 0d0h, 0e8h, 0ech, 0eeh, 0deh, 03ah, 0dah
	defb 074h, 0f4h, 0f8h, 030h, 0f0h, 0f8h, 078h, 07ch
	defb 007h, 00ch, 018h, 018h, 018h, 074h, 09bh, 0bch
	defb 0a7h, 040h, 038h, 027h, 028h, 047h, 038h, 000h
	defb 0e0h, 030h, 018h, 01ch, 01ah, 02ah, 0d6h, 036h
	defb 0ech, 00ch, 018h, 0d0h, 030h, 088h, 048h, 044h

pat_9a37:                            ; 0x9A37  n=6 y=128 (192 bytes)
	defb 000h, 00eh, 01fh, 03fh, 017h, 005h, 03dh, 06dh
	defb 02bh, 036h, 054h, 0fah, 0cah, 07dh, 037h, 01ah
	defb 000h, 000h, 060h, 0feh, 0ffh, 0fdh, 0fdh, 0fdh
	defb 0fdh, 0d5h, 0d5h, 055h, 057h, 05eh, 0f8h, 020h
	defb 000h, 00eh, 011h, 029h, 015h, 006h, 03eh, 05eh
	defb 03eh, 02fh, 05fh, 0b7h, 0bfh, 04bh, 02dh, 01ah
	defb 000h, 000h, 060h, 09eh, 025h, 0b7h, 097h, 047h
	defb 07fh, 07fh, 07fh, 0ffh, 0fdh, 0f6h, 0d8h, 020h
	defb 00fh, 018h, 01fh, 01fh, 01fh, 03fh, 03fh, 01fh
	defb 03fh, 078h, 07fh, 076h, 03bh, 013h, 007h, 003h
	defb 0f8h, 00ch, 0fch, 086h, 0feh, 083h, 0feh, 0e2h
	defb 082h, 0c4h, 0fch, 0aah, 0fch, 048h, 0e8h, 0f0h
	defb 00fh, 017h, 01fh, 010h, 016h, 02ch, 021h, 016h
	defb 038h, 047h, 04fh, 055h, 02bh, 013h, 004h, 003h
	defb 0f8h, 0f4h, 0fch, 0fah, 0feh, 0fdh, 0feh, 01eh
	defb 07eh, 0fch, 0fch, 056h, 0fch, 0b8h, 018h, 0f0h
	defb 01fh, 030h, 03fh, 03fh, 07fh, 0ffh, 0ffh, 0e3h
	defb 07ch, 02bh, 004h, 003h, 002h, 003h, 001h, 000h
	defb 0f0h, 018h, 0f8h, 00ch, 0fch, 086h, 0fch, 0e4h
	defb 006h, 01bh, 066h, 09dh, 077h, 0d6h, 03ch, 018h
	defb 01fh, 02fh, 03fh, 021h, 06dh, 09fh, 081h, 0bch
	defb 05fh, 02fh, 007h, 003h, 003h, 002h, 001h, 000h
	defb 0f0h, 0e8h, 0f8h, 0f4h, 0fch, 0fah, 0fch, 01ch
	defb 0feh, 0fdh, 0fah, 0efh, 0b9h, 0dah, 024h, 018h

pat_9af7:                            ; 0x9AF7  n=4 y=176 (128 bytes)
	defb 00fh, 017h, 0e8h, 0e7h, 0d0h, 0efh, 0f0h, 0efh
	defb 05fh, 03fh, 03fh, 07fh, 07dh, 05dh, 02bh, 01fh
	defb 0e0h, 0d0h, 028h, 0c8h, 014h, 0eeh, 01fh, 0ffh
	defb 0fbh, 0feh, 0fch, 0dch, 0dch, 0b4h, 0e8h, 0f0h
	defb 00fh, 018h, 0ffh, 03fh, 07fh, 07fh, 0bfh, 09fh
	defb 078h, 027h, 02fh, 05bh, 053h, 073h, 03fh, 01fh
	defb 0e0h, 030h, 0f8h, 0f8h, 0fch, 0feh, 0f9h, 0edh
	defb 035h, 0cah, 0ach, 034h, 034h, 0fch, 0f8h, 0f0h
	defb 007h, 00bh, 014h, 013h, 028h, 077h, 0f8h, 0ffh
	defb 0dfh, 07fh, 03fh, 03bh, 03bh, 02dh, 017h, 00fh
	defb 0f0h, 0e8h, 017h, 0e7h, 00bh, 0f7h, 00fh, 0f7h
	defb 0fah, 0fch, 0fch, 0feh, 0beh, 0bah, 0d4h, 0f8h
	defb 007h, 00ch, 01fh, 01fh, 03fh, 07fh, 09fh, 0b7h
	defb 0ach, 053h, 035h, 02ch, 02ch, 03fh, 01fh, 00fh
	defb 0f0h, 018h, 0ffh, 0fch, 0feh, 0feh, 0fdh, 0f9h
	defb 01eh, 0e4h, 0f4h, 0dah, 0cah, 0ceh, 0fch, 0f8h

pat_9b77:                            ; 0x9B77  n=2 y=192 (64 bytes)
	defb 037h, 058h, 0b7h, 0fdh, 0a7h, 0b6h, 0bdh, 0f5h
	defb 067h, 01fh, 014h, 022h, 057h, 04eh, 03ch, 046h
	defb 0c0h, 060h, 078h, 0f4h, 072h, 0f1h, 0fah, 0deh
	defb 096h, 05ah, 039h, 04eh, 0eah, 072h, 03eh, 021h
	defb 037h, 06fh, 0dah, 0b7h, 07fh, 05bh, 05eh, 0beh
	defb 07ah, 01fh, 01bh, 03fh, 069h, 07ah, 034h, 07ah
	defb 0c0h, 0a0h, 0d8h, 09ch, 0deh, 02fh, 027h, 07dh
	defb 0f5h, 0bfh, 0efh, 0feh, 096h, 05eh, 02ah, 03fh

pat_9bb7:                            ; 0x9BB7  n=4 y=208 (128 bytes)
	defb 00fh, 010h, 020h, 070h, 098h, 08fh, 0c7h, 08fh
	defb 0dfh, 0afh, 0dfh, 07fh, 03fh, 01fh, 00fh, 007h
	defb 0e0h, 090h, 048h, 034h, 01eh, 0ffh, 0ffh, 07fh
	defb 0dfh, 0ffh, 0ffh, 0ffh, 0feh, 0fch, 0f8h, 0f0h
	defb 00fh, 01fh, 03fh, 05fh, 0efh, 0f6h, 0b8h, 0f8h
	defb 0a8h, 0deh, 0bfh, 06dh, 036h, 01bh, 00ch, 007h
	defb 0e0h, 0f0h, 0f8h, 0cch, 0f2h, 089h, 01fh, 08dh
	defb 02fh, 00fh, 0f5h, 05bh, 0beh, 074h, 0d8h, 0f0h
	defb 007h, 00ch, 014h, 026h, 04bh, 095h, 0bbh, 0e3h
	defb 0d7h, 0e6h, 0ffh, 0ffh, 07fh, 03fh, 01fh, 00fh
	defb 0f0h, 008h, 004h, 00eh, 01bh, 0e1h, 0e7h, 0efh
	defb 0bfh, 0ffh, 0ffh, 0feh, 0fch, 0f8h, 0f0h, 0e0h
	defb 007h, 00bh, 01bh, 039h, 07dh, 0fah, 0e4h, 0dch
	defb 0ach, 0f9h, 09ch, 0a7h, 05bh, 037h, 01fh, 00fh
	defb 0f0h, 0f8h, 0fch, 0fah, 0f5h, 09fh, 019h, 011h
	defb 053h, 035h, 03bh, 036h, 0ech, 0f8h, 0f0h, 0e0h

pat_9c37:                            ; 0x9C37  n=4 y=224 (128 bytes)
	defb 000h, 000h, 000h, 000h, 000h, 003h, 00ah, 01fh
	defb 01fh, 00fh, 00fh, 01fh, 01fh, 00bh, 001h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 080h, 070h, 0b8h
	defb 0b8h, 0b0h, 060h, 0f0h, 0f0h, 0a0h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 003h, 00ch, 015h, 020h
	defb 020h, 010h, 010h, 020h, 020h, 014h, 00ah, 001h
	defb 000h, 000h, 000h, 000h, 080h, 070h, 088h, 044h
	defb 044h, 048h, 090h, 008h, 008h, 050h, 0a0h, 000h
	defb 000h, 003h, 037h, 079h, 077h, 07fh, 03fh, 03fh
	defb 07fh, 06fh, 06fh, 033h, 00fh, 007h, 001h, 000h
	defb 000h, 08ch, 0deh, 0feh, 01ch, 0e8h, 0ech, 0eeh
	defb 0deh, 0f4h, 0f8h, 0f8h, 0f8h, 0b0h, 000h, 000h
	defb 003h, 034h, 048h, 086h, 088h, 080h, 040h, 040h
	defb 080h, 090h, 090h, 04ch, 030h, 008h, 006h, 001h
	defb 08ch, 052h, 021h, 001h, 0e2h, 014h, 012h, 011h
	defb 021h, 00ah, 004h, 004h, 004h, 048h, 0f0h, 000h

pat_9cb7:                            ; 0x9CB7  n=4 y=240 (128 bytes)
	defb 000h, 000h, 000h, 001h, 011h, 00dh, 00ah, 004h
	defb 038h, 004h, 00ah, 00dh, 011h, 001h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 010h, 060h, 0a0h, 040h
	defb 038h, 040h, 0a0h, 060h, 010h, 000h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 005h, 003h
	defb 007h, 003h, 005h, 000h, 000h, 000h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 040h, 080h
	defb 0c0h, 080h, 040h, 000h, 000h, 000h, 000h, 000h
	defb 001h, 001h, 041h, 033h, 02ch, 010h, 010h, 020h
	defb 0e0h, 020h, 010h, 010h, 02ch, 033h, 041h, 001h
	defb 000h, 000h, 004h, 098h, 068h, 010h, 010h, 008h
	defb 00eh, 008h, 010h, 010h, 078h, 098h, 00ch, 000h
	defb 000h, 000h, 000h, 000h, 013h, 00fh, 00fh, 01fh
	defb 01fh, 01fh, 00fh, 00fh, 013h, 000h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 090h, 0e0h, 0e0h, 0f0h
	defb 0f0h, 0f0h, 0e0h, 0e0h, 080h, 000h, 000h, 000h

end_txt:                             ; 0x9D37  mode_end; EF10 1=music 2=puzzle
	defw str_music, str_puzzle
str_music:                           ; 0x9D3B
	defb 050h, 050h         ; D,E
	TEXT "music stage"
	defb 0ffh               ; end
str_puzzle:                          ; 0x9D49
	defb 048h, 050h         ; D,E
	TEXT "puzzle stage"
	defb 0ffh               ; end

