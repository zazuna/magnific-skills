---
version: 0.1.0
name: video-concatenate
description: Join 2 to 10 finished video clips into one MP4 in playback order. Use to assemble a multi-clip video. To create the clips use video-generate.
argument-hint: "<2-10 video creation ids in playback order> [name]"
allowed-tools:
  - mcp__claude_ai_Magnific__video_concatenate
  - mcp__claude_ai_Magnific__creations_show
---

# video-concatenate

> Several finished clips → one MP4, in the order you give. The assembly step for long videos.

## When to use

- A `video-plan` split a >15s video into clips you've now generated, and they need stitching into one file.
- You have multiple finished clips to deliver as a single video.

Do **not** use this to:

- Generate or extend a clip — that's `video-generate`.
- Add a background music bed — concatenate keeps **each clip's own audio**; there is no external audio track here.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `clips` | **yes** | `creationIdentifiers` | **2–10** completed video creation `identifier`s, **in playback order**. |
| `name` | no | `name` | Label for the joined video in the media viewer. |
| `folder` | no | `folderReference` | Optional target folder. |

## Steps

1. **Confirm clips are complete.** All identifiers must be finished video creations — a still-rendering clip can't be concatenated.
2. **Order them** exactly as they should play (the array order is the playback order).
3. **Call** `video_concatenate({ creationIdentifiers, name? })`. It returns a queued creation.
4. **Wait if needed**, then **preview.** UI → `creations_show`; text-only → `webUrl`.
5. **Return** the joined creation `identifier`.

## Output

A single MP4 creation `identifier`. Each source clip keeps its own audio; no external bed is added.

## Chaining

- **Feeds into:** `video-upscale` (enhance the final cut), delivery.
- **Consumes from:** `video-generate`, `video-speak` (the clips), `video-plan` (the clip order/plan).

## Notes

- **2–10 clips only.** Fewer than 2 has nothing to join; more than 10 isn't allowed — split into stages.
- Array order **is** playback order — double-check before calling.
- Keep this file under 300 lines.
