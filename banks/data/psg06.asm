; packed-PSG channel streams in bank 06 (0xA000–0xBDB1).
; Opens with the tail of ch_9ffa. 0xFF pad from 0xBDB1 is ds in banks_456.asm.

; tail of ch_9ffa (crosses 0xA000)
	defb 001h, 0eah, 008h, 0edh, 007h, 0ebh, 087h, 020h
	defb 0f2h, 00ah, 0f1h, 054h, 0d8h, 0bfh, 0d2h, 094h
	defb 0d7h, 080h, 090h, 080h, 0d8h, 0afh, 033h, 0d8h
	defb 09fh, 021h, 001h, 0d8h, 0bfh, 02eh, 0ffh

ch_a01f:                            ; 0xA01F
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 028h, 0eah, 00dh
	defb 0ebh, 077h, 051h, 0d4h, 02bh, 0d5h, 073h, 0d4h
	defb 02fh, 0ffh

ch_a031:                            ; 0xA031
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 00dh, 0eah, 009h
	defb 0ebh, 007h, 061h, 0d8h, 07fh, 0f1h, 0edh, 0f2h
	defb 00ah, 0d3h, 022h, 0d8h, 079h, 0f1h, 0d3h, 0eah
	defb 008h, 0ebh, 002h, 031h, 0d2h, 028h, 0eah, 009h
	defb 0ebh, 037h, 061h, 0d8h, 07fh, 003h, 0d3h, 0ebh
	defb 017h, 061h, 0f1h, 0edh, 022h, 0d8h, 079h, 0f1h
	defb 0d3h, 0eah, 008h, 0ebh, 002h, 031h, 0d2h, 02ch
	defb 0ffh

ch_a06a:                            ; 0xA06A
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 00dh, 0eah, 00ah
	defb 0ebh, 027h, 041h, 0eeh, 001h, 0f1h, 0e1h, 0f2h
	defb 009h, 0d3h, 0c0h, 0d8h, 0a9h, 070h, 099h, 074h
	defb 070h, 09dh, 0ffh

ch_a085:                            ; 0xA085
	defb 0feh, 001h, 0e9h, 007h, 0f8h, 00dh, 0eah, 00ah
	defb 0edh, 005h, 0ebh, 087h, 031h, 0f2h, 00ah, 0f1h
	defb 054h, 0d8h, 0dfh, 0d1h, 024h, 0d7h, 010h, 020h
	defb 010h, 0d8h, 0cfh, 0d2h, 0a3h, 0d8h, 0bfh, 091h
	defb 071h, 0d8h, 0dfh, 09fh, 0ffh

ch_a0aa:                            ; 0xA0AA
	defb 0feh, 001h, 0e9h, 007h, 0eah, 00ah, 0edh, 005h
	defb 0ebh, 087h, 031h, 0f2h, 00ah, 0f1h, 054h, 0d8h
	defb 0dfh, 0d2h, 094h, 0d7h, 080h, 090h, 080h, 0d8h
	defb 0cfh, 033h, 0d8h, 0bfh, 021h, 001h, 0d8h, 0dfh
	defb 02fh, 0ffh

ch_a0cc:                            ; 0xA0CC
	defb 0feh, 001h, 0e9h, 005h, 0c3h, 0cfh, 0ffh

ch_a0d3:                            ; 0xA0D3
	defb 0feh, 001h, 0e9h, 005h, 0c3h, 0cfh, 0ffh

ch_a0da:                            ; 0xA0DA
	defb 0feh, 001h, 0e9h, 005h, 0c3h, 0cfh, 0ffh

ch_a0e1:                            ; 0xA0E1
	defb 0feh, 001h, 0f8h, 00dh, 0e9h, 005h, 0eah, 00fh
	defb 0ebh, 032h, 091h, 0f2h, 009h, 0f1h, 041h, 0d0h
	defb 034h, 0d1h, 03eh, 0ffh

ch_a0f5:                            ; 0xA0F5
	defb 0feh, 001h, 0f8h, 00dh, 0e9h, 005h, 0eah, 00fh
	defb 0ebh, 032h, 091h, 0f2h, 009h, 0f1h, 041h, 0c0h
	defb 0d0h, 004h, 0d1h, 00dh, 0ffh

ch_a10a:                            ; 0xA10A
	defb 0feh, 001h, 0f8h, 00dh, 0e9h, 005h, 0eah, 00fh
	defb 0ebh, 032h, 091h, 0f2h, 009h, 0f1h, 041h, 0c1h
	defb 0d1h, 094h, 0d2h, 0ach, 0ffh

ch_a11f:                            ; 0xA11F
	defb 0feh, 001h, 0f8h, 00dh, 0e9h, 005h, 0eah, 00fh
	defb 0ebh, 032h, 091h, 0f2h, 009h, 0f1h, 041h, 0c2h
	defb 0d1h, 054h, 0f1h, 043h, 0d8h, 0e1h, 0d2h, 09bh
	defb 0ffh

ch_a138:                            ; 0xA138
	defb 0feh, 001h, 0e9h, 005h, 0eah, 00fh, 0ebh, 032h
	defb 091h, 0f2h, 009h, 0f1h, 041h, 0c3h, 0d1h, 04fh
	defb 0ffh

ch_a149:                            ; 0xA149
	defb 0feh, 001h, 0f8h, 009h, 0eah, 009h, 0e9h, 008h
	defb 0ebh, 007h, 024h, 0f5h, 0d4h, 02fh, 07fh, 02fh
	defb 07bh, 093h, 0fdh, 049h, 0a1h

ch_a15e:                            ; 0xA15E
	defb 0feh, 001h, 0f2h, 00ah, 0f1h, 052h, 0e9h, 008h
	defb 0eah, 008h, 0edh, 005h, 0ebh, 081h, 010h, 0c0h
	defb 0d8h, 055h, 0d1h, 091h, 0d7h, 071h, 061h, 031h
	defb 0d8h, 097h, 023h, 0d7h, 001h, 021h, 0d8h, 097h
	defb 033h, 0a3h, 0d7h, 091h, 071h, 0d8h, 097h, 063h
	defb 0d7h, 091h, 071h, 061h, 031h, 0d8h, 097h, 023h
	defb 0d7h, 001h, 021h, 0d8h, 097h, 035h, 0d7h, 020h
	defb 000h, 0d8h, 097h, 027h, 0fdh, 06eh, 0a1h

ch_a19d:                            ; 0xA19D
	defb 0feh, 001h, 0f8h, 009h, 0eah, 00eh, 0e9h, 008h
	defb 0ebh, 007h, 024h, 0f5h, 0d4h, 02dh, 0eah, 00ah
	defb 021h, 0eah, 00eh, 07fh, 02dh, 0eah, 00ah, 021h
	defb 0eah, 00eh, 07bh, 0eah, 00ah, 0e9h, 002h, 071h
	defb 080h, 090h, 0eah, 00eh, 0e9h, 008h, 092h, 0fdh
	defb 09dh, 0a1h

ch_a1c7:                            ; 0xA1C7
	defb 0feh, 001h, 0f8h, 00dh, 0f2h, 00ah, 0f1h, 051h
	defb 0e9h, 008h, 0eah, 00bh, 0edh, 007h, 0ebh, 081h
	defb 072h, 0d8h, 047h, 0d1h, 091h, 0d7h, 071h, 061h
	defb 031h, 0d8h, 0a7h, 023h, 0d7h, 001h, 021h, 0d8h
	defb 0a7h, 033h, 0a3h, 0d7h, 091h, 071h, 0d8h, 0a7h
	defb 063h, 0d7h, 091h, 071h, 061h, 031h, 0d8h, 0a7h
	defb 023h, 0d7h, 001h, 021h, 0d8h, 0a7h, 035h, 0d7h
	defb 020h, 000h, 0d8h, 0a7h, 027h, 0fdh, 0c7h, 0a1h

ch_a207:                            ; 0xA207
	defb 0feh, 001h, 0f8h, 018h, 0e9h, 008h, 0eah, 006h
	defb 0ebh, 027h, 020h, 0d2h, 025h, 065h, 0eah, 005h
	defb 020h, 060h, 070h, 090h, 0eah, 006h, 035h, 075h
	defb 0eah, 005h, 0a0h, 090h, 070h, 060h, 0eah, 006h
	defb 025h, 065h, 0eah, 005h, 020h, 060h, 070h, 090h
	defb 0eah, 006h, 035h, 075h, 0eah, 005h, 0a0h, 090h
	defb 070h, 030h, 0fdh, 007h, 0a2h

ch_a23c:                            ; 0xA23C
	defb 0feh, 001h, 0e9h, 008h, 0c1h, 0eah, 004h, 0ebh
	defb 017h, 010h, 0d2h, 021h, 0eah, 004h, 023h, 0eah
	defb 004h, 061h, 0eah, 004h, 062h, 0ebh, 017h, 010h
	defb 0eah, 004h, 020h, 060h, 070h, 0eah, 004h, 091h
	defb 0ebh, 017h, 010h, 0eah, 004h, 031h, 0eah, 004h
	defb 033h, 0eah, 004h, 071h, 0eah, 004h, 072h, 0ebh
	defb 017h, 010h, 0eah, 004h, 0a0h, 090h, 070h, 0eah
	defb 004h, 061h, 0ebh, 017h, 010h, 0eah, 004h, 021h
	defb 0eah, 004h, 023h, 0eah, 004h, 061h, 0eah, 004h
	defb 062h, 0ebh, 017h, 010h, 0eah, 004h, 020h, 060h
	defb 070h, 0eah, 004h, 091h, 0ebh, 017h, 010h, 0eah
	defb 004h, 031h, 0eah, 004h, 033h, 0eah, 004h, 071h
	defb 0eah, 004h, 072h, 0ebh, 017h, 010h, 0eah, 004h
	defb 0a0h, 090h, 070h, 0eah, 004h, 031h, 0fdh, 041h
	defb 0a2h

ch_a2ad:                            ; 0xA2AD
	defb 0feh, 004h, 0e9h, 00ah, 0d0h, 097h, 095h, 091h
	defb 097h, 097h, 095h, 091h, 097h, 097h, 097h, 0fdh
	defb 0adh, 0a2h

ch_a2bf:                            ; 0xA2BF
	defb 0feh, 001h, 0e9h, 00ah, 0eah, 007h, 0f2h, 010h
	defb 0f1h, 042h, 0ech, 0d3h, 0b4h, 0d2h, 002h, 021h
	defb 039h, 021h, 031h, 061h, 073h, 070h, 060h, 030h
	defb 020h, 00bh, 0eah, 003h, 001h, 0f9h, 0ffh, 0a2h
	defb 0eah, 007h, 0f2h, 010h, 0f1h, 042h, 0ech, 0d2h
	defb 034h, 062h, 071h, 099h, 071h, 091h, 0a1h, 0d1h
	defb 013h, 010h, 0d2h, 0a0h, 090h, 070h, 04bh, 0eah
	defb 003h, 041h, 0f9h, 0ffh, 0a2h, 0fdh, 0bfh, 0a2h
	defb 0f0h, 0e9h, 00ah, 0eah, 006h, 0ebh, 021h, 040h
	defb 0d2h, 0a0h, 090h, 0eah, 007h, 0d1h, 010h, 0d2h
	defb 090h, 0eah, 008h, 0d1h, 020h, 0d2h, 090h, 0eah
	defb 009h, 0d1h, 040h, 0d2h, 090h, 0eah, 008h, 0d1h
	defb 050h, 0d2h, 090h, 0eah, 007h, 0d1h, 040h, 0d2h
	defb 090h, 0ebh, 001h, 040h, 0eah, 006h, 0d1h, 020h
	defb 0d2h, 090h, 0eah, 005h, 0d1h, 010h, 0d2h, 090h
	defb 0fah

ch_a338:                            ; 0xA338
	defb 0feh, 001h, 0e9h, 00ah, 0f8h, 014h, 0eah, 00eh
	defb 0ebh, 077h, 0f1h, 0d5h, 097h, 095h, 091h, 097h
	defb 097h, 095h, 091h, 097h, 097h, 097h, 0fdh, 038h
	defb 0a3h

