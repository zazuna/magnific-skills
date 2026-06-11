---
version: 0.1.0
name: creations-upload
description: Turn an external asset (public URL, host-attached file, or local file) into a Magnific creation and return its identifier — the prerequisite for using any image as a reference in images-generate, video-generate, relight, upscale, and other tools.
argument-hint: "<source: public URL | host file | local path> [mime type for local files]"
allowed-tools:
  - mcp__claude_ai_Magnific__creations_upload_image
  - mcp__claude_ai_Magnific__creations_upload_file
  - mcp__claude_ai_Magnific__creations_request_upload
  - mcp__claude_ai_Magnific__creations_finalize_upload
  - Bash
---

# creations-upload

> External asset → Magnific creation `identifier`. Nothing can be used as a reference until it is a creation; this is that bridge.

## When to use

- A reference-taking skill (`images-generate`, `video-generate`, `images-relight`, …) needs a creation `identifier`, but the user gave you a **URL**, a **file they attached in the chat host**, or a **local file on disk**.
- You need to bring any outside image/video into the user's Magnific workspace.

Do **not** use this for:

- Assets that are already Magnific creations (you already have an `identifier`) — skip straight to the tool that needs it.
- Pre-built **library** assets (characters/products/locations/style LoRAs) — those are referenced by their numeric `id` from `library_list`, never uploaded here.

## Inputs

| Source you were given | Path | Tool(s) | Required fields |
|-----------------------|------|---------|-----------------|
| **Public image URL** | A | `creations_upload_image` | `url` |
| **Host-attached file** (user uploaded into the chat host) | B | `creations_upload_file` | `file.download_url`, `file.file_id` (plus `file_name`, `mime_type` when known) |
| **Local file / raw bytes** | C | `creations_request_upload` → PUT → `creations_finalize_upload` | `mimeType` (enum), then `path` |

### Constraints (from the API)

- **`mimeType` enum:** `image/jpeg`, `image/png`, `image/webp`, `video/mp4`, `video/quicktime`, `video/webm`, `video/x-m4v`.
- **Size:** images ≤ 25 MB, videos ≤ 200 MB.
- **Batch:** `creations_request_upload.count` and `creations_finalize_upload.uploads[]` accept 1–100.

## Steps

**First, classify the source** into path A, B, or C. If unclear, ask the user whether it's a public URL, a file they attached here, or a file on disk.

### Path A — public URL (one step)

1. Call `creations_upload_image({ url })`.
2. Return the resulting creation `identifier`.

### Path B — host-attached file (one step)

1. Call `creations_upload_file({ file: { download_url, file_id, file_name?, mime_type? } })`.
2. Return the resulting creation `identifier`.

### Path C — local file / raw bytes (three steps)

1. **Request:** call `creations_request_upload({ mimeType, count })`. Pick `mimeType` from the enum that matches the real file type. Use `count` only for a batch. You get back presigned PUT URL(s) and a temp `path` for each.
2. **Upload bytes — outside MCP.** PUT the file to each presigned URL. In a shell-capable agent (Claude Code) use `Bash`:
   `curl -sS -X PUT --upload-file "<local-file>" "<presigned-url>"`
   This step needs an HTTP-PUT capability. Hosts without a shell (e.g. ChatGPT) cannot do path C — use path B (host file) or path A (URL) instead.
3. **Finalize:** call `creations_finalize_upload`. Single: `{ path }`. Batch: `{ uploads: [{ path }, …] }` (1–100). This converts the uploaded temp path(s) into creation(s).
4. Return the creation `identifier`(s).

## Output

One creation `identifier` per uploaded asset (batch → several). Hand back the **`identifier`** only — that is what reference-taking skills consume. There is no `webUrl` step here; uploading is a setup operation, not a render.

## Chaining

- **Feeds into:** `images-generate` (`references[].type=image|style`), `video-generate` (keyframes/references), `images-relight`, `images-upscale`, `images-remove-background`, `images-resize`, `images-crop` — anything that takes an existing image.
- **Consumes from:** nothing — this is an entry point.

## Notes

- This skill wraps one **capability** (upload), which the API splits across up to four tools because presigned uploads are inherently multi-step. That is deliberate, not orchestration of separate user intents.
- Verify the file is within size limits before path C; the finalize step will reject oversized files.
- Keep this file under 300 lines.
