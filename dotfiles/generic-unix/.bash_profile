# dannykansas' OS X .bash_profile
# Public stuff goes here, 
# private stuff goes in .profile

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

# Load .profile if it exists
test -f ~/.profile && source ~/.profile

# Alias definitions.
# Put all your additions into a separate file like ~/.bash_aliases
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
test -f ~/.bash_aliases && source ~/.bash_aliases

# Alternative syntax for testing existence then loading
#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

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
export PATH="${PATH}:/usr/local/go/bin"

# Source AWS bash completion if aws_completer exists
if [ -f /usr/local/bin/aws_completer ]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# Use git autocompletion, if it exists
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
