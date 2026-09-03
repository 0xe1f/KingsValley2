; bank 0E glyph_ptr payloads (stamp_level / stamp_glyph after page_banks_ef).
; 0x800C: 6 worlds × 8 tile-id lists (draw 8×8 via tile_pset).
; 0x806A: per-level 3-byte records, 0xFF end (level in A, 1-based).
; Unique ptrs; several glyph_ptr slots share a list.

glyphs:                               ; 0x80E4  glyph_ptr[0]
gly_80e4:                          ; 0x80E4  ids 0
	defb 037h, 037h, 026h, 027h, 028h, 029h, 036h, 036h
	defb 039h, 037h, 02ah, 02bh, 02ch, 02dh, 036h, 038h
	defb 03bh, 037h, 02eh, 02fh, 030h, 031h, 036h, 03ah
	defb 037h, 037h, 032h, 033h, 034h, 035h, 036h, 036h
	defb 028h, 029h, 018h, 019h, 01ah, 018h, 026h, 027h
	defb 02ch, 02dh, 01bh, 01ch, 01dh, 01eh, 02ah, 02bh
	defb 030h, 031h, 01fh, 020h, 021h, 022h, 02eh, 02fh
	defb 034h, 035h, 023h, 024h, 025h, 023h, 032h, 033h

gly_8124:                          ; 0x8124  ids 1
	defb 038h, 018h, 039h, 03ah, 038h, 018h, 043h, 044h
	defb 03bh, 03ch, 03dh, 03eh, 01ah, 043h, 045h, 046h
	defb 03ch, 03dh, 03fh, 040h, 047h, 045h, 046h, 01bh
	defb 03dh, 041h, 019h, 042h, 049h, 04ah, 04bh, 01ch
	defb 04ch, 01dh, 04dh, 03ah, 04ch, 01dh, 04dh, 03ah
	defb 01eh, 04eh, 03dh, 04fh, 01eh, 04eh, 03dh, 04fh
	defb 04dh, 03dh, 051h, 01fh, 04dh, 03dh, 051h, 01fh
	defb 03dh, 04fh, 020h, 021h, 03dh, 04fh, 020h, 021h

gly_8164:                          ; 0x8164  ids 2
	defb 020h, 021h, 022h, 023h, 024h, 025h, 026h, 027h
	defb 028h, 029h, 02ah, 02bh, 02ch, 02dh, 02eh, 02fh
	defb 030h, 031h, 032h, 033h, 034h, 030h, 035h, 032h
	defb 036h, 037h, 038h, 039h, 03ah, 036h, 03bh, 03ch
	defb 03dh, 03eh, 03fh, 040h, 041h, 03dh, 03eh, 03fh
	defb 042h, 043h, 044h, 045h, 02ch, 02dh, 043h, 044h
	defb 030h, 031h, 047h, 048h, 049h, 046h, 035h, 047h
	defb 04ah, 037h, 04bh, 04ch, 04dh, 036h, 037h, 04bh

gly_81a4:                          ; 0x81A4  ids 3
	defb 018h, 019h, 01ah, 01bh, 01ch, 01dh, 01eh, 01fh
	defb 020h, 021h, 022h, 023h, 024h, 025h, 026h, 027h
	defb 028h, 029h, 02ah, 02bh, 02ch, 02dh, 02eh, 02fh
	defb 030h, 031h, 032h, 033h, 034h, 035h, 036h, 037h
	defb 018h, 019h, 01ah, 01bh, 01ch, 01dh, 01eh, 01fh
	defb 020h, 021h, 022h, 023h, 024h, 025h, 026h, 027h
	defb 02eh, 02fh, 028h, 029h, 02ah, 02bh, 02ch, 02dh
	defb 036h, 037h, 030h, 031h, 032h, 033h, 034h, 035h

