; delayed E500 pickups (bank 0D; 0xB7CD -> 0xE2C0). 4 bytes type, screen, X, Y; 0 end.
; spawn_tool after timer; C>=5 rejected so stock ids are 1-4.

pickups_b5c3:          ; pyramid 1
	defb 001h, 001h, 020h, 020h ; knife
	defb 000h               ; end
pickups_b5c8:          ; pyramid 2
	defb 001h, 001h, 090h, 068h ; knife
	defb 000h               ; end
pickups_b5cd:          ; pyramid 3
	defb 002h, 001h, 0a0h, 078h ; boomerang
	defb 000h               ; end
pickups_b5d2:          ; pyramid 4
	defb 001h, 002h, 028h, 0a0h ; knife
	defb 000h               ; end
pickups_b5d7:          ; pyramid 5
	defb 003h, 002h, 0a8h, 050h ; shovel
	defb 000h               ; end
pickups_b5dc:          ; pyramid 6
	defb 001h, 002h, 070h, 078h ; knife
	defb 004h, 001h, 010h, 020h ; pick
	defb 000h               ; end
pickups_b5e5:          ; pyramid 7
	defb 003h, 002h, 0a8h, 0d8h ; shovel
	defb 000h               ; end
pickups_b5ea:          ; pyramid 8
	defb 002h, 002h, 010h, 040h ; boomerang
	defb 004h, 003h, 050h, 098h ; pick
	defb 000h               ; end
pickups_b5f3:          ; pyramid 9
	defb 004h, 001h, 018h, 090h ; pick
	defb 001h, 001h, 018h, 010h ; knife
	defb 000h               ; end
pickups_b5fc:          ; pyramid 10
	defb 003h, 001h, 018h, 030h ; shovel
	defb 004h, 001h, 058h, 068h ; pick
	defb 004h, 002h, 038h, 0c8h ; pick
	defb 000h               ; end
pickups_b609:          ; pyramid 11
	defb 003h, 001h, 010h, 040h ; shovel
	defb 000h               ; end
pickups_b60e:          ; pyramid 12
	defb 001h, 001h, 070h, 040h ; knife
	defb 001h, 001h, 030h, 0d0h ; knife
	defb 001h, 002h, 070h, 048h ; knife
	defb 001h, 002h, 030h, 0a0h ; knife
	defb 000h               ; end
pickups_b61f:          ; pyramid 13
	defb 004h, 001h, 020h, 010h ; pick
	defb 004h, 002h, 020h, 080h ; pick
	defb 004h, 003h, 078h, 080h ; pick
	defb 000h               ; end
pickups_b62c:          ; pyramid 14
	defb 004h, 001h, 020h, 020h ; pick
	defb 004h, 001h, 040h, 080h ; pick
	defb 004h, 001h, 020h, 0e0h ; pick
	defb 004h, 002h, 0a8h, 078h ; pick
	defb 004h, 003h, 020h, 040h ; pick
	defb 004h, 003h, 020h, 0c0h ; pick
	defb 000h               ; end
pickups_b645:          ; pyramid 15
	defb 001h, 001h, 018h, 038h ; knife
	defb 001h, 003h, 018h, 0b8h ; knife
	defb 000h               ; end
pickups_b64e:          ; pyramid 16
	defb 004h, 002h, 020h, 008h ; pick
	defb 001h, 002h, 070h, 020h ; knife
	defb 003h, 002h, 070h, 0d0h ; shovel
	defb 000h               ; end
pickups_b65b:          ; pyramid 17
	defb 002h, 002h, 0a8h, 030h ; boomerang
	defb 004h, 003h, 018h, 060h ; pick
	defb 000h               ; end
pickups_b664:          ; pyramid 18
	defb 004h, 001h, 008h, 008h ; pick
	defb 000h               ; end
pickups_b669:          ; pyramid 19
	defb 003h, 001h, 040h, 078h ; shovel
	defb 000h               ; end
pickups_b66e:          ; pyramid 20
	defb 001h, 001h, 020h, 060h ; knife
	defb 004h, 001h, 090h, 008h ; pick
	defb 002h, 002h, 0a8h, 078h ; boomerang
	defb 000h               ; end
pickups_b67b:          ; pyramid 21
	defb 004h, 001h, 010h, 028h ; pick
	defb 004h, 001h, 068h, 098h ; pick
	defb 000h               ; end
