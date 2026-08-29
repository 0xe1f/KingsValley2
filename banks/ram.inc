; ===========================================================================
;  Confirmed work-RAM. Readability only — not emitted, not in msx.sym
;  (z80dasm would rewrite matching immediates).
; ===========================================================================

; BIOS hooks (system work area)
H_KEYI:                  equ 0xFD9A
H_TIMI:                  equ 0xFD9F
H_STKE:                  equ 0xFEDA
H_PHYD:                  equ 0xFFA7

; Boot (bank 0 cart_boot). Stack at 0xE000; 0xE000-0xEFFF and 0xD200-0xD3FF
; are zeroed. Mapper copies at 0xF0F1/F0F2/F0F3 track banks written to
; 0x7000 / 0x9000 / 0xB000 (SCC pages 6000 / 8000 / A000).
mapper_bank_6000:        equ 0xF0F1
mapper_bank_8000:        equ 0xF0F2
mapper_bank_A000:        equ 0xF0F3

; Vic. 0xE280 is d_9ecd (no dec a): 0 walk, 1 jump, 2 climb (ladder;
; secret_hit arms bit 5), 3 fall-in, 4 die, 5 E500-hit, 6/7 coffin pull,
; 8-13 tools, 14 hold. Not an equ — z80dasm would rewrite immediates.
; 0xE282 X, 0xE284 Y, 0xE287 held E300 type.
; 0xE788  screen ids from ab5a_flags. 0xED80/90/A0/B0 door links (4 dirs).
