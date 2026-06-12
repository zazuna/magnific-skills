---
version: 0.1.0
name: images-resize
description: Resize an existing image to exact pixel dimensions without AI, for hitting a precise banner or ad-slot size. Use for exact pixels. For AI enlargement use images-upscale, and for aspect-ratio reframing use images-crop.
argument-hint: "<creation identifier> <width px> <height px>"
allowed-tools:
  - mcp__claude_ai_Magnific__images_resize
  - mcp__claude_ai_Magnific__creations_show
---

# images-resize

> Existing creation → exact W×H in pixels. Mechanical resize, no AI invention.

## When to use

- You need an image at a **specific pixel size** (e.g. a 1200×628 ad slot).
- A pipeline must hit a platform's exact banner dimensions for final delivery.

Do **not** use this to:

- **Add real detail / enlarge with quality** — this is a plain resize. Run `images-upscale` first for AI detail, then resize to the exact spec.
- Change **aspect ratio** when you don't have exact pixels in mind — use `images-crop` (ratio-based).
- Resize something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `width` | **yes** | `width` | Pixels, 16–8192. **Snaps to the nearest multiple of 8.** |
| `height` | **yes** | `height` | Pixels, 16–8192. **Snaps to the nearest multiple of 8.** |
| `folder` | no | `folderReference` | Optional target folder from `folders_list`. |

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Check the aspect.** If your target W:H differs from the source's aspect, the tool **center-crops** to fit — edges are lost. If that's not what you want, `images-crop` to the right ratio first, then resize.
3. **Mind the multiple-of-8 snap.** Final dimensions round to multiples of 8; don't promise pixel-perfect odd sizes.
4. **Call** `images_resize` with `{ creationIdentifier, width, height }`.
5. **Preview.** Follow the response `instruction`. UI → `creations_show`; text-only → `webUrl`.
6. **Return** the new creation `identifier`.

## Output

A new creation `identifier` at the requested size (snapped to ×8). Original unchanged.

## Chaining

- **Feeds into:** final delivery.
- **Consumes from:** `images-upscale` (enlarge first, then resize to spec), `images-crop` (fix aspect first), `images-generate`, `images-relight`, `images-remove-background`, `creations-upload`.

## Notes

- Order matters for quality: **upscale → crop → resize**, not resize-then-upscale.
- Keep this file under 300 lines.
