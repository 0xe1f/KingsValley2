; packed map-bit overlays -> E900 / secret-entrance E7C0 (bank 0C).
; load_obj (obj_ptr) / load_obj2 (obj2_ptr): 2-byte stamps, 0xFF = next
; screen (+0xC0 dest), 0 end. Offset = record>>7. Byte0 bits 5-6 = starting
; nibble, bits 0-4 = run; each step writes cell 1 twice (2-wide) down a row.

obj_a363:                         ; pyramid 1
	defb 026h, 003h
	defb 0a6h, 041h
	defb 022h, 05bh
	defb 000h               ; end
obj_a36a:                         ; pyramid 2
	defb 000h               ; end
obj_a36b:                         ; pyramid 3
	defb 050h, 018h
	defb 090h, 01bh
	defb 0ffh               ; next screen
	defb 04ah, 01ah
	defb 005h, 02dh
	defb 0c6h, 042h
	defb 000h               ; end
obj_a377:                         ; pyramid 4
	defb 007h, 001h
	defb 0c7h, 002h
	defb 048h, 01ch
	defb 088h, 01fh
	defb 007h, 03dh
	defb 0c7h, 03eh
	defb 082h, 05bh
	defb 0ffh               ; next screen
	defb 087h, 003h
	defb 088h, 01ch
	defb 048h, 01fh
	defb 047h, 03ch
	defb 087h, 03fh
	defb 002h, 059h
	defb 0c2h, 05ah
	defb 000h               ; end
obj_a395:                         ; pyramid 5
	defb 034h, 00ch
	defb 0ffh               ; next screen
	defb 08bh, 01ah
	defb 0b4h, 00fh
	defb 000h               ; end
obj_a39d:                         ; pyramid 6
	defb 095h, 013h
	defb 0ffh               ; next screen
	defb 096h, 003h
	defb 000h               ; end
obj_a3a3:                         ; pyramid 7
	defb 0c5h, 022h
	defb 005h, 037h
	defb 0c5h, 04ah
	defb 001h, 05fh
	defb 0ffh               ; next screen
	defb 003h, 003h
	defb 0c5h, 00eh
	defb 005h, 023h
	defb 0c5h, 036h
	defb 005h, 04bh
	defb 000h               ; end
obj_a3b7:                         ; pyramid 8
	defb 005h, 04dh
	defb 0e5h, 04dh
	defb 0e5h, 04eh
	defb 0a1h, 05fh
	defb 0ffh               ; next screen
	defb 0c5h, 011h
	defb 045h, 025h
	defb 0c5h, 038h
	defb 0ffh               ; next screen
	defb 004h, 001h
	defb 0eah, 001h
	defb 0e4h, 002h
	defb 0b7h, 003h
	defb 0a4h, 012h
	defb 0ech, 022h
	defb 06ah, 028h
	defb 023h, 053h
	defb 023h, 050h
	defb 000h               ; end
obj_a3da:                         ; pyramid 9
	defb 092h, 017h
	defb 000h               ; end
obj_a3dd:                         ; pyramid 10
	defb 000h               ; end
obj2_a3de:                        ; secret pyramid 1,2,3,4,5,6,7,8
	defb 000h               ; end
obj2_a3df:                        ; secret pyramid 9
	defb 086h, 03eh
	defb 000h               ; end
obj2_a3e2:                        ; secret pyramid 10
	defb 0ffh               ; next screen
	defb 06eh, 014h
	defb 000h               ; end
obj_a3e6:                         ; pyramid 11
	defb 0a6h, 018h
	defb 028h, 021h
	defb 024h, 023h
	defb 0a4h, 032h
	defb 0a9h, 039h
	defb 026h, 042h
	defb 000h               ; end
obj_a3f3:                         ; pyramid 12
	defb 000h               ; end
obj_a3f4:                         ; pyramid 13
	defb 0d2h, 01ah
	defb 082h, 058h
	defb 082h, 05bh
	defb 0ffh               ; next screen
	defb 08eh, 000h
	defb 0c6h, 002h
	defb 098h, 003h
	defb 084h, 050h
	defb 004h, 052h
	defb 0ffh               ; next screen
	defb 090h, 000h
	defb 007h, 002h
	defb 094h, 003h
	defb 000h               ; end
