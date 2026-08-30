; packed-PSG channel streams in bank 05 (0x8000–0xA000).
; Opens with the tail of ch_7fd7; ch_9ffa continues into bank 06.

; tail of ch_7fd7 (crosses 0x8000)
	defb 070h, 070h, 0b1h, 0d1h, 001h, 023h, 001h, 0d2h
	defb 0b1h, 085h, 0d8h, 04ch, 081h, 0d8h, 05ch, 076h
	defb 0e9h, 005h, 0c0h, 0d7h, 0e9h, 005h, 0ebh, 0c7h
	defb 060h, 0d2h, 0c2h, 0e9h, 00ah, 070h, 070h, 070h
	defb 0b1h, 0d1h, 001h, 023h, 001h, 0d2h, 0b1h, 085h
	defb 081h, 077h, 0c0h, 070h, 070h, 070h, 0b1h, 0d1h
	defb 001h, 023h, 001h, 0d2h, 0b1h, 085h, 0d1h, 001h
	defb 0d2h, 076h, 0e9h, 005h, 0c0h, 0e9h, 00ah, 0eah
	defb 009h, 0ebh, 037h, 025h, 0eeh, 001h, 0d1h, 0c0h
	defb 0a0h, 0a0h, 0a0h, 0a1h, 0a0h, 0a0h, 0a1h, 0ebh
	defb 017h, 020h, 0d0h, 005h, 0eah, 005h, 000h, 0eah
	defb 009h, 0ebh, 037h, 025h, 0d1h, 0a0h, 0a0h, 0a0h
	defb 0a0h, 0a0h, 0a0h, 0a0h, 0a1h, 0ebh, 017h, 020h
	defb 095h, 0eah, 005h, 090h, 0eah, 009h, 0ebh, 037h
	defb 025h, 0a0h, 0a0h, 0a0h, 0a1h, 0a0h, 0a0h, 0a0h
	defb 0d0h, 000h, 001h, 000h, 0d1h, 0a0h, 0a1h, 0a0h
	defb 090h, 0ebh, 027h, 010h, 093h, 0eah, 005h, 091h
	defb 0fdh, 0d7h, 07fh, 0d2h, 0c0h, 070h, 070h, 070h
	defb 0b1h, 0d1h, 001h, 023h, 001h, 0d2h, 0b1h, 085h
	defb 0d8h, 0bch, 081h, 0d8h, 05ch, 077h, 0d7h, 0fah

ch_80a0:                            ; 0x80A0
	defb 0feh, 004h, 0e9h, 00eh, 0d0h, 090h, 000h, 000h
	defb 090h, 090h, 000h, 030h, 000h, 0fbh, 008h, 0a5h
	defb 080h, 090h, 000h, 000h, 090h, 090h, 000h, 030h
	defb 000h, 0fbh, 004h, 0b1h, 080h, 090h, 000h, 000h
	defb 090h, 090h, 000h, 030h, 000h, 0fbh, 008h, 0bdh
	defb 080h, 090h, 000h, 000h, 090h, 090h, 000h, 030h
	defb 000h, 0fbh, 004h, 0c9h, 080h, 0fdh, 0a0h, 080h

ch_80d8:                            ; 0x80D8
	defb 0feh, 001h, 0eeh, 001h, 0f2h, 00ah, 0f1h, 047h
	defb 0eah, 007h, 0edh, 005h, 0ebh, 081h, 023h, 0e9h
	defb 007h, 0c0h, 0e9h, 00eh, 0d1h, 004h, 0e9h, 001h
	defb 0d2h, 0a4h, 0d1h, 003h, 0d2h, 0a3h, 0e9h, 007h
	defb 090h, 0c0h, 070h, 0c0h, 067h, 0e9h, 002h, 03ah
	defb 06ah, 0e9h, 001h, 07ch, 0e9h, 007h, 005h, 040h
	defb 0c0h, 075h, 090h, 0c0h, 0a0h, 0c0h, 090h, 0c0h
	defb 070h, 0c0h, 050h, 0c0h, 043h, 002h, 0fbh, 002h
	defb 0e7h, 080h, 0eeh, 001h, 0f2h, 00ah, 0f1h, 047h
	defb 0eah, 007h, 0edh, 005h, 0ebh, 081h, 023h, 0e9h
	defb 007h, 0c0h, 0e9h, 00eh, 0d1h, 035h, 030h, 020h
	defb 002h, 0e9h, 001h, 0d2h, 0a4h, 0d1h, 004h, 0d2h
	defb 0a3h, 0e9h, 007h, 093h, 070h, 0c0h, 060h, 0c0h
	defb 0a0h, 0c0h, 0a0h, 0c0h, 090h, 0c0h, 090h, 0c0h
	defb 070h, 0c0h, 070h, 0c0h, 090h, 0c0h, 090h, 0c0h
	defb 002h, 030h, 060h, 0c0h, 070h, 0c0h, 090h, 0c2h
	defb 0a0h, 0c1h, 0f8h, 00dh, 0f2h, 007h, 0f1h, 047h
	defb 0eah, 008h, 0edh, 004h, 0e9h, 007h, 0eeh, 001h
	defb 0ebh, 081h, 013h, 0c0h, 0d1h, 000h, 0d2h, 0a0h
	defb 0d1h, 000h, 0d2h, 0a0h, 090h, 070h, 060h, 030h
	defb 020h, 030h, 060h, 070h, 090h, 070h, 060h, 030h
	defb 000h, 040h, 070h, 090h, 0a0h, 090h, 0a0h, 0d1h
	defb 000h, 030h, 000h, 0d2h, 0a0h, 090h, 070h, 050h
	defb 040h, 000h, 070h, 090h, 0a0h, 090h, 070h, 050h
	defb 040h, 000h, 0d1h, 020h, 000h, 020h, 030h, 020h
	defb 030h, 020h, 000h, 0d2h, 090h, 070h, 0d1h, 000h
	defb 000h, 0d2h, 0a0h, 0a0h, 090h, 090h, 070h, 070h
	defb 000h, 030h, 060h, 070h, 090h, 0fbh, 002h, 06bh
	defb 081h, 0eeh, 001h, 0f2h, 00ah, 0f1h, 047h, 0eah
	defb 007h, 0edh, 005h, 0ebh, 081h, 023h, 0e9h, 007h
	defb 0c0h, 0e9h, 00eh, 0d1h, 035h, 030h, 020h, 002h
	defb 0e9h, 001h, 0d2h, 0a4h, 0d1h, 004h, 0d2h, 0a3h
	defb 0e9h, 007h, 093h, 070h, 0c0h, 060h, 0c0h, 0a0h
	defb 0c0h, 0a0h, 0c0h, 090h, 0c0h, 090h, 0c0h, 070h
	defb 0c0h, 070h, 0c0h, 090h, 0c0h, 090h, 0c0h, 070h
	defb 0c0h, 070h, 0c0h, 060h, 0c0h, 060h, 0c0h, 030h
	defb 0c0h, 030h, 0c0h, 060h, 0c0h, 060h, 0fdh, 0d8h
	defb 080h

ch_8201:                            ; 0x8201
	defb 0feh, 001h, 0f8h, 023h, 0eah, 00dh, 0e9h, 007h
	defb 0ebh, 077h, 0f4h, 0d4h, 002h, 0ebh, 077h, 0fdh
	defb 040h, 071h, 091h, 0a1h, 091h, 071h, 041h, 0fbh
	defb 008h, 009h, 082h, 0f8h, 023h, 0eah, 00dh, 0e9h
	defb 007h, 0ebh, 077h, 0f4h, 0d5h, 052h, 090h, 0d4h
	defb 001h, 021h, 031h, 021h, 001h, 0d5h, 091h, 0fbh
	defb 004h, 025h, 082h, 0f8h, 023h, 0eah, 00dh, 0e9h
	defb 007h, 0ebh, 077h, 0f4h, 0d4h, 002h, 040h, 071h
	defb 091h, 0a1h, 091h, 071h, 041h, 0fbh, 008h, 03dh
	defb 082h, 0f8h, 023h, 0eah, 00dh, 0e9h, 007h, 0ebh
	defb 077h, 0f4h, 0d5h, 052h, 090h, 0d4h, 001h, 021h
	defb 031h, 021h, 001h, 0d5h, 091h, 0fbh, 004h, 053h
	defb 082h, 0fdh, 001h, 082h

ch_8265:                            ; 0x8265
	defb 0feh, 001h, 0f8h, 025h, 0f2h, 009h, 0f1h, 047h
	defb 0e9h, 00eh, 0eah, 00ah, 0ebh, 051h, 031h, 0d8h
	defb 0a5h, 0d3h, 0c0h, 071h, 070h, 0d2h, 000h, 0d3h
	defb 071h, 070h, 060h, 071h, 071h, 073h, 071h, 070h
	defb 0d2h, 000h, 0d3h, 071h, 070h, 040h, 071h, 071h
	defb 072h, 0fbh, 002h, 076h, 082h, 0f8h, 025h, 0f2h
	defb 009h, 0f1h, 047h, 0e9h, 00eh, 0eah, 009h, 0ebh
	defb 051h, 021h, 0d8h, 0a5h, 0d2h, 0c0h, 000h, 0c0h
	defb 000h, 030h, 000h, 0c0h, 000h, 0d3h, 0a0h, 0d2h
	defb 000h, 0c0h, 000h, 0c0h, 000h, 0c1h, 0eah, 007h
	defb 0d7h, 0f8h, 00dh, 0ebh, 081h, 023h, 0edh, 002h
	defb 0d3h, 071h, 051h, 031h, 051h, 0e9h, 007h, 0ebh
	defb 081h, 043h, 0edh, 007h, 002h, 030h, 060h, 0c0h
	defb 070h, 0c0h, 090h, 0c2h, 0ech, 0f8h, 025h, 0eah
	defb 007h, 0d2h, 031h, 0e9h, 002h, 020h, 010h, 000h
	defb 0eah, 006h, 0d3h, 0b0h, 0a0h, 0eah, 004h, 090h
	defb 080h, 0f8h, 025h, 0f2h, 009h, 0f1h, 057h, 0e9h
	defb 00eh, 0eah, 009h, 0ebh, 051h, 021h, 0d8h, 0a5h
	defb 0d3h, 0c0h, 001h, 041h, 071h, 091h, 0a0h, 0a0h
	defb 090h, 072h, 040h, 0c0h, 0a0h, 0a0h, 090h, 071h
	defb 040h, 070h, 0e9h, 007h, 0ebh, 074h, 027h, 000h
	defb 0c0h, 000h, 0c0h, 040h, 0c0h, 040h, 0c0h, 070h
	defb 0c0h, 070h, 0c0h, 090h, 0c0h, 090h, 0c0h, 0e9h
	defb 00eh, 0eah, 009h, 0ebh, 051h, 021h, 0e9h, 00eh
	defb 0a4h, 0e9h, 001h, 094h, 0a4h, 093h, 0ebh, 074h
	defb 027h, 0e9h, 007h, 070h, 0c0h, 050h, 0c0h, 0ebh
	defb 051h, 021h, 075h, 051h, 047h, 0e9h, 00eh, 0eah
	defb 009h, 0d8h, 0a5h, 0ebh, 051h, 073h, 0d1h, 0c0h
	defb 000h, 0c0h, 000h, 030h, 000h, 0c0h, 000h, 0d2h
	defb 0a0h, 0d1h, 000h, 0c0h, 000h, 0c0h, 0e9h, 007h
	defb 0eah, 007h, 0d3h, 090h, 0d2h, 000h, 030h, 040h
	defb 060h, 070h, 0f8h, 025h, 0f2h, 003h, 0f1h, 047h
	defb 0e9h, 00eh, 0eah, 009h, 0ebh, 051h, 021h, 0d2h
	defb 0c0h, 000h, 0c0h, 000h, 030h, 000h, 0c0h, 000h
	defb 0d3h, 0a0h, 0d2h, 000h, 0c0h, 000h, 0c0h, 000h
	defb 0c2h, 000h, 0c0h, 000h, 030h, 000h, 0c0h, 000h
	defb 0d3h, 0a0h, 0a0h, 090h, 090h, 070h, 070h, 090h
	defb 090h, 0fdh, 065h, 082h

