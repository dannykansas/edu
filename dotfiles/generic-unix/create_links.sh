echo "Creating symbolic links for dotfiles..."

BAL=".bash_aliases"
BPR=".bash_profile"
BRC=".bashrc"
VRC=".vimrc"
TMX=".tmux.conf"
GIT=".git-completion.bash"

BAL_SOURCE=${PWD}/${BAL} # .bash_aliases
BPR_SOURCE=${PWD}/${BPR} # .bash_profile
BRC_SOURCE=${PWD}/${BRC} # .bashrc
VRC_SOURCE=${PWD}/${VRC} # .vimrc
TMX_SOURCE=${PWD}/${VRC} # .tmux.conf
GIT_SOURCE=${PWD}/${GIT} # .git-completion.bash

BAL_DEST=${HOME}/${BAL} # .bash_aliases
BPR_DEST=${HOME}/${BPR} # .bash_profile
BRC_DEST=${HOME}/${BRC} # .bashrc
VRC_DEST=${HOME}/${VRC} # .vimrc
TMX_DEST=${HOME}/${TMX} # .tmux.conf
GIT_DEST=${HOME}/${GIT} # .git-completion.bash


if [ -L $BAL_DEST ]
then
  echo "${BAL} already exists!"
else
  ln -s $BAL_SOURCE $BAL_DEST || echo "Failed to create ${BAL}"
  if [ -L $BAL_DEST ]
  then
    echo "${BAL} created successfully."
  fi
fi


if [ -L $BPR_DEST ]
then
  echo "${BPR} already exists!"
else
  ln -s $BPR_SOURCE $BPR_DEST || echo "Failed to create ${BPR}"
  if [ -L $BPR_DEST ]
  then
    echo "${BPR} created successfully."
  fi
fi

if [ -L $BRC_DEST ]
then
  echo "${BRC} already exists!"
else
  ln -s $BRC_SOURCE $BRC_DEST || echo "Failed to create ${BRC}"
  if [ -L $BRC_DEST ]
  then
    echo "${BRC} created successfully."
  fi
fi

if [ -L $VRC_DEST ]
then
  echo "${VRC} already exists!"
else
  ln -s $VRC_SOURCE $VRC_DEST || echo "Failed to create ${VRC}"
  if [ -L $VRC_DEST ]
  then
    echo "${VRC} created successfully."
  fi
fi

if [ -L $TMX_DEST ]
then
  echo "${TMX} already exists!"
else
  ln -s $TMX_SOURCE $TMX_DEST || echo "Failed to create ${TMX}"
  if [ -L $TMX_DEST ]
  then
    echo "${TMX} created successfully."
  fi
fi

if [ -L $GIT_DEST ]
then
  echo "${GIT} already exists!"
else
  ln -s $GIT_SOURCE $GIT_DEST || echo "Failed to create ${GIT}"
  if [ -L $GIT_DEST ]
  then
    echo "${GIT} created successfully."
  fi
fi
