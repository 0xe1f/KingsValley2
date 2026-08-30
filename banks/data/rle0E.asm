; bank 0E Konami RLE (sub_4e54h) 0x86D4–0x98C9.
; Packed chain: each stream’s 00 terminator is the next label.
; copy_ab59 / copy_pwd / l5928h / col_15 plus held_* VIC_RLE srcs.

rle_86d4:                            ; 0x86D4  copy_ab59 / copy_pwd → F880 / FC80
	defb 008h, 000h, 088h, 004h, 00bh, 004h, 003h, 005h
	defb 005h, 009h, 008h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 004h, 00fh, 007h, 003h, 007h, 007h, 00fh
	defb 00fh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 007h, 000h, 089h, 004h
	defb 00bh, 004h, 003h, 005h, 005h, 009h, 008h, 004h
	defb 007h, 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh
	defb 03eh, 02fh, 00eh, 038h, 007h, 000h, 089h, 004h
	defb 00fh, 007h, 003h, 007h, 007h, 00fh, 00fh, 007h
	defb 007h, 000h, 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h
	defb 0f2h, 0fdh, 0feh, 0f8h, 008h, 000h, 088h, 004h
	defb 00bh, 004h, 003h, 005h, 005h, 009h, 008h, 008h
	defb 000h, 088h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh
	defb 02fh, 00eh, 008h, 000h, 088h, 004h, 00fh, 007h
	defb 003h, 007h, 007h, 00fh, 00fh, 008h, 000h, 088h
	defb 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh
	defb 000h

rle_875d:                            ; 0x875D  held_0 → E000
	defb 007h, 000h, 089h, 001h, 006h, 00bh, 017h, 037h
	defb 05fh, 07fh, 07fh, 03fh, 007h, 000h, 089h, 080h
	defb 0e0h, 0f0h, 0f8h, 0fch, 0feh, 0feh, 0fch, 0fah
	defb 007h, 000h, 089h, 001h, 007h, 00dh, 018h, 038h
	defb 070h, 048h, 060h, 038h, 007h, 000h, 089h, 080h
	defb 060h, 090h, 008h, 00ch, 00ah, 012h, 064h, 01eh
	defb 006h, 000h, 08ah, 001h, 006h, 00bh, 017h, 037h
	defb 05fh, 07fh, 03fh, 03fh, 04fh, 006h, 000h, 08ah
	defb 080h, 0e0h, 0f0h, 0f8h, 0fch, 0feh, 0feh, 0fch
	defb 0feh, 0fch, 006h, 000h, 08ah, 001h, 007h, 00dh
	defb 018h, 038h, 070h, 048h, 020h, 038h, 07fh, 006h
	defb 000h, 08ah, 080h, 060h, 090h, 008h, 00ch, 00ah
	defb 012h, 064h, 01ah, 0f4h, 008h, 000h, 088h, 009h
	defb 017h, 009h, 006h, 00bh, 00ah, 012h, 070h, 008h
	defb 000h, 088h, 0f0h, 068h, 0f8h, 07ch, 0fch, 07ch
	defb 05eh, 01ch, 008h, 000h, 088h, 009h, 01eh, 00fh
	defb 007h, 00fh, 00fh, 01fh, 07fh, 008h, 000h, 088h
	defb 0f0h, 0b8h, 008h, 084h, 084h, 0e4h, 0fah, 0fch
	defb 000h

rle_87ee:                            ; 0x87EE  held_1 → E000
	defb 008h, 000h, 088h, 034h, 05bh, 05ch, 05bh, 05dh
	defb 05dh, 079h, 0f8h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 034h, 06fh, 06fh, 06bh, 06fh, 06fh, 04fh
	defb 0ffh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 007h, 000h, 089h, 034h
	defb 05bh, 05ch, 05bh, 05dh, 05dh, 079h, 0f8h, 04ch
	defb 007h, 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh
	defb 03eh, 02fh, 00eh, 038h, 007h, 000h, 089h, 034h
	defb 06fh, 06fh, 06bh, 06fh, 06fh, 04fh, 0ffh, 07fh
	defb 007h, 000h, 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h
	defb 0f2h, 0fdh, 0feh, 0f8h, 008h, 000h, 088h, 01ch
	defb 02bh, 02ch, 02fh, 02dh, 02dh, 039h, 078h, 008h
	defb 000h, 088h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh
	defb 02fh, 00eh, 008h, 000h, 082h, 01ch, 03fh, 004h
	defb 037h, 082h, 02fh, 07fh, 008h, 000h, 088h, 0f8h
	defb 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 000h

rle_8876:                            ; 0x8876  held_1 → E000
	defb 006h, 000h, 086h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 003h, 0ffh, 081h, 07fh, 005h, 000h, 085h
	defb 00ch, 016h, 0d6h, 0f6h, 0f6h, 003h, 0feh, 083h
	defb 0ffh, 0f2h, 0feh, 006h, 000h, 08ah, 003h, 00eh
	defb 01bh, 030h, 070h, 0e0h, 090h, 0c0h, 0b0h, 05fh
	defb 005h, 000h, 08bh, 00ch, 01ah, 0dah, 03ah, 01ah
	defb 01ah, 016h, 026h, 0cfh, 03eh, 0eah, 007h, 000h
	defb 089h, 003h, 00dh, 017h, 02fh, 06fh, 0bfh, 0ffh
	defb 07fh, 0bfh, 007h, 000h, 083h, 018h, 0ech, 0ech
	defb 005h, 0fch, 081h, 0feh, 007h, 000h, 089h, 003h
	defb 00eh, 01bh, 030h, 070h, 0e0h, 090h, 040h, 0f0h
	defb 007h, 000h, 089h, 018h, 0f4h, 034h, 014h, 01ch
	defb 014h, 024h, 0cch, 03eh, 003h, 000h, 081h, 018h
	defb 004h, 02ch, 088h, 02bh, 02ch, 07fh, 03dh, 03dh
	defb 029h, 028h, 01ch, 007h, 000h, 089h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 038h, 003h
	defb 000h, 081h, 018h, 004h, 034h, 084h, 03fh, 037h
	defb 07fh, 02fh, 003h, 03fh, 081h, 017h, 007h, 000h
	defb 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh
	defb 0feh, 0f8h, 000h

