# Homebrew's supported default prefixes cover Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  _zsh_brew_prefix=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  _zsh_brew_prefix=/usr/local
else
  _zsh_brew_prefix=""
fi
if [[ -n $_zsh_brew_prefix ]]; then
  export HOMEBREW_PREFIX=$_zsh_brew_prefix
  export HOMEBREW_CELLAR=$_zsh_brew_prefix/Cellar
  if [[ $_zsh_brew_prefix == /usr/local ]]; then
    export HOMEBREW_REPOSITORY=/usr/local/Homebrew
  else
    export HOMEBREW_REPOSITORY=$_zsh_brew_prefix
  fi
  path=("$_zsh_brew_prefix/bin" "$_zsh_brew_prefix/sbin" $path)
  fpath=("$_zsh_brew_prefix/share/zsh/site-functions" $fpath)
  export MANPATH="$_zsh_brew_prefix/share/man:${MANPATH:-}"
  export INFOPATH="$_zsh_brew_prefix/share/info:${INFOPATH:-}"
fi
unset _zsh_brew_prefix
