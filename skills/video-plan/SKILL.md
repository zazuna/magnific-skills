---
version: 0.1.0
name: video-plan
description: Plan a video before generating. Returns a brief, recommended model, prompt draft, and clip breakdown, and splits anything over 15 seconds into clips. Call this first for any non-trivial video. For a complete ad deliverable use video-ad.
argument-hint: "<raw video idea> [aspect ratio] [duration sec] [style]"
allowed-tools:
  - mcp__claude_ai_Magnific__video_plan
---

# video-plan

> The pre-production step. Turns a raw idea into a concrete brief + model choice + prompt draft, and decides whether it's one clip or many.

## When to use

- **Call this first for essentially any video request** — it resolves model choice, surfaces missing details, and prevents wasted generations.
- Skip only when the user explicitly says "just generate" / "one-shot".

Do **not** use this to:

- Actually create the video — that's `video-generate`.
- Plan an image — there's no planning step for images.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `prompt` | **yes** | `prompt` | The raw user idea — pass **verbatim**, don't pre-polish it. |
| `aspectRatio` | no | `aspectRatioHint` | e.g. `16:9`, `9:16`. |
| `duration` | no | `durationHint` | Seconds. **>15 triggers a multi-clip plan.** |
| `style` | no | `styleHint` | e.g. `cinematic`, `anime`. |
| `references` | no | `referenceIdentifiers` | Creation identifiers already attached as references. |

## Steps

1. **Pass the idea through unedited** as `prompt`, plus any hints you have.
2. **Call** `video_plan`.
3. **Read the returned markdown plan:** brief, open questions, characters to prepare, recommended model `slug`, and a prompt draft. For >15s it splits into clips with `video_concatenate` instructions.
4. **Resolve open questions** with the user before generating.
5. **Return** the plan — especially the recommended `slug` and prompt draft — to feed `video-generate`.

## Output

A markdown production plan. The pieces that matter downstream: the **recommended model `slug`**, the **prompt draft**, the **clip breakdown** (if multi-clip), and any **characters** to prepare via `library-show`/`creations-upload`.

## Chaining

- **Feeds into:** `video-generate` (use the recommended slug + prompt draft), and for >15s the planned clips → `video-concatenate`.
- **Consumes from:** `creations-upload` / `library-show` (reference identifiers to hand in as `referenceIdentifiers`).

## Notes

- This returns **text**, not a creation — there's nothing to `creations_show`.
- Don't polish the user's idea before passing it; the planner does that.
- Keep this file under 300 lines.
