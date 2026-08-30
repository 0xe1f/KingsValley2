; Vic start (bank 0D; 0xB844 + e242*3) and exit door (0xB8F8 + e242*3).
; Spawn: X, Y, screen. Exit: X, Y, (screen<<5)|shape; shape indexes b9ad_tbl.
; Loader base 0xB844 overlaps last b7cd_tbl pointer bytes; real records from 0xB847.

vic_spawn:                        ; 0xB847  pyramids 1-59; 60 overlaps exit_door[0]
	defb 00A0h, 0080h, 0001h  ; pyramid 1
	defb 0090h, 0088h, 0001h  ; pyramid 2
	defb 0020h, 0078h, 0001h  ; pyramid 3
	defb 0028h, 0098h, 0001h  ; pyramid 4
	defb 00A8h, 00C0h, 0002h  ; pyramid 5
	defb 00A0h, 0078h, 0002h  ; pyramid 6
	defb 00A8h, 0078h, 0002h  ; pyramid 7
	defb 00A8h, 0068h, 0003h  ; pyramid 8
	defb 00A8h, 0078h, 0001h  ; pyramid 9
	defb 0018h, 0008h, 0002h  ; pyramid 10
	defb 0050h, 00B8h, 0001h  ; pyramid 11
	defb 0070h, 00E0h, 0001h  ; pyramid 12
	defb 0050h, 0090h, 0003h  ; pyramid 13
	defb 0020h, 0010h, 0003h  ; pyramid 14
	defb 00A8h, 0078h, 0002h  ; pyramid 15
	defb 0090h, 0078h, 0002h  ; pyramid 16
	defb 00A8h, 0078h, 0002h  ; pyramid 17
	defb 0088h, 00D8h, 0002h  ; pyramid 18
	defb 0058h, 0078h, 0001h  ; pyramid 19
	defb 0090h, 0078h, 0001h  ; pyramid 20
	defb 0050h, 0078h, 0001h  ; pyramid 21
	defb 0010h, 0078h, 0002h  ; pyramid 22
	defb 00A8h, 0090h, 0003h  ; pyramid 23
	defb 00A0h, 0078h, 0003h  ; pyramid 24
	defb 0078h, 0008h, 0001h  ; pyramid 25
	defb 0018h, 0098h, 0002h  ; pyramid 26
	defb 00A8h, 0068h, 0002h  ; pyramid 27
	defb 0090h, 0068h, 0003h  ; pyramid 28
	defb 0018h, 0078h, 0001h  ; pyramid 29
	defb 0008h, 0078h, 0001h  ; pyramid 30
	defb 00A8h, 0078h, 0001h  ; pyramid 31
	defb 0010h, 0078h, 0002h  ; pyramid 32
	defb 0088h, 0078h, 0002h  ; pyramid 33
	defb 00A8h, 0078h, 0002h  ; pyramid 34
	defb 00A8h, 0078h, 0002h  ; pyramid 35
	defb 0040h, 0078h, 0003h  ; pyramid 36
	defb 00A0h, 0078h, 0001h  ; pyramid 37
	defb 00A0h, 00A0h, 0002h  ; pyramid 38
	defb 00A8h, 0078h, 0001h  ; pyramid 39
	defb 00A8h, 0010h, 0002h  ; pyramid 40
	defb 00A0h, 0078h, 0001h  ; pyramid 41
	defb 0018h, 00B8h, 0001h  ; pyramid 42
	defb 00A8h, 00E0h, 0003h  ; pyramid 43
	defb 0028h, 0078h, 0005h  ; pyramid 44
	defb 0020h, 0090h, 0002h  ; pyramid 45
	defb 00A0h, 00D0h, 0002h  ; pyramid 46
	defb 0018h, 0078h, 0001h  ; pyramid 47
	defb 00A0h, 0078h, 0002h  ; pyramid 48
	defb 00A8h, 0078h, 0001h  ; pyramid 49
	defb 0030h, 00B0h, 0002h  ; pyramid 50
	defb 0028h, 0078h, 0001h  ; pyramid 51
	defb 0010h, 00D8h, 0001h  ; pyramid 52
	defb 0018h, 00C0h, 0001h  ; pyramid 53
	defb 0090h, 0078h, 0001h  ; pyramid 54
	defb 0018h, 0080h, 0001h  ; pyramid 55
	defb 0010h, 0078h, 0001h  ; pyramid 56
	defb 0010h, 00A0h, 0001h  ; pyramid 57
	defb 0018h, 0030h, 0002h  ; pyramid 58
	defb 00A8h, 0078h, 0003h  ; pyramid 59