rle_8911:                            ; 0x8911  held_2 → E000
	defb 007h, 000h, 089h, 010h, 02ch, 02bh, 05ch, 053h
	defb 0b5h, 0b5h, 0f9h, 078h, 008h, 000h, 088h, 0f8h
	defb 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 007h
	defb 000h, 089h, 010h, 03ch, 03fh, 06fh, 073h, 0d7h
	defb 0d7h, 09fh, 07fh, 008h, 000h, 088h, 0f8h, 05ch
	defb 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 006h, 000h
	defb 08ah, 010h, 02ch, 02bh, 05ch, 053h, 0b5h, 0b5h
	defb 0f9h, 078h, 04ch, 007h, 000h, 089h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 038h, 006h
	defb 000h, 08ah, 010h, 03ch, 03fh, 06fh, 073h, 0d7h
	defb 0d7h, 09fh, 07fh, 07fh, 007h, 000h, 089h, 0f8h
	defb 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 0f8h
	defb 007h, 000h, 089h, 008h, 014h, 01bh, 02ch, 02bh
	defb 05dh, 05dh, 079h, 038h, 008h, 000h, 088h, 0f8h
	defb 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 007h
	defb 000h, 089h, 008h, 01ch, 01fh, 037h, 03bh, 06fh
	defb 06fh, 04fh, 03fh, 008h, 000h, 088h, 0f8h, 05ch
	defb 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 000h

rle_89a0:                            ; 0x89A0  held_2 → E000
	defb 006h, 000h, 086h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 003h, 0ffh, 081h, 07fh, 004h, 000h, 08ch
	defb 008h, 014h, 014h, 0dah, 0eah, 0fdh, 0fdh, 0ffh
	defb 0ffh, 0feh, 0f2h, 0feh, 006h, 000h, 08ah, 003h
	defb 00eh, 01bh, 030h, 070h, 0e0h, 090h, 0c0h, 0b0h
	defb 05fh, 004h, 000h, 08ch, 008h, 01ch, 01ch, 0d6h
	defb 02eh, 01bh, 01fh, 015h, 027h, 0ceh, 03eh, 0eah
	defb 007h, 000h, 089h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 0ffh, 07fh, 0bfh, 007h, 000h, 089h, 008h
	defb 0d4h, 0f4h, 0fah, 0fah, 0fdh, 0fdh, 0ffh, 0feh
	defb 007h, 000h, 089h, 003h, 00eh, 01bh, 030h, 070h
	defb 0e0h, 090h, 040h, 0f0h, 007h, 000h, 089h, 008h
	defb 0dch, 03ch, 016h, 01eh, 017h, 027h, 0cdh, 03ah
	defb 004h, 000h, 08ch, 008h, 014h, 014h, 02ch, 02bh
	defb 05ch, 05bh, 07dh, 03dh, 029h, 028h, 01ch, 007h
	defb 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh
	defb 02fh, 00eh, 038h, 004h, 000h, 088h, 008h, 01ch
	defb 01ch, 034h, 03fh, 06fh, 06bh, 04fh, 003h, 03fh
	defb 081h, 017h, 007h, 000h, 089h, 0f8h, 05ch, 084h
	defb 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 0f8h, 000h

rle_8a3f:                            ; 0x8A3F  held_3 → E000
	defb 004h, 000h, 08ch, 001h, 002h, 006h, 003h, 007h
	defb 00bh, 00ch, 00fh, 01dh, 07dh, 0f9h, 0f8h, 003h
	defb 000h, 081h, 0c0h, 003h, 020h, 089h, 0c0h, 0f8h
	defb 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 004h
	defb 000h, 08ch, 001h, 003h, 005h, 002h, 005h, 00fh
	defb 00fh, 00bh, 017h, 067h, 09fh, 0bfh, 003h, 000h
	defb 081h, 0c0h, 003h, 0e0h, 089h, 040h, 0f8h, 05ch
	defb 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 003h, 000h
	defb 090h, 001h, 002h, 006h, 003h, 007h, 00bh, 00ch
	defb 00fh, 01dh, 07dh, 0f9h, 0f8h, 04ch, 000h, 000h
	defb 0c0h, 003h, 020h, 08ah, 0c0h, 0f8h, 0b4h, 0fch
	defb 03eh, 0feh, 03eh, 02fh, 00eh, 038h, 003h, 000h
	defb 090h, 001h, 003h, 005h, 002h, 005h, 00fh, 00fh
	defb 00bh, 017h, 067h, 09fh, 0bfh, 07fh, 000h, 000h
	defb 0c0h, 003h, 0e0h, 08ah, 040h, 0f8h, 05ch, 084h
	defb 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 0f8h, 005h, 000h
	defb 08bh, 001h, 003h, 001h, 007h, 00bh, 004h, 007h
	defb 00dh, 03dh, 079h, 078h, 003h, 000h, 08dh, 060h
	defb 090h, 010h, 010h, 0e0h, 0f8h, 0b4h, 0fch, 03eh
	defb 0feh, 03eh, 02fh, 00eh, 005h, 000h, 08bh, 001h
	defb 002h, 001h, 006h, 00fh, 007h, 007h, 00fh, 037h
	defb 04fh, 05fh, 003h, 000h, 081h, 060h, 003h, 0f0h
	defb 089h, 020h, 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h
	defb 0fdh, 0feh, 000h

rle_8afa:                            ; 0x8AFA  held_3 → E000
	defb 006h, 000h, 086h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 003h, 0ffh, 085h, 07fh, 000h, 000h, 008h
	defb 014h, 003h, 022h, 083h, 0feh, 0fch, 0f4h, 004h
	defb 0fch, 082h, 0f2h, 0feh, 006h, 000h, 08eh, 003h
	defb 00eh, 01bh, 030h, 070h, 0e0h, 090h, 0c0h, 0b0h
	defb 05fh, 000h, 000h, 008h, 01ch, 003h, 03eh, 089h
	defb 0eah, 034h, 01ch, 01ch, 014h, 024h, 0cch, 03eh
	defb 0eah, 007h, 000h, 089h, 003h, 00dh, 017h, 02fh
	defb 06fh, 0bfh, 0ffh, 07fh, 0bfh, 004h, 000h, 08ch
	defb 010h, 028h, 044h, 044h, 0c4h, 0fch, 0f8h, 0f8h
	defb 0fch, 0fch, 0f8h, 0f8h, 007h, 000h, 089h, 003h
	defb 00eh, 01bh, 030h, 070h, 0e0h, 090h, 040h, 0f0h
	defb 004h, 000h, 08ch, 010h, 038h, 07ch, 07ch, 0fch
	defb 034h, 018h, 018h, 014h, 024h, 0c8h, 038h, 008h
	defb 000h, 088h, 004h, 00bh, 004h, 003h, 005h, 005h
	defb 009h, 008h, 008h, 000h, 088h, 0f8h, 0b4h, 0fch
	defb 03eh, 0feh, 03eh, 02fh, 01eh, 008h, 000h, 088h
	defb 004h, 00fh, 007h, 003h, 007h, 007h, 00fh, 00fh
	defb 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h, 0c2h
	defb 0f2h, 0fdh, 0f6h, 007h, 000h, 089h, 004h, 00bh
	defb 004h, 003h, 075h, 09dh, 08dh, 08ch, 056h, 007h
	defb 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh
	defb 02fh, 00eh, 038h, 007h, 000h, 089h, 004h, 00fh
	defb 007h, 003h, 077h, 0efh, 0f7h, 0ffh, 07bh, 007h
	defb 000h, 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h
	defb 0fdh, 0feh, 0f8h, 000h