ch_8391:                            ; 0x8391
	defb 0feh, 001h, 0f8h, 00dh, 0f2h, 00ah, 0f1h, 047h
	defb 0eah, 00ah, 0edh, 007h, 0ebh, 081h, 043h, 0e9h
	defb 00eh, 0d1h, 004h, 0e9h, 001h, 0d2h, 0a4h, 0d1h
	defb 003h, 0d2h, 0a3h, 0e9h, 007h, 090h, 0c0h, 070h
	defb 0c0h, 067h, 0e9h, 002h, 03ah, 06ah, 0e9h, 001h
	defb 07ch, 0e9h, 007h, 005h, 040h, 0c0h, 075h, 090h
	defb 0c0h, 0a0h, 0c0h, 090h, 0c0h, 070h, 0c0h, 050h
	defb 0c0h, 043h, 003h, 0fbh, 002h, 0a0h, 083h, 0f8h
	defb 00dh, 0f2h, 00ah, 0f1h, 047h, 0eah, 00ah, 0edh
	defb 007h, 0ebh, 081h, 043h, 0e9h, 00eh, 0d1h, 035h
	defb 030h, 020h, 002h, 0e9h, 001h, 0d2h, 0a4h, 0d1h
	defb 004h, 0d2h, 0a3h, 0e9h, 007h, 093h, 070h, 0c0h
	defb 060h, 0c0h, 0a0h, 0c0h, 0a0h, 0c0h, 090h, 0c0h
	defb 090h, 0c0h, 070h, 0c0h, 070h, 0c0h, 090h, 0c0h
	defb 090h, 0c0h, 002h, 030h, 060h, 0c0h, 070h, 0c0h
	defb 090h, 0c2h, 0a1h, 0e9h, 002h, 0ech, 0eah, 007h
	defb 090h, 080h, 070h, 0eah, 006h, 060h, 050h, 0eah
	defb 004h, 040h, 030h, 0f8h, 00dh, 0f2h, 007h, 0f1h
	defb 047h, 0eah, 00ch, 0edh, 006h, 0e9h, 007h, 0ebh
	defb 081h, 043h, 0d1h, 000h, 0d2h, 0a0h, 0d1h, 000h
	defb 0d2h, 0a0h, 090h, 070h, 060h, 030h, 020h, 030h
	defb 060h, 070h, 090h, 070h, 060h, 030h, 000h, 040h
	defb 070h, 090h, 0a0h, 090h, 0a0h, 0d1h, 000h, 030h
	defb 000h, 0d2h, 0a0h, 090h, 070h, 050h, 040h, 000h
	defb 070h, 090h, 0a0h, 090h, 070h, 050h, 040h, 000h
	defb 0d1h, 020h, 000h, 020h, 030h, 020h, 030h, 020h
	defb 000h, 0d2h, 090h, 070h, 0edh, 004h, 0d1h, 000h
	defb 000h, 0d2h, 0a0h, 0a0h, 090h, 090h, 070h, 070h
	defb 0edh, 006h, 000h, 030h, 060h, 070h, 090h, 0a0h
	defb 0fbh, 002h, 02bh, 084h, 0f8h, 00dh, 0f2h, 00ah
	defb 0f1h, 047h, 0eah, 00ah, 0edh, 007h, 0ebh, 081h
	defb 043h, 0e9h, 00eh, 0d1h, 035h, 030h, 020h, 002h
	defb 0e9h, 001h, 0d2h, 0a4h, 0d1h, 004h, 0d2h, 0a3h
	defb 0e9h, 007h, 093h, 070h, 0c0h, 060h, 0c0h, 0a0h
	defb 0c0h, 0a0h, 0c0h, 090h, 0c0h, 090h, 0c0h, 070h
	defb 0c0h, 070h, 0c0h, 090h, 0c0h, 090h, 0c0h, 070h
	defb 0c0h, 070h, 0c0h, 060h, 0c0h, 060h, 0c0h, 030h
	defb 0c0h, 030h, 0c0h, 060h, 0c0h, 060h, 0c0h, 0fdh
	defb 091h, 083h

ch_84c3:                            ; 0x84C3
	defb 0feh, 001h, 0f2h, 00ah, 0f1h, 047h, 0eah, 00ah
	defb 0edh, 007h, 0ebh, 081h, 043h, 0e9h, 00eh, 0d2h
	defb 074h, 0e9h, 001h, 054h, 073h, 053h, 0e9h, 007h
	defb 040h, 0c0h, 020h, 0c0h, 017h, 0e9h, 002h, 0d3h
	defb 0aah, 0d2h, 01ah, 0e9h, 001h, 02ch, 0e9h, 007h
	defb 0d3h, 075h, 0d2h, 000h, 0c0h, 045h, 050h, 0c0h
	defb 070h, 0c0h, 050h, 0c0h, 040h, 0c0h, 020h, 0c0h
	defb 003h, 0d3h, 073h, 0e9h, 00eh, 0d2h, 074h, 0e9h
	defb 001h, 054h, 073h, 053h, 0e9h, 007h, 040h, 0c0h
	defb 020h, 0c0h, 017h, 0e9h, 002h, 0d3h, 0aah, 0d2h
	defb 01ah, 0e9h, 001h, 02ch, 0e9h, 007h, 045h, 070h
	defb 0c0h, 0a5h, 0d1h, 000h, 0c0h, 020h, 0c0h, 000h
	defb 0c0h, 0d2h, 0a0h, 0c0h, 090h, 0c0h, 073h, 043h
	defb 0f2h, 00ah, 0f1h, 047h, 0eah, 00ah, 0edh, 007h
	defb 0ebh, 081h, 043h, 0e9h, 00eh, 0d1h, 005h, 000h
	defb 0d2h, 0a0h, 092h, 0e9h, 001h, 074h, 094h, 073h
	defb 0e9h, 007h, 063h, 030h, 0c0h, 020h, 0c0h, 0e9h
	defb 007h, 0d2h, 070h, 0c0h, 070h, 0c0h, 050h, 0c0h
	defb 050h, 0c0h, 030h, 0c0h, 030h, 0c0h, 050h, 0c0h
	defb 050h, 0c0h, 0d3h, 072h, 0a0h, 0d2h, 010h, 0c0h
	defb 020h, 0c0h, 050h, 0c2h, 061h, 0e9h, 002h, 0ech
	defb 0eah, 006h, 050h, 040h, 030h, 0eah, 005h, 020h
	defb 010h, 0eah, 004h, 000h, 0d3h, 0b0h, 0f2h, 007h
	defb 0f1h, 047h, 0eah, 004h, 0edh, 002h, 0e9h, 007h
	defb 0ebh, 081h, 010h, 0c1h, 0d1h, 000h, 0d2h, 0a0h
	defb 0d1h, 000h, 0d2h, 0a0h, 090h, 070h, 060h, 030h
	defb 020h, 030h, 060h, 070h, 090h, 070h, 060h, 030h
	defb 000h, 040h, 070h, 090h, 0a0h, 090h, 0a0h, 0d1h
	defb 000h, 030h, 000h, 0d2h, 0a0h, 090h, 070h, 050h
	defb 040h, 000h, 070h, 090h, 0a0h, 090h, 070h, 050h
	defb 040h, 000h, 0d1h, 020h, 000h, 020h, 030h, 020h
	defb 030h, 020h, 000h, 0d2h, 090h, 070h, 0edh, 001h
	defb 0d1h, 000h, 000h, 0d2h, 0a0h, 0a0h, 090h, 090h
	defb 070h, 070h, 0edh, 002h, 000h, 030h, 060h, 070h
	defb 0fbh, 002h, 086h, 085h, 0f2h, 00ah, 0f1h, 047h
	defb 0eah, 00ah, 0edh, 007h, 0ebh, 081h, 043h, 0e9h
	defb 00eh, 0d1h, 005h, 000h, 0d2h, 0a0h, 092h, 0e9h
	defb 001h, 074h, 094h, 073h, 0e9h, 007h, 063h, 030h
	defb 0c0h, 020h, 0c0h, 070h, 0c0h, 070h, 0c0h, 060h
	defb 0c0h, 060h, 0c0h, 030h, 0c0h, 030h, 0c0h, 060h
	defb 0c0h, 060h, 0c0h, 0a0h, 0c0h, 0a0h, 0c0h, 090h
	defb 0c0h, 090h, 0c0h, 070h, 0c0h, 070h, 0c0h, 090h
	defb 0c0h, 090h, 0c0h, 0fdh, 0c3h, 084h

ch_8619:                            ; 0x8619
	defb 0feh, 004h, 0d0h, 0e9h, 009h, 090h, 0e9h, 001h
	defb 003h, 004h, 0e9h, 009h, 000h, 000h, 000h, 000h
	defb 030h, 030h, 091h, 011h, 001h, 010h, 090h, 000h
	defb 000h, 011h, 090h, 000h, 011h, 0fbh, 004h, 02bh
	defb 086h, 091h, 011h, 001h, 010h, 090h, 000h, 000h
	defb 011h, 090h, 000h, 011h, 0fbh, 004h, 03ah, 086h
	defb 091h, 011h, 001h, 010h, 090h, 000h, 000h, 011h
	defb 090h, 000h, 011h, 0fbh, 004h, 049h, 086h, 0fdh
	defb 02bh, 086h

ch_865b:                            ; 0x865B
	defb 0feh, 001h, 0e9h, 009h, 0eah, 00ah, 0ebh, 047h
	defb 088h, 0d5h, 090h, 0b0h, 0d4h, 000h, 030h, 040h
	defb 030h, 000h, 0d5h, 0b0h, 0d5h, 0a1h, 0d4h, 0a0h
	defb 0a0h, 0fbh, 008h, 06fh, 086h, 0d5h, 091h, 0d4h
	defb 090h, 090h, 0fbh, 008h, 078h, 086h, 0d5h, 0a1h
	defb 0d4h, 0a0h, 0a0h, 0fbh, 008h, 081h, 086h, 0d5h
	defb 091h, 0d4h, 090h, 090h, 0fbh, 008h, 08ah, 086h
	defb 0d5h, 0a1h, 0d4h, 0a0h, 0a0h, 0fbh, 008h, 093h
	defb 086h, 0d5h, 091h, 0d4h, 090h, 090h, 0fbh, 008h
	defb 09ch, 086h, 0fdh, 06fh, 086h

ch_86a8:                            ; 0x86A8
	defb 0feh, 001h, 0f8h, 00dh, 0e9h, 009h, 0eah, 00ah
	defb 0ebh, 077h, 088h, 0d4h, 090h, 0b0h, 0d3h, 000h
	defb 030h, 040h, 030h, 000h, 0d4h, 0b0h, 0f8h, 009h
	defb 0e9h, 009h, 0eah, 00bh, 0ebh, 047h, 088h, 0d4h
	defb 0a1h, 0d3h, 0a0h, 0a0h, 0fbh, 008h, 0c7h, 086h
	defb 0d4h, 091h, 0d3h, 090h, 090h, 0fbh, 008h, 0d0h
	defb 086h, 0f8h, 009h, 0e9h, 009h, 0eah, 00bh, 0ebh
	defb 047h, 088h, 0d4h, 0a1h, 0d3h, 0a0h, 0a0h, 0fbh
	defb 008h, 0e2h, 086h, 0d4h, 091h, 0d3h, 090h, 090h
	defb 0fbh, 008h, 0ebh, 086h, 0f8h, 009h, 0e9h, 009h
	defb 0eah, 00bh, 0ebh, 047h, 088h, 0d4h, 0a1h, 0d3h
	defb 0a0h, 0a0h, 0fbh, 008h, 0fdh, 086h, 0d4h, 091h
	defb 0d3h, 090h, 090h, 0fbh, 008h, 006h, 087h, 0fdh
	defb 0beh, 086h

ch_8712:                            ; 0x8712
	defb 0feh, 001h, 0f8h, 007h, 0e9h, 009h, 0eah, 00ah
	defb 0ebh, 067h, 0f6h, 0d3h, 090h, 0b0h, 0d2h, 000h
	defb 030h, 040h, 030h, 000h, 0d3h, 0b0h, 0f8h, 009h
	defb 0e9h, 009h, 0eah, 008h, 0ebh, 03eh, 0ceh, 0d3h
	defb 080h, 050h, 0a0h, 050h, 0d2h, 000h, 0d3h, 0a0h
	defb 080h, 050h, 0fbh, 004h, 032h, 087h, 070h, 040h
	defb 090h, 040h, 0b0h, 090h, 070h, 040h, 0fbh, 004h
	defb 040h, 087h, 0f8h, 009h, 0e9h, 009h, 0eah, 008h
	defb 0ebh, 03eh, 0ceh, 0d1h, 000h, 0d2h, 0a0h, 0d1h
	defb 020h, 0d2h, 0a0h, 0d1h, 040h, 020h, 000h, 0d2h
	defb 0a0h, 0fbh, 004h, 055h, 087h, 0d1h, 000h, 0d2h
	defb 090h, 0d1h, 020h, 0d2h, 090h, 0d1h, 040h, 020h
	defb 000h, 0d2h, 090h, 0fbh, 004h, 067h, 087h, 0f8h
	defb 007h, 0e9h, 009h, 0eah, 00bh, 0ebh, 067h, 0f6h
	defb 0f1h, 035h, 0f2h, 015h, 0d8h, 0d4h, 0d1h, 005h
	defb 0d7h, 0f0h, 0f1h, 076h, 001h, 0f0h, 0d2h, 071h
	defb 051h, 041h, 051h, 0d1h, 001h, 0f1h, 076h, 001h
	defb 0f0h, 0d2h, 071h, 051h, 0eah, 008h, 0f8h, 01ah
	defb 0d2h, 090h, 0a0h, 0d1h, 000h, 040h, 050h, 040h
	defb 000h, 0d2h, 0a0h, 0eah, 00bh, 0f8h, 007h, 0f1h
	defb 035h, 0f2h, 015h, 0d8h, 0d4h, 0d1h, 005h, 0d7h
	defb 0f0h, 0f1h, 076h, 001h, 0f0h, 0d2h, 071h, 071h
	defb 041h, 071h, 0d1h, 001h, 0f1h, 076h, 001h, 0f0h
	defb 0d2h, 071h, 061h, 0d3h, 090h, 0b0h, 0d2h, 000h
	defb 030h, 040h, 030h, 000h, 0d3h, 0b0h, 0fdh, 028h
	defb 087h

