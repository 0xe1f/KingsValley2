; ===========================================================================
;  Packed map-object records (banks/data lists -> E600 / E700 / E300).
;
;  actor   (load_actors): 4 bytes, 0 end. type=hi4, screen=lo4, Y, X,
;          byte3 = (height << 3) | lo3 (lo3 -> ix+7 bit 1 + lid frame).
;  gem     (load_gems):   3 bytes, 0 end. type=hi4 (always 1), screen=lo4, X, Y.
;          Last gem Y + terminator overlap a75d_tbl[0] (0x00A0).
;  tool    (load_map_tools): 3 bytes, 0xFF end. screen=hi4, type=lo4, Y, X.
;  link    (load_links):     2 bytes, 0xFF end. screen-from, screen-to (8x6 map).
;  delayed (0xB7CD -> E2C0): 4 bytes, 0 end. type, screen, Y, X.
;          Type 1–4 = names_enemies (Slouman / Flouman / Pyoncy / Rock
;          Roll). Same numeric ids as knife / boomerang / shovel / pick
;          but play spawns E500 enemies (enemy_sat / E840), not E300
;          floor tools. load_delayed: type|0x80, timer 0x14, screen, Y, X.
;          First spawn uses 0x14; enemy_done re-arms bit 7, respawn 0x30.
;          stamp_delayed: types 1–2 only, 3×2 case_under at (X, Y−8).
;          Type 4 Rock Roll: no case; play SAT boulder D0/D8 cc 07/49
;          (SAT Y = packed Y−1). delay_sat is editor preview at (X, Y).
;  overlay (load_obj / load_obj2): 2 bytes, 0 end. 0xFF = next screen (+0xC0).
;          Offset = record>>7. Byte0 bits 5-6 = starting nibble in that packed
;          byte, bits 0-4 = run (djnz; 0 would be 256). Each step writes cell 1
;          twice (2-wide) and advances one row.
;  blit    (blit_list): 5 bytes, 0xFF end. flags, tile, count, dest word.
;          dest = packed pattern planes in the paged ROM: 8/16/24 bytes ×
;          count = 8 × (1 + ((flags&7)>>1)). Even/odd flags&7 pick the
;          unflipped / X-flipped expander. Tile bytes come from 0x8000.
;  map run (unpack_map): 1 byte, 0 end. tile = bits 7-6 (0..3), count = bits 0-5
;          (1..63). Packed into E900 four 2-bit cells/byte; 768 tiles/screen.
;  stamp   (stamp): tile id; 0xFE,dx = next row; 0xFF end.
;
;  sat_fx  (sat_fx): 5 bytes. from pal, to pal (16×GRB), delay. A=0..11.
;  vic_pat (vic_pat / vic_reload): 4 bytes, 0xFF end.
;          lo-nibble 0 = RLE dest,src words; else copy n in lo-nibble,
;          dest hi/lo with n overwriting dest lo-nibble, then src word.
;          held_ptr[(0xE287)] 0=none, 1–6 tool.
; ===========================================================================
