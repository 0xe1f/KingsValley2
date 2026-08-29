# KingsValley2

This is an [MSXDAW](https://github.com/) game repo (MSX Disassembly Workbench).

- Workbench (tools, generic skills): `tools/workbench` (git submodule of `~/code/msxdaw`).
- Generic skills live in `tools/workbench/skills/` and are linked into this repo's `.cursor/skills/` (`tools/workbench/bin/install-skills`). Never `~/.cursor/skills`.
- Game-only skills live in `.agents/skills/` (`KingsValley2-*` / cart-specific). Do not copy DAW skills here.

**Placement:** if a helper would apply to a second MSX/Konami cart, put it in msxdaw. If it names this ROM’s stems, RAM, banks, or dumpers, keep it in this repo.

Default source split is **one file per 8 KiB mapper bank** (`banks/bank00.asm`). Do not invent paging-window files until this cart’s mapper schedule is known. Say **bank**, not segment.