ch_a351:                            ; 0xA351
	defb 0feh, 001h, 0e9h, 00ah, 0f8h, 016h, 0eah, 00ch
	defb 0edh, 007h, 0ebh, 081h, 032h, 0f1h, 043h, 0f2h
	defb 010h, 0d2h, 022h, 032h, 061h, 0edh, 005h, 077h
	defb 0ech, 0eah, 003h, 071h, 0edh, 007h, 0ebh, 081h
	defb 032h, 0eah, 00ch, 061h, 071h, 091h, 0a3h, 0a0h
	defb 090h, 070h, 060h, 0f1h, 045h, 0edh, 005h, 03dh
	defb 0ech, 0eah, 002h, 031h, 0f8h, 01ah, 0ech, 0f0h
	defb 0f1h, 072h, 0eah, 003h, 0d2h, 093h, 0eah, 004h
	defb 093h, 0eah, 005h, 093h, 0eah, 003h, 093h, 0f8h
	defb 016h, 0eah, 00ch, 0edh, 007h, 0ebh, 081h, 032h
	defb 0f2h, 010h, 0f1h, 043h, 0d2h, 072h, 092h, 0a1h
	defb 0edh, 005h, 0d1h, 019h, 0edh, 007h, 0d2h, 0a1h
	defb 0d1h, 011h, 021h, 043h, 040h, 020h, 010h, 0d2h
	defb 0a0h, 0f1h, 045h, 0edh, 005h, 09dh, 0ech, 0eah
	defb 002h, 091h, 0f8h, 01ah, 0f1h, 072h, 0f0h, 0ech
	defb 0eah, 003h, 0d2h, 093h, 0eah, 004h, 093h, 0eah
	defb 005h, 093h, 0eah, 003h, 093h, 0fdh, 051h, 0a3h

ch_a3d9:                            ; 0xA3D9
	defb 0feh, 001h, 0e9h, 00ah, 0f8h, 002h, 0eah, 00bh
	defb 0edh, 006h, 0ebh, 081h, 032h, 0f1h, 043h, 0f2h
	defb 010h, 0d3h, 0b2h, 0d2h, 002h, 021h, 0edh, 004h
	defb 037h, 0ech, 0eah, 003h, 031h, 0edh, 006h, 0ebh
	defb 081h, 032h, 0eah, 00bh, 021h, 031h, 061h, 073h
	defb 070h, 060h, 030h, 020h, 0f1h, 045h, 0edh, 004h
	defb 00dh, 0ech, 0eah, 002h, 001h, 0f0h, 0f9h, 041h
	defb 0a4h, 0f2h, 010h, 0f1h, 043h, 0f8h, 002h, 0eah
	defb 00ah, 0edh, 006h, 0ebh, 081h, 032h, 0d2h, 032h
	defb 062h, 071h, 0edh, 004h, 099h, 0edh, 006h, 071h
	defb 091h, 0a1h, 0d1h, 013h, 010h, 0d2h, 0a0h, 090h
	defb 070h, 0f1h, 045h, 0edh, 004h, 04dh, 0ech, 0eah
	defb 002h, 041h, 0f9h, 041h, 0a4h, 0fdh, 0d9h, 0a3h
	defb 0e9h, 00ah, 0f8h, 018h, 0eah, 007h, 0ebh, 041h
	defb 070h, 0d3h, 0a0h, 090h, 0eah, 008h, 0d2h, 010h
	defb 0d3h, 090h, 0eah, 009h, 0d2h, 020h, 0d3h, 090h
	defb 0ebh, 071h, 070h, 0eah, 00ah, 0d2h, 040h, 0d3h
	defb 090h, 0eah, 009h, 0d2h, 050h, 0d3h, 090h, 0ebh
	defb 041h, 070h, 0eah, 008h, 0d2h, 040h, 0d3h, 090h
	defb 0eah, 007h, 0d2h, 020h, 0d3h, 090h, 0ebh, 011h
	defb 070h, 0eah, 006h, 0d2h, 010h, 0eah, 005h, 0d3h
	defb 090h, 0fah

ch_a483:                            ; 0xA483
	defb 0feh, 001h, 0eeh, 001h, 0e9h, 00ah, 0ebh, 000h
	defb 010h, 0eah, 005h, 0d2h, 024h, 032h, 061h, 079h
	defb 061h, 071h, 091h, 0a3h, 0a0h, 090h, 070h, 060h
	defb 03bh, 0eah, 001h, 031h, 0efh, 0f9h, 0c6h, 0a4h
	defb 0ebh, 000h, 010h, 0eeh, 001h, 0eah, 005h, 0d2h
	defb 074h, 092h, 0a1h, 0d1h, 019h, 0d2h, 0a1h, 0d1h
	defb 011h, 021h, 043h, 040h, 020h, 010h, 0d2h, 0a0h
	defb 09bh, 0eah, 001h, 091h, 0efh, 0f9h, 0c6h, 0a4h
	defb 0fdh, 083h, 0a4h, 0e9h, 005h, 0c1h, 0e9h, 00ah
	defb 0eah, 006h, 0ebh, 001h, 010h, 0eah, 003h, 0d3h
	defb 0a0h, 090h, 0eah, 004h, 0d2h, 010h, 0d3h, 090h
	defb 0ebh, 004h, 050h, 0eah, 004h, 0d2h, 020h, 0d3h
	defb 090h, 0ebh, 017h, 070h, 0eah, 005h, 0d2h, 040h
	defb 0d3h, 090h, 0eah, 005h, 0ebh, 014h, 070h, 0d2h
	defb 050h, 0d3h, 090h, 0eah, 004h, 0ebh, 003h, 070h
	defb 0d2h, 040h, 0d3h, 090h, 0ebh, 007h, 070h, 0eah
	defb 003h, 0d2h, 020h, 0d3h, 090h, 0ech, 0eah, 001h
	defb 0d2h, 010h, 0fah

ch_a50e:                            ; 0xA50E
	defb 0feh, 002h, 0eeh, 001h, 0e0h, 002h, 0e2h, 001h
	defb 020h, 0b7h, 020h, 0a0h, 020h, 08ch, 020h, 07ah
	defb 020h, 06bh, 030h, 05dh, 040h, 050h, 040h, 04ah
	defb 040h, 042h, 030h, 035h, 000h, 035h, 010h, 0b7h
	defb 010h, 0a0h, 010h, 08ch, 010h, 07ah, 010h, 06bh
	defb 010h, 05dh, 010h, 050h, 010h, 04ah, 0ffh

ch_a53d:                            ; 0xA53D
	defb 0feh, 002h, 0f8h, 004h, 0e2h, 001h, 040h, 0b7h
	defb 050h, 0a0h, 060h, 08ch, 070h, 07ah, 080h, 06bh
	defb 090h, 05dh, 0a0h, 050h, 0b0h, 04ah, 0b0h, 042h
	defb 070h, 038h, 0e0h, 001h, 0e2h, 001h, 0f8h, 005h
	defb 000h, 0b7h, 000h, 0a0h, 000h, 08ch, 000h, 07ah
	defb 000h, 06bh, 000h, 05dh, 000h, 050h, 000h, 04ah
	defb 000h, 042h, 000h, 038h, 0ffh

ch_a572:                            ; 0xA572
	defb 0feh, 002h, 0e1h, 001h, 0e4h, 01fh, 009h, 000h
	defb 000h, 000h, 0e4h, 002h, 004h, 000h, 000h, 0e2h
	defb 001h, 051h, 000h, 050h, 0e0h, 0ffh

ch_a588:                            ; 0xA588
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 0c3h, 000h
	defb 0f8h, 004h, 002h, 080h, 000h, 000h, 001h, 08ah
	defb 0f8h, 006h, 002h, 090h, 000h, 000h, 000h, 000h
	defb 0f8h, 00ch, 0e2h, 001h, 071h, 000h, 070h, 0e0h
	defb 0ffh

ch_a5a9:                            ; 0xA5A9
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 000h, 0c5h, 000h
	defb 0e4h, 00ah, 097h, 000h, 032h, 000h, 031h, 080h
	defb 031h, 030h, 032h, 000h, 034h, 0e0h, 032h, 0e0h
	defb 0e4h, 01fh, 092h, 000h, 0e0h, 001h, 0e3h, 001h
	defb 033h, 000h, 031h, 080h, 033h, 030h, 032h, 000h
	defb 034h, 0e0h, 032h, 0e0h, 0e4h, 01fh, 033h, 000h
	defb 022h, 010h, 023h, 040h, 013h, 040h, 0ffh

ch_a5e0:                            ; 0xA5E0
	defb 0feh, 002h, 0f8h, 00bh, 0e2h, 001h, 0c3h, 000h
	defb 018h, 030h, 0f8h, 004h, 082h, 000h, 0f8h, 014h
	defb 027h, 000h, 082h, 000h, 0f8h, 002h, 043h, 000h
	defb 052h, 080h, 054h, 030h, 052h, 000h, 051h, 0e0h
	defb 053h, 0e0h, 0f8h, 00dh, 073h, 000h, 000h, 000h
	defb 0f8h, 002h, 013h, 000h, 012h, 080h, 014h, 030h
	defb 012h, 000h, 013h, 0e0h, 012h, 0e0h, 0f8h, 014h
	defb 003h, 000h, 0ffh

ch_a61b:                            ; 0xA61B
	defb 0feh, 002h, 0e2h, 001h, 070h, 010h, 0e1h, 001h
	defb 0e4h, 009h, 00ah, 0e4h, 01fh, 007h, 0e3h, 001h
	defb 0e4h, 005h, 070h, 008h, 0fbh, 008h, 01dh, 0a6h
	defb 0ffh

ch_a634:                            ; 0xA634
	defb 0feh, 002h, 0e2h, 001h, 0f8h, 028h, 0c4h, 03bh
	defb 0f8h, 00ah, 061h, 00dh, 0f8h, 00dh, 051h, 0c5h
	defb 0f8h, 014h, 0c9h, 008h, 0fbh, 008h, 038h, 0a6h
	defb 0ffh

ch_a64d:                            ; 0xA64D
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 004h, 091h, 050h
	defb 0e4h, 01fh, 0c8h, 010h, 080h, 00ch, 031h, 080h
	defb 031h, 030h, 032h, 000h, 034h, 0e0h, 032h, 0e0h
	defb 0e4h, 01fh, 092h, 000h, 0e0h, 001h, 0e3h, 001h
	defb 033h, 000h, 031h, 080h, 033h, 030h, 032h, 000h
	defb 034h, 0e0h, 032h, 0e0h, 0e4h, 01fh, 033h, 000h
	defb 022h, 010h, 023h, 040h, 013h, 040h, 0ffh

ch_a684:                            ; 0xA684
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 044h, 050h
	defb 0f8h, 004h, 050h, 010h, 060h, 00bh, 082h, 000h
	defb 0f8h, 014h, 027h, 000h, 062h, 000h, 0f8h, 002h
	defb 043h, 000h, 052h, 080h, 054h, 030h, 052h, 000h
	defb 051h, 0e0h, 053h, 0e0h, 0f8h, 00dh, 073h, 000h
	defb 000h, 000h, 0f8h, 002h, 013h, 000h, 012h, 080h
	defb 014h, 030h, 012h, 000h, 013h, 0e0h, 012h, 0e0h
	defb 0f8h, 014h, 003h, 000h, 0ffh

ch_a6c1:                            ; 0xA6C1
	defb 0feh, 002h, 0e2h, 001h, 0b2h, 000h, 031h, 050h
	defb 044h, 000h, 0e0h, 002h, 0e3h, 001h, 0e4h, 01fh
	defb 0a0h, 080h, 090h, 040h, 080h, 080h, 070h, 020h
	defb 08ah, 000h, 08bh, 000h, 08ch, 000h, 0ffh

ch_a6e0:                            ; 0xA6E0
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 0c6h, 050h
	defb 006h, 000h, 027h, 000h, 0e0h, 002h, 0e2h, 001h
	defb 0f8h, 014h, 082h, 080h, 053h, 040h, 042h, 080h
	defb 031h, 020h, 03ah, 000h, 02bh, 000h, 01ch, 000h
	defb 0ffh

