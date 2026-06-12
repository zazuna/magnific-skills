---
version: 0.1.0
name: audio-tts
description: Generate a spoken voiceover from text with one voice or two speakers (ElevenLabs or Google). Use for narration or dialogue audio. To put that voice on a face use video-speak, and for music use audio-music-generate.
argument-hint: "<text> <voiceId | two speakers> [model]"
allowed-tools:
  - mcp__claude_ai_Magnific__audio_tts
  - mcp__claude_ai_Magnific__audio_voices_show
  - mcp__claude_ai_Magnific__creations_show
---

# audio-tts

> Text → spoken audio. One narrator or a two-speaker exchange.

## When to use

- Produce a voiceover/narration track.
- Generate a two-speaker dialogue (same provider).
- Make the audio that `video-speak` will lip-sync.

Do **not** use this to:

- Generate music — that's `audio-music-generate`.
- Make a talking video — that's `video-speak` (this feeds it).

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `text` | **yes** | `text` | Max 40k chars. Eleven v3 best ≤3k; turbo ≤10k. `(pause 1.5s)` markup works **only** on turbo. |
| `voiceId` | one of | `voiceId` | From the voices catalog. Required **unless** you pass `speakers`. |
| `speakers` | one of | `speakers[]` | Two speakers (same provider), each `{ voiceId, speakerName? }`. |
| `model` | no | `model` | `eleven_turbo_v2_5`, `eleven_v3` (default), `gemini_v2_5_pro`, `gemini_v3_1_flash_tts`. |
| `speed` | no | `speed` | 0.7–1.2 (default 1.0). |
| `stability` / `similarityBoost` / `useSpeakerBoost` | no | — | **ElevenLabs only** (0–1 / 0–1 / bool). |
| `systemInstruction` / `temperature` | no | — | **Gemini only** (≤10k / 0–2). |

## Steps

1. **Resolve a voice.** No `voiceId`? Call `audio_voices_show` (UI picker) — or `audio_voices_list` for headless lookup — to get one. For dialogue, gather two `voiceId`s of the **same provider**.
2. **Pick the model** to match the voice provider; respect that model's text-length sweet spot.
3. **Set provider-appropriate params only** (ElevenLabs vs. Gemini knobs don't cross over).
4. **Call** `audio_tts`.
5. **Preview.** UI → `creations_show`; text-only → `webUrl`.
6. **Return** the audio creation `identifier`.

## Output

An audio creation `identifier`. Feed it to `video-speak`, or deliver as a standalone voiceover.

## Chaining

- **Feeds into:** `video-speak` (`audioUrl`), `video-generate` (Seedance audio reference), delivery.
- **Consumes from:** `audio_voices_show` / `audio_voices_list` (the `voiceId`).

## Notes

- `voiceId` **or** `speakers` — single voice needs `voiceId`; dialogue needs `speakers` (same provider).
- `(pause 1.5s)` only works on the turbo model.
- Keep this file under 300 lines.
