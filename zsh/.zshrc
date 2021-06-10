# Zplug plugins

export ZPLUG_HOME=/usr/local/opt/zplug
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

# Enable shell_history in IEx
export ERL_AFLAGS="-kernel shell_history enabled"

# Temp fix with hyper terminal showing % (percent sign) on first tab
# https://github.com/zeit/hyper/issues/2144
unsetopt PROMPT_SP

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/Users/vadim/yandex-cloud/path.bash.inc' ]; then source '/Users/vadim/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/Users/vadim/yandex-cloud/completion.zsh.inc' ]; then source '/Users/vadim/yandex-cloud/completion.zsh.inc'; fi

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/Users/v.shvetsov/yandex-cloud/path.bash.inc' ]; then source '/Users/v.shvetsov/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/Users/v.shvetsov/yandex-cloud/completion.zsh.inc' ]; then source '/Users/v.shvetsov/yandex-cloud/completion.zsh.inc'; fi


