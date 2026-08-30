; bank 09 blit dest planes 0xB82B–0xBB8B (b7df_blit).

pat_b82b:                          ; 0xB82B  b7df_blit  1×8
	defb 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh

pat_b833:                          ; 0xB833  b7df_blit  1×8
	defb 0feh, 0feh, 0feh, 0feh, 0feh, 0feh, 0feh, 0ffh

pat_b83b:                          ; 0xB83B  b7df_blit  1×8
	defb 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 000h

pat_b843:                          ; 0xB843  b7df_blit  1×8
	defb 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03fh

pat_b84b:                          ; 0xB84B  b7df_blit  7×16
	defb 0fch, 013h, 0fch, 013h, 0fch, 013h, 0fch, 013h
	defb 0fch, 013h, 0fch, 013h, 0fch, 013h, 000h, 00fh
	defb 0ffh, 000h, 0e0h, 01fh, 0ffh, 000h, 0e0h, 01fh
	defb 0ffh, 000h, 0ffh, 000h, 0ffh, 000h, 000h, 000h
	defb 0ffh, 000h, 000h, 0ffh, 0ffh, 000h, 000h, 0ffh
	defb 0ffh, 000h, 0ffh, 000h, 0ffh, 000h, 000h, 000h
	defb 0ffh, 0ffh, 000h, 0ffh, 0ffh, 000h, 0ffh, 000h
	defb 0ffh, 000h, 0ffh, 000h, 0ffh, 000h, 0ffh, 000h
	defb 0ffh, 0ffh, 000h, 0ffh, 0fch, 013h, 0fch, 013h
	defb 0fch, 013h, 0fch, 013h, 0fch, 013h, 0fch, 013h
	defb 0ffh, 0ffh, 000h, 0ffh, 0ffh, 000h, 0ffh, 000h
	defb 0ffh, 000h, 0e0h, 01fh, 0ffh, 000h, 0e0h, 01fh
	defb 0ffh, 0ffh, 000h, 0ffh, 0ffh, 000h, 0ffh, 000h
	defb 0ffh, 000h, 000h, 0ffh, 0ffh, 000h, 000h, 0ffh

pat_b8bb:                          ; 0xB8BB  b7df_blit  5×16
	defb 0ffh, 0ffh, 080h, 0ffh, 0bfh, 0c0h, 0bfh, 0c0h
	defb 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h
	defb 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h
	defb 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h, 0bfh, 0c0h
	defb 03fh, 040h, 020h, 05fh, 03fh, 040h, 020h, 05fh
	defb 03fh, 040h, 020h, 05fh, 03fh, 040h, 020h, 05fh
	defb 03fh, 040h, 03fh, 040h, 03fh, 040h, 03fh, 040h
	defb 03fh, 040h, 03fh, 040h, 03fh, 040h, 01fh, 060h
	defb 000h, 080h, 000h, 080h, 080h, 000h, 080h, 000h
	defb 080h, 040h, 0c0h, 020h, 0e0h, 01fh, 0ffh, 000h

pat_b90b:                          ; 0xB90B  b7df_blit  2×8
	defb 01fh, 01fh, 01fh, 01fh, 01fh, 01fh, 01fh, 01fh
	defb 000h, 000h, 01fh, 01fh, 01fh, 01fh, 01fh, 01fh

pat_b91b:                          ; 0xB91B  b7df_blit  2×8
	defb 000h, 000h, 07fh, 07fh, 07fh, 07fh, 07fh, 07fh
	defb 07fh, 07fh, 07fh, 07fh, 07fh, 07fh, 07fh, 07fh

