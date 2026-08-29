; ===========================================================================
;  KingsValley2  —  MSXDAW scaffold. Mapper: konami-scc, 16 x 8 KiB banks.
;  Bank 0 is source (`banks/bank00.asm`); leftover banks are INCBIN until folded.
; ===========================================================================

    OUTPUT "KingsValley2.rom"
    ORG 0x0000

    INCLUDE "banks/bios.inc"
    INCLUDE "banks/ram.inc"

; --- bank 00 ---
    PHASE 0x4000
    INCLUDE "banks/bank00.asm"
    DEPHASE

; --- bank 01 ---
    PHASE 0x6000
    INCBIN "banks/bank01.bin"
    DEPHASE

; --- bank 02 ---
    PHASE 0x8000
    INCBIN "banks/bank02.bin"
    DEPHASE

; --- bank 03 ---
    PHASE 0xA000
    INCBIN "banks/bank03.bin"
    DEPHASE

; --- bank 04 ---
    PHASE 0x4000
    INCBIN "banks/bank04.bin"
    DEPHASE

; --- bank 05 ---
    PHASE 0x6000
    INCBIN "banks/bank05.bin"
    DEPHASE

; --- bank 06 ---
    PHASE 0x8000
    INCBIN "banks/bank06.bin"
    DEPHASE

; --- bank 07 ---
    PHASE 0xA000
    INCBIN "banks/bank07.bin"
    DEPHASE

; --- bank 08 ---
    PHASE 0x4000
    INCBIN "banks/bank08.bin"
    DEPHASE

; --- bank 09 ---
    PHASE 0x6000
    INCBIN "banks/bank09.bin"
    DEPHASE

; --- bank 10 ---
    PHASE 0x8000
    INCBIN "banks/bank10.bin"
    DEPHASE

; --- bank 11 ---
    PHASE 0xA000
    INCBIN "banks/bank11.bin"
    DEPHASE

; --- bank 12 ---
    PHASE 0x4000
    INCBIN "banks/bank12.bin"
    DEPHASE

; --- bank 13 ---
    PHASE 0x6000
    INCBIN "banks/bank13.bin"
    DEPHASE

; --- bank 14 ---
    PHASE 0x8000
    INCBIN "banks/bank14.bin"
    DEPHASE

; --- bank 15 ---
    PHASE 0xA000
    INCBIN "banks/bank15.bin"
    DEPHASE

