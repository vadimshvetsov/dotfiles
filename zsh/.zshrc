# aliases
[ -f $HOME/.aliases ] && source $HOME/.aliases

# zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dracula"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# nvm for Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Loads nvm bash completion
export NODE_BINARY="node"

# rbenv for Ruby
eval "$(rbenv init -)" # Loads ruby from rbenv
export ANSIBLE_COW_SELECTION=random # Shows funny animals during ansible deploy

# jenv for Java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# secret keys
[ -f $HOME/.proling ] && source $HOME/.proling # ProLing keys
[ -f $HOME/.qlean ] && source $HOME/.qlean # Qlean keys

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
