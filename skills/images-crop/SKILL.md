---
version: 0.1.0
name: images-crop
description: Center-crop an existing Magnific creation to a target aspect ratio — for reframing one image into square, landscape, portrait, or wide formats. Returns a new creation identifier.
argument-hint: "<creation identifier> <aspect ratio: 1:1|16:9|9:16|4:3|3:4|3:2|2:3|21:9>"
allowed-tools:
  - mcp__claude_ai_Magnific__images_crop
  - mcp__claude_ai_Magnific__creations_show
---

# images-crop

> Existing creation → same image, new aspect ratio by center-crop. No pixels invented.

## When to use

- You need one source image reframed into a different **aspect ratio** (square for social, 16:9 for web, 9:16 for stories).
- A multi-format banner set needs the same hero image cropped to each placement's ratio.

Do **not** use this to:

- Hit an **exact pixel size** — use `images-resize`.
- **Enlarge / add detail** — use `images-upscale`.
- Reframe by camera angle (not crop) — use `images-change-camera`.
- Crop something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `aspectRatio` | **yes** | `aspectRatio` | One of **8** ratios: `1:1`, `16:9`, `9:16`, `4:3`, `3:4`, `3:2`, `2:3`, `21:9`. |
| `folder` | no | `folderReference` | Optional target folder from `folders_list`. |

> Note: this set is **smaller than `images-generate`'s** (no `2:1`, `1:2`, `5:4`, `4:5`). If you need one of those, generate at that ratio rather than crop.

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Pick a ratio** from the 8 allowed values — do not pass a ratio outside this list.
3. **Mind the crop.** It **center-crops**: content at the edges outside the new ratio is discarded. If the subject is off-center, crop may clip it — consider regenerating instead.
4. **Call** `images_crop` with `{ creationIdentifier, aspectRatio }`.
5. **Preview.** Follow the response `instruction`. UI → `creations_show`; text-only → `webUrl`.
6. **Return** the new creation `identifier`.

## Output

A new creation `identifier` at the target aspect ratio. Original unchanged.

## Chaining

- **Feeds into:** `images-resize` (to an exact px size after the ratio is right), `images-upscale`, final delivery.
- **Consumes from:** `images-generate`, `images-relight`, `images-remove-background`, `images-upscale`, `creations-upload`.

## Notes

- For a multi-format set, crop the **same** hero creation once per ratio.
- Keep this file under 300 lines.
