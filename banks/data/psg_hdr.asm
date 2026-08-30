; packed-PSG headers (sound_play / sound_ptr ids 1–0x41).
; db flags, pri; then dw per SET bit (bit 7 first … bit 0).
; flags bits 7..0 → channels E000, E033, E066, E099, E0CC, E0FF, E132, E165.
; sound_play copies 18 bytes from each entry (window may overlap the next header).
; Channel ptrs at 0x8000+ use ch_* labels (same window as headers).

psg_01:                            ; 0x6FB0  id 1  sfx_01
	defb 0ffh, 0feh
	defw ch_785e, ch_785e, ch_785e, ch_785e, ch_785e, ch_785e, ch_785e, ch_785e

psg_02:                            ; 0x6FC2  id 2  sfx_02
	defb 010h, 0fdh
	defw ch_b0e9

psg_03:                            ; 0x6FC6  id 3  sfx_03
	defb 0ffh, 0a0h
	defw ch_785f, ch_7882, ch_78b1, ch_78df, ch_790d, ch_7951, ch_7999, ch_79bb

psg_04:                            ; 0x6FD8  id 4  sfx_04
	defb 0cfh, 0a0h
	defw ch_79da, ch_79da, ch_79da, ch_79da, ch_79da, ch_79da

psg_05:                            ; 0x6FE6  id 5  sfx_05  BGM (bgm_stage)
	defb 0cfh, 0a0h
	defw ch_79db, ch_7a0d, ch_7aa4, ch_7af0, ch_7b84, ch_7c23

psg_06:                            ; 0x6FF4  id 6  sfx_06  BGM (bgm_stage)
	defb 0cfh, 0a0h
	defw ch_7d42, ch_7d98, ch_7e35, ch_7e93, ch_7f58, ch_7fd7

psg_07:                            ; 0x7002  id 7  sfx_07  BGM (bgm_stage)
	defb 0cfh, 0a0h
	defw ch_80a0, ch_80d8, ch_8201, ch_8265, ch_8391, ch_84c3

psg_08:                            ; 0x7010  id 8  sfx_08  BGM (bgm_stage)
	defb 0cfh, 0a0h
	defw ch_8619, ch_865b, ch_86a8, ch_8712, ch_87db, ch_8895

psg_09:                            ; 0x701E  id 9  sfx_09  BGM (bgm_stage)
	defb 0cfh, 0a0h
	defw ch_896f, ch_89b7, ch_8a67, ch_8ac2, ch_8b78, ch_8c75

psg_0a:                            ; 0x702C  id 10  sfx_0a
	defb 0cfh, 0a0h
	defw ch_8d60, ch_8de6, ch_8ee7, ch_8fbf, ch_9102, ch_9249

psg_0b:                            ; 0x703A  id 11  sfx_0b
	defb 0cfh, 0a0h
	defw ch_9372, ch_9394, ch_93bb, ch_93e9, ch_941d, ch_9453

psg_0c:                            ; 0x7048  id 12  sfx_0c
	defb 0ffh, 0a0h
	defw ch_9492, ch_94a7, ch_94d2, ch_94fd, ch_9527, ch_955b, ch_95a3, ch_95ef

psg_0d:                            ; 0x705A  id 13  sfx_0d
	defb 0cfh, 0a0h
	defw ch_9623, ch_9682, ch_9729, ch_97a4, ch_983e, ch_9884

psg_0e:                            ; 0x7068  id 14  sfx_0e
	defb 0ffh, 0a0h
	defw ch_98c9, ch_994f, ch_99c8, ch_9aa2, ch_9b49, ch_9bdf, ch_9ce3, ch_9d8f

psg_0f:                            ; 0x707A  id 15  sfx_0f
	defb 0ffh, 0a0h
	defw ch_9fc8, ch_9fd3, ch_9ffa, ch_a01f, ch_a031, ch_a06a, ch_a085, ch_a0aa

