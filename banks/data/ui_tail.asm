; bank 0F tail: stamp, pal_15, RLE, F800 copy, tilemap, hud_world.

stamp_b8db:                            ; 0xB8DB  Japanese logo (stamp_logo_jp / title_jp_gfx at 1050h)
	defb 001h
	defb 0feh, 000h         ; next row
	defb 02eh
	defb 030h
	defb 02fh
	defb 031h
	defb 032h
	defb 033h
	defb 034h
	defb 035h
	defb 036h
	defb 000h
	defb 007h
	defb 008h
	defb 009h
	defb 00ah
	defb 00bh
	defb 00ch
	defb 00dh
	defb 00eh
	defb 00fh
	defb 010h
	defb 002h
	defb 0feh, 000h         ; next row
	defb 037h
	defb 038h
	defb 039h
	defb 03ah
	defb 03bh
	defb 03ch
	defb 03dh
	defb 03eh
	defb 03fh
	defb 040h
	defb 011h
	defb 012h
	defb 013h
	defb 014h
	defb 015h
	defb 016h
	defb 005h
	defb 017h
	defb 018h
	defb 019h
	defb 0feh, 000h         ; next row
	defb 000h
	defb 041h
	defb 042h
	defb 043h
	defb 044h
	defb 045h
	defb 046h
	defb 047h
	defb 048h
	defb 049h
	defb 01ah
	defb 01bh
	defb 01ch
	defb 01dh
	defb 01eh
	defb 01fh
	defb 006h
	defb 020h
	defb 021h
	defb 022h
	defb 0feh, 000h         ; next row
	defb 04ah
	defb 04bh
	defb 04ch
	defb 04dh
	defb 04eh
	defb 04fh
	defb 050h
	defb 051h
	defb 003h
	defb 000h
	defb 023h
	defb 024h
	defb 025h
	defb 026h
	defb 027h
	defb 028h
	defb 029h
	defb 02ah
	defb 02bh
	defb 02ch
	defb 0feh, 000h         ; next row
	defb 052h
	defb 004h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 02dh
	defb 0feh, 000h         ; next row
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 0dah
	defb 0ebh
	defb 0efh
	defb 0eeh
	defb 0e1h
	defb 0edh
	defb 0e9h
	defb 000h
	defb 0d1h
	defb 0d9h
	defb 0d8h
	defb 0d8h
	defb 0ffh               ; end

pal_hud:                            ; 0xB95D  palette_list
	; last rec E + 0xFF terminator overlap pal_w_even[0] (0xFF00)
	defb 000h, 000h, 000h, 007h, 060h, 000h, 008h, 036h
	defb 004h, 009h, 060h, 004h, 00ah, 070h, 007h, 00bh
	defb 077h, 007h, 00ch, 014h, 002h, 00dh, 017h, 007h
	defb 00eh, 075h, 006h, 00fh, 000h
pal_w_even:                         ; 0xB97A  tbl_word[E241] even pyramid
	defw 0ff00h, pal_we1, pal_we2, pal_we3, pal_we4, pal_we5, pal_we6
pal_we1:                            ; 0xB988  world 1 even
	defb 001h, 040h, 002h, 002h, 045h, 004h, 003h, 034h
	defb 003h, 004h, 023h, 002h, 005h, 012h, 001h, 006h
	defb 000h, 000h, 0ffh

pal_we2:                            ; 0xB99B  world 2 even
	defb 001h, 062h, 005h, 002h, 052h, 003h, 003h, 032h
	defb 002h, 004h, 021h, 001h, 005h, 010h, 000h, 006h
	defb 002h, 005h, 0ffh

pal_we3:                            ; 0xB9AE  world 3 even
	defb 001h, 012h, 007h, 002h, 002h, 000h, 003h, 044h
	defb 006h, 004h, 022h, 004h, 005h, 000h, 002h, 006h
	defb 003h, 000h, 0ffh

pal_we4:                            ; 0xB9C1  world 4 even
	defb 001h, 000h, 001h, 002h, 011h, 002h, 003h, 022h
	defb 003h, 004h, 033h, 005h, 005h, 077h, 007h, 006h
	defb 007h, 006h, 0ffh

pal_we5:                            ; 0xB9D4  world 5 even
	defb 001h, 053h, 002h, 002h, 042h, 001h, 003h, 031h
	defb 000h, 004h, 010h, 000h, 005h, 060h, 003h, 006h
	defb 060h, 000h, 0ffh

pal_we6:                            ; 0xB9E7  world 6 even
	; last rec E + 0xFF overlap pal_w_odd[0] (0xFF00)
	defb 001h, 011h, 002h, 002h, 022h, 003h, 003h, 033h
	defb 004h, 004h, 044h, 005h, 005h, 000h, 001h, 006h
	defb 070h

pal_w_odd:                          ; 0xB9F8  tbl_word[E241] odd pyramid
	defw 0ff00h, pal_wo1, pal_wo2, pal_wo3, pal_wo4, pal_wo5, pal_wo6
