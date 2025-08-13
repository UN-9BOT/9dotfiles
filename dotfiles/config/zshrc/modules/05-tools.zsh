# pyenv init
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
  # https://github.com/pyenv/pyenv#b-set-up-your-shell-environment-for-pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# broot
if [ -r "$HOME/.config/broot/launcher/bash/br" ]; then
  source "$HOME/.config/broot/launcher/bash/br"
fi
