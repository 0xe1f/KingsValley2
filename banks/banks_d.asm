; ===========================================================================
;  bank d — tables / text streams / tiles, CPU 0xA000 (PHASE in master).
;  A000-only via page_bank_d (6000/8000 keep the previous triplet). Not code.
;  Packed lists live in banks/data/ (macros in objects.inc).
;  Regen: tools/workbench/msx/regen-bank.sh 13 0xA000 banks/banks_d.blocks
; ===========================================================================

	INCLUDE "banks/data/gems.asm"
	INCLUDE "banks/data/actors.asm"
	INCLUDE "banks/data/screens.asm"
	INCLUDE "banks/data/links.asm"
afb1_tbl:                         ; per-pyramid map tools -> 0xE300 (load_map_tools; 60 words, level-1)
	defw tools_b029, tools_b033, tools_b03d, tools_b056, tools_b060, tools_b073, tools_b080, tools_b099
	defw tools_b0b5, tools_b0c2, tools_b0de, tools_b0e5, tools_b0ec, tools_b0fc, tools_b10f, tools_b13d
	defw tools_b14d, tools_b166, tools_b17f, tools_b195, tools_b1b1, tools_b1c1, tools_b1da, tools_b1f6
	defw tools_b212, tools_b21f, tools_b23b, tools_b257, tools_b273, tools_b27a, tools_b293, tools_b29d
	defw tools_b2c8, tools_b2f3, tools_b321, tools_b32e, tools_b362, tools_b384, tools_b3a0, tools_b3a7
	defw tools_b3c0, tools_b3cd, tools_b3e0, tools_b3f6, tools_b41b, tools_b437, tools_b45f, tools_b48d
	defw tools_b4a6, tools_b4b9, tools_b4d5, tools_b4eb, tools_b4f5, tools_b51d, tools_b539, tools_b543
	defw tools_b550, tools_b560, tools_b57f, tools_b598
	INCLUDE "banks/data/tools.asm"
	INCLUDE "banks/data/pickups.asm"
	INCLUDE "banks/data/doors.asm"
bb38_tbl:
	defw map_bb3c, map_bb9c
	INCLUDE "banks/data/minimap.asm"
print_legend:                     ; print_stream 0xBC54  editor legend
	defb 028h, 010h         ; D,E
	TEXT "floor1"
	defb 0feh, 028h, 020h   ; next D,E
	TEXT "floor2"
	defb 0feh, 028h, 030h   ; next D,E
	TEXT "ladder"
	defb 0feh, 028h, 040h   ; next D,E
	TEXT "player"
	defb 0feh, 028h, 050h   ; next D,E
	TEXT "enemy"
	defb 0feh, 028h, 060h   ; next D,E
	TEXT "trap"
	defb 0feh, 028h, 070h   ; next D,E
	TEXT "tool weapon"
	defb 0feh, 028h, 080h   ; next D,E
	TEXT "soul stone"
	defb 0feh, 028h, 090h   ; next D,E
	TEXT "exit door"
	defb 0feh, 028h, 0a0h   ; next D,E
	TEXT "save"
	defb 0feh, 028h, 0b0h   ; next D,E
	TEXT "end"
	defb 0ffh               ; end
bcbb_tbl:
	; print_stream ptrs: enemies, doors/terrain, tools. Caller reads max
	; cursor at (hl), inc hl, print_stream. A 4th word from bcbb_tbl is
	; names_enemies's max/D (03h, A0h) = 0xA003.
	defw names_enemies, names_terrain, names_tools
print_names:                      ; 0xBCC1-0xBECF
names_enemies:                    ; max=3; E261 0–3 → E2C0 type 1–4 (E500 in play)
	defb 3
	defb 0a0h, 010h         ; D,E
	TEXT "slouman"
	defb 0feh, 0a0h, 020h   ; next D,E
	TEXT "flouman"
	defb 0feh, 0a0h, 030h   ; next D,E
	TEXT "pyoncy"
	defb 0feh, 0a0h, 040h   ; next D,E
	TEXT "rock roll"
	defb 0ffh               ; end
