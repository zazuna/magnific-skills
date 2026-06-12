---
version: 0.1.0
name: images-skin-enhancer
description: Enhance skin and portrait detail on an existing image (faithful, creative, or flexible). Use for people and portrait clean-up. For lighting use images-relight, and for resolution use images-upscale.
argument-hint: "<creation id> [version: faithful|creative|flexible]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_skin_enhancer
  - mcp__claude_ai_Magnific__creations_show
---

# images-skin-enhancer

> Existing creation → cleaner skin / better portrait detail. Three strengths of intervention.

## When to use

- A portrait or model shot needs skin clean-up or detail enhancement for a banner or ad.

Do **not** use this to:

- Change lighting — that's `images-relight`.
- Enlarge resolution — that's `images-upscale`.
- Enhance something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `version` | no | `version` | `faithful` (default, preserves identity), `creative` (reinterprets), `flexible` (preset-driven). |
| `skinDetail` | no | `skinDetail` | **`faithful` only**, 0–100. |
| `optimizedFor` | no | `optimizedFor` | **`flexible` only**: `enhance_skin`, `enhance_everything`, `improve_lighting`, `transform_to_real`, `no_make_up`. |
| `sharpen` | no | `sharpen` | 0–100, default 0. |
| `smartGrain` | no | `smartGrain` | 0–100, default 0. |
| `folder` | no | `folderReference` | Optional target folder. |

## Steps

1. **Validate.** Confirm a creation `identifier`; upload first if needed.
2. **Pick the `version`:** `faithful` to keep the person's identity (most banner work), `creative` for a reinterpretation, `flexible` to drive with an `optimizedFor` preset.
3. **Set only that version's knob:** `skinDetail` is faithful-only; `optimizedFor` is flexible-only. `sharpen`/`smartGrain` apply generally.
4. **Call** `images_skin_enhancer`.
5. **Preview.** UI → `creations_show`; text-only → `webUrl`.
6. **Return** the new creation `identifier`.

## Output

A new creation `identifier` with enhanced skin/detail. Original unchanged.

## Chaining

- **Feeds into:** `images-upscale`, `images-relight`, `images-crop`, `images-resize`, final delivery.
- **Consumes from:** `images-generate`, `creations-upload`.

## Notes

- For people in brand creative, prefer `faithful` — `creative` can drift the likeness.
- `skinDetail` (faithful) and `optimizedFor` (flexible) are mutually exclusive by version.
- Keep this file under 300 lines.
