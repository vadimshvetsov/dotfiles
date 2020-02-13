# Zplug plugins

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme

if zplug check || zplug install; then
  zplug load
fi

# Enable shell_history in IEx
export ERL_AFLAGS="-kernel shell_history enabled"

# Temp fix with hyper terminal showing % (percent sign) on first tab
# https://github.com/zeit/hyper/issues/2144
unsetopt PROMPT_SP
