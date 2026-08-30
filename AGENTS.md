# KingsValley2

This is an [MSXDAW](https://github.com/) game repo (MSX Disassembly Workbench).

- Workbench (tools, generic skills): `tools/workbench` (git submodule of `~/code/msxdaw`).
- Generic skills live in `tools/workbench/skills/` and are linked into this repo's `.cursor/skills/` (`tools/workbench/bin/install-skills`). After pulling workbench, re-run it so new skills are linked and removed ones are dropped. Never `~/.cursor/skills`.
- Game-only skills live in `.agents/skills/` (`KingsValley2-*` / cart-specific). Do not copy DAW skills here.

**Placement:** if a helper would apply to a second MSX/Konami cart, put it in msxdaw. If it names this ROM’s stems, RAM, banks, or dumpers, keep it in this repo.

**End state.** Every ROM byte is labelled `.asm`. Leftover `INCBIN` is scaffold
only (`msx-code-data`).

Window files: `konami-msx-disasm`. This cart: `banks_0`, `banks_123`,
`banks_456`, `banks_789`, `banks_abc`, `banks_d`, `banks_ef` (matching
`.blocks`). Later windows wrap `MODULE` so labels do not collide with
banks 1–3. Say **bank**, not segment.
