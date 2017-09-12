#!/bin/bash

source setup/utils.sh

sudo apt-get -y install build-essential
sudo apt-get -y install cmake
sudo apt-get -y install htop
command -v zsh >/dev/null 2>&1 || sudo apt-get -y install zsh
command -v tmux >/dev/null 2>&1 || sudo apt-get -y install tmux
command -v vim >/dev/null 2>&1 || sudo apt-get -y install vim
command -v cmake >/dev/null 2>&1 || sudo apt-get -y install cmake

# for building python / ruby
sudo apt-get -y install libssl-dev libreadline-dev libbz2-dev libsqlite3-dev libffi-dev zlib1g-dev wget curl llvm libncurses5-dev libncursesw5-dev

echo

# rbenv
if [[ ! -d ~/.rbenv ]]; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  # Build optional dynamic bash extension to speed up.
  ~/.rbenv/src/configure && make -C ~/.rbenv/src/
fi

# pyenv
if [[ ! -d ~/.pyenv ]]; then
  git clone git://github.com/yyuu/pyenv.git ~/.pyenv
  git clone https://github.com/yyuu/pyenv-which-ext.git ~/.pyenv/plugins/pyenv-which-ext
fi

cmds=()
IFS=$'\n' pythons=(`~/.pyenv/bin/pyenv versions --bare`)

# install ruby?
LATEST_RUBY2=`~/.rbenv/bin/rbenv install -l | awk '$1~/^2[.0-9]+$/{print $1}' | tail -n 1`
if ! ask_skip "Install ruby $LATEST_RUBY2"; then
  # Install latest ruby in rbenv!
  cmds+=("Installing ruby $LATEST_RUBY2" "$HOME/.rbenv/bin/rbenv install $LATEST_RUBY2")
  cmds+=("Setting ruby global $LATEST_RUBY2" "$HOME/.rbenv/bin/rbenv global $LATEST_RUBY2" )
fi

# install python2?
LATEST_PYTHON2=`~/.pyenv/bin/pyenv install -l | awk '$1~/^2[.0-9]+$/{print $1}' | tail -n 1`
if ! ask_skip "Install python $LATEST_PYTHON2"; then
  # Install latest python2 in pyenv!
  cmds+=("Installing python $LATEST_PYTHON2" "env PYTHON_CONFIGURE_OPTS=--enable-shared $HOME/.pyenv/bin/pyenv install $LATEST_PYTHON2")
  pythons+=($LATEST_PYTHON2)
fi

# install python3?
LATEST_PYTHON3=`~/.pyenv/bin/pyenv install -l | awk '$1~/^3[.0-9]+$/{print $1}' | tail -n 1`
if ! ask_skip "Install python $LATEST_PYTHON3"; then
  # Install latest python3 in pyenv!
  cmds+=("Installing python $LATEST_PYTHON3" "env PYTHON_CONFIGURE_OPTS=--enable-shared $HOME/.pyenv/bin/pyenv install $LATEST_PYTHON3")
  pythons+=($LATEST_PYTHON3)
fi

# Prefer python2 as global
if [[ ${#pythons[@]} -ne 0 ]]; then
  IFS=$'\n' pythons=($(sort <<<"${pythons[*]}"))
  global_version=${pythons[-1]}
	for version in ${pythons[@]}; do
    [[ $version =~ ^2 ]] && global_version=$version
	done
  cmds+=("Setting python global $global_version" "$HOME/.pyenv/bin/pyenv global $global_version" )
fi

echo -e "\n\e[1;33mGo!\e[m"
for (( i=0 ; i<"${#cmds[@]}" ; i+=2 )) do
  name=${cmds[i]}
  cmd=${cmds[i+1]}
  echo -e "\e[1;32m${name}\e[m"
  echo -e "\e[1;34m${cmd}\e[m"
  eval $cmd
  echo
done

echo -e "\e[1;33mFinished!\e[m"
