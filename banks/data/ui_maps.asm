; bank 0F draw_tilemap grids + stamp streams (0xA2C8–0xA792).

pic_a2c8:                            ; 0xA2C8  12×12 draw_tilemap
	defb 001h, 002h, 002h, 002h, 002h, 002h, 002h, 002h, 002h, 002h, 002h, 006h
	defb 003h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 000h, 009h, 00ah, 00bh, 00ch, 00dh, 000h, 000h, 007h
	defb 003h, 000h, 000h, 000h, 00eh, 00fh, 000h, 010h, 011h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 012h, 013h, 000h, 014h, 015h, 016h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 017h, 018h, 000h, 019h, 01ah, 01bh, 000h, 000h, 007h
	defb 003h, 000h, 000h, 01ch, 01dh, 01eh, 01fh, 020h, 021h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 022h, 023h, 024h, 025h, 026h, 027h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 028h, 029h, 02ah, 02bh, 02ch, 02dh, 02eh, 000h, 007h
	defb 003h, 000h, 000h, 02fh, 030h, 031h, 032h, 033h, 034h, 000h, 000h, 007h
	defb 003h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h
	defb 004h, 005h, 005h, 005h, 005h, 005h, 005h, 005h, 005h, 005h, 005h, 008h

pic_a358:                            ; 0xA358  12×12 draw_tilemap
	defb 04eh, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 043h
	defb 010h, 018h, 018h, 018h, 018h, 03ch, 018h, 018h, 018h, 018h, 018h, 041h
	defb 010h, 018h, 018h, 018h, 002h, 003h, 008h, 009h, 018h, 018h, 018h, 041h
	defb 010h, 018h, 018h, 018h, 026h, 013h, 026h, 019h, 01ah, 01bh, 018h, 041h
	defb 010h, 045h, 020h, 021h, 022h, 018h, 028h, 029h, 004h, 018h, 02ah, 041h
	defb 010h, 04ah, 030h, 031h, 032h, 033h, 038h, 026h, 02ch, 026h, 03ah, 041h
	defb 010h, 049h, 004h, 005h, 006h, 007h, 00ch, 00dh, 018h, 00fh, 040h, 041h
	defb 010h, 02fh, 014h, 015h, 016h, 017h, 01ch, 01dh, 01eh, 01fh, 040h, 041h
	defb 010h, 018h, 04fh, 050h, 026h, 027h, 018h, 02dh, 02eh, 026h, 046h, 041h
	defb 010h, 018h, 034h, 004h, 036h, 037h, 004h, 00fh, 03eh, 03fh, 00bh, 041h
	defb 010h, 039h, 04ch, 04dh, 042h, 04bh, 036h, 00eh, 035h, 023h, 048h, 041h
	defb 011h, 012h, 012h, 012h, 044h, 044h, 044h, 044h, 044h, 012h, 044h, 00ah

stamp_a3e8:                            ; 0xA3E8  stamp world-map
	defb 091h
	defb 051h
	defb 052h
	defb 052h
	defb 052h
	defb 052h
	defb 052h
	defb 052h
	defb 052h
	defb 052h
	defb 05ah
	defb 05bh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 062h
	defb 063h
	defb 064h
	defb 064h
	defb 064h
	defb 064h
	defb 068h
	defb 069h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 074h
	defb 075h
	defb 075h
	defb 077h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 084h
	defb 000h
	defb 000h
	defb 087h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 072h
	defb 061h
	defb 0a5h
	defb 0a6h
	defb 0a6h
	defb 0a8h
	defb 061h
	defb 079h
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 060h
	defb 061h
	defb 082h
	defb 070h
	defb 0b5h
	defb 061h
	defb 061h
	defb 0b5h
	defb 07bh
	defb 07ch
	defb 061h
	defb 07eh
	defb 0feh, 000h         ; next row
	defb 05fh
	defb 070h
	defb 071h
	defb 061h
	defb 061h
	defb 061h
	defb 071h
	defb 061h
	defb 061h
	defb 061h
	defb 07bh
	defb 08eh
	defb 0ffh               ; end

stamp_a4c7:                            ; 0xA4C7  stamp world-map
	defb 065h
	defb 0b1h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 0b4h
	defb 094h
	defb 05dh
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 088h
	defb 07fh
	defb 07ah
	defb 07ah
	defb 07ah
	defb 07ah
	defb 083h
	defb 053h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 08fh
	defb 06dh
	defb 06dh
	defb 0aeh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0afh
	defb 000h
	defb 000h
	defb 06eh
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 061h
	defb 0abh
	defb 0ach
	defb 0adh
	defb 0adh
	defb 078h
	defb 07dh
	defb 061h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 061h
	defb 08ah
	defb 057h
	defb 058h
	defb 061h
	defb 05eh
	defb 061h
	defb 05eh
	defb 08dh
	defb 067h
	defb 08bh
	defb 061h
	defb 0feh, 000h         ; next row
	defb 057h
	defb 076h
	defb 061h
	defb 061h
	defb 06bh
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 06bh
	defb 09fh
	defb 067h
	defb 0ffh               ; end

