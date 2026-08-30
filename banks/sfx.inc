; ===========================================================================
;  sound_far thunks (bank 00 @ 0x41E0). Id in A; 1–0x27 use jp, 0x28–0x41
;  use jr (last jr is +127 onto sound_far). Ids 1–0x41 index psg_01..psg_41
;  in bank 04. 0x80–0x84 are special-cased in the driver; 0x82/0x83 also
;  poke (0xE21A).
; ===========================================================================

    MACRO SFX n
        ld a, n
        jp sound_far
    ENDM

    MACRO SFXR n
        ld a, n
        jr sound_far
    ENDM
