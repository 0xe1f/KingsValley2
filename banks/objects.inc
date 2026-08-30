; ===========================================================================
;  Packed map-object records (banks/data lists -> E600 / E700 / E300).
;
;  ACTOR  (load_actors): 4 bytes, 0 end. type=hi4, screen=lo4, X, Y,
;          byte3 = (height << 3) | lo3 (lo3 -> ix+7 bit 1 + lid frame).
;  GEM    (load_gems):   3 bytes, 0 end. type=hi4 (always 1), screen=lo4, X, Y.
;          Last gem Y + terminator overlap a75d_tbl[0] (0x00A0).
;  TOOL   (load_map_tools): 3 bytes, 0xFF end. screen=hi4, type=lo4, Y, X.
;  LINK   (load_links):     2 bytes, 0xFF end. screen-from, screen-to (8x6 map).
;  DELAYED (0xB7CD -> E2C0): 4 bytes, 0 end. type, screen, X, Y (spawn_tool 1-4).
;  OVERLAY (load_obj / load_obj2): 2 bytes, 0 end. 0xFF = next screen (+0xC0).
;          Byte0 bits 5-6 = 2-bit tile, bits 0-4 = run; bit 7 is in DE>>7 offset.
;  BLIT    (blit_list): 5 bytes, 0xFF end. flags, tile, count, dest word.
;          dest = packed pattern planes in the paged ROM: 8/16/24 bytes ×
;          count = 8 × (1 + ((flags&7)>>1)). Even/odd flags&7 pick the
;          unflipped / X-flipped expander. Tile bytes come from 0x8000.
;  MAP_RUN (unpack_map): 1 byte, 0 end. tile = bits 7-6 (0..3), count = bits 0-5
;          (1..63). Packed into E900 four 2-bit cells/byte; 768 tiles/screen.
;  STAMP   (sub_576dh): tile id; 0xFE,dx = next row; 0xFF end.
;  SATFX   (sat_fx): 5 bytes. from pal, to pal (16×GRB), delay. A=0..11.
;  VIC_RLE / VIC_COPY (sub_58dbh / vic_reload): 4 bytes, 0xFF end.
;          lo-nibble 0 = RLE dest,src; else COPY n, dest, src (l4e60h).
;          held_ptr[(0xE287)] 0=none, 1–6 tool.
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

    MACRO OVERLAY b0, b1
        db b0, b1
    ENDM

    MACRO OVERLAY_NEXT
        db 0ffh
    ENDM

    MACRO OVERLAY_END
        db 0
    ENDM

    MACRO BLIT flags, tile, n, dest
        db flags, tile, n
        dw dest
    ENDM

    MACRO BLIT_END
        db 0ffh
    ENDM

    MACRO MAP_RUN tile, count
        db (tile << 6) | count
    ENDM

    MACRO MAP_END
        db 0
    ENDM

    MACRO STAMP tile
        db tile
    ENDM

    MACRO STAMP_NEXT dx
        db 0feh, dx
    ENDM

    MACRO STAMP_END
        db 0ffh
    ENDM

    MACRO SATFX src, dst, delay
        dw src, dst
        db delay
    ENDM

    MACRO VIC_RLE dest, src
        dw dest, src
    ENDM

    MACRO VIC_COPY n, dest, src
        db (dest & 0f0h) | n
        db dest >> 8
        dw src
    ENDM

    MACRO VIC_END
        db 0ffh
    ENDM
