eval "$(/opt/homebrew/bin/brew shellenv)"

# github-safe auth (doesn't leak account ID) to ECR
_ecr_login(){
  docker login -u AWS -p $(aws ecr get-login-password) https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-west-2.amazonaws.com
}

# Add devtools to $PATH
export PATH="/opt/devtools:$PATH"

# Add python alias for macOS 12.3+
#alias python=/opt/homebrew/bin/python3

# Add our key to ssh-agent if not already present
#  - ensures errors are emitted
#  - prevents expected "No keychain exists" errors when accessing this host from SSH
if [ -z "$SSH_CONNECTION" ]; then
  ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/id_rsa  | awk '{print $2}'` || ssh-add --apple-use-keychain ~/.ssh/id_rsa 
fi
