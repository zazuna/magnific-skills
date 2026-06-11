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
3. Point your agent at the `skills/` directory.

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

## Status

🚧 Early. Layer 1 wrappers in progress; Layer 2 orchestrators not started.

## License

MIT
