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

# OpenClaw completion (cached for speed)
_openclaw_cache="${ZDOTDIR}/.openclaw-completion.zsh"
if [[ ! -f "$_openclaw_cache" ]] || [[ "$(which openclaw)" -nt "$_openclaw_cache" ]]; then
  openclaw completion --shell zsh > "$_openclaw_cache" 2>/dev/null
fi
[[ -f "$_openclaw_cache" ]] && source "$_openclaw_cache"
unset _openclaw_cache

# disable
compdef _files uv
