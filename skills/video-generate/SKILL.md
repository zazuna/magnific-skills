---
version: 0.1.0
name: video-generate
description: Generate video from a prompt and/or image keyframes and references via Magnific — text-to-video, image-to-video, and multi-shot clips. Returns creation identifiers. Run video-plan first unless the user says "just generate".
argument-hint: "<prompt> [model slug] [duration sec] [start/end keyframe creation ids]"
allowed-tools:
  - mcp__claude_ai_Magnific__video_generate
  - mcp__claude_ai_Magnific__video_models_list
  - mcp__claude_ai_Magnific__creations_show
---

# video-generate

> Prompt and/or images → video clip(s). The core video primitive.

## When to use

- Create a video from a text prompt, image keyframes, or references.
- Render the clips a `video-plan` laid out.

Do **not** use this to:

- Plan/brief a video — run `video-plan` first (it picks the model and splits long videos).
- Add speech/lipsync — that's `video-speak`. Enlarge/clean up — `video-upscale`. Join clips — `video-concatenate`.

## Inputs

The tool takes `video.clips[]` (one or more clips). Per clip, the fields you'll use most:

| Field | Notes |
|-------|-------|
| `prompt` | The shot description. Check the model's `maxLength`. Exclusive with `multi_prompt`. |
| `slug` | Model id copied **verbatim** from `video_models_list` (e.g. `bytedance-seedance-pro-2.0`). Omit for auto-select. |
| `duration` | Seconds. **Required when `slug` is set.** |
| `aspectRatio` | Allowed values are per-model. |
| `keyframes.start` / `.end` | `{ type: "image", url }` where `url` is an asset URL or a creation `identifier` — **never `webUrl`**. |
| `references[]` | `{ type, url }`; types per model: `image, video, character, product, style, color, effect, audio`. |
| `multi_prompt` | Only when the model is multishot; up to 6 shots; replaces `prompt`. |
| `resolution`, `negativePrompt`, `cameraMotion`, `withSoundEffects` | Only when the chosen model supports them — check the catalog. |

`folderReference` (top-level) files results in a project.

## Steps

1. **Plan first** (unless "just generate"): use `video-plan`'s recommended `slug` + prompt draft.
2. **Confirm model limits.** Call `video_models_list` to get the model's `slug`, max prompt length, allowed `aspectRatio`/`resolution`, multishot/sound support. Copy the `slug` verbatim.
3. **Build clips.** Set `prompt` (or `multi_prompt`), `duration` (required with `slug`), and any keyframes/references. For every image/video reference use a creation `identifier` or asset URL, **never `webUrl`**.
4. **Call** `video_generate({ video: { clips: [...] }, folderReference? })`.
5. **Preview.** UI client → call `creations_show` once with **all** returned identifiers; text-only → share `webUrl`s.
6. **Return** the creation `identifier`(s).

## Output

One or more video creation `identifier`s. Hand them back for `video-speak`, `video-upscale`, `video-concatenate`, or delivery.

## Chaining

- **Feeds into:** `video-speak`, `video-upscale`, `video-concatenate`.
- **Consumes from:** `video-plan` (slug + prompt), `images-generate` / `creations-upload` (keyframes), `library-show` (character/product references).

## Notes

- **`webUrl` never goes in a keyframe/reference** — use the creation `identifier` or an asset URL.
- `duration` is mandatory whenever you pin a `slug`.
- Keep this file under 300 lines.
