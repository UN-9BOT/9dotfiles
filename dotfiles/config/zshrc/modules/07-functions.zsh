mdcd() {
  mkdir -p -- "$1" && cd -- "$1" || return
}

# Yazi -> вернуться в выбранный каталог
f() {
  local tmp dir
  tmp="$(mktemp)"
  yazi --cwd-file "$tmp" "$@"

  if [ -s "$tmp" ]; then
    dir="$(<"$tmp")"
    rm -f "$tmp"
    if [ "$dir" != "$PWD" ]; then
      cd -- "$dir" || return
    fi
  else
    rm -f "$tmp"
  fi
}

# my_custom_function() {
#   echo "Hello from custom function!"
#   zle reset-prompt
# }
# zle -N my_custom_function
