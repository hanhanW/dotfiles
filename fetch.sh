#!/usr/bin/env bash
# Bootstrap dotfiles on a new machine
set -e

if ! command -v git >/dev/null 2>&1; then
    echo "git not installed. Please install git first."
    exit 1
fi

git clone https://github.com/hanhanW/dotfiles ~/dotfiles
cd ~/dotfiles
git remote set-url --push origin git@github.com:hanhanW/dotfiles.git
./install.sh
