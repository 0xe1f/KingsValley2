; bank 0E Vic held-tool gfx (vic_pat / vic_reload).
; held_ptr[(0xE287)] → 4-byte recs until 0xFF. lo-nibble 0 = RLE dest,src
; words; else copy n (lo-nibble overwrites dest lo). RLE dests are
; E000-range work RAM; srcs are rle_* in this bank.
; vic_hmm / vic_hmm2: 14 vdp_hmmm dests, (0xE285)*2. Src XY
; is 00F0 / 80F0 (pattern / colour).

held_ptr:                            ; 0x858B  E287 = 0 none, 1–6 tool
	defw held_0, held_1, held_2, held_3, held_4, held_5, held_6

held_0:                            ; 0x8599  unarmed (vic_unarmed)
	defw 0e000h, rle_86d4   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_875d   ; rle
	defb 052h, 0e2h         ; copy 2
	defw 0e200h
	defw 0e300h, rle_8fd9   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_905d   ; rle
	defb 052h, 0e5h         ; copy 2
	defw 0e500h
	defb 0ffh               ; end

held_1:                            ; 0x85BA  knife (vic_knife)
	defw 0e000h, rle_87ee   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_8876   ; rle
	defw 0e240h, rle_9510   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_90d4   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_91aa   ; rle
	defw 0e540h, rle_9227   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

held_2:                            ; 0x85E3  boomerang (vic_boomerang)
	defw 0e000h, rle_8911   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_89a0   ; rle
	defw 0e240h, rle_9510   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_90d4   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_91aa   ; rle
	defw 0e540h, rle_9227   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

held_3:                            ; 0x860C  shovel (vic_shovel)
	defw 0e000h, rle_8a3f   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_8afa   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_90d4   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_9158   ; rle
	defw 0e500h, rle_9254   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

held_4:                            ; 0x8631  pick (vic_pick)
	defw 0e000h, rle_8d08   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_8dc1   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_9304   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_9388   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

held_5:                            ; 0x8652  hammer (vic_hammer)
	defw 0e000h, rle_8bc6   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_8c4f   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_90d4   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_9158   ; rle
	defw 0e500h, rle_92ad   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

held_6:                            ; 0x8677  drill (vic_drill)
	defw 0e000h, rle_8e86   ; rle
	defb 0d6h, 0e0h         ; copy 6
	defw 0e000h
	defw 0e180h, rle_8f0e   ; rle
	defb 094h, 0e2h         ; copy 4
	defw 0e200h
	defw 0e300h, rle_9432   ; rle
	defb 0d6h, 0e3h         ; copy 6
	defw 0e300h
	defw 0e480h, rle_9158   ; rle
	defw 0e500h, rle_94b7   ; rle
	defb 094h, 0e5h         ; copy 4
	defw 0e500h
	defb 0ffh               ; end

vic_hmm:                             ; 0x869C  vdp_hmmm dest, src 00F0
	defw 000c0h, 080c0h, 000c1h, 080c1h, 000c2h, 080c2h, 000c3h
	defw 080c3h, 000c4h, 080c4h, 000c4h, 080c4h, 000c5h, 080c5h
vic_hmm2:                            ; 0x86B8  vdp_hmmm dest, src 80F0
	defw 000c6h, 080c6h, 000c7h, 080c7h, 000c8h, 080c8h, 000c9h
	defw 080c9h, 000cah, 080cah, 000cah, 080cah, 000cbh, 080cbh

