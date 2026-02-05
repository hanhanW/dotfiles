# Dotfiles

Personal dotfiles managed with simple shell scripts.

## Quick Install

```sh
bash <(curl -s https://raw.githubusercontent.com/hanhanW/dotfiles/main/fetch.sh)
```

Or manually:

```sh
git clone https://github.com/hanhanW/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's Included

- **Shell**: zsh configuration
- **Editors**: vim, neovim
- **Terminal**: ghostty
- **Tools**: tmux, git, gdb
- **Scripts**: personal bin directory

## Scripts

| Script | Description |
|--------|-------------|
| `install.sh` | Main installer (symlinks only by default) |
| `scripts/setup-symlinks.sh` | Create all dotfile symlinks |
| `scripts/setup-packages.sh` | Install apt packages (optional, requires sudo) |
| `scripts/setup-languages.sh` | Install pyenv (optional, no admin) |

## Symlinks Created

```
~/.zshrc           → config/zshrc
~/.config/nvim     → config/nvim
~/.vimrc           → config/vimrc
~/.vim/autoload/plug.vim → modules/vim-plug/plug.vim
~/.ycm_extra_conf.py → config/ycm_extra_conf.py
~/bin/common       → bin/
~/.config/ghostty/config → config/ghostty
~/.tmux.conf       → config/tmux.conf
~/.gitconfig       → config/gitconfig
~/.gitignore_global → config/gitignore_global
~/.gdbinit         → config/gdbinit
~/.gdb             → config/gdb
~/.pryrc           → config/pryrc
```
