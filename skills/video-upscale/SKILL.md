---
version: 0.1.0
name: video-upscale
description: Upscale and enhance an existing video via Topaz or Magnific for higher resolution and smoother frames. Use for final video quality. To create the video use video-generate.
argument-hint: "<creation id or video URL> <mode: topaz|magnific|magnific_precision>"
allowed-tools:
  - mcp__claude_ai_Magnific__video_upscale
  - mcp__claude_ai_Magnific__video_upscale_models_list
  - mcp__claude_ai_Magnific__creations_show
---

# video-upscale

> Existing video → larger, cleaner video. Two engines (Topaz / Magnific) with different knobs.

## When to use

- A generated or uploaded video needs higher resolution, sharper detail, or smoother frame rate for final delivery.

Do **not** use this to:

- Generate a video — that's `video-generate`.
- Join clips — `video-concatenate`. Add speech — `video-speak`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `mode` | **yes** | `mode` | `topaz`, `magnific`, or `magnific_precision`. Decides which other params apply. |
| `creation` | one of | `creationIdentifier` | A completed owned video. Required without `videoUrl`. |
| `videoUrl` | one of | `videoUrl` | A Freepik video URL. Required without `creationIdentifier`. |
| `folder` | no | `folderReference` | Optional target folder. |

**Mode-specific params (set only those for your mode — confirm via `video_upscale_models_list`):**

- **Topaz** (all required): `enhancementModel` (proteus/artemis/nyx/…), `focus` 0–1, `sharpen` 0–1, `targetFps` 0–60, `upscaleFactor` 1–8, `frameInterpolation` (apollo/chronos).
- **Magnific / Precision:** `targetResolution` (width 640–3840, required), plus optional `creativity` 0–100, `flavor` vivid/natural, `magnificResolution` 720p/1k/2k/4k, `sharpen` 0–100, `smartGrain` 0–100, `fpsBoost`, `strength` (precision), `premiumQuality`/`turbo`/`preview`.

## Steps

1. **Provide the source:** exactly one of `creationIdentifier` / `videoUrl`.
2. **Pick `mode`**, then call `video_upscale_models_list` to confirm the **required** params for that mode (Topaz requires several; Magnific requires `targetResolution`).
3. **Set only the params for your mode** — mixing Topaz and Magnific fields is invalid.
4. **Call** `video_upscale`.
5. **Preview.** UI → `creations_show`; text-only → `webUrl`.
6. **Return** the new creation `identifier`.

## Output

A new, enhanced video creation `identifier`. Original unchanged.

## Chaining

- **Feeds into:** `video-concatenate`, delivery.
- **Consumes from:** `video-generate`, `video-speak`, `creations-upload`.

## Notes

- Topaz vs. Magnific params are **not interchangeable** — `mode` dictates the valid set.
- Always confirm required params via `video_upscale_models_list`; they differ a lot by mode.
- Keep this file under 300 lines.