gly_81e4:                          ; 0x81E4  ids 4
	defb 018h, 043h, 044h, 019h, 01ah, 01bh, 01ch, 01dh
	defb 01eh, 01fh, 020h, 021h, 022h, 023h, 024h, 025h
	defb 026h, 027h, 028h, 029h, 02ah, 02bh, 02ch, 02dh
	defb 02eh, 02fh, 030h, 031h, 032h, 045h, 046h, 033h
	defb 034h, 035h, 018h, 043h, 044h, 019h, 036h, 037h
	defb 037h, 038h, 039h, 01fh, 020h, 03ah, 03bh, 038h
	defb 038h, 03ch, 03dh, 027h, 028h, 03eh, 03fh, 037h
	defb 037h, 038h, 040h, 041h, 030h, 042h, 037h, 038h

gly_8224:                          ; 0x8224  ids 5
	defb 018h, 019h, 01ah, 01bh, 01ch, 01dh, 01eh, 01fh
	defb 020h, 021h, 022h, 023h, 024h, 025h, 026h, 027h
	defb 028h, 029h, 02ah, 02bh, 02ch, 02dh, 02eh, 02fh
	defb 030h, 031h, 032h, 033h, 034h, 035h, 036h, 037h
	defb 038h, 039h, 03ah, 03bh, 044h, 048h, 048h, 045h
	defb 040h, 04dh, 04ch, 041h, 049h, 04ah, 04bh, 049h
	defb 042h, 04eh, 04ah, 043h, 049h, 04ch, 04dh, 049h
	defb 03ch, 03dh, 03eh, 03fh, 046h, 048h, 048h, 047h

gly_8264:                          ; 0x8264  ids 6
	defb 03ch, 03dh, 03eh, 03fh, 040h, 041h, 042h, 043h
	defb 044h, 045h, 046h, 047h, 048h, 049h, 04ah, 04bh

gly_8274:                          ; 0x8274  ids 7
	defb 03ch, 03dh, 03eh, 03fh, 040h, 04ch, 04dh, 043h
	defb 044h, 04eh, 04fh, 050h, 048h, 051h, 052h, 04bh

gly_8284:                          ; 0x8284  ids 8..14
	defb 022h, 023h, 024h, 025h, 026h, 027h, 028h, 029h
	defb 02ah, 02bh, 02ch, 02dh, 02eh, 02fh, 030h, 031h

gly_8294:                          ; 0x8294  ids 15..20
	defb 032h, 033h, 036h, 037h, 034h, 035h

gly_829a:                          ; 0x829A  ids 21
	defb 032h, 033h, 048h, 050h, 034h, 035h

gly_82a0:                          ; 0x82A0  ids 22..26
	defb 018h, 019h, 01ah, 01bh, 01ch, 01dh, 01eh, 01fh

gly_82a8:                          ; 0x82A8  ids 27..30
	defb 038h, 043h, 039h, 03ah, 03eh, 03bh, 044h, 03fh
	defb 03dh, 040h, 041h, 042h, 045h, 03ch, 046h, 047h

gly_82b8:                          ; 0x82B8  ids 31..32
	defb 043h, 039h, 03bh, 044h, 048h, 049h, 03ch, 046h

gly_82c0:                          ; 0x82C0  ids 33..36
	defb 04ah, 04bh, 04ah, 04bh, 04ah, 04bh

gly_82c6:                          ; 0x82C6  ids 37..38
	defb 047h, 048h, 049h, 04ah, 04bh, 04ch, 04dh, 04eh
	defb 04fh, 050h, 051h, 052h, 053h, 054h, 055h, 056h

gly_82d6:                          ; 0x82D6  ids 39..46
	defb 044h, 050h, 04ch, 045h, 050h, 04dh, 04fh, 051h
	defb 04fh, 04eh, 04ah, 04fh, 046h, 051h, 04dh, 047h

gly_82e6:                          ; 0x82E6  ids 47..48
	defb 049h, 042h, 052h, 053h, 054h, 055h, 049h, 040h

