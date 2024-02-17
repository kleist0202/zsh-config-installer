#!/bin/bash

sudo apt install -y git zsh

cp ./.zshrc ~/.

CACHE_DIR=~/.cache/zsh
PLUGINS_DIR=~/.zsh

mkdir -p $CACHE_DIR
touch $CACHE_DIR/.histfile

mkdir -p $PLUGINS_DIR
cp aliases $PLUGINS_DIR

cd $PLUGINS_DIR

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source $PWD/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

git clone https://github.com/zsh-users/zsh-completions.git
echo "fpath=($PWD/zsh-completions/src \$fpath)" >> ${ZDOTDIR:-$HOME}/.zshrc
rm -f ~/.zcompdump; compinit

git clone https://github.com/zsh-users/zsh-autosuggestions
echo "source $PWD/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
