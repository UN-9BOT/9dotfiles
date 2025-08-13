# pipx/bin
path=("$HOME/.local/bin" $path)

# pyenv
if [ -d "$PYENV_ROOT/bin" ]; then
  path=("$PYENV_ROOT/bin" $path)
fi
