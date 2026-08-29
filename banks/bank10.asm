; ===========================================================================
;  bank 10 — map pointer tables + packed streams, CPU 0x6000 (PHASE in master).
;  Triplet 10/11/12 via page_banks_10_11_12. Not code. Three parallel 60-word
;  tables indexed by (0xE242)-1 after paging this triplet (sub_43cbh /
;  sub_4416h / sub_440ch):
;
;    map_ptr @ 0x6000 — 60 words, [0] == 0x6168 (first stream in this bank).
;      entries 33.. continue into bank 11 (0x80B0) and bank 12 (0xA121).
;    obj_ptr @ 0x6078 — 60 words into bank 12 (0xA363..).
;    obj2_ptr @ 0x60F0 — 60 words into bank 12 (0xA3DE..); (0xEFC3)=1 variant.
;    streams from 0x6168.
;
;  .blocks map: banks/bank10.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
	INCBIN "banks/bank10.tbl.bin"
