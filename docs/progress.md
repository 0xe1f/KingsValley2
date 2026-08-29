# KingsValley2 — progress

Scaffolded by MSXDAW (`konami-scc`, 16 banks). ROM is gitignored;
`make verify` matches `KingsValley2.sha1`.

- Probe: [`docs/probe.md`](probe.md).
- Mapper schedule from `page_triplet` is in [`docs/game-notes.md`](game-notes.md);
  `workbench.cfg` `bank_org` and master `PHASE` match it.
- Banks 0–15 are source (no leftover `INCBIN`).
- `DISPATCH_A` inline word tables in banks 0–3 are marked (`.blocks` + `defw`).
- Game Master option table at 0x4010 is data (`gm_opt`).
- Generic split/graduation workflow: workbench skill `msx-code-data`.

## Next

1. Name `l54a0h` / `l51d0h` / `l4f1ch` once a second cart confirms the
   packed-list / text-blit grammars.

Do not invent paging-window files; one file per 8 KiB bank. Banks that
share a CPU window use `MODULE bankNN` so z80dasm labels do not collide.