gly_82ee:                          ; 0x82EE  ids 49..54
	defb 090h, 030h, 000h, 091h, 0b0h, 000h, 0ffh

gly_82f5:                          ; 0x82F5  ids 55
	defb 091h, 040h, 000h, 091h, 0a0h, 000h, 0ffh

gly_82fc:                          ; 0x82FC  ids 56
	defb 010h, 030h, 000h, 010h, 0b0h, 000h, 011h, 031h
	defb 000h, 011h, 0b1h, 000h, 0ffh

gly_8309:                          ; 0x8309  ids 57
	defb 011h, 070h, 000h, 050h, 020h, 000h, 050h, 0c0h
	defb 000h, 0ffh

gly_8313:                          ; 0x8313  ids 58
	defb 021h, 0d0h, 000h, 091h, 020h, 000h, 020h, 011h
	defb 000h, 090h, 0c1h, 000h, 0ffh

gly_8320:                          ; 0x8320  ids 59
	defb 031h, 040h, 000h, 030h, 0a0h, 000h, 091h, 041h
	defb 000h, 090h, 0a1h, 000h, 0ffh

gly_832d:                          ; 0x832D  ids 60
	defb 010h, 040h, 000h, 011h, 0a0h, 000h, 0ffh

gly_8334:                          ; 0x8334  ids 61
	defb 031h, 042h, 000h, 030h, 08ah, 000h, 0ffh

gly_833b:                          ; 0x833B  ids 62
	defb 0ffh

gly_833c:                          ; 0x833C  ids 63
	defb 009h, 050h, 000h, 009h, 0b0h, 000h, 008h, 031h
	defb 000h, 008h, 091h, 000h, 0ffh

gly_8349:                          ; 0x8349  ids 64
	defb 0ffh

gly_834a:                          ; 0x834A  ids 65
	defb 067h, 040h, 004h, 027h, 0d0h, 004h, 050h, 051h
	defb 000h, 0ffh

gly_8354:                          ; 0x8354  ids 66
	defb 050h, 048h, 000h, 076h, 030h, 006h, 048h, 061h
	defb 000h, 046h, 05ah, 003h, 06eh, 09ah, 004h, 0ffh

gly_8364:                          ; 0x8364  ids 67
	defb 017h, 041h, 004h, 017h, 0b1h, 004h, 09eh, 079h
	defb 004h, 0ffh

gly_836e:                          ; 0x836E  ids 68
	defb 00fh, 020h, 004h, 00eh, 0c0h, 004h, 00fh, 041h
	defb 004h, 00fh, 0b1h, 004h, 00eh, 022h, 004h, 008h
	defb 072h, 000h, 00eh, 0d2h, 004h, 0ffh

gly_8384:                          ; 0x8384  ids 69
	defb 0ffh

gly_8385:                          ; 0x8385  ids 70
	defb 00fh, 010h, 004h, 010h, 038h, 000h, 00fh, 070h
	defb 004h, 038h, 051h, 000h, 038h, 091h, 000h, 09eh
	defb 031h, 004h, 09fh, 0c1h, 004h, 00eh, 0d2h, 004h
	defb 09fh, 052h, 004h, 0ffh

gly_83a1:                          ; 0x83A1  ids 71
	defb 08eh, 088h, 006h, 0a7h, 041h, 003h, 0a6h, 0b1h
	defb 003h, 010h, 0d2h, 000h, 070h, 012h, 000h, 0ffh

gly_83b1:                          ; 0x83B1  ids 72
	defb 016h, 038h, 004h, 016h, 0c8h, 004h, 0ffh

gly_83b8:                          ; 0x83B8  ids 73
	defb 00fh, 078h, 005h, 086h, 060h, 004h, 086h, 090h
	defb 004h, 000h, 071h, 000h, 087h, 041h, 003h, 087h
	defb 0b1h, 003h, 0ffh

