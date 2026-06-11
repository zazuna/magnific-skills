# magnific-skills

A forkable, Higgsfield-style skill set for the [Magnific](https://magnific.com) MCP server. Turn Magnific's image, video, audio, and 3D tools into composable agent skills you can chain into real production workflows — banners, ad variants, listing visuals, video spots, and more.

Works with any MCP-capable agent (Claude Code, Codex, etc.).

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

## Status

🚧 Early scaffolding. Layer 1 wrappers in progress.

## License

MIT
