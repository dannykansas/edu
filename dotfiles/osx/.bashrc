# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
# allow override of pip virtualenv lock
gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# docker-compose
dc(){
  docker-compose "$@"
}

## use my aws key with ssh
awssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/aws_ubuntu.pem ubuntu@"$@"
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

# add Haskell to path
PATH=/Users/${USER}/Library/Haskell/bin:$PATH

## And random aliases (alii? - ha!) go here:
alias ll="ls -la"