psg_10:                            ; 0x708C  id 16  sfx_10
	defb 0ffh, 0a0h
	defw ch_a0cc, ch_a0d3, ch_a0da, ch_a0e1, ch_a0f5, ch_a10a, ch_a11f, ch_a138

psg_11:                            ; 0x709E  id 17  sfx_11
	defb 0cfh, 0a0h
	defw ch_a149, ch_a15e, ch_a19d, ch_a1c7, ch_a207, ch_a23c

psg_12:                            ; 0x70AC  id 18  sfx_12
	defb 0cfh, 0a0h
	defw ch_a2ad, ch_a2bf, ch_a338, ch_a351, ch_a3d9, ch_a483

psg_13:                            ; 0x70BA  id 19  sfx_13
	defb 030h, 005h
	defw ch_a50e, ch_a53d

psg_14:                            ; 0x70C0  id 20  sfx_14
	defb 030h, 002h
	defw ch_a572, ch_a588

psg_15:                            ; 0x70C6  id 21  sfx_15
	defb 030h, 01bh
	defw ch_a5a9, ch_a5e0

psg_16:                            ; 0x70CC  id 22  sfx_16
	defb 030h, 01bh
	defw ch_a61b, ch_a634

psg_17:                            ; 0x70D2  id 23  sfx_17
	defb 030h, 01bh
	defw ch_a64d, ch_a684

psg_18:                            ; 0x70D8  id 24  sfx_18
	defb 030h, 01bh
	defw ch_a6c1, ch_a6e0

psg_19:                            ; 0x70DE  id 25  sfx_19
	defb 030h, 038h
	defw ch_a701, ch_a74e

psg_1a:                            ; 0x70E4  id 26  sfx_1a
	defb 030h, 040h
	defw ch_a79f, ch_a7c6

psg_1b:                            ; 0x70EA  id 27  sfx_1b
	defb 030h, 007h
	defw ch_a7ed, ch_a80f

psg_1c:                            ; 0x70F0  id 28  sfx_1c
	defb 030h, 007h
	defw ch_a850, ch_a897

psg_1d:                            ; 0x70F6  id 29  sfx_1d
	defb 030h, 018h
	defw ch_a8d2, ch_a947

psg_1e:                            ; 0x70FC  id 30  sfx_1e
	defb 030h, 018h
	defw ch_aa88, ch_aab5

psg_1f:                            ; 0x7102  id 31  sfx_1f
	defb 030h, 003h
	defw ch_ab0a, ch_ab41

psg_20:                            ; 0x7108  id 32  sfx_20
	defb 030h, 0fdh
	defw ch_ab78, ch_ab9b

psg_21:                            ; 0x710E  id 33  sfx_21
	defb 030h, 010h
	defw ch_a9ce, ch_aa29

psg_22:                            ; 0x7114  id 34  sfx_22
	defb 030h, 010h
	defw ch_ac34, ch_ac8f

psg_23:                            ; 0x711A  id 35  sfx_23
	defb 0ffh, 0a0h
	defw ch_9488, ch_949d, ch_94c6, ch_94e4, ch_950f, ch_9543, ch_9587, ch_95db

psg_24:                            ; 0x712C  id 36  sfx_24
	defb 030h, 010h
	defw ch_abc2, ch_abf9

psg_25:                            ; 0x7132  id 37  sfx_25
	defb 030h, 010h
	defw ch_ac34, ch_ac8f

psg_26:                            ; 0x7138  id 38  sfx_26
	defb 030h, 039h
	defw ch_acea, ch_ad51

psg_27:                            ; 0x713E  id 39  sfx_27
	defb 030h, 040h
	defw ch_adbe, ch_adf7

psg_28:                            ; 0x7144  id 40  sfx_28
	defb 0ffh, 0a0h
	defw ch_ae34, ch_ae67, ch_ae9a, ch_aed3, ch_af08, ch_af3f, ch_af7a, ch_afaf

