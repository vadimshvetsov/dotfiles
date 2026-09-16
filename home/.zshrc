# Dedupe PATH and fpath automatically. Keeps repeated exports harmless.
typeset -U path fpath PATH FPATH

# Set env variables early so later blocks can use them.
export XDG_CONFIG_HOME=$HOME/.config
export KUBECONFIG=$HOME/.kube/config
export K9SCONFIG=$XDG_CONFIG_HOME/k9s
export EDITOR=nvim
export ERL_AFLAGS="-kernel shell_history enabled"

# Platform setup
if [[ $OSTYPE == linux* ]]; then
  export ZPLUG_HOME=$HOME/.zplug
  export NVM_DIR=$HOME/.nvm
else
  if [[ -x /opt/homebrew/bin/brew ]]; then
    # Inlined `brew shellenv` output. The eval costs ~40ms per shell.
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
    export HOMEBREW_REPOSITORY=/opt/homebrew
    path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
    fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
    manpath=(/opt/homebrew/share/man $manpath)
    infopath=(/opt/homebrew/share/info $infopath)
    export ZPLUG_HOME=/opt/homebrew/opt/zplug
  else
    export ZPLUG_HOME=/usr/local/opt/zplug
  fi
  export NVM_DIR=$XDG_CONFIG_HOME/nvm
fi

# Zplug plugins
source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

# `zplug check` runs git and awk on every start. Only re-check when this file
# changes, which is the only time the plugin list can change.
_zplug_stamp=$HOME/.cache/zsh/zplug-checked
if [[ ! -f $_zplug_stamp || ${(%):-%N} -nt $_zplug_stamp ]]; then
  if zplug check || zplug install; then
    mkdir -p ${_zplug_stamp:h} && touch $_zplug_stamp
  fi
fi
unset _zplug_stamp
zplug load

source $HOME/.zshrc_aliases

# nvm: sourcing nvm.sh costs ~850ms, so put the default version on PATH and load
# the real nvm only when a command needs it.
if [[ -s $NVM_DIR/nvm.sh ]]; then
  _nvm_default=default
  # Follow the alias chain, for example default -> lts/* -> lts/krypton -> v24.x
  while [[ -r $NVM_DIR/alias/$_nvm_default ]]; do
    _nvm_default=$(<$NVM_DIR/alias/$_nvm_default)
  done
  if [[ -d $NVM_DIR/versions/node/$_nvm_default/bin ]]; then
    path=($NVM_DIR/versions/node/$_nvm_default/bin $path)
  fi
  unset _nvm_default

  nvm() {
    unfunction nvm
    source $NVM_DIR/nvm.sh
    [[ -s $NVM_DIR/bash_completion ]] && source $NVM_DIR/bash_completion
    nvm "$@"
  }
fi

# pnpm
export PNPM_HOME=$HOME/.pnpm/store
path=($PNPM_HOME $path)

# pipx packages
path=($path $HOME/.local/bin)

if [ -f "$HOME/.work_zshrc" ]; then source "$HOME/.work_zshrc"; fi
if [ -f "$HOME/.home_zshrc" ]; then source "$HOME/.home_zshrc"; fi

export OPENCODE_ENABLE_EXA=1
export CLAUDE_CODE_USE_KEYCHAIN=false
