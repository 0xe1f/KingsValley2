; world-map copy_tiles 1bpp (bank 0C). tiles_wmap / wmap_font after
; page_banks_abc; dest VRAM 0x8030 / 0xB838 / 0x0038. Colour C
; is 0x0A (play) / 0x0C / 0x0B (editor). 42 tiles 0xAA29–0xAB79
; (0–9, extras, A–Z); 5 marks at 0xAB79; 4bpp pair at 0xABC1 (copy_4bpp).

; 42 × 8×8 1bpp (copy_tiles B=0x29 or 0x2A)
wmap_aa29:                        ; AA29
	defb %00000000
	defb %00011100
	defb %00100010
	defb %01100011
	defb %01100011
	defb %01100011
	defb %00100010
	defb %00011100
wmap_aa31:                        ; AA31
	defb %00000000
	defb %00011000
	defb %00111000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %01111110
wmap_aa39:                        ; AA39
	defb %00000000
	defb %00111110
	defb %01100011
	defb %00000011
	defb %00001110
	defb %00111100
	defb %01110000
	defb %01111111
wmap_aa41:                        ; AA41
	defb %00000000
	defb %00111110
	defb %01100011
	defb %00000011
	defb %00001110
	defb %00000011
	defb %01100011
	defb %00111110
wmap_aa49:                        ; AA49
	defb %00000000
	defb %00001110
	defb %00011110
	defb %00110110
	defb %01100110
	defb %01100110
	defb %01111111
	defb %00000110
wmap_aa51:                        ; AA51
	defb %00000000
	defb %01111111
	defb %01100000
	defb %01111110
	defb %01100011
	defb %00000011
	defb %01100011
	defb %00111110
wmap_aa59:                        ; AA59
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100000
	defb %01111110
	defb %01100011
	defb %01100011
	defb %00111110
wmap_aa61:                        ; AA61
	defb %00000000
	defb %01111111
	defb %01100011
	defb %00000110
	defb %00001100
	defb %00011000
	defb %00011000
	defb %00011000
wmap_aa69:                        ; AA69
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100011
	defb %00111110
	defb %01100011
	defb %01100011
	defb %00111110
wmap_aa71:                        ; AA71
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100011
	defb %00111111
	defb %00000011
	defb %01100011
	defb %00111110
wmap_aa79:                        ; AA79
	defb %00111100
	defb %01000010
	defb %10011001
	defb %10100001
	defb %10100001
	defb %10011001
	defb %01000010
	defb %00111100
wmap_aa81:                        ; AA81
	defb %00000000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00000000
	defb %00011000
wmap_aa89:                        ; AA89
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
wmap_aa91:                        ; AA91
	defb %00000000
	defb %00011100
	defb %00110110
	defb %01100011
	defb %01100011
	defb %01111111
	defb %01100011
	defb %01100011
wmap_aa99:                        ; AA99
	defb %00000000
	defb %01111110
	defb %01100011
	defb %01100011
	defb %01111110
	defb %01100011
	defb %01100011
	defb %01111110
wmap_aaa1:                        ; AAA1
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100000
	defb %01100000
	defb %01100000
	defb %01100011
	defb %00111110
wmap_aaa9:                        ; AAA9
	defb %00000000
	defb %01111100
	defb %01100110
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100110
	defb %01111100
wmap_aab1:                        ; AAB1
	defb %00000000
	defb %01111111
	defb %01100000
	defb %01100000
	defb %01111110
	defb %01100000
	defb %01100000
	defb %01111111
wmap_aab9:                        ; AAB9
	defb %00000000
	defb %01111111
	defb %01100000
	defb %01100000
	defb %01111110
	defb %01100000
	defb %01100000
	defb %01100000
wmap_aac1:                        ; AAC1
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100000
	defb %01100111
	defb %01100011
	defb %01100011
	defb %00111111
wmap_aac9:                        ; AAC9
	defb %00000000
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01111111
	defb %01100011
	defb %01100011
	defb %01100011
wmap_aad1:                        ; AAD1
	defb %00000000
	defb %00111100
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00111100
wmap_aad9:                        ; AAD9
	defb %00000000
	defb %00011111
	defb %00000110
	defb %00000110
	defb %00000110
	defb %00000110
	defb %01100110
	defb %00111100
wmap_aae1:                        ; AAE1
	defb %00000000
	defb %01100011
	defb %01100110
	defb %01101100
	defb %01111000
	defb %01111100
	defb %01101110
	defb %01100111
wmap_aae9:                        ; AAE9
	defb %00000000
	defb %01100000
	defb %01100000
	defb %01100000
	defb %01100000
	defb %01100000
	defb %01100000
	defb %01111111
