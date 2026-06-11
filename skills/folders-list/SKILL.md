---
version: 0.1.0
name: folders-list
description: List Magnific folders and projects to obtain a folder reference — the value that image, video, and flow tools accept as folderReference to file their outputs in the right project. Use it before generating when results should land in a specific project rather than the default.
argument-hint: "[onlyProjects] | [parent folder reference]"
allowed-tools:
  - mcp__claude_ai_Magnific__folders_list
---

# folders-list

> Resolve a `folderReference`: where your creations get filed. Most image/video tools accept one; this is how you find it.

## When to use

- Outputs must land in a specific **project/folder** (e.g. the Omnia campaign), not the default.
- You need to browse the project/folder tree to pick or confirm a target.

Do **not** use this to:

- Create, rename, or delete folders — those are `folders_create` / `folders_rename` / `folders_delete` (no wrappers yet).

## Inputs

| Arg | Required | Maps to | Notes |
|-----|----------|---------|-------|
| `onlyProjects` | no | `onlyProjects` | `true` = top-level projects only. **Mutually exclusive with `parentReference`.** |
| `parent` | no | `parentReference` | List the children of this folder. Exclusive with `onlyProjects`. |
| `page` | no | `page` | Pagination. |

With no params, returns the **top level**.

## Steps

1. **Decide the view:** no params → top level; `onlyProjects: true` → just projects; `parentReference: <ref>` → that folder's children. Don't set both `onlyProjects` and `parentReference`.
2. **Call** `folders_list` with the chosen params (raw TOON text back).
3. **Pick the reference** for the target folder/project.
4. **Return** that folder reference.

## Output

A folder/project **reference** string. Pass it as `folderReference` to `images-generate`, `images-upscale`, `images-relight`, `images-remove-background`, `images-resize`, `images-crop`, `images-variations`, video tools, etc. — or to folder operations.

## Chaining

- **Feeds into:** every generation/processing skill's optional `folder` arg (`folderReference`).
- **Consumes from:** nothing — this is a lookup entry point.

## Notes

- `onlyProjects` and `parentReference` are mutually exclusive — pick one.
- Omitting the folder entirely files results in the default location; only use this when placement matters.
- Keep this file under 300 lines.
