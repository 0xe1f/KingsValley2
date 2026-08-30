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
	TEXT_AT 028h, 010h
	TEXT "floor1"
	TEXT_NEXT 028h, 020h
	TEXT "floor2"
	TEXT_NEXT 028h, 030h
	TEXT "ladder"
	TEXT_NEXT 028h, 040h
	TEXT "player"
	TEXT_NEXT 028h, 050h
	TEXT "enemy"
	TEXT_NEXT 028h, 060h
	TEXT "trap"
	TEXT_NEXT 028h, 070h
	TEXT "tool weapon"
	TEXT_NEXT 028h, 080h
	TEXT "soul stone"
	TEXT_NEXT 028h, 090h
	TEXT "exit door"
	TEXT_NEXT 028h, 0a0h
	TEXT "save"
	TEXT_NEXT 028h, 0b0h
	TEXT "end"
	TEXT_END
bcbb_tbl:
	; print_stream ptrs: enemies, doors/terrain, tools. Caller reads max
	; cursor at (hl), inc hl, print_stream. A 4th word from bcbb_tbl is
	; names_enemies's max/D (03h, A0h) = 0xA003.
	defw names_enemies, names_terrain, names_tools
print_names:                      ; 0xBCC1-0xBECF
names_enemies:                    ; max=3; Slouman, Flouman, Pyoncy, Rock Roll
	defb 3
	TEXT_AT 0a0h, 010h
	TEXT "slouman"
	TEXT_NEXT 0a0h, 020h
	TEXT "flouman"
	TEXT_NEXT 0a0h, 030h
	TEXT "pyoncy"
	TEXT_NEXT 0a0h, 040h
	TEXT "rock roll"
	TEXT_END
names_terrain:                    ; max=7; door1/2 lr/rl, wall, floor, stone, ladder
	defb 7
	TEXT_AT 0a0h, 010h
	TEXT "door1 lr"
	TEXT_NEXT 0a0h, 020h
	TEXT "door1 rl"
	TEXT_NEXT 0a0h, 030h
	TEXT "door2 lr"
	TEXT_NEXT 0a0h, 040h
	TEXT "door2 rl"
	TEXT_NEXT 0a0h, 050h
	TEXT "wall"
	TEXT_NEXT 0a0h, 060h
	TEXT "floor"
	TEXT_NEXT 0a0h, 070h
	TEXT "stone"
	TEXT_NEXT 0a0h, 080h
	TEXT "ladder"
	TEXT_END
names_tools:                      ; max=5; knife, boomerang, shovel (HUD scoop), pick, hammer, drill
	defb 5
	TEXT_AT 0a0h, 010h
	TEXT "knife"
	TEXT_NEXT 0a0h, 020h
	TEXT "boomerang"
	TEXT_NEXT 0a0h, 030h
	TEXT "scoop"                   ; manual: shovel
	TEXT_NEXT 0a0h, 040h
	TEXT "pick"
	TEXT_NEXT 0a0h, 050h
	TEXT "hammer"
	TEXT_NEXT 0a0h, 060h
	TEXT "drill"
	TEXT_END
str_load_data:                    ; 0xBD6D  io_ask
	TEXT_AT 050h, 048h
	TEXT "load data }"
	TEXT_NEXT 080h, 058h
	TEXT "yes"
	TEXT_NEXT 080h, 068h
	TEXT "no"
	TEXT_END
str_file_hdr:                     ; 0xBD86  "| file name |"
	TEXT_AT 048h, 010h
	TEXT "| file name |"
	TEXT_NEXT 048h, 0a8h
	TEXT "next ||  m key"
	TEXT_NEXT 048h, 0b8h
	TEXT "load || ret key"
	TEXT_END
str_load_mode:                    ; 0xBDB9  io_mode
	TEXT_AT 048h, 040h
	TEXT "| load mode |"
	TEXT_NEXT 060h, 050h
	TEXT "tape load"
	TEXT_END
str_disk_load:                    ; 0xBDD5  glyphs only; DE preloaded
	TEXT "disk load"
	TEXT_END
str_sram_load:                    ; 0xBDDF
	TEXT "sram load"
	TEXT_END
str_input_name:                   ; 0xBDE9
	TEXT_AT 040h, 040h
	TEXT "input file name"
	TEXT_NEXT 060h, 060h
	TEXT "{{{{{{{{"
	TEXT_END
str_loading:                      ; 0xBE06
	TEXT_AT 058h, 048h
	TEXT "now loading"
	TEXT_END
	TEXT_AT 048h, 040h
	TEXT "| save mode |"
	TEXT_NEXT 060h, 050h
	TEXT "tape save"
	TEXT_END
	TEXT "disk save"
	TEXT_END
	TEXT "sram save"
	TEXT_END
	TEXT_AT 070h, 050h
	TEXT "file1"
	TEXT_END
	TEXT_AT 070h, 060h
	TEXT "file2"
	TEXT_END
	TEXT_AT 070h, 070h
	TEXT "file3"
	TEXT_END
	TEXT_AT 050h, 040h
	TEXT "file select"
	TEXT_END
	TEXT_AT 060h, 080h
	TEXT "save error"
	TEXT_END
	TEXT_AT 060h, 050h
	TEXT "edit end"
	TEXT_NEXT 050h, 060h
	TEXT "ok }  y or n"
	TEXT_END
	TEXT_AT 040h, 060h
	TEXT "input password"
	TEXT_NEXT 060h, 078h
	TEXT "{{{{{{{{"
	TEXT_END
	TEXT_AT 040h, 088h
	TEXT "wrong password"
	TEXT_END
	TEXT_AT 040h, 088h
	TEXT "right password"
	TEXT_END
	INCLUDE "banks/data/hud_tiles.asm"
	ds 10, 0ffh
