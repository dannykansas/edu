# pip should only run if there is a virtualenv currently activated
#export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
#export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
# allow override of pip virtualenv lock
gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

## use my aws key with ssh
awssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/aws_ubuntu.pem ubuntu@"$@"
}

## use global aws key with ssh
vmissh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/vmi-global.pem ubuntu@"$@"
}

## use my GCE key with ssh
gssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine.pem "$@"
}

## quick git commit with message
gc(){
  git commit -am "$@"
}

## quick git status
gs(){
  git status
}

## quick git add everything here
ga(){
  git add .
}

## quick git commit, and push origin master
gp(){
  git commit -am "$@" && git push
}

# node version manager setup
export NVM_DIR="/Users/${USER}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # This actually loads nvm

# ensure correct GOPATH
export GOPATH="${HOME}/repos/edu/go"

## And random aliases (alii? - ha!) go here:
alias ll="ls -la"

