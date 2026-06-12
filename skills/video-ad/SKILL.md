---
version: 0.1.0
name: video-ad
description: Orchestrate a short video ad from a brief — plan it, generate the clip(s), add voiceover and music, optionally lip-sync a presenter, then assemble and enhance the final cut. Layer 2 orchestrator built from the video and audio primitives, with a flows-run shortcut to the "Product ad spot" flow when it fits.
argument-hint: "<brief> [duration sec] [aspect ratio] [product/brand assets] [presenter image]"
allowed-tools:
  - video-plan
  - video-generate
  - audio-tts
  - audio-music-generate
  - video-speak
  - video-upscale
  - video-concatenate
  - images-generate
  - creations-upload
  - library-show
  - folders-list
  - flows-run
---

# video-ad

> Brief → a finished short video ad. Plan, shoot, voice, score, assemble.

## When to use

- Produce a short product/brand video ad (with or without narration, music, or a presenter).

Do **not** use this for:

- A still banner set — use `banner-flow`. A property listing — use `listing-visuals`.
- A single raw clip with no assembly — call `video-generate` directly.

## Inputs

| Arg | Required | Notes |
|-----|----------|-------|
| `brief` | **yes** | The ad concept/message. |
| `duration` | no | Seconds. **>15 → the plan splits into clips** that get concatenated. |
| `aspectRatio` | no | e.g. `9:16` for stories, `16:9` for web. |
| `assets` | no | Product/brand library ids (`library-show`) or photos (`creations-upload`) to feature. |
| `presenter` | no | A face image for a talking-head, or an existing clip to lip-sync. |
| `script` | no | Voiceover text for `audio-tts`. |
| `project` | no | Project folder via `folders-list`. |

## Steps

1. **Plan first.** Run `video-plan` with the brief, duration, aspect, and any reference ids. Take its recommended model `slug`, prompt draft, and clip breakdown. Resolve its open questions with the user.
2. **Hybrid check.** If the "Product ad spot" flow fits (product image → ready 15s commercial), offer `flows-run` as a shortcut and skip to step 7 with its output.
3. **Prep references.** `library-show` / `creations-upload` for product/brand assets; `images-generate` for any keyframes the plan calls for.
4. **Generate clip(s).** `video-generate` per the plan (one clip, or each planned shot for >15s). Pass keyframes/references as creation `identifier`s, never `webUrl`.
5. **Voice & score.** `audio-tts` for narration (from `script`); `audio-music-generate` for a bed. If a presenter speaks, `video-speak` (image+audio talking head, or video+audio lip-sync).
6. **Assemble.** For multi-clip ads, `video-concatenate` the clips in order (2–10).
7. **Finish.** `video-upscale` the final cut if higher quality/resolution is needed. File in `project`.
8. **Preview & return** the final video creation `identifier`.

## Output

One final-cut video creation `identifier` (plus intermediate clip ids if useful). Identifiers only, never `webUrl`.

## Chaining

- **Composes:** `video-plan`, `video-generate`, `audio-tts`, `audio-music-generate`, `video-speak`, `video-upscale`, `video-concatenate`, `images-generate`, `creations-upload`, `library-show`, `folders-list`, `flows-run`.
- **Wrapped by:** a Layer 3 (brand) skill supplying brand assets, voice, and ad-spec defaults.

## Notes

- **Always `video-plan` first** (unless the user says "just generate") — it picks the model and decides single- vs multi-clip.
- `video-concatenate` keeps each clip's own audio; mux a separate music bed in an editor if needed.
- Thread creation `identifier`s between steps; never pass a `webUrl`.
- Keep this file under 300 lines.
