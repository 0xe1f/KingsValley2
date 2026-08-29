; ===========================================================================
;  Packed map-object records (bank 13 lists -> E600 / E700 / E300).
;
;  ACTOR  (load_actors): 4 bytes, 0 end. type=hi4, screen=lo4, X, Y,
;          byte3 = (height << 3) | lo3 (lo3 -> ix+7 bit 1 + lid frame).
;  GEM    (load_gems):   3 bytes, 0 end. type=hi4 (always 1), screen=lo4, X, Y.
;          Last gem Y + terminator overlap a75d_tbl[0] (0x00A0).
;  TOOL   (load_map_tools): 3 bytes, 0xFF end. screen=hi4, type=lo4, Y, X.
;  LINK   (load_links):     2 bytes, 0xFF end. screen-from, screen-to (8x6 map).
;  DELAYED (0xB7CD -> E2C0): 4 bytes, 0 end. type, screen, X, Y (spawn_tool 1-4).
; ===========================================================================

    MACRO ACTOR typ, scr, x, y, hgt, lo3
        db (typ << 4) | scr, x, y, (hgt << 3) | lo3
    ENDM

    MACRO ACTOR_END
        db 0
    ENDM

    MACRO GEM typ, scr, x, y
        db (typ << 4) | scr, x, y
    ENDM

    MACRO GEM_END
        db 0
    ENDM

    MACRO TOOL typ, scr, y, x
        db (scr << 4) | typ, y, x
    ENDM

    MACRO TOOL_END
        db 0ffh
    ENDM

    MACRO LINK frm, dst
        db frm, dst
    ENDM

    MACRO LINK_END
        db 0ffh
    ENDM

    MACRO DELAYED typ, scr, x, y
        db typ, scr, x, y
    ENDM

    MACRO DELAYED_END
        db 0
    ENDM
