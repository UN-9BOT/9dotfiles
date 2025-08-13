#!/usr/bin/env bash

# 1) В окне, где все панeли в одном pwd — оставить одну панель.
# 2) В сессии, где несколько окон с одним pwd — оставить одно окно (с минимальным index).

set -euo pipefail

# DRY_RUN=1 bash tmux_dedup.sh  -> только печатает, что бы сделал
DRY_RUN="${DRY_RUN:-0}"

tmux_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "+ tmux $*"
  else
    tmux "$@"
  fi
}

# Проверки
if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux не найден в PATH" >&2
  exit 1
fi

# Если сервер не запущен — list-sessions вернёт ошибку
if ! tmux list-sessions -F '#{session_name}' >/dev/null 2>&1; then
  echo "Нет активных сессий tmux." >&2
  exit 0
fi

# Обход по сессиям
while IFS= read -r session; do
  [[ -z "$session" ]] && continue

  # --- Фаза 1: дедуп панелей в окнах ---
  # Для каждого окна: если все pane в одном пути, убираем лишние
  while IFS= read -r window_id; do
    [[ -z "$window_id" ]] && continue

    # Собираем панели: id, активность, путь
    panes=()
    keep_pane=""
    first_pane=""
    unique_path=""
    same_path=1
    pane_count=0

    while IFS=$'\t' read -r pid pact ppath; do
      panes+=("$pid")
      pane_count=$((pane_count + 1))
      [[ -z "$first_pane" ]] && first_pane="$pid"
      [[ "$pact" == "1" ]] && keep_pane="$pid"
      if [[ -z "$unique_path" ]]; then
        unique_path="$ppath"
      else
        if [[ "$ppath" != "$unique_path" ]]; then
          same_path=0
        fi
      fi
    done < <(tmux list-panes -t "$window_id" -F '#{pane_id}	#{pane_active}	#{pane_current_path}')

    if (( same_path == 1 && pane_count > 1 )); then
      [[ -z "$keep_pane" ]] && keep_pane="$first_pane"
      for pid in "${panes[@]}"; do
        if [[ "$pid" != "$keep_pane" ]]; then
          tmux_cmd kill-pane -t "$pid"
        fi
      done
    fi
  done < <(tmux list-windows -t "$session" -F '#{window_id}')

  # --- Фаза 2: дедуп окон по pwd в сессии ---
  # Берём pwd активной панели каждого окна как "pwd окна"
  declare -A keep_idx_by_path=()
  declare -A keep_id_by_path=()
  declare -a to_kill=()

  # Собираем окна с индексами, сортируем по индексу (оставляем минимальный)
  while IFS=$'\t' read -r wid widx wpath; do
    # Если по пути ещё ничего не сохраняли — сохраняем текущего кандидата
    if [[ -z "${keep_idx_by_path[$wpath]+_}" ]]; then
      keep_idx_by_path["$wpath"]="$widx"
      keep_id_by_path["$wpath"]="$wid"
    else
      prev_idx="${keep_idx_by_path[$wpath]}"
      prev_wid="${keep_id_by_path[$wpath]}"
      if (( widx < prev_idx )); then
        # Текущий лучше (меньше индекс) — помечаем старый на удаление
        to_kill+=("$prev_wid")
        keep_idx_by_path["$wpath"]="$widx"
        keep_id_by_path["$wpath"]="$wid"
      else
        # Текущий хуже — его и удалим
        to_kill+=("$wid")
      fi
    fi
  done < <(tmux list-windows -t "$session" -F '#{window_id}	#{window_index}	#{pane_current_path}' | sort -t$'\t' -k2,2n)

  # Удаляем дубликаты в списке на убийство и убиваем
  if (( ${#to_kill[@]} > 0 )); then
    declare -A seen=()
    for wid in "${to_kill[@]}"; do
      [[ -n "${seen[$wid]+_}" ]] && continue
      seen["$wid"]=1
      tmux_cmd kill-window -t "$wid"
    done
  fi

  # Чистим ассоц. массивы перед следующей сессией
  unset keep_idx_by_path keep_id_by_path to_kill

done < <(tmux list-sessions -F '#{session_name}')
