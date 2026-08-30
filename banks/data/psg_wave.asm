; SCC wavetable index (opcode ld de,wave_ptr / add a,a) and 32-byte waves.
; Index 0x7210–0x72A0; unique waves 0x72A0–0x76A0. Many slots point at env_0.

wave_ptr:                            ; 0x7210  was l7210h
	defw wave_72a0, wave_72a0, wave_72a0, wave_72c0, wave_72e0, wave_7300, wave_7320, wave_7340
	defw wave_7360, wave_7360, wave_7380, wave_73a0, wave_73c0, wave_73e0, wave_7400, wave_7400
	defw wave_7400, wave_7400, wave_7420, wave_7440, wave_7460, wave_7480, wave_74a0, wave_74c0
	defw wave_74e0, wave_7500, wave_7500, wave_7520, wave_7540, wave_7560, wave_7580, wave_7580
	defw wave_7580, wave_75a0, wave_75c0, wave_75c0, wave_75e0, wave_75e0, wave_7600, wave_7620
	defw wave_7620, wave_7640, wave_7660, wave_7680, wave_7680, wave_7680, env_0, env_0
	defw env_0, env_0, env_0, env_0, env_0, env_0, env_0, env_0
	defw env_0, env_0, env_0, env_0, env_0, env_0, env_0, env_0
	defw env_0, env_0, env_0, env_0, env_0, env_0, env_0, env_0

wave_72a0:                          ; 0x72A0
	defb 000h, 0f8h, 0f0h, 0e8h, 0e0h, 0d8h, 0d0h, 0c8h
	defb 0c0h, 0b8h, 0b0h, 0a8h, 0a0h, 098h, 090h, 088h
	defb 080h, 078h, 070h, 068h, 060h, 058h, 050h, 048h
	defb 040h, 038h, 030h, 028h, 020h, 018h, 010h, 008h

wave_72c0:                          ; 0x72C0
	defb 000h, 0f0h, 0e0h, 0d0h, 0c0h, 0b0h, 0a0h, 090h
	defb 080h, 070h, 060h, 050h, 040h, 030h, 020h, 010h
	defb 000h, 0f0h, 0e0h, 0d0h, 0c0h, 0b0h, 0a0h, 090h
	defb 080h, 070h, 060h, 050h, 040h, 030h, 020h, 010h

wave_72e0:                          ; 0x72E0
	defb 000h, 04eh, 062h, 06dh, 075h, 07ah, 07dh, 07eh
	defb 07fh, 07eh, 07dh, 07ah, 075h, 06dh, 062h, 04eh
	defb 000h, 0b1h, 09dh, 092h, 08ah, 085h, 082h, 081h
	defb 080h, 081h, 082h, 085h, 08ah, 092h, 09dh, 0b1h

wave_7300:                          ; 0x7300
	defb 000h, 019h, 031h, 047h, 05ah, 06ah, 075h, 07dh
	defb 07fh, 07dh, 075h, 06ah, 05ah, 047h, 031h, 019h
	defb 000h, 0e7h, 0cfh, 0b9h, 0a6h, 096h, 08bh, 083h
	defb 080h, 083h, 08bh, 096h, 0a6h, 0b9h, 0cfh, 0e7h

wave_7320:                          ; 0x7320
	defb 000h, 0f0h, 0e0h, 0d0h, 0c0h, 0b0h, 0a0h, 090h
	defb 080h, 090h, 0a0h, 0b0h, 0c0h, 0d0h, 0e0h, 0f0h
	defb 000h, 010h, 020h, 030h, 040h, 050h, 060h, 070h
	defb 07fh, 070h, 060h, 050h, 040h, 030h, 020h, 010h

wave_7340:                          ; 0x7340
	defb 000h, 0e0h, 0c0h, 0a0h, 080h, 0a0h, 0c0h, 0e0h
	defb 000h, 020h, 040h, 060h, 07fh, 060h, 040h, 020h
	defb 000h, 0e0h, 0c0h, 0a0h, 080h, 0a0h, 0c0h, 0e0h
	defb 000h, 020h, 040h, 060h, 07fh, 060h, 040h, 020h

wave_7360:                          ; 0x7360
	defb 000h, 019h, 031h, 047h, 05ah, 06ah, 075h, 07dh
	defb 07fh, 07dh, 075h, 06ah, 05ah, 047h, 031h, 019h
	defb 000h, 0e0h, 0c0h, 0a0h, 080h, 0a0h, 0c0h, 0e0h
	defb 000h, 020h, 040h, 060h, 07fh, 060h, 040h, 020h

