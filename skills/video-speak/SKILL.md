---
version: 0.1.0
name: video-speak
description: Make a character speak by combining a face with audio (image plus audio for a talking head, or video plus audio for lip-sync). Use to put a voice onto a face. To create the voice track first use audio-tts.
argument-hint: "<audio: creation id/URL> <image OR video: creation id/URL> [voiceId] [mode]"
allowed-tools:
  - mcp__claude_ai_Magnific__video_speak
  - mcp__claude_ai_Magnific__creations_show
---

# video-speak

> Audio + a face → a speaking video. Image source = talking head; video source = lip sync.

## When to use

- Turn a still portrait into a talking-head video (Veed Fabric).
- Lip-sync an existing video to an audio track (Lipsync 2.0).

Do **not** use this to:

- Generate the base video — that's `video-generate`.
- Produce the audio — that's `audio-tts` (its output feeds here).

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `audio` | **yes** | `audioUrl` | Asset URL or a creation `identifier` (e.g. from `audio-tts`). |
| `image` | one of | `imageUrl` | Talking-head source. **Mutually exclusive with `video`.** Asset URL or creation `identifier`. |
| `video` | one of | `videoUrl` | Lip-sync source. **Mutually exclusive with `image`.** Asset URL or creation `identifier`. |
| `mode` | no | `mode` | Omit for auto (image → `veed-fabric-1.0`, video → `lipsync-2.0`). Others: `latentsync`, `omnihuman`, `veed-fabric-1.0-fast`, `react-1`. |
| `resolution` | no | `resolution` | **Veed modes only**, `480p`/`720p` (default `720p`). |
| `prompt` | no | `prompt` | Script/prompt; support is model-dependent. |
| `voiceId` | no | `voiceId` | Voice ID from `audio_voices_list`; links the voice to the creation. |

`folderReference` files results in a project.

## Steps

1. **Provide audio** (`audioUrl`) plus **exactly one** of `imageUrl` / `videoUrl` — never both.
2. **Let `mode` auto-resolve** unless you need a specific model. Set `resolution` only for Veed modes.
3. **Call** `video_speak`.
4. **Preview.** UI → `creations_show`; text-only → `webUrl`.
5. **Return** the creation `identifier`.

## Output

A speaking-video creation `identifier`. Original assets unchanged.

## Chaining

- **Feeds into:** `video-upscale`, `video-concatenate`, or delivery.
- **Consumes from:** `audio-tts` (the voice track), `images-generate` (a portrait) or `video-generate` (a clip), `creations-upload`.

## Notes

- `image` and `video` are mutually exclusive — pick the one matching your source.
- Pass creation `identifier`s or asset URLs, never `webUrl`.
- Keep this file under 300 lines.
