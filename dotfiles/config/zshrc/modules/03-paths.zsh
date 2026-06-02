# pipx/bin
path=("$HOME/.local/bin" $path)

# pyenv
if [ -d "$PYENV_ROOT/bin" ]; then
  path=("$PYENV_ROOT/bin" $path)
fi

# bun
export PATH="/home/unbot/.bun/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"

# go
export PATH="/home/unbot/go/bin:$PATH"

# cargo (rust)
export PATH="/home/unbot/.cargo/bin:$PATH"

# npm
export PATH="$HOME/.npm-global/bin:$PATH"

# bin
export PATH="$HOME/bin:$PATH"
