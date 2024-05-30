# shellcheck disable=SC1091,SC1094,SC2086

ZDOTDIR=$XDG_CONFIG_HOME/zsh

source $ZDOTDIR/options.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/vi-mode.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/plugins.zsh
source $ZDOTDIR/hooks.zsh

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