wave_7380:                          ; 0x7380
	defb 000h, 019h, 031h, 047h, 05ah, 06ah, 075h, 07dh
	defb 07fh, 07dh, 075h, 06ah, 05ah, 047h, 031h, 019h
	defb 080h, 090h, 0a0h, 0b0h, 0c0h, 0d0h, 0e0h, 0f0h
	defb 000h, 010h, 020h, 030h, 040h, 050h, 060h, 070h

wave_73a0:                          ; 0x73A0
	defb 000h, 019h, 031h, 047h, 05ah, 06ah, 075h, 07dh
	defb 07fh, 07dh, 075h, 06ah, 05ah, 047h, 031h, 019h
	defb 080h, 0a0h, 0c0h, 0e0h, 000h, 020h, 040h, 060h
	defb 080h, 0a0h, 0c0h, 0e0h, 000h, 020h, 040h, 060h

wave_73c0:                          ; 0x73C0
	defb 001h, 02ah, 040h, 050h, 05ch, 068h, 070h, 078h
	defb 07fh, 078h, 070h, 068h, 05ch, 050h, 040h, 02ah
	defb 0ffh, 0d6h, 0c0h, 0b0h, 0a4h, 098h, 090h, 088h
	defb 081h, 088h, 090h, 098h, 0a4h, 0b0h, 0c0h, 0d6h

wave_73e0:                          ; 0x73E0
	defb 000h, 040h, 07fh, 040h, 001h, 0c0h, 081h, 0c0h
	defb 001h, 040h, 07fh, 040h, 001h, 0c0h, 001h, 040h
	defb 001h, 0e0h, 001h, 020h, 001h, 0f0h, 001h, 010h
	defb 001h, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 040h, 040h

wave_7400:                          ; 0x7400
	defb 000h, 040h, 07fh, 040h, 010h, 001h, 0eah, 0d6h
	defb 0c3h, 0b9h, 0afh, 0a4h, 09ch, 095h, 08fh, 08ah
	defb 086h, 083h, 081h, 083h, 086h, 08ah, 08fh, 095h
	defb 09ch, 0a4h, 0afh, 0b9h, 0c3h, 0d6h, 0eah, 0ffh

wave_7420:                          ; 0x7420
	defb 000h, 040h, 07fh, 040h, 000h, 0c0h, 0ffh, 0c0h
	defb 005h, 0ebh, 0d6h, 0c3h, 0b9h, 0afh, 0a4h, 09ch
	defb 095h, 08fh, 089h, 084h, 081h, 084h, 089h, 08fh
	defb 095h, 09ch, 0a4h, 0afh, 0b9h, 0c3h, 0d6h, 0eah

wave_7440:                          ; 0x7440
	defb 000h, 0f0h, 0e0h, 0d0h, 0c0h, 0b0h, 0a0h, 090h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h
	defb 07fh, 070h, 060h, 050h, 040h, 030h, 020h, 010h

wave_7460:                          ; 0x7460
	defb 000h, 030h, 050h, 060h, 070h, 060h, 050h, 030h
	defb 000h, 0d0h, 0b0h, 0a0h, 090h, 0a0h, 0b0h, 0d0h
	defb 000h, 040h, 060h, 070h, 060h, 040h, 000h, 0c0h
	defb 0a0h, 090h, 0a0h, 0c0h, 000h, 070h, 000h, 090h

wave_7480:                          ; 0x7480
	defb 030h, 050h, 050h, 030h, 000h, 000h, 010h, 040h
	defb 060h, 070h, 060h, 030h, 0f0h, 0e0h, 0e0h, 000h
	defb 020h, 020h, 010h, 0c0h, 0a0h, 090h, 0a0h, 0c0h
	defb 000h, 000h, 0d0h, 0b0h, 0b0h, 0d0h, 000h, 000h

wave_74a0:                          ; 0x74A0
	defb 0a0h, 090h, 090h, 0a0h, 0a0h, 0b0h, 0b0h, 0b0h
	defb 0c0h, 0c0h, 0d0h, 0d0h, 0e0h, 0e0h, 0f0h, 0f0h
	defb 000h, 000h, 010h, 010h, 020h, 020h, 030h, 030h
	defb 040h, 040h, 050h, 050h, 060h, 060h, 060h, 050h

wave_74c0:                          ; 0x74C0
	defb 000h, 07fh, 000h, 080h, 0a0h, 0c0h, 0d8h, 0f0h
	defb 008h, 020h, 030h, 040h, 050h, 060h, 070h, 078h
	defb 07ch, 07fh, 07ch, 078h, 070h, 060h, 050h, 040h
	defb 030h, 020h, 008h, 0f0h, 0d8h, 0c0h, 0a0h, 080h

