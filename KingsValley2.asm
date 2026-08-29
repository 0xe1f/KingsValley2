; ===========================================================================
;  KingsValley2  —  MSXDAW. Mapper: konami-scc, 16 x 8 KiB banks.
;  Page 4000-5FFF is never remapped (no ld (5000h),a). Later banks are
;  consecutive triplets into 6000/8000/A000 via page_triplet (bank 0).
;  Bank 0–15 are source.
; ===========================================================================

    OUTPUT "KingsValley2.rom"
    ORG 0x0000

    INCLUDE "banks/bios.inc"
    INCLUDE "banks/ram.inc"
    INCLUDE "banks/text.inc"
    INCLUDE "banks/objects.inc"

; --- bank 00 ---
    PHASE 0x4000
    INCLUDE "banks/bank00.asm"
    DEPHASE

; --- banks 1–3 ---  boot triplet @ 6000/8000/A000 (page_banks_123)
    PHASE 0x6000
    INCLUDE "banks/banks123.asm"
    DEPHASE

; --- bank 04 ---  triplet 4,5,6 @ 6000/8000/A000
    PHASE 0x6000
    MODULE bank04
    INCLUDE "banks/bank04.asm"
    ENDMODULE
    DEPHASE

; --- bank 05 ---
    PHASE 0x8000
    MODULE bank05
    INCLUDE "banks/bank05.asm"
    ENDMODULE
    DEPHASE

; --- bank 06 ---
    PHASE 0xA000
    MODULE bank06
    INCLUDE "banks/bank06.asm"
    ENDMODULE
    DEPHASE

; --- bank 07 ---  triplet 7,8,9 @ 6000/8000/A000
    PHASE 0x6000
    MODULE bank07
    INCLUDE "banks/bank07.asm"
    ENDMODULE
    DEPHASE

; --- bank 08 ---
    PHASE 0x8000
    MODULE bank08
    INCLUDE "banks/bank08.asm"
    ENDMODULE
    DEPHASE

; --- bank 09 ---
    PHASE 0xA000
    MODULE bank09
    INCLUDE "banks/bank09.asm"
    ENDMODULE
    DEPHASE

; --- bank 10 ---  triplet 10,11,12 @ 6000/8000/A000
    PHASE 0x6000
    MODULE bank10
    INCLUDE "banks/bank10.asm"
    ENDMODULE
    DEPHASE

; --- bank 11 ---
    PHASE 0x8000
    MODULE bank11
    INCLUDE "banks/bank11.asm"
    ENDMODULE
    DEPHASE

; --- bank 12 ---
    PHASE 0xA000
    MODULE bank12
    INCLUDE "banks/bank12.asm"
    ENDMODULE
    DEPHASE

; --- bank 13 ---  A000-only (page_bank_13)
    PHASE 0xA000
    MODULE bank13
    INCLUDE "banks/bank13.asm"
    ENDMODULE
    DEPHASE

; --- bank 14 ---  with 15 at 8000/A000 (page_banks_14_15)
    PHASE 0x8000
    MODULE bank14
    INCLUDE "banks/bank14.asm"
    ENDMODULE
    DEPHASE

; --- bank 15 ---
    PHASE 0xA000
    MODULE bank15
    INCLUDE "banks/bank15.asm"
    ENDMODULE
    DEPHASE

