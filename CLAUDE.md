# magnific-skills — Claude Code

This repo is a set of [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills) for the Magnific MCP server.

## Install

```bash
./install.sh claude
```

This symlinks each skill in `skills/` into `~/.claude/skills/`, so Claude Code discovers them globally. Use `--copy` for a standalone copy.

For marketplace-style distribution, the plugin manifests live in `.claude-plugin/` (`plugin.json` + `marketplace.json`), exposing each skill as `/magnific-skills:<name>`.

## Prerequisite — the Magnific MCP server

The skills call Magnific MCP tools. Connect and authenticate once:

```bash
claude mcp add --transport http magnific https://mcp.magnific.com
```

Then run `/mcp` and authenticate the Magnific connector.

> **Tool-name note:** skills reference tools as `mcp__claude_ai_Magnific__…`. If your connector is registered under a different name, the prefix differs — see [CONTRIBUTING.md](CONTRIBUTING.md#mcp-tool-names-are-connector-specific-).

## How the skills are organized

- **Layer 1 (21):** one thin wrapper per Magnific capability. They return a creation `identifier` you chain forward.
- **Layer 2 (3):** orchestrators — `banner-flow`, `listing-visuals`, `video-ad` — that compose Layer 1 skills.

Browse the full list in [README.md](README.md#skills). Each skill is a folder under `skills/<name>/SKILL.md`.

## Using them

Just describe what you want ("build an on-brand banner set for these sizes") and Claude selects the right skill from its description. Skills load on demand — only their one-line descriptions sit in context until invoked.
