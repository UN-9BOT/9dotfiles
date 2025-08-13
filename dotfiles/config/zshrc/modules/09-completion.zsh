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

# disable
compdef _files uv
