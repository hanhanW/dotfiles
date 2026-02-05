#!/usr/bin/env bash
# Create symlinks for dotfiles - no admin required
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Create symlink, backing up existing files
link() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dst")"

    # Handle existing files/symlinks
    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        warn "Backing up: $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    info "Linked: $dst → $src"
}

# Update vim-plug submodule
if [[ -f "$DOTFILES_DIR/.gitmodules" ]]; then
    git -C "$DOTFILES_DIR" submodule update --init --recursive
fi

# Create symlinks
# Shell
link config/zshrc ~/.zshrc

# Editors
link config/nvim ~/.config/nvim
link config/vimrc ~/.vimrc
link modules/vim-plug/plug.vim ~/.vim/autoload/plug.vim
link config/ycm_extra_conf.py ~/.ycm_extra_conf.py

# Tools
link bin ~/bin/common
link config/ghostty ~/.config/ghostty/config
link config/tmux.conf ~/.tmux.conf
link config/gitconfig ~/.gitconfig
link config/gitignore_global ~/.gitignore_global
link config/gdbinit ~/.gdbinit
link config/gdb ~/.gdb
link config/pryrc ~/.pryrc

echo ""
info "Symlinks created successfully!"
