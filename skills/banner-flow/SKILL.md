---
version: 0.1.0
name: banner-flow
description: Orchestrate a complete on-brand banner set from a brief plus source assets and a list of target placements/sizes — generate a hero visual, harmonize it, then crop/resize/upscale it into every requested format. Layer 2 orchestrator built from the image primitives, with a flows-run shortcut when a strong pre-built flow fits.
argument-hint: "<brief> <target placements: list of {name, ratio or WxH, print?}> [brand assets] [source photo]"
allowed-tools:
  - library-show
  - creations-upload
  - folders-list
  - flows-run
  - images-generate
  - images-relight
  - images-remove-background
  - images-skin-enhancer
  - images-crop
  - images-resize
  - images-upscale
---

# banner-flow

> Brief + assets + a list of target formats → a finished banner in each format. The Omnia banner deliverable.

## When to use

- Produce a multi-format banner set (social, web, print) from one brief/source.
- The caller supplies the exact placements they need this run (variable per run).

Do **not** use this for:

- A single one-off image — call `images-generate` directly.
- A property listing set — use `listing-visuals`. A video ad — use `video-ad`.

## Inputs

| Arg | Required | Notes |
|-----|----------|-------|
| `brief` | **yes** | What the banner should show/say (concept, subject, mood). |
| `targets` | **yes** | List of placements: each `{ name, ratio (e.g. 1:1) OR width×height px, print? }`. This run produces exactly these. |
| `brandAssets` | no | Library asset ids (style/character/product/location) via `library-show`. |
| `sourcePhoto` | no | A property/product photo to feature; a URL/local file becomes a creation via `creations-upload`. |
| `project` | no | Omnia project folder via `folders-list` (`folderReference`). |

## Steps

1. **Resolve inputs.** `library-show` → brand asset ids. `creations-upload` → turn any source photo/URL into a creation id. `folders-list` → the target project folder. Map library `element` → reference `product`.
2. **Hybrid check.** If a pre-built flow clearly fits the brief (e.g. "Audience-driven ads"), offer `flows-run` as a shortcut and skip to step 6 with its outputs. Otherwise compose (steps 3–5).
3. **Generate the hero.** `images-generate` with the brief as prompt, brand assets + source photo as `references[]`, filed to `project`. Pick the aspect ratio closest to your largest target to preserve the most pixels.
4. **Harmonize (as needed).** `images-relight` to match lighting; `images-remove-background` + a fresh background via `images-generate` to composite a product; `images-skin-enhancer` (faithful) if people are featured. Each returns a new identifier — carry the latest forward.
5. **Make print-grade once.** If any target has `print: true`, `images-upscale` the hero now (upscale before crop/resize, per the quality order).
6. **Fan out per target.** Working from the hero (already upscaled in step 5 when any target is print): for each placement, `images-crop` to its ratio → `images-resize` to its exact px. Use the **same hero** for every format. Never upscale *after* resizing — if a target needs more resolution than the hero has, raise the step-5 upscale instead.
7. **Preview & return.** Collect every output creation `identifier`; preview them; hand back the set keyed by target `name`.

## Output

A set of banner creation `identifier`s — one per requested placement — all filed in the project folder. Always identifiers, never `webUrl`.

## Chaining

- **Composes:** `library-show`, `creations-upload`, `folders-list`, `flows-run`, `images-generate`, `images-relight`, `images-remove-background`, `images-skin-enhancer`, `images-crop`, `images-resize`, `images-upscale`.
- **Wrapped by:** a Layer 3 (brand) skill that supplies Omnia's assets, palette, and standard placement list.

## Notes

- **Quality order is upscale → crop → resize**, never resize-then-upscale.
- Generate **one** hero, then fan out — don't re-generate per format, or the formats won't match.
- Thread identifiers between steps; never pass a `webUrl`.
- Keep this file under 300 lines.