pickups_b684:          ; pyramid 22
	defb 004h, 001h, 030h, 0a0h ; pick
	defb 002h, 003h, 010h, 0a0h ; boomerang
	defb 000h               ; end
pickups_b68d:          ; pyramid 23
	defb 002h, 004h, 0a8h, 068h ; boomerang
	defb 000h               ; end
pickups_b692:          ; pyramid 24
	defb 004h, 003h, 010h, 0d0h ; pick
	defb 003h, 004h, 048h, 078h ; shovel
	defb 000h               ; end
pickups_b69b:          ; pyramid 25
	defb 004h, 001h, 008h, 090h ; pick
	defb 003h, 001h, 028h, 028h ; shovel
	defb 000h               ; end
pickups_b6a4:          ; pyramid 26
	defb 000h               ; end
pickups_b6a5:          ; pyramid 27
	defb 004h, 002h, 050h, 0e8h ; pick
	defb 002h, 003h, 0a8h, 078h ; boomerang
	defb 000h               ; end
pickups_b6ae:          ; pyramid 28
	defb 003h, 002h, 020h, 0c0h ; shovel
	defb 004h, 003h, 018h, 068h ; pick
	defb 004h, 003h, 060h, 030h ; pick
	defb 000h               ; end
pickups_b6bb:          ; pyramid 29
	defb 001h, 001h, 038h, 0a0h ; knife
	defb 000h               ; end
pickups_b6c0:          ; pyramid 30
	defb 003h, 002h, 008h, 0b8h ; shovel
	defb 004h, 002h, 008h, 030h ; pick
	defb 000h               ; end
pickups_b6c9:          ; pyramid 31
	defb 003h, 001h, 018h, 018h ; shovel
	defb 004h, 001h, 088h, 030h ; pick
	defb 004h, 001h, 018h, 090h ; pick
	defb 000h               ; end
pickups_b6d6:          ; pyramid 32
	defb 002h, 002h, 010h, 0d0h ; boomerang
	defb 000h               ; end
pickups_b6db:          ; pyramid 33
	defb 004h, 002h, 0a8h, 0d0h ; pick
	defb 003h, 003h, 028h, 020h ; shovel
	defb 000h               ; end
pickups_b6e4:          ; pyramid 34
	defb 001h, 001h, 0a0h, 0e0h ; knife
	defb 004h, 002h, 010h, 040h ; pick
	defb 004h, 002h, 010h, 0b0h ; pick
	defb 001h, 004h, 0a8h, 0c0h ; knife
	defb 000h               ; end
pickups_b6f5:          ; pyramid 35
	defb 001h, 001h, 020h, 048h ; knife
	defb 003h, 004h, 0a8h, 0c0h ; shovel
	defb 000h               ; end
pickups_b6fe:          ; pyramid 36
	defb 004h, 002h, 010h, 0b0h ; pick
	defb 001h, 003h, 040h, 050h ; knife
	defb 000h               ; end
pickups_b707:          ; pyramid 37
	defb 001h, 002h, 0a0h, 078h ; knife
	defb 003h, 004h, 0a0h, 070h ; shovel
	defb 000h               ; end
pickups_b710:          ; pyramid 38
	defb 004h, 002h, 0a0h, 030h ; pick
	defb 004h, 004h, 020h, 010h ; pick
	defb 000h               ; end
pickups_b719:          ; pyramid 39
	defb 003h, 001h, 078h, 078h ; shovel
	defb 000h               ; end
pickups_b71e:          ; pyramid 40
	defb 003h, 001h, 0a8h, 070h ; shovel
	defb 000h               ; end
pickups_b723:          ; pyramid 41
	defb 000h               ; end
pickups_b724:          ; pyramid 42
	defb 003h, 002h, 028h, 0b0h ; shovel
	defb 000h               ; end
pickups_b729:          ; pyramid 43
	defb 004h, 001h, 018h, 078h ; pick
	defb 004h, 002h, 050h, 0c8h ; pick
	defb 000h               ; end
pickups_b732:          ; pyramid 44
	defb 000h               ; end
pickups_b733:          ; pyramid 45
	defb 001h, 002h, 020h, 020h ; knife
	defb 004h, 003h, 020h, 078h ; pick
	defb 000h               ; end
pickups_b73c:          ; pyramid 46
	defb 004h, 001h, 010h, 078h ; pick
	defb 004h, 004h, 0a0h, 030h ; pick
	defb 000h               ; end
