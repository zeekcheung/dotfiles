# shellcheck disable=SC1091,SC2155

# xdg
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# zsh
export ZDOTDIR=$HOME/.config/zsh
HISTFILE=$XDG_DATA_HOME/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# path
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$N_PREFIX/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/share/nvim/mason/bin:$PATH

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# default editor
export EDITOR="nvim"
export VISUAL="nvim"

# n
export N_PREFIX=$HOME/.n

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

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
