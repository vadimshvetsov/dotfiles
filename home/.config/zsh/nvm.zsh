# Prefer the standard location, while preserving explicit and older XDG setups.
if [[ -z ${NVM_DIR:-} ]]; then
  if [[ -s $HOME/.nvm/nvm.sh ]]; then
    export NVM_DIR=$HOME/.nvm
  else
    export NVM_DIR=$XDG_CONFIG_HOME/nvm
  fi
fi

if [[ -s $NVM_DIR/nvm.sh ]]; then
  # Resolve the common default aliases without sourcing nvm on every shell start.
  _zsh_nvm_version=default
  typeset -a _zsh_nvm_seen _zsh_nvm_versions
  _zsh_nvm_seen=()
  while [[ -r $NVM_DIR/alias/$_zsh_nvm_version ]]; do
    if (( ${_zsh_nvm_seen[(Ie)$_zsh_nvm_version]} || ${#_zsh_nvm_seen} >= 16 )); then
      _zsh_nvm_version=""
      break
    fi
    _zsh_nvm_seen+=("$_zsh_nvm_version")
    _zsh_nvm_version=$(<"$NVM_DIR/alias/$_zsh_nvm_version")
  done
  case $_zsh_nvm_version in
    node|stable)
      _zsh_nvm_versions=("$NVM_DIR"/versions/node/v*(N/n)) ;;
    <->|<->.<->|v<->|v<->.<->)
      _zsh_nvm_pattern="v${_zsh_nvm_version#v}.*"
      _zsh_nvm_versions=("$NVM_DIR"/versions/node/${~_zsh_nvm_pattern}(N/n)) ;;
    <->.<->.<->|v<->.<->.<->)
      _zsh_nvm_versions=("$NVM_DIR"/versions/node/v${_zsh_nvm_version#v}(N/)) ;;
  esac
  if (( ${#_zsh_nvm_versions} )); then
    path=("$_zsh_nvm_versions[-1]/bin" $path)
  fi
  unset _zsh_nvm_version _zsh_nvm_seen _zsh_nvm_versions _zsh_nvm_pattern

  nvm() {
    unfunction nvm
    source "$NVM_DIR/nvm.sh"
    [[ -s $NVM_DIR/bash_completion ]] && source "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi
