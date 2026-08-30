; bank 0F sat_fx palettes (0xA8E6–0xA9F6). Two unused next-pal words;
; fx_a98a last 10 words overlap fx_a996 (all zero).

fx_a8e6:                            ; 0xA8E6  sat_fx 16×GRB
	defw 00000h, 00240h, 00341h, 00451h, 00775h, 00330h, 00604h, 00070h
	defw 00555h, 00470h, 00030h, 00777h, 00050h, 00000h, 00000h, 00000h

fx_a906:                            ; 0xA906  sat_fx 16×GRB
	defw 00000h, 00230h, 00341h, 00451h, 00765h, 00000h, 00000h, 00070h
	defw 00341h, 00451h, 00777h, 00777h, 00300h, 00000h, 00000h, 00000h

fx_a926:                            ; 0xA926  sat_fx 16×GRB
	defw 00000h, 00273h, 00374h, 00475h, 00677h, 00467h, 00367h, 00070h
	defw 00341h, 00451h, 00000h, 00777h, 00300h, 00000h, 00000h, 00000h
	defw fx_a948                      ; not consumed by sat_fx

fx_a948:                            ; 0xA948  sat_fx 16×GRB
	defw 00000h, 00230h, 00341h, 00451h, 00765h, 00000h, 00000h, 00070h
	defw 00341h, 00451h, 00000h, 00777h, 00300h, 00117h, 00675h, 00000h
	defw fx_a96a                      ; not consumed by sat_fx

fx_a96a:                            ; 0xA96A  sat_fx 16×GRB
	defw 00000h, 00230h, 00341h, 00451h, 00765h, 00000h, 00000h, 00070h
	defw 00341h, 00451h, 00777h, 00777h, 00300h, 00117h, 00675h, 00000h

fx_a98a:                            ; 0xA98A  last 10 words overlap fx_a996
	defw 00000h, 00000h, 00000h, 00000h, 00000h, 00777h

fx_a996:                            ; 0xA996  sat_fx 16×GRB (all black)
	defw 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h
	defw 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h

fx_a9b6:                            ; 0xA9B6  sat_fx 16×GRB
	defw 00000h, 00030h, 00230h, 00341h, 00773h, 00555h, 00200h, 00070h
	defw 00230h, 00550h, 00777h, 00777h, 00300h, 00717h, 00675h, 00000h

fx_a9d6:                            ; 0xA9D6  sat_fx 16×GRB
	defw 00000h, 00030h, 00230h, 00341h, 00773h, 00555h, 00200h, 00070h
	defw 00230h, 00550h, 00777h, 00777h, 00300h, 00000h, 00000h, 00000h