gly_83cb:                          ; 0x83CB  ids 74
	defb 014h, 038h, 000h, 0ffh

gly_83cf:                          ; 0x83CF  ids 75
	defb 034h, 0b8h, 000h, 06ch, 091h, 000h, 09ch, 0aah
	defb 000h, 0ffh

gly_83d9:                          ; 0x83D9  ids 76
	defb 0ffh

gly_83da:                          ; 0x83DA  ids 77
	defb 07ch, 038h, 000h, 09ch, 0d0h, 000h, 04ch, 029h
	defb 000h, 07ch, 071h, 000h, 08ch, 03ah, 000h, 08ch
	defb 0bah, 000h, 054h, 02bh, 000h, 054h, 0b3h, 000h
	defb 0ffh

gly_83f3:                          ; 0x83F3  ids 78
	defb 02ch, 028h, 000h, 0ffh

gly_83f7:                          ; 0x83F7  ids 79
	defb 014h, 078h, 000h, 014h, 071h, 000h, 014h, 072h
	defb 000h, 0ffh

gly_8401:                          ; 0x8401  ids 80
	defb 014h, 050h, 000h, 04ch, 091h, 000h, 084h, 072h
	defb 000h, 0ffh

gly_840b:                          ; 0x840B  ids 81
	defb 01ch, 068h, 000h, 01ch, 0a2h, 000h, 0ffh

gly_8412:                          ; 0x8412  ids 82
	defb 08ch, 018h, 000h, 064h, 0b8h, 000h, 0ffh

gly_8419:                          ; 0x8419  ids 83
	defb 0ffh

gly_841a:                          ; 0x841A  ids 84
	defb 002h, 018h, 000h, 002h, 058h, 000h, 002h, 098h
	defb 000h, 002h, 0d8h, 000h, 0ffh

gly_8427:                          ; 0x8427  ids 85
	defb 01eh, 0d8h, 007h, 03eh, 018h, 007h, 03eh, 060h
	defb 003h, 03eh, 090h, 003h, 008h, 072h, 000h, 0ffh

gly_8437:                          ; 0x8437  ids 86
	defb 00eh, 010h, 006h, 03eh, 068h, 006h, 06eh, 0e0h
	defb 006h, 0a6h, 068h, 003h, 0a6h, 0e0h, 003h, 070h
	defb 071h, 000h, 00ah, 012h, 000h, 00ah, 0e2h, 000h
	defb 010h, 072h, 000h, 0ffh

gly_8453:                          ; 0x8453  ids 87
	defb 050h, 0d0h, 000h, 00eh, 039h, 003h, 00eh, 0b9h
	defb 003h, 0a6h, 062h, 003h, 0a6h, 092h, 003h, 0ffh

gly_8463:                          ; 0x8463  ids 88
	defb 012h, 038h, 000h, 010h, 070h, 000h, 012h, 0b8h
	defb 000h, 00ah, 059h, 000h, 00ah, 099h, 000h, 06eh
	defb 02ah, 004h, 06eh, 0cah, 004h, 09eh, 02ah, 004h
	defb 09eh, 0cah, 004h, 00eh, 033h, 004h, 00ah, 07bh
	defb 000h, 00eh, 0c3h, 004h, 050h, 073h, 000h, 09ah
	defb 07bh, 000h, 0ffh

gly_848e:                          ; 0x848E  ids 89
	defb 010h, 052h, 000h, 010h, 092h, 000h, 0ffh

gly_8495:                          ; 0x8495  ids 90
	defb 016h, 060h, 004h, 016h, 090h, 004h, 096h, 060h
	defb 004h, 096h, 090h, 004h, 016h, 062h, 004h, 016h
	defb 092h, 004h, 096h, 062h, 004h, 096h, 092h, 004h
	defb 0ffh

gly_84ae:                          ; 0x84AE  ids 91
	defb 0ffh

