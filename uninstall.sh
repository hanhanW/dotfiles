#!/usr/bin/env bash
# Remove symlinks and user-local tools created by the dotfiles installer
# No admin required
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

is_under_home() {
    local path="$1"
    [[ "$path" == "$HOME"/* ]]
}

# Remove a symlink only when it points to the expected file in this repository.
unlink_dotfile() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"
    local target

    if [[ ! -e "$dst" && ! -L "$dst" ]]; then
        warn "Missing: $dst"
        return
    fi

    if [[ ! -L "$dst" ]]; then
        warn "Skipping non-symlink: $dst"
        return
    fi

    target="$(readlink "$dst")"
    if [[ "$target" != "$src" ]]; then
        warn "Skipping symlink with unexpected target: $dst -> $target"
        return
    fi

    rm "$dst"
    info "Removed: $dst"
}

cleanup_beads_rc_lines() {
    local rc

    for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.config/fish/config.fish"; do
        if [[ ! -f "$rc" ]]; then
            continue
        fi

        if ! grep -q "# br installer" "$rc" 2>/dev/null; then
            continue
        fi

        if [[ -L "$rc" ]]; then
            warn "Skipping br rc cleanup for symlink: $rc"
            continue
        fi

        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/# br installer/d' "$rc" 2>/dev/null || true
        else
            sed -i '/# br installer/d' "$rc" 2>/dev/null || true
        fi
        info "Cleaned br installer lines from: $rc"
    done
}

remove_beads() {
    local binary_name="br"
    local dest="${BR_INSTALL_DIR:-$HOME/.local/bin}"
    local bin
    local active_br

    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) binary_name="br.exe" ;;
    esac

    if ! is_under_home "$dest"; then
        warn "Skipping beads install dir outside HOME: $dest"
        return
    fi

    bin="$dest/$binary_name"

    if [[ -e "$bin" || -L "$bin" ]]; then
        rm -f "$bin"
        info "Removed beads CLI: $bin"
    else
        info "beads CLI not found at: $bin"
    fi

    cleanup_beads_rc_lines
    hash -r 2>/dev/null || true

    active_br="$(command -v "$binary_name" 2>/dev/null || true)"
    if [[ -n "$active_br" && "$active_br" != "$bin" ]]; then
        warn "br still found elsewhere, leaving it untouched: $active_br"
    fi
}

remove_ripgrep() {
    local marker="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/rg-installed"
    local bin="${LOCAL_BIN_DIR:-$HOME/.local/bin}/rg"
    local marked_bin

    if [[ ! -f "$marker" ]]; then
        info "rg install marker not found; leaving rg untouched"
        return
    fi

    marked_bin="$(sed -n '1p' "$marker" 2>/dev/null || true)"
    if [[ -n "$marked_bin" ]]; then
        bin="$marked_bin"
    fi

    if ! is_under_home "$bin"; then
        warn "Skipping rg install path outside HOME: $bin"
        return
    fi

    if [[ -e "$bin" || -L "$bin" ]]; then
        rm -f "$bin"
        info "Removed rg: $bin"
    else
        info "rg not found at: $bin"
    fi

    rm -f "$marker"
    hash -r 2>/dev/null || true
}

echo "=== Dotfiles Uninstaller ==="
echo ""

# Shell
unlink_dotfile config/zshrc "$HOME/.zshrc"

# Editors
unlink_dotfile config/nvim "$HOME/.config/nvim"
unlink_dotfile config/vimrc "$HOME/.vimrc"
unlink_dotfile modules/vim-plug/plug.vim "$HOME/.vim/autoload/plug.vim"
unlink_dotfile config/ycm_extra_conf.py "$HOME/.ycm_extra_conf.py"

# Tools
unlink_dotfile bin "$HOME/bin/common"
unlink_dotfile config/ghostty "$HOME/.config/ghostty/config"
unlink_dotfile config/tmux.conf "$HOME/.tmux.conf"
unlink_dotfile config/gitconfig "$HOME/.gitconfig"
unlink_dotfile config/gitignore_global "$HOME/.gitignore_global"
unlink_dotfile config/gdbinit "$HOME/.gdbinit"
unlink_dotfile config/gdb "$HOME/.gdb"
unlink_dotfile config/pryrc "$HOME/.pryrc"

echo ""
info "Removing user-local CLI tools..."
remove_beads
remove_ripgrep

echo ""
info "Uninstall complete!"
