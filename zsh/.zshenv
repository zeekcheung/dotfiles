# shellcheck disable=SC1091,SC2155

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# zsh
export ZDOTDIR=$HOME/.config/zsh
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# default editor
export EDITOR="nvim"
export VISUAL="nvim"

# n
export N_PREFIX=$HOME/.n

# Rust
if [ -d "$HOME/.cargo" ]; then
	. "$HOME/.cargo/env"
fi

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='bat --color=always {}'
--preview-window=right,60%
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"