ch_a701:                            ; 0xA701
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 002h, 0e2h, 001h
	defb 083h, 0fah, 083h, 00bh, 082h, 054h, 081h, 0c8h
	defb 081h, 05dh, 081h, 00bh, 080h, 0cdh, 080h, 09ch
	defb 080h, 082h, 080h, 070h, 080h, 05ah, 080h, 046h
	defb 080h, 038h, 080h, 02dh, 031h, 0c8h, 031h, 05dh
	defb 031h, 00bh, 030h, 0cdh, 030h, 09ch, 030h, 082h
	defb 030h, 070h, 030h, 05ah, 030h, 046h, 030h, 038h
	defb 030h, 02dh, 021h, 0c8h, 021h, 05dh, 021h, 00bh
	defb 020h, 0cdh, 020h, 09ch, 020h, 082h, 020h, 070h
	defb 020h, 05ah, 020h, 046h, 0ffh

ch_a74e:                            ; 0xA74E
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 0c3h, 0fah
	defb 0c3h, 00bh, 0c2h, 054h, 0c1h, 0c8h, 0c1h, 05dh
	defb 0c1h, 00bh, 0c0h, 0cdh, 0c0h, 09ch, 0c0h, 082h
	defb 0c0h, 070h, 0c0h, 05ah, 0c0h, 046h, 0c0h, 038h
	defb 0c0h, 02dh, 0f8h, 00dh, 021h, 0c8h, 021h, 05dh
	defb 021h, 00bh, 020h, 0cdh, 020h, 09ch, 020h, 082h
	defb 020h, 070h, 020h, 05ah, 020h, 046h, 020h, 038h
	defb 020h, 02dh, 001h, 0c8h, 001h, 05dh, 001h, 00bh
	defb 000h, 0cdh, 000h, 09ch, 000h, 082h, 000h, 070h
	defb 000h, 05ah, 000h, 046h, 000h, 038h, 000h, 02dh
	defb 0ffh

ch_a79f:                            ; 0xA79F
	defb 0feh, 002h, 0e0h, 003h, 0e2h, 004h, 090h, 080h
	defb 090h, 060h, 090h, 048h, 070h, 080h, 070h, 060h
	defb 070h, 048h, 050h, 080h, 050h, 060h, 050h, 048h
	defb 030h, 080h, 030h, 060h, 030h, 048h, 020h, 080h
	defb 020h, 060h, 0e2h, 001h, 010h, 048h, 0ffh

ch_a7c6:                            ; 0xA7C6
	defb 0feh, 002h, 0f8h, 00bh, 0e2h, 004h, 0c0h, 080h
	defb 0c0h, 060h, 0c0h, 048h, 060h, 080h, 060h, 060h
	defb 060h, 048h, 030h, 080h, 030h, 060h, 030h, 048h
	defb 000h, 080h, 000h, 060h, 000h, 048h, 0f8h, 01ah
	defb 000h, 080h, 000h, 060h, 000h, 048h, 0ffh

ch_a7ed:                            ; 0xA7ED
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 004h, 070h, 00ah
	defb 0e1h, 001h, 0e4h, 001h, 005h, 0e4h, 002h, 008h
	defb 0e4h, 003h, 00ah, 0e4h, 007h, 00ah, 0e4h, 00bh
	defb 009h, 0e4h, 00ch, 005h, 0e4h, 00dh, 004h, 0e0h
	defb 014h, 0ffh

ch_a80f:                            ; 0xA80F
	defb 0feh, 002h, 0f8h, 011h, 0e2h, 001h, 071h, 0a0h
	defb 0a1h, 0e0h, 0b1h, 050h, 0b1h, 080h, 0f8h, 007h
	defb 0c2h, 000h, 0c1h, 0f0h, 0c2h, 050h, 0b2h, 0a0h
	defb 0a3h, 000h, 093h, 080h, 094h, 000h, 004h, 080h
	defb 032h, 000h, 031h, 0f0h, 032h, 050h, 032h, 0a0h
	defb 033h, 000h, 033h, 080h, 034h, 000h, 034h, 080h
	defb 002h, 000h, 001h, 0f0h, 002h, 050h, 002h, 0a0h
	defb 003h, 000h, 003h, 080h, 004h, 000h, 004h, 080h
	defb 0ffh

ch_a850:                            ; 0xA850
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 01fh, 080h, 012h
	defb 0e4h, 01ch, 090h, 012h, 0e4h, 019h, 0a0h, 012h
	defb 0e4h, 018h, 090h, 012h, 0e4h, 01ah, 080h, 018h
	defb 0e4h, 016h, 070h, 018h, 060h, 020h, 0e4h, 005h
	defb 050h, 020h, 0e4h, 001h, 0e3h, 002h, 090h, 002h
	defb 090h, 004h, 090h, 006h, 090h, 008h, 090h, 00ah
	defb 040h, 002h, 040h, 004h, 040h, 006h, 040h, 008h
	defb 040h, 00ah, 020h, 002h, 020h, 004h, 020h, 006h
	defb 020h, 008h, 010h, 00ah, 0e0h, 001h, 0ffh

ch_a897:                            ; 0xA897
	defb 0feh, 002h, 0f8h, 00dh, 0e2h, 001h, 040h, 025h
	defb 050h, 021h, 060h, 025h, 070h, 021h, 060h, 025h
	defb 050h, 021h, 040h, 025h, 030h, 021h, 0f8h, 01bh
	defb 0e0h, 001h, 0e2h, 002h, 0c0h, 013h, 0c0h, 015h
	defb 0c0h, 017h, 0c0h, 019h, 0c0h, 01bh, 040h, 013h
	defb 040h, 015h, 040h, 017h, 040h, 019h, 040h, 01bh
	defb 010h, 013h, 010h, 015h, 010h, 017h, 010h, 019h
	defb 010h, 01bh, 0ffh

ch_a8d2:                            ; 0xA8D2
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 00fh, 0e2h, 001h
	defb 074h, 09ah, 074h, 030h, 073h, 070h, 073h, 020h
	defb 072h, 0a0h, 072h, 050h, 072h, 010h, 071h, 0d0h
	defb 084h, 09ah, 084h, 030h, 083h, 070h, 083h, 020h
	defb 082h, 0a0h, 082h, 050h, 082h, 010h, 081h, 0d0h
	defb 0fbh, 002h, 0eah, 0a8h, 064h, 09ah, 064h, 030h
	defb 063h, 070h, 063h, 020h, 062h, 0a0h, 062h, 050h
	defb 062h, 010h, 061h, 0d0h, 0fbh, 002h, 0feh, 0a8h
	defb 044h, 09ah, 044h, 030h, 043h, 070h, 043h, 020h
	defb 042h, 0a0h, 042h, 050h, 042h, 010h, 041h, 0d0h
	defb 0fbh, 002h, 012h, 0a9h, 034h, 09ah, 034h, 030h
	defb 033h, 070h, 033h, 020h, 032h, 0a0h, 032h, 050h
	defb 032h, 010h, 031h, 0d0h, 0fbh, 002h, 026h, 0a9h
	defb 024h, 09ah, 024h, 030h, 023h, 070h, 023h, 020h
	defb 022h, 0a0h, 022h, 050h, 0ffh

ch_a947:                            ; 0xA947
	defb 0feh, 002h, 0f8h, 023h, 0e2h, 001h, 0b4h, 09ah
	defb 0b4h, 030h, 0b3h, 070h, 0b3h, 020h, 0b2h, 0a0h
	defb 0b2h, 050h, 0b2h, 010h, 0b1h, 0d0h, 0f8h, 01ch
	defb 0c4h, 09ah, 0c4h, 030h, 0c3h, 070h, 0c3h, 020h
	defb 0c2h, 0a0h, 0c2h, 050h, 0c2h, 010h, 0c1h, 0d0h
	defb 0f8h, 009h, 0fbh, 002h, 05fh, 0a9h, 0f8h, 01ch
	defb 084h, 09ah, 084h, 030h, 083h, 070h, 083h, 020h
	defb 082h, 0a0h, 082h, 050h, 082h, 010h, 081h, 0d0h
	defb 0f8h, 009h, 0fbh, 002h, 077h, 0a9h, 0f8h, 01ch
	defb 054h, 09ah, 054h, 030h, 053h, 070h, 053h, 020h
	defb 052h, 0a0h, 052h, 050h, 052h, 010h, 051h, 0d0h
	defb 0f8h, 009h, 0fbh, 002h, 08fh, 0a9h, 0f8h, 004h
	defb 034h, 09ah, 034h, 030h, 033h, 070h, 033h, 020h
	defb 032h, 0a0h, 032h, 050h, 032h, 010h, 031h, 0d0h
	defb 0f8h, 009h, 0fbh, 002h, 0a7h, 0a9h, 004h, 09ah
	defb 004h, 030h, 003h, 070h, 003h, 020h, 002h, 0a0h
	defb 002h, 050h, 002h, 010h, 002h, 0d0h, 0ffh

ch_a9ce:                            ; 0xA9CE
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 001h, 062h, 05fh
	defb 072h, 000h, 083h, 05fh, 084h, 090h, 083h, 063h
	defb 084h, 000h, 084h, 090h, 084h, 090h, 083h, 040h
	defb 085h, 000h, 084h, 0a9h, 086h, 000h, 083h, 030h
	defb 082h, 060h, 0fbh, 003h, 0d4h, 0a9h, 064h, 090h
	defb 064h, 090h, 063h, 040h, 065h, 000h, 064h, 0a9h
	defb 066h, 000h, 063h, 030h, 062h, 060h, 0fbh, 003h
	defb 0f4h, 0a9h, 044h, 090h, 044h, 090h, 043h, 040h
	defb 045h, 000h, 044h, 0a9h, 046h, 000h, 043h, 030h
	defb 042h, 060h, 0fbh, 003h, 008h, 0aah, 034h, 090h
	defb 034h, 090h, 033h, 040h, 035h, 000h, 034h, 0a9h
	defb 036h, 000h, 0ffh

ch_aa29:                            ; 0xAA29
	defb 0feh, 002h, 0f8h, 021h, 0e2h, 001h, 062h, 05fh
	defb 072h, 000h, 0a3h, 05fh, 0b4h, 090h, 0c3h, 063h
	defb 0c4h, 000h, 0b4h, 090h, 0b4h, 090h, 0c3h, 040h
	defb 0c5h, 000h, 0c4h, 0a9h, 0c6h, 000h, 0c3h, 030h
	defb 0c2h, 060h, 0fbh, 003h, 02fh, 0aah, 064h, 090h
	defb 064h, 090h, 063h, 040h, 065h, 000h, 064h, 0a9h
	defb 066h, 000h, 063h, 030h, 062h, 060h, 0fbh, 003h
	defb 04fh, 0aah, 044h, 090h, 044h, 090h, 043h, 040h
	defb 045h, 000h, 044h, 0a9h, 046h, 000h, 043h, 030h
	defb 042h, 060h, 0fbh, 003h, 063h, 0aah, 024h, 090h
	defb 024h, 090h, 023h, 040h, 025h, 000h, 014h, 0a9h
	defb 016h, 000h, 013h, 030h, 012h, 060h, 0ffh

ch_aa88:                            ; 0xAA88
	defb 0feh, 002h, 0e3h, 003h, 0e4h, 01fh, 074h, 01ah
	defb 080h, 005h, 0a0h, 008h, 0e3h, 001h, 0b0h, 005h
	defb 0e3h, 002h, 090h, 00ah, 0e3h, 003h, 064h, 01ah
	defb 060h, 005h, 060h, 008h, 060h, 005h, 0e3h, 002h
	defb 060h, 00ah, 0e3h, 003h, 054h, 01ah, 050h, 005h
	defb 050h, 008h, 050h, 005h, 0ffh

ch_aab5:                            ; 0xAAB5
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 065h, 05fh
	defb 075h, 000h, 0a6h, 05fh, 0b7h, 090h, 0c5h, 063h
	defb 0c6h, 000h, 0b4h, 090h, 0b5h, 090h, 0c6h, 040h
	defb 0c8h, 000h, 0c5h, 0a9h, 0c7h, 000h, 0c6h, 030h
	defb 0c4h, 060h, 0f8h, 00bh, 064h, 090h, 065h, 090h
	defb 066h, 040h, 068h, 000h, 067h, 0a9h, 067h, 000h
	defb 066h, 030h, 064h, 060h, 044h, 090h, 045h, 090h
	defb 046h, 040h, 048h, 000h, 047h, 0a9h, 047h, 000h
	defb 046h, 030h, 044h, 060h, 024h, 090h, 025h, 090h
	defb 026h, 040h, 028h, 000h, 027h, 0a9h, 017h, 000h
	defb 016h, 030h, 014h, 060h, 0ffh