psg_29:                            ; 0x7156  id 41  sfx_29
	defb 0ffh, 0a0h
	defw ch_afe8, ch_b019, ch_b04a, ch_b05a, ch_b06c, ch_b076, ch_b082, ch_b0b3

psg_2a:                            ; 0x7168  id 42  sfx_2a
	defb 030h, 080h
	defw ch_b0ff, ch_b144

psg_2b:                            ; 0x716E  id 43  sfx_2b
	defb 030h, 001h
	defw ch_b18b, ch_b1a6

psg_2c:                            ; 0x7174  id 44  sfx_2c
	defb 030h, 002h
	defw ch_b1bf, ch_b212

psg_2d:                            ; 0x717A  id 45  sfx_2d
	defb 030h, 039h
	defw ch_b265, ch_b2c4

psg_2e:                            ; 0x7180  id 46  sfx_2e
	defb 030h, 040h
	defw ch_b325, ch_b366

psg_2f:                            ; 0x7186  id 47  sfx_2f
	defb 030h, 040h
	defw ch_b3ab, ch_b3ab

psg_30:                            ; 0x718C  id 48  sfx_30
	defb 0ffh, 0a0h
	defw ch_b3ac, ch_b3b4, ch_b3c0, ch_b3ca, ch_b3d6, ch_b3e4, ch_b3f0, ch_b3fc

psg_31:                            ; 0x719E  id 49  sfx_31
	defb 030h, 010h
	defw ch_aa88, ch_aab5

psg_32:                            ; 0x71A4  id 50  sfx_32
	defb 030h, 010h
	defw ch_b4a2, ch_b4d1

psg_33:                            ; 0x71AA  id 51  sfx_33
	defb 030h, 011h
	defw ch_b4fe, ch_b4fe

psg_34:                            ; 0x71B0  id 52  sfx_34
	defb 030h, 002h
	defw ch_b4ff, ch_b4ff

psg_35:                            ; 0x71B6  id 53  sfx_35
	defb 030h, 039h
	defw ch_b500, ch_b51d

psg_36:                            ; 0x71BC  id 54  sfx_36
	defb 030h, 008h
	defw ch_b530, ch_b551

psg_37:                            ; 0x71C2  id 55  sfx_37
	defb 030h, 010h
	defw ch_b56a, ch_b599

psg_38:                            ; 0x71C8  id 56  sfx_38
	defb 030h, 002h
	defw ch_b5c8, ch_b5e9

psg_39:                            ; 0x71CE  id 57  sfx_39
	defb 030h, 010h
	defw ch_b60c, ch_b661

psg_3a:                            ; 0x71D4  id 58  sfx_3a
	defb 0ffh, 0a0h
	defw ch_b6b4, ch_b6fd, ch_b746, ch_b7d1, ch_b86c, ch_b907, ch_b992, ch_ba19

psg_3b:                            ; 0x71E6  id 59  sfx_3b
	defb 030h, 040h
	defw ch_baa0, ch_bac7

psg_3c:                            ; 0x71EC  id 60  sfx_3c
	defb 030h, 002h
	defw ch_baec, ch_bb3f

psg_3d:                            ; 0x71F2  id 61  sfx_3d
	defb 030h, 010h
	defw ch_bb92, ch_bbcd

psg_3e:                            ; 0x71F8  id 62  sfx_3e
	defb 030h, 010h
	defw ch_bbfe, ch_bc6b

psg_3f:                            ; 0x71FE  id 63  sfx_3f
	defb 030h, 010h
	defw ch_bcda, ch_bcdb

psg_40:                            ; 0x7204  id 64  sfx_40
	defb 030h, 040h
	defw ch_bcdc, ch_bd19

psg_41:                            ; 0x720A  id 65  sfx_41
	defb 030h, 018h
	defw ch_bd5a, ch_bd79

