# Play freeze (pickup / held-tool reload)

The picture and Vic stop for a beat (sometimes a long one) when Vic
picks up a tool — English players often say **sword**; the HUD / editor
name is **knife** (`E300` type 1). The same stall shows up on throw,
boomerang catch, finishing a shovel/pick, pause, and death. This is
stock ROM behaviour, not a disassembly mistake.

Play does not idle in a main loop. After boot the CPU sits on
`jr boot_halt` (`cart_boot`); all gameplay is `mode_frame` from **H.TIMI**.
Before that call the ISR sets `(0xE205)` and `ei`s, then only clears it
when `mode_frame` returns (`htimi_isr` @ 0x402E). A nested vblank that
arrives while that is still running skips `mode_frame` entirely: SAT is
not flipped, Vic does not tick, and the picture stays put. Sound can
keep going (the ISR still pages banks 04–06 for `sound_tick` unless
`(0xE206)` is set). That is why it feels like a freeze rather than a
crash.

## Pickup path

Walking onto an on-map tool: `probe_pickup` @ 0x9A14 → `pickup_tool` @
0x9A93.

`pickup_tool` copies the low nibble to `(0xE287)`, ORs `0xF0` into the
E300 slot, plays `sfx_19`, then in the same call:

1. `stones_undraw` — 16×16 HMMM restore for every on-screen type-5 stone
2. `tools_redraw` — scan `EE50`, 16×16 HMMM restore per tool (and
   `tool_id` turns `0xF0` into in-use `0x10`)
3. `stones_redraw` — stamp stones back on top

Each HMMM spins in `vdp_ce_wait` (VDP S#2 bit 0 / CE).

`play_tick` calls `vic_blit` *before* `probe_pickup`, so the held-sprite
reload is the **next** frame. `vic_blit` @ 0x5864 compares `(0xE287)` to
`(0xE297)` and, on change, calls `vic_pat_sync` @ 0x5925.

`vic_pat_sync` walks `held_ptr` @ 0x858B (bank 0E; index = held type
0–6). Knife is `held_1`: several Konami RLE blobs into VRAM via
`rle_vram` (`SETWRT` + `OUT`) plus `spr_copy` (BIOS `RDVRM` / `WRTVRM`
per 16×16 plane). Then two 8×1 `vdp_hmmm` copies of the current pose
(`vic_hmm` / `vic_hmm2`). All of that finishes before `play_frame`
returns, so `(0xE205)` stays set and nested vblanks cannot catch up.

Throw (`throw_done` clears `E287`), boomerang catch (`E287 ← 2`),
`dig_done`, pause (`vic_pause_rle`), and death (`vic_die_rle`) skip the
stone/tool HMMM burst but still hit `vic_pat` / the die/pause RLE.

Fan patches (KV22 / KV2G) replaced this with a faster pickup and made
**128 KiB VRAM** a requirement — they are caching decompressed Vic
planes in the extra 64 KiB rather than RLE-ing them on the grab.

## Harder hangs (if it never recovers)

The hitch above always completes on a healthy V9938/58. Two loops on
the same path can run forever:

- **`vdp_ce_wait` @ 0x4F2A** — CE stuck. `rle_vram` does not wait CE
  before `SETWRT`; CPU VRAM I/O while a HMMM is still busy is undefined
  on the VDP.
- **`e300_index` @ 0x925E** — `tools_pack` (from `tools_redraw`) scans
  `EE50` for this slot id with no `0x00` terminator check. Stock
  `afb1_tbl` tools are listed by `e300_list` at pyramid load, so a
  first knife pickup should not hit this. A spawned / editor slot that
  never made `EE50` would.

`tick_map_knife` (and the other E300 ticks) `DISPATCH_A` on
`(high nibble) − 1`. If `0xF0` is still in `ix+0` when the *next* frame
ticks (conversion in `tools_scan` never ran), index 14 jumps off the
five-word table.

## Effort to fix (not done)

This is a **gameplay patch**. It changes ROM bytes; `make verify` stays
on the original SHA-1 unless a second target exists (`make patch` / a
second `.sha1`). Do not fold a fix into the labelled source until that
split exists.

| Approach | What it buys | Effort | Risk |
|---|---|---|---|
| Bound `e300_index`; `vdp_ce_wait` before `rle_vram` | True hangs only; hitch unchanged | A few hours, if a few spare bytes exist | Need a hole or a small relocate |
| Pickup only undraws the grabbed 16×16 (plus overlapping stones) | Shorter `pickup_tool`; `vic_pat_sync` still stalls | ~½–1 day including playtest | Z-order vs remaining tools/stones |
| Slice RLE / HMMM across vblanks | Hitch becomes a lock-anim; no extra VRAM | ~4–6 days | New Vic/busy state; pause/death/room re-entry |
| Preload all seven `held_*` sets (and die/pause) into unused VRAM; pickup only switches dest / HMMM | The actual freeze; matches KV22’s 128 KiB requirement | **~3–5 days** of VDP layout + wiring, **~1 week** with playtest of all six tools, throw/catch, pause, death, room change | VRAM map in SCREEN 5; A16 page bits (`vdp_hmmm` A=5); MSX1-ish 64 KiB machines |

**Player-facing “pickup does not freeze”** is the preload (or a
frame-slice with a visible lock). The stone/tool scan trim is a cheap
partial. Hang hardening is independent and small.

The labelled source already names every call on this path
(`pickup_tool`, `vic_pat_sync`, `held_ptr`, `htimi_isr`). The work is
VDP budgeting and a patch build, not more reversing.