rle_8bc6:                            ; 0x8BC6  held_5 → E000
	defb 008h, 000h, 088h, 004h, 07bh, 084h, 083h, 0bdh
	defb 07dh, 029h, 038h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 004h, 07fh, 0ffh, 0ffh, 0c7h, 06fh, 03fh
	defb 03fh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 007h, 000h, 089h, 004h
	defb 07bh, 084h, 083h, 0bdh, 07dh, 029h, 038h, 04ch
	defb 007h, 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh
	defb 03eh, 02fh, 00eh, 038h, 007h, 000h, 089h, 004h
	defb 07fh, 0ffh, 0ffh, 0c7h, 06fh, 03fh, 03fh, 07fh
	defb 007h, 000h, 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h
	defb 0f2h, 0fdh, 0feh, 0f8h, 008h, 000h, 088h, 004h
	defb 03bh, 044h, 043h, 05dh, 03dh, 019h, 018h, 008h
	defb 000h, 088h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh
	defb 02fh, 00eh, 008h, 000h, 088h, 004h, 03fh, 07fh
	defb 07fh, 067h, 037h, 01fh, 01fh, 008h, 000h, 088h
	defb 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh
	defb 000h

rle_8c4f:                            ; 0x8C4F  held_5 → E000
	defb 006h, 000h, 086h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 003h, 0ffh, 081h, 07fh, 007h, 000h, 089h
	defb 0feh, 0c1h, 0c1h, 0dfh, 0feh, 0fch, 0fah, 0f2h
	defb 0feh, 006h, 000h, 08ah, 003h, 00eh, 01bh, 030h
	defb 070h, 0e0h, 090h, 0c0h, 0b0h, 05fh, 007h, 000h
	defb 089h, 0feh, 07fh, 07fh, 061h, 036h, 034h, 0ceh
	defb 03eh, 0eah, 007h, 000h, 089h, 003h, 00dh, 017h
	defb 02fh, 06fh, 0bfh, 0ffh, 07fh, 0bfh, 008h, 000h
	defb 088h, 0c0h, 0fch, 082h, 082h, 0beh, 0fch, 0f8h
	defb 0f4h, 007h, 000h, 089h, 003h, 00eh, 01bh, 030h
	defb 070h, 0e0h, 090h, 040h, 0f0h, 008h, 000h, 088h
	defb 0c0h, 07ch, 0feh, 0feh, 0c2h, 06ch, 0e8h, 03ch
	defb 008h, 000h, 088h, 013h, 02eh, 013h, 00ch, 017h
	defb 054h, 0a4h, 0a0h, 008h, 000h, 088h, 0e0h, 0d0h
	defb 0f8h, 0f4h, 0e2h, 0f9h, 0fch, 04fh, 008h, 000h
	defb 088h, 013h, 03dh, 01eh, 00fh, 01fh, 05fh, 0ffh
	defb 0ffh, 008h, 000h, 088h, 0e0h, 070h, 018h, 01ch
	defb 03eh, 0f7h, 0f3h, 0fdh, 008h, 000h, 088h, 07fh
	defb 082h, 083h, 0beh, 07fh, 07ch, 0bch, 0c6h, 008h
	defb 000h, 083h, 0e0h, 0d0h, 0f0h, 003h, 0f8h, 082h
	defb 0bch, 038h, 008h, 000h, 088h, 07fh, 0ffh, 0feh
	defb 0c3h, 06fh, 06fh, 0ffh, 0ffh, 008h, 000h, 088h
	defb 0e0h, 070h, 010h, 008h, 008h, 0c8h, 0f4h, 0f8h
	defb 000h

rle_8d08:                            ; 0x8D08  held_4 → E000
	defb 004h, 000h, 08ch, 003h, 004h, 003h, 000h, 009h
	defb 017h, 009h, 006h, 00bh, 00ah, 012h, 030h, 004h
	defb 000h, 08ch, 0c8h, 03ch, 0c8h, 0f4h, 0f4h, 06ah
	defb 0fah, 07ch, 0fch, 07ch, 05eh, 01ch, 004h, 000h
	defb 08ch, 003h, 007h, 003h, 000h, 009h, 01eh, 00fh
	defb 007h, 00fh, 00fh, 01fh, 03fh, 004h, 000h, 08ch
	defb 0c8h, 0f4h, 038h, 0cch, 0fch, 0beh, 00eh, 084h
	defb 084h, 0e4h, 0fah, 0fch, 003h, 000h, 08dh, 003h
	defb 004h, 003h, 000h, 009h, 017h, 009h, 006h, 00bh
	defb 00ah, 012h, 030h, 058h, 003h, 000h, 08dh, 0c8h
	defb 03ch, 0c8h, 0f4h, 0f4h, 06ah, 0fah, 07ch, 0fch
	defb 07ch, 05eh, 01ch, 070h, 003h, 000h, 08dh, 003h
	defb 007h, 003h, 000h, 009h, 01eh, 00fh, 007h, 00fh
	defb 00fh, 01fh, 03fh, 07fh, 003h, 000h, 08dh, 0c8h
	defb 0f4h, 038h, 0cch, 0fch, 0beh, 00eh, 084h, 084h
	defb 0e4h, 0fah, 0fch, 0f0h, 004h, 000h, 08ch, 001h
	defb 002h, 001h, 000h, 009h, 017h, 009h, 006h, 00bh
	defb 00ah, 012h, 010h, 004h, 000h, 08ch, 0e4h, 01eh
	defb 0e4h, 07ah, 0fah, 06dh, 0fdh, 07eh, 0fch, 07ch
	defb 05eh, 01ch, 004h, 000h, 08ch, 001h, 003h, 001h
	defb 000h, 009h, 01eh, 00fh, 007h, 00fh, 00fh, 01fh
	defb 01fh, 004h, 000h, 08ch, 0e4h, 0fah, 09ch, 066h
	defb 0feh, 0bbh, 00fh, 086h, 084h, 0e4h, 0fah, 0fch
	defb 000h

