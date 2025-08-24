# Zplug plugins

# For Linux
if [[ $(uname) == "Linux" ]]; then
  export ZPLUG_HOME=$HOME/.zplug
  export NVM_DIR="${HOME}/.nvm"
# For M1 
elif [[ $(uname -p) == "arm" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export ZPLUG_HOME=/opt/homebrew/opt/zplug
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# For Intel
elif [[ $(uname) == "Darwin" ]]; then
  export ZPLUG_HOME=/usr/local/opt/zplug
fi

source $ZPLUG_HOME/init.zsh

zplug "dracula/zsh", as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

if zplug check || zplug install; then
  zplug load
fi

source $HOME/.zshrc_aliases

# Set env variables for utilities
export KUBECONFIG=$HOME/.kube/config
export K9SCONFIG=$HOME/.config/k9s
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=nvim

# Generated for envman. Do not edit. Loads k9s
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME=~/.pnpm/store
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Enable shell_history in IEx
export ERL_AFLAGS="-kernel shell_history enabled"

# Check if pyenv is installed
if command -v pyenv 1>/dev/null 2>&1; then
  # Add pyenv init to shell
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# Check if direnv is installed
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Update PATH for pipx packages
export PATH="$PATH:$HOME/.local/bin"

# Update PATH for the Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi
if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi

# Update PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

if [ -f "$HOME/.work_zshrc" ]; then source "$HOME/.work_zshrc"; fi
if [ -f "$HOME/.env_zshrc" ]; then source "$HOME/.env_zshrc"; fi

