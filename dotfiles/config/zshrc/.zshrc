# Rebuilt 2026-10-16 from captured live zsh settings plus marked historical fallbacks.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for _f in modules/{00-live-settings,01-zinit,02-env,03-paths,04-options,05-tools,06-aliases,07-functions,08-keys,09-completion,10-plugins,11-ui}.zsh; do
  [[ -r "$ZDOTDIR/$_f" ]] && source "$ZDOTDIR/$_f"
done
unset _f
[[ -r "$ZDOTDIR/extensions/beans.zsh" ]] && source "$ZDOTDIR/extensions/beans.zsh"

# Saved functions were already alias-expanded by the original shell.
# Suppress a second alias expansion while loading their definitions.
() {
  setopt localoptions noaliases
  builtin source "$ZDOTDIR/extensions/live-functions.zsh"
}
# Powerlevel10k calls this saved formatter as a math function.
functions -M my_git_formatter
source "$ZDOTDIR/extensions/.p10k.zsh"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
