#!/bin/bash
echo "Creating symlinks for dotfiles..."

dotfiles=('.zshrc' '.zprofile' '.zsh.d/' '.zsh.d/aliases.zsh')

for each in ${dotfiles[*]}; do
  if [ -L ${HOME}/$each ]
  then
    echo "Skipping ${HOME}/$each as it already exists"
  else 
    echo ${HOME}/$each
  fi
done

VRC=".vimrc"
TMX=".tmux.conf"
GIT=".git-completion.bash"