ch_ab0a:                            ; 0xAB0A
	defb 0feh, 002h, 0e0h, 001h, 0eeh, 001h, 0e2h, 001h
	defb 033h, 090h, 042h, 040h, 041h, 0c0h, 051h, 040h
	defb 051h, 000h, 050h, 0e0h, 050h, 0c0h, 0f8h, 023h
	defb 043h, 090h, 042h, 040h, 041h, 0c0h, 041h, 040h
	defb 041h, 000h, 040h, 0e0h, 040h, 0c0h, 0f8h, 007h
	defb 013h, 090h, 012h, 040h, 011h, 0c0h, 011h, 040h
	defb 011h, 000h, 010h, 0e0h, 0e0h, 010h, 0ffh

ch_ab41:                            ; 0xAB41
	defb 0feh, 002h, 0f8h, 007h, 0e2h, 001h, 063h, 090h
	defb 072h, 040h, 081h, 0c0h, 091h, 040h, 0a1h, 000h
	defb 0a0h, 0e0h, 0a0h, 0c0h, 0f8h, 023h, 043h, 090h
	defb 042h, 040h, 041h, 0c0h, 041h, 040h, 041h, 000h
	defb 040h, 0e0h, 040h, 0c0h, 0f8h, 007h, 003h, 090h
	defb 002h, 040h, 001h, 0c0h, 001h, 040h, 001h, 000h
	defb 000h, 0e0h, 000h, 0c0h, 0e0h, 010h, 0ffh

ch_ab78:                            ; 0xAB78
	defb 0feh, 002h, 0e2h, 003h, 070h, 0aah, 000h, 0aah
	defb 070h, 08fh, 010h, 0aah, 070h, 06bh, 010h, 08fh
	defb 070h, 055h, 010h, 06bh, 070h, 047h, 010h, 08fh
	defb 070h, 035h, 010h, 047h, 000h, 06bh, 020h, 035h
	defb 010h, 047h, 0ffh

ch_ab9b:                            ; 0xAB9B
	defb 0feh, 002h, 0f8h, 02ah, 0e2h, 003h, 0c0h, 0aah
	defb 000h, 0aah, 0c0h, 08fh, 010h, 0aah, 0c0h, 06bh
	defb 010h, 08fh, 0c0h, 055h, 010h, 06bh, 0b0h, 047h
	defb 010h, 08fh, 0b0h, 035h, 010h, 047h, 0f8h, 01ah
	defb 000h, 06bh, 030h, 035h, 000h, 047h, 0ffh

ch_abc2:                            ; 0xABC2
	defb 0feh, 002h, 0e2h, 001h, 0c4h, 08ch, 065h, 0f6h
	defb 0c3h, 015h, 043h, 077h, 0a3h, 08ch, 000h, 000h
	defb 0a3h, 015h, 000h, 000h, 0a3h, 08ch, 053h, 045h
	defb 033h, 011h, 083h, 050h, 053h, 033h, 084h, 000h
	defb 000h, 000h, 083h, 0ddh, 000h, 000h, 000h, 000h
	defb 073h, 050h, 000h, 000h, 054h, 022h, 000h, 000h
	defb 043h, 050h, 000h, 000h, 033h, 0eeh, 0ffh

ch_abf9:                            ; 0xABF9
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 0c4h, 08ch
	defb 065h, 0f6h, 0f8h, 002h, 0c3h, 015h, 043h, 077h
	defb 0a3h, 08ch, 000h, 000h, 0a3h, 015h, 000h, 000h
	defb 0a3h, 08ch, 053h, 045h, 033h, 011h, 083h, 050h
	defb 053h, 033h, 084h, 000h, 000h, 000h, 083h, 0ddh
	defb 000h, 000h, 000h, 000h, 073h, 050h, 000h, 000h
	defb 054h, 022h, 000h, 000h, 043h, 050h, 000h, 000h
	defb 033h, 0eeh, 0ffh

ch_ac34:                            ; 0xAC34
	defb 0feh, 002h, 0eeh, 001h, 0e2h, 001h, 0a3h, 070h
	defb 0a4h, 0cfh, 0a6h, 0f3h, 0e0h, 003h, 0f8h, 014h
	defb 0e2h, 001h, 0a2h, 0abh, 0a3h, 09bh, 0a5h, 012h
	defb 0a2h, 067h, 0a3h, 030h, 0a4h, 06ch, 092h, 0abh
	defb 093h, 09bh, 095h, 012h, 082h, 067h, 083h, 030h
	defb 084h, 06ch, 072h, 0abh, 073h, 09bh, 075h, 012h
	defb 062h, 067h, 063h, 030h, 064h, 06ch, 052h, 0abh
	defb 053h, 09bh, 055h, 012h, 042h, 067h, 043h, 030h
	defb 045h, 06ch, 032h, 0abh, 033h, 09bh, 035h, 012h
	defb 022h, 067h, 023h, 030h, 024h, 06ch, 022h, 0abh
	defb 023h, 09bh, 025h, 012h, 022h, 067h, 023h, 030h
	defb 024h, 06ch, 0ffh

ch_ac8f:                            ; 0xAC8F
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 0c3h, 070h
	defb 0c4h, 0cfh, 0c6h, 0f3h, 0e0h, 003h, 0f8h, 014h
	defb 0e2h, 001h, 0c2h, 0abh, 0c3h, 09bh, 0c5h, 012h
	defb 0c2h, 067h, 0c3h, 030h, 0c4h, 06ch, 092h, 0abh
	defb 093h, 09bh, 095h, 012h, 082h, 067h, 083h, 030h
	defb 084h, 06ch, 072h, 0abh, 073h, 09bh, 075h, 012h
	defb 062h, 067h, 063h, 030h, 064h, 06ch, 052h, 0abh
	defb 053h, 09bh, 055h, 012h, 042h, 067h, 043h, 030h
	defb 045h, 06ch, 032h, 0abh, 033h, 09bh, 035h, 012h
	defb 022h, 067h, 023h, 030h, 024h, 06ch, 012h, 0abh
	defb 013h, 09bh, 015h, 012h, 002h, 067h, 003h, 030h
	defb 004h, 06ch, 0ffh

ch_acea:                            ; 0xACEA
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 002h, 0e2h, 001h
	defb 0b2h, 000h, 019h, 000h, 0a1h, 00dh, 0a1h, 054h
	defb 0a1h, 0aeh, 0a2h, 021h, 0a2h, 0b2h, 0a3h, 069h
	defb 0a4h, 051h, 0a5h, 077h, 0a1h, 0feh, 0a2h, 08ch
	defb 0a3h, 06ch, 0a4h, 0cbh, 0a6h, 0e9h, 0a9h, 03dh
	defb 0aeh, 070h, 0a2h, 0d5h, 0a3h, 04ch, 0a4h, 008h
	defb 0a5h, 02ch, 0a6h, 0f5h, 0a9h, 0bfh, 0ach, 01bh
	defb 0aeh, 0eeh, 072h, 0b3h, 073h, 017h, 073h, 0b5h
	defb 074h, 0aah, 076h, 02ah, 077h, 083h, 07bh, 02ch
	defb 07fh, 0e5h, 052h, 0ach, 052h, 0fah, 053h, 086h
	defb 054h, 062h, 055h, 0b9h, 057h, 0d2h, 05bh, 018h
	defb 05eh, 035h, 042h, 0ach, 042h, 0fah, 043h, 086h
	defb 044h, 062h, 035h, 0b9h, 037h, 0d2h, 0ffh

ch_ad51:                            ; 0xAD51
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 0c4h, 000h
	defb 009h, 000h, 0f8h, 023h, 0c1h, 00dh, 0c1h, 054h
	defb 0c1h, 0aeh, 0c2h, 021h, 0c2h, 0b2h, 0c3h, 069h
	defb 0c4h, 051h, 0c5h, 077h, 0c1h, 0feh, 0c2h, 08ch
	defb 0c3h, 06ch, 0c4h, 0cbh, 0c6h, 0e9h, 0c9h, 03dh
	defb 0ceh, 070h, 0f8h, 014h, 0c2h, 0d5h, 0c3h, 04ch
	defb 0c4h, 008h, 0c5h, 02ch, 0c6h, 0f5h, 0c9h, 0bfh
	defb 0cch, 01bh, 0ceh, 0eeh, 072h, 0b3h, 073h, 017h
	defb 073h, 0b5h, 074h, 0aah, 076h, 02ah, 077h, 083h
	defb 07bh, 02ch, 07fh, 0e5h, 042h, 0ach, 042h, 0fah
	defb 043h, 086h, 044h, 062h, 045h, 0b9h, 047h, 0d2h
	defb 04bh, 018h, 04eh, 035h, 022h, 0ach, 022h, 0fah
	defb 023h, 086h, 024h, 062h, 025h, 0b9h, 027h, 0d2h
	defb 02ah, 018h, 02eh, 035h, 0ffh

ch_adbe:                            ; 0xADBE
	defb 0feh, 002h, 0e2h, 002h, 064h, 036h, 073h, 0fah
	defb 083h, 0c0h, 093h, 08ah, 0a3h, 057h, 0a2h, 03bh
	defb 0a1h, 0abh, 000h, 000h, 0e2h, 003h, 083h, 057h
	defb 082h, 03bh, 071h, 0abh, 073h, 057h, 072h, 03bh
	defb 061h, 0abh, 063h, 057h, 062h, 03bh, 051h, 0abh
	defb 053h, 057h, 052h, 03bh, 041h, 0abh, 043h, 057h
	defb 042h, 03bh, 031h, 0abh, 033h, 057h, 032h, 03bh
	defb 0ffh

ch_adf7:                            ; 0xADF7
	defb 0feh, 002h, 0f8h, 017h, 0e2h, 002h, 072h, 0cfh
	defb 092h, 0a7h, 0b2h, 081h, 0c2h, 05dh, 0c2h, 03bh
	defb 0c1h, 0abh, 0c1h, 01dh, 0f8h, 021h, 082h, 03bh
	defb 0e2h, 003h, 0b1h, 0abh, 0b1h, 01dh, 072h, 03bh
	defb 071h, 0abh, 071h, 01dh, 042h, 03bh, 041h, 0abh
	defb 041h, 01dh, 032h, 03bh, 031h, 0abh, 031h, 01dh
	defb 012h, 03bh, 011h, 0abh, 011h, 01dh, 002h, 03bh
	defb 001h, 0abh, 001h, 01dh, 0ffh

ch_ae34:                            ; 0xAE34
	defb 0feh, 002h, 0e2h, 005h, 090h, 010h, 090h, 018h
	defb 090h, 020h, 090h, 028h, 090h, 030h, 080h, 010h
	defb 080h, 018h, 080h, 020h, 080h, 028h, 080h, 030h
	defb 070h, 010h, 070h, 018h, 070h, 020h, 070h, 028h
	defb 070h, 030h, 060h, 010h, 060h, 018h, 050h, 020h
	defb 050h, 028h, 040h, 030h, 040h, 010h, 030h, 018h
	defb 020h, 020h, 0ffh

ch_ae67:                            ; 0xAE67
	defb 0feh, 002h, 0e0h, 00ah, 0eeh, 001h, 0e2h, 005h
	defb 080h, 010h, 080h, 018h, 080h, 020h, 080h, 028h
	defb 080h, 030h, 070h, 010h, 070h, 018h, 070h, 020h
	defb 070h, 028h, 070h, 030h, 060h, 010h, 060h, 018h
	defb 060h, 020h, 050h, 028h, 050h, 030h, 040h, 010h
	defb 040h, 018h, 030h, 020h, 030h, 028h, 020h, 030h
	defb 020h, 010h, 0ffh

ch_ae9a:                            ; 0xAE9A
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 002h, 0e2h, 005h
	defb 080h, 010h, 080h, 018h, 080h, 020h, 080h, 028h
	defb 080h, 030h, 070h, 010h, 070h, 018h, 070h, 020h
	defb 070h, 028h, 070h, 030h, 060h, 010h, 060h, 018h
	defb 060h, 020h, 060h, 028h, 060h, 030h, 050h, 010h
	defb 050h, 018h, 040h, 020h, 040h, 028h, 030h, 030h
	defb 030h, 010h, 020h, 018h, 0e2h, 003h, 020h, 020h
	defb 0ffh

