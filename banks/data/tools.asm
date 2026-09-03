; packed map tools -> 0xE300 (bank 0D). afb1_tbl is 60 words (level-1); [60] was first record.

tools_b029:           ; pyramid 1
	defb 011h, 0a0h, 0a0h   ; knife
	defb 016h, 050h, 0b8h   ; drill
	defb 014h, 050h, 038h   ; pick
	defb 0ffh               ; end
tools_b033:           ; pyramid 2
	defb 011h, 008h, 0d0h   ; knife
	defb 011h, 090h, 0e8h   ; knife
	defb 016h, 088h, 0d0h   ; drill
	defb 0ffh               ; end
tools_b03d:           ; pyramid 3
	defb 011h, 020h, 020h   ; knife
	defb 022h, 0a0h, 0e0h   ; boomerang
	defb 016h, 048h, 030h   ; drill
	defb 016h, 048h, 0c0h   ; drill
	defb 016h, 078h, 0c0h   ; drill
	defb 014h, 060h, 050h   ; pick
	defb 014h, 060h, 0a0h   ; pick
	defb 014h, 078h, 030h   ; pick
	defb 0ffh               ; end
tools_b056:           ; pyramid 4
	defb 011h, 028h, 078h   ; knife
	defb 026h, 0a0h, 0a0h   ; drill
	defb 025h, 028h, 010h   ; hammer
	defb 0ffh               ; end
tools_b060:           ; pyramid 5
	defb 011h, 030h, 038h   ; knife
	defb 021h, 040h, 0c8h   ; knife
	defb 012h, 0a0h, 0b8h   ; boomerang
	defb 025h, 058h, 088h   ; hammer
	defb 013h, 080h, 038h   ; shovel
	defb 023h, 078h, 050h   ; shovel
	defb 0ffh               ; end
tools_b073:           ; pyramid 6
	defb 011h, 040h, 020h   ; knife
	defb 022h, 070h, 0d0h   ; boomerang
	defb 016h, 0a0h, 040h   ; drill
	defb 026h, 040h, 0c0h   ; drill
	defb 0ffh               ; end
tools_b080:           ; pyramid 7
	defb 011h, 080h, 090h   ; knife
	defb 021h, 030h, 090h   ; knife
	defb 021h, 0a8h, 018h   ; knife
	defb 012h, 030h, 0c8h   ; boomerang
	defb 016h, 020h, 028h   ; drill
	defb 026h, 030h, 038h   ; drill
	defb 014h, 0a8h, 038h   ; pick
	defb 026h, 058h, 038h   ; drill
	defb 0ffh               ; end
tools_b099:           ; pyramid 8
	defb 021h, 010h, 098h   ; knife
	defb 021h, 060h, 098h   ; knife
	defb 021h, 0a8h, 050h   ; knife
	defb 031h, 050h, 048h   ; knife
	defb 012h, 060h, 0c8h   ; boomerang
	defb 026h, 038h, 0e0h   ; drill
	defb 026h, 088h, 0e0h   ; drill
	defb 024h, 010h, 0c8h   ; pick
	defb 024h, 060h, 0c8h   ; pick
	defb 0ffh               ; end
tools_b0b5:           ; pyramid 9
	defb 011h, 018h, 030h   ; knife
	defb 011h, 018h, 0e0h   ; knife
	defb 011h, 068h, 050h   ; knife
	defb 011h, 0a8h, 0c0h   ; knife
	defb 0ffh               ; end
tools_b0c2:           ; pyramid 10
	defb 011h, 038h, 008h   ; knife
	defb 011h, 058h, 008h   ; knife
	defb 011h, 078h, 048h   ; knife
	defb 011h, 098h, 088h   ; knife
	defb 022h, 018h, 038h   ; boomerang
	defb 021h, 038h, 0e8h   ; knife
	defb 021h, 058h, 0e8h   ; knife
	defb 021h, 078h, 0a8h   ; knife
	defb 021h, 098h, 068h   ; knife
	defb 0ffh               ; end
tools_b0de:           ; pyramid 11
	defb 012h, 030h, 018h   ; boomerang
	defb 011h, 030h, 0d8h   ; knife
	defb 0ffh               ; end
