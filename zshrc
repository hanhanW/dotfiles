# vim: syntax=zsh:

# KEY {{{

zle-line-init () {
    (( ${+terminfo[smkx]} )) && echoti smkx
}

zle-line-finish () {
    (( ${+terminfo[rmkx]} )) && echoti rmkx
}

zle -N zle-line-init
zle -N zle-line-finish

bindkey -e

typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Home]}"     ]] && bindkey "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]] && bindkey "${key[End]}"      end-of-line
[[ -n "${key[Delete]}"   ]] && bindkey "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]] && bindkey "${key[Up]}"       up-line-or-search
[[ -n "${key[Down]}"     ]] && bindkey "${key[Down]}"     down-line-or-search
[[ -n "${key[Left]}"     ]] && bindkey "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]] && bindkey "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   backward-word
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" forward-word

# }}}

# EXPORT {{{

export EDITOR=vim
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GREP_COLOR='1;32'
export PAGER='less'
export LESS='-R'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export TERM=screen-256color
# }}}

# prompt {{{

precmd() {
    psvar=()
    local git_head=((../)#.git/HEAD([1]N))
    [[ -n $git_head ]] && psvar[1]=${"$(< "$git_head")"##*/}
}


PS1=""
PS1+='%{%F{118}%}[%*] '
PS1+='%F{81}%n%f'
PS1+=' at %F{135}%m%f'
PS1+=' in %F{226}%~%f'
PS1+='%(1V. %F{243}%1v%f.)'
PS1+='%(2V. %F{180}%2v%f.)'
PS1+=$'\n'
PS1+='%(?.%F{231}.%F{196})%(!.#.❯)%f '

# }}}

# OPT {{{

HISTFILE=~/.histfile
HISTSIZE=65536
SAVEHIST=65536

setopt always_to_end
setopt append_history
setopt auto_name_dirs
setopt auto_pushd
setopt autocd
setopt complete_in_word
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_lex_words
setopt inc_append_history
setopt interactivecomments
setopt mark_dirs
setopt menu_complete
setopt multios
setopt prompt_subst
setopt pushd_ignore_dups
setopt pushd_minus

autoload -Uz compinit
compinit

{
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# }}}

# ALIAS {{{

if ls --color -d . &>/dev/null 2>&1; then
    alias ls='ls --color=auto'
  else
    alias ls='ls -G'
fi

alias vi='vim'
alias l='ls -F'
alias ll='ls -lhF'
alias la='ls -lhaF'
alias cls='clear'
alias grep='grep --color=auto' 
alias objdump='objdump -M intel'
alias p1='ssh bbsu@ptt.cc'
alias p2='ssh bbsu@ptt2.cc'
# }}}

# OTHER {{{

path=(
    ~/bin
    $HOME/.rbenv/bin
    $HOME/.rbenv/shims
    $HOME/.pyenv/bin
    $HOME/.pyenv/shims
    /usr/local/bin
    /usr/local/sbin
    $path
)

rbenv() { eval "$(command rbenv init -)" && rbenv "$@"; }
pyenv() { eval "$(command pyenv init -)" && pyenv "$@"; }

# }}}

