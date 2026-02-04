#!/usr/bin/env bash
# Install system packages - REQUIRES ADMIN
set -e

if [[ $EUID -eq 0 ]]; then
    echo "Error: Don't run as root, script will use sudo as needed"
    exit 1
fi

echo "Installing system packages..."

sudo apt-get update
sudo apt-get install -y build-essential cmake htop

# Only install if not present
command -v zsh  >/dev/null 2>&1 || sudo apt-get install -y zsh
command -v tmux >/dev/null 2>&1 || sudo apt-get install -y tmux
command -v vim  >/dev/null 2>&1 || sudo apt-get install -y vim

echo "Packages installed!"