tools_b0e5:           ; pyramid 12
	defb 011h, 060h, 088h   ; knife
	defb 021h, 060h, 0a0h   ; knife
	defb 0ffh               ; end
tools_b0ec:           ; pyramid 13
	defb 011h, 090h, 098h   ; knife
	defb 026h, 070h, 058h   ; drill
	defb 021h, 0a0h, 0b0h   ; knife
	defb 031h, 090h, 0c0h   ; knife
	defb 025h, 0a0h, 0c0h   ; hammer
	defb 0ffh               ; end
tools_b0fc:           ; pyramid 14
	defb 026h, 040h, 010h   ; drill
	defb 026h, 040h, 0e0h   ; drill
	defb 026h, 060h, 010h   ; drill
	defb 026h, 060h, 0e0h   ; drill
	defb 021h, 0a8h, 010h   ; knife
	defb 021h, 0a8h, 0e0h   ; knife
	defb 0ffh               ; end
tools_b10f:           ; pyramid 15
	defb 013h, 060h, 088h   ; shovel
	defb 016h, 060h, 008h   ; drill
	defb 011h, 0a8h, 058h   ; knife
	defb 021h, 018h, 020h   ; knife
	defb 021h, 018h, 0d0h   ; knife
	defb 026h, 060h, 008h   ; drill
	defb 026h, 060h, 048h   ; drill
	defb 026h, 060h, 0c8h   ; drill
	defb 026h, 078h, 088h   ; drill
	defb 023h, 090h, 048h   ; shovel
	defb 021h, 0a8h, 030h   ; knife
	defb 033h, 060h, 068h   ; shovel
	defb 036h, 078h, 028h   ; drill
	defb 036h, 0a8h, 088h   ; drill
	defb 031h, 0a8h, 0b8h   ; knife
	defb 0ffh               ; end
tools_b13d:           ; pyramid 16
	defb 016h, 038h, 070h   ; drill
	defb 016h, 058h, 090h   ; drill
	defb 016h, 078h, 0b0h   ; drill
	defb 021h, 090h, 050h   ; knife
	defb 022h, 080h, 0b0h   ; boomerang
	defb 0ffh               ; end
tools_b14d:           ; pyramid 17
	defb 014h, 038h, 058h   ; pick
	defb 015h, 0a8h, 008h   ; hammer
	defb 021h, 018h, 0d8h   ; knife
	defb 021h, 0a8h, 0d0h   ; knife
	defb 032h, 018h, 0b0h   ; boomerang
	defb 035h, 038h, 0c0h   ; hammer
	defb 036h, 050h, 080h   ; drill
	defb 031h, 080h, 058h   ; knife
	defb 0ffh               ; end
tools_b166:           ; pyramid 18
	defb 016h, 048h, 028h   ; drill
	defb 016h, 058h, 038h   ; drill
	defb 034h, 040h, 090h   ; pick
	defb 036h, 050h, 080h   ; drill
	defb 033h, 070h, 048h   ; shovel
	defb 011h, 008h, 080h   ; knife
	defb 021h, 008h, 0d8h   ; knife
	defb 021h, 0a8h, 080h   ; knife
	defb 0ffh               ; end
tools_b17f:           ; pyramid 19
	defb 016h, 020h, 018h   ; drill
	defb 011h, 020h, 060h   ; knife
	defb 014h, 040h, 0b0h   ; pick
	defb 012h, 040h, 0d0h   ; boomerang
	defb 015h, 068h, 010h   ; hammer
	defb 011h, 088h, 018h   ; knife
	defb 011h, 088h, 0d8h   ; knife
	defb 0ffh               ; end
tools_b195:           ; pyramid 20
	defb 014h, 010h, 008h   ; pick
	defb 011h, 020h, 090h   ; knife
	defb 016h, 030h, 008h   ; drill
	defb 013h, 070h, 008h   ; shovel
	defb 011h, 090h, 040h   ; knife
	defb 021h, 010h, 0c8h   ; knife
	defb 025h, 030h, 030h   ; hammer
	defb 021h, 0a8h, 0b0h   ; knife
	defb 026h, 018h, 080h   ; drill
	defb 0ffh               ; end
