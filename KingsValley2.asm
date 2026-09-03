; ===========================================================================
;  KingsValley2  —  MSXDAW. Mapper: konami-scc, 16 x 8 KiB banks.
;  Page 4000-5FFF is never remapped (no ld (5000h),a). Later banks are
;  consecutive triplets into 6000/8000/A000 via page_triplet (bank 0).
;  One source file per paging window (stems like Vampire Killer: banks_123).
; ===========================================================================

    OUTPUT "KingsValley2.rom"
    ORG 0x0000

    INCLUDE "banks/bios.inc"
    INCLUDE "banks/ram.inc"
    INCLUDE "banks/text.inc"
    INCLUDE "banks/objects.inc"

; --- bank 0 ---  resident @ 4000
    PHASE 0x4000
    INCLUDE "banks/banks_0.asm"
    DEPHASE

; --- banks 1-3 ---  boot triplet @ 6000/8000/A000 (page_banks_123)
    PHASE 0x6000
    INCLUDE "banks/banks_123.asm"
    DEPHASE

; --- banks 4-6 ---  sound triplet @ 6000/8000/A000 (page_banks_456)
    PHASE 0x6000
    MODULE banks_456
    INCLUDE "banks/banks_456.asm"
    ENDMODULE
    DEPHASE

; --- banks 7-9 ---  gfx triplet @ 6000/8000/A000 (page_banks_789)
    PHASE 0x6000
    MODULE banks_789
    INCLUDE "banks/banks_789.asm"
    ENDMODULE
    DEPHASE

; --- banks a-c ---  map triplet @ 6000/8000/A000 (page_banks_abc)
    PHASE 0x6000
    MODULE banks_abc
    INCLUDE "banks/banks_abc.asm"
    ENDMODULE
    DEPHASE

; --- bank d ---  A000-only (page_bank_d)
    PHASE 0xA000
    MODULE banks_d
    INCLUDE "banks/banks_d.asm"
    ENDMODULE
    DEPHASE

; --- banks e-f ---  font + UI @ 8000/A000 (page_banks_ef)
    PHASE 0x8000
    MODULE banks_ef
    INCLUDE "banks/banks_ef.asm"
    ENDMODULE
    DEPHASE
