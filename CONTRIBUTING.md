# Contributing

## Adding a skill

1. Copy `skills/_TEMPLATE/` to `skills/<your-skill-name>/`.
2. Fill in `SKILL.md`. Keep it under **300 lines**.
3. Use kebab-case for the folder and the `name:` field — they must match.
4. List only the Magnific MCP tools the skill actually calls in `allowed-tools`.
5. Put long examples, sample prompts, and reference images in `references/`.

## SKILL.md rules

- **Frontmatter is required:** `version`, `name`, `description`, `argument-hint`, `allowed-tools`.
- **`description` is the selector.** Front-load the trigger phrase — it's what an agent reads to decide whether to use the skill.
- **Return an `identifier`, not a `webUrl`.** Downstream skills chain on the creation `identifier`. `webUrl` is only for showing the user a link in text-only clients.
- **One responsibility per skill.** If you're describing two outcomes, split into two skills.

## Layer discipline

- **Layer 1** skills wrap exactly one Magnific tool. No orchestration.
- **Layer 2** skills orchestrate Layer 1 skills. They call no Magnific tool directly that a Layer 1 skill already wraps.
- **Layer 3** (your brand-specific skills) does **not** belong in this repo. Keep it in your own project.

## Naming

- Folder == `name:` field == kebab-case.
- Prefix wrappers by domain: `images-`, `video-`, `audio-`, `flows-`, `spaces-`.
- Orchestrators get plain action names: `banner-flow`, `listing-visuals`.

## Testing a skill

Before opening a PR, run the skill end-to-end against a live Magnific account and confirm it returns a usable creation `identifier`.