tools_b1b1:           ; pyramid 21
	defb 015h, 008h, 058h   ; hammer
	defb 015h, 030h, 0d8h   ; hammer
	defb 015h, 050h, 0c0h   ; hammer
	defb 011h, 088h, 098h   ; knife
	defb 015h, 0a0h, 058h   ; hammer
	defb 0ffh               ; end
tools_b1c1:           ; pyramid 22
	defb 011h, 030h, 070h   ; knife
	defb 016h, 060h, 090h   ; drill
	defb 011h, 0a8h, 010h   ; knife
	defb 021h, 010h, 0c8h   ; knife
	defb 021h, 038h, 0a8h   ; knife
	defb 026h, 0a8h, 068h   ; drill
	defb 021h, 098h, 010h   ; knife
	defb 036h, 058h, 050h   ; drill
	defb 0ffh               ; end
tools_b1da:           ; pyramid 23
	defb 016h, 0a0h, 0b0h   ; drill
	defb 036h, 040h, 050h   ; drill
	defb 036h, 040h, 0e0h   ; drill
	defb 036h, 070h, 090h   ; drill
	defb 031h, 0a8h, 0c0h   ; knife
	defb 046h, 030h, 0b0h   ; drill
	defb 046h, 040h, 0b0h   ; drill
	defb 046h, 050h, 0b0h   ; drill
	defb 044h, 070h, 0b0h   ; pick
	defb 0ffh               ; end
tools_b1f6:           ; pyramid 24
	defb 011h, 030h, 078h   ; knife
	defb 011h, 050h, 010h   ; knife
	defb 021h, 030h, 078h   ; knife
	defb 035h, 020h, 060h   ; hammer
	defb 033h, 020h, 090h   ; shovel
	defb 031h, 0a0h, 040h   ; knife
	defb 045h, 028h, 008h   ; hammer
	defb 045h, 048h, 008h   ; hammer
	defb 041h, 088h, 078h   ; knife
	defb 0ffh               ; end
tools_b212:           ; pyramid 25
	defb 011h, 068h, 0c8h   ; knife
	defb 015h, 078h, 0b8h   ; hammer
	defb 015h, 088h, 0e8h   ; hammer
	defb 012h, 0a8h, 0e8h   ; boomerang
	defb 0ffh               ; end
tools_b21f:           ; pyramid 26
	defb 016h, 018h, 048h   ; drill
	defb 013h, 068h, 0b0h   ; shovel
	defb 013h, 080h, 040h   ; shovel
	defb 026h, 070h, 0e0h   ; drill
	defb 026h, 090h, 0c0h   ; drill
	defb 034h, 038h, 0c0h   ; pick
	defb 036h, 048h, 080h   ; drill
	defb 036h, 050h, 010h   ; drill
	defb 034h, 068h, 060h   ; pick
	defb 0ffh               ; end
tools_b23b:           ; pyramid 27
	defb 015h, 010h, 0b8h   ; hammer
	defb 015h, 070h, 008h   ; hammer
	defb 012h, 038h, 048h   ; boomerang
	defb 011h, 010h, 0d0h   ; knife
	defb 011h, 0a8h, 0d0h   ; knife
	defb 021h, 068h, 0a8h   ; knife
	defb 025h, 078h, 0e8h   ; hammer
	defb 022h, 088h, 0c0h   ; boomerang
	defb 032h, 010h, 0c8h   ; boomerang
	defb 0ffh               ; end
tools_b257:           ; pyramid 28
	defb 016h, 040h, 090h   ; drill
	defb 012h, 020h, 070h   ; boomerang
	defb 024h, 0a0h, 020h   ; pick
	defb 021h, 060h, 040h   ; knife
	defb 026h, 0a0h, 060h   ; drill
	defb 036h, 050h, 050h   ; drill
	defb 035h, 050h, 0d0h   ; hammer
	defb 036h, 070h, 0a0h   ; drill
	defb 031h, 090h, 080h   ; knife
	defb 0ffh               ; end
tools_b273:           ; pyramid 29
	defb 016h, 038h, 020h   ; drill
	defb 016h, 050h, 010h   ; drill
	defb 0ffh               ; end