wpic0:                            ; 0xA5A6  12×2 world-complete
	defb 09bh, 09ch
	defb 05ch, 0b2h
	defb 05ch, 0b2h
	defb 05ch, 0b2h
	defb 05ch, 0b2h
	defb 05ch, 0b2h
	defb 05ch, 0b2h
	defb 0c6h, 0bdh
	defb 0beh, 0bfh
	defb 0beh, 0bfh
	defb 0beh, 0bfh
	defb 0b8h, 0b9h

wpic1:                            ; 0xA5BE  12×4 world-complete
	defb 09dh, 09eh, 09eh, 0a2h
	defb 05ch, 061h, 061h, 0b2h
	defb 05ch, 061h, 061h, 0b2h
	defb 05ch, 061h, 061h, 0b2h
	defb 05ch, 061h, 061h, 0b2h
	defb 05ch, 061h, 061h, 0b2h
	defb 05ch, 061h, 061h, 0b2h
	defb 0c8h, 0c9h, 0c9h, 0c1h
	defb 0beh, 0cch, 0cch, 0bfh
	defb 0beh, 0cch, 0cch, 0bfh
	defb 0beh, 0cch, 0cch, 0bfh
	defb 0c2h, 0c3h, 0c3h, 0cbh

wpic2:                            ; 0xA5EE  14×6 world-complete
	defb 0b6h, 073h, 073h, 073h, 073h, 06ah
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 05ch, 061h, 061h, 061h, 061h, 066h
	defb 0c4h, 0c5h, 0c5h, 0c5h, 0c5h, 0cah
	defb 0c7h, 0cch, 0cch, 0cch, 0cch, 0c0h
	defb 0c7h, 0cch, 0cch, 0cch, 0cch, 0c0h
	defb 0c7h, 0cch, 0cch, 0cch, 0cch, 0c0h
	defb 0c7h, 0cch, 0cch, 0cch, 0cch, 0c0h
	defb 0bbh, 0bah, 0bah, 0bah, 0bah, 0bch

stamp_a642:                            ; 0xA642  stamp
	defb 0b6h
	defb 073h
	defb 073h
	defb 073h
	defb 073h
	defb 06ah
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 05ch
	defb 061h
	defb 061h
	defb 061h
	defb 061h
	defb 059h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0feh, 000h         ; next row
	defb 0b5h
	defb 061h
	defb 061h
	defb 061h
	defb 0b5h
	defb 061h
	defb 0ffh               ; end

stamp_a6b1:                            ; 0xA6B1  stamp
	defb 0c4h
	defb 0c5h
	defb 0c5h
	defb 0c5h
	defb 0c5h
	defb 0cah
	defb 0feh, 000h         ; next row
	defb 0c7h
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0c0h
	defb 0feh, 000h         ; next row
	defb 0c7h
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0c0h
	defb 0feh, 000h         ; next row
	defb 0c7h
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0c0h
	defb 0feh, 000h         ; next row
	defb 0c7h
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0cch
	defb 0c0h
	defb 0feh, 000h         ; next row
	defb 0ceh
	defb 0ceh
	defb 0ceh
	defb 0ceh
	defb 0ceh
	defb 0ceh
	defb 0ffh               ; end

stamp_a6e0:                            ; 0xA6E0  stamp → 8848h
	defb 037h
	defb 038h
	defb 039h
	defb 0feh, 000h         ; next row
	defb 047h
	defb 048h
	defb 049h
	defb 0feh, 000h         ; next row
	defb 040h
	defb 041h
	defb 02ah
	defb 0feh, 000h         ; next row
	defb 03fh
	defb 02fh
	defb 03ah
	defb 0feh, 000h         ; next row
	defb 042h
	defb 041h
	defb 01dh
	defb 0feh, 000h         ; next row
	defb 04ch
	defb 041h
	defb 02dh
	defb 0feh, 000h         ; next row
	defb 013h
	defb 014h
	defb 015h
	defb 0ffh               ; end

pic_a702:                            ; 0xA702  12×12 draw_tilemap
	defb 04dh, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 00bh
	defb 010h, 011h, 012h, 012h, 012h, 012h, 012h, 012h, 012h, 012h, 012h, 01bh
	defb 010h, 021h, 022h, 022h, 022h, 025h, 026h, 027h, 028h, 029h, 026h, 01bh
	defb 010h, 031h, 032h, 033h, 033h, 035h, 026h, 037h, 00dh, 00eh, 026h, 01bh
	defb 010h, 031h, 033h, 033h, 033h, 035h, 046h, 044h, 041h, 00ch, 04ah, 01bh
	defb 010h, 03eh, 02ch, 02ch, 02ch, 036h, 045h, 034h, 041h, 01ch, 02bh, 01bh
	defb 010h, 021h, 022h, 022h, 022h, 025h, 00ah, 006h, 007h, 008h, 03bh, 01bh
	defb 010h, 031h, 03ch, 03dh, 03dh, 035h, 00fh, 016h, 017h, 018h, 01eh, 01bh
	defb 010h, 031h, 03dh, 03dh, 03dh, 035h, 01fh, 003h, 004h, 005h, 02eh, 01bh
	defb 010h, 03eh, 02ch, 02ch, 02ch, 036h, 026h, 013h, 014h, 015h, 026h, 01bh
	defb 010h, 043h, 026h, 026h, 026h, 026h, 026h, 002h, 002h, 002h, 026h, 01bh
	defb 04eh, 04bh, 04bh, 04bh, 04bh, 04bh, 04bh, 04bh, 04bh, 04bh, 04bh, 024h

