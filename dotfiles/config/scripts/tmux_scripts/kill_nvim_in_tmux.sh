#!/usr/bin/env bash

set -euo pipefail

# Закрыть Neovim во всех панелях tmux, где он активный процесс.
# Для nvim: сначала гарантированно выйти в Normal режим, затем :qa!<CR>.
while IFS= read -r pane_id; do
  tmux send-keys -t "$pane_id" C-\\ C-n :qa\! Enter
done < <(tmux list-panes -a -F '#{pane_id} #{pane_current_command}' | awk '$2=="nvim"{print $1}')
