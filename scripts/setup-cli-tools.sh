#!/usr/bin/env bash
# Install user-local CLI tools that aren't packaged by apt
# No admin required - everything installs under $HOME
set -e

INSTALL_DIR="${LOCAL_BIN_DIR:-$HOME/.local/bin}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
tmp_paths=()

cleanup() {
    if [[ ${#tmp_paths[@]} -gt 0 ]]; then
        rm -rf "${tmp_paths[@]}"
    fi
}
trap cleanup EXIT

echo "CLI tool setup"
echo ""

mkdir -p "$INSTALL_DIR"

install_br() {
    local tmp_installer

    # br (beads_rust) - local-first issue tracker
    # https://github.com/Dicklesworthstone/beads_rust
    #
    # --skip-skills: we manage Claude Code/Codex skills via claude-workspace,
    #                so we don't want the installer dropping skills into
    #                ~/.claude/skills or ~/.codex/skills.
    # --no-gum:      skip the optional gum TUI dep (would prompt for sudo on apt).
    if ! command -v br >/dev/null 2>&1; then
        echo "Installing br (beads issue tracker)..."
        tmp_installer=$(mktemp)
        tmp_paths+=("$tmp_installer")
        curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh" \
            -o "$tmp_installer"
        bash "$tmp_installer" --skip-skills --no-gum
    else
        echo "br already installed ($(br --version 2>/dev/null || echo unknown))"
    fi
}

ripgrep_asset_pattern() {
    case "$(uname -s)-$(uname -m)" in
        Linux-x86_64) echo "x86_64-unknown-linux-musl.tar.gz" ;;
        Linux-aarch64|Linux-arm64) echo "aarch64-unknown-linux-gnu.tar.gz" ;;
        Darwin-x86_64) echo "x86_64-apple-darwin.tar.gz" ;;
        Darwin-arm64) echo "aarch64-apple-darwin.tar.gz" ;;
        *)
            echo "Error: unsupported platform for rg installer: $(uname -s) $(uname -m)" >&2
            return 1
            ;;
    esac
}

install_rg() {
    local bin="$INSTALL_DIR/rg"
    local existing_rg
    local asset_pattern
    local release_json
    local asset_url
    local tmp_dir
    local archive
    local extracted_rg

    if [[ -x "$bin" ]]; then
        echo "rg already installed ($("$bin" --version 2>/dev/null | head -n 1 || echo unknown))"
        return
    fi

    existing_rg="$(command -v rg 2>/dev/null || true)"
    if [[ -n "$existing_rg" ]]; then
        echo "rg found at $existing_rg; installing user-local copy to $bin"
    else
        echo "Installing rg (ripgrep)..."
    fi

    asset_pattern="$(ripgrep_asset_pattern)"
    release_json="$(curl -fsSL "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest")"
    asset_url="$(
        printf '%s\n' "$release_json" |
            sed -n 's/.*"browser_download_url": "\(.*'"$asset_pattern"'\)".*/\1/p' |
            head -n 1
    )"

    if [[ -z "$asset_url" ]]; then
        echo "Error: could not find ripgrep release asset matching $asset_pattern" >&2
        exit 1
    fi

    tmp_dir=$(mktemp -d)
    tmp_paths+=("$tmp_dir")
    archive="$tmp_dir/ripgrep.tar.gz"

    curl -fsSL "$asset_url" -o "$archive"
    tar -xzf "$archive" -C "$tmp_dir"

    extracted_rg="$(find "$tmp_dir" -type f -name rg | head -n 1)"
    if [[ -z "$extracted_rg" ]]; then
        echo "Error: ripgrep archive did not contain an rg binary" >&2
        exit 1
    fi

    install -m 0755 "$extracted_rg" "$bin"
    mkdir -p "$STATE_DIR"
    printf '%s\n' "$bin" > "$STATE_DIR/rg-installed"
    echo "Installed rg to $bin ($("$bin" --version 2>/dev/null | head -n 1 || echo unknown))"
}

install_br
echo ""
install_rg

echo ""
echo "Done!"