ch_aed3:                            ; 0xAED3
	defb 0feh, 002h, 0f8h, 01bh, 0e2h, 005h, 063h, 0f5h
	defb 063h, 000h, 063h, 0f5h, 063h, 030h, 053h, 0f5h
	defb 053h, 030h, 053h, 0f5h, 053h, 030h, 043h, 0f5h
	defb 043h, 030h, 043h, 0f5h, 043h, 030h, 033h, 0f5h
	defb 033h, 030h, 033h, 0f5h, 033h, 030h, 023h, 0f5h
	defb 023h, 030h, 013h, 0f5h, 013h, 030h, 003h, 0f5h
	defb 003h, 030h, 003h, 0f5h, 0ffh

ch_af08:                            ; 0xAF08
	defb 0feh, 002h, 0f8h, 00dh, 0eeh, 003h, 0e2h, 005h
	defb 0b3h, 0f5h, 0b3h, 000h, 0a3h, 0f5h, 0a3h, 030h
	defb 093h, 0f5h, 093h, 030h, 083h, 0f5h, 083h, 030h
	defb 073h, 0f5h, 073h, 030h, 063h, 0f5h, 063h, 030h
	defb 053h, 0f5h, 053h, 030h, 043h, 0f5h, 043h, 030h
	defb 033h, 0f5h, 033h, 030h, 023h, 0f5h, 023h, 030h
	defb 013h, 0f5h, 013h, 030h, 003h, 0f5h, 0ffh

ch_af3f:                            ; 0xAF3F
	defb 0feh, 002h, 0f8h, 00bh, 0e0h, 001h, 0eeh, 003h
	defb 0e2h, 005h, 0b3h, 0f5h, 0b3h, 000h, 0a3h, 0f5h
	defb 0a3h, 030h, 093h, 0f5h, 093h, 030h, 083h, 0f5h
	defb 083h, 030h, 073h, 0f5h, 073h, 030h, 063h, 0f5h
	defb 063h, 030h, 053h, 0f5h, 053h, 030h, 043h, 0f5h
	defb 043h, 030h, 033h, 0f5h, 033h, 030h, 023h, 0f5h
	defb 023h, 030h, 013h, 0f5h, 013h, 030h, 0e2h, 004h
	defb 003h, 0f5h, 0ffh

ch_af7a:                            ; 0xAF7A
	defb 0feh, 002h, 0f8h, 00dh, 0e2h, 005h, 0b3h, 0f5h
	defb 0b3h, 000h, 0a3h, 0f5h, 0a3h, 030h, 093h, 0f5h
	defb 093h, 030h, 083h, 0f5h, 083h, 030h, 073h, 0f5h
	defb 073h, 030h, 063h, 0f5h, 063h, 030h, 053h, 0f5h
	defb 053h, 030h, 043h, 0f5h, 043h, 030h, 033h, 0f5h
	defb 033h, 030h, 023h, 0f5h, 023h, 030h, 013h, 0f5h
	defb 013h, 030h, 003h, 0f5h, 0ffh

ch_afaf:                            ; 0xAFAF
	defb 0feh, 002h, 0e0h, 001h, 0eeh, 003h, 0e2h, 005h
	defb 0b3h, 0f5h, 0b3h, 000h, 0a3h, 0f5h, 0a3h, 030h
	defb 093h, 0f5h, 093h, 030h, 083h, 0f5h, 083h, 030h
	defb 073h, 0f5h, 073h, 030h, 063h, 0f5h, 063h, 030h
	defb 053h, 0f5h, 053h, 030h, 043h, 0f5h, 043h, 030h
	defb 033h, 0f5h, 033h, 030h, 023h, 0f5h, 023h, 030h
	defb 013h, 0f5h, 013h, 030h, 0e2h, 004h, 003h, 0f5h
	defb 0ffh

ch_afe8:                            ; 0xAFE8
	defb 0feh, 002h, 0e0h, 002h, 0e0h, 001h, 0e2h, 002h
	defb 0a6h, 000h, 0aah, 000h, 099h, 0e0h, 089h, 0c0h
	defb 089h, 000h, 088h, 000h, 087h, 040h, 086h, 0a0h
	defb 086h, 000h, 085h, 080h, 036h, 000h, 03ah, 000h
	defb 039h, 0e0h, 039h, 0c0h, 029h, 000h, 028h, 000h
	defb 027h, 040h, 026h, 0a0h, 016h, 000h, 015h, 080h
	defb 0ffh

ch_b019:                            ; 0xB019
	defb 0feh, 002h, 0e0h, 002h, 0e0h, 001h, 0e2h, 002h
	defb 0a3h, 000h, 0a5h, 000h, 094h, 0f0h, 084h, 0e0h
	defb 084h, 080h, 084h, 000h, 083h, 0a0h, 083h, 050h
	defb 083h, 000h, 082h, 0c0h, 033h, 000h, 035h, 000h
	defb 034h, 0f0h, 034h, 0e0h, 024h, 080h, 024h, 000h
	defb 023h, 0a0h, 023h, 050h, 013h, 000h, 012h, 0c0h
	defb 0ffh

ch_b04a:                            ; 0xB04A
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 002h, 0c6h, 000h
	defb 0c8h, 000h, 0feh, 001h, 0e9h, 008h, 0cfh, 0ffh

ch_b05a:                            ; 0xB05A
	defb 0feh, 002h, 0e0h, 002h, 0f8h, 009h, 0e2h, 002h
	defb 0c6h, 000h, 0c8h, 000h, 0feh, 001h, 0e9h, 008h
	defb 0cfh, 0ffh

ch_b06c:                            ; 0xB06C
	defb 0feh, 002h, 0e0h, 002h, 0f8h, 009h, 0f9h, 0beh
	defb 0b0h, 0ffh

ch_b076:                            ; 0xB076
	defb 0feh, 002h, 0e0h, 002h, 0f8h, 004h, 0e2h, 002h
	defb 0f9h, 0beh, 0b0h, 0ffh

ch_b082:                            ; 0xB082
	defb 0feh, 002h, 0e0h, 002h, 0f8h, 014h, 0e2h, 002h
	defb 0c6h, 000h, 0cah, 000h, 0b9h, 0e0h, 0a9h, 0c0h
	defb 0a9h, 000h, 0a8h, 000h, 0a7h, 040h, 0a6h, 0a0h
	defb 0a6h, 000h, 0a5h, 080h, 006h, 000h, 00ah, 000h
	defb 009h, 0e0h, 009h, 0c0h, 009h, 000h, 008h, 000h
	defb 007h, 040h, 006h, 0a0h, 006h, 000h, 005h, 080h
	defb 0ffh

ch_b0b3:                            ; 0xB0B3
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 002h, 0c4h, 000h
	defb 0c8h, 000h, 0ffh, 0e2h, 002h, 0c3h, 000h, 0c5h
	defb 000h, 0b4h, 0f0h, 0a4h, 0e0h, 0a4h, 080h, 0a4h
	defb 000h, 0a3h, 0a0h, 0a3h, 050h, 0a3h, 000h, 0a2h
	defb 0c0h, 003h, 000h, 005h, 000h, 004h, 0f0h, 004h
	defb 0e0h, 004h, 080h, 004h, 000h, 003h, 0a0h, 003h
	defb 050h, 003h, 000h, 002h, 0c0h, 0fah

ch_b0e9:                            ; 0xB0E9
	defb 0feh, 001h, 0f8h, 015h, 0eah, 00fh, 0e9h, 001h
	defb 0d1h, 0ebh, 001h, 088h, 004h, 074h, 044h, 074h
	defb 0ebh, 001h, 023h, 0d0h, 009h, 0ffh

ch_b0ff:                            ; 0xB0FF
	defb 0feh, 002h, 0e0h, 003h, 0e2h, 003h, 061h, 0c5h
	defb 061h, 067h, 061h, 02eh, 060h, 0e2h, 060h, 0b3h
	defb 060h, 097h, 060h, 071h, 060h, 059h, 070h, 071h
	defb 070h, 059h, 070h, 04bh, 060h, 071h, 060h, 059h
	defb 060h, 04bh, 050h, 071h, 050h, 059h, 050h, 04bh
	defb 040h, 071h, 040h, 059h, 040h, 04bh, 040h, 071h
	defb 030h, 059h, 030h, 04bh, 030h, 071h, 030h, 059h
	defb 030h, 04bh, 020h, 071h, 020h, 059h, 020h, 04bh
	defb 020h, 071h, 020h, 059h, 0ffh

ch_b144:                            ; 0xB144
	defb 0feh, 002h, 0f8h, 027h, 0e2h, 003h, 061h, 0c5h
	defb 061h, 067h, 071h, 02eh, 070h, 0e2h, 080h, 0b3h
	defb 090h, 097h, 0a0h, 071h, 0b0h, 059h, 0c0h, 071h
	defb 0c0h, 059h, 0c0h, 04bh, 080h, 071h, 080h, 059h
	defb 080h, 04bh, 040h, 071h, 040h, 059h, 040h, 04bh
	defb 030h, 071h, 030h, 059h, 030h, 04bh, 030h, 071h
	defb 020h, 059h, 020h, 04bh, 010h, 071h, 010h, 059h
	defb 010h, 04bh, 000h, 071h, 000h, 059h, 000h, 04bh
	defb 000h, 071h, 000h, 059h, 000h, 04bh, 0ffh

ch_b18b:                            ; 0xB18B
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 01fh, 080h, 002h
	defb 020h, 004h, 0e2h, 001h, 0eeh, 005h, 050h, 0edh
	defb 051h, 0e8h, 051h, 0e3h, 020h, 083h, 020h, 07dh
	defb 020h, 078h, 0ffh

ch_b1a6:                            ; 0xB1A6
	defb 0feh, 002h, 0e2h, 001h, 0f8h, 006h, 090h, 090h
	defb 050h, 080h, 0f8h, 006h, 090h, 0edh, 091h, 0e8h
	defb 091h, 0e3h, 050h, 083h, 050h, 07dh, 050h, 078h
	defb 0ffh

ch_b1bf:                            ; 0xB1BF
	defb 0feh, 002h, 0e0h, 014h, 0eeh, 001h, 0e3h, 003h
	defb 0e4h, 000h, 030h, 040h, 030h, 041h, 030h, 042h
	defb 040h, 043h, 050h, 044h, 060h, 045h, 070h, 046h
	defb 080h, 047h, 090h, 048h, 090h, 049h, 090h, 04ah
	defb 080h, 04bh, 080h, 04ch, 080h, 04dh, 070h, 04eh
	defb 070h, 04fh, 070h, 050h, 060h, 051h, 060h, 052h
	defb 060h, 053h, 050h, 054h, 050h, 055h, 050h, 056h
	defb 040h, 057h, 040h, 058h, 040h, 059h, 030h, 05ah
	defb 030h, 05bh, 030h, 05ch, 030h, 05dh, 030h, 05eh
	defb 030h, 05fh, 030h, 060h, 030h, 061h, 030h, 062h
	defb 030h, 063h, 0ffh

ch_b212:                            ; 0xB212
	defb 0feh, 002h, 0e0h, 014h, 0f8h, 015h, 0e2h, 002h
	defb 030h, 040h, 040h, 041h, 050h, 042h, 060h, 043h
	defb 070h, 044h, 080h, 045h, 090h, 046h, 0a0h, 047h
	defb 0b0h, 048h, 0b0h, 049h, 0b0h, 04ah, 0a0h, 04bh
	defb 0a0h, 04ch, 0a0h, 04dh, 090h, 04eh, 090h, 04fh
	defb 090h, 050h, 080h, 051h, 080h, 052h, 080h, 053h
	defb 070h, 054h, 070h, 055h, 070h, 056h, 060h, 057h
	defb 060h, 058h, 060h, 059h, 050h, 05ah, 050h, 05bh
	defb 050h, 05ch, 040h, 05dh, 040h, 05eh, 040h, 05fh
	defb 040h, 060h, 030h, 061h, 030h, 062h, 030h, 063h
	defb 0e0h, 024h, 0ffh

