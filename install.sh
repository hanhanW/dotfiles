#!/usr/bin/env bash
# Main dotfiles installer
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper for yes/no prompts
ask() {
    local prompt="$1"
    local default="${2:-n}"
    local yn
    if [[ "$default" == "y" ]]; then
        read -p "$prompt [Y/n] " -n 1 -r yn
    else
        read -p "$prompt [y/N] " -n 1 -r yn
    fi
    echo
    [[ "$yn" =~ ^[Yy]$ ]] || [[ -z "$yn" && "$default" == "y" ]]
}

echo "=== Dotfiles Installer ==="
echo ""

# Always run symlinks
echo "Setting up symlinks..."
"$DOTFILES_DIR/scripts/setup-symlinks.sh"
echo ""

# Optional: system packages
if ask "Install system packages? (requires sudo)"; then
    "$DOTFILES_DIR/scripts/setup-packages.sh"
    echo ""
fi

# Optional: language runtimes
if ask "Install pyenv for Python version management?"; then
    "$DOTFILES_DIR/scripts/setup-languages.sh"
    echo ""
fi

echo "=== Done! ==="