ch_87db:                            ; 0x87DB
	defb 0feh, 001h, 0f8h, 007h, 0e9h, 009h, 0eah, 00ah
	defb 0edh, 002h, 0ebh, 067h, 0f6h, 0d2h, 090h, 0b0h
	defb 0d1h, 000h, 030h, 040h, 030h, 000h, 0d2h, 0b0h
	defb 0f8h, 009h, 0e9h, 009h, 0eah, 009h, 0ebh, 03eh
	defb 0ceh, 0d2h, 080h, 050h, 0a0h, 050h, 0d1h, 000h
	defb 0d2h, 0a0h, 080h, 050h, 0fbh, 004h, 0fdh, 087h
	defb 070h, 040h, 090h, 040h, 0b0h, 090h, 070h, 040h
	defb 0fbh, 004h, 00bh, 088h, 0f8h, 009h, 0e9h, 009h
	defb 0eah, 009h, 0ebh, 03eh, 0ceh, 0d2h, 080h, 050h
	defb 0a0h, 050h, 0d1h, 000h, 0d2h, 0a0h, 080h, 050h
	defb 0fbh, 004h, 021h, 088h, 070h, 040h, 090h, 040h
	defb 0b0h, 090h, 070h, 040h, 0fbh, 004h, 02fh, 088h
	defb 0f8h, 007h, 0e9h, 009h, 0eah, 00bh, 0edh, 002h
	defb 0ebh, 0d5h, 053h, 0d8h, 0d4h, 0f1h, 035h, 0f2h
	defb 015h, 0d1h, 055h, 0d7h, 0f0h, 0f1h, 076h, 041h
	defb 0f0h, 001h, 0d2h, 0a1h, 091h, 0a1h, 0d1h, 051h
	defb 0f1h, 076h, 041h, 0f0h, 001h, 0d2h, 0a1h, 090h
	defb 0a0h, 0d1h, 000h, 040h, 050h, 040h, 000h, 0d2h
	defb 0a0h, 0f1h, 035h, 0f2h, 015h, 0d8h, 0d4h, 0d1h
	defb 045h, 0d7h, 0f0h, 0f1h, 076h, 031h, 0f0h, 001h
	defb 0d2h, 0b1h, 091h, 0b1h, 0d1h, 041h, 0f1h, 076h
	defb 031h, 0f0h, 001h, 0d2h, 0b1h, 090h, 0b0h, 0d1h
	defb 000h, 030h, 040h, 030h, 000h, 0d2h, 0b0h, 0fdh
	defb 0f3h, 087h

ch_8895:                            ; 0x8895
	defb 0feh, 001h, 0eeh, 002h, 0e9h, 001h, 0eah, 009h
	defb 0edh, 004h, 0ebh, 067h, 0f9h, 0d2h, 0c4h, 0e9h
	defb 009h, 090h, 0b0h, 0d1h, 000h, 030h, 040h, 030h
	defb 000h, 0e9h, 001h, 0d2h, 0b3h, 0efh, 0e9h, 001h
	defb 0eeh, 001h, 0eah, 008h, 0ebh, 03eh, 0ceh, 0d2h
	defb 0c1h, 0e9h, 009h, 080h, 050h, 0a0h, 050h, 0d1h
	defb 000h, 0d2h, 0a0h, 080h, 050h, 0fbh, 004h, 0c0h
	defb 088h, 070h, 040h, 090h, 040h, 0b0h, 090h, 070h
	defb 040h, 0fbh, 003h, 0ceh, 088h, 070h, 040h, 090h
	defb 040h, 0b0h, 090h, 070h, 0e9h, 001h, 046h, 0e9h
	defb 001h, 0eeh, 001h, 0eah, 009h, 0ebh, 03eh, 0ceh
	defb 0d2h, 0c1h, 0e9h, 009h, 080h, 050h, 0a0h, 050h
	defb 0d1h, 000h, 0d2h, 0a0h, 080h, 050h, 0fbh, 004h
	defb 0f1h, 088h, 070h, 040h, 090h, 040h, 0b0h, 090h
	defb 070h, 040h, 0fbh, 003h, 0ffh, 088h, 070h, 040h
	defb 090h, 040h, 0b0h, 090h, 070h, 0e9h, 001h, 046h
	defb 0eeh, 002h, 0e9h, 001h, 0eah, 00ah, 0edh, 004h
	defb 0ebh, 0c5h, 053h, 0d1h, 0c4h, 0f1h, 035h, 0f2h
	defb 015h, 0e9h, 009h, 055h, 0f0h, 0f1h, 076h, 041h
	defb 0f0h, 001h, 0d2h, 0a1h, 091h, 0a1h, 0d1h, 051h
	defb 0f1h, 076h, 041h, 0f0h, 001h, 0d2h, 0a1h, 090h
	defb 0a0h, 0d1h, 000h, 040h, 050h, 040h, 000h, 0d2h
	defb 0a0h, 0f1h, 035h, 0f2h, 015h, 0d1h, 045h, 0f0h
	defb 0f1h, 076h, 031h, 0f0h, 001h, 0d2h, 0b1h, 091h
	defb 0b1h, 0d1h, 041h, 0f1h, 076h, 031h, 0f0h, 001h
	defb 0d2h, 0b1h, 090h, 0b0h, 0d1h, 000h, 030h, 040h
	defb 030h, 000h, 0e9h, 001h, 0d2h, 0b3h, 0efh, 0fdh
	defb 0b3h, 088h

ch_896f:                            ; 0x896F
	defb 0feh, 004h, 0e9h, 009h, 0d0h, 090h, 000h, 030h
	defb 000h, 090h, 010h, 030h, 000h, 090h, 000h, 030h
	defb 000h, 090h, 000h, 030h, 010h, 0fbh, 004h, 074h
	defb 089h, 090h, 000h, 030h, 000h, 090h, 010h, 030h
	defb 000h, 090h, 000h, 030h, 000h, 010h, 030h, 090h
	defb 010h, 0fbh, 008h, 088h, 089h, 090h, 000h, 010h
	defb 090h, 030h, 000h, 090h, 000h, 000h, 010h, 030h
	defb 090h, 000h, 010h, 030h, 000h, 0fbh, 004h, 09ch
	defb 089h, 0fch, 002h, 088h, 089h, 0fdh, 06fh, 089h

ch_89b7:                            ; 0x89B7
	defb 0feh, 001h, 0f8h, 009h, 0f2h, 009h, 0f1h, 057h
	defb 0e9h, 009h, 0c0h, 0eeh, 001h, 0eah, 008h, 0edh
	defb 004h, 0ebh, 082h, 020h, 0d8h, 07fh, 0d3h, 0b1h
	defb 0d7h, 090h, 0b0h, 0d2h, 001h, 0d3h, 0b0h, 0d2h
	defb 000h, 0d8h, 0e6h, 023h, 003h, 0d7h, 0d3h, 0b1h
	defb 090h, 0b0h, 0d2h, 001h, 0d3h, 0b0h, 0d2h, 000h
	defb 0d8h, 0e6h, 033h, 042h, 0fbh, 002h, 0c1h, 089h
	defb 0d7h, 0f8h, 003h, 0f2h, 008h, 0f1h, 058h, 0e9h
	defb 009h, 0c1h, 0eah, 006h, 0edh, 004h, 0ebh, 081h
	defb 013h, 0d2h, 045h, 050h, 080h, 095h, 080h, 090h
	defb 0b1h, 0e9h, 006h, 090h, 0b0h, 090h, 0e9h, 009h
	defb 041h, 051h, 043h, 013h, 045h, 050h, 080h, 095h
	defb 080h, 090h, 0b1h, 0e9h, 006h, 090h, 0b0h, 090h
	defb 0e9h, 009h, 081h, 051h, 043h, 011h, 0fbh, 002h
	defb 0f8h, 089h, 0eeh, 001h, 0f2h, 007h, 0f1h, 049h
	defb 0c1h, 0eah, 006h, 0edh, 004h, 0ebh, 081h, 021h
	defb 0d3h, 046h, 0d2h, 030h, 040h, 050h, 090h, 080h
	defb 051h, 040h, 050h, 0d3h, 046h, 0d2h, 080h, 050h
	defb 040h, 020h, 010h, 003h, 0d3h, 046h, 0d2h, 030h
	defb 040h, 050h, 090h, 080h, 051h, 040h, 050h, 0d3h
	defb 046h, 0d2h, 030h, 040h, 050h, 090h, 050h, 0a0h
	defb 090h, 0fch, 002h, 0f0h, 089h, 0fdh, 0b7h, 089h

ch_8a67:                            ; 0x8A67
	defb 0feh, 001h, 0f8h, 014h, 0eah, 00fh, 0e9h, 009h
	defb 0ebh, 067h, 0f5h, 0d5h, 043h, 053h, 083h, 053h
	defb 043h, 053h, 083h, 0b3h, 043h, 053h, 083h, 053h
	defb 043h, 053h, 083h, 0b1h, 0d4h, 000h, 0d5h, 0b0h
	defb 0eah, 00eh, 0d5h, 0e9h, 009h, 093h, 091h, 041h
	defb 091h, 043h, 041h, 093h, 091h, 041h, 091h, 043h
	defb 0e9h, 006h, 040h, 050h, 080h, 0fbh, 004h, 08ah
	defb 08ah, 0eah, 00eh, 0e9h, 009h, 0d5h, 043h, 041h
	defb 011h, 0c1h, 0d4h, 010h, 010h, 020h, 020h, 011h
	defb 0d5h, 043h, 041h, 011h, 0c1h, 081h, 0c1h, 081h
	defb 0fbh, 002h, 0a4h, 08ah, 0fch, 002h, 087h, 08ah
	defb 0fdh, 067h, 08ah

ch_8ac2:                            ; 0x8AC2
	defb 0feh, 001h, 0f8h, 009h, 0f2h, 009h, 0f1h, 057h
	defb 0e9h, 009h, 0eah, 008h, 0edh, 004h, 0ebh, 082h
	defb 052h, 0d8h, 07fh, 0d3h, 0b1h, 0d7h, 090h, 0b0h
	defb 0d2h, 001h, 0d3h, 0b0h, 0d2h, 000h, 0d8h, 0e6h
	defb 023h, 003h, 0d7h, 0d3h, 0b1h, 090h, 0b0h, 0d2h
	defb 001h, 0d3h, 0b0h, 0d2h, 000h, 0d8h, 0e6h, 033h
	defb 043h, 0fbh, 002h, 0d3h, 08ah, 0d7h, 0f8h, 003h
	defb 0f2h, 008h, 0f1h, 058h, 0e9h, 009h, 0eah, 006h
	defb 0edh, 003h, 0ebh, 081h, 013h, 0d3h, 045h, 050h
	defb 080h, 095h, 080h, 090h, 0b1h, 0e9h, 006h, 090h
	defb 0b0h, 090h, 0e9h, 009h, 041h, 051h, 043h, 013h
	defb 045h, 050h, 080h, 095h, 080h, 090h, 0b1h, 0e9h
	defb 006h, 090h, 0b0h, 090h, 0e9h, 009h, 081h, 051h
	defb 043h, 013h, 0fbh, 002h, 007h, 08bh, 0f8h, 006h
	defb 0f2h, 007h, 0f1h, 049h, 0e9h, 009h, 0eah, 006h
	defb 0edh, 003h, 0ebh, 081h, 021h, 0d3h, 046h, 0f8h
	defb 003h, 030h, 040h, 050h, 090h, 080h, 051h, 040h
	defb 050h, 0f8h, 006h, 046h, 0f8h, 003h, 080h, 050h
	defb 040h, 020h, 010h, 003h, 0f8h, 006h, 046h, 0f8h
	defb 003h, 030h, 040h, 050h, 090h, 080h, 051h, 040h
	defb 050h, 0f8h, 006h, 046h, 0f8h, 003h, 030h, 040h
	defb 050h, 090h, 050h, 0a0h, 090h, 050h, 090h, 0fch
	defb 002h, 0f8h, 08ah, 0fdh, 0c2h, 08ah

ch_8b78:                            ; 0x8B78
	defb 0feh, 001h, 0f8h, 00dh, 0f2h, 008h, 0f1h, 048h
	defb 0e9h, 009h, 0eah, 00ah, 0edh, 006h, 0ebh, 081h
	defb 053h, 0d2h, 040h, 050h, 080h, 090h, 0b0h, 090h
	defb 0b0h, 0d1h, 000h, 021h, 0e9h, 006h, 000h, 020h
	defb 000h, 0e9h, 009h, 0d2h, 0b3h, 040h, 050h, 080h
	defb 090h, 0b0h, 090h, 0b0h, 0d1h, 000h, 021h, 0e9h
	defb 006h, 000h, 020h, 000h, 0e9h, 009h, 0d2h, 0b1h
	defb 0d1h, 041h, 0d2h, 040h, 050h, 080h, 090h, 0b0h
	defb 090h, 0b0h, 0d1h, 000h, 021h, 0e9h, 006h, 000h
	defb 020h, 000h, 0e9h, 009h, 0d2h, 0b3h, 0d2h, 040h
	defb 050h, 080h, 090h, 0b0h, 090h, 0b0h, 0d1h, 000h
	defb 020h, 030h, 040h, 030h, 001h, 0d2h, 0b0h, 080h
	defb 0f8h, 00dh, 0f2h, 007h, 0f1h, 047h, 0e9h, 009h
	defb 0eah, 00ah, 0edh, 007h, 0ebh, 081h, 043h, 0d8h
	defb 0dfh, 0d2h, 095h, 0d7h, 0e9h, 006h, 080h, 090h
	defb 080h, 0e9h, 009h, 053h, 041h, 021h, 0d8h, 0dfh
	defb 045h, 0d7h, 021h, 041h, 010h, 020h, 030h, 040h
	defb 051h, 0d8h, 0dfh, 095h, 0d7h, 0e9h, 006h, 080h
	defb 090h, 080h, 0e9h, 009h, 053h, 041h, 021h, 0d8h
	defb 0dfh, 045h, 0d7h, 021h, 010h, 020h, 010h, 0d3h
	defb 0a0h, 093h, 0fbh, 002h, 0e7h, 08bh, 0f8h, 01bh
	defb 0e9h, 009h, 0f2h, 008h, 0f1h, 041h, 0eah, 007h
	defb 0edh, 004h, 0ebh, 082h, 022h, 0d3h, 090h, 080h
	defb 090h, 080h, 041h, 050h, 080h, 090h, 080h, 090h
	defb 080h, 0d2h, 021h, 010h, 0d3h, 0a0h, 090h, 080h
	defb 090h, 080h, 041h, 050h, 080h, 090h, 080h, 050h
	defb 040h, 033h, 090h, 080h, 090h, 080h, 041h, 050h
	defb 080h, 090h, 080h, 090h, 080h, 0d2h, 021h, 010h
	defb 0d3h, 0a0h, 090h, 080h, 090h, 080h, 041h, 050h
	defb 080h, 090h, 0a0h, 0d2h, 010h, 0d3h, 0a0h, 0d2h
	defb 020h, 010h, 0d3h, 0a0h, 0d2h, 010h, 0fch, 002h
	defb 0d8h, 08bh, 0fdh, 078h, 08bh

