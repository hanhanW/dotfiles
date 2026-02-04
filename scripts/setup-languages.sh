#!/usr/bin/env bash
# Install pyenv - no admin required
set -e

echo "Language runtime setup (pyenv)"
echo ""

# pyenv
if [[ ! -d ~/.pyenv ]]; then
    echo "Installing pyenv..."
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
    echo "pyenv already installed"
fi

echo ""
echo "Done! Add to your shell config if not already present:"
echo '  export PYENV_ROOT="$HOME/.pyenv"'
echo '  export PATH="$PYENV_ROOT/bin:$PATH"'
echo '  eval "$(pyenv init -)"'
