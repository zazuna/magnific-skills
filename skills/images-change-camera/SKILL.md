---
version: 0.1.0
name: images-change-camera
description: Re-render an existing image from a new camera angle by rotating, tilting, or zooming around the subject. Use for a true viewpoint change. For a flat crop of the existing pixels use images-crop.
argument-hint: "<creation id> [rotate 0-360] [vertical -30..90] [closeup 0-10]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_change_camera
  - mcp__claude_ai_Magnific__creations_show
---

# images-change-camera

> Existing creation → same subject, new camera angle. Orbit/tilt/zoom, not a crop.

## When to use

- You want a different viewpoint of the same subject (rotate around it, raise/lower the angle, push in/out).

Do **not** use this to:

- Reframe by **cropping** the existing pixels — that's `images-crop`.
- Change the subject or scene — that's `images-generate`.
- Reframe something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `rotate` | no | `rotate` | 0–360°, default 45. Horizontal orbit around the subject. |
| `vertical` | no | `vertical` | −30 to 90°, default 0. Camera height/tilt. |
| `closeup` | no | `closeup` | 0–10, default 5. How tight the framing is. |
| `folder` | no | `folderReference` | Optional target folder. |

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Set the angle** with `rotate` / `vertical` / `closeup` within their ranges (defaults 45 / 0 / 5).
3. **Call** `images_change_camera`.
4. **Preview.** UI → `creations_show`; text-only → `webUrl`.
5. **Return** the new creation `identifier`.

## Output

A new creation `identifier` showing the subject from the new camera. Original unchanged.

## Chaining

- **Feeds into:** `images-upscale`, `images-crop`, `images-resize`, `images-variations`, final delivery.
- **Consumes from:** `images-generate`, `creations-upload`.

## Notes

- This is a true **camera move** (it re-renders the viewpoint), not a 2D crop — for a plain reframe of existing pixels use `images-crop`.
- `vertical` is asymmetric: −30 (slightly below) to 90 (top-down).
- Keep this file under 300 lines.