ch_8c75:                            ; 0x8C75
	defb 0feh, 001h, 0eeh, 001h, 0f2h, 008h, 0f1h, 044h
	defb 0e9h, 009h, 0c1h, 0eah, 004h, 0edh, 002h, 0ebh
	defb 081h, 010h, 0d2h, 040h, 050h, 080h, 090h, 0b0h
	defb 090h, 0b0h, 0d1h, 000h, 021h, 0e9h, 006h, 000h
	defb 020h, 000h, 0e9h, 009h, 0d2h, 0b3h, 040h, 050h
	defb 080h, 090h, 0b0h, 090h, 0b0h, 0d1h, 000h, 021h
	defb 0e9h, 006h, 000h, 020h, 000h, 0e9h, 009h, 0d2h
	defb 0b1h, 0d1h, 041h, 0d2h, 040h, 050h, 080h, 090h
	defb 0b0h, 090h, 0b0h, 0d1h, 000h, 021h, 0e9h, 006h
	defb 000h, 020h, 000h, 0e9h, 009h, 0d2h, 0b3h, 0d2h
	defb 040h, 050h, 080h, 090h, 0b0h, 090h, 0b0h, 0d1h
	defb 000h, 020h, 030h, 040h, 030h, 001h, 0f2h, 005h
	defb 0f1h, 047h, 0e9h, 009h, 0c0h, 0eeh, 001h, 0eah
	defb 005h, 0edh, 002h, 0ebh, 081h, 010h, 0d2h, 095h
	defb 0e9h, 006h, 080h, 090h, 080h, 0e9h, 009h, 053h
	defb 041h, 021h, 045h, 021h, 041h, 010h, 020h, 030h
	defb 040h, 051h, 095h, 0e9h, 006h, 080h, 090h, 080h
	defb 0e9h, 009h, 053h, 041h, 021h, 045h, 021h, 010h
	defb 020h, 010h, 0d3h, 0a0h, 092h, 0fbh, 002h, 0d9h
	defb 08ch, 0e9h, 009h, 0c0h, 0eeh, 001h, 0eah, 004h
	defb 0edh, 002h, 0ebh, 082h, 020h, 0d3h, 090h, 080h
	defb 090h, 080h, 041h, 050h, 080h, 090h, 080h, 090h
	defb 080h, 0d2h, 021h, 010h, 0d3h, 0a0h, 090h, 080h
	defb 090h, 080h, 041h, 050h, 080h, 090h, 080h, 050h
	defb 040h, 033h, 090h, 080h, 090h, 080h, 041h, 050h
	defb 080h, 090h, 080h, 090h, 080h, 0d2h, 021h, 010h
	defb 0d3h, 0a0h, 090h, 080h, 090h, 080h, 041h, 050h
	defb 080h, 090h, 0a0h, 0d2h, 010h, 0d3h, 0a0h, 0d2h
	defb 020h, 010h, 0d3h, 0a0h, 0fch, 002h, 0d3h, 08ch
	defb 0fdh, 075h, 08ch

ch_8d60:                            ; 0x8D60
	defb 0feh, 004h, 0d0h, 0e9h, 00ch, 012h, 001h, 000h
	defb 012h, 001h, 000h, 012h, 001h, 000h, 012h, 0e9h
	defb 009h, 001h, 0fbh, 007h, 071h, 08dh, 031h, 0fbh
	defb 003h, 076h, 08dh, 0e9h, 00ch, 013h, 000h, 010h
	defb 032h, 000h, 010h, 010h, 0e9h, 00ch, 012h, 001h
	defb 000h, 012h, 001h, 000h, 012h, 001h, 000h, 012h
	defb 0e9h, 009h, 001h, 0fbh, 007h, 092h, 08dh, 031h
	defb 0fbh, 003h, 097h, 08dh, 0e9h, 00ch, 013h, 000h
	defb 010h, 032h, 000h, 000h, 010h, 0e9h, 00ch, 012h
	defb 001h, 000h, 012h, 000h, 000h, 000h, 012h, 001h
	defb 000h, 012h, 0e9h, 009h, 000h, 0fbh, 01ch, 0b4h
	defb 08dh, 0e9h, 00ch, 012h, 000h, 000h, 000h, 0e9h
	defb 00ch, 012h, 031h, 000h, 012h, 031h, 000h, 000h
	defb 011h, 031h, 000h, 012h, 0e9h, 009h, 030h, 000h
	defb 000h, 000h, 0e9h, 00ch, 012h, 031h, 000h, 012h
	defb 031h, 000h, 000h, 011h, 031h, 000h, 012h, 0e9h
	defb 009h, 031h, 011h, 0fdh, 060h, 08dh

ch_8de6:                            ; 0x8DE6
	defb 0feh, 001h, 0e9h, 009h, 0f8h, 009h, 0eah, 00ah
	defb 0ebh, 007h, 070h, 0d4h, 043h, 073h, 063h, 0b3h
	defb 0a7h, 0b3h, 0edh, 003h, 0ebh, 082h, 062h, 0edh
	defb 003h, 0eah, 007h, 0d2h, 002h, 0d3h, 0b1h, 0d2h
	defb 041h, 031h, 0eah, 008h, 091h, 081h, 0eah, 009h
	defb 0d1h, 001h, 0d2h, 0b1h, 0eah, 008h, 0d1h, 041h
	defb 030h, 0eah, 009h, 0ebh, 007h, 040h, 0d3h, 007h
	defb 0d4h, 0b1h, 0ech, 0eah, 003h, 0e9h, 003h, 0a0h
	defb 090h, 0eah, 002h, 080h, 070h, 060h, 050h, 0e9h
	defb 009h, 0c3h, 0e9h, 009h, 0f8h, 009h, 0eah, 00ah
	defb 0ebh, 007h, 070h, 0d4h, 043h, 073h, 063h, 0b3h
	defb 0a7h, 0b3h, 0edh, 003h, 0ebh, 082h, 062h, 0edh
	defb 003h, 0eah, 007h, 0d2h, 002h, 0d3h, 0b1h, 0d2h
	defb 041h, 031h, 0eah, 008h, 091h, 081h, 0eah, 009h
	defb 0d1h, 001h, 0d2h, 0b1h, 0eah, 008h, 0d1h, 041h
	defb 030h, 0eah, 009h, 0ebh, 007h, 040h, 0d4h, 0a7h
	defb 0b1h, 0ech, 0eah, 003h, 0e9h, 003h, 0a0h, 090h
	defb 0eah, 002h, 080h, 070h, 060h, 050h, 0e9h, 009h
	defb 0c3h, 0e9h, 009h, 0eah, 00ah, 0ebh, 007h, 050h
	defb 0d3h, 007h, 0d4h, 0b7h, 0a7h, 0b7h, 0eah, 007h
	defb 0ebh, 087h, 010h, 0d8h, 0a7h, 0d2h, 001h, 0d3h
	defb 0b1h, 0a1h, 0b1h, 0d2h, 001h, 0d3h, 0b1h, 0a1h
	defb 0b1h, 0d2h, 001h, 0d3h, 0b1h, 0d2h, 001h, 0d3h
	defb 0b1h, 0a5h, 0d7h, 0ech, 0e9h, 002h, 0eah, 003h
	defb 0a3h, 0e9h, 001h, 090h, 080h, 070h, 060h, 050h
	defb 040h, 030h, 020h, 010h, 000h, 0eah, 008h, 0ebh
	defb 007h, 010h, 0f1h, 052h, 0f2h, 010h, 0e9h, 004h
	defb 0d2h, 0a1h, 0bah, 0e9h, 00ch, 090h, 070h, 093h
	defb 070h, 060h, 071h, 071h, 040h, 020h, 042h, 040h
	defb 070h, 090h, 0e9h, 004h, 0d2h, 0a0h, 0bah, 0e9h
	defb 00ch, 090h, 070h, 093h, 070h, 060h, 041h, 041h
	defb 040h, 020h, 044h, 0e9h, 004h, 0c1h, 0fdh, 0e6h
	defb 08dh

ch_8ee7:                            ; 0x8EE7
	defb 0feh, 001h, 0e9h, 009h, 0f8h, 009h, 0eah, 00fh
	defb 0ebh, 061h, 034h, 0d4h, 043h, 073h, 063h, 0b3h
	defb 0a7h, 0ebh, 041h, 070h, 0b3h, 0edh, 003h, 0ebh
	defb 081h, 075h, 0eah, 00ah, 071h, 061h, 0b1h, 0a1h
	defb 0eah, 00bh, 0d3h, 041h, 031h, 071h, 061h, 0b1h
	defb 0a1h, 0eah, 00fh, 0ebh, 061h, 034h, 0d3h, 007h
	defb 0ebh, 071h, 060h, 0d4h, 0b1h, 0ech, 0eah, 003h
	defb 0e9h, 003h, 0a0h, 090h, 0eah, 002h, 080h, 070h
	defb 060h, 050h, 0e9h, 009h, 0c3h, 0e9h, 009h, 0f8h
	defb 009h, 0eah, 00fh, 0ebh, 061h, 034h, 0d4h, 043h
	defb 073h, 063h, 0b3h, 0a7h, 0ebh, 041h, 070h, 0b3h
	defb 0edh, 003h, 0ebh, 081h, 075h, 0eah, 00ah, 071h
	defb 061h, 0b1h, 0a1h, 0eah, 00bh, 0d3h, 041h, 031h
	defb 071h, 061h, 0b1h, 0a1h, 0eah, 00fh, 0ebh, 061h
	defb 034h, 0d4h, 0a7h, 0ebh, 071h, 060h, 0b1h, 0ech
	defb 0eah, 003h, 0e9h, 003h, 0a0h, 090h, 0eah, 002h
	defb 080h, 070h, 060h, 050h, 0e9h, 009h, 0c3h, 0e9h
	defb 009h, 0f8h, 009h, 0eah, 00fh, 0ebh, 031h, 062h
	defb 0d3h, 007h, 0d4h, 0b7h, 0a7h, 0b7h, 0d3h, 001h
	defb 0d4h, 0b1h, 0a1h, 0b1h, 0d3h, 001h, 0d4h, 0b1h
	defb 0a1h, 0b1h, 0d3h, 001h, 0d4h, 0b1h, 0d3h, 001h
	defb 0ebh, 061h, 024h, 0d4h, 0b1h, 0a7h, 0e9h, 009h
	defb 0f8h, 009h, 0eah, 00fh, 0ebh, 052h, 040h, 0d4h
	defb 042h, 040h, 063h, 073h, 0ebh, 023h, 050h, 0d8h
	defb 0dfh, 043h, 0d7h, 0ebh, 052h, 040h, 092h, 090h
	defb 0b3h, 093h, 0ebh, 023h, 050h, 0d8h, 0dfh, 063h
	defb 0d7h, 0fbh, 002h, 095h, 08fh, 0fdh, 0e7h, 08eh