pal_wo1:                            ; 0xBA06  world 1 odd
	defb 001h, 040h, 002h, 002h, 046h, 003h, 003h, 035h
	defb 002h, 004h, 024h, 001h, 005h, 012h, 000h, 006h
	defb 000h, 000h, 0ffh

pal_wo2:                            ; 0xBA19  world 2 odd
	defb 001h, 063h, 003h, 002h, 052h, 002h, 003h, 041h
	defb 001h, 004h, 030h, 000h, 005h, 010h, 000h, 006h
	defb 002h, 005h, 0ffh

pal_wo3:                            ; 0xBA2C  world 3 odd
	defb 001h, 054h, 006h, 002h, 002h, 000h, 003h, 042h
	defb 004h, 004h, 021h, 002h, 005h, 010h, 001h, 006h
	defb 020h, 002h, 0ffh

pal_wo4:                            ; 0xBA3F  world 4 odd
	defb 001h, 001h, 000h, 002h, 003h, 001h, 003h, 014h
	defb 002h, 004h, 025h, 003h, 005h, 077h, 007h, 006h
	defb 007h, 006h, 0ffh

pal_wo5:                            ; 0xBA52  world 5 odd
	defb 001h, 045h, 002h, 002h, 034h, 001h, 003h, 023h
	defb 000h, 004h, 012h, 000h, 005h, 046h, 003h, 006h
	defb 060h, 000h, 0ffh

pal_wo6:                            ; 0xBA65  world 6 odd
	defb 001h, 031h, 002h, 002h, 042h, 003h, 003h, 053h
	defb 004h, 004h, 064h, 005h, 005h, 020h, 001h, 006h
	defb 070h, 000h, 0ffh

pal_ba78:                           ; 0xBA78  palette_list (l57bbh)
	defb 001h, 011h, 001h, 002h, 022h, 002h, 003h, 032h
	defb 003h, 004h, 044h, 004h, 007h, 077h, 007h, 008h
	defb 014h, 001h, 009h, 012h, 000h, 00ah, 007h, 002h
	defb 00dh, 052h, 004h, 00eh, 074h, 006h, 00fh, 000h
	defb 000h, 0ffh

rle_ba9a:                            ; 0xBA9A  finger pointer → F800 (pointer.png)
	defb 083h, 000h, 01ch, 03eh, 006h, 036h, 003h, 037h
	defb 084h, 036h, 070h, 070h, 0e4h, 009h, 000h, 08ah
	defb 080h, 0f0h, 0f8h, 0fch, 05eh, 00eh, 087h, 000h
	defb 01ch, 036h, 006h, 02ah, 087h, 02bh, 02ah, 028h
	defb 029h, 06fh, 04fh, 0dbh, 009h, 000h, 089h, 080h
	defb 0f0h, 058h, 00ch, 0a6h, 0f2h, 07bh, 0e0h, 0e0h
	defb 003h, 0c0h, 002h, 0e0h, 084h, 070h, 078h, 038h
	defb 018h, 004h, 008h, 084h, 00fh, 017h, 003h, 003h
	defb 003h, 007h, 002h, 00eh, 002h, 01ch, 002h, 038h
	defb 003h, 030h, 083h, 0f0h, 09fh, 09fh, 003h, 0bfh
	defb 086h, 09fh, 0dfh, 04fh, 067h, 037h, 01fh, 005h
	defb 00fh, 08ch, 0e9h, 0fdh, 0fdh, 0f9h, 0f9h, 0fbh
	defb 0f2h, 0f6h, 0e4h, 0ech, 0c8h, 0d8h, 003h, 0d0h
	defb 081h, 0f0h, 000h

pat_bb05:                           ; 0xBB05  256 bytes → F800 (ldirmv)
	defb 000h, 040h, 03fh, 019h, 001h, 001h, 001h, 01fh
	defb 00dh, 001h, 001h, 001h, 01fh, 0fch, 070h, 000h
	defb 000h, 000h, 0feh, 00ch, 080h, 080h, 080h, 0f8h
	defb 09ch, 080h, 080h, 080h, 0fch, 01fh, 006h, 000h
	defb 000h, 000h, 000h, 026h, 018h, 000h, 000h, 000h
	defb 012h, 00ch, 000h, 000h, 000h, 003h, 08ch, 070h
	defb 000h, 000h, 001h, 0f2h, 04ch, 040h, 040h, 000h
	defb 060h, 05ch, 040h, 040h, 000h, 0e0h, 019h, 006h
	defb 000h, 000h, 001h, 07fh, 060h, 027h, 041h, 006h
	defb 018h, 002h, 00dh, 032h, 00ch, 078h, 033h, 000h
	defb 000h, 0c0h, 0c0h, 0feh, 007h, 0f3h, 002h, 098h
	defb 0f4h, 040h, 060h, 060h, 070h, 0deh, 08ch, 000h
	defb 000h, 000h, 000h, 000h, 01fh, 010h, 026h, 000h
	defb 006h, 019h, 002h, 00dh, 032h, 004h, 048h, 033h
	defb 000h, 000h, 000h, 001h, 0f8h, 004h, 0f5h, 002h
	defb 008h, 034h, 010h, 010h, 000h, 021h, 052h, 08ch
	defb 000h, 000h, 000h, 000h, 00fh, 019h, 031h, 021h
	defb 042h, 042h, 046h, 064h, 038h, 010h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 0e0h, 010h, 008h, 004h
	defb 004h, 004h, 004h, 00ch, 018h, 0f0h, 060h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 006h, 008h, 010h
	defb 021h, 021h, 021h, 002h, 044h, 028h, 010h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 0e0h, 090h, 088h
	defb 000h, 002h, 002h, 002h, 004h, 008h, 090h, 060h
	defb 000h, 008h, 00ch, 019h, 033h, 062h, 004h, 018h
	defb 070h, 0e0h, 04fh, 018h, 008h, 00ch, 007h, 000h
	defb 000h, 010h, 030h, 098h, 0cch, 046h, 020h, 018h
	defb 00eh, 007h, 0f2h, 018h, 010h, 030h, 0e0h, 000h
	defb 000h, 000h, 000h, 004h, 008h, 011h, 062h, 004h
	defb 008h, 010h, 020h, 007h, 004h, 002h, 008h, 007h
	defb 000h, 000h, 000h, 020h, 010h, 088h, 046h, 020h
	defb 010h, 008h, 004h, 0e0h, 008h, 008h, 010h, 0e0h