ch_b265:                            ; 0xB265
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 00fh, 0e2h, 001h
	defb 092h, 057h, 093h, 03ah, 094h, 059h, 095h, 0c5h
	defb 0f8h, 023h, 081h, 053h, 081h, 0adh, 082h, 01fh
	defb 082h, 0afh, 080h, 0d5h, 081h, 00dh, 081h, 055h
	defb 081h, 0afh, 061h, 053h, 061h, 0adh, 062h, 01fh
	defb 062h, 0afh, 060h, 0d5h, 061h, 00dh, 061h, 055h
	defb 061h, 0afh, 041h, 053h, 041h, 0adh, 042h, 01fh
	defb 042h, 0afh, 040h, 0d5h, 041h, 00dh, 041h, 055h
	defb 041h, 0afh, 031h, 053h, 031h, 0adh, 032h, 01fh
	defb 032h, 0afh, 020h, 0d5h, 021h, 00dh, 021h, 055h
	defb 021h, 0afh, 011h, 053h, 011h, 0adh, 012h, 01fh
	defb 012h, 0afh, 010h, 0d5h, 011h, 00dh, 0ffh

ch_b2c4:                            ; 0xB2C4
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 0c2h, 057h
	defb 0c3h, 03ah, 0c4h, 059h, 0c5h, 0c5h, 0f8h, 023h
	defb 0c1h, 053h, 0c1h, 0adh, 0c2h, 01fh, 0c2h, 0afh
	defb 0c0h, 0d5h, 0c1h, 00dh, 0c1h, 055h, 0c1h, 0afh
	defb 071h, 053h, 071h, 0adh, 072h, 01fh, 072h, 0afh
	defb 070h, 0d5h, 071h, 00dh, 071h, 055h, 071h, 0afh
	defb 041h, 053h, 041h, 0adh, 042h, 01fh, 042h, 0afh
	defb 040h, 0d5h, 041h, 00dh, 041h, 055h, 041h, 0afh
	defb 021h, 053h, 021h, 0adh, 022h, 01fh, 022h, 0afh
	defb 020h, 0d5h, 021h, 00dh, 021h, 055h, 021h, 0afh
	defb 011h, 053h, 011h, 0adh, 012h, 01fh, 012h, 0afh
	defb 000h, 0d5h, 001h, 00dh, 001h, 055h, 001h, 0afh
	defb 0ffh

ch_b325:                            ; 0xB325
	defb 0feh, 002h, 0e2h, 003h, 090h, 04ch, 090h, 03fh
	defb 090h, 05eh, 090h, 032h, 090h, 02ah, 070h, 05eh
	defb 070h, 04ch, 070h, 03fh, 070h, 05eh, 070h, 032h
	defb 070h, 02ah, 050h, 05eh, 050h, 04ch, 050h, 03fh
	defb 050h, 05eh, 050h, 032h, 050h, 02ah, 030h, 05eh
	defb 030h, 04ch, 030h, 03fh, 030h, 05eh, 030h, 032h
	defb 030h, 02ah, 010h, 05eh, 010h, 04ch, 010h, 03fh
	defb 010h, 05eh, 010h, 032h, 010h, 02ah, 010h, 05eh
	defb 0ffh

ch_b366:                            ; 0xB366
	defb 0feh, 002h, 0f8h, 02dh, 0e2h, 003h, 0c0h, 05eh
	defb 0c0h, 04ch, 0c0h, 03fh, 0c0h, 05eh, 0c0h, 032h
	defb 0c0h, 02ah, 060h, 05eh, 060h, 04ch, 060h, 03fh
	defb 060h, 05eh, 060h, 032h, 060h, 02ah, 020h, 05eh
	defb 020h, 04ch, 020h, 03fh, 020h, 05eh, 020h, 032h
	defb 020h, 02ah, 000h, 05eh, 000h, 04ch, 000h, 03fh
	defb 000h, 05eh, 000h, 032h, 000h, 02ah, 0f8h, 01ah
	defb 000h, 05eh, 000h, 04ch, 000h, 03fh, 000h, 05eh
	defb 000h, 032h, 000h, 02ah, 0ffh

ch_b3ab:                            ; 0xB3AB
	defb 0ffh

ch_b3ac:                            ; 0xB3AC
	defb 0feh, 002h, 0f9h, 008h, 0b4h, 0e0h, 002h, 0ffh

ch_b3b4:                            ; 0xB3B4
	defb 0feh, 002h, 0e0h, 001h, 0eeh, 001h, 0f9h, 008h
	defb 0b4h, 0e0h, 001h, 0ffh

ch_b3c0:                            ; 0xB3C0
	defb 0feh, 002h, 0e0h, 002h, 0eeh, 003h, 0f9h, 008h
	defb 0b4h, 0ffh

ch_b3ca:                            ; 0xB3CA
	defb 0feh, 002h, 0e2h, 001h, 0f8h, 00dh, 0f9h, 029h
	defb 0b4h, 0e0h, 002h, 0ffh

ch_b3d6:                            ; 0xB3D6
	defb 0feh, 002h, 0e0h, 001h, 0e2h, 001h, 0f8h, 021h
	defb 0f9h, 029h, 0b4h, 0e0h, 001h, 0ffh

ch_b3e4:                            ; 0xB3E4
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 001h, 0f8h, 00dh
	defb 0f9h, 029h, 0b4h, 0ffh

ch_b3f0:                            ; 0xB3F0
	defb 0feh, 002h, 0e2h, 001h, 0f8h, 00ah, 0f9h, 029h
	defb 0b4h, 0e0h, 002h, 0ffh

ch_b3fc:                            ; 0xB3FC
	defb 0feh, 002h, 0e0h, 001h, 0e2h, 001h, 0f9h, 029h
	defb 0b4h, 0e0h, 001h, 0ffh, 0e2h, 004h, 083h, 080h
	defb 094h, 000h, 0a4h, 080h, 095h, 000h, 095h, 080h
	defb 096h, 000h, 086h, 080h, 087h, 000h, 087h, 080h
	defb 078h, 000h, 078h, 080h, 079h, 000h, 069h, 080h
	defb 06ah, 000h, 06ah, 080h, 0fah, 0c1h, 078h, 0c1h
	defb 04ah, 0c1h, 022h, 0c0h, 0fbh, 0c0h, 0e0h, 0c0h
	defb 0c5h, 0c0h, 0adh, 0c0h, 098h, 0c0h, 085h, 0c0h
	defb 075h, 0c0h, 067h, 0c0h, 05ah, 0c0h, 04fh, 0c0h
	defb 046h, 0c0h, 03dh, 081h, 099h, 081h, 067h, 081h
	defb 03bh, 081h, 015h, 080h, 0f4h, 080h, 0d6h, 080h
	defb 0bch, 080h, 0a5h, 080h, 091h, 080h, 07fh, 080h
	defb 070h, 080h, 062h, 080h, 056h, 080h, 04ch, 080h
	defb 043h, 031h, 099h, 031h, 067h, 031h, 03bh, 031h
	defb 015h, 030h, 0f4h, 030h, 0d6h, 030h, 0bch, 030h
	defb 0a5h, 030h, 091h, 030h, 07fh, 030h, 070h, 030h
	defb 062h, 030h, 056h, 030h, 04ch, 030h, 043h, 001h
	defb 099h, 001h, 067h, 001h, 03bh, 001h, 015h, 000h
	defb 0f4h, 000h, 0d6h, 000h, 0bch, 000h, 0a5h, 000h
	defb 091h, 000h, 07fh, 000h, 070h, 000h, 062h, 000h
	defb 056h, 000h, 04ch, 000h, 043h, 0fah

ch_b4a2:                            ; 0xB4A2
	defb 0feh, 002h, 0e2h, 001h, 071h, 000h, 070h, 080h
	defb 070h, 040h, 0e2h, 003h, 010h, 040h, 0e2h, 001h
	defb 041h, 000h, 040h, 080h, 040h, 040h, 0e2h, 003h
	defb 010h, 040h, 0e2h, 001h, 031h, 000h, 030h, 080h
	defb 030h, 040h, 0e2h, 003h, 010h, 040h, 0e2h, 001h
	defb 021h, 000h, 020h, 080h, 020h, 040h, 0ffh

ch_b4d1:                            ; 0xB4D1
	defb 0feh, 002h, 0f8h, 02ah, 0e2h, 001h, 0c1h, 080h
	defb 0c0h, 0c0h, 0c0h, 080h, 0e0h, 003h, 0e2h, 001h
	defb 041h, 080h, 040h, 0c0h, 040h, 080h, 0e0h, 003h
	defb 0e2h, 001h, 001h, 080h, 000h, 0c0h, 000h, 080h
	defb 0e0h, 003h, 0f8h, 02ah, 0e2h, 001h, 001h, 080h
	defb 000h, 0c0h, 000h, 080h, 0ffh

ch_b4fe:                            ; 0xB4FE
	defb 0ffh

ch_b4ff:                            ; 0xB4FF
	defb 0ffh

ch_b500:                            ; 0xB500
	defb 0feh, 002h, 0e2h, 001h, 0c3h, 000h, 0e3h, 001h
	defb 0e4h, 01ch, 092h, 070h, 0e4h, 000h, 0a4h, 080h
	defb 0e4h, 01ch, 0b4h, 060h, 0e4h, 01ah, 080h, 020h
	defb 0e4h, 017h, 090h, 010h, 0ffh

ch_b51d:                            ; 0xB51D
	defb 0feh, 002h, 0f8h, 009h, 0e2h, 001h, 0c2h, 070h
	defb 0c4h, 080h, 000h, 000h, 000h, 000h, 092h, 070h
	defb 0a4h, 080h, 0ffh

ch_b530:                            ; 0xB530
	defb 0feh, 002h, 0e2h, 001h, 073h, 000h, 0e3h, 001h
	defb 0e4h, 01fh, 098h, 000h, 0e4h, 018h, 083h, 040h
	defb 0e4h, 008h, 0a3h, 000h, 0e4h, 01ch, 090h, 010h
	defb 0e4h, 01ah, 0a0h, 010h, 0e4h, 017h, 0b0h, 010h
	defb 0ffh

ch_b551:                            ; 0xB551
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 0c3h, 000h
	defb 009h, 000h, 002h, 040h, 0a2h, 0a0h, 0f8h, 00dh
	defb 0e2h, 001h, 040h, 025h, 050h, 021h, 060h, 025h
	defb 0ffh

ch_b56a:                            ; 0xB56A
	defb 0feh, 002h, 0f8h, 009h, 0e2h, 001h, 042h, 0d7h
	defb 042h, 0b7h, 052h, 097h, 052h, 077h, 062h, 057h
	defb 062h, 037h, 072h, 017h, 071h, 0f7h, 071h, 0d7h
	defb 071h, 0b7h, 071h, 097h, 071h, 077h, 071h, 057h
	defb 071h, 047h, 071h, 03fh, 071h, 03bh, 071h, 037h
	defb 071h, 03ah, 071h, 03bh, 0fdh, 070h, 0b5h

ch_b599:                            ; 0xB599
	defb 0feh, 002h, 0f8h, 009h, 0e2h, 001h, 012h, 0d7h
	defb 022h, 0b7h, 032h, 097h, 042h, 077h, 052h, 057h
	defb 062h, 037h, 072h, 017h, 081h, 0f7h, 091h, 0d7h
	defb 0a1h, 0b7h, 0b1h, 097h, 0c1h, 077h, 0c1h, 057h
	defb 0c1h, 047h, 0c1h, 03fh, 0c1h, 03bh, 0c1h, 037h
	defb 0c1h, 03ah, 081h, 03bh, 0fdh, 09fh, 0b5h

ch_b5c8:                            ; 0xB5C8
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 01fh, 0a3h, 000h
	defb 0e0h, 001h, 0eeh, 005h, 0e2h, 001h, 050h, 080h
	defb 040h, 092h, 050h, 0e0h, 051h, 020h, 040h, 0d0h
	defb 040h, 070h, 0e0h, 004h, 0e2h, 001h, 020h, 0d0h
	defb 0ffh

ch_b5e9:                            ; 0xB5E9
	defb 0feh, 002h, 0f8h, 028h, 0e2h, 001h, 0c3h, 000h
	defb 0f8h, 006h, 050h, 080h, 090h, 092h, 0c0h, 0e0h
	defb 0f8h, 00ch, 0c1h, 020h, 090h, 0d0h, 090h, 070h
	defb 0f8h, 005h, 0e0h, 004h, 0e2h, 001h, 000h, 0d0h
	defb 000h, 070h, 0ffh