ch_8fbf:                            ; 0x8FBF
	defb 0feh, 001h, 0e9h, 009h, 0f8h, 005h, 0eah, 00eh
	defb 0ebh, 081h, 071h, 0f1h, 047h, 0f2h, 013h, 0d2h
	defb 0bfh, 0a7h, 0ebh, 081h, 054h, 0b1h, 0ech, 0eah
	defb 002h, 0b1h, 0f8h, 00dh, 0f0h, 0eah, 008h, 0ebh
	defb 0e7h, 010h, 0d2h, 001h, 0d3h, 0b1h, 0d2h, 041h
	defb 031h, 0ebh, 0f7h, 020h, 0eah, 009h, 091h, 081h
	defb 0eah, 00ah, 0d1h, 001h, 0d2h, 0b1h, 0eah, 009h
	defb 0d1h, 041h, 031h, 0f8h, 005h, 0eah, 00eh, 0ebh
	defb 081h, 071h, 0f1h, 052h, 0d8h, 0c3h, 0d1h, 097h
	defb 0ebh, 081h, 010h, 061h, 0d7h, 0ech, 0f0h, 0eah
	defb 002h, 0e9h, 003h, 050h, 040h, 0eah, 001h, 030h
	defb 020h, 010h, 000h, 0e9h, 009h, 0c3h, 0f0h, 0d7h
	defb 0e9h, 009h, 0f8h, 005h, 0eah, 00eh, 0ebh, 081h
	defb 071h, 0f1h, 047h, 0f2h, 013h, 0d2h, 0bfh, 0a7h
	defb 0ebh, 081h, 054h, 0b1h, 0ech, 0eah, 002h, 0b1h
	defb 0f8h, 00dh, 0f0h, 0eah, 008h, 0ebh, 0e7h, 010h
	defb 0d2h, 001h, 0d3h, 0b1h, 0d2h, 041h, 031h, 0ebh
	defb 0f7h, 020h, 0eah, 009h, 091h, 081h, 0eah, 00ah
	defb 0d1h, 001h, 0d2h, 0b1h, 0eah, 009h, 0d1h, 041h
	defb 031h, 0f8h, 005h, 0eah, 00eh, 0ebh, 081h, 071h
	defb 0f1h, 052h, 0d8h, 0c3h, 0d1h, 047h, 0ebh, 081h
	defb 010h, 031h, 0d7h, 0ech, 0f0h, 0eah, 002h, 0e9h
	defb 003h, 020h, 010h, 0eah, 001h, 000h, 0d2h, 0b0h
	defb 0a0h, 090h, 0e9h, 009h, 0c3h, 0f0h, 0d7h, 0e9h
	defb 009h, 0f8h, 004h, 0eah, 00eh, 0ebh, 0f7h, 040h
	defb 0f1h, 044h, 0f2h, 009h, 0d8h, 032h, 0d1h, 087h
	defb 077h, 067h, 077h, 0d7h, 0f8h, 00dh, 0f2h, 00dh
	defb 0eah, 00ah, 0ebh, 097h, 040h, 0edh, 001h, 0d2h
	defb 091h, 061h, 041h, 031h, 0eah, 00bh, 091h, 061h
	defb 041h, 031h, 0eah, 00ah, 091h, 061h, 0eah, 00bh
	defb 091h, 061h, 0eah, 00ch, 053h, 0e9h, 00ch, 0f8h
	defb 015h, 0eah, 00eh, 0ebh, 073h, 030h, 0f1h, 052h
	defb 0f2h, 010h, 0d2h, 040h, 070h, 090h, 0f8h, 015h
	defb 0eah, 00eh, 0ebh, 073h, 030h, 0f1h, 052h, 0f2h
	defb 010h, 0e9h, 004h, 0d2h, 0a0h, 0bah, 0e9h, 00ch
	defb 090h, 070h, 093h, 070h, 060h, 070h, 0eah, 007h
	defb 070h, 0eah, 00eh, 071h, 040h, 020h, 042h, 040h
	defb 070h, 090h, 0e9h, 004h, 0d2h, 0a0h, 0bah, 0e9h
	defb 00ch, 090h, 070h, 093h, 070h, 060h, 040h, 0eah
	defb 007h, 040h, 0eah, 00eh, 041h, 040h, 020h, 045h
	defb 0fdh, 0bfh, 08fh

ch_9102:                            ; 0x9102
	defb 0feh, 001h, 0e9h, 009h, 0f8h, 004h, 0eah, 00fh
	defb 0ebh, 081h, 071h, 0f1h, 052h, 0f2h, 013h, 0d1h
	defb 04fh, 077h, 0ebh, 081h, 054h, 061h, 0ech, 0eah
	defb 002h, 061h, 0f8h, 025h, 0f0h, 0d8h, 0a9h, 0eah
	defb 008h, 0ebh, 0e7h, 010h, 0d2h, 041h, 031h, 071h
	defb 061h, 0ebh, 0f7h, 020h, 0eah, 009h, 0d1h, 001h
	defb 0d2h, 0b1h, 0eah, 00ah, 0d1h, 041h, 031h, 0eah
	defb 009h, 071h, 061h, 0d7h, 0f8h, 004h, 0f1h, 052h
	defb 0f2h, 013h, 0eah, 00fh, 0ebh, 081h, 071h, 0d0h
	defb 007h, 0f0h, 0eah, 008h, 0ebh, 081h, 010h, 0d1h
	defb 0b1h, 0ech, 0eah, 002h, 0e9h, 003h, 0a0h, 090h
	defb 0eah, 001h, 080h, 070h, 060h, 050h, 0e9h, 009h
	defb 0c3h, 0e9h, 009h, 0f8h, 004h, 0eah, 00fh, 0ebh
	defb 081h, 071h, 0f1h, 052h, 0f2h, 013h, 0d1h, 04fh
	defb 077h, 0ebh, 081h, 054h, 061h, 0ech, 0eah, 002h
	defb 061h, 0f8h, 025h, 0f0h, 0d8h, 0a9h, 0eah, 008h
	defb 0ebh, 0e7h, 010h, 0d2h, 041h, 031h, 071h, 061h
	defb 0ebh, 0f7h, 020h, 0eah, 009h, 0d1h, 001h, 0d2h
	defb 0b1h, 0eah, 00ah, 0d1h, 041h, 031h, 0eah, 009h
	defb 071h, 061h, 0d7h, 0f8h, 004h, 0f1h, 052h, 0f2h
	defb 013h, 0eah, 00fh, 0ebh, 081h, 071h, 0d1h, 0a7h
	defb 0f0h, 0eah, 008h, 0ebh, 081h, 010h, 0b1h, 0ech
	defb 0eah, 002h, 0e9h, 003h, 0a0h, 090h, 0eah, 001h
	defb 080h, 070h, 060h, 050h, 0e9h, 009h, 0c3h, 0e9h
	defb 009h, 0f8h, 004h, 0eah, 00eh, 0ebh, 0f7h, 040h
	defb 0f1h, 052h, 0f2h, 009h, 0d0h, 007h, 0d1h, 0b7h
	defb 0a7h, 0b7h, 0f8h, 00dh, 0f2h, 00dh, 0eah, 00dh
	defb 0d8h, 0a5h, 0d1h, 001h, 0d2h, 0b1h, 0a1h, 0b1h
	defb 0d1h, 001h, 0d2h, 0b1h, 0a1h, 0b1h, 0d1h, 001h
	defb 0d2h, 0b1h, 0d1h, 001h, 0d2h, 0b1h, 0a5h, 0ech
	defb 0e9h, 002h, 0eah, 001h, 0a3h, 0e9h, 001h, 090h
	defb 080h, 070h, 060h, 050h, 040h, 030h, 020h, 010h
	defb 000h, 0d7h, 0e9h, 00ch, 0d7h, 0f8h, 00ah, 0eah
	defb 00ch, 0ebh, 061h, 051h, 0f2h, 010h, 0f1h, 067h
	defb 0d2h, 0c1h, 020h, 0c2h, 0f0h, 0ebh, 041h, 021h
	defb 0f1h, 067h, 024h, 0e9h, 002h, 0ech, 0eah, 003h
	defb 023h, 0eah, 002h, 010h, 0eah, 001h, 000h, 0f2h
	defb 010h, 0f1h, 067h, 0e9h, 00ch, 0eah, 00ch, 0f2h
	defb 010h, 0f1h, 067h, 0ebh, 061h, 051h, 0c1h, 010h
	defb 0c2h, 0f0h, 0ebh, 041h, 021h, 0f1h, 067h, 015h
	defb 0fbh, 002h, 009h, 092h, 0fdh, 002h, 091h

ch_9249:                            ; 0x9249
	defb 0feh, 001h, 0e9h, 009h, 0eeh, 001h, 0c1h, 0f8h
	defb 004h, 0eah, 008h, 0ebh, 081h, 021h, 0f1h, 051h
	defb 0f2h, 013h, 0d1h, 04fh, 077h, 0ech, 0eah, 001h
	defb 061h, 0f0h, 0f8h, 01dh, 0ech, 0eah, 003h, 0d2h
	defb 042h, 031h, 071h, 061h, 0eah, 004h, 0d1h, 001h
	defb 0d2h, 0b1h, 0eah, 005h, 0d1h, 041h, 031h, 0eah
	defb 004h, 071h, 060h, 0f1h, 051h, 0f2h, 013h, 0eah
	defb 00dh, 0ebh, 081h, 071h, 0d1h, 067h, 0f0h, 0eah
	defb 009h, 0ebh, 081h, 010h, 0b1h, 0ech, 0eah, 002h
	defb 0e9h, 003h, 0a0h, 090h, 0eah, 001h, 080h, 070h
	defb 060h, 050h, 0e9h, 009h, 0c3h, 0e9h, 009h, 0eeh
	defb 001h, 0c1h, 0f8h, 004h, 0eah, 008h, 0ebh, 081h
	defb 021h, 0f1h, 051h, 0f2h, 013h, 0d1h, 04fh, 077h
	defb 0ech, 0eah, 001h, 061h, 0f0h, 0f8h, 01dh, 0ech
	defb 0eah, 003h, 0d2h, 042h, 031h, 071h, 061h, 0eah
	defb 004h, 0d1h, 001h, 0d2h, 0b1h, 0eah, 005h, 0d1h
	defb 041h, 031h, 0eah, 004h, 071h, 060h, 0f1h, 051h
	defb 0f2h, 013h, 0eah, 00dh, 0ebh, 081h, 071h, 0d1h
	defb 077h, 0f0h, 0eah, 009h, 0ebh, 081h, 010h, 0b1h
	defb 0ech, 0eah, 002h, 0e9h, 003h, 0a0h, 090h, 0eah
	defb 001h, 080h, 070h, 060h, 050h, 0e9h, 009h, 0c3h
	defb 0eeh, 001h, 0e9h, 009h, 0eah, 007h, 0ebh, 087h
	defb 030h, 0f1h, 051h, 0f2h, 008h, 0d0h, 009h, 0d1h
	defb 0b7h, 0a7h, 0b5h, 0f2h, 00dh, 0eah, 008h, 0ebh
	defb 081h, 021h, 0d1h, 002h, 0d2h, 0b1h, 0a1h, 0b1h
	defb 0d1h, 001h, 0d2h, 0b1h, 0a1h, 0b1h, 0d1h, 001h
	defb 0d2h, 0b1h, 0d1h, 001h, 0d2h, 0b1h, 0a4h, 0ech
	defb 0e9h, 002h, 0eah, 001h, 0a3h, 0e9h, 001h, 090h
	defb 080h, 070h, 060h, 050h, 040h, 030h, 020h, 010h
	defb 0c0h, 0d7h, 0e9h, 00ch, 0d7h, 0eah, 00ch, 0ebh
	defb 061h, 051h, 0f2h, 010h, 0f1h, 067h, 0d3h, 0c1h
	defb 070h, 0c2h, 0f0h, 0ebh, 041h, 021h, 0f1h, 067h
	defb 074h, 0e9h, 002h, 0ech, 0eah, 003h, 073h, 0eah
	defb 002h, 060h, 0eah, 001h, 050h, 0f2h, 010h, 0f1h
	defb 067h, 0e9h, 00ch, 0ebh, 061h, 051h, 0eah, 00ch
	defb 0c1h, 090h, 0c2h, 0f0h, 0ebh, 041h, 021h, 0f1h
	defb 067h, 095h, 0fbh, 002h, 033h, 093h, 0fdh, 049h
	defb 092h

ch_9372:                            ; 0x9372
	defb 0feh, 001h, 0eah, 00bh, 0f2h, 008h, 0f1h, 053h
	defb 0e9h, 002h, 0d4h, 020h, 030h, 040h, 050h, 060h
	defb 070h, 080h, 090h, 0a0h, 0b0h, 0d3h, 000h, 010h
	defb 0ebh, 001h, 04fh, 0e9h, 00fh, 02eh, 0e9h, 001h
	defb 0c2h, 0ffh

ch_9394:                            ; 0x9394
	defb 0feh, 001h, 0e9h, 00fh, 0c0h, 0eeh, 00bh, 0eah
	defb 008h, 0f2h, 008h, 0f1h, 053h, 0e9h, 002h, 0d4h
	defb 020h, 030h, 040h, 050h, 060h, 070h, 080h, 090h
	defb 0a0h, 0b0h, 0d3h, 000h, 010h, 0ebh, 001h, 04fh
	defb 0e9h, 00fh, 02dh, 0e9h, 001h, 0c2h, 0ffh

ch_93bb:                            ; 0x93BB
	defb 0feh, 001h, 0f8h, 014h, 0eah, 008h, 0e9h, 002h
	defb 0d5h, 020h, 030h, 040h, 050h, 060h, 070h, 080h
	defb 090h, 0a0h, 0b0h, 0d4h, 000h, 010h, 0eah, 00bh
	defb 0ebh, 002h, 060h, 0e9h, 00ch, 020h, 000h, 020h
	defb 030h, 0d8h, 0efh, 021h, 021h, 0d7h, 070h, 050h
	defb 070h, 080h, 0f1h, 053h, 076h, 0ffh

