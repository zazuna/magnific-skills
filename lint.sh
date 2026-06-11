#!/usr/bin/env bash
# Validate every skill against the rules in CONTRIBUTING.md.
# Run from the repo root: ./lint.sh
# Exit 0 = all skills pass; exit 1 = at least one failure.
#
# Checks per skill (skills/<name>/SKILL.md):
#   1. SKILL.md is <= 300 lines
#   2. Frontmatter present and contains: version, name, description,
#      argument-hint, allowed-tools
#   3. The `name:` field matches the folder name
# Folders beginning with `_` (e.g. _TEMPLATE) are scaffolding and skipped.

set -u

MAX_LINES=300
REQUIRED_KEYS=(version name description argument-hint allowed-tools)
fail=0
checked=0

for skill in skills/*/SKILL.md; do
  [ -e "$skill" ] || { echo "No skills found under skills/*/SKILL.md"; exit 1; }

  dir=$(dirname "$skill")
  folder=$(basename "$dir")

  # Skip scaffolding folders (e.g. _TEMPLATE)
  case "$folder" in
    _*) continue ;;
  esac

  checked=$((checked + 1))
  errors=()

  # 1. Line-count limit
  lines=$(wc -l < "$skill" | tr -d ' ')
  if [ "$lines" -gt "$MAX_LINES" ]; then
    errors+=("exceeds $MAX_LINES lines (has $lines)")
  fi

  # Extract frontmatter: lines between the first pair of `---` delimiters.
  fm=$(awk 'NR==1 && $0!="---"{exit 1} NR==1{next} /^---[[:space:]]*$/{exit} {print}' "$skill")
  if [ -z "$fm" ]; then
    errors+=("missing or empty YAML frontmatter")
  else
    # 2. Required keys present
    for key in "${REQUIRED_KEYS[@]}"; do
      if ! printf '%s\n' "$fm" | grep -qE "^${key}:"; then
        errors+=("frontmatter missing key: $key")
      fi
    done

    # 3. name == folder
    name_val=$(printf '%s\n' "$fm" | grep -E '^name:' | head -1 | sed -E 's/^name:[[:space:]]*//; s/[[:space:]]*$//; s/^"//; s/"$//')
    if [ -n "$name_val" ] && [ "$name_val" != "$folder" ]; then
      errors+=("name '$name_val' does not match folder '$folder'")
    fi
  fi

  if [ "${#errors[@]}" -eq 0 ]; then
    echo "PASS  $dir"
  else
    fail=1
    echo "FAIL  $dir"
    for e in "${errors[@]}"; do
      echo "        - $e"
    done
  fi
done

echo
if [ "$checked" -eq 0 ]; then
  echo "No real skills to lint yet (only scaffolding). OK."
  exit 0
fi

if [ "$fail" -ne 0 ]; then
  echo "Lint failed."
  exit 1
fi
echo "All $checked skill(s) passed."
exit 0