rle_8dc1:                            ; 0x8DC1  held_4 → E000
	defb 005h, 000h, 08bh, 002h, 005h, 00fh, 016h, 02eh
	defb 06dh, 0bdh, 0fdh, 0fdh, 0ffh, 07fh, 005h, 000h
	defb 08bh, 03ch, 0c2h, 03ch, 0f0h, 0a0h, 0d0h, 0ech
	defb 0fah, 0f2h, 0ffh, 0feh, 005h, 000h, 08bh, 002h
	defb 007h, 00fh, 01bh, 033h, 076h, 0e6h, 097h, 0c7h
	defb 0b2h, 05fh, 005h, 000h, 08bh, 03ch, 0feh, 0cch
	defb 070h, 0e0h, 0f0h, 0bch, 036h, 0deh, 03dh, 0eah
	defb 007h, 000h, 089h, 00bh, 017h, 01ch, 02bh, 06ah
	defb 0b7h, 0f7h, 077h, 0b7h, 007h, 000h, 089h, 0f0h
	defb 008h, 0f0h, 0f0h, 0f8h, 07ch, 0bch, 0d8h, 0f4h
	defb 007h, 000h, 089h, 00bh, 01fh, 01fh, 03dh, 07fh
	defb 0fbh, 09ah, 05ch, 0fch, 007h, 000h, 089h, 0f0h
	defb 0f8h, 030h, 0d0h, 098h, 0d4h, 0e4h, 0f8h, 02ch
	defb 007h, 000h, 089h, 004h, 00bh, 00fh, 031h, 04fh
	defb 05dh, 0b5h, 0ach, 0bah, 007h, 000h, 089h, 0f8h
	defb 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 038h
	defb 007h, 000h, 089h, 004h, 00fh, 00fh, 03fh, 077h
	defb 07fh, 0efh, 0ffh, 0f7h, 007h, 000h, 089h, 0f8h
	defb 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 0f8h
	defb 008h, 000h, 088h, 004h, 00bh, 004h, 003h, 005h
	defb 015h, 029h, 058h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 004h, 00fh, 007h, 003h, 007h, 017h, 03fh
	defb 06fh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 000h

rle_8e86:                            ; 0x8E86  held_6 → E000
	defb 008h, 000h, 088h, 004h, 00bh, 004h, 003h, 005h
	defb 005h, 009h, 008h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 004h, 00fh, 007h, 003h, 007h, 007h, 00fh
	defb 00fh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 007h, 000h, 089h, 004h
	defb 00bh, 004h, 003h, 005h, 005h, 009h, 008h, 00fh
	defb 007h, 000h, 089h, 0f8h, 0b4h, 0fch, 03eh, 0feh
	defb 03eh, 02fh, 00eh, 0beh, 007h, 000h, 086h, 004h
	defb 00fh, 007h, 003h, 007h, 007h, 003h, 00fh, 007h
	defb 000h, 089h, 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h
	defb 0fdh, 0feh, 0f2h, 008h, 000h, 088h, 004h, 00bh
	defb 004h, 003h, 005h, 005h, 009h, 008h, 008h, 000h
	defb 088h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh
	defb 00eh, 008h, 000h, 088h, 004h, 00fh, 007h, 003h
	defb 007h, 007h, 00fh, 00fh, 008h, 000h, 088h, 0f8h
	defb 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 000h

rle_8f0e:                            ; 0x8F0E  held_6 → E000
	defb 006h, 000h, 086h, 003h, 00dh, 017h, 02fh, 06fh
	defb 0bfh, 003h, 0ffh, 081h, 07fh, 003h, 000h, 088h
	defb 008h, 014h, 014h, 01ch, 0e2h, 0eeh, 0feh, 0feh
	defb 003h, 0ffh, 082h, 0f2h, 0feh, 006h, 000h, 08ah
	defb 003h, 00eh, 01bh, 030h, 070h, 0e0h, 090h, 0c0h
	defb 0b0h, 05fh, 003h, 000h, 08dh, 008h, 01ch, 01ch
	defb 014h, 0feh, 032h, 012h, 01ah, 017h, 025h, 0cdh
	defb 03eh, 0eah, 007h, 000h, 089h, 003h, 00dh, 017h
	defb 02fh, 06fh, 0bfh, 0ffh, 07fh, 0bfh, 006h, 000h
	defb 087h, 010h, 028h, 0e8h, 0fch, 0f4h, 0fch, 0fch
	defb 003h, 0feh, 007h, 000h, 089h, 003h, 00eh, 01bh
	defb 030h, 070h, 0e0h, 090h, 040h, 0f0h, 006h, 000h
	defb 08ah, 010h, 038h, 0f8h, 02ch, 01ch, 01ch, 014h
	defb 026h, 0ceh, 03ah, 008h, 000h, 088h, 004h, 00bh
	defb 004h, 003h, 005h, 005h, 009h, 008h, 008h, 000h
	defb 088h, 0f8h, 0b4h, 0fch, 03eh, 0feh, 03eh, 02fh
	defb 00eh, 008h, 000h, 088h, 004h, 00fh, 007h, 003h
	defb 007h, 007h, 00fh, 00fh, 008h, 000h, 088h, 0f8h
	defb 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh, 006h
	defb 000h, 08ah, 004h, 00bh, 004h, 003h, 003h, 005h
	defb 005h, 009h, 008h, 00fh, 006h, 000h, 08ah, 0f8h
	defb 0b4h, 0fch, 03eh, 0feh, 0feh, 03fh, 02eh, 00fh
	defb 0ffh, 006h, 000h, 087h, 004h, 00fh, 007h, 003h
	defb 003h, 007h, 007h, 003h, 00fh, 006h, 000h, 08ah
	defb 0f8h, 05ch, 084h, 0c2h, 0c2h, 0f2h, 0fdh, 0feh
	defb 0f9h, 0f1h, 000h

rle_8fd9:                            ; 0x8FD9  copy_ab59 / copy_pwd → F940 / FD40
	defb 088h, 004h, 01fh, 02fh, 02dh, 012h, 01dh, 00fh
	defb 007h, 008h, 000h, 084h, 03ch, 0feh, 0fdh, 0f9h
	defb 003h, 0ffh, 081h, 01eh, 008h, 000h, 088h, 007h
	defb 01bh, 034h, 03fh, 013h, 01eh, 00eh, 007h, 008h
	defb 000h, 088h, 0f4h, 0e2h, 017h, 0ffh, 00fh, 011h
	defb 0e7h, 01eh, 008h, 000h, 088h, 003h, 007h, 007h
	defb 002h, 001h, 001h, 000h, 003h, 008h, 000h, 003h
	defb 0fch, 085h, 08ch, 07ch, 0f8h, 0f8h, 0f0h, 008h
	defb 000h, 088h, 003h, 004h, 004h, 003h, 001h, 001h
	defb 000h, 003h, 008h, 000h, 088h, 0cch, 084h, 074h
	defb 0fch, 0f4h, 008h, 0f8h, 0f0h, 008h, 000h, 088h
	defb 004h, 003h, 005h, 004h, 007h, 00bh, 00fh, 007h
	defb 008h, 000h, 088h, 03ch, 0feh, 0fdh, 0feh, 0feh
	defb 0ffh, 08fh, 09eh, 008h, 000h, 082h, 007h, 003h
	defb 003h, 007h, 083h, 00ah, 00fh, 007h, 008h, 000h
	defb 088h, 0f4h, 0c6h, 00fh, 0b6h, 0c2h, 071h, 08bh
	defb 09eh, 008h, 000h, 000h

