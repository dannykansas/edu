echo "Creating symbolic links for dotfiles..."

BPR=".bash_profile"
BRC=".bashrc"
VRC=".vimrc"

BPR_SOURCE=${PWD}/${BPR}
BRC_SOURCE=${PWD}/${BRC}
VRC_SOURCE=${PWD}/${VRC}

BPR_DEST=${HOME}/${BPR}
BRC_DEST=${HOME}/${BRC}
VRC_DEST=${HOME}/${VRC}

if [ -L $BPR_DEST ]
then
  echo "${BPR} already exists!"
else
  ln -s $BPR_SOURCE $BPR_DEST || echo "Failed to create .bash_profile"
  if [ -L $BPR_DEST ]
  then
    echo "${BPR} created successfully."
  fi
fi

if [ -L $BRC_DEST ]
then
  echo "${BRC} already exists!"
else
  ln -s $BRC_SOURCE $BRC_DEST || echo "Failed to create .bashrc"
  if [ -L $BRC_DEST ]
  then
    echo "${BRC} created successfully."
  fi
fi

if [ -L $VRC_DEST ]
then
  echo "${VRC} already exists!"
else
  ln -s $VRC_SOURCE $VRC_DEST || echo "Failed to create .vimrc"
  if [ -L $VRC_DEST ]
  then
    echo "${VRC} created successfully."
  fi
fi
