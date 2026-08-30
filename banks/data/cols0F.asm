; bank 0F draw_cols continuation (col_21 tail + col_22..col_47).
; 27 tile ids × 1, draw_tilemap BC=1B01h. col_47 packed, not indexed
; by current A=0/4/0Fh callers.

	; col_21 continues
	defb 065h, 08ch, 095h, 066h, 076h, 086h, 064h, 064h, 07eh, 09eh

col_22:                            ; 0xA00A
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 075h, 066h, 076h, 086h, 067h, 077h, 09ah, 064h, 064h, 07eh, 09eh

col_23:                            ; 0xA025
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 067h, 077h, 09ah, 068h, 078h, 088h, 064h, 064h, 07eh, 09eh

col_24:                            ; 0xA040
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 066h, 076h, 0a3h, 078h, 088h, 066h, 076h, 086h, 064h, 064h, 07eh, 09eh

col_25:                            ; 0xA05B
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 066h, 076h, 067h, 066h, 076h, 066h, 076h, 086h, 099h, 09ah, 064h, 064h, 07eh, 09eh

col_26:                            ; 0xA076
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 066h, 076h, 067h, 066h, 076h, 086h, 099h, 067h, 077h, 09ah, 06bh, 088h, 064h, 064h, 07eh, 09eh

col_27:                            ; 0xA091
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 067h, 077h, 068h, 067h, 077h, 09ah, 06bh, 068h, 078h, 088h, 06ch, 086h, 064h, 064h, 07eh, 09eh

col_28:                            ; 0xA0AC
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 068h, 078h, 066h, 068h, 078h, 088h, 07ah, 0a8h, 079h, 089h, 085h, 09ah, 064h, 064h, 07eh, 09eh

col_29:                            ; 0xA0C7
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 090h, 090h, 068h, 067h, 066h, 076h, 086h, 099h, 077h, 09ah, 068h, 078h, 088h, 064h, 064h, 07eh, 09eh

col_30:                            ; 0xA0E2
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 090h, 090h, 066h, 076h, 068h, 067h, 077h, 09ah, 08bh, 078h, 058h, 0a9h, 0a9h, 0a9h, 064h, 064h, 07eh, 09eh

col_31:                            ; 0xA0FD
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 090h, 067h, 077h, 066h, 068h, 078h, 088h, 06ch, 076h, 059h, 000h, 000h, 000h, 064h, 064h, 07eh, 09eh

col_32:                            ; 0xA118
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 066h, 076h, 086h, 099h, 085h, 079h, 066h, 076h, 086h, 059h, 000h, 000h, 000h, 064h, 064h, 07eh, 09eh

col_33:                            ; 0xA133
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 067h, 077h, 09ah, 08bh, 078h, 088h, 067h, 077h, 09ah, 05ah, 0a9h, 0a9h, 0a9h, 064h, 064h, 07eh, 09eh

col_34:                            ; 0xA14E
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 068h, 078h, 088h, 098h, 066h, 076h, 068h, 078h, 088h, 05ch, 066h, 076h, 086h, 064h, 064h, 07eh, 09eh

col_35:                            ; 0xA169
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 080h, 090h, 084h, 094h, 097h, 067h, 077h, 079h, 089h, 085h, 093h, 067h, 077h, 09ah, 064h, 064h, 07eh, 09eh

col_36:                            ; 0xA184
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 067h, 077h, 066h, 068h, 078h, 088h, 066h, 076h, 086h, 08bh, 078h, 088h, 064h, 064h, 07eh, 09eh

col_37:                            ; 0xA19F
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 068h, 078h, 067h, 09ah, 066h, 076h, 067h, 077h, 09ah, 06ch, 076h, 086h, 064h, 064h, 07eh, 09eh

col_38:                            ; 0xA1BA
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 068h, 078h, 067h, 077h, 068h, 078h, 088h, 099h, 077h, 09ah, 064h, 064h, 07eh, 09eh

col_39:                            ; 0xA1D5
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 068h, 078h, 082h, 092h, 085h, 093h, 078h, 088h, 064h, 064h, 07eh, 09eh

col_40:                            ; 0xA1F0
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 068h, 089h, 093h, 0a4h, 066h, 076h, 086h, 064h, 064h, 07eh, 09eh

col_41:                            ; 0xA20B
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 068h, 0a4h, 082h, 067h, 077h, 09ah, 064h, 064h, 07eh, 09eh

col_42:                            ; 0xA226
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 083h, 000h, 068h, 078h, 088h, 064h, 064h, 07eh, 09eh

col_43:                            ; 0xA241
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 08ch, 095h, 087h, 081h, 091h, 064h, 064h, 07eh, 09eh

col_44:                            ; 0xA25C
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 0a7h, 08ch, 000h, 087h, 081h, 091h, 064h, 064h, 07eh, 09eh

col_45:                            ; 0xA277
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 07bh, 065h, 095h, 000h, 087h, 081h, 091h, 064h, 064h, 07eh, 09eh

col_46:                            ; 0xA292
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 07ch, 095h, 000h, 000h, 087h, 081h, 091h, 0a6h, 064h, 07eh, 09eh

col_47:                            ; 0xA2AD
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 000h, 000h, 000h, 087h, 081h, 091h, 0a6h, 064h, 07eh, 09eh

