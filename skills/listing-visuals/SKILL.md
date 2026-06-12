---
version: 0.1.0
name: listing-visuals
description: Produce a full property or product listing visual set (hero, feature shots, lifestyle, detail) from photos plus key features. Prefer this over images-generate for real-estate or marketplace listing image sets.
argument-hint: "<source photos> <key features list> [target placements] [brand assets]"
allowed-tools:
  - creations-upload
  - library-show
  - folders-list
  - flows-run
  - images-generate
  - images-variations
  - images-crop
  - images-resize
  - images-upscale
---

# listing-visuals

> Property/product photos + feature list → a coherent listing set (hero, features, lifestyle). For real-estate and marketplace marketing.

## When to use

- Build a multi-image listing set for a property or product from source photos.
- You have key selling points to turn into feature/benefit visuals.

Do **not** use this for:

- A single banner set across ad placements — use `banner-flow`.
- A video — use `video-ad`.

## Inputs

| Arg | Required | Notes |
|-----|----------|-------|
| `photos` | **yes** | Source property/product photos; URLs/local files become creations via `creations-upload`. |
| `features` | **yes** | Key selling points to turn into feature/benefit visuals. |
| `targets` | no | Placements/sizes to output each visual at (variable per run). Omit for the set's native sizes. |
| `brandAssets` | no | Library style/character/location ids via `library-show`. |
| `project` | no | Project folder via `folders-list`. |

## Steps

1. **Resolve inputs.** `creations-upload` for each photo → creation ids. `library-show` for brand style. `folders-list` for the project.
2. **Hybrid check.** If the "Marketplace listing visuals" flow fits (product + features → hero/features/benefits/how-to/lifestyle/badges), offer `flows-run` as a shortcut and skip to step 6 with its outputs. Otherwise compose (steps 3–5).
3. **Hero.** `images-generate` (or enhance a source photo) into a strong hero, using brand style as a reference.
4. **Feature shots.** For each feature, `images-generate` a focused visual, or use `images-variations` (e.g. `custom`/`storyboard`) to produce a coherent grid of feature/detail/lifestyle frames from one source.
5. **Lifestyle/context.** Generate or vary context shots that place the subject in use.
6. **Size per target.** If print/hi-res is needed, `images-upscale` the output **first**; then for each placement `images-crop` → `images-resize`. Never resize then upscale (quality order: upscale → crop → resize).
7. **Preview & return.** Collect all output `identifier`s; preview; return the set labeled by role (hero, feature-1, lifestyle, …).

## Output

A labeled set of listing visual creation `identifier`s, filed in the project folder. Identifiers only, never `webUrl`.

## Chaining

- **Composes:** `creations-upload`, `library-show`, `folders-list`, `flows-run`, `images-generate`, `images-variations`, `images-crop`, `images-resize`, `images-upscale`.
- **Wrapped by:** a Layer 3 (brand) skill supplying the brand style and the standard listing-set definition.

## Notes

- Keep the **same style reference** across every visual so the set looks like one campaign.
- `images-variations` is the efficient way to get a coherent multi-shot set from one source.
- Thread identifiers between steps; never pass a `webUrl`.
- Keep this file under 300 lines.