wmap_aaf1:                        ; AAF1
	defb %00000000
	defb %01100011
	defb %01110111
	defb %01111111
	defb %01111111
	defb %01101011
	defb %01100011
	defb %01100011
wmap_aaf9:                        ; AAF9
	defb %00000000
	defb %01100011
	defb %01110011
	defb %01111011
	defb %01111111
	defb %01101111
	defb %01100111
	defb %01100011
wmap_ab01:                        ; AB01
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %00111110
wmap_ab09:                        ; AB09
	defb %00000000
	defb %01111110
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01111110
	defb %01100000
	defb %01100000
wmap_ab11:                        ; AB11
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01101111
	defb %01100110
	defb %00111101
wmap_ab19:                        ; AB19
	defb %00000000
	defb %01111110
	defb %01100011
	defb %01100011
	defb %01100010
	defb %01111100
	defb %01100110
	defb %01100011
wmap_ab21:                        ; AB21
	defb %00000000
	defb %00111110
	defb %01100011
	defb %01100000
	defb %00111110
	defb %00000011
	defb %01100011
	defb %00111110
wmap_ab29:                        ; AB29
	defb %00000000
	defb %01111110
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
	defb %00011000
wmap_ab31:                        ; AB31
	defb %00000000
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %00111110
wmap_ab39:                        ; AB39
	defb %00000000
	defb %01100011
	defb %01100011
	defb %01100011
	defb %01100011
	defb %00110110
	defb %00011100
	defb %00001000
wmap_ab41:                        ; AB41
	defb %00000000
	defb %01100011
	defb %01100011
	defb %01101011
	defb %01101011
	defb %01111111
	defb %01110111
	defb %00100010
wmap_ab49:                        ; AB49
	defb %00000000
	defb %01100011
	defb %01110110
	defb %00111100
	defb %00011100
	defb %00011110
	defb %00110111
	defb %01100011
wmap_ab51:                        ; AB51
	defb %00000000
	defb %01100110
	defb %01100110
	defb %01111110
	defb %00111100
	defb %00011000
	defb %00011000
	defb %00011000
wmap_ab59:                        ; AB59
	defb %00000000
	defb %01111111
	defb %00000111
	defb %00001110
	defb %00011100
	defb %00111000
	defb %01110000
	defb %01111111
wmap_ab61:                        ; AB61
	defb %00000000
	defb %01111111
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
wmap_ab69:                        ; AB69
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %01111110
	defb %00000000
	defb %00000000
	defb %00000000
wmap_ab71:                        ; AB71
	defb %00000000
	defb %00111100
	defb %01100110
	defb %01100110
	defb %00001100
	defb %00011000
	defb %00000000
	defb %00011000

; 5 × 8×8 1bpp (copy_tiles B=5)
wmap_ab79:                        ; AB79
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00110000
	defb %00110000
wmap_ab81:                        ; AB81
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00011000
	defb %00011000
	defb %00000000
	defb %00000000
	defb %00000000
wmap_ab89:                        ; AB89
	defb %00101000
	defb %00101000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
	defb %00000000
wmap_ab91:                        ; AB91
	defb %11111111
	defb %00110011
	defb %00110011
	defb %00110011
	defb %00110011
	defb %00110011
	defb %00110011
	defb %11111111
wmap_ab99:                        ; AB99
	defb %11111110
	defb %00110000
	defb %00110000
	defb %00110000
	defb %00110000
	defb %00110000
	defb %00110000
	defb %11111110

; 0xABA1–0xABC1: 32-byte 4bpp 8×8 (high nibble left), unused by named copy
wmap_aba1:
	defb 002h, 002h, 02ah, 0aah, 02ah, 002h, 002h, 002h
	defb 000h, 000h, 0feh, 001h, 0feh, 000h, 000h, 000h
	defb 091h, 081h, 081h, 081h, 081h, 081h, 061h, 011h
	defb 051h, 051h, 051h, 0f7h, 0f1h, 0f1h, 0f1h, 0f1h

; 0xABC1: two 8×8 4bpp tiles (copy_4bpp B=2 → VRAM 0x9870)
wmap_abc1:
	defb 000h, 000h, 000h, 0f0h, 00fh, 0ffh, 0ffh, 0afh
	defb 0f7h, 071h, 071h, 0afh, 0f7h, 071h, 071h, 0afh
	defb 0fah, 0afh, 0afh, 0afh, 00fh, 0ffh, 0ffh, 0afh
	defb 000h, 000h, 000h, 0f0h, 000h, 000h, 000h, 000h
	defb 000h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 000h
	defb 0ddh, 0ddh, 0ddh, 0f0h, 0bbh, 0bbh, 0bbh, 0bfh
	defb 0bbh, 0bbh, 0bbh, 0f0h, 0ffh, 0ffh, 0ffh, 000h
	defb 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
