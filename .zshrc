#
#            _
#    _______| |__
#   |_  / __| '_ \
#    / /\__ \ | | |
#   /___|___/_| |_|
#
#
# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/$USER/.zshrc'

# default path conf
export PATH=$PATH:/bin:/usr/bin:/home/$USER/.local/bin
# additional paths
export PATH=$PATH:/usr/lib/jvm/java-17-openjdk/bin:$HOME/.config/composer/vendor/bin:$HOME/.cargo/bin:$HOME/node_modules/.bin/
export PATH="$HOME/neovim/bin:$PATH"

export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' gain-privileges 1
bindkey '^[[Z' reverse-menu-complete

# SSH
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent -s) &> /dev/null
    ssh-add ~/.ssh/gitea_key &> /dev/null
fi

# ---- Git ---- #

# autoload vcs and colors
autoload -Uz vcs_info
autoload -U colors && colors

# enable only git 
zstyle ':vcs_info:*' enable git 

# setup a hook that runs before every ptompt. 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# add a function to check for untracked files in the directory.
# from https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# 
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})"

# ------------- #

setopt share_history

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

if [[ "$(uname -s)" == "Linux" && -f "/etc/os-release" ]]; then
    source /etc/os-release
    if [[ "$NAME" == "Ubuntu" ]]; then
        bindkey "$key[Up]" up-line-or-beginning-search # Up
        bindkey "$key[Down]" down-line-or-beginning-search # Down
    elif [[ "$NAME" == "Arch Linux" ]]; then
        bindkey "^[[A" up-line-or-beginning-search # Up
        bindkey "^[[B" down-line-or-beginning-search # Down
    fi
fi

# aliases 

alias ls='ls --color=auto'
alias v='vim'
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CF'
alias lt='ls -altrh'
alias rm='rm -I'
alias md='mkdir'

if [ -r ~/.zsh/aliases ]; then
  source ~/.zsh/aliases
fi

function webtitle {
    echo $(wget -qO- "$1" |
        perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si')
}

function last_x {
    if [ -z "$2" ]; then
        last_index=$(($1))
    else
        last_index=$(($2+$(($1-1))))
    fi
    for i in {$1..$last_index}
    do
        echo $(ls -At | sed -n "$i"p) 
    done
}

function order {
    count=1
    for file in *.png; do
        if [ -f "$file" ]; then
            tmp_name="tmp_${count}.png"
            mv "$file" "$tmp_name"
            ((count++))
        fi
    done
    count=1
    for file in *.png; do
        if [ -f "$file" ]; then
            new_name="$1_${count}.png"
            mv "$file" "$new_name"
            ((count++))
        fi
    done
}

export PAGER=""

# prompt 
PS1='%F{yellow}[%F{red}%n%f%F{yellow}@%F{cyan}%m%f %F{blue}%B%~%b%f%F{yellow}]%F{white}${vcs_info_msg_0_} > '

# plugins 
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