ch_93e9:                            ; 0x93E9
	defb 0feh, 001h, 0f8h, 025h, 0eah, 006h, 0e9h, 002h
	defb 0d3h, 020h, 030h, 040h, 050h, 060h, 070h, 080h
	defb 090h, 0a0h, 0b0h, 0d2h, 000h, 010h, 0e9h, 00ch
	defb 020h, 0eah, 00ch, 0edh, 002h, 0f2h, 008h, 0f1h
	defb 043h, 0ebh, 083h, 083h, 000h, 020h, 030h, 0d8h
	defb 0dfh, 021h, 021h, 0d7h, 070h, 050h, 070h, 080h
	defb 0d8h, 0dfh, 076h, 0ffh

ch_941d:                            ; 0x941D
	defb 0feh, 001h, 0f8h, 00dh, 0eah, 006h, 0e9h, 002h
	defb 0d3h, 070h, 080h, 090h, 0a0h, 0b0h, 0d2h, 000h
	defb 010h, 020h, 030h, 040h, 050h, 060h, 0e9h, 00ch
	defb 0eah, 00ch, 070h, 0f2h, 00ah, 0f1h, 041h, 0edh
	defb 008h, 0ebh, 081h, 052h, 0d2h, 050h, 070h, 080h
	defb 0d8h, 0dfh, 071h, 071h, 0d7h, 0d1h, 020h, 000h
	defb 020h, 030h, 0d8h, 0dfh, 026h, 0ffh

ch_9453:                            ; 0x9453
	defb 0feh, 001h, 0eah, 002h, 0eeh, 001h, 0e9h, 00ch
	defb 0c0h, 0e9h, 002h, 0d3h, 070h, 080h, 090h, 0a0h
	defb 0b0h, 0d2h, 000h, 010h, 020h, 030h, 040h, 050h
	defb 060h, 0e9h, 00ch, 0eah, 006h, 070h, 0edh, 004h
	defb 0ebh, 081h, 010h, 0d2h, 050h, 070h, 080h, 0d8h
	defb 0bfh, 071h, 071h, 0d7h, 0d1h, 020h, 000h, 020h
	defb 030h, 0d8h, 0dfh, 025h, 0ffh

ch_9488:                            ; 0x9488
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0e9h, 005h
	defb 0c3h, 0cfh

ch_9492:                            ; 0x9492
	defb 0feh, 004h, 0e9h, 00ah, 0d0h, 097h, 097h, 097h
	defb 097h, 09fh, 0ffh

ch_949d:                            ; 0x949D
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0e9h, 005h
	defb 0c3h, 0cfh

ch_94a7:                            ; 0x94A7
	defb 0feh, 004h, 0e9h, 00ah, 0d0h, 025h, 020h, 020h
	defb 021h, 020h, 020h, 021h, 021h, 025h, 021h, 021h
	defb 020h, 020h, 021h, 021h, 0e9h, 004h, 000h, 0fbh
	defb 01eh, 0bdh, 094h, 0e9h, 00ah, 01fh, 0ffh

ch_94c6:                            ; 0x94C6
	defb 0feh, 002h, 0feh, 002h, 0e0h, 010h, 0feh, 001h
	defb 0e9h, 005h, 0c3h, 0cfh

ch_94d2:                            ; 0x94D2
	defb 0feh, 001h, 0f8h, 014h, 0eah, 00ch, 0e9h, 00ah
	defb 0ebh, 037h, 015h, 0d4h, 077h, 087h, 077h, 087h
	defb 07fh, 0ffh

ch_94e4:                            ; 0x94E4
	defb 0feh, 002h, 0feh, 002h, 0e0h, 010h, 0feh, 001h
	defb 0f8h, 00dh, 0e9h, 005h, 0eah, 00fh, 0ebh, 032h
	defb 091h, 0f2h, 009h, 0f1h, 041h, 0d0h, 034h, 0d1h
	defb 03eh

ch_94fd:                            ; 0x94FD
	defb 0feh, 001h, 0f8h, 014h, 0eah, 00fh, 0e9h, 00ah
	defb 0ebh, 047h, 055h, 0d5h, 077h, 087h, 077h, 087h
	defb 07fh, 0ffh

ch_950f:                            ; 0x950F
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0f8h, 00dh
	defb 0e9h, 005h, 0eah, 00fh, 0ebh, 032h, 091h, 0f2h
	defb 009h, 0f1h, 041h, 0c0h, 0d0h, 004h, 0d1h, 00dh

ch_9527:                            ; 0x9527
	defb 0feh, 001h, 0f8h, 00dh, 0f2h, 007h, 0f1h, 05fh
	defb 0e9h, 00ah, 0eah, 00eh, 0ebh, 011h, 053h, 0d4h
	defb 0b7h, 0d3h, 003h, 021h, 001h, 0d4h, 0b5h, 071h
	defb 033h, 083h, 02fh, 0ffh

ch_9543:                            ; 0x9543
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0f8h, 00dh
	defb 0e9h, 005h, 0eah, 00fh, 0ebh, 032h, 091h, 0f2h
	defb 009h, 0f1h, 041h, 0c1h, 0d1h, 094h, 0d2h, 0ach

ch_955b:                            ; 0x955B
	defb 0feh, 001h, 0f8h, 00dh, 0f2h, 00ah, 0f1h, 053h
	defb 0e9h, 00ah, 0eah, 00bh, 0edh, 005h, 0ebh, 081h
	defb 073h, 0d8h, 0e3h, 0d2h, 075h, 0d7h, 0ebh, 001h
	defb 063h, 050h, 070h, 081h, 0a0h, 080h, 070h, 0c0h
	defb 050h, 0c0h, 0d8h, 0afh, 077h, 085h, 031h, 0ebh
	defb 011h, 075h, 02fh, 0ffh

ch_9587:                            ; 0x9587
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0f8h, 00dh
	defb 0e9h, 005h, 0eah, 00fh, 0ebh, 032h, 091h, 0f2h
	defb 009h, 0f1h, 041h, 0c2h, 0d1h, 054h, 0f1h, 043h
	defb 0d8h, 0e1h, 0d2h, 09bh

ch_95a3:                            ; 0x95A3
	defb 0feh, 001h, 0f8h, 002h, 0f2h, 00ah, 0f1h, 053h
	defb 0e9h, 00ah, 0eah, 00ch, 0edh, 005h, 0ebh, 081h
	defb 073h, 0d8h, 0e3h, 0d1h, 025h, 0d7h, 0ebh, 001h
	defb 063h, 000h, 020h, 031h, 050h, 030h, 020h, 0c0h
	defb 000h, 0c0h, 0d8h, 0afh, 025h, 0d7h, 0d2h, 0b1h
	defb 0d1h, 001h, 020h, 000h, 0d2h, 0b0h, 0c0h, 080h
	defb 0c0h, 0ebh, 011h, 075h, 0d8h, 0afh, 07fh, 0ffh

ch_95db:                            ; 0x95DB
	defb 0feh, 002h, 0e0h, 010h, 0feh, 001h, 0e9h, 005h
	defb 0eah, 00fh, 0ebh, 032h, 091h, 0f2h, 009h, 0f1h
	defb 041h, 0c3h, 0d1h, 04fh

ch_95ef:                            ; 0x95EF
	defb 0feh, 001h, 0f2h, 00ah, 0f1h, 054h, 0e9h, 00ah
	defb 0eeh, 001h, 0eah, 005h, 0edh, 003h, 0ebh, 081h
	defb 013h, 0d8h, 0e3h, 0d1h, 026h, 0d7h, 0ebh, 001h
	defb 013h, 000h, 020h, 031h, 050h, 030h, 021h, 001h
	defb 0d8h, 0afh, 025h, 0d7h, 0d2h, 0b1h, 0d1h, 001h
	defb 020h, 000h, 0d2h, 0b1h, 081h, 0ebh, 011h, 025h
	defb 0d8h, 0afh, 07eh, 0ffh

ch_9623:                            ; 0x9623
	defb 0feh, 004h, 0d0h, 0e9h, 007h, 091h, 000h, 000h
	defb 091h, 000h, 030h, 091h, 000h, 000h, 091h, 010h
	defb 020h, 0fbh, 007h, 028h, 096h, 091h, 000h, 000h
	defb 091h, 000h, 030h, 091h, 000h, 000h, 030h, 030h
	defb 030h, 030h, 0e9h, 007h, 091h, 000h, 000h, 031h
	defb 000h, 090h, 091h, 000h, 000h, 091h, 010h, 020h
	defb 0fbh, 003h, 047h, 096h, 091h, 000h, 000h, 031h
	defb 000h, 090h, 091h, 000h, 000h, 091h, 030h, 030h
	defb 091h, 000h, 000h, 031h, 000h, 090h, 091h, 000h
	defb 000h, 091h, 010h, 020h, 0fbh, 003h, 063h, 096h
	defb 091h, 000h, 000h, 031h, 000h, 090h, 091h, 000h
	defb 000h, 091h, 030h, 030h, 0fdh, 023h, 096h

ch_9682:                            ; 0x9682
	defb 0feh, 001h, 0e9h, 007h, 0c0h, 0eeh, 002h, 0f2h
	defb 00ah, 0f1h, 072h, 0eah, 008h, 0edh, 007h, 0ebh
	defb 087h, 011h, 0d8h, 0e7h, 0d2h, 093h, 0d7h, 0a1h
	defb 0d1h, 011h, 0d8h, 075h, 025h, 0d7h, 010h, 020h
	defb 011h, 0d2h, 0a0h, 090h, 071h, 090h, 0a0h, 095h
	defb 061h, 073h, 093h, 0a1h, 073h, 0a1h, 097h, 067h
	defb 0d8h, 0e7h, 093h, 0d7h, 0a1h, 0d1h, 011h, 0d8h
	defb 075h, 025h, 0d7h, 010h, 020h, 011h, 0d2h, 0a0h
	defb 090h, 071h, 090h, 0a0h, 095h, 061h, 073h, 093h
	defb 0a3h, 0d1h, 013h, 0d8h, 048h, 02eh, 0feh, 001h
	defb 0e9h, 007h, 0d7h, 0c1h, 0f1h, 043h, 0f2h, 019h
	defb 0e9h, 007h, 0eah, 008h, 0ebh, 007h, 001h, 0d2h
	defb 0a0h, 070h, 090h, 0a0h, 090h, 070h, 050h, 030h
	defb 022h, 072h, 0a1h, 0d1h, 027h, 022h, 002h, 0d2h
	defb 0a1h, 0d1h, 007h, 002h, 0d2h, 0a2h, 0eah, 009h
	defb 073h, 023h, 033h, 053h, 0c1h, 0eah, 008h, 0a0h
	defb 070h, 090h, 0a0h, 090h, 0a0h, 0d1h, 000h, 020h
	defb 0ebh, 007h, 010h, 032h, 002h, 021h, 079h, 022h
	defb 052h, 071h, 097h, 092h, 0a2h, 0d0h, 001h, 0edh
	defb 002h, 0ebh, 087h, 011h, 0f1h, 052h, 0f2h, 019h
	defb 0d1h, 07bh, 0f0h, 0f3h, 0fdh, 082h, 096h

ch_9729:                            ; 0x9729
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 023h, 0eah, 00dh
	defb 0ebh, 074h, 0f1h, 0d5h, 021h, 0d4h, 020h, 020h
	defb 0d5h, 021h, 0d4h, 021h, 0d5h, 021h, 0d4h, 021h
	defb 0d5h, 030h, 0d4h, 030h, 0d5h, 060h, 0d4h, 060h
	defb 0fbh, 008h, 034h, 097h, 0e9h, 007h, 0f8h, 023h
	defb 0eah, 00dh, 0ebh, 074h, 0f1h, 0d5h, 071h, 0d4h
	defb 070h, 070h, 0d5h, 071h, 0d4h, 071h, 0d5h, 071h
	defb 0d4h, 071h, 0d5h, 071h, 0d4h, 020h, 070h, 0d5h
	defb 031h, 0d4h, 030h, 030h, 0d5h, 031h, 0d4h, 031h
	defb 0d5h, 031h, 0d4h, 031h, 0d5h, 031h, 0d4h, 020h
	defb 030h, 0d5h, 051h, 0d4h, 050h, 050h, 0d5h, 051h
	defb 0d4h, 051h, 0d5h, 051h, 0d4h, 051h, 0d5h, 051h
	defb 0d4h, 030h, 050h, 0d5h, 071h, 0d4h, 070h, 070h
	defb 0d5h, 071h, 0d4h, 071h, 0d5h, 031h, 0d4h, 031h
	defb 0d5h, 051h, 0d4h, 051h, 0fbh, 002h, 056h, 097h
	defb 0fdh, 029h, 097h

ch_97a4:                            ; 0x97A4
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 014h, 0f2h, 00ah
	defb 0f1h, 072h, 0eah, 00ah, 0edh, 004h, 0ebh, 087h
	defb 041h, 0d8h, 0efh, 0d2h, 093h, 0d7h, 0a1h, 0d1h
	defb 011h, 0d8h, 078h, 025h, 0d7h, 010h, 020h, 011h
	defb 0d2h, 0a0h, 090h, 071h, 090h, 0a0h, 095h, 061h
	defb 073h, 093h, 0a1h, 073h, 0a1h, 097h, 067h, 0d8h
	defb 0efh, 093h, 0d7h, 0a1h, 0d1h, 011h, 0d8h, 078h
	defb 025h, 0d7h, 010h, 020h, 011h, 0d2h, 0a0h, 090h
	defb 071h, 090h, 0a0h, 095h, 061h, 073h, 093h, 0a3h
	defb 0d1h, 013h, 0d8h, 04fh, 02fh, 0d7h, 0e9h, 007h
	defb 0f8h, 00bh, 0eah, 00ah, 0ebh, 027h, 041h, 0f1h
	defb 044h, 0f2h, 019h, 0d2h, 0a0h, 070h, 090h, 0a0h
	defb 090h, 070h, 050h, 030h, 022h, 072h, 0a1h, 0d1h
	defb 027h, 022h, 002h, 0d2h, 0a1h, 0d1h, 007h, 002h
	defb 0d2h, 0a2h, 091h, 0a3h, 073h, 073h, 093h, 0a0h
	defb 070h, 090h, 0a0h, 090h, 0a0h, 0d1h, 000h, 020h
	defb 032h, 002h, 021h, 077h, 022h, 052h, 071h, 097h
	defb 092h, 0a2h, 0d0h, 001h, 0edh, 003h, 0ebh, 087h
	defb 071h, 0f1h, 053h, 0f2h, 019h, 0d1h, 07fh, 0fdh
	defb 0a4h, 097h

