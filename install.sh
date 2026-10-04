#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SOURCE_DIR="$SCRIPT_DIR/profile"
CONFIG_BASE="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="$CONFIG_BASE/opencode"
STAMP="$(date +%Y%m%d-%H%M%S)"
MARKER="$TARGET_DIR/.portable-profile-install"

managed=(AGENTS.md agents skills commands tools plugins)

mkdir -p "$TARGET_DIR"

EXISTING_PROFILE_DIR=""
BACKUP_DIR="$TARGET_DIR/.portable-profile-backup-$STAMP"
CONFIG_MANAGED=0

if [[ -f "$MARKER" ]]; then
  EXISTING_PROFILE_DIR="$(awk -F '\t' '$1=="PROFILE_DIR"{sub($1 FS,""); print}' "$MARKER")"
  if [[ "$EXISTING_PROFILE_DIR" == "$SCRIPT_DIR" ]]; then
    previous_backup="$(awk -F '\t' '$1=="BACKUP_DIR"{sub($1 FS,""); print}' "$MARKER")"
    previous_config="$(awk -F '\t' '$1=="CONFIG_MANAGED"{print $2}' "$MARKER")"
    [[ -n "$previous_backup" ]] && BACKUP_DIR="$previous_backup"
    [[ -n "$previous_config" ]] && CONFIG_MANAGED="$previous_config"
  fi
fi

same_link() {
  local target="$1"
  local source="$2"
  [[ -L "$target" ]] || return 1
  [[ "$(readlink "$target")" == "$source" ]]
}

backup_path() {
  local target="$1"
  local name="$2"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$name"
  fi
}

for name in "${managed[@]}"; do
  source="$SOURCE_DIR/$name"
  target="$TARGET_DIR/$name"

  if same_link "$target" "$source"; then
    echo "Already linked: $target"
    continue
  fi

  backup_path "$target" "$name"
  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
done

if same_link "$TARGET_DIR/opencode.json" "$SOURCE_DIR/opencode.json"; then
  CONFIG_MANAGED=1
  echo "Minimal config already linked."
elif [[ ! -e "$TARGET_DIR/opencode.json" && ! -L "$TARGET_DIR/opencode.json" && ! -e "$TARGET_DIR/opencode.jsonc" && ! -L "$TARGET_DIR/opencode.jsonc" ]]; then
  ln -s "$SOURCE_DIR/opencode.json" "$TARGET_DIR/opencode.json"
  CONFIG_MANAGED=1
  echo "Linked minimal config: $TARGET_DIR/opencode.json"
else
  if [[ "$EXISTING_PROFILE_DIR" != "$SCRIPT_DIR" ]]; then
    CONFIG_MANAGED=0
  fi
  echo "Preserved existing OpenCode config file."
fi

{
  printf 'PROFILE_DIR\t%s\n' "$SCRIPT_DIR"
  printf 'BACKUP_DIR\t%s\n' "$BACKUP_DIR"
  printf 'CONFIG_MANAGED\t%s\n' "$CONFIG_MANAGED"
} > "$MARKER"

echo
echo "Installed portable OpenCode profile."
echo "Global config: $TARGET_DIR"
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Backup: $BACKUP_DIR"
fi
echo "OpenCode itself was not modified."