obj_a40d:                         ; pyramid 14
	defb 044h, 019h
	defb 0c4h, 019h
	defb 044h, 01bh
	defb 0c6h, 028h
	defb 046h, 02ah
	defb 046h, 040h
	defb 046h, 041h
	defb 0c8h, 042h
	defb 082h, 058h
	defb 0c2h, 059h
	defb 0ffh               ; next screen
	defb 08fh, 018h
	defb 04fh, 01bh
	defb 047h, 039h
	defb 087h, 03ah
	defb 0ffh               ; next screen
	defb 086h, 000h
	defb 0c6h, 001h
	defb 0c6h, 002h
	defb 046h, 019h
	defb 04ch, 01ah
	defb 048h, 01bh
	defb 046h, 030h
	defb 0c4h, 039h
	defb 0c6h, 042h
	defb 0c4h, 048h
	defb 000h               ; end
obj_a440:                         ; pyramid 15
	defb 0a9h, 015h
	defb 0a9h, 017h
	defb 0a9h, 038h
	defb 0a9h, 03ah
	defb 0ffh               ; next screen
	defb 0a9h, 021h
	defb 0a9h, 023h
	defb 0a9h, 02ch
	defb 0a9h, 02eh
	defb 0ffh               ; next screen
	defb 026h, 014h
	defb 0b2h, 017h
	defb 029h, 038h
	defb 000h               ; end
obj_a459:                         ; pyramid 16
	defb 0a1h, 05fh
	defb 0ffh               ; next screen
	defb 0a4h, 003h
	defb 046h, 029h
	defb 086h, 039h
	defb 044h, 042h
	defb 000h               ; end
obj_a465:                         ; pyramid 17
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0b2h, 017h
	defb 000h               ; end
obj_a46a:                         ; pyramid 18
	defb 005h, 00fh
	defb 069h, 01eh
	defb 007h, 033h
	defb 084h, 04eh
	defb 0ffh               ; next screen
	defb 0a4h, 020h
	defb 006h, 029h
	defb 0c6h, 02ah
	defb 0a3h, 040h
	defb 0ffh               ; next screen
	defb 045h, 00ch
	defb 064h, 011h
	defb 024h, 021h
	defb 0a8h, 023h
	defb 0c7h, 031h
	defb 047h, 043h
	defb 004h, 04dh
	defb 000h               ; end
obj_a48b:                         ; pyramid 19
	defb 066h, 002h
	defb 085h, 02ah
	defb 062h, 05ah
	defb 000h               ; end
obj_a492:                         ; pyramid 20
	defb 0a4h, 013h
	defb 064h, 023h
	defb 0a4h, 033h
	defb 064h, 043h
	defb 0a4h, 053h
	defb 0c4h, 052h
	defb 0ffh               ; next screen
	defb 0c4h, 002h
	defb 0a4h, 003h
	defb 064h, 013h
	defb 0a4h, 023h
	defb 066h, 027h
	defb 0a6h, 037h
	defb 064h, 04fh
	defb 024h, 03fh
	defb 000h               ; end
obj2_a4b0:                        ; secret pyramid 12
	defb 086h, 019h
obj2_a4b2:                        ; secret pyramid 11,13,14,15
	defb 000h               ; end
obj2_a4b3:                        ; secret pyramid 16
	defb 084h, 015h
	defb 004h, 026h
	defb 084h, 036h
	defb 004h, 047h
	defb 000h               ; end
obj2_a4bc:                        ; secret pyramid 17
	defb 0e5h, 04ah
	defb 0ffh               ; next screen
	defb 02bh, 01ch
	defb 045h, 049h
	defb 0a5h, 04ah
	defb 0ffh               ; next screen
	defb 066h, 014h
	defb 0edh, 014h
	defb 044h, 027h
	defb 005h, 037h
	defb 045h, 048h
	defb 005h, 04ah
	defb 0c5h, 04ah
	defb 000h               ; end
obj2_a4d5:                        ; secret pyramid 18
	defb 028h, 03dh
obj2_a4d7:                        ; secret pyramid 19,20
	defb 000h               ; end
obj_a4d8:                         ; pyramid 21
	defb 032h, 014h
	defb 0abh, 017h
	defb 024h, 021h
	defb 0a4h, 022h
	defb 0a3h, 042h
	defb 003h, 04eh
	defb 063h, 016h
	defb 000h               ; end
