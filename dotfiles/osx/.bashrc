: '
  dannykansas .bashrc dotfile
 
   .bash_profile loads (in this order):
        - .bashrc (you are here!)
        - .profile 
        - .bash_profile

  More at: https://github.com/dannykansas/edu
'
# brew sometimes throws stuff in sbin
# TODO: cleanup or leave; MacPorts already prepends this to the path in .bash_profile
export PATH=$PATH:/usr/local/sbin

# cache pip-installed packages to avoid re-downloading
# export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# ---------------------------
#  specific completion loaders
# ---------------------------

# kubectl
# source <(kubectl completion bash)

# ----------------------
# make ssh life easier
# ----------------------

## use my aws key with ssh
opssh(){
   ssh -o "IdentitiesOnly=yes" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ~/.ssh/ops_rsa ec2-user@"$@"
}

hadoopssh(){
   ssh -o "IdentitiesOnly=yes" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ~/.ssh/ops_rsa ec2-user@"$@"
}

## use GCE key with ssh
gssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine.pem "$@"
}

# ----------------------
#   git flow shortcuts
# ----------------------

gc(){
  git commit -am "$@"
}
gs(){
  git status
}
ga(){
  git add .
}
gp(){
  git pull
}

# --------------------
#   git subtree funcs
# --------------------

git-all-subtrees(){
  git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq
}

git-active-subtrees(){
  git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi'
}

# -------------------
#  golang setup
# -------------------
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# -------------------
#  alias grab bag
# -------------------
alias ll="ls -la"
alias wifidown="networksetup -setairportpower Wi-Fi off"
alias wifiup="networksetup -setairportpower Wi-Fi on"
alias dsa='docker stop `docker ps -q`'
alias dcl='docker stop `docker ps -aq` && docker rm `docker ps -aq`'
 
# find D&I terms
alias grep_di="grep -rnw 'master\|slave\|whitelist\|blacklist' ./*"

# prepend pyenv shims to path
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

# -------------------
#  aws related funcs
# -------------------

# aws shortcuts for multiple accounts
alias aws_dsp="export AWS_DEFAULT_PROFILE=dsp && export AWS_PROFILE=dsp"
alias aws_growlabs="export AWS_DEFAULT_PROFILE=growlabs && export AWS_PROFILE=growlabs"
alias aws_bi="export AWS_DEFAULT_PROFILE=bi && export AWS_PROFILE=bi"
alias aws_adroll="unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE"

# find out who i am for aws
alias aws_whoami="aws sts get-caller-identity"

# connect to an instance by id
# stolen from: http://travisjeffery.com/b/2015/11/ssh-into-ec2-instances-by-instance-id/
function ec2-ssh () {
  ssh $(aws ec2 describe-instances --filter Name=instance-id,Values=$1 | jq '.Reservations[0].Instances[0].PrivateIpAddress' | tr -d '"')
}

function ecr-login () {
  aws ecr get-login --region us-west-2 --no-include-email
}

# ----------------------------
#  terraform helper functions
# ----------------------------
alias tfapply="terraform apply"
alias tfplan="terraform plan"

alias twsp='terraform workspace select production'
alias twss='terraform workspace select staging'
alias twsd='terraform workspace select default'

# ----------------------------
#  vscode helper functions
# ----------------------------
# create the vscode tmux session
alias newvsmux="tmux new -s vscode"
# attach to my default vscode session
alias vsmux="tmux attach -t vscode"

# ---------------------------
#  banyan setup helpers
# ---------------------------
HOLOGRAM_PATH="/Library/LaunchDaemons/com.adroll.hologram.plist"
alias reload_hologram="sudo launchctl unload ${HOLOGRAM_PATH} && sudo launchctl load ${HOLOGRAM_PATH}"
