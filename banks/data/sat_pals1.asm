; bank 0F sat_fx palettes + world_scr palette_list (0xA830–0xA8BB).

fx_a830:                            ; 0xA830  sat_fx 16×GRB
	defw 00000h, 00333h, 00444h, 00555h, 00666h, 00000h, 00000h, 00070h
	defw 00230h, 00550h, 00030h, 00777h, 00300h, 00117h, 00675h, 00000h

fx_a850:                            ; 0xA850  sat_fx 16×GRB
	defw 00000h, 00333h, 00444h, 00555h, 00666h, 00000h, 00000h, 00070h
	defw 00230h, 00550h, 00030h, 00777h, 00300h, 00000h, 00000h, 00000h

pal_a870:                            ; 0xA870  palette_list (world_scr)
	defb 000h, 000h, 000h, 001h, 030h, 000h, 002h, 030h
	defb 002h, 003h, 041h, 003h, 004h, 073h, 007h, 005h
	defb 055h, 005h, 006h, 000h, 002h, 007h, 070h, 000h
	defb 008h, 030h, 002h, 009h, 050h, 005h, 00ah, 077h
	defb 007h, 00bh, 077h, 007h, 00ch, 000h, 003h, 00fh
	defb 000h, 000h, 0ffh

fx_a89b:                            ; 0xA89B  sat_fx 16×GRB
	defw 00000h, 00301h, 00402h, 00503h, 00635h, 00777h, 00220h, 00070h
	defw 00341h, 00451h, 00777h, 00777h, 00050h, 00000h, 00000h, 00000h

