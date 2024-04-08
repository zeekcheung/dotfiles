# shellcheck disable=SC1091,SC1094,SC2086

source $ZDOTDIR/config/options.zsh
source $ZDOTDIR/config/completion.zsh
source $ZDOTDIR/config/vi-mode.zsh
source $ZDOTDIR/config/aliases.zsh
source $ZDOTDIR/config/plugins.zsh
source $ZDOTDIR/config/hooks.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
