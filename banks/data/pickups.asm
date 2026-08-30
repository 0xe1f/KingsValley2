; delayed E500 pickups (bank 0D; 0xB7CD -> 0xE2C0). 4 bytes type, screen, X, Y; 0 end.
; spawn_tool after timer; C>=5 rejected so stock ids are 1-4.

pickups_b5c3:          ; pyramid 1
	DELAYED 1, 1, 0020h, 0020h  ; knife
	DELAYED_END
pickups_b5c8:          ; pyramid 2
	DELAYED 1, 1, 0090h, 0068h  ; knife
	DELAYED_END
pickups_b5cd:          ; pyramid 3
	DELAYED 2, 1, 00A0h, 0078h  ; boomerang
	DELAYED_END
pickups_b5d2:          ; pyramid 4
	DELAYED 1, 2, 0028h, 00A0h  ; knife
	DELAYED_END
pickups_b5d7:          ; pyramid 5
	DELAYED 3, 2, 00A8h, 0050h  ; shovel
	DELAYED_END
pickups_b5dc:          ; pyramid 6
	DELAYED 1, 2, 0070h, 0078h  ; knife
	DELAYED 4, 1, 0010h, 0020h  ; pick
	DELAYED_END
pickups_b5e5:          ; pyramid 7
	DELAYED 3, 2, 00A8h, 00D8h  ; shovel
	DELAYED_END
pickups_b5ea:          ; pyramid 8
	DELAYED 2, 2, 0010h, 0040h  ; boomerang
	DELAYED 4, 3, 0050h, 0098h  ; pick
	DELAYED_END
pickups_b5f3:          ; pyramid 9
	DELAYED 4, 1, 0018h, 0090h  ; pick
	DELAYED 1, 1, 0018h, 0010h  ; knife
	DELAYED_END
pickups_b5fc:          ; pyramid 10
	DELAYED 3, 1, 0018h, 0030h  ; shovel
	DELAYED 4, 1, 0058h, 0068h  ; pick
	DELAYED 4, 2, 0038h, 00C8h  ; pick
	DELAYED_END
pickups_b609:          ; pyramid 11
	DELAYED 3, 1, 0010h, 0040h  ; shovel
	DELAYED_END
pickups_b60e:          ; pyramid 12
	DELAYED 1, 1, 0070h, 0040h  ; knife
	DELAYED 1, 1, 0030h, 00D0h  ; knife
	DELAYED 1, 2, 0070h, 0048h  ; knife
	DELAYED 1, 2, 0030h, 00A0h  ; knife
	DELAYED_END
pickups_b61f:          ; pyramid 13
	DELAYED 4, 1, 0020h, 0010h  ; pick
	DELAYED 4, 2, 0020h, 0080h  ; pick
	DELAYED 4, 3, 0078h, 0080h  ; pick
	DELAYED_END
pickups_b62c:          ; pyramid 14
	DELAYED 4, 1, 0020h, 0020h  ; pick
	DELAYED 4, 1, 0040h, 0080h  ; pick
	DELAYED 4, 1, 0020h, 00E0h  ; pick
	DELAYED 4, 2, 00A8h, 0078h  ; pick
	DELAYED 4, 3, 0020h, 0040h  ; pick
	DELAYED 4, 3, 0020h, 00C0h  ; pick
	DELAYED_END
pickups_b645:          ; pyramid 15
	DELAYED 1, 1, 0018h, 0038h  ; knife
	DELAYED 1, 3, 0018h, 00B8h  ; knife
	DELAYED_END
pickups_b64e:          ; pyramid 16
	DELAYED 4, 2, 0020h, 0008h  ; pick
	DELAYED 1, 2, 0070h, 0020h  ; knife
	DELAYED 3, 2, 0070h, 00D0h  ; shovel
	DELAYED_END
pickups_b65b:          ; pyramid 17
	DELAYED 2, 2, 00A8h, 0030h  ; boomerang
	DELAYED 4, 3, 0018h, 0060h  ; pick
	DELAYED_END
pickups_b664:          ; pyramid 18
	DELAYED 4, 1, 0008h, 0008h  ; pick
	DELAYED_END
