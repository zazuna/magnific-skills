---
version: 0.1.0
name: models3d-generate
description: Convert an existing image creation into a 3D model (GLB) via Magnific — Tripo or Trellis engines, with face-count and texture controls. Returns a 3D creation identifier.
argument-hint: "<source image creation id> [model: tripo-p1|tripo-v31|trellis-2]"
allowed-tools:
  - mcp__claude_ai_Magnific__models3d_generate
  - mcp__claude_ai_Magnific__creations_show
---

# models3d-generate

> Image → 3D GLB. Turn a product or object photo into a mesh.

## When to use

- Make a 3D model (GLB) of a product/object from a single image — for AR, turntables, or 3D mockups.

Do **not** use this to:

- Generate or edit a 2D image — use `images-generate` / the image skills.
- Animate/rig the mesh — rigging is **not exposed by the current MCP connector**, so don't plan a tool call for it here.
- Convert something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | Source **image** creation `identifier`; upload external images first. |
| `model` | no | `model` | `tripo-p1` (default, fast), `tripo-v31` (HQ), `trellis-2`. |
| `faceLimit` | no | `faceLimit` | **Tripo only.** `tripo-p1`: 100–20,000 (default 10,000); `tripo-v31`: up to 2,000,000. |
| `resolution` | no | `resolution` | **`trellis-2` only:** `512`, `1024` (default), `1536`. |
| `textureQuality` | no | `textureQuality` | **Tripo only:** `none`, `standard` (default), `detailed` (**v31 only**). |
| `folder` | no | `folderReference` | Optional target folder. |

## Steps

1. **Validate.** Confirm an **image** creation `identifier`; upload first if needed.
2. **Pick the engine:** `tripo-p1` for speed, `tripo-v31` for high quality (and `detailed` textures / huge `faceLimit`), `trellis-2` when you want `resolution` control.
3. **Set only that engine's knobs** — `faceLimit`/`textureQuality` are Tripo; `resolution` is Trellis. Don't cross them.
4. **Call** `models3d_generate`.
5. **Preview.** UI → `creations_show`; text-only → `webUrl`.
6. **Return** the 3D (GLB) creation `identifier`.

## Output

A 3D model (GLB) creation `identifier`.

## Chaining

- **Feeds into:** delivery, AR/3D pipelines.
- **Consumes from:** `images-generate`, `images-remove-background` (a clean cut-out makes a better mesh), `creations-upload`.

## Notes

- `detailed` texture is **`tripo-v31` only**; `resolution` is **`trellis-2` only**.
- A clean, single-subject source image yields a far better mesh — consider `images-remove-background` first.
- Keep this file under 300 lines.
