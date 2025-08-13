# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zshrc/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


_modules=(
  "modules/01-zinit.zsh"
  "modules/02-env.zsh"
  "modules/03-paths.zsh"
  "modules/04-options.zsh"
  "modules/05-tools.zsh"
  "modules/06-aliases.zsh"
  "modules/07-functions.zsh"
  "modules/08-keys.zsh"
  "modules/09-completion.zsh"
  "modules/10-plugins.zsh"
  "modules/11-ui.zsh"
)

for _f in "${_modules[@]}"; do
  [ -r "$ZDOTDIR/$_f" ] && source "$ZDOTDIR/$_f"
done

unset _modules _f

# To customize prompt, run `p10k configure` or edit ~/.config/zshrc/.p10k.zsh.
[[ ! -f ~/.config/zshrc/.p10k.zsh ]] || source ~/.config/zshrc/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
