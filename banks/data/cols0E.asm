; bank 0E draw_cols word table + 1-wide 27-row tile-id columns.
; col_21 continues into bank 0F; col_22..col_47 live there.

col_ptr:                             ; 0x9D58  draw_cols; A=0/4/0Fh → 32 cols
	defw col_00, col_01, col_02, col_03, col_04, col_05, col_06, col_07
	defw col_08, col_09, col_10, col_11, col_12, col_13, col_14, col_15
	defw col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23
	defw col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31
	defw col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39
	defw col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47

col_00:                            ; 0x9DB8
	defb 0a1h, 0a0h, 0a0h, 05dh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 07ch, 095h, 000h, 08ch, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_01:                            ; 0x9DD3
	defb 06ah, 0a1h, 06dh, 05dh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 075h, 08ah, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_02:                            ; 0x9DEE
	defb 09fh, 0a2h, 06eh, 05eh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 08eh, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_03:                            ; 0x9E09
	defb 09dh, 06dh, 06fh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 07ch, 08eh, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_04:                            ; 0x9E24
	defb 06dh, 06eh, 07dh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 075h, 065h, 095h, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_05:                            ; 0x9E3F
	defb 09ch, 07fh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 07ch, 095h, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_06:                            ; 0x9E5A
	defb 07dh, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 075h, 08ah, 000h, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_07:                            ; 0x9E75
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 08ah, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_08:                            ; 0x9E90
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 083h, 096h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_09:                            ; 0x9EAB
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 083h, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_10:                            ; 0x9EC6
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 08dh, 08ch, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_11:                            ; 0x9EE1
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 05fh, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_12:                            ; 0x9EFC
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 08dh, 08eh, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_13:                            ; 0x9F17
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 08eh, 095h, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_14:                            ; 0x9F32
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 07bh, 065h, 095h, 095h, 095h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_15:                            ; 0x9F4D
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 07ch, 06ah, 095h, 000h, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_16:                            ; 0x9F68
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 07bh, 08ah, 000h, 095h, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_17:                            ; 0x9F83
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 08ah, 000h, 000h, 087h, 081h, 09eh, 0a6h, 064h, 07eh, 09eh

col_18:                            ; 0x9F9E
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 000h, 000h, 087h, 081h, 09eh, 064h, 064h, 07eh, 09eh

col_19:                            ; 0x9FB9
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 083h, 096h, 095h, 087h, 081h, 09eh, 064h, 064h, 07eh, 09eh

col_20:                            ; 0x9FD4
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 083h, 0a7h, 095h, 000h, 087h, 081h, 09eh, 064h, 064h, 07eh, 09eh

col_21:                             ; 0x9FEF  17 bytes here, 10 in bank 0F
	defb 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 0a5h, 063h, 083h, 075h