tools_b27a:           ; pyramid 30
	defb 011h, 008h, 040h   ; knife
	defb 015h, 028h, 0d8h   ; hammer
	defb 015h, 088h, 020h   ; hammer
	defb 011h, 088h, 060h   ; knife
	defb 025h, 048h, 028h   ; hammer
	defb 021h, 048h, 050h   ; knife
	defb 025h, 048h, 090h   ; hammer
	defb 021h, 068h, 018h   ; knife
	defb 0ffh               ; end
tools_b293:           ; pyramid 31
	defb 016h, 088h, 0a8h   ; drill
	defb 011h, 018h, 060h   ; knife
	defb 011h, 0a8h, 0b8h   ; knife
	defb 0ffh               ; end
tools_b29d:           ; pyramid 32
	defb 013h, 020h, 090h   ; shovel
	defb 012h, 040h, 0e8h   ; boomerang
	defb 014h, 0a8h, 098h   ; pick
	defb 022h, 010h, 0a0h   ; boomerang
	defb 025h, 058h, 0a0h   ; hammer
	defb 026h, 0a8h, 040h   ; drill
	defb 021h, 0a8h, 090h   ; knife
	defb 031h, 020h, 040h   ; knife
	defb 033h, 040h, 050h   ; shovel
	defb 036h, 040h, 060h   ; drill
	defb 034h, 050h, 050h   ; pick
	defb 035h, 060h, 050h   ; hammer
	defb 034h, 060h, 060h   ; pick
	defb 031h, 080h, 008h   ; knife
	defb 0ffh               ; end
tools_b2c8:           ; pyramid 33
	defb 012h, 028h, 020h   ; boomerang
	defb 011h, 088h, 0d0h   ; knife
	defb 016h, 0a8h, 078h   ; drill
	defb 016h, 0a8h, 0c8h   ; drill
	defb 026h, 038h, 010h   ; drill
	defb 026h, 048h, 010h   ; drill
	defb 026h, 058h, 010h   ; drill
	defb 025h, 088h, 050h   ; hammer
	defb 021h, 0a8h, 028h   ; knife
	defb 036h, 078h, 010h   ; drill
	defb 036h, 078h, 0d0h   ; drill
	defb 035h, 088h, 010h   ; hammer
	defb 032h, 088h, 090h   ; boomerang
	defb 036h, 088h, 0d0h   ; drill
	defb 0ffh               ; end
tools_b2f3:           ; pyramid 34
	defb 012h, 010h, 030h   ; boomerang
	defb 015h, 048h, 040h   ; hammer
	defb 011h, 0a0h, 038h   ; knife
	defb 022h, 0a8h, 020h   ; boomerang
	defb 034h, 050h, 050h   ; pick
	defb 034h, 060h, 040h   ; pick
	defb 036h, 050h, 090h   ; drill
	defb 036h, 060h, 0a0h   ; drill
	defb 031h, 0a8h, 030h   ; knife
	defb 043h, 018h, 060h   ; shovel
	defb 043h, 018h, 090h   ; shovel
	defb 043h, 028h, 050h   ; shovel
	defb 043h, 028h, 0a0h   ; shovel
	defb 041h, 0a8h, 040h   ; knife
	defb 026h, 0a8h, 0d8h   ; drill
	defb 0ffh               ; end
tools_b321:           ; pyramid 35
	defb 012h, 020h, 008h   ; boomerang
	defb 021h, 020h, 0d0h   ; knife
	defb 031h, 048h, 0c8h   ; knife
	defb 041h, 0a8h, 028h   ; knife
	defb 0ffh               ; end
tools_b32e:           ; pyramid 36
	defb 016h, 058h, 068h   ; drill
	defb 016h, 078h, 048h   ; drill
	defb 016h, 078h, 0a8h   ; drill
	defb 016h, 098h, 028h   ; drill
	defb 021h, 040h, 0b0h   ; knife
	defb 024h, 090h, 030h   ; pick
	defb 026h, 0a0h, 090h   ; drill
	defb 031h, 010h, 018h   ; knife
	defb 036h, 020h, 0d0h   ; drill
	defb 034h, 030h, 0c0h   ; pick
	defb 032h, 040h, 0a0h   ; boomerang
	defb 036h, 0a8h, 030h   ; drill
	defb 036h, 0a8h, 0b0h   ; drill
	defb 046h, 080h, 080h   ; drill
	defb 046h, 0a0h, 030h   ; drill
	defb 016h, 068h, 008h   ; drill
	defb 026h, 010h, 008h   ; drill
	defb 0ffh               ; end
