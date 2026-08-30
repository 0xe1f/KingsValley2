; bank 0E Vic held-tool gfx (sub_58dbh / vic_reload).
; held_ptr[(0xE287)] → VIC_RLE / VIC_COPY until 0xFF. RLE dests
; are E000-range work RAM; srcs are rle_* in this bank.
; vic_hmm / vic_hmm2: 14 vdp_hmmm dests, (0xE285)*2. Src XY
; is 00F0 / 80F0 (pattern / colour).

held_ptr:                            ; 0x858B  E287 = 0 none, 1–6 tool
	defw held_0, held_1, held_2, held_3, held_4, held_5, held_6

held_0:                            ; 0x8599  unarmed Vic
	VIC_RLE 0e000h, rle_86d4
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_875d
	VIC_COPY 2, 0e250h, 0e200h
	VIC_RLE 0e300h, rle_8fd9
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_905d
	VIC_COPY 2, 0e550h, 0e500h
	VIC_END

held_1:                            ; 0x85BA  knife
	VIC_RLE 0e000h, rle_87ee
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_8876
	VIC_RLE 0e240h, rle_9510
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_90d4
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_91aa
	VIC_RLE 0e540h, rle_9227
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

held_2:                            ; 0x85E3  boomerang
	VIC_RLE 0e000h, rle_8911
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_89a0
	VIC_RLE 0e240h, rle_9510
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_90d4
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_91aa
	VIC_RLE 0e540h, rle_9227
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

held_3:                            ; 0x860C  shovel
	VIC_RLE 0e000h, rle_8a3f
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_8afa
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_90d4
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_9158
	VIC_RLE 0e500h, rle_9254
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

held_4:                            ; 0x8631  pick
	VIC_RLE 0e000h, rle_8d08
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_8dc1
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_9304
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_9388
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

held_5:                            ; 0x8652  hammer
	VIC_RLE 0e000h, rle_8bc6
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_8c4f
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_90d4
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_9158
	VIC_RLE 0e500h, rle_92ad
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

held_6:                            ; 0x8677  drill
	VIC_RLE 0e000h, rle_8e86
	VIC_COPY 6, 0e0d0h, 0e000h
	VIC_RLE 0e180h, rle_8f0e
	VIC_COPY 4, 0e290h, 0e200h
	VIC_RLE 0e300h, rle_9432
	VIC_COPY 6, 0e3d0h, 0e300h
	VIC_RLE 0e480h, rle_9158
	VIC_RLE 0e500h, rle_94b7
	VIC_COPY 4, 0e590h, 0e500h
	VIC_END

vic_hmm:                             ; 0x869C  vdp_hmmm dest, src 00F0
	defw 000c0h, 080c0h, 000c1h, 080c1h, 000c2h, 080c2h, 000c3h
	defw 080c3h, 000c4h, 080c4h, 000c4h, 080c4h, 000c5h, 080c5h
vic_hmm2:                            ; 0x86B8  vdp_hmmm dest, src 80F0
	defw 000c6h, 080c6h, 000c7h, 080c7h, 000c8h, 080c8h, 000c9h
	defw 080c9h, 000cah, 080cah, 000cah, 080cah, 000cbh, 080cbh