obj_a4e7:                         ; pyramid 22
	defb 046h, 010h
	defb 042h, 027h
	defb 047h, 029h
	defb 002h, 037h
	defb 0c6h, 03eh
	defb 0ffh               ; next screen
	defb 043h, 010h
	defb 086h, 044h
	defb 006h, 045h
	defb 0ffh               ; next screen
	defb 089h, 010h
	defb 046h, 013h
	defb 0c5h, 021h
	defb 045h, 035h
	defb 047h, 043h
	defb 005h, 04ah
	defb 000h               ; end
obj_a506:                         ; pyramid 23
	defb 037h, 004h
	defb 0c4h, 010h
	defb 0ceh, 021h
	defb 04eh, 023h
	defb 0c6h, 030h
	defb 046h, 032h
	defb 042h, 05ah
	defb 0ffh               ; next screen
	defb 0c8h, 011h
	defb 0b7h, 007h
	defb 0c4h, 028h
	defb 046h, 029h
	defb 044h, 032h
	defb 044h, 038h
	defb 0c4h, 051h
	defb 042h, 058h
	defb 0ffh               ; next screen
	defb 037h, 000h
	defb 04eh, 002h
	defb 0d0h, 011h
	defb 04ch, 01bh
	defb 0c6h, 020h
	defb 0c5h, 048h
	defb 085h, 04bh
	defb 0ffh               ; next screen
	defb 0b7h, 003h
	defb 048h, 000h
	defb 0c6h, 001h
	defb 044h, 011h
	defb 044h, 012h
	defb 004h, 021h
	defb 08dh, 028h
	defb 087h, 042h
	defb 000h               ; end
obj_a546:                         ; pyramid 24
	defb 048h, 013h
	defb 044h, 021h
	defb 0c4h, 031h
	defb 084h, 042h
	defb 0c4h, 050h
	defb 0ffh               ; next screen
	defb 0c4h, 000h
	defb 0c8h, 022h
	defb 044h, 031h
	defb 0c4h, 040h
	defb 044h, 043h
	defb 084h, 051h
	defb 0c4h, 052h
	defb 0ffh               ; next screen
	defb 0c7h, 020h
	defb 08eh, 023h
	defb 004h, 02fh
	defb 0ffh               ; next screen
	defb 083h, 001h
	defb 0c3h, 002h
	defb 084h, 01dh
	defb 048h, 03fh
	defb 024h, 02ch
	defb 084h, 04eh
	defb 000h               ; end
obj_a574:                         ; pyramid 25
	defb 0e2h, 016h
	defb 022h, 01fh
	defb 0a2h, 02fh
	defb 022h, 02fh
	defb 0e2h, 036h
	defb 062h, 037h
	defb 0a2h, 03eh
	defb 022h, 03fh
	defb 0a2h, 03fh
	defb 062h, 046h
	defb 0e2h, 046h
	defb 062h, 047h
	defb 022h, 044h
	defb 062h, 04ch
	defb 0a2h, 04fh
	defb 022h, 054h
	defb 062h, 027h
	defb 000h               ; end
obj_a597:                         ; pyramid 26
	defb 051h, 014h
	defb 0cbh, 015h
	defb 0ffh               ; next screen
	defb 045h, 034h
	defb 02dh, 015h
	defb 0c5h, 048h
	defb 0ffh               ; next screen
	defb 085h, 014h
	defb 00eh, 015h
	defb 08ch, 017h
	defb 006h, 047h
	defb 000h               ; end
obj_a5ac:                         ; pyramid 27
	defb 065h, 01ch
	defb 083h, 025h
	defb 044h, 033h
	defb 0e3h, 040h
	defb 0ffh               ; next screen
	defb 084h, 010h
	defb 00ch, 003h
	defb 0c5h, 01dh
	defb 0abh, 030h
	defb 067h, 031h
	defb 003h, 041h
	defb 0a4h, 04fh
	defb 001h, 05dh
	defb 0ffh               ; next screen
	defb 004h, 001h
	defb 084h, 013h
	defb 084h, 020h
	defb 044h, 021h
	defb 087h, 032h
	defb 004h, 04dh
	defb 001h, 05fh
	defb 000h               ; end
