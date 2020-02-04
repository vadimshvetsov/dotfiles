# Zplug plugins

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme

if zplug check || zplug install; then
  zplug load
fi


#export ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="dracula"
#plugins=(git zsh-autosuggestions)
#source $ZSH/oh-my-zsh.sh

# [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Temp fix with hyper terminal showing % (percent sign) on first tab
# https://github.com/zeit/hyper/issues/2144
unsetopt PROMPT_SP
