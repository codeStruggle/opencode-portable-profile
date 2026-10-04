#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
CONFIG_BASE="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="$CONFIG_BASE/opencode"
MARKER="$TARGET_DIR/.portable-profile-install"

managed=(AGENTS.md agents skills commands tools plugins)
BACKUP_DIR=""
CONFIG_MANAGED=0
PROFILE_DIR="$SCRIPT_DIR"

if [[ -f "$MARKER" ]]; then
  marker_profile="$(awk -F '\t' '$1=="PROFILE_DIR"{sub($1 FS,""); print}' "$MARKER")"
  [[ -n "$marker_profile" ]] && PROFILE_DIR="$marker_profile"
  BACKUP_DIR="$(awk -F '\t' '$1=="BACKUP_DIR"{sub($1 FS,""); print}' "$MARKER")"
  CONFIG_MANAGED="$(awk -F '\t' '$1=="CONFIG_MANAGED"{print $2}' "$MARKER")"
fi

SOURCE_DIR="$PROFILE_DIR/profile"

same_link() {
  local target="$1"
  local source="$2"
  [[ -L "$target" ]] || return 1
  [[ "$(readlink "$target")" == "$source" ]]
}

for name in "${managed[@]}"; do
  target="$TARGET_DIR/$name"
  source="$SOURCE_DIR/$name"

  if same_link "$target" "$source"; then
    rm "$target"
    echo "Removed managed link: $target"
  fi

  if [[ -n "$BACKUP_DIR" && -e "$BACKUP_DIR/$name" && ! -e "$target" && ! -L "$target" ]]; then
    mv "$BACKUP_DIR/$name" "$target"
    echo "Restored backup: $target"
  fi
done

if [[ "$CONFIG_MANAGED" == "1" ]]; then
  target="$TARGET_DIR/opencode.json"
  if same_link "$target" "$SOURCE_DIR/opencode.json"; then
    rm "$target"
    echo "Removed managed minimal config."
  fi
fi

rm -f "$MARKER"

if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
  rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo
echo "Portable OpenCode profile uninstalled."
echo "OpenCode itself was not modified."
