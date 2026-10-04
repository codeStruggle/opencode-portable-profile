#!/usr/bin/env bash
set -euo pipefail

CONFIG_BASE="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="$CONFIG_BASE/opencode"

echo "OpenCode config directory: $TARGET_DIR"

required=(AGENTS.md agents)
for item in "${required[@]}"; do
  if [[ ! -e "$TARGET_DIR/$item" ]]; then
    echo "Missing: $TARGET_DIR/$item" >&2
    exit 1
  fi
done

count="$(find -L "$TARGET_DIR/agents" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')"
if [[ "$count" -lt 10 ]]; then
  echo "Expected at least 10 agents, found $count" >&2
  exit 1
fi

echo "Agents discovered in config directory: $count"

if command -v opencode >/dev/null 2>&1; then
  echo "OpenCode: $(command -v opencode)"
  opencode --version || true
else
  echo "OpenCode binary not found in PATH. Configuration files are installed, but OpenCode itself is not installed by this profile."
fi

echo "Verification passed."