pickups_b669:          ; pyramid 19
	DELAYED 3, 1, 0040h, 0078h  ; shovel
	DELAYED_END
pickups_b66e:          ; pyramid 20
	DELAYED 1, 1, 0020h, 0060h  ; knife
	DELAYED 4, 1, 0090h, 0008h  ; pick
	DELAYED 2, 2, 00A8h, 0078h  ; boomerang
	DELAYED_END
pickups_b67b:          ; pyramid 21
	DELAYED 4, 1, 0010h, 0028h  ; pick
	DELAYED 4, 1, 0068h, 0098h  ; pick
	DELAYED_END
pickups_b684:          ; pyramid 22
	DELAYED 4, 1, 0030h, 00A0h  ; pick
	DELAYED 2, 3, 0010h, 00A0h  ; boomerang
	DELAYED_END
pickups_b68d:          ; pyramid 23
	DELAYED 2, 4, 00A8h, 0068h  ; boomerang
	DELAYED_END
pickups_b692:          ; pyramid 24
	DELAYED 4, 3, 0010h, 00D0h  ; pick
	DELAYED 3, 4, 0048h, 0078h  ; shovel
	DELAYED_END
pickups_b69b:          ; pyramid 25
	DELAYED 4, 1, 0008h, 0090h  ; pick
	DELAYED 3, 1, 0028h, 0028h  ; shovel
	DELAYED_END
pickups_b6a4:          ; pyramid 26
	DELAYED_END
pickups_b6a5:          ; pyramid 27
	DELAYED 4, 2, 0050h, 00E8h  ; pick
	DELAYED 2, 3, 00A8h, 0078h  ; boomerang
	DELAYED_END
pickups_b6ae:          ; pyramid 28
	DELAYED 3, 2, 0020h, 00C0h  ; shovel
	DELAYED 4, 3, 0018h, 0068h  ; pick
	DELAYED 4, 3, 0060h, 0030h  ; pick
	DELAYED_END
pickups_b6bb:          ; pyramid 29
	DELAYED 1, 1, 0038h, 00A0h  ; knife
	DELAYED_END
pickups_b6c0:          ; pyramid 30
	DELAYED 3, 2, 0008h, 00B8h  ; shovel
	DELAYED 4, 2, 0008h, 0030h  ; pick
	DELAYED_END
pickups_b6c9:          ; pyramid 31
	DELAYED 3, 1, 0018h, 0018h  ; shovel
	DELAYED 4, 1, 0088h, 0030h  ; pick
	DELAYED 4, 1, 0018h, 0090h  ; pick
	DELAYED_END
pickups_b6d6:          ; pyramid 32
	DELAYED 2, 2, 0010h, 00D0h  ; boomerang
	DELAYED_END
pickups_b6db:          ; pyramid 33
	DELAYED 4, 2, 00A8h, 00D0h  ; pick
	DELAYED 3, 3, 0028h, 0020h  ; shovel
	DELAYED_END
pickups_b6e4:          ; pyramid 34
	DELAYED 1, 1, 00A0h, 00E0h  ; knife
	DELAYED 4, 2, 0010h, 0040h  ; pick
	DELAYED 4, 2, 0010h, 00B0h  ; pick
	DELAYED 1, 4, 00A8h, 00C0h  ; knife
	DELAYED_END
pickups_b6f5:          ; pyramid 35
	DELAYED 1, 1, 0020h, 0048h  ; knife
	DELAYED 3, 4, 00A8h, 00C0h  ; shovel
	DELAYED_END
pickups_b6fe:          ; pyramid 36
	DELAYED 4, 2, 0010h, 00B0h  ; pick
	DELAYED 1, 3, 0040h, 0050h  ; knife
	DELAYED_END
pickups_b707:          ; pyramid 37
	DELAYED 1, 2, 00A0h, 0078h  ; knife
	DELAYED 3, 4, 00A0h, 0070h  ; shovel
	DELAYED_END
pickups_b710:          ; pyramid 38
	DELAYED 4, 2, 00A0h, 0030h  ; pick
	DELAYED 4, 4, 0020h, 0010h  ; pick
	DELAYED_END
