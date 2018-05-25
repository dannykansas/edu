# Setup local profile
# 
# This script will check for and install if the following do not exist:
#   - tmux plugin manager (https://github.com/tmux-plugins/tpm)
#   - install dotfiles

if [ ! -d "~/.tmux/plugins/tpm" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir -p ~/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

./create_links.sh