obj_a5d5:                         ; pyramid 28
	defb 086h, 018h
	defb 0c6h, 01ah
	defb 082h, 032h
	defb 042h, 03ah
	defb 082h, 042h
	defb 046h, 048h
	defb 006h, 04ah
	defb 082h, 05bh
	defb 0ffh               ; next screen
	defb 0d0h, 019h
	defb 0ffh               ; next screen
	defb 045h, 000h
	defb 005h, 002h
	defb 085h, 003h
	defb 089h, 014h
	defb 08ah, 033h
	defb 007h, 017h
	defb 000h               ; end
obj_a5f6:                         ; pyramid 29
	defb 023h, 018h
	defb 003h, 01bh
	defb 000h               ; end
obj_a5fb:                         ; pyramid 30
	defb 034h, 00ch
	defb 084h, 00eh
	defb 084h, 02ch
	defb 024h, 04dh
	defb 084h, 04fh
	defb 0ffh               ; next screen
	defb 0a4h, 01fh
	defb 0a4h, 02dh
	defb 004h, 02fh
	defb 0a4h, 03ch
	defb 004h, 03eh
	defb 0a4h, 04fh
	defb 000h               ; end
obj2_a613:                        ; secret pyramid 21
	defb 000h               ; end
obj2_a614:                        ; secret pyramid 22
	defb 0ffh               ; next screen
	defb 06ah, 02fh
obj2_a617:                        ; secret pyramid 23
	defb 000h               ; end
obj2_a618:                        ; secret pyramid 24
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0c6h, 044h
obj2_a61d:                        ; secret pyramid 25,26
	defb 000h               ; end
obj2_a61e:                        ; secret pyramid 27
	defb 027h, 040h
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0a4h, 033h
	defb 000h               ; end
obj2_a625:                        ; secret pyramid 28
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 046h, 038h
	defb 000h               ; end
obj2_a62a:                        ; secret pyramid 29
	defb 0abh, 01bh
obj2_a62c:                        ; secret pyramid 30
	defb 000h               ; end
obj_a62d:                         ; pyramid 31
	defb 024h, 01ch
	defb 026h, 015h
	defb 0e2h, 015h
	defb 0a2h, 016h
	defb 0a4h, 017h
	defb 0a2h, 024h
	defb 062h, 02ch
	defb 0e2h, 02ch
	defb 022h, 035h
	defb 062h, 03dh
	defb 0a2h, 045h
	defb 0e4h, 03eh
	defb 024h, 02fh
	defb 064h, 01fh
	defb 0a4h, 04fh
	defb 000h               ; end
obj_a64c:                         ; pyramid 32
	defb 003h, 003h
	defb 004h, 019h
	defb 0c4h, 01ah
	defb 0c4h, 03ah
	defb 021h, 05ch
	defb 0ffh               ; next screen
	defb 024h, 000h
	defb 02ah, 038h
	defb 0cah, 010h
	defb 0d3h, 011h
	defb 0c9h, 012h
	defb 0b4h, 013h
	defb 0ffh               ; next screen
	defb 026h, 000h
	defb 0a6h, 003h
	defb 00ch, 01ah
	defb 005h, 04fh
	defb 000h               ; end
obj_a66d:                         ; pyramid 33
	defb 087h, 002h
	defb 0c6h, 01ch
	defb 086h, 034h
	defb 08bh, 036h
	defb 0ffh               ; next screen
	defb 085h, 001h
	defb 0cch, 01ch
	defb 046h, 037h
	defb 004h, 04eh
	defb 081h, 05dh
	defb 046h, 01eh
	defb 0ffh               ; next screen
	defb 00ch, 01eh
	defb 006h, 01fh
	defb 000h               ; end
obj_a688:                         ; pyramid 34
	defb 037h, 004h
	defb 086h, 048h
	defb 0c7h, 02ch
	defb 0c5h, 035h
	defb 006h, 026h
	defb 047h, 012h
	defb 0ffh               ; next screen
	defb 066h, 034h
	defb 0b3h, 013h
	defb 001h, 05fh
	defb 0ffh               ; next screen
	defb 037h, 000h
	defb 08ah, 000h
	defb 0c2h, 020h
	defb 042h, 021h
	defb 042h, 022h
	defb 0c2h, 022h
	defb 002h, 029h
	defb 082h, 029h
	defb 082h, 02ah
	defb 0c2h, 030h
	defb 042h, 031h
	defb 042h, 032h
	defb 0c2h, 032h
	defb 002h, 039h
	defb 082h, 039h
	defb 082h, 03ah
	defb 044h, 042h
	defb 083h, 052h
	defb 0ffh               ; next screen
	defb 048h, 014h
	defb 08ah, 034h
	defb 0c6h, 00eh
	defb 003h, 003h
	defb 082h, 00ch
	defb 000h               ; end