tools_b362:           ; pyramid 37
	defb 014h, 060h, 0d0h   ; pick
	defb 016h, 070h, 0c0h   ; drill
	defb 016h, 080h, 028h   ; drill
	defb 024h, 060h, 020h   ; pick
	defb 024h, 070h, 030h   ; pick
	defb 024h, 070h, 050h   ; pick
	defb 024h, 080h, 0d0h   ; pick
	defb 022h, 0a0h, 030h   ; boomerang
	defb 036h, 020h, 030h   ; drill
	defb 041h, 0a0h, 020h   ; knife
	defb 034h, 060h, 0d0h   ; pick
	defb 0ffh               ; end
tools_b384:           ; pyramid 38
	defb 012h, 0a0h, 060h   ; boomerang
	defb 026h, 018h, 010h   ; drill
	defb 021h, 0a0h, 080h   ; knife
	defb 032h, 050h, 020h   ; boomerang
	defb 036h, 060h, 090h   ; drill
	defb 046h, 020h, 030h   ; drill
	defb 044h, 020h, 0a0h   ; pick
	defb 046h, 050h, 020h   ; drill
	defb 041h, 060h, 090h   ; knife
	defb 0ffh               ; end
tools_b3a0:           ; pyramid 39
	defb 012h, 098h, 030h   ; boomerang
	defb 011h, 098h, 0c0h   ; knife
	defb 0ffh               ; end
tools_b3a7:           ; pyramid 40
	defb 012h, 0a8h, 020h   ; boomerang
	defb 021h, 0a8h, 098h   ; knife
	defb 032h, 0a0h, 020h   ; boomerang
	defb 046h, 018h, 010h   ; drill
	defb 046h, 018h, 050h   ; drill
	defb 046h, 028h, 070h   ; drill
	defb 046h, 028h, 030h   ; drill
	defb 041h, 0a0h, 088h   ; knife
	defb 0ffh               ; end
tools_b3c0:           ; pyramid 41
	defb 014h, 010h, 060h   ; pick
	defb 016h, 010h, 070h   ; drill
	defb 014h, 010h, 080h   ; pick
	defb 016h, 010h, 090h   ; drill
	defb 0ffh               ; end
tools_b3cd:           ; pyramid 42
	defb 016h, 048h, 090h   ; drill
	defb 016h, 098h, 058h   ; drill
	defb 021h, 018h, 020h   ; knife
	defb 026h, 018h, 080h   ; drill
	defb 026h, 058h, 0b0h   ; drill
	defb 022h, 098h, 070h   ; boomerang
	defb 0ffh               ; end
tools_b3e0:           ; pyramid 43
	defb 011h, 038h, 0c8h   ; knife
	defb 024h, 030h, 038h   ; pick
	defb 024h, 070h, 058h   ; pick
	defb 026h, 050h, 0b8h   ; drill
	defb 026h, 070h, 098h   ; drill
	defb 034h, 070h, 078h   ; pick
	defb 041h, 040h, 078h   ; knife
	defb 0ffh               ; end
tools_b3f6:           ; pyramid 44
	defb 016h, 070h, 010h   ; drill
	defb 016h, 070h, 0e0h   ; drill
	defb 026h, 070h, 010h   ; drill
	defb 024h, 070h, 0e0h   ; pick
	defb 036h, 070h, 010h   ; drill
	defb 036h, 070h, 0e0h   ; drill
	defb 046h, 070h, 010h   ; drill
	defb 046h, 070h, 0e0h   ; drill
	defb 056h, 070h, 010h   ; drill
	defb 054h, 070h, 0e0h   ; pick
	defb 066h, 070h, 010h   ; drill
	defb 066h, 070h, 0e0h   ; drill
	defb 0ffh               ; end