exit_door:                        ; 0xB8F8  [0] = pyramid 60 Vic spawn
	defb 00A0h, 0078h, 0005h  ; [0] / Vic pyramid 60
	defb 0010h, 0070h, 0024h  ; pyramid 1  scr=1 shape=4
	defb 0020h, 0070h, 0024h  ; pyramid 2  scr=1 shape=4
	defb 0040h, 0070h, 0024h  ; pyramid 3  scr=1 shape=4
	defb 0018h, 0070h, 0044h  ; pyramid 4  scr=2 shape=4
	defb 0010h, 0070h, 0044h  ; pyramid 5  scr=2 shape=4
	defb 0010h, 0070h, 0044h  ; pyramid 6  scr=2 shape=4
	defb 0020h, 0070h, 0026h  ; pyramid 7  scr=1 shape=6
	defb 0080h, 0060h, 0066h  ; pyramid 8  scr=3 shape=6
	defb 0028h, 0070h, 0026h  ; pyramid 9  scr=1 shape=6
	defb 0028h, 00D8h, 0046h  ; pyramid 10  scr=2 shape=6
	defb 0010h, 0070h, 0026h  ; pyramid 11  scr=1 shape=6
	defb 0020h, 0060h, 0046h  ; pyramid 12  scr=2 shape=6
	defb 0060h, 0070h, 0026h  ; pyramid 13  scr=1 shape=6
	defb 0050h, 0070h, 0046h  ; pyramid 14  scr=2 shape=6
	defb 0008h, 0070h, 0046h  ; pyramid 15  scr=2 shape=6
	defb 0010h, 0018h, 0048h  ; pyramid 16  scr=2 shape=8
	defb 0048h, 0038h, 0028h  ; pyramid 17  scr=1 shape=8
	defb 0040h, 0070h, 0048h  ; pyramid 18  scr=2 shape=8
	defb 0010h, 0070h, 0028h  ; pyramid 19  scr=1 shape=8
	defb 0050h, 0070h, 0028h  ; pyramid 20  scr=1 shape=8
	defb 0008h, 0070h, 0028h  ; pyramid 21  scr=1 shape=8
	defb 0088h, 0098h, 0048h  ; pyramid 22  scr=2 shape=8
	defb 0070h, 0060h, 008Ah  ; pyramid 23  scr=4 shape=10
	defb 0048h, 0070h, 006Ah  ; pyramid 24  scr=3 shape=10
	defb 0058h, 0068h, 002Ah  ; pyramid 25  scr=1 shape=10
	defb 0050h, 0090h, 004Ah  ; pyramid 26  scr=2 shape=10
	defb 0050h, 0070h, 006Ah  ; pyramid 27  scr=3 shape=10
	defb 0090h, 00B0h, 0068h  ; pyramid 28  scr=3 shape=8
	defb 0048h, 0070h, 002Ah  ; pyramid 29  scr=1 shape=10
	defb 0018h, 0070h, 004Ah  ; pyramid 30  scr=2 shape=10
	defb 0048h, 0088h, 002Ah  ; pyramid 31  scr=1 shape=10
	defb 0098h, 0070h, 002Ah  ; pyramid 32  scr=1 shape=10
	defb 0018h, 00B8h, 004Ah  ; pyramid 33  scr=2 shape=10
	defb 0048h, 0070h, 008Ah  ; pyramid 34  scr=4 shape=10
	defb 0040h, 0070h, 002Ch  ; pyramid 35  scr=1 shape=12
	defb 0010h, 0070h, 002Ch  ; pyramid 36  scr=1 shape=12
	defb 0070h, 0070h, 002Ch  ; pyramid 37  scr=1 shape=12
	defb 0010h, 0080h, 002Ch  ; pyramid 38  scr=1 shape=12
	defb 0008h, 0070h, 002Ch  ; pyramid 39  scr=1 shape=12
	defb 0038h, 00B0h, 006Ch  ; pyramid 40  scr=3 shape=12
	defb 0050h, 0070h, 002Eh  ; pyramid 41  scr=1 shape=14
	defb 0018h, 00D0h, 004Eh  ; pyramid 42  scr=2 shape=14
	defb 0090h, 0070h, 002Ch  ; pyramid 43  scr=1 shape=12
	defb 0050h, 0070h, 004Ch  ; pyramid 44  scr=2 shape=12
	defb 0038h, 0070h, 002Dh  ; pyramid 45  scr=1 shape=13
	defb 0040h, 0070h, 002Ch  ; pyramid 46  scr=1 shape=12
	defb 0048h, 0070h, 002Eh  ; pyramid 47  scr=1 shape=14
	defb 0070h, 0068h, 002Eh  ; pyramid 48  scr=1 shape=14
	defb 0008h, 0070h, 002Eh  ; pyramid 49  scr=1 shape=14
	defb 0098h, 0058h, 002Eh  ; pyramid 50  scr=1 shape=14
	defb 0018h, 0070h, 002Eh  ; pyramid 51  scr=1 shape=14
	defb 0070h, 0030h, 002Eh  ; pyramid 52  scr=1 shape=14
	defb 0050h, 0050h, 004Eh  ; pyramid 53  scr=2 shape=14
	defb 0058h, 0058h, 002Eh  ; pyramid 54  scr=1 shape=14
	defb 0038h, 0050h, 0030h  ; pyramid 55  scr=1 shape=16
	defb 0000h, 0070h, 0030h  ; pyramid 56  scr=1 shape=16
	defb 0078h, 0048h, 0050h  ; pyramid 57  scr=2 shape=16
	defb 0038h, 0088h, 0050h  ; pyramid 58  scr=2 shape=16
	defb 0060h, 0070h, 0030h  ; pyramid 59  scr=1 shape=16
	defb 0090h                    ; pyramid 60 X; Y/shape overlap b9ad_tbl[0] (70 50h)