names_terrain:                    ; max=7; door1/2 lr/rl, wall, floor, stone, ladder
	defb 7
	defb 0a0h, 010h         ; D,E
	TEXT "door1 lr"
	defb 0feh, 0a0h, 020h   ; next D,E
	TEXT "door1 rl"
	defb 0feh, 0a0h, 030h   ; next D,E
	TEXT "door2 lr"
	defb 0feh, 0a0h, 040h   ; next D,E
	TEXT "door2 rl"
	defb 0feh, 0a0h, 050h   ; next D,E
	TEXT "wall"
	defb 0feh, 0a0h, 060h   ; next D,E
	TEXT "floor"
	defb 0feh, 0a0h, 070h   ; next D,E
	TEXT "stone"
	defb 0feh, 0a0h, 080h   ; next D,E
	TEXT "ladder"
	defb 0ffh               ; end
names_tools:                      ; max=5; knife, boomerang, shovel (HUD scoop), pick, hammer, drill
	defb 5
	defb 0a0h, 010h         ; D,E
	TEXT "knife"
	defb 0feh, 0a0h, 020h   ; next D,E
	TEXT "boomerang"
	defb 0feh, 0a0h, 030h   ; next D,E
	TEXT "scoop"                   ; manual: shovel
	defb 0feh, 0a0h, 040h   ; next D,E
	TEXT "pick"
	defb 0feh, 0a0h, 050h   ; next D,E
	TEXT "hammer"
	defb 0feh, 0a0h, 060h   ; next D,E
	TEXT "drill"
	defb 0ffh               ; end
str_load_data:                    ; 0xBD6D  io_ask
	defb 050h, 048h         ; D,E
	TEXT "load data }"
	defb 0feh, 080h, 058h   ; next D,E
	TEXT "yes"
	defb 0feh, 080h, 068h   ; next D,E
	TEXT "no"
	defb 0ffh               ; end
str_file_hdr:                     ; 0xBD86  "| file name |"
	defb 048h, 010h         ; D,E
	TEXT "| file name |"
	defb 0feh, 048h, 0a8h   ; next D,E
	TEXT "next ||  m key"
	defb 0feh, 048h, 0b8h   ; next D,E
	TEXT "load || ret key"
	defb 0ffh               ; end
str_load_mode:                    ; 0xBDB9  io_mode
	defb 048h, 040h         ; D,E
	TEXT "| load mode |"
	defb 0feh, 060h, 050h   ; next D,E
	TEXT "tape load"
	defb 0ffh               ; end
str_disk_load:                    ; 0xBDD5  glyphs only; DE preloaded
	TEXT "disk load"
	defb 0ffh               ; end
str_sram_load:                    ; 0xBDDF
	TEXT "sram load"
	defb 0ffh               ; end
str_input_name:                   ; 0xBDE9
	defb 040h, 040h         ; D,E
	TEXT "input file name"
	defb 0feh, 060h, 060h   ; next D,E
	TEXT "{{{{{{{{"
	defb 0ffh               ; end
str_loading:                      ; 0xBE06
	defb 058h, 048h         ; D,E
	TEXT "now loading"
	defb 0ffh               ; end
	defb 048h, 040h         ; D,E
	TEXT "| save mode |"
	defb 0feh, 060h, 050h   ; next D,E
	TEXT "tape save"
	defb 0ffh               ; end
	TEXT "disk save"
	defb 0ffh               ; end
	TEXT "sram save"
	defb 0ffh               ; end
	defb 070h, 050h         ; D,E
	TEXT "file1"
	defb 0ffh               ; end
	defb 070h, 060h         ; D,E
	TEXT "file2"
	defb 0ffh               ; end
	defb 070h, 070h         ; D,E
	TEXT "file3"
	defb 0ffh               ; end
	defb 050h, 040h         ; D,E
	TEXT "file select"
	defb 0ffh               ; end
	defb 060h, 080h         ; D,E
	TEXT "save error"
	defb 0ffh               ; end
	defb 060h, 050h         ; D,E
	TEXT "edit end"
	defb 0feh, 050h, 060h   ; next D,E
	TEXT "ok }  y or n"
	defb 0ffh               ; end
	defb 040h, 060h         ; D,E
	TEXT "input password"
	defb 0feh, 060h, 078h   ; next D,E
	TEXT "{{{{{{{{"
	defb 0ffh               ; end
	defb 040h, 088h         ; D,E
	TEXT "wrong password"
	defb 0ffh               ; end
	defb 040h, 088h         ; D,E
	TEXT "right password"
	defb 0ffh               ; end
	INCLUDE "banks/data/hud_tiles.asm"
	ds 10, 0ffh
