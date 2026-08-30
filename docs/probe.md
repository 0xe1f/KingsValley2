# Probe

ROM: `/Users/akop/code/KingsValley2/KingsValley2.rom`

- size: 131072 bytes (128 KiB)
- sha1: `5ec8811254dc762c6852289a08acf22954404f0d`
- 8 KiB banks: 16
- MSX `AB` header at bank 00; init=0x40a3
- bytes at CPU 0x7FFD-0x7FFF (file 0x3FFD): 1821f3 (Konami RC BCD + 0xAA often ends a 16K page)
- `ld (nn),a` hits at mapper-select addresses:
  - `0x7000` x8  (konami-scc page 6000-7FFF / bank select)
  - `0x8000` x11  (konami4 page 8000-9FFF / bank select)
  - `0x9000` x19  (konami-scc page 8000-9FFF / bank select (3F enables SCC))
  - `0xb000` x10  (konami-scc page A000-BFFF / bank select)
- mapper guess: **konami-scc** (SCC-style hits=37, Konami4-style hits=11)
- SCC enable sequence `ld a,3Fh / ld (9000h),a`: yes (file offset 0x8024)
