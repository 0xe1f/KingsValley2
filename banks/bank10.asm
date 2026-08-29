; ===========================================================================
;  bank 10 — map pointer tables + packed streams, CPU 0x6000 (PHASE in master).
;  Triplet 10/11/12 via page_banks_10_11_12. Not code. Three parallel 60-word
;  tables indexed by (0xE242)-1 after paging this triplet (unpack_map /
;  load_obj / load_obj2):
;
;    map_ptr @ 0x6000 — 60 words, [0] == 0x6168 (first stream in this bank).
;      entries 33.. continue into bank 11 (0x80B0) and bank 12 (0xA121).
;    obj_ptr @ 0x6078 — packed map-bit overlay (not actors).
;    obj2_ptr @ 0x60F0 — secret-entrance records -> 0xE7C0 (editor tool 7).
;    streams from 0x6168.
;
;  .blocks map: banks/bank10.blocks
; ===========================================================================

; (org set by PHASE in KingsValley2.asm)
map_ptr:
	defw 06168h, 061e0h, 0624ah, 062fbh, 063a9h, 06476h, 06520h, 06608h
	defw 0674eh, 067ceh, 06861h, 068e5h, 069e3h, 06b06h, 06cbch, 06df6h
	defw 06f11h, 07039h, 07173h, 071e1h, 072d0h, 07366h, 074cah, 0778ah
	defw 078f7h, 07957h, 07ab8h, 07be2h, 07d27h, 07d97h, 07e3bh, 07eabh
	defw 07fb4h, 080b0h, 0825dh, 08407h, 08585h, 086f5h, 08878h, 088eeh
	defw 08ad4h, 08b8ch, 08c98h, 08ea8h, 0913eh, 0923bh, 093eeh, 09587h
	defw 096c9h, 09727h, 098dah, 0996eh, 09a7dh, 09ba8h, 09c8ah, 09d74h
	defw 09ddfh, 09e8ah, 09f81h, 0a121h
obj_ptr:
	defw 0a363h, 0a36ah, 0a36bh, 0a377h, 0a395h, 0a39dh, 0a3a3h, 0a3b7h
	defw 0a3dah, 0a3ddh, 0a3e6h, 0a3f3h, 0a3f4h, 0a40dh, 0a440h, 0a459h
	defw 0a465h, 0a46ah, 0a48bh, 0a492h, 0a4d8h, 0a4e7h, 0a506h, 0a546h
	defw 0a574h, 0a597h, 0a5ach, 0a5d5h, 0a5f6h, 0a5fbh, 0a62dh, 0a64ch
	defw 0a66dh, 0a688h, 0a6cch, 0a6d4h, 0a702h, 0a71ah, 0a734h, 0a739h
	defw 0a7a8h, 0a7b5h, 0a7bfh, 0a7dbh, 0a815h, 0a826h, 0a868h, 0a87bh
	defw 0a88ch, 0a8b1h, 0a8f7h, 0a8fah, 0a8fdh, 0a90eh, 0a916h, 0a932h
	defw 0a922h, 0a92ah, 0a933h, 0a9a0h
obj2_ptr:
	defw 0a3deh, 0a3deh, 0a3deh, 0a3deh, 0a3deh, 0a3deh, 0a3deh, 0a3deh
	defw 0a3dfh, 0a3e2h, 0a4b2h, 0a4b0h, 0a4b2h, 0a4b2h, 0a4b2h, 0a4b3h
	defw 0a4bch, 0a4d5h, 0a4d7h, 0a4d7h, 0a613h, 0a614h, 0a617h, 0a618h
	defw 0a61dh, 0a61dh, 0a61eh, 0a625h, 0a62ah, 0a62ch, 0a779h, 0a77ah
	defw 0a77bh, 0a77ch, 0a77dh, 0a795h, 0a796h, 0a797h, 0a798h, 0a7a7h
	defw 0a8c1h, 0a8c4h, 0a8f6h, 0a8f6h, 0a8c7h, 0a8e9h, 0a8f6h, 0a8efh
	defw 0a8f6h, 0a8f6h, 0a9d4h, 0a9d9h, 0a9e9h, 0a9eeh, 0a9f1h, 0a9f7h
	defw 0aa06h, 0aa14h, 0a97dh, 0aa1eh
	INCBIN "banks/bank10.tbl.bin", 0x168
