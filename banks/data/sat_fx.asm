; bank 0F sat_fx scripts (A=0..11). 5 bytes: from pal, to pal, delay.
; Pals are 16× MSX2 GRB words; 0xE887 is the live E887 buffer.

sat_fx_tbl:                          ; 0xA792  sat_fx
sat_fx00:                            ; A=0
	SATFX fx_a98a, fx_a89b, 00ch
sat_fx01:                            ; A=1
	SATFX fx_a89b, fx_a996, 008h
sat_fx02:                            ; A=2
	SATFX 0e887h, fx_a906, 006h
sat_fx03:                            ; A=3
	SATFX fx_a906, fx_a996, 002h
sat_fx04:                            ; A=4
	SATFX fx_a9b6, fx_a9d6, 004h
sat_fx05:                            ; A=5
	SATFX fx_a8e6, fx_a996, 008h
sat_fx06:                            ; A=6
	SATFX fx_a906, fx_a948, 008h
sat_fx07:                            ; A=7
	SATFX fx_a96a, fx_a996, 008h
sat_fx08:                            ; A=8
	SATFX fx_a830, fx_a850, 008h
sat_fx09:                            ; A=9
	SATFX 0e887h, fx_a926, 004h
sat_fx10:                            ; A=10
	SATFX fx_a926, fx_a906, 004h
sat_fx11:                            ; A=11
	SATFX fx_a948, fx_a96a, 008h

