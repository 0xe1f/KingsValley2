# KingsValley2 — progress

Scaffolded by MSXDAW (`konami-scc`, 16 banks). ROM is gitignored;
`make verify` matches `KingsValley2.sha1`.

- Probe: [`docs/probe.md`](probe.md).
- Bank 0 folded to [`banks/bank00.asm`](../banks/bank00.asm) (AB header,
  `cart_init` / `cart_boot` / `htimi_isr`). Leftover banks 1–15 are still
  `INCBIN`.
- Notes: [`docs/game-notes.md`](game-notes.md).

Do not invent paging-window files until this cart's mapper schedule is known.
