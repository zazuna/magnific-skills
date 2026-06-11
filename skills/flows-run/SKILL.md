---
version: 0.1.0
name: flows-run
description: Find, inspect, and run a Magnific Flow (a packaged multi-step pipeline) — e.g. "Audience-driven ads", "Marketplace listing visuals", "Room decorator" — then return the output creation identifiers. The fastest path to a finished result when a community or saved flow already does the job.
argument-hint: "<flow name or identifier> [inputs per the flow's flows_get spec]"
allowed-tools:
  - mcp__claude_ai_Magnific__flows_list
  - mcp__claude_ai_Magnific__flows_show
  - mcp__claude_ai_Magnific__flows_get
  - mcp__claude_ai_Magnific__flows_run
  - mcp__claude_ai_Magnific__flows_wait
  - mcp__claude_ai_Magnific__creations_show
---

# flows-run

> A Flow is a published, packaged pipeline with defined inputs/outputs. This skill discovers one, reads its input spec, runs it, and waits for the result.

## When to use

- A pre-built flow already does what the user wants (ad variants, listing visuals, mockups, room redecoration, product video).
- You want a finished, multi-step result without wiring Layer 1 skills yourself.

Do **not** use this for:

- A single primitive op (generate, upscale, relight) — call that Layer 1 skill directly.
- A custom multi-step pipeline that no flow covers — that's a Layer 2 orchestrator built from Layer 1 skills.

## Inputs

| Arg | Required | Notes |
|-----|----------|-------|
| `flow` | **yes** | A flow `identifier`, or a name to find via `flows_list`. |
| `inputs` | **yes** | `{ inputId: value }` — the **exact** input ids come from `flows_get`. Don't guess them. |

## Steps

1. **Discover.** If you don't have an identifier, call `flows_list` (`ownership: mine` for own/saved/shared, `public` for community; `query` to search). For a visual pick, `flows_show`. Resolve to one flow `identifier`.
2. **Inspect — do not skip.** Call `flows_get(identifier)`. It returns each input's `inputId`, `kind`, `howToProvide`, and any `options`/`presetOptions`. This is the only reliable source of the input ids and shapes.
3. **Build `inputs`.** Map values to `{ inputId: value }`. Creation inputs take a creation `identifier` (from `creations-upload` or `creations_list`); voice inputs come from `audio_voices_show`. Respect each input's `kind`/`options`.
4. **Run.** Call `flows_run({ identifier, inputs })` → returns a `workflowRunIdentifier`.
5. **Wait.** Call `flows_wait({ workflowRunIdentifier, timeoutSeconds≤25 })`. If it returns `poll_after_seconds`, it's still running — wait that long and call again. Terminal response has one entry per output creation with a real `identifier`.
6. **Preview.** UI client → `creations_show` with all output identifiers; text-only → share `webUrl`s.
7. **Return** the output creation `identifier`(s).

## Output

The flow's output creation `identifier`(s). Hand them back for further chaining or delivery.

## Chaining

- **Feeds into:** any image/video skill (`images-upscale`, `images-resize`, …) on an output, or final delivery.
- **Consumes from:** `creations-upload` / `library-show` (to supply creation/library inputs the flow requires), `flows_get` (the input contract).

## Notes

- **Always `flows_get` before `flows_run`.** Input ids are flow-specific; guessing them fails the run.
- `flows_wait` is a long-poll (≤25s budget) — loop on `poll_after_seconds` until terminal; flows can take minutes.
- Keep this file under 300 lines.
