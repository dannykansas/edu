: '
  dannykansas .bashrc dotfile
 
   .bash_profile loads:
        - .bashrc (you are here!)
        - .profile 

  More at: https://github.com/dannykansas/edu
'
eval "$(pyenv init -)"

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# ----------------------
# make ssh life easier!
# ----------------------

## use my aws key with ssh
opssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/ops_rsa ec2-user@"$@"
}

## use GCE key with ssh
gssh(){
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine.pem "$@"
}

# ----------------------
#   git flow shortcuts!
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

# I probably shouldn't have this as a shortcut... hmm.
gpush(){
  git commit -am "$@" && git push
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

# node version manager setup
export NVM_DIR="/Users/${USER}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # This actually loads nvm

# ensure correct GOPATH
export GOPATH="${HOME}/repos/edu/go"

## And random aliases (alii? - ha!) go here:
alias ll="ls -la"