rle_905d:                            ; 0x905D  held_0 → E000
	defb 082h, 03fh, 01fh, 005h, 00fh, 081h, 01fh, 008h
	defb 000h, 003h, 0feh, 084h, 0fch, 0feh, 0bch, 080h
	defb 009h, 000h, 088h, 027h, 010h, 00bh, 00ch, 008h
	defb 008h, 00eh, 01fh, 008h, 000h, 087h, 0eah, 006h
	defb 0f2h, 00ch, 0c6h, 0bch, 080h, 009h, 000h, 003h
	defb 07fh, 084h, 03fh, 07fh, 03dh, 001h, 009h, 000h
	defb 082h, 0fch, 0f8h, 005h, 0f0h, 081h, 0f8h, 008h
	defb 000h, 087h, 053h, 060h, 04fh, 030h, 063h, 03dh
	defb 001h, 009h, 000h, 088h, 0c4h, 008h, 0d0h, 030h
	defb 010h, 010h, 070h, 0f8h, 008h, 000h, 087h, 098h
	defb 0bfh, 07bh, 00dh, 03bh, 01fh, 00eh, 009h, 000h
	defb 083h, 07eh, 0fdh, 0f9h, 003h, 0feh, 081h, 01ch
	defb 009h, 000h, 087h, 0ffh, 0c7h, 07ch, 00fh, 03ch
	defb 01dh, 00eh, 009h, 000h, 087h, 0e2h, 0c7h, 03fh
	defb 0d6h, 022h, 0f6h, 01ch, 009h, 000h, 000h

rle_90d4:                            ; 0x90D4  held_1, held_2, held_3, held_5 → E000
	defb 088h, 04ch, 05fh, 03fh, 00dh, 002h, 01dh, 00fh
	defb 007h, 008h, 000h, 084h, 03ch, 0feh, 0fdh, 0f9h
	defb 003h, 0ffh, 081h, 01eh, 008h, 000h, 088h, 07fh
	defb 073h, 034h, 00fh, 003h, 01eh, 00eh, 007h, 008h
	defb 000h, 088h, 0f4h, 0e2h, 017h, 0ffh, 00fh, 011h
	defb 0e7h, 01eh, 008h, 000h, 088h, 05fh, 03fh, 00fh
	defb 002h, 001h, 001h, 000h, 003h, 008h, 000h, 003h
	defb 0fch, 085h, 08ch, 07ch, 0f8h, 0f8h, 0f0h, 008h
	defb 000h, 088h, 073h, 034h, 00ch, 003h, 001h, 001h
	defb 000h, 003h, 008h, 000h, 088h, 0cch, 084h, 074h
	defb 0fch, 0f4h, 008h, 0f8h, 0f0h, 008h, 000h, 088h
	defb 024h, 02fh, 01dh, 004h, 007h, 00bh, 00fh, 007h
	defb 008h, 000h, 081h, 03ch, 003h, 0fch, 084h, 0feh
	defb 0ffh, 08fh, 09eh, 008h, 000h, 088h, 03fh, 03bh
	defb 01fh, 007h, 007h, 00ah, 00fh, 007h, 008h, 000h
	defb 088h, 0f4h, 0c4h, 00ch, 0b4h, 0c2h, 071h, 08bh
	defb 09eh, 008h, 000h, 000h

rle_9158:                            ; 0x9158  held_3, held_5, held_6 → E000
	defb 082h, 07fh, 03fh, 005h, 01fh, 081h, 03eh, 008h
	defb 000h, 002h, 0feh, 084h, 0fch, 0f0h, 0fch, 078h
	defb 00ah, 000h, 088h, 047h, 020h, 017h, 018h, 011h
	defb 011h, 01dh, 03eh, 008h, 000h, 086h, 086h, 032h
	defb 0dch, 010h, 08ch, 078h, 00ah, 000h, 003h, 0ffh
	defb 085h, 07fh, 0ffh, 07bh, 003h, 001h, 008h, 000h
	defb 081h, 0e4h, 003h, 0fch, 084h, 0f8h, 0e0h, 0e0h
	defb 0f0h, 008h, 000h, 088h, 0afh, 0c0h, 09fh, 060h
	defb 0c6h, 07ah, 002h, 001h, 008h, 000h, 088h, 0fch
	defb 014h, 08ch, 064h, 038h, 020h, 0e0h, 0f0h, 008h
	defb 000h, 000h

rle_91aa:                            ; 0x91AA  held_1, held_2 → E000
	defb 082h, 07fh, 03fh, 005h, 01fh, 081h, 03eh, 008h
	defb 000h, 002h, 0feh, 084h, 0fch, 0f0h, 0fch, 078h
	defb 00ah, 000h, 088h, 047h, 020h, 017h, 018h, 011h
	defb 011h, 01dh, 03eh, 008h, 000h, 086h, 086h, 032h
	defb 0dch, 010h, 08ch, 078h, 00ah, 000h, 003h, 0ffh
	defb 085h, 07fh, 0ffh, 07bh, 003h, 001h, 008h, 000h
	defb 081h, 0e4h, 003h, 0fch, 084h, 0f8h, 0e0h, 0e0h
	defb 0f0h, 008h, 000h, 088h, 0afh, 0c0h, 09fh, 060h
	defb 0c6h, 07ah, 002h, 001h, 008h, 000h, 088h, 0fch
	defb 014h, 08ch, 064h, 038h, 020h, 0e0h, 0f0h, 008h
	defb 000h, 088h, 00fh, 007h, 007h, 002h, 001h, 001h
	defb 000h, 003h, 008h, 000h, 003h, 0fch, 085h, 08ch
	defb 07ch, 0f8h, 0f8h, 0f0h, 008h, 000h, 088h, 00bh
	defb 004h, 004h, 003h, 001h, 001h, 000h, 003h, 008h
	defb 000h, 088h, 0cch, 084h, 074h, 0fch, 0f4h, 008h
	defb 0f8h, 0f0h, 008h, 000h, 000h

rle_9227:                            ; 0x9227  held_1, held_2 → E000
	defb 088h, 04ch, 05fh, 03fh, 00dh, 002h, 01dh, 00fh
	defb 007h, 008h, 000h, 084h, 03ch, 0feh, 0fdh, 0f9h
	defb 003h, 0ffh, 081h, 01eh, 008h, 000h, 088h, 07fh
	defb 073h, 034h, 00fh, 003h, 01eh, 00eh, 007h, 008h
	defb 000h, 088h, 0f4h, 0e2h, 017h, 0ffh, 00fh, 011h
	defb 0e7h, 01eh, 008h, 000h, 000h

