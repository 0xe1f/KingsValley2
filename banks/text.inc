; ===========================================================================
;  print_stream glyph encoding (bank 00 @ 0x51D0).
;
;    ' '          -> 00h
;    '0'..'?'     -> ch + A0h   digits, ':' = ©, '<'/'=' extra HUD
;    other ASCII  -> ch | 80h   a-z; '|' quote/box; '{'/'}' underline/prompt
;
;  Stream controls are raw bytes (not macros):
;    first two bytes = D,E; 0xFE = next D,E; 0xFF = end.
;  TEXT / TEXT4 take one quoted string (no commas — sjasmplus splits on comma).
;  TEXT4 is the ending / world-map font: source is displayed ASCII, stored as
;  ch-4 (space and digits unchanged). '.' is the `{` glyph; '|' is 0x7F.
; ===========================================================================

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
    function kv2_end_store(c)
        if c == 46 then
            c = 123
        elseif c == 124 then
            c = 127
        end
        if c == 32 or (c >= 48 and c <= 57) then
            return c
        end
        return c - 4
    end
    function kv2_text_emit(raw, xform)
        if type(raw) ~= "string" then
            sj.error("TEXT needs a quoted string")
            return
        end
        local s = raw
        if #s >= 2 and ((s:sub(1,1) == '"' and s:sub(-1) == '"') or (s:sub(1,1) == "'" and s:sub(-1) == "'")) then
            s = s:sub(2, -2)
        end
        local parts = { "db" }
        for i = 1, #s do
            local c = s:byte(i)
            if xform then
                c = xform(c)
            end
            parts[#parts+1] = string.format(" 0x%02X", kv2_char(c))
            if i < #s then
                parts[#parts] = parts[#parts] .. ","
            end
        end
        _pc(table.concat(parts))
    end
    ENDLUA

    MACRO TEXT str
        LUA ALLPASS
            kv2_text_emit(sj.get_define("str", true), nil)
        ENDLUA
    ENDM

    MACRO TEXT4 str
        LUA ALLPASS
            kv2_text_emit(sj.get_define("str", true), kv2_end_store)
        ENDLUA
    ENDM