ch_b60c:                            ; 0xB60C
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 01fh, 0c7h, 000h
	defb 0e4h, 00ah, 084h, 033h, 082h, 04fh, 080h, 07ch
	defb 080h, 066h, 080h, 064h, 080h, 05ah, 0e0h, 004h
	defb 0e3h, 001h, 0e4h, 01fh, 0a2h, 040h, 0a2h, 038h
	defb 0a2h, 030h, 0a2h, 028h, 0a2h, 020h, 0a2h, 010h
	defb 0a2h, 008h, 022h, 008h, 060h, 050h, 060h, 04eh
	defb 060h, 048h, 060h, 046h, 060h, 040h, 060h, 03fh
	defb 040h, 03fh, 040h, 050h, 040h, 04eh, 040h, 048h
	defb 040h, 046h, 040h, 040h, 040h, 03fh, 030h, 03fh
	defb 030h, 050h, 030h, 04eh, 030h, 048h, 030h, 046h
	defb 030h, 040h, 030h, 03fh, 0ffh

ch_b661:                            ; 0xB661
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 0c2h, 033h
	defb 0c1h, 04fh, 0c2h, 07ch, 0c3h, 066h, 0c4h, 064h
	defb 0c5h, 05ah, 0c6h, 058h, 0e0h, 004h, 0e2h, 001h
	defb 0f8h, 028h, 0c6h, 050h, 0c5h, 04eh, 0c4h, 048h
	defb 0c3h, 046h, 0c2h, 040h, 0c1h, 03fh, 001h, 03fh
	defb 026h, 050h, 025h, 04eh, 024h, 048h, 023h, 046h
	defb 022h, 040h, 021h, 03fh, 001h, 03fh, 006h, 050h
	defb 005h, 04eh, 004h, 048h, 003h, 046h, 002h, 040h
	defb 001h, 03fh, 0f8h, 02ah, 001h, 03fh, 006h, 050h
	defb 005h, 04eh, 004h, 048h, 003h, 046h, 002h, 040h
	defb 001h, 03fh, 0ffh

ch_b6b4:                            ; 0xB6B4
	defb 0feh, 002h, 0e2h, 004h, 0b0h, 030h, 0b0h, 020h
	defb 0e0h, 003h, 0fbh, 003h, 0b6h, 0b6h, 0e2h, 004h
	defb 090h, 030h, 090h, 020h, 0e0h, 003h, 0fbh, 002h
	defb 0c2h, 0b6h, 0e2h, 004h, 070h, 030h, 070h, 020h
	defb 0e0h, 003h, 0fbh, 002h, 0ceh, 0b6h, 0e2h, 004h
	defb 050h, 030h, 050h, 020h, 0e0h, 003h, 0fbh, 002h
	defb 0dah, 0b6h, 0e2h, 004h, 030h, 030h, 030h, 020h
	defb 0e0h, 003h, 0e2h, 004h, 010h, 030h, 010h, 020h
	defb 0e0h, 003h, 0e2h, 004h, 000h, 030h, 000h, 020h
	defb 0ffh

ch_b6fd:                            ; 0xB6FD
	defb 0feh, 002h, 0e2h, 004h, 090h, 031h, 090h, 021h
	defb 0e0h, 003h, 0fbh, 003h, 0ffh, 0b6h, 0e2h, 004h
	defb 070h, 031h, 070h, 021h, 0e0h, 003h, 0fbh, 002h
	defb 00bh, 0b7h, 0e2h, 004h, 050h, 031h, 050h, 021h
	defb 0e0h, 003h, 0fbh, 002h, 017h, 0b7h, 0e2h, 004h
	defb 040h, 031h, 040h, 021h, 0e0h, 003h, 0fbh, 002h
	defb 023h, 0b7h, 0e2h, 004h, 020h, 031h, 020h, 021h
	defb 0e0h, 003h, 0e2h, 004h, 000h, 031h, 000h, 021h
	defb 0e0h, 003h, 0e2h, 004h, 000h, 031h, 000h, 021h
	defb 0ffh

ch_b746:                            ; 0xB746
	defb 0feh, 002h, 0e4h, 003h, 0e3h, 001h, 0b1h, 020h
	defb 0b1h, 060h, 0b1h, 0a0h, 0b1h, 0e0h, 0b2h, 040h
	defb 0b2h, 080h, 0b3h, 000h, 0b4h, 000h, 0e0h, 003h
	defb 0fbh, 003h, 04ah, 0b7h, 0e3h, 001h, 091h, 020h
	defb 091h, 060h, 091h, 0a0h, 091h, 0e0h, 092h, 040h
	defb 092h, 080h, 093h, 000h, 094h, 000h, 0e0h, 003h
	defb 0fbh, 003h, 062h, 0b7h, 0e3h, 001h, 071h, 020h
	defb 071h, 060h, 071h, 0a0h, 071h, 0e0h, 072h, 040h
	defb 072h, 080h, 073h, 000h, 074h, 000h, 0e0h, 003h
	defb 0fbh, 002h, 07ah, 0b7h, 0e3h, 001h, 051h, 020h
	defb 051h, 060h, 051h, 0a0h, 051h, 0e0h, 052h, 040h
	defb 052h, 080h, 053h, 000h, 064h, 000h, 0e0h, 003h
	defb 0fbh, 002h, 092h, 0b7h, 0e3h, 001h, 031h, 020h
	defb 031h, 060h, 031h, 0a0h, 031h, 0e0h, 032h, 040h
	defb 032h, 080h, 033h, 000h, 034h, 000h, 0e0h, 003h
	defb 0e3h, 001h, 011h, 020h, 011h, 060h, 011h, 0a0h
	defb 011h, 0e0h, 012h, 040h, 012h, 080h, 013h, 000h
	defb 014h, 000h, 0ffh

ch_b7d1:                            ; 0xB7D1
	defb 0feh, 002h, 0f8h, 00dh, 0e2h, 001h, 0b1h, 060h
	defb 0b1h, 020h, 0b0h, 0e0h, 0b0h, 0a0h, 0b0h, 080h
	defb 0b0h, 060h, 0b0h, 040h, 0b0h, 030h, 0e0h, 003h
	defb 0fbh, 003h, 0d5h, 0b7h, 0e2h, 001h, 091h, 060h
	defb 091h, 020h, 090h, 0e0h, 090h, 0a0h, 090h, 080h
	defb 090h, 060h, 090h, 040h, 090h, 030h, 0e0h, 003h
	defb 0fbh, 003h, 0edh, 0b7h, 0e2h, 001h, 071h, 060h
	defb 071h, 020h, 070h, 0e0h, 070h, 0a0h, 070h, 080h
	defb 070h, 060h, 070h, 040h, 070h, 030h, 0e0h, 003h
	defb 0fbh, 002h, 005h, 0b8h, 0e2h, 001h, 051h, 060h
	defb 051h, 020h, 050h, 0e0h, 050h, 0a0h, 050h, 080h
	defb 050h, 060h, 050h, 040h, 050h, 030h, 0e0h, 003h
	defb 0e2h, 001h, 031h, 060h, 031h, 020h, 030h, 0e0h
	defb 030h, 0a0h, 030h, 080h, 030h, 060h, 030h, 040h
	defb 030h, 030h, 0e0h, 003h, 0e2h, 001h, 011h, 060h
	defb 011h, 020h, 010h, 0e0h, 010h, 0a0h, 010h, 080h
	defb 010h, 060h, 010h, 040h, 010h, 030h, 0e0h, 003h
	defb 0e2h, 001h, 001h, 060h, 001h, 020h, 000h, 0e0h
	defb 000h, 0a0h, 000h, 080h, 000h, 060h, 000h, 040h
	defb 000h, 030h, 0ffh

ch_b86c:                            ; 0xB86C
	defb 0feh, 002h, 0f8h, 01dh, 0e2h, 001h, 0b1h, 070h
	defb 0b1h, 030h, 0b0h, 0e8h, 0b0h, 0a8h, 0b0h, 088h
	defb 0b0h, 065h, 0b0h, 043h, 0b0h, 031h, 0e0h, 003h
	defb 0fbh, 003h, 070h, 0b8h, 0e2h, 001h, 091h, 070h
	defb 091h, 030h, 090h, 0e8h, 090h, 0a8h, 090h, 088h
	defb 090h, 065h, 090h, 043h, 090h, 031h, 0e0h, 003h
	defb 0fbh, 003h, 088h, 0b8h, 0e2h, 001h, 071h, 070h
	defb 071h, 030h, 070h, 0e8h, 070h, 0a8h, 070h, 086h
	defb 070h, 065h, 070h, 043h, 070h, 031h, 0e0h, 003h
	defb 0fbh, 002h, 0a0h, 0b8h, 0e2h, 001h, 051h, 070h
	defb 051h, 030h, 050h, 0e8h, 050h, 0a8h, 050h, 088h
	defb 050h, 065h, 050h, 043h, 050h, 031h, 0e0h, 003h
	defb 0e2h, 001h, 031h, 070h, 031h, 030h, 030h, 0e8h
	defb 030h, 0a8h, 030h, 085h, 030h, 063h, 030h, 042h
	defb 030h, 031h, 0e0h, 003h, 0e2h, 001h, 011h, 070h
	defb 011h, 030h, 010h, 0e8h, 010h, 0a8h, 010h, 086h
	defb 010h, 065h, 010h, 043h, 010h, 031h, 0e0h, 003h
	defb 0e2h, 001h, 001h, 070h, 001h, 030h, 000h, 0e8h
	defb 000h, 0a8h, 000h, 086h, 000h, 065h, 000h, 043h
	defb 000h, 031h, 0ffh

ch_b907:                            ; 0xB907
	defb 0feh, 002h, 0f8h, 025h, 0e2h, 001h, 0b1h, 030h
	defb 0b1h, 070h, 0b1h, 0b0h, 0b1h, 0f0h, 0b2h, 060h
	defb 0b2h, 0a0h, 0b3h, 030h, 0b4h, 040h, 0e0h, 003h
	defb 0fbh, 003h, 00bh, 0b9h, 0e2h, 001h, 091h, 040h
	defb 091h, 070h, 091h, 0b0h, 091h, 0f0h, 092h, 060h
	defb 092h, 0a0h, 093h, 030h, 094h, 040h, 0e0h, 003h
	defb 0fbh, 003h, 023h, 0b9h, 0e2h, 001h, 071h, 030h
	defb 071h, 070h, 071h, 0b0h, 071h, 0f0h, 072h, 060h
	defb 072h, 0a0h, 073h, 030h, 074h, 040h, 0e0h, 003h
	defb 0fbh, 002h, 03bh, 0b9h, 0e2h, 001h, 051h, 030h
	defb 051h, 070h, 051h, 0b0h, 051h, 0f0h, 052h, 060h
	defb 052h, 0a0h, 053h, 030h, 064h, 040h, 0e0h, 003h
	defb 0fbh, 002h, 053h, 0b9h, 0e2h, 001h, 031h, 030h
	defb 031h, 070h, 031h, 0b0h, 031h, 0f0h, 032h, 060h
	defb 032h, 0a0h, 033h, 030h, 034h, 040h, 0e0h, 003h
	defb 0e2h, 001h, 001h, 030h, 001h, 070h, 001h, 0b0h
	defb 001h, 0f0h, 002h, 060h, 002h, 0a0h, 003h, 030h
	defb 004h, 040h, 0ffh

ch_b992:                            ; 0xB992
	defb 0feh, 002h, 0f8h, 01dh, 0e2h, 001h, 0b0h, 0bch
	defb 0b0h, 0b0h, 0b0h, 0a0h, 0b0h, 094h, 0b0h, 088h
	defb 0b0h, 076h, 0b0h, 068h, 0b0h, 05dh, 0e0h, 003h
	defb 0fbh, 004h, 096h, 0b9h, 0e2h, 001h, 090h, 0bch
	defb 090h, 0b0h, 090h, 0a0h, 090h, 094h, 090h, 088h
	defb 090h, 076h, 090h, 068h, 090h, 05dh, 0e0h, 003h
	defb 0fbh, 003h, 0aeh, 0b9h, 0e2h, 001h, 070h, 0bch
	defb 070h, 0b0h, 070h, 0a0h, 070h, 094h, 070h, 088h
	defb 070h, 076h, 070h, 068h, 070h, 05dh, 0e0h, 003h
	defb 0fbh, 002h, 0c6h, 0b9h, 0e2h, 001h, 050h, 0bch
	defb 050h, 0b0h, 050h, 0a0h, 050h, 094h, 050h, 088h
	defb 050h, 076h, 040h, 068h, 050h, 05dh, 0e0h, 003h
	defb 0e2h, 001h, 030h, 0bch, 030h, 0b0h, 030h, 0a0h
	defb 030h, 094h, 030h, 088h, 030h, 076h, 030h, 068h
	defb 030h, 05dh, 0e0h, 003h, 0e2h, 001h, 000h, 0bch
	defb 000h, 0b0h, 000h, 0a0h, 000h, 094h, 000h, 088h
	defb 000h, 076h, 000h, 068h, 000h, 05dh, 0ffh