rle_9254:                            ; 0x9254  held_3 → E000
	defb 088h, 004h, 00fh, 032h, 073h, 0cfh, 087h, 08fh
	defb 077h, 008h, 000h, 088h, 07eh, 0deh, 0cch, 0f8h
	defb 0fch, 0feh, 0feh, 03ch, 008h, 000h, 088h, 007h
	defb 00bh, 03fh, 05eh, 0bfh, 0fch, 0feh, 077h, 008h
	defb 000h, 088h, 0e2h, 0e6h, 07ch, 0f8h, 00ch, 012h
	defb 0e6h, 03ch, 008h, 000h, 088h, 035h, 00eh, 003h
	defb 003h, 005h, 01fh, 00fh, 007h, 008h, 000h, 002h
	defb 0fch, 086h, 0b8h, 038h, 0fch, 0feh, 0feh, 03ch
	defb 008h, 000h, 088h, 03fh, 00dh, 003h, 003h, 006h
	defb 01ch, 00eh, 007h, 008h, 000h, 088h, 0cch, 084h
	defb 068h, 0f8h, 0cch, 012h, 0e6h, 03ch, 008h, 000h
	defb 000h

rle_92ad:                            ; 0x92AD  held_5 → E000
	defb 088h, 070h, 03fh, 01fh, 017h, 00bh, 077h, 03fh
	defb 01ch, 008h, 000h, 088h, 0eah, 0f0h, 0e0h, 0e0h
	defb 0f0h, 0f8h, 0f8h, 0e0h, 008h, 000h, 088h, 05fh
	defb 02fh, 010h, 01fh, 00ch, 078h, 03bh, 01ch, 008h
	defb 000h, 088h, 0bah, 010h, 0a0h, 0e0h, 030h, 048h
	defb 098h, 0e0h, 008h, 000h, 088h, 04fh, 03fh, 01fh
	defb 017h, 00bh, 077h, 03fh, 01ch, 008h, 000h, 004h
	defb 0e0h, 084h, 0f0h, 0f8h, 0f8h, 0e0h, 008h, 000h
	defb 088h, 079h, 030h, 01ch, 01fh, 00ch, 078h, 03bh
	defb 01ch, 008h, 000h, 088h, 0e0h, 020h, 020h, 0e0h
	defb 030h, 048h, 098h, 0e0h, 008h, 000h, 000h

rle_9304:                            ; 0x9304  held_4 → E000
	defb 088h, 058h, 05fh, 0ffh, 05bh, 005h, 03bh, 01fh
	defb 00eh, 008h, 000h, 084h, 078h, 0fch, 0fah, 0f2h
	defb 003h, 0feh, 081h, 03ch, 008h, 000h, 088h, 07fh
	defb 077h, 0a8h, 05fh, 006h, 03ch, 01dh, 00eh, 008h
	defb 000h, 088h, 0e8h, 0c4h, 02eh, 0feh, 01eh, 022h
	defb 0ceh, 03ch, 008h, 000h, 088h, 05fh, 0ffh, 05fh
	defb 005h, 002h, 003h, 001h, 007h, 008h, 000h, 003h
	defb 0f8h, 085h, 018h, 0f8h, 0f0h, 0f0h, 0e0h, 008h
	defb 000h, 088h, 077h, 0a9h, 058h, 007h, 003h, 002h
	defb 001h, 007h, 008h, 000h, 088h, 098h, 008h, 0e8h
	defb 0f8h, 0e8h, 010h, 0f0h, 0e0h, 008h, 000h, 088h
	defb 028h, 02fh, 07dh, 03ch, 00fh, 017h, 01fh, 00fh
	defb 008h, 000h, 081h, 078h, 003h, 0f8h, 084h, 0fch
	defb 0feh, 01eh, 03ch, 008h, 000h, 002h, 03fh, 086h
	defb 057h, 03fh, 00fh, 014h, 01fh, 00fh, 008h, 000h
	defb 088h, 0e8h, 088h, 018h, 0e8h, 084h, 0e2h, 016h
	defb 03ch, 008h, 000h, 000h

rle_9388:                            ; 0x9388  held_4 → E000
	defb 082h, 07fh, 03fh, 005h, 01fh, 081h, 03eh, 008h
	defb 000h, 086h, 0feh, 0fch, 0f8h, 0f0h, 0fch, 078h
	defb 00ah, 000h, 088h, 047h, 020h, 017h, 018h, 011h
	defb 011h, 01dh, 03eh, 008h, 000h, 086h, 082h, 034h
	defb 0d8h, 010h, 08ch, 078h, 00ah, 000h, 003h, 0ffh
	defb 085h, 07fh, 0ffh, 07bh, 003h, 001h, 008h, 000h
	defb 088h, 0e4h, 0feh, 0fch, 0fch, 0f8h, 0e0h, 0e0h
	defb 0f0h, 008h, 000h, 088h, 0afh, 0c0h, 09fh, 060h
	defb 0c6h, 07ah, 002h, 001h, 008h, 000h, 088h, 0fch
	defb 01ah, 084h, 064h, 038h, 020h, 0e0h, 0f0h, 008h
	defb 000h, 088h, 0adh, 046h, 003h, 003h, 005h, 01fh
	defb 00fh, 007h, 008h, 000h, 002h, 0fch, 086h, 0b8h
	defb 038h, 0fch, 0feh, 0feh, 03ch, 008h, 000h, 088h
	defb 0ebh, 045h, 003h, 003h, 006h, 01ch, 00eh, 007h
	defb 008h, 000h, 088h, 0cch, 084h, 048h, 0f8h, 0cch
	defb 012h, 0e6h, 03ch, 008h, 000h, 088h, 054h, 0bfh
	defb 0a7h, 0afh, 0bfh, 05fh, 04fh, 037h, 008h, 000h
	defb 088h, 03eh, 0feh, 0dch, 0c8h, 0fch, 0feh, 0feh
	defb 03ch, 008h, 000h, 088h, 077h, 0dbh, 0ffh, 0f4h
	defb 0dfh, 07ch, 07eh, 037h, 008h, 000h, 088h, 0f2h
	defb 0e2h, 0f4h, 078h, 0fch, 012h, 0e6h, 03ch, 008h
	defb 000h, 000h

rle_9432:                            ; 0x9432  held_6 → E000
	defb 088h, 00fh, 070h, 0bfh, 073h, 017h, 01fh, 00fh
	defb 007h, 008h, 000h, 088h, 0beh, 0feh, 0dch, 0cch
	defb 0feh, 0ffh, 0ffh, 01eh, 008h, 000h, 088h, 00fh
	defb 07fh, 0deh, 07eh, 01bh, 01ch, 00eh, 007h, 008h
	defb 000h, 088h, 0f2h, 062h, 074h, 07ch, 0b2h, 011h
	defb 0e7h, 01eh, 008h, 000h, 088h, 070h, 0bfh, 073h
	defb 017h, 00dh, 001h, 000h, 003h, 008h, 000h, 088h
	defb 0feh, 0dch, 0cch, 0fch, 0fch, 0f8h, 0f8h, 0f0h
	defb 008h, 000h, 088h, 07fh, 0deh, 07eh, 01bh, 00dh
	defb 001h, 000h, 003h, 008h, 000h, 088h, 062h, 074h
	defb 07ch, 0b4h, 004h, 008h, 0f8h, 0f0h, 008h, 000h
	defb 088h, 007h, 038h, 05fh, 039h, 00bh, 007h, 00fh
	defb 007h, 008h, 000h, 088h, 0ffh, 07fh, 0eeh, 0e4h
	defb 0feh, 0ffh, 08fh, 09eh, 008h, 000h, 088h, 007h
	defb 03fh, 06fh, 03fh, 00dh, 006h, 00fh, 007h, 008h
	defb 000h, 088h, 0f9h, 0b1h, 03ah, 03ch, 0fah, 071h
	defb 08bh, 09eh, 008h, 000h, 000h

