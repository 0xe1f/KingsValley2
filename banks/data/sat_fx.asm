; bank 0F sat_fx scripts (A=0..11). 5 bytes: from pal, to pal, delay.
; Pals are 16× MSX2 GRB words; 0xE887 is the live E887 buffer.

sat_fx_tbl:                          ; 0xA792  sat_fx
sat_fx00:                            ; A=0
	defw fx_a98a, fx_a89b
	defb 00ch               ; delay
sat_fx01:                            ; A=1
	defw fx_a89b, fx_a996
	defb 008h               ; delay
sat_fx02:                            ; A=2
	defw 0e887h, fx_a906
	defb 006h               ; delay
sat_fx03:                            ; A=3
	defw fx_a906, fx_a996
	defb 002h               ; delay
sat_fx04:                            ; A=4
	defw fx_a9b6, fx_a9d6
	defb 004h               ; delay
sat_fx05:                            ; A=5
	defw fx_a8e6, fx_a996
	defb 008h               ; delay
sat_fx06:                            ; A=6
	defw fx_a906, fx_a948
	defb 008h               ; delay
sat_fx07:                            ; A=7
	defw fx_a96a, fx_a996
	defb 008h               ; delay
sat_fx08:                            ; A=8
	defw fx_a830, fx_a850
	defb 008h               ; delay
sat_fx09:                            ; A=9
	defw 0e887h, fx_a926
	defb 004h               ; delay
sat_fx10:                            ; A=10
	defw fx_a926, fx_a906
	defb 004h               ; delay
sat_fx11:                            ; A=11
	defw fx_a948, fx_a96a
	defb 008h               ; delay