b9ad_tbl:                         ; 0xB9AD  exit-door metatile (shape 1-16); [0] overlap
	defw 05070h, door_b9cf, door_b9d0, door_b9d2, door_b9d5, door_b9d9, door_b9de, door_b9e4
	defw door_b9eb, door_b9f3, door_b9fc, door_ba06, door_ba11, door_ba1d, door_ba2a, door_ba38
	defw door_ba47
door_b9cf:  defb 005h
door_b9d0:  defb 00Ah, 005h
door_b9d2:  defb 006h, 00Ah, 005h
door_b9d5:  defb 00Ah, 005h, 00Fh, 000h
door_b9d9:  defb 003h, 00Ah, 005h, 00Fh, 000h
door_b9de:  defb 009h, 006h, 00Ah, 005h, 00Ch, 003h
door_b9e4:  defb 000h, 009h, 006h, 00Ah, 005h, 00Ch, 003h
door_b9eb:  defb 00Ah, 005h, 009h, 006h, 00Ch, 003h, 00Fh, 000h
door_b9f3:  defb 001h, 00Ah, 005h, 009h, 006h, 00Ch, 003h, 00Fh, 000h
door_b9fc:  defb 00Ah, 005h, 000h, 00Fh, 004h, 00Bh, 008h, 007h, 00Ch, 003h
door_ba06:  defb 001h, 00Ah, 005h, 000h, 00Fh, 004h, 00Bh, 008h, 007h, 00Ch, 003h
door_ba11:  defb 004h, 00Bh, 002h, 00Dh, 007h, 008h, 00Eh, 001h, 00Ch, 003h, 00Fh, 000h
door_ba1d:  defb 005h, 004h, 00Bh, 002h, 00Dh, 007h, 008h, 00Eh, 001h, 00Ch, 003h, 00Fh, 000h
door_ba2a:  defb 009h, 006h, 003h, 00Ch, 00Fh, 000h, 004h, 008h, 00Dh, 00Eh, 00Bh, 007h, 002h, 001h
door_ba38:  defb 005h, 009h, 006h, 003h, 00Ch, 00Fh, 000h, 004h, 008h, 00Dh, 00Eh, 00Bh, 007h, 002h, 001h
door_ba47:  defb 00Ch, 009h, 006h, 003h, 00Fh, 00Ah, 005h, 000h, 00Eh, 00Dh, 002h, 001h, 00Bh, 008h, 007h, 004h

ba57_tbl:                         ; 0xBA57  world-1 -> (idx, val) pairs; 0xFF end
	defw ba_w1, ba_w2, ba_w3, ba_w4, ba_w5
ba_w1:
	defb 0, 2, 3, 1, 6, 2, 11, 0, 25, 2, 31, 1, 39, 2, 44, 1
	defb 47, 3, 52, 1, 57, 3, 60, 1, 63, 2, 71, 1, 76, 3, 79, 1
	defb 82, 2
	defb 0FFh
ba_w2:
	defb 0, 2, 3, 1, 6, 2, 11, 1, 16, 3, 21, 1, 24, 3, 29, 0
	defb 32, 3, 46, 1, 54, 2, 60, 0, 63, 2, 68, 1, 76, 2, 84, 0
	defb 89, 2, 94, 1, 97, 2, 103, 1, 108, 3, 111, 1, 114, 3, 119, 0
	defb 122, 3, 125, 1, 130, 3, 135, 0, 140, 3, 148, 0, 151, 3, 154, 1
	defb 160, 2, 165, 1, 170, 2, 181, 1
	defb 0FFh
ba_w3:
	defb 0, 3, 3, 1, 11, 2, 29, 1, 33, 3, 57, 0, 63, 3, 66, 1
	defb 69, 3, 74, 0, 82, 2, 87, 0, 95, 3, 100, 0, 103, 3, 106, 1
	defb 117, 3, 125, 1, 133, 3
	defb 0FFh
ba_w4:
	defb 0, 0, 8, 3, 16, 1, 32, 3, 48, 0, 62, 2, 70, 0, 75, 3
	defb 86, 0, 115, 2, 121, 1, 126, 2, 131, 1
	defb 0FFh
ba_w5:
	defb 0, 2, 8, 1, 11, 2, 17, 0, 31, 3, 34, 0, 39, 3, 47, 0
	defb 55, 2, 63, 0, 68, 3, 87, 0, 93, 2, 104, 1, 107, 2, 123, 1
	defb 131, 2, 134, 1, 139, 2, 141, 1
	defb 0FFh
