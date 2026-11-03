# Register plugin helpers even when compinit reuses a dump made before
# zsh-autocomplete was loaded. Existing plugin widgets call these by name.
() {
  local completion_dir="$HOME/.local/share/zinit/plugins/marlonrichert---zsh-autocomplete/Completions"
  [[ -d "$completion_dir" ]] || return 0
  typeset -gU fpath
  fpath=("$completion_dir" $fpath)
  builtin autoload -Uz "$completion_dir"/_autocomplete__*(N-.)
}

# Настройки completion
zstyle ':completion:*' menu select
zstyle ':completion:*:paths' path-completion yes
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Инициализация completion
autoload -Uz compinit
# -C: используем кеш; если сломается — compinit заново с -i
if ! compinit -C; then
  compinit -i
fi

# Load cached OpenClaw completion only when the tool still exists.
if (( $+commands[openclaw] )); then
  _openclaw_cache="${ZDOTDIR}/.openclaw-completion.zsh"
  if [[ ! -s "$_openclaw_cache" || "${commands[openclaw]}" -nt "$_openclaw_cache" ]]; then
    command openclaw completion --shell zsh > "$_openclaw_cache" 2>/dev/null
  fi
  [[ -s "$_openclaw_cache" ]] && source "$_openclaw_cache"
  unset _openclaw_cache
fi

# disable
compdef _files uv