tools_b41b:           ; pyramid 45
	defb 021h, 020h, 040h   ; knife
	defb 021h, 090h, 078h   ; knife
	defb 023h, 070h, 030h   ; shovel
	defb 023h, 0a0h, 010h   ; shovel
	defb 032h, 020h, 020h   ; boomerang
	defb 033h, 050h, 040h   ; shovel
	defb 033h, 060h, 060h   ; shovel
	defb 035h, 060h, 090h   ; hammer
	defb 033h, 050h, 0b0h   ; shovel
	defb 0ffh               ; end
tools_b437:           ; pyramid 46
	defb 014h, 040h, 040h   ; pick
	defb 014h, 050h, 030h   ; pick
	defb 014h, 040h, 0b0h   ; pick
	defb 014h, 050h, 0c0h   ; pick
	defb 026h, 020h, 030h   ; drill
	defb 026h, 020h, 070h   ; drill
	defb 026h, 040h, 020h   ; drill
	defb 026h, 040h, 080h   ; drill
	defb 036h, 010h, 038h   ; drill
	defb 036h, 020h, 018h   ; drill
	defb 036h, 060h, 0b0h   ; drill
	defb 036h, 070h, 0c0h   ; drill
	defb 041h, 0a0h, 0e0h   ; knife
	defb 0ffh               ; end
tools_b45f:           ; pyramid 47
	defb 016h, 048h, 030h   ; drill
	defb 016h, 048h, 0c0h   ; drill
	defb 014h, 088h, 058h   ; pick
	defb 014h, 088h, 098h   ; pick
	defb 026h, 0a0h, 020h   ; drill
	defb 026h, 0a0h, 0d0h   ; drill
	defb 024h, 018h, 0a0h   ; pick
	defb 026h, 0a0h, 088h   ; drill
	defb 036h, 070h, 030h   ; drill
	defb 036h, 080h, 030h   ; drill
	defb 036h, 070h, 040h   ; drill
	defb 036h, 080h, 040h   ; drill
	defb 034h, 070h, 050h   ; pick
	defb 034h, 080h, 050h   ; pick
	defb 036h, 0a0h, 080h   ; drill
	defb 0ffh               ; end
tools_b48d:           ; pyramid 48
	defb 013h, 048h, 0c0h   ; shovel
	defb 011h, 0a0h, 0d0h   ; knife
	defb 025h, 028h, 020h   ; hammer
	defb 025h, 048h, 030h   ; hammer
	defb 035h, 028h, 020h   ; hammer
	defb 035h, 038h, 010h   ; hammer
	defb 035h, 058h, 0e0h   ; hammer
	defb 035h, 070h, 010h   ; hammer
	defb 0ffh               ; end
tools_b4a6:           ; pyramid 49
	defb 014h, 050h, 008h   ; pick
	defb 013h, 050h, 0e8h   ; shovel
	defb 016h, 068h, 008h   ; drill
	defb 015h, 068h, 0e8h   ; hammer
	defb 012h, 0a8h, 018h   ; boomerang
	defb 012h, 0a8h, 0e8h   ; boomerang
	defb 0ffh               ; end
tools_b4b9:           ; pyramid 50
	defb 016h, 048h, 058h   ; drill
	defb 016h, 048h, 070h   ; drill
	defb 026h, 098h, 038h   ; drill
	defb 034h, 020h, 058h   ; pick
	defb 032h, 020h, 0d8h   ; boomerang
	defb 036h, 030h, 0c8h   ; drill
	defb 036h, 060h, 0d8h   ; drill
	defb 036h, 090h, 018h   ; drill
	defb 041h, 020h, 0d0h   ; knife
	defb 0ffh               ; end
tools_b4d5:           ; pyramid 51
	defb 016h, 018h, 028h   ; drill
	defb 016h, 018h, 0c8h   ; drill
	defb 013h, 028h, 038h   ; shovel
	defb 013h, 028h, 0b8h   ; shovel
	defb 013h, 060h, 048h   ; shovel
	defb 013h, 060h, 0a8h   ; shovel
	defb 011h, 0a8h, 048h   ; knife
	defb 0ffh               ; end
tools_b4eb:           ; pyramid 52
	defb 011h, 010h, 070h   ; knife
	defb 021h, 010h, 080h   ; knife
	defb 021h, 0a8h, 0b0h   ; knife
	defb 0ffh               ; end