obj_a6cc:                         ; pyramid 35
	defb 0ffh               ; next screen
	defb 0c1h, 05eh
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0c5h, 002h
	defb 000h               ; end
obj_a6d4:                         ; pyramid 36
	defb 046h, 003h
	defb 089h, 03fh
	defb 0ffh               ; next screen
	defb 0c8h, 028h
	defb 048h, 032h
	defb 08eh, 02bh
	defb 084h, 050h
	defb 084h, 051h
	defb 002h, 05bh
	defb 0ffh               ; next screen
	defb 084h, 003h
	defb 046h, 028h
	defb 00dh, 029h
	defb 0cbh, 02ah
	defb 0c5h, 049h
	defb 048h, 043h
	defb 0ffh               ; next screen
	defb 088h, 000h
	defb 086h, 001h
	defb 008h, 003h
	defb 084h, 003h
	defb 0cah, 028h
	defb 0c8h, 021h
	defb 0aeh, 023h
	defb 000h               ; end
obj_a702:                         ; pyramid 37
	defb 051h, 014h
	defb 0ffh               ; next screen
	defb 047h, 014h
	defb 046h, 02ah
	defb 088h, 02bh
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0c5h, 000h
	defb 0c8h, 040h
	defb 045h, 02eh
	defb 084h, 03ah
	defb 0c4h, 04ah
	defb 08dh, 017h
	defb 000h               ; end
obj_a71a:                         ; pyramid 38
	defb 053h, 014h
	defb 025h, 01ah
	defb 00bh, 02dh
	defb 086h, 02fh
	defb 0ffh               ; next screen
	defb 0d1h, 015h
	defb 086h, 016h
	defb 046h, 02fh
	defb 0c2h, 05ah
	defb 0ffh               ; next screen
	defb 056h, 000h
	defb 0ffh               ; next screen
	defb 0ceh, 002h
	defb 046h, 031h
	defb 000h               ; end
obj_a734:                         ; pyramid 39
	defb 022h, 04ch
	defb 0a2h, 04fh
	defb 000h               ; end
obj_a739:                         ; pyramid 40
	defb 041h, 05ch
	defb 082h, 042h
	defb 002h, 03bh
	defb 082h, 043h
	defb 0ffh               ; next screen
	defb 042h, 040h
	defb 0c2h, 038h
	defb 042h, 041h
	defb 081h, 05fh
	defb 0ffh               ; next screen
	defb 045h, 000h
	defb 082h, 014h
	defb 002h, 01dh
	defb 082h, 025h
	defb 002h, 02eh
	defb 082h, 036h
	defb 002h, 03fh
	defb 0ffh               ; next screen
	defb 082h, 014h
	defb 082h, 015h
	defb 082h, 016h
	defb 002h, 01dh
	defb 002h, 01eh
	defb 0c2h, 01eh
	defb 082h, 024h
	defb 082h, 025h
	defb 042h, 026h
	defb 002h, 02dh
	defb 0c2h, 02dh
	defb 082h, 034h
	defb 042h, 035h
	defb 0c2h, 03ch
	defb 083h, 003h
	defb 000h               ; end
obj2_a779:                        ; secret pyramid 31
	defb 000h               ; end
obj2_a77a:                        ; secret pyramid 32
	defb 000h               ; end
obj2_a77b:                        ; secret pyramid 33
	defb 000h               ; end
obj2_a77c:                        ; secret pyramid 34
	defb 000h               ; end
obj2_a77d:                        ; secret pyramid 35
	defb 02bh, 030h
	defb 0abh, 033h
	defb 0ffh               ; next screen
	defb 04bh, 033h
	defb 0b1h, 01bh
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 066h, 014h
	defb 066h, 017h
	defb 0e6h, 02ch
	defb 0e6h, 02eh
	defb 086h, 045h
	defb 046h, 046h
	defb 000h               ; end
obj2_a795:                        ; secret pyramid 36
	defb 000h               ; end
obj2_a796:                        ; secret pyramid 37
	defb 000h               ; end
obj2_a797:                        ; secret pyramid 38
	defb 000h               ; end