pic_bc05:                            ; 0xBC05  13×26 draw_tilemap at 1830h
	defb 00eh, 00ah, 00ah, 00bh, 00bh, 00ch, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00dh, 00bh, 00bh, 00ah, 00ah, 013h
	defb 00fh, 006h, 004h, 007h, 007h, 008h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 009h, 007h, 007h, 004h, 005h, 014h
	defb 00fh, 015h, 01ah, 02eh, 019h, 034h, 035h, 036h, 037h, 01ch, 01ah, 02fh, 01eh, 032h, 033h, 01ch, 01ah, 02eh, 019h, 034h, 035h, 036h, 037h, 01ch, 010h, 014h
	defb 00fh, 015h, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 01bh, 022h, 01fh, 024h, 021h, 01dh, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 01bh, 022h, 01fh, 024h, 021h, 01dh, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 01bh, 022h, 01fh, 024h, 021h, 01dh, 01bh, 025h, 018h, 026h, 027h, 028h, 029h, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 03bh, 018h, 03dh, 03fh, 040h, 042h, 01dh, 01bh, 030h, 020h, 038h, 03ah, 01dh, 01bh, 03bh, 018h, 03dh, 03fh, 040h, 042h, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 03ch, 02bh, 03eh, 02ch, 041h, 02dh, 01dh, 01bh, 031h, 023h, 039h, 02ah, 01dh, 01bh, 03ch, 02bh, 03eh, 02ch, 041h, 02dh, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 010h, 014h
	defb 00fh, 015h, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 01bh, 01dh, 010h, 014h
	defb 00fh, 016h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 043h, 044h, 011h, 014h
	defb 001h, 002h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 012h, 017h, 003h, 001h
	defb 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h, 001h

hud_world_tbl:                      ; 0xBD57  5 bytes × world 1..6 (hud_world)
	; B, C, max, ptr.le
hud_w1:                            ; world 1 ptr 0xBD75
	defb 006h, 00fh, 004h, 075h, 0bdh
hud_w2:                            ; world 2 ptr 0xBD93
	defb 006h, 008h, 008h, 093h, 0bdh
hud_w3:                            ; world 3 ptr 0xBDA3
	defb 002h, 004h, 010h, 0a3h, 0bdh
hud_w4:                            ; world 4 ptr 0xBDAB
	defb 005h, 002h, 005h, 0abh, 0bdh
hud_w5:                            ; world 5 ptr 0xBDB3
	defb 006h, 004h, 018h, 0b3h, 0bdh
hud_w6:                            ; world 6 ptr 0xBDBB
	defb 006h, 008h, 008h, 0bbh, 0bdh

hud_anim:                           ; 0xBD75  palette-set pairs through 0xBDCB
	defb 000h, 000h, 010h, 000h, 020h, 000h, 030h, 000h
	defb 040h, 000h, 050h, 000h, 060h, 000h, 070h, 000h
	defb 071h, 001h, 072h, 002h, 073h, 003h, 074h, 004h
	defb 075h, 005h, 076h, 006h, 077h, 007h, 000h, 000h
	defb 001h, 001h, 002h, 002h, 003h, 003h, 004h, 004h
	defb 005h, 005h, 006h, 006h, 007h, 007h, 002h, 000h
	defb 003h, 000h, 004h, 000h, 005h, 000h, 077h, 007h
	defb 047h, 004h, 047h, 004h, 077h, 007h, 042h, 001h
	defb 052h, 001h, 062h, 001h, 072h, 001h, 000h, 000h
	defb 010h, 000h, 020h, 001h, 030h, 001h, 040h, 002h
	defb 050h, 002h, 060h, 003h, 070h, 003h

