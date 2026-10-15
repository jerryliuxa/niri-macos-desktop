#!/usr/bin/env bash
set -Eeuo pipefail

# Installs dependencies and copies this repository's Waybar config.
# It intentionally does NOT edit ~/.config/niri/config.kdl.

if [[ ! -f /etc/arch-release ]]; then
  echo "This installer targets Arch Linux and derivatives." >&2
  exit 1
fi
command -v pacman >/dev/null 2>&1 || { echo "pacman not found" >&2; exit 1; }

ROOT="$(cd -- "$(dirname -- "$(readlink -f -- "$0")")" && pwd)"
BACKUP_ROOT="$HOME/.config/niri-macos-desktop-backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_ROOT"

echo "Installing system dependencies..."
sudo pacman -S --needed waybar fuzzel gtk4 gtk4-layer-shell cairo poppler-glib protobuf ttf-jetbrains-mono-nerd otf-font-awesome papirus-icon-theme

if command -v yay >/dev/null 2>&1; then
  AUR_HELPER=(yay)
elif command -v paru >/dev/null 2>&1; then
  AUR_HELPER=(paru)
else
  echo "No yay/paru found. Install an AUR helper, then install Walker/Elephant packages."
  AUR_HELPER=()
fi

if [[ ${#AUR_HELPER[@]} -gt 0 ]]; then
  "${AUR_HELPER[@]}" -S --needed walker elephant elephant-providerlist elephant-desktopapplications elephant-calc elephant-files elephant-runner elephant-websearch
fi

copy_with_backup() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname -- "$dest")"
  if [[ -e "$dest" ]]; then
    local rel="${dest#"$HOME"/}"
    mkdir -p "$BACKUP_ROOT/$(dirname -- "$rel")"
    cp -a -- "$dest" "$BACKUP_ROOT/$rel"
    echo "Backed up: $dest -> $BACKUP_ROOT/$rel"
  fi
  install -m 0644 -- "$src" "$dest"
  echo "Installed: $dest"
}

copy_with_backup "$ROOT/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
copy_with_backup "$ROOT/waybar/style.css" "$HOME/.config/waybar/style.css"

if command -v walker >/dev/null 2>&1 && command -v elephant >/dev/null 2>&1; then
  echo "Enabling Elephant user service..."
  elephant service enable || echo "Could not enable Elephant automatically; see README.md."
  systemctl --user enable --now elephant.service || echo "Elephant did not start; check systemctl --user status elephant.service."
  elephant providers list || true
fi

echo
echo "Done. Backup directory: $BACKUP_ROOT"
echo 'Add manually inside your existing Niri binds block:'
echo '  Mod+Space { spawn "walker"; }'
echo "Your Niri config was not modified."
