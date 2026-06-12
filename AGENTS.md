# magnific-skills — Codex / Cursor

A set of Magnific MCP skills for automated visual production. Unlike Claude Code, Codex and Cursor have no native "skill" loader — so this file is the entry point that tells the agent how to use them.

## Install

```bash
./install.sh codex     # or: ./install.sh cursor
```

This places the repo at `~/.codex/plugins/magnific-skills` (or `~/.cursor/plugins/magnific-skills`). The plugin manifest is in `.codex-plugin/plugin.json` (and `.cursor-plugin/plugin.json`).

## Prerequisite — the Magnific MCP server

The skills call Magnific MCP tools, so the Magnific MCP server must be connected and authenticated in your agent. Register the server per your agent's MCP setup, pointing at `https://mcp.magnific.com`.

> Skills reference tools as `mcp__<connector>__<tool>`. The `<connector>` segment depends on how you registered the server — adjust if yours differs (see [CONTRIBUTING.md](CONTRIBUTING.md)).

## How to use the skills (read this before any visual-production task)

When the user asks for image, video, audio, 3D, banner, listing, or video-ad work:

1. **Pick the skill.** Open [README.md](README.md#skills) for the catalog (24 skills). Each is a folder `skills/<name>/SKILL.md`.
2. **Read that one `SKILL.md`** before acting. It is the contract: inputs, the exact Magnific tool(s) to call, the steps, and what it returns.
3. **Follow it exactly.** Each skill returns a creation `identifier`; pass it to the next skill — never a `webUrl`.
4. **For multi-step jobs, start with a Layer 2 orchestrator** (`banner-flow`, `listing-visuals`, `video-ad`); it tells you which Layer 1 skills to chain.

Do not guess Magnific tool arguments — the SKILL.md files carry the schema-accurate parameters. Read the relevant one first.

## Layers

- **Layer 1 (21):** one wrapper per Magnific capability; returns a chainable creation `identifier`.
- **Layer 2 (3):** orchestrators that compose Layer 1 skills into a finished deliverable.