obj2_a798:                        ; secret pyramid 39
	defb 024h, 01ch
	defb 064h, 01dh
	defb 0e4h, 01eh
	defb 0e6h, 015h
	defb 024h, 034h
	defb 024h, 036h
	defb 024h, 037h
	defb 000h               ; end
obj2_a7a7:                        ; secret pyramid 40
	defb 000h               ; end
obj_a7a8:                         ; pyramid 41
	defb 086h, 028h
	defb 046h, 021h
	defb 046h, 02bh
	defb 002h, 043h
	defb 0c2h, 04ah
	defb 082h, 052h
	defb 000h               ; end
obj_a7b5:                         ; pyramid 42
	defb 082h, 021h
	defb 0ffh               ; next screen
	defb 0c2h, 035h
	defb 044h, 01fh
	defb 004h, 03fh
	defb 000h               ; end
obj_a7bf:                         ; pyramid 43
	defb 06bh, 034h
	defb 0a2h, 02dh
	defb 0e4h, 025h
	defb 022h, 026h
	defb 0a9h, 002h
	defb 0ffh               ; next screen
	defb 028h, 001h
	defb 0ach, 002h
	defb 0ffh               ; next screen
	defb 066h, 000h
	defb 0a1h, 05eh
	defb 0ffh               ; next screen
	defb 068h, 018h
	defb 021h, 05dh
	defb 0a1h, 05eh
	defb 000h               ; end
obj_a7db:                         ; pyramid 44
	defb 08bh, 000h
	defb 04bh, 003h
	defb 085h, 04ch
	defb 045h, 04fh
	defb 0ffh               ; next screen
	defb 08bh, 000h
	defb 04bh, 003h
	defb 081h, 05ch
	defb 041h, 05fh
	defb 0ffh               ; next screen
	defb 08bh, 000h
	defb 04bh, 003h
	defb 085h, 04ch
	defb 045h, 04fh
	defb 04ah, 02eh
	defb 0ffh               ; next screen
	defb 08bh, 000h
	defb 04bh, 003h
	defb 085h, 04ch
	defb 045h, 04fh
	defb 0ffh               ; next screen
	defb 08bh, 000h
	defb 04bh, 003h
	defb 085h, 04ch
	defb 045h, 04fh
	defb 0e8h, 02dh
	defb 0ffh               ; next screen
	defb 08bh, 000h
	defb 04bh, 003h
	defb 088h, 040h
	defb 048h, 043h
	defb 000h               ; end
obj_a815:                         ; pyramid 45
	defb 0ffh               ; next screen
	defb 086h, 040h
	defb 004h, 01ah
	defb 0ffh               ; next screen
	defb 044h, 018h
	defb 006h, 042h
	defb 082h, 03ah
	defb 002h, 033h
	defb 087h, 017h
	defb 000h               ; end
obj_a826:                         ; pyramid 46
	defb 082h, 018h
	defb 082h, 028h
	defb 082h, 038h
	defb 0c2h, 020h
	defb 0c2h, 030h
	defb 0c2h, 040h
	defb 002h, 029h
	defb 002h, 039h
	defb 002h, 049h
	defb 042h, 031h
	defb 042h, 041h
	defb 082h, 032h
	defb 082h, 042h
	defb 0c2h, 02ah
	defb 0c2h, 03ah
	defb 0c2h, 04ah
	defb 002h, 023h
	defb 002h, 033h
	defb 002h, 043h
	defb 042h, 01bh
	defb 042h, 02bh
	defb 042h, 03bh
	defb 0c2h, 050h
	defb 0ffh               ; next screen
	defb 04ah, 032h
	defb 0c8h, 012h
	defb 0ffh               ; next screen
	defb 046h, 002h
	defb 004h, 051h
	defb 042h, 05bh
	defb 0ffh               ; next screen
	defb 004h, 001h
	defb 04ah, 003h
	defb 042h, 05ah
	defb 000h               ; end
obj_a868:                         ; pyramid 47
	defb 053h, 014h
	defb 0a3h, 045h
	defb 0e4h, 035h
	defb 022h, 052h
	defb 082h, 05bh
	defb 0ffh               ; next screen
	defb 056h, 000h
	defb 064h, 04ah
	defb 096h, 003h
	defb 0ffh               ; next screen
	defb 000h               ; end
