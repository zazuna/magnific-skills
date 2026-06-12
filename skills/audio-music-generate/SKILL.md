---
version: 0.1.0
name: audio-music-generate
description: Generate music or a soundtrack from a text description (Google Lyria or ElevenLabs), with or without vocals. Use for a background music bed. For spoken narration use audio-tts.
argument-hint: "<music description> [model] [durationSeconds]"
allowed-tools:
  - mcp__claude_ai_Magnific__audio_music_generate
  - mcp__claude_ai_Magnific__creations_show
---

# audio-music-generate

> Text → music track. Background bed or soundtrack for a video/ad.

## When to use

- Create a background music bed for a video ad or banner reel.
- Generate a standalone soundtrack from a genre/mood/instrument description.

Do **not** use this to:

- Generate speech/narration — that's `audio-tts`.
- Add a bed during concatenation — `video-concatenate` keeps each clip's own audio; mux a bed in your editor.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `prompt` | **yes** | `prompt` | 10–2000 chars. Describe genre, mood, instruments, tempo. |
| `model` | no | `model` | `google-lyria` (default), `google-lyria-3`, `google-lyria-3-pro`, `elevenlabs-music-generation`. |
| `durationSeconds` | conditional | `durationSeconds` | **Required for `elevenlabs-music-generation`.** Effective only for `google-lyria-3-pro` (30–180) and ElevenLabs (10–300). Ignored by fixed-duration models. |
| `instrumental` | no | `instrumental` | Omit vocals. **Only** for `google-lyria-3` / `google-lyria-3-pro`. |
| `folder` | no | `folderReference` | Optional target folder. |

### Duration by model (important)

- `google-lyria`, `google-lyria-3` → **fixed 30s** (`durationSeconds` ignored).
- `google-lyria-3-pro` → **30–180s**.
- `elevenlabs-music-generation` → **10–300s** (and `durationSeconds` is **required**).

## Steps

1. **Write a descriptive `prompt`** (≥10 chars) — genre, mood, instruments, tempo.
2. **Pick a model for the length you need** (see the table) and set `durationSeconds` accordingly; it's required for ElevenLabs.
3. **Set `instrumental`** only on the Lyria-3 models if you want no vocals.
4. **Call** `audio_music_generate`.
5. **Preview.** UI → `creations_show`; text-only → `webUrl`.
6. **Return** the audio creation `identifier`.

## Output

A music audio creation `identifier`. Use as a bed (muxed in an editor) or deliver standalone.

## Chaining

- **Feeds into:** delivery, or your video editor as a background bed.
- **Consumes from:** nothing — prompt-driven.

## Notes

- Want a non-30s track? You **must** use `google-lyria-3-pro` or `elevenlabs-music-generation`; the base Lyria models are fixed at 30s.
- `instrumental` is ignored outside the Lyria-3 models.
- Keep this file under 300 lines.