tools_b4f5:           ; pyramid 53
	defb 011h, 008h, 080h   ; knife
	defb 013h, 030h, 020h   ; shovel
	defb 013h, 048h, 020h   ; shovel
	defb 016h, 048h, 0e0h   ; drill
	defb 013h, 088h, 048h   ; shovel
	defb 012h, 098h, 0b0h   ; boomerang
	defb 022h, 008h, 080h   ; boomerang
	defb 026h, 030h, 090h   ; drill
	defb 026h, 040h, 0a0h   ; drill
	defb 023h, 030h, 0b0h   ; shovel
	defb 026h, 040h, 0c0h   ; drill
	defb 023h, 030h, 0d0h   ; shovel
	defb 021h, 098h, 0b0h   ; knife
	defb 0ffh               ; end
tools_b51d:           ; pyramid 54
	defb 013h, 010h, 038h   ; shovel
	defb 013h, 010h, 080h   ; shovel
	defb 013h, 068h, 0d8h   ; shovel
	defb 016h, 010h, 0b8h   ; drill
	defb 013h, 068h, 088h   ; shovel
	defb 012h, 090h, 028h   ; boomerang
	defb 021h, 010h, 038h   ; knife
	defb 023h, 028h, 0c8h   ; shovel
	defb 023h, 040h, 0c8h   ; shovel
	defb 0ffh               ; end
tools_b539:           ; pyramid 55
	defb 025h, 018h, 028h   ; hammer
	defb 024h, 038h, 0e8h   ; pick
	defb 022h, 0a8h, 0d0h   ; boomerang
	defb 0ffh               ; end
tools_b543:           ; pyramid 56
	defb 011h, 070h, 0b0h   ; knife
	defb 011h, 0a0h, 0c0h   ; knife
	defb 012h, 010h, 060h   ; boomerang
	defb 013h, 070h, 010h   ; shovel
	defb 0ffh               ; end
tools_b550:           ; pyramid 57
	defb 015h, 088h, 018h   ; hammer
	defb 015h, 088h, 068h   ; hammer
	defb 015h, 088h, 088h   ; hammer
	defb 011h, 0a8h, 060h   ; knife
	defb 011h, 0a8h, 090h   ; knife
	defb 0ffh               ; end
tools_b560:           ; pyramid 58
	defb 012h, 098h, 0d8h   ; boomerang
	defb 016h, 018h, 068h   ; drill
	defb 016h, 038h, 028h   ; drill
	defb 016h, 038h, 0d0h   ; drill
	defb 016h, 038h, 0e0h   ; drill
	defb 011h, 0a8h, 058h   ; knife
	defb 026h, 098h, 0c8h   ; drill
	defb 021h, 0a8h, 078h   ; knife
	defb 026h, 098h, 098h   ; drill
	defb 016h, 008h, 048h   ; drill
	defb 0ffh               ; end
tools_b57f:           ; pyramid 59
	defb 016h, 010h, 058h   ; drill
	defb 016h, 010h, 098h   ; drill
	defb 015h, 030h, 058h   ; hammer
	defb 015h, 030h, 098h   ; hammer
	defb 024h, 078h, 0b0h   ; pick
	defb 024h, 080h, 0c0h   ; pick
	defb 032h, 0a8h, 030h   ; boomerang
	defb 041h, 0a8h, 028h   ; knife
	defb 0ffh               ; end
tools_b598:           ; pyramid 60
	defb 011h, 008h, 030h   ; knife
	defb 021h, 008h, 010h   ; knife
	defb 031h, 008h, 010h   ; knife
	defb 034h, 090h, 030h   ; pick
	defb 034h, 090h, 0a8h   ; pick
	defb 044h, 048h, 050h   ; pick
	defb 046h, 078h, 070h   ; drill
	defb 056h, 078h, 070h   ; drill
	defb 054h, 008h, 030h   ; pick
	defb 054h, 038h, 050h   ; pick
	defb 051h, 0a0h, 030h   ; knife
	defb 052h, 078h, 0d0h   ; boomerang
	defb 066h, 078h, 090h   ; drill
	defb 062h, 078h, 0c0h   ; boomerang
	defb 0ffh               ; end
