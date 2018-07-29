# zsh
export ZSH=/Users/Vadim/.oh-my-zsh
ZSH_THEME="dracula"
ZSH_DEFAULT_USER="Vadim"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.bashrc ] && source $HOME/.bashrc