gly_84af:                          ; 0x84AF  ids 92
	defb 042h, 090h, 000h, 062h, 060h, 000h, 082h, 090h
	defb 000h, 0ffh

gly_84b9:                          ; 0x84B9  ids 93
	defb 022h, 040h, 000h, 020h, 060h, 000h, 022h, 090h
	defb 000h, 022h, 061h, 000h, 020h, 081h, 000h, 022h
	defb 0b1h, 000h, 0ffh

gly_84cc:                          ; 0x84CC  ids 94
	defb 0ffh

gly_84cd:                          ; 0x84CD  ids 95
	defb 038h, 071h, 000h, 0ffh

gly_84d1:                          ; 0x84D1  ids 96
	defb 020h, 020h, 000h, 020h, 0c0h, 000h, 018h, 011h
	defb 000h, 018h, 071h, 000h, 018h, 0d1h, 000h, 010h
	defb 072h, 000h, 0ffh

gly_84e4:                          ; 0x84E4  ids 97
	defb 038h, 073h, 000h, 030h, 04dh, 000h, 030h, 09dh
	defb 000h, 0ffh

gly_84ee:                          ; 0x84EE  ids 98
	defb 0ffh

gly_84ef:                          ; 0x84EF  ids 99
	defb 008h, 020h, 000h, 008h, 0c0h, 000h, 0ffh

gly_84f6:                          ; 0x84F6  ids 100
	defb 0ffh

gly_84f7:                          ; 0x84F7  ids 101
	defb 050h, 071h, 000h, 018h, 072h, 000h, 0ffh

gly_84fe:                          ; 0x84FE  ids 102
	defb 010h, 018h, 000h, 010h, 0c8h, 000h, 088h, 018h
	defb 000h, 088h, 0c8h, 000h, 0ffh

gly_850b:                          ; 0x850B  ids 103
	defb 0ffh

gly_850c:                          ; 0x850C  ids 104
	defb 000h, 040h, 000h, 000h, 0a0h, 000h, 040h, 0e0h
	defb 000h, 0ffh

gly_8516:                          ; 0x8516  ids 105
	defb 0ffh

gly_8517:                          ; 0x8517  ids 106
	defb 000h, 040h, 000h, 000h, 0a0h, 000h, 072h, 0b8h
	defb 000h, 080h, 020h, 000h, 000h, 021h, 000h, 000h
	defb 041h, 000h, 052h, 0b9h, 000h, 080h, 0c1h, 000h
	defb 000h, 022h, 000h, 000h, 082h, 000h, 080h, 0c2h
	defb 000h, 0ffh

gly_8539:                          ; 0x8539  ids 107
	defb 0ffh

gly_853a:                          ; 0x853A  ids 108
	defb 000h, 080h, 000h, 000h, 0c0h, 000h, 032h, 0b8h
	defb 000h, 092h, 0b8h, 000h, 040h, 001h, 000h, 052h
	defb 0b9h, 000h, 0ffh

gly_854d:                          ; 0x854D  ids 109
	defb 0ffh

gly_854e:                          ; 0x854E  ids 110
	defb 000h, 020h, 000h, 000h, 0c0h, 000h, 060h, 0a0h
	defb 000h, 092h, 0b8h, 000h, 000h, 021h, 000h, 000h
	defb 0c1h, 000h, 072h, 039h, 000h, 080h, 001h, 000h
	defb 0ffh

gly_8567:                          ; 0x8567  ids 111
	defb 0ffh

gly_8568:                          ; 0x8568  ids 112
	defb 000h, 080h, 000h, 020h, 040h, 000h, 000h, 041h
	defb 000h, 000h, 0a1h, 000h, 000h, 022h, 000h, 060h
	defb 022h, 000h, 072h, 0bah, 000h, 000h, 0a3h, 000h
	defb 040h, 023h, 000h, 092h, 03bh, 000h, 0a0h, 063h
	defb 000h, 0ffh

