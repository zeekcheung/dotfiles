# shellcheck disable=SC1091,SC2034,SC2155

# xdg
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# zsh
HISTFILE=$XDG_DATA_HOME/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# path
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$N_PREFIX/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH
export PATH=$XDG_DATA_HOME/nvim/mason/bin:$PATH
export PATH=$XDG_DATA_HOME/bob/nvim-bin:$PATH

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# default editor
export EDITOR="nvim"
export VISUAL="nvim"

# man pager
export MANPAGER="sh -c 'col -bx | bat --theme=ansi -l man -p'"
export MANROFFOPT="-c"

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
--preview='fzf-preview {}'
--preview-window=right,60%
--color=fg:#908caa,bg:#232136,hl:#ea9a97
--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
--color=border:#44415a,header:#3e8fb0,gutter:#232136
--color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"
