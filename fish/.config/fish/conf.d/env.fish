# Use XDG paths for consolidating configuration locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# language environment
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# man pager
set -gx MANPAGER "sh -c 'col -bx | bat --theme=ansi -l man -p'"
set -gx MANROFFOPT -c

# n/node.js
set -gx N_PREFIX $HOME/.n

# path
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $N_PREFIX/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $XDG_DATA_HOME/nvim/mason/bin
fish_add_path $XDG_DATA_HOME/share/bob/nvim-bin

# fzf
set -gx FZF_DEFAULT_OPTS "
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