pat_b92b:                          ; 0xB92B  b7df_blit  37×16
	defb 080h, 080h, 000h, 080h, 00fh, 080h, 00fh, 080h
	defb 00fh, 080h, 00fh, 080h, 00fh, 080h, 00fh, 080h
	defb 00fh, 080h, 00fh, 080h, 00fh, 080h, 00fh, 080h
	defb 00fh, 080h, 00fh, 080h, 00fh, 080h, 00fh, 080h
	defb 00fh, 080h, 00fh, 080h, 00fh, 080h, 00fh, 080h
	defb 00fh, 080h, 00fh, 080h, 08fh, 080h, 00fh, 080h
	defb 003h, 0e0h, 003h, 0e0h, 003h, 0e0h, 003h, 0e0h
	defb 003h, 0e0h, 003h, 0e0h, 003h, 0e0h, 003h, 0e0h
	defb 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh
	defb 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh
	defb 00fh, 080h, 00fh, 0c0h, 00fh, 080h, 00fh, 000h
	defb 00fh, 000h, 07fh, 070h, 07fh, 000h, 07fh, 000h
	defb 0f2h, 017h, 0f2h, 017h, 0f2h, 017h, 0f2h, 017h
	defb 0f2h, 017h, 0f2h, 017h, 0f2h, 017h, 0f2h, 017h
	defb 090h, 0bfh, 090h, 0bfh, 090h, 0bfh, 090h, 0bfh
	defb 090h, 0bfh, 090h, 0bfh, 090h, 0bfh, 090h, 0bfh
	defb 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh
	defb 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh
	defb 007h, 0c0h, 007h, 0c0h, 007h, 0c0h, 007h, 0c0h
	defb 007h, 0c0h, 007h, 0c0h, 007h, 0c0h, 007h, 0c0h
	defb 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh
	defb 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh
	defb 001h, 0f0h, 001h, 0f0h, 001h, 0f0h, 001h, 0f0h
	defb 001h, 0f0h, 001h, 0f0h, 001h, 0f0h, 001h, 0f0h
	defb 003h, 0e0h, 003h, 0f0h, 003h, 0e0h, 003h, 000h
	defb 003h, 000h, 07fh, 07ch, 07fh, 000h, 07fh, 000h
	defb 01fh, 000h, 01fh, 080h, 01fh, 000h, 01fh, 000h
	defb 01fh, 000h, 07fh, 060h, 07fh, 000h, 07fh, 000h
	defb 007h, 0c0h, 007h, 0e0h, 007h, 0c0h, 007h, 000h
	defb 007h, 000h, 07fh, 078h, 07fh, 000h, 07fh, 000h
	defb 001h, 0f0h, 001h, 0f8h, 001h, 0f0h, 001h, 000h
	defb 001h, 000h, 07fh, 07eh, 07fh, 000h, 07fh, 000h
	defb 001h, 01fh, 010h, 03fh, 090h, 0bfh, 090h, 0bfh
	defb 090h, 0bfh, 090h, 0bfh, 090h, 0bfh, 090h, 0bfh
	defb 000h, 00fh, 008h, 01fh, 0c8h, 05fh, 0c8h, 05fh
	defb 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh
	defb 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh, 0c8h, 05fh
	defb 0c8h, 05fh, 0c8h, 05fh, 0c4h, 05fh, 0c0h, 05fh
	defb 0c0h, 05fh, 0c0h, 05fh, 0c0h, 04fh, 0c0h, 040h
	defb 0c0h, 040h, 0feh, 07eh, 0feh, 000h, 0feh, 000h
	defb 000h, 003h, 002h, 007h, 0f2h, 017h, 0f2h, 017h
	defb 0f2h, 017h, 0f2h, 017h, 0f2h, 017h, 0f2h, 017h
	defb 020h, 0e0h, 000h, 0e0h, 003h, 0e0h, 003h, 0e0h
	defb 003h, 0e0h, 003h, 0e0h, 003h, 0e0h, 003h, 0e0h
	defb 000h, 007h, 004h, 00fh, 0e4h, 02fh, 0e4h, 02fh
	defb 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh
	defb 040h, 0c0h, 000h, 0c0h, 007h, 0c0h, 007h, 0c0h
	defb 007h, 0c0h, 007h, 0c0h, 007h, 0c0h, 007h, 0c0h
	defb 000h, 001h, 001h, 003h, 0f9h, 00bh, 0f9h, 00bh
	defb 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh
	defb 010h, 0f0h, 000h, 0f0h, 001h, 0f0h, 001h, 0f0h
	defb 001h, 0f0h, 001h, 0f0h, 001h, 0f0h, 001h, 0f0h
	defb 0f2h, 017h, 0f2h, 017h, 0f2h, 017h, 0f2h, 017h
	defb 0f2h, 017h, 0f2h, 017h, 0f1h, 017h, 0f0h, 017h
	defb 0f0h, 017h, 0f0h, 017h, 0f0h, 013h, 0f0h, 010h
	defb 0f0h, 010h, 0feh, 01eh, 0feh, 000h, 0feh, 000h
	defb 003h, 0e0h, 003h, 0e0h, 003h, 0e0h, 003h, 0e0h
	defb 003h, 0e0h, 003h, 0e0h, 023h, 0e0h, 003h, 0e0h
	defb 090h, 0bfh, 090h, 0bfh, 090h, 0bfh, 090h, 0bfh
	defb 090h, 0bfh, 090h, 0bfh, 089h, 0bfh, 080h, 0bfh
	defb 080h, 0bfh, 080h, 0bfh, 080h, 09fh, 080h, 080h
	defb 080h, 080h, 0feh, 0feh, 0feh, 000h, 0feh, 000h
	defb 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh, 0e4h, 02fh
	defb 0e4h, 02fh, 0e4h, 02fh, 0e2h, 02fh, 0e0h, 02fh
	defb 0e0h, 02fh, 0e0h, 02fh, 0e0h, 027h, 0e0h, 020h
	defb 0e0h, 020h, 0feh, 03eh, 0feh, 000h, 0feh, 000h
	defb 007h, 0c0h, 007h, 0c0h, 007h, 0c0h, 007h, 0c0h
	defb 007h, 0c0h, 007h, 0c0h, 047h, 0c0h, 007h, 0c0h
	defb 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh, 0f9h, 00bh
	defb 0f9h, 00bh, 0f9h, 00bh, 0f8h, 00bh, 0f8h, 00bh
	defb 0f8h, 00bh, 0f8h, 00bh, 0f8h, 009h, 0f8h, 008h
	defb 0f8h, 008h, 0feh, 00eh, 0feh, 000h, 0feh, 000h
	defb 001h, 0f0h, 001h, 0f0h, 001h, 0f0h, 001h, 0f0h
	defb 001h, 0f0h, 001h, 0f0h, 091h, 0f0h, 001h, 0f0h

pat_bb7b:                          ; 0xBB7B  b7df_blit  1×16
	defb 07fh, 000h, 07fh, 000h, 07fh, 000h, 07fh, 000h
	defb 07fh, 040h, 07fh, 07fh, 03fh, 03fh, 000h, 000h

