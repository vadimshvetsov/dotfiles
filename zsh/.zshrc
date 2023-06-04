# Zplug plugins

# For Linux
if [[ $(uname) == "Linux" ]]; then
  export ZPLUG_HOME=$HOME/.zplug
  export KUBECONFIG=$HOME/.kube/config
  export K9SCONFIG=$HOME/.config/k9s
  export XDG_CONFIG_HOME=$HOME/.config
# For M1 
elif [[ $(uname -p) == "arm" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export ZPLUG_HOME=/opt/homebrew/opt/zplug
  export PATH="$PATH:$HOME/Library/Python/3.9/bin"
# For Intel
elif [[ $(uname) == "Darwin" ]]; then
  export ZPLUG_HOME=/usr/local/opt/zplug
fi

source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

if zplug check || zplug install; then
  zplug load
fi

# Set default editor for k9s and other utilities
export EDITOR=nvim

# Generated for envman. Do not edit. Loads k9s
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Load NVM and Node
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Enable shell_history in IEx
export ERL_AFLAGS="-kernel shell_history enabled"

# Update PATH for Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi

if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi

if [ -f "$HOME/.work_zshrc" ]; then source "$HOME/.work_zshrc"; fi

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/home/vadim/yandex-cloud/path.bash.inc' ]; then source '/home/vadim/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/vadim/yandex-cloud/completion.zsh.inc' ]; then source '/home/vadim/yandex-cloud/completion.zsh.inc'; fi
