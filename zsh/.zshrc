# shellcheck disable=SC1090,SC1091,SC2034,SC2086,SC2128,SC2155,SC2164,SC2206,SC2296

source $ZDOTDIR/config/options.zsh
source $ZDOTDIR/config/completion.zsh
source $ZDOTDIR/config/vi-mode.zsh
source $ZDOTDIR/config/aliases.zsh
source $ZDOTDIR/config/plugins.zsh
source $ZDOTDIR/config/hooks.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
