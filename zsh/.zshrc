# Zplug plugins

# For M1 
eval "$(/opt/homebrew/bin/brew shellenv)"
export ZPLUG_HOME=/opt/homebrew/opt/zplug

# For Intel
# export ZPLUG_HOME=/usr/local/opt/zplug

source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

if zplug check || zplug install; then
  zplug load
fi

# This loads NVM and Node
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Enable shell_history in IEx
export ERL_AFLAGS="-kernel shell_history enabled"

# Temp fix with hyper terminal showing % (percent sign) on first tab
# https://github.com/zeit/hyper/issues/2144
unsetopt PROMPT_SP

# The next line updates PATH for Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi

# The next line enables shell command completion for yc.
if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi
