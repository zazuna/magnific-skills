---
version: 0.1.0
name: skill-name
description: One sentence on what this skill does and when an agent should reach for it. Write it for the agent's selector — front-load the trigger.
argument-hint: "<required-arg> [optional-arg]"
allowed-tools:
  - mcp__claude_ai_Magnific__images_generate
---

# Skill Name

> One-line restatement of purpose. What goes in, what comes out.

## When to use

- Trigger condition 1
- Trigger condition 2

Do **not** use this when <the case a sibling skill handles> — use `sibling-skill` instead.

## Inputs

| Arg | Required | Description |
|-----|----------|-------------|
| `subject` | yes | What to generate / process |
| `format` | no | Output aspect ratio, defaults to `1:1` |

## Steps

1. Validate inputs. If `subject` is missing, ask the user before calling any tool.
2. Call the Magnific tool with the mapped arguments.
3. Follow the `instruction` field in the tool response (preview vs. webUrl handling).
4. Return the creation `identifier` so downstream skills can chain off it.

## Output

What this skill returns to the caller — always a creation `identifier` (not a `webUrl`) so the next skill in a chain can consume it.

## Chaining

- Feeds into: `next-skill` (pass the returned `identifier`)
- Consumes from: `previous-skill`

## Notes

- Keep this file under 300 lines. If it grows past that, split it.
- Reference images / long examples live in `references/`, not here.
