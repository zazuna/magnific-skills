# Contributing

## Adding a skill

1. Copy `skills/_TEMPLATE/` to `skills/<your-skill-name>/`.
2. Fill in `SKILL.md`. Keep it under **300 lines**.
3. Use kebab-case for the folder and the `name:` field — they must match.
4. List only the Magnific MCP tools the skill actually calls in `allowed-tools`.
5. Put long examples, sample prompts, and reference images in `references/`.
6. Add a row for the skill to the **Skills** table in `README.md` (name, layer, one-line description). The catalog is the front door — a skill that isn't listed effectively doesn't exist.

## SKILL.md rules

- **Frontmatter is required:** `version`, `name`, `description`, `argument-hint`, `allowed-tools`.
- **`description` is the selector.** Front-load the trigger phrase — it's what an agent reads to decide whether to use the skill.
- **Return an `identifier`, not a `webUrl`.** Downstream skills chain on the creation `identifier`. `webUrl` is only for showing the user a link in text-only clients.
- **One responsibility per skill.** If you're describing two outcomes, split into two skills.

## MCP tool names are connector-specific ⚠️

The `allowed-tools` entries use the form `mcp__<connector-name>__<tool>`, e.g.
`mcp__claude_ai_Magnific__images_generate`. **The `<connector-name>` segment depends
on how _you_ registered the Magnific MCP server in your client** — it is not the same
for everyone. If your `allowed-tools` silently never match, this is almost always why.

Find your actual prefix:

- **Claude Code:** run `/mcp`, or check `claude mcp list` — the server name you chose
  becomes the prefix (sanitized). The skills here assume the connector is the
  claude.ai Magnific connector (`mcp__claude_ai_Magnific__…`).
- **Other agents:** inspect your tool list and copy the exact tool id.

If your prefix differs, update the `allowed-tools` block in each skill to match. Only
the prefix changes — the trailing tool name (`images_generate`, `images_relight`, …)
is stable.

## Layer discipline

- **Layer 1** skills wrap exactly one **capability** — one user intent. Usually that
  is one Magnific tool, but it may be a few tightly-coupled calls when the API splits a
  single operation across tools (e.g. presigned upload: `request_upload` → PUT →
  `finalize_upload`). What a Layer 1 skill must **not** do is orchestrate *separate*
  intents (don't generate-then-upscale in one wrapper — that's Layer 2).
- **Layer 2** skills orchestrate Layer 1 skills. They call no Magnific tool directly that a Layer 1 skill already wraps.
- **Layer 3** (your brand-specific skills) does **not** belong in this repo. Keep it in your own project.

## Naming

- Folder == `name:` field == kebab-case.
- Prefix wrappers by domain: `images-`, `video-`, `audio-`, `flows-`, `spaces-`.
- Orchestrators get plain action names: `banner-flow`, `listing-visuals`.
- **Exempt:** any folder beginning with `_` (e.g. `_TEMPLATE`) is scaffolding, not a
  real skill. The linter skips these, and agents should not load them.

## Testing a skill

Before opening a PR, run the skill end-to-end against a live Magnific account and confirm it returns a usable creation `identifier`.