obj_a87b:                         ; pyramid 48
	defb 044h, 014h
	defb 044h, 034h
	defb 084h, 024h
	defb 083h, 044h
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 044h, 027h
	defb 045h, 047h
	defb 084h, 037h
	defb 000h               ; end
obj_a88c:                         ; pyramid 49
	defb 0e2h, 014h
	defb 0e2h, 016h
	defb 0a2h, 01ch
	defb 022h, 01fh
	defb 067h, 024h
	defb 067h, 027h
	defb 0a4h, 034h
	defb 024h, 037h
	defb 0e6h, 03ch
	defb 0e2h, 03dh
	defb 0e6h, 03eh
	defb 0a2h, 045h
	defb 022h, 046h
	defb 022h, 04dh
	defb 0e2h, 04dh
	defb 0a2h, 04eh
	defb 0a2h, 055h
	defb 022h, 056h
	defb 000h               ; end
obj_a8b1:                         ; pyramid 50
	defb 0e6h, 02ch
	defb 024h, 023h
	defb 0ffh               ; next screen
	defb 002h, 01ah
	defb 0b0h, 023h
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 010h, 01ah
	defb 0a6h, 003h
	defb 000h               ; end
obj2_a8c1:                        ; secret pyramid 41
	defb 088h, 022h
	defb 000h               ; end
obj2_a8c4:                        ; secret pyramid 42
	defb 086h, 037h
	defb 000h               ; end
obj2_a8c7:                        ; secret pyramid 45
	defb 064h, 028h
	defb 064h, 029h
	defb 064h, 02ah
	defb 064h, 02bh
	defb 0a4h, 038h
	defb 024h, 039h
	defb 0a4h, 039h
	defb 024h, 03ah
	defb 0a4h, 03ah
	defb 024h, 03bh
	defb 0e4h, 048h
	defb 0e4h, 049h
	defb 0e4h, 04ah
	defb 0ffh               ; next screen
	defb 002h, 039h
	defb 082h, 031h
	defb 0c6h, 019h
	defb 000h               ; end
obj2_a8e9:                        ; secret pyramid 46
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 008h, 022h
	defb 000h               ; end
obj2_a8ef:                        ; secret pyramid 48
	defb 0ffh               ; next screen
	defb 00ah, 025h
	defb 0ffh               ; next screen
	defb 084h, 017h
	defb 000h               ; end
obj2_a8f6:                        ; secret pyramid 43,44,47,49,50
	defb 000h               ; end
obj_a8f7:                         ; pyramid 51
	defb 0e5h, 045h
	defb 000h               ; end
obj_a8fa:                         ; pyramid 52
	defb 0c5h, 048h
	defb 000h               ; end
obj_a8fd:                         ; pyramid 53
	defb 0ffh               ; next screen
	defb 052h, 014h
	defb 042h, 022h
	defb 082h, 01ah
	defb 0c2h, 022h
	defb 002h, 01bh
	defb 042h, 023h
	defb 085h, 017h
	defb 0ffh               ; next screen
	defb 000h               ; end
obj_a90e:                         ; pyramid 54
	defb 0e4h, 052h
	defb 0ffh               ; next screen
	defb 0e4h, 002h
	defb 0e5h, 015h
	defb 000h               ; end
obj_a916:                         ; pyramid 55
	defb 0a5h, 000h
	defb 048h, 017h
	defb 006h, 02dh
	defb 002h, 037h
	defb 0ffh               ; next screen
	defb 0a1h, 05ch
	defb 000h               ; end
obj_a922:                         ; pyramid 57
	defb 02fh, 010h
	defb 0a4h, 013h
	defb 0ffh               ; next screen
	defb 024h, 010h
	defb 000h               ; end
obj_a92a:                         ; pyramid 58
	defb 0ach, 024h
	defb 0ffh               ; next screen
	defb 02eh, 017h
	defb 0e4h, 04eh
	defb 000h               ; end
obj_a932:                         ; pyramid 56
	defb 000h               ; end