ch_ba19:                            ; 0xBA19
	defb 0feh, 002h, 0f8h, 01dh, 0e2h, 001h, 090h, 0bdh
	defb 090h, 0b1h, 090h, 0a1h, 090h, 095h, 090h, 089h
	defb 090h, 077h, 090h, 069h, 090h, 05eh, 0e0h, 003h
	defb 0fbh, 004h, 01dh, 0bah, 0e2h, 001h, 070h, 0bdh
	defb 070h, 0b1h, 070h, 0a1h, 070h, 095h, 070h, 089h
	defb 070h, 077h, 070h, 069h, 070h, 05eh, 0e0h, 003h
	defb 0fbh, 003h, 035h, 0bah, 0e2h, 001h, 050h, 0bdh
	defb 050h, 0b1h, 050h, 0a1h, 050h, 095h, 050h, 089h
	defb 050h, 077h, 050h, 069h, 050h, 05eh, 0e0h, 003h
	defb 0fbh, 002h, 04dh, 0bah, 0e2h, 001h, 040h, 0bdh
	defb 040h, 0b1h, 040h, 0a1h, 040h, 095h, 040h, 089h
	defb 040h, 077h, 040h, 069h, 040h, 05eh, 0e0h, 003h
	defb 0e2h, 001h, 020h, 0bdh, 020h, 0b1h, 020h, 0a1h
	defb 020h, 095h, 020h, 089h, 020h, 077h, 020h, 069h
	defb 020h, 05eh, 0e0h, 003h, 0e2h, 001h, 000h, 0bdh
	defb 000h, 0b1h, 000h, 0a1h, 000h, 095h, 000h, 089h
	defb 000h, 077h, 000h, 069h, 000h, 05eh, 0ffh

ch_baa0:                            ; 0xBAA0
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 003h, 090h, 080h
	defb 020h, 01fh, 070h, 03fh, 020h, 06ah, 090h, 05ah
	defb 020h, 03fh, 070h, 06ah, 020h, 05ah, 070h, 03fh
	defb 010h, 06ah, 030h, 03fh, 010h, 01fh, 0f8h, 01ah
	defb 010h, 03fh, 0e2h, 002h, 000h, 03fh, 0ffh

ch_bac7:                            ; 0xBAC7
	defb 0feh, 002h, 0f8h, 02ah, 0e2h, 003h, 0c0h, 080h
	defb 020h, 01fh, 0a0h, 03fh, 020h, 06ah, 0c0h, 05ah
	defb 020h, 03fh, 0a0h, 06ah, 020h, 05ah, 0a0h, 03fh
	defb 010h, 06ah, 030h, 03fh, 010h, 01fh, 0f8h, 01ah
	defb 010h, 03fh, 000h, 03fh, 0ffh

ch_baec:                            ; 0xBAEC
	defb 0feh, 002h, 0e0h, 014h, 0eeh, 001h, 0e3h, 003h
	defb 0e4h, 000h, 030h, 030h, 030h, 031h, 030h, 032h
	defb 040h, 033h, 050h, 034h, 060h, 035h, 070h, 036h
	defb 080h, 037h, 090h, 038h, 090h, 039h, 090h, 03ah
	defb 080h, 03bh, 080h, 03ch, 080h, 03dh, 070h, 03eh
	defb 070h, 03fh, 070h, 040h, 060h, 041h, 060h, 042h
	defb 060h, 043h, 050h, 044h, 050h, 045h, 050h, 046h
	defb 040h, 047h, 040h, 048h, 040h, 049h, 030h, 04ah
	defb 030h, 04bh, 030h, 04ch, 030h, 04dh, 030h, 04eh
	defb 030h, 04fh, 030h, 050h, 030h, 051h, 030h, 052h
	defb 030h, 053h, 0ffh

ch_bb3f:                            ; 0xBB3F
	defb 0feh, 002h, 0e0h, 014h, 0f8h, 015h, 0e2h, 002h
	defb 030h, 030h, 040h, 031h, 050h, 032h, 060h, 033h
	defb 070h, 034h, 080h, 035h, 090h, 036h, 0a0h, 037h
	defb 0b0h, 038h, 0b0h, 039h, 0b0h, 03ah, 0a0h, 03bh
	defb 0a0h, 03ch, 0a0h, 03dh, 090h, 03eh, 090h, 03fh
	defb 090h, 040h, 080h, 041h, 080h, 042h, 080h, 043h
	defb 070h, 044h, 070h, 045h, 070h, 046h, 060h, 047h
	defb 060h, 048h, 060h, 049h, 050h, 04ah, 050h, 04bh
	defb 050h, 04ch, 040h, 04dh, 040h, 04eh, 040h, 04fh
	defb 040h, 050h, 030h, 051h, 030h, 052h, 030h, 053h
	defb 0e0h, 024h, 0ffh

ch_bb92:                            ; 0xBB92
	defb 0feh, 002h, 0e3h, 001h, 0e4h, 00ch, 0b0h, 080h
	defb 000h, 000h, 000h, 000h, 0a0h, 00ah, 080h, 00bh
	defb 0e0h, 004h, 0e3h, 001h, 070h, 080h, 000h, 000h
	defb 000h, 000h, 060h, 00ah, 050h, 00bh, 0e0h, 003h
	defb 0e3h, 001h, 050h, 080h, 000h, 000h, 000h, 000h
	defb 040h, 00ah, 030h, 00bh, 0e0h, 003h, 0e3h, 001h
	defb 030h, 080h, 000h, 000h, 000h, 000h, 020h, 00ah
	defb 010h, 00bh, 0ffh

ch_bbcd:                            ; 0xBBCD
	defb 0feh, 002h, 0f8h, 007h, 0e2h, 001h, 070h, 0a6h
	defb 070h, 0a5h, 070h, 0a4h, 0e0h, 002h, 0f8h, 007h
	defb 0e0h, 004h, 0e2h, 001h, 030h, 0a6h, 030h, 0a5h
	defb 030h, 0a4h, 0e0h, 005h, 0e2h, 001h, 010h, 0a6h
	defb 010h, 0a5h, 010h, 0a4h, 0e0h, 005h, 0e2h, 001h
	defb 000h, 0a6h, 000h, 0a5h, 000h, 0a4h, 0e0h, 002h
	defb 0ffh

ch_bbfe:                            ; 0xBBFE
	defb 0feh, 002h, 0e0h, 001h, 0e2h, 001h, 064h, 05fh
	defb 074h, 000h, 085h, 05fh, 086h, 090h, 092h, 063h
	defb 093h, 000h, 091h, 090h, 092h, 090h, 093h, 040h
	defb 095h, 000h, 092h, 0a9h, 094h, 000h, 093h, 030h
	defb 091h, 060h, 0fbh, 008h, 00ch, 0bch, 061h, 090h
	defb 062h, 090h, 063h, 040h, 065h, 000h, 064h, 0a9h
	defb 064h, 000h, 063h, 030h, 061h, 060h, 0fbh, 002h
	defb 024h, 0bch, 041h, 090h, 042h, 090h, 043h, 040h
	defb 045h, 000h, 044h, 0a9h, 044h, 000h, 043h, 030h
	defb 041h, 060h, 0fbh, 002h, 038h, 0bch, 031h, 090h
	defb 032h, 090h, 033h, 040h, 035h, 000h, 034h, 0a9h
	defb 034h, 000h, 033h, 030h, 031h, 060h, 021h, 090h
	defb 022h, 090h, 023h, 040h, 025h, 000h, 024h, 0a9h
	defb 024h, 000h, 023h, 030h, 0ffh

ch_bc6b:                            ; 0xBC6B
	defb 0feh, 002h, 0f8h, 009h, 0e2h, 001h, 064h, 05fh
	defb 074h, 000h, 0a5h, 05fh, 0b6h, 090h, 0c2h, 063h
	defb 0c3h, 000h, 0b1h, 090h, 0b2h, 090h, 0c3h, 040h
	defb 0c5h, 000h, 0c2h, 0a9h, 0c4h, 000h, 0c3h, 030h
	defb 0c1h, 060h, 0fbh, 008h, 079h, 0bch, 061h, 090h
	defb 062h, 090h, 063h, 040h, 065h, 000h, 064h, 0a9h
	defb 064h, 000h, 063h, 030h, 061h, 060h, 0fbh, 002h
	defb 091h, 0bch, 041h, 090h, 042h, 090h, 043h, 040h
	defb 045h, 000h, 044h, 0a9h, 044h, 000h, 043h, 030h
	defb 041h, 060h, 0fbh, 002h, 0a5h, 0bch, 021h, 090h
	defb 022h, 090h, 023h, 040h, 025h, 000h, 024h, 0a9h
	defb 024h, 000h, 023h, 030h, 021h, 060h, 001h, 090h
	defb 002h, 090h, 003h, 040h, 005h, 000h, 004h, 0a9h
	defb 004h, 000h, 003h, 030h, 001h, 060h, 0ffh

ch_bcda:                            ; 0xBCDA
	defb 0ffh

ch_bcdb:                            ; 0xBCDB
	defb 0ffh

ch_bcdc:                            ; 0xBCDC
	defb 0feh, 002h, 0e0h, 002h, 0e2h, 003h, 070h, 06bh
	defb 030h, 06bh, 070h, 054h, 030h, 06bh, 080h, 046h
	defb 030h, 054h, 080h, 054h, 030h, 046h, 080h, 046h
	defb 030h, 054h, 070h, 03eh, 030h, 046h, 070h, 038h
	defb 030h, 03eh, 040h, 054h, 020h, 046h, 040h, 046h
	defb 020h, 054h, 040h, 03eh, 020h, 046h, 040h, 038h
	defb 020h, 03eh, 030h, 054h, 020h, 054h, 030h, 046h
	defb 020h, 046h, 030h, 03eh, 0ffh

ch_bd19:                            ; 0xBD19
	defb 0feh, 002h, 0f8h, 003h, 0e2h, 003h, 090h, 06bh
	defb 000h, 06bh, 0a0h, 054h, 020h, 06bh, 0b0h, 046h
	defb 020h, 054h, 0c0h, 054h, 020h, 046h, 0b0h, 046h
	defb 020h, 054h, 0a0h, 03eh, 020h, 046h, 0a0h, 038h
	defb 020h, 03eh, 040h, 054h, 000h, 046h, 040h, 046h
	defb 000h, 054h, 040h, 03eh, 000h, 046h, 040h, 038h
	defb 000h, 03eh, 000h, 054h, 000h, 000h, 000h, 046h
	defb 000h, 000h, 000h, 03eh, 000h, 000h, 000h, 038h
	defb 0ffh

ch_bd5a:                            ; 0xBD5A
	defb 0feh, 002h, 0e3h, 003h, 0e4h, 01fh, 074h, 01ah
	defb 070h, 005h, 070h, 008h, 070h, 005h, 0e3h, 002h
	defb 070h, 00ah, 0e3h, 003h, 064h, 01ah, 060h, 005h
	defb 060h, 008h, 0e2h, 002h, 050h, 005h, 0ffh

ch_bd79:                            ; 0xBD79
	defb 0feh, 002h, 0f8h, 014h, 0e2h, 001h, 075h, 05fh
	defb 085h, 000h, 0a6h, 05fh, 0b7h, 090h, 0c5h, 063h
	defb 0c6h, 000h, 0b4h, 090h, 0b5h, 090h, 0c6h, 040h
	defb 0c8h, 000h, 0c5h, 0a9h, 0c7h, 000h, 0c6h, 030h
	defb 0c4h, 060h, 064h, 090h, 065h, 090h, 066h, 040h
	defb 068h, 000h, 067h, 0a9h, 037h, 000h, 036h, 030h
	defb 034h, 060h, 017h, 000h, 016h, 030h, 014h, 060h

