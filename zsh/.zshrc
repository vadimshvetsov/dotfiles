# zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dracula"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.bashrc ] && source $HOME/.bashrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
