eval "$(/opt/homebrew/bin/brew shellenv)"

# Add devtools to $PATH
export PATH="/opt/devtools:$PATH"

#add key to ssh-agent if not already present
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/id_rsa  | awk '{print $2}'` || ssh-add -K ~/.ssh/id_rsa 

