#!/usr/bin/env bash
# Install user-local CLI tools that aren't packaged by apt
# No admin required - everything installs under $HOME
set -e

echo "CLI tool setup"
echo ""

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
    trap 'rm -f "$tmp_installer"' EXIT
    curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh" \
        -o "$tmp_installer"
    bash "$tmp_installer" --skip-skills --no-gum
else
    echo "br already installed ($(br --version 2>/dev/null || echo unknown))"
fi

echo ""
echo "Done!"