ch_983e:                            ; 0x983E
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 025h, 0d8h, 02fh
	defb 0eah, 008h, 0ebh, 044h, 021h, 0eeh, 001h, 0d2h
	defb 0c1h, 0a2h, 092h, 071h, 063h, 0a3h, 0a1h, 093h
	defb 071h, 061h, 070h, 092h, 0fbh, 004h, 04dh, 098h
	defb 0efh, 0d7h, 0e9h, 007h, 0f8h, 00dh, 0eah, 00ah
	defb 0d8h, 04fh, 0ebh, 027h, 041h, 0d2h, 027h, 0d8h
	defb 05fh, 007h, 0d3h, 033h, 073h, 0a3h, 0d2h, 023h
	defb 007h, 0d3h, 0a7h, 0a3h, 073h, 073h, 093h, 0fbh
	defb 002h, 06bh, 098h, 0fdh, 03eh, 098h

ch_9884:                            ; 0x9884
	defb 0feh, 001h, 0e9h, 007h, 0eah, 008h, 0d8h, 02fh
	defb 0ebh, 044h, 021h, 0d2h, 0c1h, 072h, 062h, 031h
	defb 023h, 073h, 071h, 063h, 031h, 021h, 030h, 062h
	defb 0fbh, 004h, 08fh, 098h, 0d7h, 0e9h, 007h, 0eah
	defb 00ah, 0d8h, 04fh, 0ebh, 027h, 041h, 0d3h, 0a7h
	defb 0d8h, 05fh, 097h, 0c2h, 0eah, 009h, 0d3h, 033h
	defb 073h, 0a3h, 0d2h, 020h, 0eah, 00ah, 0d3h, 097h
	defb 077h, 073h, 023h, 033h, 053h, 0fbh, 002h, 0aah
	defb 098h, 0efh, 0fdh, 084h, 098h

ch_98c9:                            ; 0x98C9
	defb 0f9h, 03dh, 09eh, 0e9h, 005h, 093h, 001h, 001h
	defb 093h, 001h, 001h, 093h, 001h, 001h, 091h, 011h
	defb 031h, 031h, 093h, 001h, 001h, 093h, 001h, 001h
	defb 093h, 001h, 001h, 093h, 001h, 001h, 093h, 001h
	defb 001h, 093h, 001h, 001h, 093h, 001h, 001h, 091h
	defb 011h, 031h, 031h, 093h, 001h, 001h, 093h, 001h
	defb 001h, 093h, 001h, 001h, 091h, 031h, 031h, 031h
	defb 0fbh, 002h, 0ceh, 098h, 0e9h, 005h, 093h, 001h
	defb 001h, 093h, 001h, 001h, 093h, 001h, 001h, 091h
	defb 011h, 031h, 031h, 093h, 001h, 001h, 093h, 010h
	defb 030h, 030h, 030h, 093h, 001h, 001h, 001h, 001h
	defb 013h, 091h, 001h, 001h, 091h, 001h, 011h, 091h
	defb 030h, 030h, 0f9h, 03dh, 09eh, 0feh, 004h, 0d0h
	defb 0e9h, 005h, 093h, 001h, 001h, 093h, 001h, 091h
	defb 093h, 091h, 0e9h, 006h, 031h, 031h, 031h, 031h
	defb 031h, 093h, 013h, 093h, 013h, 093h, 013h, 031h
	defb 031h, 031h, 030h, 030h, 09fh, 0ffh

ch_994f:                            ; 0x994F
	defb 0f9h, 064h, 09eh, 0f2h, 010h, 0f1h, 052h, 0e9h
	defb 00ah, 0d7h, 0eah, 00ah, 0ebh, 017h, 041h, 0d1h
	defb 02fh, 04fh, 00bh, 003h, 057h, 023h, 023h, 0fbh
	defb 002h, 05eh, 099h, 0f2h, 010h, 0f1h, 052h, 0e9h
	defb 00ah, 0d7h, 0eah, 009h, 0ebh, 017h, 041h, 0d2h
	defb 0a5h, 0a1h, 0d1h, 005h, 001h, 055h, 051h, 0ech
	defb 0eah, 007h, 001h, 0eah, 006h, 001h, 0eah, 005h
	defb 001h, 0eah, 004h, 001h, 0eah, 003h, 001h, 0eah
	defb 002h, 001h, 0eah, 001h, 003h, 0f9h, 064h, 09eh
	defb 0feh, 001h, 0e9h, 005h, 0c2h, 0eeh, 001h, 0f8h
	defb 013h, 0d8h, 0cbh, 0eah, 008h, 0ebh, 001h, 011h
	defb 0f1h, 043h, 0f2h, 010h, 0d2h, 093h, 0d8h, 08ch
	defb 061h, 061h, 0d8h, 09ch, 06bh, 0e9h, 006h, 0d8h
	defb 08ch, 063h, 073h, 093h, 0d8h, 0cch, 0afh, 0d8h
	defb 09ch, 093h, 0d8h, 0ach, 07bh, 0e9h, 00ah, 06ch
	defb 0ffh

ch_99c8:                            ; 0x99C8
	defb 0f9h, 0a8h, 09eh, 0f8h, 015h, 0f2h, 010h, 0f1h
	defb 052h, 0e9h, 00ah, 0c0h, 0d7h, 0eeh, 001h, 0eah
	defb 007h, 0ebh, 017h, 011h, 0d1h, 02fh, 04fh, 00eh
	defb 0f8h, 009h, 0f2h, 00ah, 0f1h, 051h, 0e9h, 005h
	defb 0c2h, 0d7h, 0eah, 007h, 0ebh, 057h, 021h, 0d0h
	defb 051h, 0d1h, 091h, 0d0h, 021h, 0d1h, 091h, 0d0h
	defb 041h, 0d1h, 091h, 0d0h, 051h, 0d1h, 091h, 0d0h
	defb 051h, 0d1h, 091h, 0d0h, 021h, 0d1h, 091h, 0d0h
	defb 041h, 0d1h, 071h, 0d0h, 051h, 0d1h, 070h, 0f8h
	defb 015h, 0f2h, 010h, 0f1h, 052h, 0e9h, 00ah, 0eah
	defb 007h, 0ebh, 017h, 011h, 0d1h, 02fh, 04fh, 00eh
	defb 0f8h, 00ah, 0e9h, 005h, 0c2h, 0eah, 006h, 0efh
	defb 0ebh, 007h, 021h, 0d3h, 091h, 0d2h, 021h, 051h
	defb 091h, 021h, 051h, 091h, 0d1h, 001h, 0d2h, 020h
	defb 050h, 090h, 0d1h, 020h, 050h, 090h, 0d0h, 020h
	defb 050h, 090h, 070h, 050h, 040h, 050h, 0f2h, 010h
	defb 0f1h, 052h, 0e9h, 00ah, 0c0h, 0eeh, 001h, 0d7h
	defb 0eah, 007h, 0ebh, 007h, 021h, 0d1h, 055h, 051h
	defb 075h, 071h, 095h, 090h, 0ech, 043h, 0eah, 006h
	defb 041h, 0eah, 005h, 041h, 0eah, 004h, 041h, 0eah
	defb 003h, 041h, 0eah, 002h, 041h, 0eah, 001h, 041h
	defb 0f9h, 0a8h, 09eh, 0feh, 001h, 0e9h, 005h, 0eah
	defb 00bh, 0ebh, 077h, 0f1h, 0d4h, 027h, 025h, 021h
	defb 0d3h, 023h, 0d4h, 0e9h, 006h, 023h, 023h, 023h
	defb 027h, 027h, 027h, 027h, 0ech, 0e9h, 00ah, 0eah
	defb 009h, 025h, 0eah, 008h, 021h, 0eah, 007h, 021h
	defb 0eah, 006h, 021h, 0eah, 005h, 021h, 0eah, 004h
	defb 021h, 0ffh

ch_9aa2:                            ; 0x9AA2
	defb 0f9h, 0c1h, 09eh, 0f8h, 014h, 0e9h, 00ah, 0f8h
	defb 014h, 0eah, 00eh, 0ebh, 077h, 0f1h, 0d5h, 0a1h
	defb 0a0h, 0a0h, 0a1h, 0a0h, 0a0h, 0a1h, 0a0h, 0a0h
	defb 0a0h, 0a0h, 0a0h, 0a0h, 0a1h, 0a0h, 0a0h, 0a1h
	defb 0a0h, 0a0h, 0a1h, 0a0h, 0a0h, 0a1h, 0a0h, 0a0h
	defb 091h, 090h, 090h, 091h, 090h, 090h, 091h, 090h
	defb 090h, 090h, 090h, 090h, 090h, 021h, 020h, 020h
	defb 021h, 020h, 020h, 021h, 020h, 020h, 000h, 000h
	defb 000h, 000h, 0fbh, 002h, 0b0h, 09ah, 0f8h, 014h
	defb 0e9h, 00ah, 0f8h, 014h, 0eah, 00eh, 0ebh, 077h
	defb 0f1h, 0d5h, 071h, 070h, 070h, 071h, 070h, 070h
	defb 091h, 090h, 090h, 091h, 090h, 090h, 0a1h, 0a0h
	defb 0a0h, 0a1h, 0a0h, 0a0h, 0ebh, 070h, 010h, 0d4h
	defb 001h, 0ech, 0eah, 003h, 005h, 0eah, 002h, 003h
	defb 0eah, 001h, 003h, 0f9h, 0c1h, 09eh, 0feh, 001h
	defb 0e9h, 005h, 0f8h, 014h, 0eah, 00eh, 0ebh, 077h
	defb 0f1h, 0d5h, 027h, 025h, 021h, 0d4h, 023h, 0d5h
	defb 0e9h, 006h, 023h, 023h, 023h, 027h, 027h, 027h
	defb 027h, 0ech, 0e9h, 00ah, 0eah, 008h, 025h, 0eah
	defb 007h, 021h, 0eah, 006h, 021h, 0eah, 005h, 021h
	defb 0eah, 004h, 021h, 0eah, 002h, 021h, 0ffh

ch_9b49:                            ; 0x9B49
	defb 0f9h, 0dah, 09eh, 0f8h, 015h, 0f2h, 010h, 0f1h
	defb 051h, 0e9h, 00ah, 0d7h, 0eah, 00bh, 0ebh, 037h
	defb 041h, 0d1h, 05fh, 07fh, 07bh, 043h, 097h, 093h
	defb 073h, 0fbh, 002h, 05ah, 09bh, 0f8h, 015h, 0f2h
	defb 010h, 0f1h, 051h, 0e9h, 00ah, 0d7h, 0eah, 00bh
	defb 0ebh, 037h, 041h, 0d1h, 055h, 051h, 075h, 071h
	defb 095h, 091h, 0eah, 00ah, 0edh, 000h, 0ebh, 081h
	defb 010h, 071h, 0ech, 0eah, 006h, 071h, 0eah, 005h
	defb 071h, 0eah, 004h, 071h, 0eah, 003h, 071h, 0eah
	defb 002h, 071h, 0eah, 001h, 073h, 0f9h, 0dah, 09eh
	defb 0feh, 001h, 0e9h, 005h, 0f8h, 013h, 0d8h, 0e3h
	defb 0eah, 00bh, 0ebh, 021h, 032h, 0f1h, 045h, 0f2h
	defb 010h, 0d2h, 093h, 0d8h, 0adh, 061h, 061h, 0d8h
	defb 0bbh, 06bh, 0e9h, 006h, 0d8h, 0adh, 063h, 073h
	defb 093h, 0d8h, 0e3h, 0afh, 0d8h, 0bah, 093h, 0d8h
	defb 0c8h, 078h, 0e9h, 003h, 0ech, 0d7h, 0eah, 004h
	defb 010h, 0eah, 005h, 020h, 0eah, 006h, 030h, 0eah
	defb 007h, 040h, 0eah, 008h, 050h, 0ebh, 021h, 042h
	defb 0eah, 00ah, 0e9h, 00ah, 06fh, 0ffh

