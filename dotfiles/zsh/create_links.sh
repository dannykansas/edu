#!/bin/bash
echo "Creating symlinks for dotfiles..."

dotfiles=('.zshrc' '.zprofile' '.zsh.d/' '.zsh.d/aliases.zsh')

for each in ${dotfiles[*]}; do
  echo ${HOME}/$each
done

VRC=".vimrc"
TMX=".tmux.conf"
GIT=".git-completion.bash"