pickups_b745:          ; pyramid 47
	defb 001h, 003h, 050h, 0b8h ; knife
	defb 000h               ; end
pickups_b74a:          ; pyramid 48
	defb 001h, 001h, 0a0h, 070h ; knife
	defb 004h, 003h, 0a0h, 078h ; pick
	defb 004h, 003h, 018h, 040h ; pick
	defb 000h               ; end
pickups_b757:          ; pyramid 49
	defb 001h, 001h, 0a8h, 008h ; knife
	defb 004h, 001h, 018h, 098h ; pick
	defb 000h               ; end
pickups_b760:          ; pyramid 50
	defb 003h, 002h, 0a8h, 0a0h ; shovel
	defb 000h               ; end
pickups_b765:          ; pyramid 51
	defb 001h, 001h, 0a8h, 010h ; knife
	defb 000h               ; end
pickups_b76a:          ; pyramid 52
	defb 002h, 001h, 0a8h, 018h ; boomerang
	defb 003h, 002h, 0a8h, 0d8h ; shovel
	defb 000h               ; end
pickups_b773:          ; pyramid 53
	defb 004h, 002h, 018h, 060h ; pick
	defb 004h, 003h, 018h, 060h ; pick
	defb 000h               ; end
pickups_b77c:          ; pyramid 54
	defb 001h, 001h, 0a8h, 0e8h ; knife
	defb 001h, 002h, 0a8h, 008h ; knife
	defb 000h               ; end
pickups_b785:          ; pyramid 55
	defb 001h, 002h, 0a8h, 048h ; knife
	defb 000h               ; end
pickups_b78a:          ; pyramid 56
	defb 001h, 001h, 088h, 040h ; knife
	defb 003h, 001h, 010h, 010h ; shovel
	defb 003h, 001h, 010h, 0e0h ; shovel
	defb 000h               ; end
pickups_b797:          ; pyramid 57
	defb 004h, 001h, 030h, 0d0h ; pick
	defb 004h, 002h, 030h, 018h ; pick
	defb 001h, 002h, 0a8h, 0e0h ; knife
	defb 000h               ; end
pickups_b7a4:          ; pyramid 58
	defb 003h, 001h, 058h, 008h ; shovel
	defb 003h, 001h, 0a8h, 008h ; shovel
	defb 004h, 002h, 048h, 018h ; pick
	defb 004h, 002h, 018h, 090h ; pick
	defb 000h               ; end
pickups_b7b5:          ; pyramid 59
	defb 004h, 003h, 088h, 0d0h ; pick
	defb 002h, 004h, 0a8h, 0c0h ; boomerang
	defb 000h               ; end
pickups_b7be:          ; pyramid 60
	defb 001h, 003h, 008h, 078h ; knife
	defb 003h, 004h, 0a0h, 050h ; shovel
	defb 002h, 005h, 078h, 020h ; boomerang
	defb 1, 6, 0078h           ; DELAYED 1, 6, 0078h, 0050h ; Y + end overlap b7cd_tbl[0]

b7cd_tbl:                         ; per-pyramid delayed pickups (e242); [0] overlap
	defw 00050h, pickups_b5c3, pickups_b5c8, pickups_b5cd, pickups_b5d2, pickups_b5d7, pickups_b5dc, pickups_b5e5
	defw pickups_b5ea, pickups_b5f3, pickups_b5fc, pickups_b609, pickups_b60e, pickups_b61f, pickups_b62c, pickups_b645
	defw pickups_b64e, pickups_b65b, pickups_b664, pickups_b669, pickups_b66e, pickups_b67b, pickups_b684, pickups_b68d
	defw pickups_b692, pickups_b69b, pickups_b6a4, pickups_b6a5, pickups_b6ae, pickups_b6bb, pickups_b6c0, pickups_b6c9
	defw pickups_b6d6, pickups_b6db, pickups_b6e4, pickups_b6f5, pickups_b6fe, pickups_b707, pickups_b710, pickups_b719
	defw pickups_b71e, pickups_b723, pickups_b724, pickups_b729, pickups_b732, pickups_b733, pickups_b73c, pickups_b745
	defw pickups_b74a, pickups_b757, pickups_b760, pickups_b765, pickups_b76a, pickups_b773, pickups_b77c, pickups_b785
	defw pickups_b78a, pickups_b797, pickups_b7a4, pickups_b7b5, pickups_b7be
