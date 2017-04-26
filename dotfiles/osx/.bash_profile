# dannykansas' OS X .bash_profile
# Public stuff goes here, 
# private stuff goes in .profile

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:$PATH

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

# Load .profile if it exists
test -f ~/.profile && source ~/.profile

# Source bash completion if it exists
# (if not, you can run 'brew install bash-completion' as remedy
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

# Turn on terminal colors and username/path highlighting
export TERM="xterm-color" 
export PS1='\[\e[0;31m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# The next line updates PATH for the Google Cloud SDK.
if [ -e ${HOME}/google-cloud-sdk/path.bash.inc ]
  then
    source "${HOME}/google-cloud-sdk/path.bash.inc"
fi 

# The next line enables shell command completion for gcloud.
if [ -e ${HOME}/google-cloud-sdk/completion.bash.inc ]
  then
    source "${HOME}/google-cloud-sdk/completion.bash.inc"
fi
