---
version: 0.1.0
name: library-show
description: Browse or pick reusable Magnific Library assets (characters, styles, elements, locations) — the brand assets that feed generation as references. Use it to let the user choose an asset visually, or to look one up headlessly, then pass its id into images-generate or video-generate.
argument-hint: "[type: character|style|element|locations] [scope: all|projects|organization]"
allowed-tools:
  - mcp__claude_ai_Magnific__library_show
  - mcp__claude_ai_Magnific__library_list
---

# library-show

> The Library holds reusable assets — characters, styles, elements (products), locations — shared across your team/projects. This skill surfaces them so their ids can feed a reference.

## When to use

- The user should **pick** a brand asset visually before generating (inline picker).
- You need to **find** an asset's id headlessly to drop into a generation reference.

Do **not** use this to:

- Create a new asset — that's `library-create` (image-only, no LoRA training).
- Reference a one-off photo you already have — that's a creation, use `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `type` | no | `type` | `character`, `style`, `element`, or `locations`. Omit to show all. |
| `scope` | no | `scope` | `all` (default), `projects`, or `organization`. |
| `search` | no | `library_list.search` | (list only) filter by name/description. |

## Steps

1. **Choose the mode:**
   - **User should pick** → `library_show({ type?, scope? })`. Renders an inline picker grouped by source (own / public / team / project). The user clicks; you get the chosen asset's id/identifier for the next call.
   - **Headless lookup** → `library_list({ type?, scope?, search? })`. Returns lean entries with numeric `id`, `identifier`, `type`, and `source`. Page with `page`/`perPage` (max 50).
2. **Read the id correctly** (this is where references break):
   - `character`, `element`, `locations`, and **style LoRAs** → pass the **numeric `id`** as the reference.
   - A `style` used as a *style photo* (a creation) → that's a creation `identifier`, not a library id.
3. **Return** the asset id(s) to the caller for use in a reference.

## Output

A library asset **numeric `id`** (or `identifier`) plus its `type`, ready to drop into a generation reference.

## Chaining

- **Feeds into:** `images-generate` (`references[].type = character|product|style|locations`) and `video-generate` (`references[].type = character|product`). **Naming gotcha:** the library calls this asset class `element`, but generation references call the same thing **`product`** — map `element → product` when building the reference.
- **Consumes from:** nothing — this is a lookup entry point.

## Notes

- Pass the library `id` **as-is** into a reference — never convert it to a creation identifier.
- Spaces reference nodes use the numeric `id` as `modifierId` (different field, same id).
- Keep this file under 300 lines.