pickups_b719:          ; pyramid 39
	DELAYED 3, 1, 0078h, 0078h  ; shovel
	DELAYED_END
pickups_b71e:          ; pyramid 40
	DELAYED 3, 1, 00A8h, 0070h  ; shovel
	DELAYED_END
pickups_b723:          ; pyramid 41
	DELAYED_END
pickups_b724:          ; pyramid 42
	DELAYED 3, 2, 0028h, 00B0h  ; shovel
	DELAYED_END
pickups_b729:          ; pyramid 43
	DELAYED 4, 1, 0018h, 0078h  ; pick
	DELAYED 4, 2, 0050h, 00C8h  ; pick
	DELAYED_END
pickups_b732:          ; pyramid 44
	DELAYED_END
pickups_b733:          ; pyramid 45
	DELAYED 1, 2, 0020h, 0020h  ; knife
	DELAYED 4, 3, 0020h, 0078h  ; pick
	DELAYED_END
pickups_b73c:          ; pyramid 46
	DELAYED 4, 1, 0010h, 0078h  ; pick
	DELAYED 4, 4, 00A0h, 0030h  ; pick
	DELAYED_END
pickups_b745:          ; pyramid 47
	DELAYED 1, 3, 0050h, 00B8h  ; knife
	DELAYED_END
pickups_b74a:          ; pyramid 48
	DELAYED 1, 1, 00A0h, 0070h  ; knife
	DELAYED 4, 3, 00A0h, 0078h  ; pick
	DELAYED 4, 3, 0018h, 0040h  ; pick
	DELAYED_END
pickups_b757:          ; pyramid 49
	DELAYED 1, 1, 00A8h, 0008h  ; knife
	DELAYED 4, 1, 0018h, 0098h  ; pick
	DELAYED_END
pickups_b760:          ; pyramid 50
	DELAYED 3, 2, 00A8h, 00A0h  ; shovel
	DELAYED_END
pickups_b765:          ; pyramid 51
	DELAYED 1, 1, 00A8h, 0010h  ; knife
	DELAYED_END
pickups_b76a:          ; pyramid 52
	DELAYED 2, 1, 00A8h, 0018h  ; boomerang
	DELAYED 3, 2, 00A8h, 00D8h  ; shovel
	DELAYED_END
pickups_b773:          ; pyramid 53
	DELAYED 4, 2, 0018h, 0060h  ; pick
	DELAYED 4, 3, 0018h, 0060h  ; pick
	DELAYED_END
pickups_b77c:          ; pyramid 54
	DELAYED 1, 1, 00A8h, 00E8h  ; knife
	DELAYED 1, 2, 00A8h, 0008h  ; knife
	DELAYED_END
pickups_b785:          ; pyramid 55
	DELAYED 1, 2, 00A8h, 0048h  ; knife
	DELAYED_END
pickups_b78a:          ; pyramid 56
	DELAYED 1, 1, 0088h, 0040h  ; knife
	DELAYED 3, 1, 0010h, 0010h  ; shovel
	DELAYED 3, 1, 0010h, 00E0h  ; shovel
	DELAYED_END
pickups_b797:          ; pyramid 57
	DELAYED 4, 1, 0030h, 00D0h  ; pick
	DELAYED 4, 2, 0030h, 0018h  ; pick
	DELAYED 1, 2, 00A8h, 00E0h  ; knife
	DELAYED_END
pickups_b7a4:          ; pyramid 58
	DELAYED 3, 1, 0058h, 0008h  ; shovel
	DELAYED 3, 1, 00A8h, 0008h  ; shovel
	DELAYED 4, 2, 0048h, 0018h  ; pick
	DELAYED 4, 2, 0018h, 0090h  ; pick
	DELAYED_END
pickups_b7b5:          ; pyramid 59
	DELAYED 4, 3, 0088h, 00D0h  ; pick
	DELAYED 2, 4, 00A8h, 00C0h  ; boomerang
	DELAYED_END
pickups_b7be:          ; pyramid 60
	DELAYED 1, 3, 0008h, 0078h  ; knife
	DELAYED 3, 4, 00A0h, 0050h  ; shovel
	DELAYED 2, 5, 0078h, 0020h  ; boomerang
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