rle_94b7:                            ; 0x94B7  held_6 → E000
	defb 088h, 01fh, 070h, 0bfh, 073h, 017h, 00fh, 00fh
	defb 01fh, 008h, 000h, 088h, 0beh, 0feh, 0dch, 0c8h
	defb 0fch, 0feh, 0feh, 03ch, 008h, 000h, 088h, 01fh
	defb 07fh, 0deh, 07eh, 01bh, 00eh, 00eh, 01fh, 008h
	defb 000h, 088h, 0f2h, 062h, 074h, 078h, 0bch, 012h
	defb 0e6h, 03ch, 008h, 000h, 088h, 038h, 05fh, 039h
	defb 00bh, 01eh, 01dh, 00fh, 007h, 008h, 000h, 088h
	defb 06eh, 0e4h, 0f8h, 0fch, 0feh, 0feh, 0bch, 038h
	defb 008h, 000h, 088h, 03fh, 06eh, 03fh, 00dh, 01fh
	defb 01eh, 00eh, 007h, 008h, 000h, 088h, 0bah, 03ch
	defb 038h, 0cch, 012h, 066h, 0ach, 038h, 008h, 000h
	defb 000h

rle_9510:                            ; 0x9510  held_1, held_2 → E000
	defb 008h, 000h, 088h, 004h, 00bh, 004h, 003h, 005h
	defb 005h, 009h, 038h, 008h, 000h, 088h, 0f8h, 0b4h
	defb 0fch, 03eh, 0feh, 03eh, 02fh, 00eh, 008h, 000h
	defb 088h, 004h, 00fh, 007h, 003h, 007h, 007h, 00fh
	defb 03fh, 008h, 000h, 088h, 0f8h, 05ch, 084h, 0c2h
	defb 0c2h, 0f2h, 0fdh, 0feh, 000h

rle_953d:                            ; 0x953D  l5928h → E000
	defb 007h, 000h, 089h, 009h, 017h, 009h, 006h, 00bh
	defb 00ch, 012h, 010h, 009h, 007h, 000h, 089h, 0f0h
	defb 068h, 0f8h, 07ch, 0fch, 07ch, 07eh, 08ch, 0fch
	defb 007h, 000h, 089h, 009h, 01eh, 00fh, 007h, 00fh
	defb 00fh, 01fh, 01fh, 00fh, 007h, 000h, 091h, 0f0h
	defb 0b8h, 008h, 084h, 084h, 0e4h, 0fah, 0fch, 074h
	defb 007h, 00fh, 00bh, 027h, 03bh, 01fh, 00eh, 001h
	defb 008h, 000h, 081h, 0fch, 004h, 0f8h, 002h, 0f0h
	defb 081h, 0e0h, 008h, 000h, 088h, 007h, 008h, 00fh
	defb 024h, 03ch, 01dh, 00eh, 001h, 008h, 000h, 088h
	defb 004h, 008h, 0f8h, 018h, 068h, 090h, 0f0h, 0e0h
	defb 00eh, 000h, 08ah, 001h, 006h, 00bh, 017h, 037h
	defb 05fh, 07fh, 07fh, 09fh, 0bfh, 006h, 000h, 085h
	defb 080h, 0e0h, 0f0h, 0f8h, 0fch, 003h, 0feh, 082h
	defb 0f9h, 0fdh, 006h, 000h, 08ah, 001h, 007h, 00dh
	defb 018h, 038h, 070h, 048h, 060h, 0f8h, 0efh, 006h
	defb 000h, 091h, 080h, 060h, 090h, 008h, 00ch, 00ah
	defb 012h, 066h, 01fh, 0f7h, 07fh, 01fh, 07fh, 03fh
	defb 01fh, 00dh, 001h, 009h, 000h, 082h, 0feh, 0fch
	defb 003h, 0f8h, 083h, 0f0h, 0e0h, 0f0h, 008h, 000h
	defb 087h, 063h, 01ch, 063h, 030h, 01bh, 00dh, 001h
	defb 009h, 000h, 088h, 0e2h, 004h, 0e8h, 018h, 088h
	defb 010h, 0a0h, 0f0h, 00fh, 000h, 083h, 003h, 005h
	defb 007h, 003h, 00fh, 083h, 01fh, 00ch, 00fh, 007h
	defb 000h, 089h, 0e4h, 0bah, 0e4h, 098h, 0f4h, 08ch
	defb 092h, 042h, 0e4h, 007h, 000h, 089h, 003h, 007h
	defb 004h, 008h, 008h, 009h, 017h, 00fh, 00bh, 007h
	defb 000h, 08ah, 0e4h, 05eh, 03ch, 078h, 07ch, 0fch
	defb 0feh, 0feh, 0bch, 00fh, 004h, 007h, 002h, 003h
	defb 081h, 001h, 008h, 000h, 088h, 0f8h, 0fch, 0f4h
	defb 0f9h, 0f7h, 0feh, 0dch, 0e0h, 008h, 000h, 088h
	defb 008h, 004h, 007h, 006h, 005h, 002h, 003h, 001h
	defb 008h, 000h, 088h, 038h, 004h, 0fch, 009h, 08fh
	defb 06eh, 0dch, 0e0h, 00eh, 000h, 08ah, 003h, 005h
	defb 00bh, 00fh, 01fh, 03dh, 038h, 039h, 04ch, 05fh
	defb 005h, 000h, 08bh, 0c0h, 070h, 0f8h, 0fch, 0fch
	defb 0feh, 02fh, 0c7h, 027h, 0c9h, 0fdh, 006h, 000h
	defb 08ah, 003h, 006h, 00fh, 00ch, 013h, 02fh, 02fh
	defb 03fh, 07fh, 076h, 005h, 000h, 08dh, 0c0h, 0b0h
	defb 008h, 0f4h, 00ch, 0f2h, 0fdh, 0fdh, 0ffh, 0ffh
	defb 0d7h, 03fh, 01fh, 003h, 00fh, 083h, 007h, 003h
	defb 007h, 008h, 000h, 088h, 0feh, 0fch, 03fh, 0feh
	defb 0fch, 0d8h, 0c0h, 080h, 008h, 000h, 088h, 021h
	defb 010h, 00bh, 00ch, 008h, 004h, 002h, 007h, 008h
	defb 000h, 088h, 0e2h, 01ch, 0e3h, 006h, 0ech, 058h
	defb 0c0h, 080h, 00dh, 000h, 08bh, 001h, 006h, 00bh
	defb 017h, 01fh, 03fh, 07ah, 071h, 072h, 099h, 0bfh
	defb 005h, 000h, 08bh, 080h, 0e0h, 0f0h, 0f8h, 0f8h
	defb 0fch, 05eh, 08eh, 04eh, 092h, 0fah, 005h, 000h
	defb 08bh, 001h, 007h, 00ch, 01fh, 018h, 027h, 05fh
	defb 05fh, 07fh, 0ffh, 0edh, 005h, 000h, 093h, 080h
	defb 060h, 010h, 0e8h, 018h, 0e4h, 0fah, 0fah, 0feh
	defb 0feh, 0aeh, 07fh, 03fh, 01eh, 01fh, 01fh, 00fh
	defb 007h, 00fh, 008h, 000h, 087h, 0fch, 0f8h, 07eh
	defb 0fch, 0f8h, 0b0h, 080h, 009h, 000h, 088h, 043h
	defb 020h, 017h, 018h, 011h, 008h, 005h, 00fh, 008h
	defb 000h, 087h, 0c4h, 038h, 0c6h, 00ch, 0d8h, 0b0h
	defb 080h, 00eh, 000h, 08bh, 001h, 006h, 00bh, 017h
	defb 01fh, 03fh, 07ah, 071h, 072h, 049h, 05fh, 005h
	defb 000h, 08bh, 080h, 0e0h, 0f0h, 0f8h, 0f8h, 0fch
	defb 05eh, 08eh, 04eh, 099h, 0fdh, 005h, 000h, 08bh
	defb 001h, 007h, 00ch, 01fh, 018h, 027h, 05fh, 05fh
	defb 07fh, 07fh, 075h, 005h, 000h, 092h, 080h, 060h
	defb 010h, 0e8h, 018h, 0e4h, 0fah, 0fah, 0feh, 0ffh
	defb 0b7h, 03fh, 01fh, 07eh, 03fh, 01fh, 00dh, 001h
	defb 009h, 000h, 088h, 0feh, 0fch, 078h, 0f8h, 0f8h
	defb 0f0h, 0e0h, 0f0h, 008h, 000h, 087h, 023h, 01ch
	defb 063h, 030h, 01bh, 00dh, 001h, 009h, 000h, 088h
	defb 0c2h, 004h, 0e8h, 018h, 088h, 010h, 0a0h, 0f0h
	defb 017h, 000h, 081h, 038h, 00fh, 000h, 081h, 00eh
	defb 00fh, 000h, 081h, 038h, 00fh, 000h, 089h, 00eh
	defb 044h, 05eh, 03fh, 01fh, 03fh, 05fh, 05fh, 03fh
	defb 008h, 000h, 088h, 011h, 037h, 07eh, 0fch, 0feh
	defb 0fdh, 0fdh, 0feh, 008h, 000h, 088h, 07ch, 066h
	defb 039h, 010h, 030h, 078h, 074h, 03fh, 008h, 000h
	defb 088h, 01fh, 039h, 04eh, 084h, 006h, 00fh, 017h
	defb 0feh, 008h, 000h, 000h

