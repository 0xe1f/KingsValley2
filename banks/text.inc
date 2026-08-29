; ===========================================================================
;  print_stream glyph encoding (bank 0 @ 0x51D0).
;
;    ' '          -> 00h
;    '0'..'?'     -> ch + A0h   digits, ':' = ©, '<'/'=' extra HUD
;    other ASCII  -> ch | 80h   a-z; '|' quote/box; '{'/'}' underline/prompt
;
;  Stream controls stay as TEXT_AT / TEXT_NEXT / TEXT_END (or raw defb):
;    first two bytes = D,E; 0xFE = next D,E; 0xFF = end.
;  TEXT takes one quoted string (no commas — sjasmplus splits on comma).
; ===========================================================================

    MACRO CHAR ch
        IF ch = ' '
            db 0
        ELSEIF ch >= '0' && ch <= '?'
            db ch + 0A0h
        ELSE
            db ch | 080h
        ENDIF
    ENDM

    MACRO TEXT_AT x, y
        db x, y
    ENDM

    MACRO TEXT_NEXT x, y
        db 0feh, x, y
    ENDM

    MACRO TEXT_END
        db 0ffh
    ENDM

    LUA ALLPASS
    function kv2_char(c)
        if c == 32 then
            return 0
        elseif c >= 48 and c <= 63 then
            return c + 0xA0
        else
            return c | 0x80
        end
    end
    ENDLUA

    MACRO TEXT str
        LUA ALLPASS
            local s = sj.get_define("str", true)
            if type(s) ~= "string" then
                sj.error("TEXT needs a quoted string")
            else
                if #s >= 2 and ((s:sub(1,1) == '"' and s:sub(-1) == '"') or (s:sub(1,1) == "'" and s:sub(-1) == "'")) then
                    s = s:sub(2, -2)
                end
                local parts = { "db" }
                for i = 1, #s do
                    parts[#parts+1] = string.format(" 0x%02X", kv2_char(s:byte(i)))
                    if i < #s then
                        parts[#parts] = parts[#parts] .. ","
                    end
                end
                _pc(table.concat(parts))
            end
        ENDLUA
    ENDM