wave_74e0:                          ; 0x74E0
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h

wave_7500:                          ; 0x7500
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

wave_7520:                          ; 0x7520
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 07fh, 080h, 07fh, 080h, 07fh, 080h, 07fh, 080h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

wave_7540:                          ; 0x7540
	defb 080h, 08eh, 0a0h, 0c0h, 0e0h, 000h, 020h, 03fh
	defb 03eh, 03ch, 03ah, 037h, 031h, 029h, 020h, 01ch
	defb 010h, 000h, 0e6h, 0c0h, 0d0h, 000h, 020h, 03fh
	defb 010h, 0e0h, 080h, 0c0h, 000h, 020h, 000h, 090h

wave_7560:                          ; 0x7560
	defb 000h, 070h, 050h, 020h, 050h, 070h, 030h, 000h
	defb 050h, 07fh, 060h, 010h, 030h, 040h, 000h, 0b0h
	defb 010h, 060h, 000h, 0e0h, 0f0h, 000h, 0b0h, 090h
	defb 0c0h, 010h, 0e0h, 0a0h, 0c0h, 0f0h, 0c0h, 0a0h

wave_7580:                          ; 0x7580
	defb 000h, 000h, 000h, 000h, 000h, 078h, 078h, 000h
	defb 000h, 080h, 080h, 080h, 000h, 000h, 000h, 000h
	defb 078h, 078h, 078h, 000h, 080h, 080h, 000h, 000h
	defb 000h, 000h, 078h, 078h, 000h, 000h, 080h, 080h

wave_75a0:                          ; 0x75A0
	defb 078h, 078h, 078h, 078h, 080h, 080h, 080h, 080h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h

wave_75c0:                          ; 0x75C0
	defb 080h, 0b0h, 0c0h, 010h, 01ah, 02ah, 02ch, 01ah
	defb 000h, 0e0h, 0d0h, 0e0h, 022h, 053h, 070h, 075h
	defb 070h, 031h, 0eah, 080h, 088h, 08ah, 08ch, 08eh
	defb 000h, 07fh, 075h, 073h, 062h, 000h, 0c0h, 090h

wave_75e0:                          ; 0x75E0
	defb 000h, 000h, 000h, 000h, 000h, 070h, 070h, 000h
	defb 000h, 080h, 080h, 080h, 000h, 000h, 000h, 000h
	defb 070h, 070h, 070h, 000h, 080h, 080h, 000h, 000h
	defb 000h, 000h, 070h, 070h, 000h, 000h, 080h, 080h

wave_7600:                          ; 0x7600
	defb 000h, 000h, 000h, 080h, 000h, 070h, 070h, 070h
	defb 000h, 000h, 000h, 080h, 000h, 000h, 000h, 080h
	defb 080h, 080h, 080h, 000h, 080h, 000h, 000h, 000h
	defb 000h, 080h, 080h, 080h, 000h, 080h, 080h, 080h

wave_7620:                          ; 0x7620
	defb 070h, 070h, 070h, 070h, 070h, 070h, 070h, 070h
	defb 080h, 080h, 080h, 080h, 080h, 080h, 080h, 080h
	defb 070h, 070h, 070h, 080h, 080h, 080h, 070h, 070h
	defb 070h, 070h, 080h, 080h, 080h, 080h, 080h, 080h

wave_7640:                          ; 0x7640
	defb 0a0h, 090h, 090h, 090h, 0a0h, 0a0h, 0b0h, 0b0h
	defb 0c0h, 0c0h, 0d0h, 0d0h, 0e0h, 0e0h, 0f0h, 0f0h
	defb 000h, 000h, 010h, 010h, 020h, 020h, 030h, 030h
	defb 040h, 040h, 050h, 050h, 060h, 060h, 060h, 050h

wave_7660:                          ; 0x7660
	defb 070h, 070h, 060h, 080h, 090h, 090h, 080h, 080h
	defb 040h, 040h, 030h, 080h, 090h, 090h, 080h, 080h
	defb 020h, 020h, 010h, 080h, 090h, 090h, 080h, 080h
	defb 000h, 000h, 0f0h, 080h, 090h, 090h, 080h, 080h

wave_7680:                          ; 0x7680
	defb 078h, 070h, 068h, 060h, 058h, 050h, 048h, 040h
	defb 038h, 030h, 028h, 020h, 018h, 010h, 008h, 000h
	defb 078h, 070h, 068h, 060h, 058h, 050h, 048h, 040h
	defb 038h, 030h, 028h, 020h, 018h, 010h, 008h, 000h