rle_97a1:                            ; 0x97A1  col_15 → F880
	defb 005h, 000h, 002h, 001h, 090h, 00bh, 017h, 009h
	defb 004h, 009h, 009h, 012h, 012h, 00ch, 030h, 078h
	defb 078h, 0f0h, 0f0h, 0e0h, 0e0h, 003h, 0c0h, 083h
	defb 040h, 0a0h, 040h, 008h, 000h, 002h, 001h, 096h
	defb 00ah, 01eh, 00fh, 007h, 00fh, 00fh, 01eh, 01eh
	defb 00ch, 030h, 048h, 048h, 090h, 090h, 020h, 020h
	defb 040h, 040h, 0c0h, 0c0h, 0e0h, 040h, 009h, 000h
	defb 084h, 07fh, 0ffh, 0ffh, 07fh, 00ah, 000h, 088h
	defb 020h, 050h, 0deh, 0c1h, 0c1h, 0deh, 050h, 020h
	defb 00ah, 000h, 084h, 07fh, 080h, 080h, 07fh, 00ah
	defb 000h, 088h, 020h, 070h, 0feh, 07fh, 07fh, 0feh
	defb 070h, 020h, 004h, 000h, 08bh, 00ch, 012h, 012h
	defb 009h, 009h, 004h, 009h, 017h, 00bh, 001h, 001h
	defb 008h, 000h, 083h, 040h, 0a0h, 040h, 003h, 0c0h
	defb 002h, 0e0h, 002h, 0f0h, 002h, 078h, 08ch, 030h
	defb 00ch, 01eh, 01eh, 00fh, 00fh, 007h, 00fh, 01eh
	defb 00ah, 001h, 001h, 008h, 000h, 08dh, 040h, 0e0h
	defb 0c0h, 0c0h, 040h, 040h, 020h, 020h, 090h, 090h
	defb 048h, 048h, 030h, 003h, 000h, 083h, 001h, 002h
	defb 005h, 003h, 00bh, 002h, 005h, 002h, 002h, 081h
	defb 001h, 003h, 000h, 08eh, 060h, 0b0h, 070h, 0e0h
	defb 0c0h, 080h, 000h, 080h, 080h, 0c0h, 0c0h, 0e0h
	defb 060h, 0c0h, 004h, 000h, 08bh, 001h, 003h, 006h
	defb 00ch, 00dh, 00ch, 006h, 006h, 003h, 003h, 001h
	defb 003h, 000h, 08eh, 060h, 0d0h, 090h, 020h, 040h
	defb 080h, 000h, 080h, 080h, 040h, 040h, 020h, 0a0h
	defb 0c0h, 008h, 000h, 085h, 001h, 07fh, 080h, 0ffh
	defb 07fh, 006h, 000h, 08ah, 030h, 058h, 058h, 0b0h
	defb 0b0h, 030h, 060h, 060h, 0c0h, 080h, 00bh, 000h
	defb 085h, 001h, 07fh, 0ffh, 080h, 07fh, 006h, 000h
	defb 083h, 030h, 068h, 068h, 003h, 0d0h, 002h, 0a0h
	defb 082h, 040h, 080h, 008h, 000h, 085h, 07fh, 080h
	defb 0ffh, 07fh, 001h, 00bh, 000h, 084h, 080h, 040h
	defb 0a0h, 0a0h, 003h, 0d0h, 002h, 068h, 081h, 030h
	defb 006h, 000h, 085h, 07fh, 0ffh, 080h, 07fh, 001h
	defb 00bh, 000h, 08ch, 080h, 0c0h, 060h, 060h, 030h
	defb 0b0h, 0b0h, 058h, 058h, 030h, 000h, 000h, 000h

