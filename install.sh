#!/usr/bin/env bash
# Install magnific-skills globally for your coding agent.
#
#   ./install.sh [claude|codex|cursor|all]   (default: claude)
#   ./install.sh claude --copy               (copy instead of symlink)
#
# Symlink (default) keeps the installed skills in sync with this repo —
# edit a SKILL.md here and the change is live. --copy makes a standalone
# copy that does not depend on this repo's location.
#
# Skills require the Magnific MCP server to be connected in your agent:
#   claude mcp add --transport http magnific https://mcp.magnific.com

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT="${1:-claude}"
MODE="symlink"
[ "${2:-}" = "--copy" ] && MODE="copy"

# Link or copy $1 -> $2
place() {
  local src="$1" dest="$2"
  rm -rf "$dest"
  if [ "$MODE" = "copy" ]; then cp -R "$src" "$dest"; else ln -s "$src" "$dest"; fi
}

# Install every real skill folder (skip scaffolding) into a target skills dir.
install_skill_folders() {
  local target="$1"
  mkdir -p "$target"
  local count=0
  for skill in "$REPO_DIR"/skills/*/; do
    local name; name="$(basename "$skill")"
    case "$name" in _*) continue ;; esac   # skip _TEMPLATE
    place "${skill%/}" "$target/$name"
    count=$((count + 1))
  done
  echo "  $count skills -> $target ($MODE)"
}

install_claude() {
  echo "Claude Code:"
  install_skill_folders "$HOME/.claude/skills"
}

install_codex() {
  echo "Codex:"
  mkdir -p "$HOME/.codex/plugins"
  place "$REPO_DIR" "$HOME/.codex/plugins/magnific-skills"
  echo "  repo -> ~/.codex/plugins/magnific-skills ($MODE)"
  echo "  Codex reads skills via AGENTS.md — see this repo's AGENTS.md."
}

install_cursor() {
  echo "Cursor:"
  mkdir -p "$HOME/.cursor/plugins"
  place "$REPO_DIR" "$HOME/.cursor/plugins/magnific-skills"
  echo "  repo -> ~/.cursor/plugins/magnific-skills ($MODE)"
}

case "$AGENT" in
  claude) install_claude ;;
  codex)  install_codex ;;
  cursor) install_cursor ;;
  all)    install_claude; install_codex; install_cursor ;;
  *) echo "Usage: ./install.sh [claude|codex|cursor|all] [--copy]"; exit 1 ;;
esac

echo
echo "Done. Reminder: connect the Magnific MCP server if you haven't:"
echo "  claude mcp add --transport http magnific https://mcp.magnific.com"
echo "Then authenticate (Claude Code: /mcp -> Magnific)."
