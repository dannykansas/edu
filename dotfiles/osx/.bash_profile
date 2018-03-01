# dannykansas' OS X .bash_profile
# Public stuff goes here, 
# private stuff goes in .profile

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

# Load .profile if it exists
test -f ~/.profile && source ~/.profile

# Source bash completion if it exists
# (if not, you can run 'brew install bash-completion' as remedy
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    # general bash completion
    source $(brew --prefix)/etc/bash_completion
    # kubectl bash completion
    source <(kubectl completion bash)
fi

# Turn on terminal colors and username/path highlighting
export TERM="xterm-color" 
export PS1='\[\e[0;31m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# Update PATH for the Google Cloud SDK.
if [ -e ${HOME}/google-cloud-sdk/path.bash.inc ];
  then
    source "${HOME}/google-cloud-sdk/path.bash.inc"
fi 

# Enable shell command completion for gcloud.
if [ -e ${HOME}/google-cloud-sdk/completion.bash.inc ]
  then
    source "${HOME}/google-cloud-sdk/completion.bash.inc"
fi

# add golang binaries to path
# TODO: this is being added earlier in the path by... something. Find the culprit
export PATH="${PATH}:/usr/local/go/bin"

# add awscli to PATH
PATH="${PATH}:${HOME}/Library/Python/3.6/bin"

# Source AWS bash complete if aws_completer exists
if [ -f /usr/local/bin/aws_completer ]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# Use git autocompletion, if it exists
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
