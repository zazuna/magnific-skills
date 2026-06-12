---
version: 0.1.0
name: images-upscale
description: Enlarge and enhance an existing image 2x or 4x with AI for higher resolution and detail. Use for print or hi-res quality. For an exact pixel size use images-resize, and for an aspect-ratio change use images-crop.
argument-hint: "<creation identifier> [scale 2x|4x]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_upscale
  - mcp__claude_ai_Magnific__creations_show
---

# images-upscale

> Existing creation → larger, sharper creation. AI enlargement, not a plain stretch.

## When to use

- You need a higher-resolution version of an image you already have in Magnific (print, large-format banner, hi-DPI).
- A Layer 2 pipeline produced a base image at generation resolution and needs it enlarged for final delivery.

Do **not** use this to:

- Hit an **exact pixel size** — use `images-resize` (this tool only does fixed 2x/4x multipliers).
- Change the **aspect ratio** / reframe — use `images-crop`.
- Enlarge something that isn't a creation yet — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | Must be a creation `identifier`. A local file/URL is not one — upload via `creations-upload` first. |
| `scale` | no | `scale` | `2x` (default) or `4x`. Only these two multipliers exist. |
| `folder` | no | `folderReference` | Optional target folder from `folders_list`. |

## Steps

1. **Validate.** Confirm you have a creation `identifier`. If the user gave a local file/URL, stop and run `creations-upload` first.
2. **Pick scale.** Default `2x`. Use `4x` only when the source is small or the output must be very large — `4x` is slower and costs more.
3. **Call** `images_upscale` with `{ creationIdentifier, scale? }`.
4. **Preview.** Follow the response `instruction`. UI client → call `creations_show` with the returned identifier; text-only → share `webUrl`.
5. **Return** the new creation `identifier`.

## Output

A new creation `identifier` for the upscaled image (the original is unchanged). Hand back the `identifier` for any further chaining.

## Chaining

- **Feeds into:** final delivery, or `images-resize` / `images-crop` if an exact size/aspect is needed after enlarging.
- **Consumes from:** `images-generate`, `images-relight`, `images-remove-background`, `creations-upload` — anything that yields a creation.

## Notes

- `4x` ≠ "twice as good as 2x" — it's 4× the linear dimensions (16× the pixels). Use deliberately.
- Keep this file under 300 lines.
