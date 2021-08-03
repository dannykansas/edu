eval "$(/opt/homebrew/bin/brew shellenv)"

# github-safe auth (doesn't leak account ID) to ECR
_ecr_login(){
  docker login -u AWS -p $(aws ecr get-login-password) https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-west-2.amazonaws.com
}

# Add devtools to $PATH
export PATH="/opt/devtools:$PATH"

#add key to ssh-agent if not already present
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/id_rsa  | awk '{print $2}'` || ssh-add -K ~/.ssh/id_rsa 

