; packed screen-to-screen door links (bank 0D). 2 bytes (from, to) until 0xFF.
; Copied by load_links (e242) into ED80/ED90/EDA0/EDB0 (up/down/left/right).
; Empty lists point at links_empty (high byte of adcf_tbl[0] = 0xFF).

links_ad3a:
	LINK 0, 0
	LINK_END
links_ad3d:
	LINK 0, 1
	LINK_END
links_ad40:
	LINK 1, 0
	LINK_END
links_ad43:
	LINK 0, 8
	LINK_END
links_ad46:
	LINK 8, 0
	LINK_END
links_ad49:
	LINK 0, 2
	LINK_END
links_ad4c:
	LINK 2, 0
	LINK_END
links_ad4f:
	LINK 0, 16
	LINK_END
links_ad52:
	LINK 16, 0
	LINK_END
links_ad55:
	LINK 0, 0
	LINK 1, 1
	LINK_END
links_ad5a:
	LINK 8, 9
	LINK_END
links_ad5d:
	LINK 9, 8
	LINK_END
links_ad60:
	LINK 1, 9
	LINK_END
links_ad63:
	LINK 9, 1
	LINK_END
links_ad66:
	LINK 0, 1
	LINK 9, 9
	LINK_END
links_ad6b:
	LINK 1, 0
	LINK 9, 9
	LINK_END
links_ad70:
	LINK 0, 0
	LINK 16, 16
	LINK_END
links_ad75:
	LINK 0, 0
	LINK 1, 1
	LINK_END
links_ad7a:
	LINK 0, 8
	LINK 1, 9
	LINK_END
links_ad7f:
	LINK 8, 0
	LINK 9, 1
	LINK_END
links_ad84:
	LINK 1, 9
	LINK_END
links_ad87:
	LINK 9, 1
	LINK_END
links_ad8a:
	LINK 0, 0
	LINK 3, 3
	LINK_END
links_ad8f:
	LINK 0, 8
	LINK 1, 9
	LINK_END
links_ad94:
	LINK 8, 0
	LINK 9, 1
	LINK_END
links_ad99:
	LINK 0, 8
	LINK 1, 9
	LINK 2, 10
	LINK_END
links_ada0:
	LINK 8, 0
	LINK 9, 1
	LINK 10, 2
	LINK_END
links_ada7:
	LINK 0, 2
	LINK 8, 10
	LINK_END
links_adac:
	LINK 2, 0
	LINK 10, 8
	LINK_END
links_adb1:
	LINK 2, 10
	LINK_END
links_adb4:
	LINK 10, 2
	LINK_END
links_adb7:
	LINK 0, 8
	LINK 9, 9
	LINK_END
links_adbc:
	LINK 8, 0
	LINK 9, 9
	LINK_END
links_adc1:
	LINK 0, 1
	LINK 8, 9
	LINK_END
links_adc6:
	LINK 1, 0
	LINK 9, 8
	LINK_END
links_adcb:                       ; pyramid lists sharing ADCB
	LINK 0, 0
	defb 002h, 002h               ; LINK 2, 2 ; end overlaps adcf_tbl[0]

adcf_tbl:                         ; 0xADCF  up    -> 0xED80  (screen-8); 60 words, e242
	defb 0ffh
links_empty:
	defb 0ffh                      ; empty list; [0] = 0xFFFF
	defw links_ad3a, links_ad3a, links_empty, links_ad43, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad55, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_ad3a, links_empty, links_empty, links_empty, links_empty, links_ad4f
	defw links_empty, links_empty, links_ad60, links_empty, links_ad3a, links_empty, links_empty, links_ad4f
	defw links_ad75, links_empty, links_ad7a, links_ad84, links_ad8a, links_empty, links_empty, links_ad8f
	defw links_empty, links_ad3a, links_ad8f, links_ad99, links_empty, links_adb1, links_adb7, links_empty
	defw links_empty, links_ad43, links_ad3a, links_empty, links_adcb, links_ad43, links_ad43, links_empty
	defw links_empty, links_empty, links_empty

ae47_tbl:                         ; 0xAE47  down  -> 0xED90  (screen+8)
	defw links_empty, links_ad3a, links_ad3a, links_empty, links_ad46, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_empty, links_ad55, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad3a, links_empty, links_empty, links_empty, links_empty
	defw links_ad52, links_empty, links_empty, links_ad63, links_empty, links_ad3a, links_empty, links_empty
	defw links_ad52, links_ad75, links_empty, links_ad7f, links_ad87, links_ad8a, links_empty, links_empty
	defw links_ad94, links_empty, links_ad3a, links_ad94, links_ada0, links_empty, links_adb4, links_adbc
	defw links_empty, links_empty, links_ad46, links_ad3a, links_empty, links_adcb, links_ad46, links_ad46
	defw links_empty, links_empty, links_empty, links_empty

aebf_tbl:                         ; 0xAEBF  left  -> 0xEDA0  (screen-1 in row)
	defw links_empty, links_empty, links_ad3a, links_ad3d, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad3a, links_ad3d, links_empty, links_ad5a, links_ad49
	defw links_empty, links_ad49, links_empty, links_empty, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad66, links_empty, links_empty, links_empty, links_empty
	defw links_ad70, links_ad49, links_ad5a, links_empty, links_empty, links_empty, links_ad3d, links_empty
	defw links_empty, links_empty, links_ad3d, links_ad5a, links_ada7, links_ad49, links_ad49, links_ad5a
	defw links_ad49, links_empty, links_adc1, links_ad3a, links_ad3d, links_ad49, links_empty, links_empty
	defw links_empty, links_ad3d, links_empty, links_empty

af37_tbl:                         ; 0xAF37  right -> 0xEDB0  (screen+1 in row)
	defw links_empty, links_empty, links_ad3a, links_ad40, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad3a, links_ad40, links_empty, links_ad5d, links_ad4c
	defw links_empty, links_ad4c, links_empty, links_empty, links_empty, links_empty, links_empty, links_empty
	defw links_empty, links_empty, links_empty, links_ad6b, links_empty, links_empty, links_empty, links_empty
	defw links_ad70, links_ad4c, links_ad5d, links_empty, links_empty, links_empty, links_ad40, links_empty
	defw links_empty, links_empty, links_ad40, links_ad5d, links_adac, links_ad4c, links_ad4c, links_ad5d
	defw links_ad4c, links_empty, links_adc6, links_ad3a, links_ad40, links_ad4c, links_empty, links_empty
	defw links_empty, links_ad40, links_empty, links_empty

	defw links_empty                 ; leftover after af37 (0xAFAF)
