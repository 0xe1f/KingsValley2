# KingsValley2 (MSXDAW) disassembly build.
#
#   make            assemble KingsValley2.asm -> KingsValley2.rom
#   make verify     SHA-1 check against KingsValley2.sha1
#   make gfx        PNG contact sheets (palettes / copy_tiles / minimaps)
#   make banks      extract leftover 8 KiB bins / drop migrated ones
#   make clean      remove build output
#
# Prerequisite: tools/sjasmplus (built from source, gitignored)
# Workbench (tools/workbench) is required for banks / regen — not for
# assemble or verify. All 16 banks are source (no leftover INCBINs).

SRC      := KingsValley2.asm
OUT      := KingsValley2.rom
SHA1FILE := KingsValley2.sha1
ASM      ?= tools/sjasmplus --longptr
SHA1SUM  ?= $(shell command -v sha1sum 2>/dev/null || echo "shasum -a 1")

.PHONY: all verify clean banks gfx

all: $(SRC)
	$(ASM) $(SRC)

verify: all
	@$(SHA1SUM) -c $(SHA1FILE)

clean:
	rm -f $(OUT)

banks:
	tools/workbench/msx/split-rom.sh

gfx: all
	python3 tools/gfxdump.py
