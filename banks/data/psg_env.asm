; Envelope pointer tables (sub_653dh). env_0 has 12 streams; env_1..env_5
; are 12 words pointing at a single 0xFF terminator.

env_0:                               ; 0x76A0  was l76a0h
	defw env_76b8, env_76bf, env_76cc, env_76e1, env_76fa, env_7712
	defw env_772b, env_7744, env_775f, env_777c, env_778b, env_77a6

env_76b8:                          ; 0x76B8
	defb 0e1h, 001h, 0e4h, 000h, 007h, 005h, 0ffh

env_76bf:                          ; 0x76BF
	defb 0e3h, 001h, 0e4h, 000h, 08ah, 000h, 0e1h, 004h
	defb 006h, 005h, 004h, 003h, 0ffh

env_76cc:                          ; 0x76CC
	defb 0e1h, 001h, 0e4h, 014h, 007h, 0e2h, 001h, 072h
	defb 000h, 0e1h, 002h, 0e4h, 010h, 003h, 002h, 0e1h
	defb 001h, 0e4h, 006h, 002h, 0ffh

env_76e1:                          ; 0x76E1
	defb 0e2h, 001h, 0e5h, 00ah, 000h, 042h, 0c1h, 0b0h
	defb 0e8h, 0e1h, 001h, 0e4h, 008h, 008h, 007h, 006h
	defb 005h, 004h, 003h, 002h, 002h, 001h, 001h, 000h
	defb 0ffh

env_76fa:                          ; 0x76FA
	defb 0e2h, 002h, 0e5h, 009h, 000h, 0d0h, 0a2h, 080h
	defb 0e1h, 002h, 0e4h, 007h, 006h, 0e1h, 001h, 0e4h
	defb 003h, 005h, 004h, 003h, 002h, 001h, 000h, 0ffh

env_7712:                          ; 0x7712
	defb 0e2h, 001h, 0a1h, 02ah, 091h, 04ah, 081h, 055h
	defb 071h, 060h, 061h, 06ah, 051h, 075h, 041h, 080h
	defb 031h, 08ah, 021h, 095h, 011h, 0a0h, 001h, 0b0h
	defb 0ffh

env_772b:                          ; 0x772B
	defb 0e2h, 001h, 0b1h, 05ah, 091h, 080h, 081h, 08ah
	defb 071h, 095h, 061h, 0a0h, 051h, 0aah, 041h, 0b5h
	defb 031h, 0c0h, 021h, 0cah, 011h, 0d5h, 001h, 0e0h
	defb 0ffh

env_7744:                          ; 0x7744
	defb 0e2h, 001h, 0b1h, 095h, 0a1h, 0c0h, 091h, 0cah
	defb 0b1h, 0d5h, 071h, 0e0h, 061h, 0eah, 051h, 0f5h
	defb 042h, 000h, 032h, 00ah, 022h, 015h, 012h, 020h
	defb 002h, 030h, 0ffh

env_775f:                          ; 0x775F
	defb 0e2h, 001h, 0c1h, 0e0h, 0b2h, 010h, 0a2h, 01ah
	defb 092h, 025h, 082h, 030h, 072h, 03ah, 062h, 045h
	defb 052h, 050h, 042h, 05ah, 032h, 065h, 022h, 070h
	defb 012h, 07ah, 002h, 085h, 0ffh

env_777c:                          ; 0x777C
	defb 0e2h, 001h, 0e5h, 009h, 001h, 0a0h, 094h, 050h
	defb 096h, 000h, 097h, 000h, 098h, 000h, 0ffh

env_778b:                          ; 0x778B
	defb 0e3h, 001h, 0e4h, 00fh, 0e5h, 009h, 000h, 0b0h
	defb 001h, 060h, 0e8h, 0e3h, 002h, 0e4h, 000h, 0b0h
	defb 000h, 050h, 007h, 0e1h, 001h, 005h, 004h, 003h
	defb 002h, 001h, 0ffh

env_77a6:                          ; 0x77A6
	defb 0e0h, 001h, 0e3h, 001h, 0e4h, 00fh, 0e5h, 003h
	defb 000h, 0a0h, 001h, 060h, 0e8h, 0e3h, 002h, 0e4h
	defb 000h, 0b0h, 000h, 050h, 007h, 0e1h, 001h, 005h
	defb 004h, 003h, 002h, 0e3h, 002h, 060h, 000h, 030h
	defb 007h, 0e1h, 001h, 003h, 002h, 001h, 001h, 0e3h
	defb 002h, 040h, 000h, 020h, 007h, 0e1h, 002h, 002h
	defb 001h, 0e3h, 002h, 020h, 000h, 010h, 007h, 0e1h
	defb 004h, 001h, 0ffh

env_1:                               ; 0x77E1  was l77e1h
	defw env_77f9, env_77f9, env_77f9, env_77f9, env_77f9, env_77f9
	defw env_77f9, env_77f9, env_77f9, env_77f9, env_77f9, env_77f9
env_77f9:
	defb 0ffh

env_2:                               ; 0x77FA  was l77fah
	defw env_7812, env_7812, env_7812, env_7812, env_7812, env_7812
	defw env_7812, env_7812, env_7812, env_7812, env_7812, env_7812
env_7812:
	defb 0ffh

env_3:                               ; 0x7813  was l7813h
	defw env_782b, env_782b, env_782b, env_782b, env_782b, env_782b
	defw env_782b, env_782b, env_782b, env_782b, env_782b, env_782b
env_782b:
	defb 0ffh

env_4:                               ; 0x782C  was l782ch
	defw env_7844, env_7844, env_7844, env_7844, env_7844, env_7844
	defw env_7844, env_7844, env_7844, env_7844, env_7844, env_7844
env_7844:
	defb 0ffh

env_5:                               ; 0x7845  was l7845h
	defw env_785d, env_785d, env_785d, env_785d, env_785d, env_785d
	defw env_785d, env_785d, env_785d, env_785d, env_785d, env_785d
env_785d:
	defb 0ffh

