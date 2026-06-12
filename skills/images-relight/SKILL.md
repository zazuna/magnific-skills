---
version: 0.1.0
name: images-relight
description: Relight an existing image with one to four directional lights to change mood, direction, or color. Use to change lighting only, not the subject (images-generate) or skin detail (images-skin-enhancer).
argument-hint: "<creation identifier> <1-4 lights: azimuth + elevation [+ intensity/type/color]> [resolution 1k|2k]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_relight
  - mcp__claude_ai_Magnific__creations_show
---

# images-relight

> Existing creation → same subject, new lighting. Place 1–4 virtual lights by angle.

## When to use

- A product photo or portrait needs different lighting (mood, direction, color) without changing the subject.
- A banner background and product were lit differently and need to be harmonized.

Do **not** use this to:

- Change what's *in* the image — that's `images-generate`.
- Remove or replace the background — `images-remove-background` / `images-generate`.
- Relight something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `lights` | **yes** | `lights[]` | 1–4 lights. Each light's shape is below. |
| `numImages` | no | `numImages` | 1 (default) or 2 variations. |
| `resolution` | no | `resolution` | `1k` or `2k` (default `2k`). |
| `folder` | no | `folderReference` | Optional target folder from `folders_list`. |

### Light shape (each of the 1–4)

| Field | Required | Values | Notes |
|-------|----------|--------|-------|
| `azimuth` | **yes** | `-135, -90, -45, 0, 45, 90, 135, 180` | Horizontal angle (degrees). `0` = front, `180` = behind. |
| `elevation` | **yes** | `-90, -45, 0, 45, 90` | Vertical angle. `90` = top-down, `-90` = from below. |
| `intensity` | no | `1`–`10` (default `5`) | Brightness of this light. |
| `type` | no | `neutral` (default) or `gel` | `gel` = colored light. |
| `color` | no | hex, default `#ffffff` | **Only used when `type: gel`.** |

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Design the lights.** Translate the user's intent into 1–4 lights. Every light **must** have `azimuth` and `elevation` from the allowed enums — do not invent intermediate angles. Add `intensity`/`type`/`color` only as needed; `color` only with `type: gel`.
3. **Call** `images_relight` with `{ creationIdentifier, lights, numImages?, resolution? }`.
4. **Preview.** Follow the response `instruction`. UI → `creations_show`; text-only → `webUrl`.
5. **Return** the new creation `identifier`(s).

## Output

One or two new creation `identifier`s (per `numImages`). Original is unchanged.

## Chaining

- **Feeds into:** `images-upscale`, `images-resize`, `images-crop`, or final delivery.
- **Consumes from:** `images-generate`, `creations-upload`, `images-remove-background`.

## Notes

- Angles are **discrete enums**, not free degrees — pick the nearest allowed value.
- More lights ≠ better; 1–2 well-placed lights usually beat 4.
- Keep this file under 300 lines.