obj_a933:                         ; pyramid 59
	defb 034h, 010h
	defb 0c9h, 018h
	defb 046h, 035h
	defb 045h, 042h
	defb 0c7h, 02ah
	defb 049h, 013h
	defb 0b4h, 013h
	defb 0ffh               ; next screen
	defb 034h, 010h
	defb 0c5h, 014h
	defb 042h, 019h
	defb 0c3h, 01ah
	defb 047h, 013h
	defb 0b4h, 013h
	defb 085h, 04ch
	defb 083h, 042h
	defb 003h, 04bh
	defb 041h, 05eh
	defb 0ffh               ; next screen
	defb 037h, 000h
	defb 0b7h, 003h
	defb 0c2h, 044h
	defb 004h, 03dh
	defb 046h, 035h
	defb 048h, 026h
	defb 088h, 01eh
	defb 0ffh               ; next screen
	defb 037h, 000h
	defb 0b7h, 003h
	defb 093h, 000h
	defb 005h, 00dh
	defb 043h, 00dh
	defb 081h, 00dh
	defb 043h, 002h
	defb 084h, 026h
	defb 0c4h, 01eh
	defb 0c4h, 036h
	defb 006h, 02fh
	defb 000h               ; end
obj2_a97d:                        ; secret pyramid 59
	defb 089h, 010h
	defb 007h, 029h
	defb 085h, 041h
	defb 086h, 036h
	defb 008h, 01fh
	defb 0ffh               ; next screen
	defb 087h, 010h
	defb 003h, 019h
	defb 082h, 01ah
	defb 005h, 017h
	defb 0c3h, 048h
	defb 043h, 041h
	defb 0c3h, 046h
	defb 044h, 04fh
	defb 003h, 045h
	defb 0ffh               ; next screen
	defb 088h, 02dh
	defb 007h, 00fh
	defb 000h               ; end
obj_a9a0:                         ; pyramid 60
	defb 035h, 00ch
	defb 0c5h, 028h
	defb 082h, 058h
	defb 0c2h, 059h
	defb 0ffh               ; next screen
	defb 0cah, 03ah
	defb 082h, 05bh
	defb 0ffh               ; next screen
	defb 091h, 00ch
	defb 046h, 022h
	defb 044h, 042h
	defb 0b5h, 00fh
	defb 042h, 058h
	defb 082h, 059h
	defb 002h, 05bh
	defb 0ffh               ; next screen
	defb 023h, 000h
	defb 096h, 000h
	defb 0c5h, 001h
	defb 0c4h, 01dh
	defb 0ffh               ; next screen
	defb 0c4h, 002h
	defb 096h, 003h
	defb 0ffh               ; next screen
	defb 056h, 000h
	defb 08ch, 001h
	defb 006h, 003h
	defb 0b6h, 003h
	defb 000h               ; end
obj2_a9d4:                        ; secret pyramid 51
	defb 066h, 029h
	defb 066h, 02ah
	defb 000h               ; end
obj2_a9d9:                        ; secret pyramid 52
	defb 04ah, 020h
	defb 08ch, 021h
	defb 048h, 023h
	defb 0ffh               ; next screen
	defb 044h, 011h
	defb 008h, 022h
	defb 047h, 041h
	defb 005h, 04bh
	defb 000h               ; end
obj2_a9e9:                        ; secret pyramid 53
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 005h, 025h
	defb 000h               ; end
obj2_a9ee:                        ; secret pyramid 54
	defb 065h, 03eh
	defb 000h               ; end
obj2_a9f1:                        ; secret pyramid 55
	defb 024h, 034h
	defb 0ffh               ; next screen
	defb 0aeh, 027h
	defb 000h               ; end
obj2_a9f7:                        ; secret pyramid 56
	defb 08ch, 010h
	defb 04ah, 013h
	defb 0e3h, 029h
	defb 006h, 029h
	defb 0e5h, 039h
	defb 046h, 040h
	defb 086h, 043h
	defb 000h               ; end
obj2_aa06:                        ; secret pyramid 57
	defb 0c4h, 010h
	defb 0e8h, 01dh
	defb 0ffh               ; next screen
	defb 0e4h, 01dh
	defb 0e8h, 03dh
	defb 0abh, 023h
	defb 004h, 013h
	defb 000h               ; end
obj2_aa14:                        ; secret pyramid 58
	defb 0a4h, 02eh
	defb 028h, 02fh
	defb 0ffh               ; next screen
	defb 02ah, 02eh
	defb 0b0h, 015h
	defb 000h               ; end
obj2_aa1e:                        ; secret pyramid 60
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0ffh               ; next screen
	defb 0c3h, 00ch
	defb 003h, 019h
	defb 043h, 025h
	defb 000h               ; end
