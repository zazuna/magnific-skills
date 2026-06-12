# magnific-skills

A forkable, Higgsfield-style skill set for the [Magnific](https://magnific.com) MCP server. Turn Magnific's image, video, audio, and 3D tools into composable agent skills you can chain into real production workflows — banners, ad variants, listing visuals, video spots, and more.

Works with any MCP-capable agent (Claude Code, Codex, etc.). Most skills are pure MCP calls; a few need a shell for steps the MCP server can't do itself (e.g. uploading a local file via presigned `PUT`). Those skills say so and offer a shell-free fallback, so they degrade gracefully on hosts without a terminal.

## Philosophy

Borrowed from [higgsfield-ai/skills](https://github.com/higgsfield-ai/skills):

- **One skill = one folder** with a `SKILL.md` and an optional `references/`.
- **Under 300 lines per `SKILL.md`.** If it needs more, it's two skills.
- **Skills chain via explicit return values** — each returns a creation `identifier` the next can consume.
- **Cross-agent compatible.** No agent-specific assumptions in the skill body.

## Three-layer architecture

| Layer | What | Lives where |
|-------|------|-------------|
| **1 — Wrappers** | One thin skill per Magnific tool (generate, relight, upscale, resize, …) | This repo |
| **2 — Orchestrators** | Multi-step pipelines built from Layer 1 (banner flow, listing visuals, video ad) | This repo |
| **3 — Domain** | Your brand assets, formats, copy templates wired into Layer 2 | **Your own** private repo / project — not here |

Fork Layers 1 + 2, plug in your own Layer 3, and you have a working visual-production framework.

## Structure

```
magnific-skills/
  README.md
  CONTRIBUTING.md
  LICENSE
  lint.sh               # validates every SKILL.md (see "Validate")
  .gitignore
  skills/
    _TEMPLATE/          # copy this to start a new skill
      SKILL.md
      references/
    <skill-name>/
      SKILL.md
      references/
```

## Setup

1. Add the Magnific MCP server to your agent:
   ```bash
   claude mcp add --transport http magnific https://mcp.magnific.com
   ```
2. Authenticate (in Claude Code: `/mcp` → select Magnific).
3. Install the skills globally for your agent:
   ```bash
   ./install.sh claude     # or: codex | cursor | all   (add --copy to copy instead of symlink)
   ```
   Per-agent details: [CLAUDE.md](CLAUDE.md) (Claude Code) · [AGENTS.md](AGENTS.md) (Codex/Cursor).
   Plugin manifests live in `.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/`.

> **Note:** the `allowed-tools` IDs use a connector-specific prefix
> (`mcp__claude_ai_Magnific__…`). If yours differs, see [CONTRIBUTING.md](CONTRIBUTING.md#mcp-tool-names-are-connector-specific-).

## Validate

Every skill must pass the linter (≤300 lines, required frontmatter, folder == `name:`):

```bash
./lint.sh
```

Run it before opening a PR. Folders prefixed with `_` (scaffolding) are skipped.

## Skills

Layer 1 = thin wrappers over one Magnific capability. Layer 2 = orchestrators built from Layer 1. Keep this table in sync when you add a skill (see CONTRIBUTING).

| Skill | Layer | What it does |
|-------|-------|--------------|
| [`creations-upload`](skills/creations-upload/SKILL.md) | 1 | Turn a public URL, host-attached file, or local file into a Magnific creation `identifier` — the prerequisite for using any image as a reference. |
| [`images-generate`](skills/images-generate/SKILL.md) | 1 | Text-to-image, or image-conditioned generation using reference creations, characters, products, locations, or styles. |
| [`images-upscale`](skills/images-upscale/SKILL.md) | 1 | AI-enlarge a creation 2x or 4x for print / hi-res output. |
| [`images-relight`](skills/images-relight/SKILL.md) | 1 | Relight a creation with 1–4 directional lights (intensity, neutral or colored gel). |
| [`images-remove-background`](skills/images-remove-background/SKILL.md) | 1 | Cut the subject out onto a transparent PNG for compositing. |
| [`images-resize`](skills/images-resize/SKILL.md) | 1 | Resize a creation to exact pixel dimensions (snaps to ×8). |
| [`images-crop`](skills/images-crop/SKILL.md) | 1 | Center-crop a creation to one of 8 target aspect ratios. |
| [`images-variations`](skills/images-variations/SKILL.md) | 1 | Generate a grid of variations (angles, demographics, expressions, age, storyboard, custom). |
| [`flows-run`](skills/flows-run/SKILL.md) | 1 | Find, inspect, and run a packaged Magnific Flow, then return the output creations. |
| [`library-show`](skills/library-show/SKILL.md) | 1 | Browse or pick reusable Library assets (characters, styles, elements, locations) for use as references. |
| [`folders-list`](skills/folders-list/SKILL.md) | 1 | List folders/projects to get a `folderReference` for filing outputs. |
| [`video-plan`](skills/video-plan/SKILL.md) | 1 | Draft a video brief, model choice, and clip breakdown before generating. |
| [`video-generate`](skills/video-generate/SKILL.md) | 1 | Text/image-to-video and multi-shot clips with keyframes and references. |
| [`video-speak`](skills/video-speak/SKILL.md) | 1 | Talking-head (image+audio) or lip-sync (video+audio) speaking videos. |
| [`video-upscale`](skills/video-upscale/SKILL.md) | 1 | Upscale/enhance video via Topaz or Magnific modes. |
| [`video-concatenate`](skills/video-concatenate/SKILL.md) | 1 | Join 2–10 completed clips into one MP4 in playback order. |
| [`audio-tts`](skills/audio-tts/SKILL.md) | 1 | Text-to-speech voiceover (single voice or two-speaker), ElevenLabs/Google. |
| [`audio-music-generate`](skills/audio-music-generate/SKILL.md) | 1 | Generate music beds/soundtracks from a description (Lyria/ElevenLabs). |
| [`models3d-generate`](skills/models3d-generate/SKILL.md) | 1 | Convert an image creation into a 3D GLB model (Tripo/Trellis). |
| [`images-change-camera`](skills/images-change-camera/SKILL.md) | 1 | Reframe the camera (rotate/vertical/closeup) around a subject. |
| [`images-skin-enhancer`](skills/images-skin-enhancer/SKILL.md) | 1 | Enhance skin/portrait detail (faithful/creative/flexible). |
| [`banner-flow`](skills/banner-flow/SKILL.md) | 2 | One brief/source → an on-brand banner in every requested placement/size. |
| [`listing-visuals`](skills/listing-visuals/SKILL.md) | 2 | Property/product photos + features → a coherent listing set (hero, features, lifestyle). |
| [`video-ad`](skills/video-ad/SKILL.md) | 2 | Brief → a finished short video ad (plan, generate, voice, score, assemble). |

## Status

🚧 **Layers 1 & 2 complete.** 21 Layer 1 wrappers (image, video, audio, 3D, flow, library, folder) + 3 Layer 2 orchestrators (`banner-flow`, `listing-visuals`, `video-ad`). Layer 3 (brand-specific) stays in your own repo.

## License

MIT
