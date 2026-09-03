; packed screen-to-screen door links (bank 0D). 2 bytes (from, to) until 0xFF.
; Copied by load_links (e242) into ED80/ED90/EDA0/EDB0 (up/down/left/right).
; Empty lists point at links_empty (high byte of adcf_tbl[0] = 0xFF).

links_ad3a:
	defb 000h, 000h         ; 0 -> 0
	defb 0ffh               ; end
links_ad3d:
	defb 000h, 001h         ; 0 -> 1
	defb 0ffh               ; end
links_ad40:
	defb 001h, 000h         ; 1 -> 0
	defb 0ffh               ; end
links_ad43:
	defb 000h, 008h         ; 0 -> 8
	defb 0ffh               ; end
links_ad46:
	defb 008h, 000h         ; 8 -> 0
	defb 0ffh               ; end
links_ad49:
	defb 000h, 002h         ; 0 -> 2
	defb 0ffh               ; end
links_ad4c:
	defb 002h, 000h         ; 2 -> 0
	defb 0ffh               ; end
links_ad4f:
	defb 000h, 010h         ; 0 -> 16
	defb 0ffh               ; end
links_ad52:
	defb 010h, 000h         ; 16 -> 0
	defb 0ffh               ; end
links_ad55:
	defb 000h, 000h         ; 0 -> 0
	defb 001h, 001h         ; 1 -> 1
	defb 0ffh               ; end
links_ad5a:
	defb 008h, 009h         ; 8 -> 9
	defb 0ffh               ; end
links_ad5d:
	defb 009h, 008h         ; 9 -> 8
	defb 0ffh               ; end
links_ad60:
	defb 001h, 009h         ; 1 -> 9
	defb 0ffh               ; end
links_ad63:
	defb 009h, 001h         ; 9 -> 1
	defb 0ffh               ; end
links_ad66:
	defb 000h, 001h         ; 0 -> 1
	defb 009h, 009h         ; 9 -> 9
	defb 0ffh               ; end
links_ad6b:
	defb 001h, 000h         ; 1 -> 0
	defb 009h, 009h         ; 9 -> 9
	defb 0ffh               ; end
links_ad70:
	defb 000h, 000h         ; 0 -> 0
	defb 010h, 010h         ; 16 -> 16
	defb 0ffh               ; end
links_ad75:
	defb 000h, 000h         ; 0 -> 0
	defb 001h, 001h         ; 1 -> 1
	defb 0ffh               ; end
links_ad7a:
	defb 000h, 008h         ; 0 -> 8
	defb 001h, 009h         ; 1 -> 9
	defb 0ffh               ; end
links_ad7f:
	defb 008h, 000h         ; 8 -> 0
	defb 009h, 001h         ; 9 -> 1
	defb 0ffh               ; end
links_ad84:
	defb 001h, 009h         ; 1 -> 9
	defb 0ffh               ; end
links_ad87:
	defb 009h, 001h         ; 9 -> 1
	defb 0ffh               ; end
links_ad8a:
	defb 000h, 000h         ; 0 -> 0
	defb 003h, 003h         ; 3 -> 3
	defb 0ffh               ; end
links_ad8f:
	defb 000h, 008h         ; 0 -> 8
	defb 001h, 009h         ; 1 -> 9
	defb 0ffh               ; end
links_ad94:
	defb 008h, 000h         ; 8 -> 0
	defb 009h, 001h         ; 9 -> 1
	defb 0ffh               ; end
links_ad99:
	defb 000h, 008h         ; 0 -> 8
	defb 001h, 009h         ; 1 -> 9
	defb 002h, 00ah         ; 2 -> 10
	defb 0ffh               ; end
links_ada0:
	defb 008h, 000h         ; 8 -> 0
	defb 009h, 001h         ; 9 -> 1
	defb 00ah, 002h         ; 10 -> 2
	defb 0ffh               ; end
links_ada7:
	defb 000h, 002h         ; 0 -> 2
	defb 008h, 00ah         ; 8 -> 10
	defb 0ffh               ; end
links_adac:
	defb 002h, 000h         ; 2 -> 0
	defb 00ah, 008h         ; 10 -> 8
	defb 0ffh               ; end
links_adb1:
	defb 002h, 00ah         ; 2 -> 10
	defb 0ffh               ; end
links_adb4:
	defb 00ah, 002h         ; 10 -> 2
	defb 0ffh               ; end
links_adb7:
	defb 000h, 008h         ; 0 -> 8
	defb 009h, 009h         ; 9 -> 9
	defb 0ffh               ; end
links_adbc:
	defb 008h, 000h         ; 8 -> 0
	defb 009h, 009h         ; 9 -> 9
	defb 0ffh               ; end
links_adc1:
	defb 000h, 001h         ; 0 -> 1
	defb 008h, 009h         ; 8 -> 9
	defb 0ffh               ; end
links_adc6:
	defb 001h, 000h         ; 1 -> 0
	defb 009h, 008h         ; 9 -> 8
	defb 0ffh               ; end
links_adcb:                       ; pyramid lists sharing ADCB
	defb 000h, 000h         ; 0 -> 0
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
