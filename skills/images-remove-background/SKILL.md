---
version: 0.1.0
name: images-remove-background
description: Remove the background from an existing Magnific creation, returning the subject cut out on a transparent PNG — for product cut-outs, logos, and compositing onto banner backgrounds. Returns a new creation identifier.
argument-hint: "<creation identifier>"
allowed-tools:
  - mcp__claude_ai_Magnific__images_remove_background
  - mcp__claude_ai_Magnific__creations_show
---

# images-remove-background

> Existing creation → subject on transparent PNG. Clean cut-out, nothing else changed.

## When to use

- You need a product, person, or object isolated from its background for compositing.
- A banner pipeline needs a transparent-PNG subject to place over a generated background.

Do **not** use this to:

- Put the subject on a **solid color** background — the Magnific API references an `images_color_background` operation, but it is **not exposed by the current MCP connector**, so don't try to call it. Instead use `images-generate` with this cut-out as a reference and a prompt like "place on a solid #RRGGBB background", or flatten the transparent PNG onto a color yourself.
- Replace the background with a **new AI scene** — use `images-generate` with the subject as a reference and a prompt like "replace the background with …".
- Process something not yet a creation — upload it first with `creations-upload`.

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `creation` | **yes** | `creationIdentifier` | A creation `identifier`; upload local files/URLs first. |
| `folder` | no | `folderReference` | Optional target folder from `folders_list`. |

That's the whole surface — this tool takes only the image. No tuning knobs.

## Steps

1. **Validate.** Confirm a creation `identifier`. If the user gave a local file/URL, run `creations-upload` first.
2. **Call** `images_remove_background` with `{ creationIdentifier }`.
3. **Preview.** Follow the response `instruction`. UI → `creations_show`; text-only → `webUrl`.
4. **Return** the new creation `identifier` (a transparent PNG).

## Output

A new creation `identifier`: the subject cut out on transparency. Original is unchanged.

## Chaining

- **Feeds into:** `images-generate` (composite onto a new background via reference), `images-resize`, `images-crop`, `images-upscale`, or final delivery.
- **Consumes from:** `images-generate`, `creations-upload`, `images-relight`.

## Notes

- Output is a **transparent PNG** — keep it as PNG downstream or the transparency is lost.
- Best results need a clear subject/background separation in the source.
- Keep this file under 300 lines.
