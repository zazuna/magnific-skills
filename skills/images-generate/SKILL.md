---
version: 0.1.0
name: images-generate
description: Generate or edit an image from a text prompt via Magnific — text-to-image, or image-conditioned generation using reference creations, characters, products, locations, or styles. Returns a creation identifier for chaining.
argument-hint: "<prompt> [--ratio 1:1] [--count N] [--ref <id>:<type>]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_generate
  - mcp__claude_ai_Magnific__creations_show
---

# images-generate

> Text → image, or image+text → image, via Magnific. The base generation primitive every visual workflow builds on.

## When to use

- The user wants a brand-new image from a description (text-to-image).
- The user wants a variation conditioned on an existing image, character, product, location, or style.
- A Layer 2 orchestrator needs a fresh visual to feed into relight / upscale / resize.

Do **not** use this to:

- Upscale, relight, remove background, resize, or crop an existing image — those are dedicated skills (`images-upscale`, `images-relight`, `images-remove-background`, `images-resize`, `images-crop`).
- Generate variations of one specific creation when you don't want to re-prompt — prefer `images-variations`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `prompt` | **yes** | `prompt` | The description. The only required field. |
| `ratio` | no | `aspectRatio` | One of: `1:1` (default), `21:9`, `16:9`, `9:16`, `2:3`, `3:4`, `1:2`, `2:1`, `5:4`, `4:5`, `3:2`, `4:3`. |
| `count` | no | `count` | 1–8. Default lets the server decide (≤8). |
| `mode` | no | `mode` | Model slug from `images_models_list`. Omit or `auto` = server picks the best model. |
| `quality` | no | `quality` | Per-model; valid values come from `images_models_list.qualities`. |
| `resolution` | no | `resolution` | Per-model; valid values come from `images_models_list.resolutions`. |
| `references` | no | `references[]` | Max 12. Each is `{type, identifier}` — see below. |
| `folder` | no | `folderReference` | Project/folder ref from `folders_list` to file results under. Omit for default. |

### Reference rules (the part that bites)

Each reference is `{type, identifier}`:

| `type` | What `identifier` must be |
|--------|---------------------------|
| `image` | A **creation identifier** — any photo you already have in Magnific (incl. a person/product to keep consistent). |
| `style` | A library **style LoRA** numeric `id`, **or** a creation identifier used as a style photo. |
| `character` | A pre-built **library** asset — numeric `id` from `library_list`. Never a creation. |
| `product` | A pre-built **library** asset — numeric `id` from `library_list`. Never a creation. |
| `locations` | A pre-built **library** asset — numeric `id` from `library_list`. Never a creation. |

If the user hands you a **local file or a URL**, it is *not* yet a creation. Upload it first (a future `creations-upload` skill / `creations_request_upload` + `creations_finalize_upload`) to get a creation identifier, then pass that here. Do not pass raw URLs as reference identifiers.

## Steps

1. **Validate.** `prompt` is mandatory — if missing, ask the user; do not invent one.
2. **Resolve references** (if any). Confirm each identifier is the right kind for its `type` (creation id vs. library numeric id per the table). If the user gave a local file/URL, stop and upload it first.
3. **Pick the model.** Leave `mode` unset (or `auto`) unless the user named one. Only set `quality`/`resolution` to values that exist for that model in `images_models_list` — never guess.
4. **Call** `images_generate` with the mapped fields.
5. **Preview.** Follow the tool response's `instruction` field. In a UI-capable client you **must** call `creations_show` with **all** returned identifiers for inline preview — never stop at a link. In a text-only client, share the `webUrl`.
6. **Return** the creation `identifier`(s) to the caller for chaining.

## Output

One or more creation `identifier`s (per `count`). Always hand back the **`identifier`**, not the `webUrl` — downstream skills (`images-upscale`, `images-relight`, `video-generate` keyframes, etc.) chain on the identifier. `webUrl` is for showing a human a link only.

## Chaining

- **Feeds into:** `images-upscale`, `images-relight`, `images-remove-background`, `images-resize`, `images-variations`, `video-generate` (as a keyframe/reference).
- **Consumes from:** `library-show` / `library-list` (character/product/style/location ids), `creations-upload` (turns a local file/URL into a creation id), `folders-list` (target folder).

## Notes

- No references at all = pure text-to-image.
- `count > 1` returns several distinct creations — preview them all.
- Keep this file under 300 lines.
