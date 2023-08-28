alias gs="git status"
alias ll="ls -la"
alias tx="tmux attach -d"
# attach to a named session, like "tx-named remote_sesh"
alias tx-named="tmux attach-session -t ${@}"
# Start an SSM session for instance name provided
alias ssm-start="aws ssm start-session --target ${@}"
