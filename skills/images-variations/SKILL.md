---
version: 0.1.0
name: images-variations
description: Generate a grid of variations of an existing Magnific creation — by camera angle, demographics, expression, age, storyboard frames, or a custom prompt. Returns new creation identifiers for the grid tiles.
argument-hint: "<creation identifier> [mode: angles|demographics|expressions|age|storyboard|custom] [grid RxC ≤9]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_variations
  - mcp__claude_ai_Magnific__creations_show
---

# images-variations

> Existing creation → a grid of alternatives along one axis (angle, demographic, expression, age, story, or custom).

## When to use

- You want several alternatives of one image quickly (e.g. a product from many angles, or a model across demographics).
- A storyboard or A/B set needs a coherent grid derived from a single source.

Do **not** use this to:

- Make **one** re-prompted image — use `images-generate`.
- Reframe a single image's camera precisely — use `images-change-camera`.
- Vary something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | Source creation `identifier`; upload local files/URLs first. |
| `mode` | no | `variationMode` | `angles` (default), `demographics`, `expressions`, `age`, `storyboard`, `custom`. |
| `gridRows` | no | `gridRows` | 1–4, default 3. **rows × cols ≤ 9.** |
| `gridCols` | no | `gridCols` | 1–4, default 3. **rows × cols ≤ 9.** |
| `aspectRatio` | no | `aspectRatio` | `1:1` (default), `21:9`, `16:9`, `9:16`, `4:3`, `4:5`, `5:4`, `3:4`, `3:2`, `2:3`. |
| `resolution` | no | `resolution` | `2k` or `4k` (default `4k`). |
| `prompt` | conditional | `prompt` | **Required for `custom`**; also used by `storyboard`. |
| `selectedAngles` | no | `selectedAngles` | `angles` mode — up to 9 angle labels, ideally one per tile. |
| `selectedEthnicities` | no | `selectedEthnicities` | `demographics` mode — up to 9 labels. |
| `selectedGenders` | no | `selectedGenders` | `demographics` mode — `male`/`female`, up to 9. |

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Pick the mode**, then supply only that mode's extras: `custom` **requires** `prompt`; `storyboard` uses `prompt`; `angles`/`demographics` take their `selected*` lists. Don't send a mode's lists to a different mode.
3. **Size the grid.** Default 3×3. Each side is 1–4 and `gridRows × gridCols ≤ 9` — larger is rejected.
4. **Call** `images_variations` with the mapped fields.
5. **Preview.** Follow the response `instruction`. UI → `creations_show` with **all** returned tile identifiers; text-only → share `webUrl`s.
6. **Return** the tile creation `identifier`s.

## Output

Multiple creation `identifier`s — one per grid tile. Hand all of them back for chaining or selection.

## Chaining

- **Feeds into:** `images-upscale`, `images-crop`, `images-resize` on a chosen tile; final delivery.
- **Consumes from:** `images-generate`, `creations-upload`.

## Notes

- `custom` without a `prompt` will fail — always include one.
- Two limits apply together: each side ≤ 4 **and** the product ≤ 9. So `3×3`, `2×4`, `4×2` are fine; `4×4` (16) and `2×5` (side > 4) are not.
- Keep this file under 300 lines.