ch_9bdf:                            ; 0x9BDF
	defb 0f9h, 033h, 09fh, 0f8h, 015h, 0f2h, 010h, 0f1h
	defb 051h, 0e9h, 00ah, 0d7h, 0c0h, 0eeh, 001h, 0eah
	defb 006h, 0ebh, 017h, 021h, 0d1h, 05fh, 07fh, 07eh
	defb 0f8h, 009h, 0f2h, 00ah, 0f1h, 051h, 0e9h, 005h
	defb 0d7h, 0eah, 006h, 0ebh, 057h, 021h, 0d0h, 0efh
	defb 051h, 0d1h, 091h, 0d0h, 021h, 0d1h, 091h, 0d0h
	defb 041h, 0d1h, 091h, 0d0h, 051h, 0d1h, 091h, 0d0h
	defb 051h, 0d1h, 091h, 0d0h, 021h, 0d1h, 091h, 0d0h
	defb 041h, 0d1h, 071h, 0d0h, 051h, 0d1h, 073h, 0f8h
	defb 015h, 0eeh, 001h, 0f2h, 010h, 0f1h, 051h, 0e9h
	defb 00ah, 0eah, 006h, 0ebh, 017h, 021h, 0d1h, 05fh
	defb 07fh, 07eh, 0f8h, 00ah, 0e9h, 005h, 0eah, 006h
	defb 0efh, 0ebh, 007h, 021h, 0d3h, 091h, 0d2h, 021h
	defb 051h, 091h, 021h, 051h, 091h, 0d1h, 001h, 0d2h
	defb 020h, 050h, 090h, 0d1h, 020h, 050h, 090h, 0d0h
	defb 020h, 050h, 090h, 070h, 050h, 040h, 050h, 040h
	defb 020h, 000h, 0f8h, 002h, 0f2h, 00ah, 0f1h, 051h
	defb 0e9h, 00ah, 0d7h, 0eah, 00ah, 0edh, 003h, 0ebh
	defb 087h, 041h, 0d1h, 055h, 050h, 050h, 075h, 070h
	defb 070h, 095h, 090h, 090h, 0eah, 009h, 0edh, 000h
	defb 0ebh, 081h, 010h, 071h, 0ech, 0eah, 006h, 071h
	defb 0eah, 005h, 071h, 0eah, 004h, 071h, 0eah, 003h
	defb 071h, 0eah, 002h, 071h, 0eah, 001h, 073h, 0f9h
	defb 033h, 09fh, 0feh, 001h, 0e9h, 005h, 0eeh, 002h
	defb 0f8h, 013h, 0d8h, 0e3h, 0eah, 00bh, 0ebh, 021h
	defb 032h, 0f1h, 045h, 0f2h, 010h, 0d2h, 063h, 0d8h
	defb 0adh, 021h, 021h, 0d8h, 0bbh, 02bh, 0e9h, 006h
	defb 0d8h, 0adh, 023h, 023h, 023h, 0d8h, 0e3h, 07fh
	defb 0d8h, 0bah, 063h, 0d8h, 0cbh, 038h, 0e9h, 003h
	defb 0ech, 0d7h, 0d3h, 0eah, 004h, 090h, 0eah, 005h
	defb 0a0h, 0eah, 006h, 0b0h, 0d2h, 0eah, 007h, 000h
	defb 0eah, 008h, 010h, 0ebh, 021h, 042h, 0eah, 00ah
	defb 0e9h, 00ah, 02fh, 0ffh

ch_9ce3:                            ; 0x9CE3
	defb 0f9h, 076h, 09fh, 0f8h, 004h, 0f2h, 00ah, 0f1h
	defb 051h, 0e9h, 005h, 0d7h, 0eah, 00ah, 0edh, 003h
	defb 0ebh, 087h, 041h, 0d1h, 05bh, 023h, 0a3h, 095h
	defb 073h, 051h, 07bh, 0e9h, 001h, 055h, 075h, 057h
	defb 0e9h, 005h, 04bh, 023h, 07fh, 005h, 025h, 043h
	defb 075h, 051h, 05fh, 047h, 05bh, 023h, 0a3h, 095h
	defb 073h, 051h, 07bh, 0e9h, 001h, 055h, 075h, 057h
	defb 0e9h, 005h, 04bh, 091h, 0a1h, 0d0h, 0e9h, 00ah
	defb 009h, 001h, 021h, 041h, 072h, 050h, 057h, 043h
	defb 0f8h, 002h, 0f2h, 00ah, 0f1h, 051h, 0e9h, 00ah
	defb 0d7h, 0eah, 00ah, 0edh, 003h, 0ebh, 087h, 041h
	defb 0d1h, 0a5h, 090h, 0a0h, 0d0h, 005h, 0d1h, 0a0h
	defb 0d0h, 000h, 025h, 010h, 020h, 0eah, 00ah, 0edh
	defb 000h, 0ebh, 081h, 010h, 041h, 0ech, 0eah, 006h
	defb 041h, 0eah, 005h, 041h, 0eah, 004h, 041h, 0eah
	defb 003h, 041h, 0eah, 002h, 041h, 0eah, 001h, 043h
	defb 0f9h, 076h, 09fh, 0feh, 001h, 0e9h, 005h, 0f8h
	defb 009h, 0eah, 008h, 0edh, 004h, 0ebh, 087h, 061h
	defb 0f1h, 043h, 0f2h, 013h, 0d8h, 0f4h, 0d1h, 02fh
	defb 0e9h, 00dh, 0d2h, 096h, 0e9h, 001h, 0c0h, 0e9h
	defb 006h, 077h, 0a7h, 097h, 077h, 0ebh, 087h, 051h
	defb 0e9h, 00ah, 09fh, 0ffh

ch_9d8f:                            ; 0x9D8F
	defb 0f9h, 0a1h, 09fh, 0eeh, 001h, 0f2h, 00ah, 0f1h
	defb 051h, 0d7h, 0e9h, 005h, 0c2h, 0eah, 007h, 0edh
	defb 003h, 0ebh, 087h, 021h, 0d1h, 05bh, 023h, 0a3h
	defb 095h, 073h, 051h, 07bh, 0e9h, 001h, 055h, 075h
	defb 057h, 0e9h, 005h, 04bh, 023h, 07fh, 005h, 025h
	defb 043h, 075h, 051h, 05fh, 047h, 05bh, 023h, 0a3h
	defb 095h, 073h, 051h, 07bh, 0e9h, 001h, 055h, 075h
	defb 057h, 0e9h, 005h, 04bh, 091h, 0a1h, 0d0h, 0e9h
	defb 00ah, 009h, 001h, 021h, 041h, 072h, 050h, 057h
	defb 0e9h, 005h, 044h, 0f2h, 00ah, 0f1h, 051h, 0e9h
	defb 00ah, 0c1h, 0eeh, 001h, 0d7h, 0eah, 006h, 0edh
	defb 003h, 0ebh, 087h, 021h, 0d1h, 0a5h, 090h, 0a0h
	defb 0d0h, 005h, 0d1h, 0a0h, 0d0h, 000h, 025h, 0efh
	defb 0edh, 000h, 0eah, 007h, 0ebh, 081h, 010h, 001h
	defb 0ech, 0eah, 006h, 001h, 0eah, 005h, 001h, 0eah
	defb 004h, 001h, 0eah, 003h, 001h, 0eah, 002h, 001h
	defb 0eah, 001h, 003h, 0f9h, 0a1h, 09fh, 0feh, 001h
	defb 0e9h, 005h, 0f8h, 009h, 0eah, 008h, 0edh, 004h
	defb 0ebh, 087h, 061h, 0f1h, 043h, 0f2h, 013h, 0d8h
	defb 0f4h, 0d2h, 09fh, 0e9h, 00dh, 066h, 0e9h, 001h
	defb 0c0h, 0e9h, 006h, 047h, 077h, 067h, 047h, 0ebh
	defb 087h, 051h, 0e9h, 00ah, 06fh, 0ffh, 0feh, 004h
	defb 0d0h, 0e9h, 005h, 093h, 001h, 001h, 093h, 001h
	defb 091h, 093h, 093h, 030h, 030h, 030h, 030h, 030h
	defb 030h, 030h, 030h, 093h, 001h, 001h, 093h, 001h
	defb 091h, 093h, 091h, 031h, 031h, 031h, 031h, 031h
	defb 0fbh, 004h, 042h, 09eh, 0fah, 0feh, 001h, 0e9h
	defb 005h, 0c2h, 0eeh, 001h, 0f8h, 013h, 0d8h, 0cbh
	defb 0eah, 008h, 0ebh, 001h, 011h, 0f1h, 043h, 0f2h
	defb 010h, 0d2h, 093h, 0d8h, 08ch, 061h, 061h, 0d8h
	defb 09ch, 06bh, 0d8h, 08ch, 063h, 073h, 093h, 0d8h
	defb 0cch, 0afh, 0d8h, 09ch, 093h, 0d8h, 0ach, 07bh
	defb 0e9h, 00ah, 06fh, 0e9h, 005h, 0ebh, 001h, 011h
	defb 0f8h, 00dh, 0d8h, 0cch, 0eah, 007h, 0d3h, 0a7h
	defb 0d2h, 017h, 027h, 044h, 0fbh, 002h, 068h, 09eh
	defb 0fah, 0feh, 001h, 0e9h, 005h, 0f8h, 028h, 0eah
	defb 00bh, 0ebh, 077h, 0f1h, 0d4h, 027h, 025h, 021h
	defb 0d3h, 023h, 0d4h, 027h, 023h, 0fbh, 008h, 0b3h
	defb 09eh, 0fah, 0feh, 001h, 0e9h, 005h, 0f8h, 014h
	defb 0eah, 00eh, 0ebh, 077h, 0f1h, 0d5h, 027h, 025h
	defb 021h, 0d4h, 023h, 0d5h, 027h, 023h, 0fbh, 008h
	defb 0cch, 09eh, 0fah, 0feh, 001h, 0e9h, 005h, 0f8h
	defb 013h, 0d8h, 0e3h, 0eah, 00bh, 0ebh, 021h, 032h
	defb 0f1h, 045h, 0f2h, 010h, 0d2h, 093h, 0d8h, 0adh
	defb 061h, 061h, 0d8h, 0bbh, 06bh, 0d8h, 0adh, 063h
	defb 073h, 093h, 0d8h, 0e3h, 0afh, 0d8h, 0bah, 093h
	defb 0d8h, 0c8h, 078h, 0e9h, 003h, 0ech, 0d7h, 0eah
	defb 004h, 010h, 0eah, 005h, 020h, 0eah, 006h, 030h
	defb 0eah, 007h, 040h, 0eah, 008h, 050h, 0ebh, 021h
	defb 032h, 0eah, 00ah, 0e9h, 00ah, 06fh, 0e9h, 005h
	defb 0ebh, 017h, 041h, 0f8h, 00dh, 0d8h, 0efh, 0eah
	defb 00bh, 0d3h, 0a7h, 0d2h, 017h, 027h, 047h, 0fbh
	defb 002h, 0deh, 09eh, 0fah, 0feh, 001h, 0e9h, 005h
	defb 0eeh, 002h, 0f8h, 013h, 0d8h, 0e3h, 0eah, 00bh
	defb 0ebh, 021h, 032h, 0f1h, 045h, 0f2h, 010h, 0d2h
	defb 063h, 0d8h, 0adh, 021h, 021h, 0d8h, 0bbh, 02bh
	defb 0d8h, 0adh, 023h, 023h, 023h, 0d8h, 0e3h, 07fh
	defb 0d8h, 0bah, 063h, 0d8h, 0cbh, 03bh, 0e9h, 00ah
	defb 02fh, 0e9h, 005h, 0ebh, 017h, 041h, 0f8h, 00dh
	defb 0d8h, 0efh, 0eah, 00bh, 0d3h, 077h, 097h, 0a7h
	defb 0d2h, 017h, 0fbh, 002h, 039h, 09fh, 0fah, 0feh
	defb 001h, 0e9h, 005h, 0f8h, 009h, 0eah, 008h, 0edh
	defb 004h, 0ebh, 087h, 061h, 0f1h, 043h, 0f2h, 013h
	defb 0d8h, 0f4h, 0d1h, 02fh, 0d2h, 09fh, 077h, 0a7h
	defb 097h, 077h, 0e9h, 00ah, 097h, 067h, 0e9h, 005h
	defb 077h, 097h, 0a7h, 0d1h, 017h, 0fbh, 002h, 07ch
	defb 09fh, 0fah, 0feh, 001h, 0e9h, 005h, 0eah, 008h
	defb 0edh, 004h, 0ebh, 087h, 061h, 0f1h, 043h, 0f2h
	defb 013h, 0d8h, 0f4h, 0d2h, 09fh, 06fh, 047h, 077h
	defb 067h, 047h, 0e9h, 00ah, 067h, 027h, 0e9h, 005h
	defb 047h, 067h, 077h, 097h, 0fbh, 002h, 0a5h, 09fh
	defb 0fah

ch_9fc8:                            ; 0x9FC8
	defb 0feh, 004h, 0d0h, 0e9h, 007h, 093h, 013h, 013h
	defb 093h, 09fh, 0ffh

ch_9fd3:                            ; 0x9FD3
	defb 0feh, 001h, 0e9h, 007h, 0c0h, 0eeh, 001h, 0f8h
	defb 00dh, 0eah, 008h, 0edh, 007h, 0ebh, 087h, 020h
	defb 0f2h, 00ah, 0f1h, 054h, 0d8h, 0bfh, 0d1h, 024h
	defb 0d7h, 010h, 020h, 010h, 0d8h, 0afh, 0d2h, 0a3h
	defb 0d8h, 091h, 071h, 0d8h, 0bfh, 09eh, 0ffh

ch_9ffa:                            ; 0x9FFA
	defb 0feh, 001h, 0e9h, 007h, 0c0h, 0eeh

