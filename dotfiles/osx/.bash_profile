: '
  dannykansas .bash_profile dotfile (macOS)

    .bash_profile loads (in this order):
        - .bashrc
        - .profile
        - .bash_profile (you are here!)
  
  More at: https://github.com/dannykansas/edu
'

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

# Load .profile if it exists
test -f ~/.profile && source ~/.profile

# Source bash completion (v1) if it exists
# (if not, you can run 'brew install bash-completion' as remedy)
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    # general bash completion
    source $(brew --prefix)/etc/bash_completion
fi

# Source general bash completion (v2) if exists
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Turn on terminal colors and username/path highlighting
export TERM="xterm-color" 
export PS1='\[\e[0;31m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# Turn on CLICOLORS and LSCOLORS
export CLICOLOR=1

# Source AWS bash completion if aws_completer exists in
# the current pyenv shims
# if [ -f ~/.pyenv/shims/aws_completer ]; then
#  complete -C '~/.pyenv/shims/aws_completer' aws
# fi

# Use git autocompletion, if it exists
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# stop Catalina zsh prompt annoyances
export BASH_SILENCE_DEPRECATION_WARNING=1

###
# 
# TESTBED:
#   Keep the clutter out of above, unvetted additions go below.
#
###

## MacPorts path prefix (required for: gnuradio sdr) 
# export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

## Add sqlite to path
# export PATH="/usr/local/opt/sqlite/bin:$PATH"

## iterm shell integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
